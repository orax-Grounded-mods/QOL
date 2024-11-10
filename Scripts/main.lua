local utils = require("lua-mods-libs.utils")
local logging = require("lua-mods-libs.logging")

local string, table, pairs, ipairs, type = string, table, pairs, ipairs, type

local config = utils.loadConfig()
local log = __LOGGER or logging.new(config.LOG_LEVEL, config.MIN_LEVEL_OF_FATAL_ERROR)

__CONFIG = config
__LOGGER = log

local WARN = "(!) "

---@param instance UObject
---@param name string
---@param value any
---@param item Mod_Options_Item
---@param path? string
local function set(instance, name, value, item, path)
    -- The variable "path" can be more descriptive than "property".
    -- "name" is just the name of the property.
    -- "path" is only useful for logging.
    -- For example, with the option:
    --   CharMovementComponent = { MaxWalkSpeed = 350 }
    -- The variables will be:
    -- "name" => MaxWalkSpeed
    -- "path" => CharMovementComponent.MaxWalkSpeed
    path = path or name

    if not instance:IsValid() then
        log.error("Instance is not valid. Property: %q. Item ID: %q.", path, item.id)
        return
    end

    -- In some cases, the value may be nil.
    -- For example, the IMPORT_TEXT function changes the game value and returns nil.
    if value == nil then
        log.debug("Value is nil. Property: %q. Item ID: %q.", path, item.id)
    end

    -- If the property value in the game is almost equal (≈) to the property value
    -- in the option file, then the property value in game remains unchanged.
    if value ~= nil and utils.checkEquality(instance[name], value, item.epsilon) then
        log.trace(WARN .. "The property value in the game is the same (%s = %s). Epsilon = %g.",
            instance[name], value, item.epsilon)

        return
    end

    -- call "pre" function
    for i, func in ipairs(item.pre) do
        log.trace([[Running "pre" function %i/%i.]], i, #item.pre)
        local ret = func(instance, name, value, item)
        log.trace([[The "pre" function returned: ]] .. tostring(ret))
    end

    if value ~= nil then
        log.trace([[-> Set "%s" = "%s". Old = "%s".]], path, value, instance[name])
        instance[name] = value -- set the new value
    end

    -- call "post" function
    for i, func in ipairs(item.post) do
        log.trace([[Running "post" function %i/%i.]], i, #item.post)
        local ret = func(instance, name, value, item)
        log.trace([[The "post" function returned: ]] .. tostring(ret))
    end
end

---Update/patch nested instances/objects.
---@param instance UObject
---@param list table
---@param item Mod_Options_Item
---@param path string?
local function patchNested(instance, list, item, path)
    ---@param name string
    ---@param data function|table
    for name, data in pairs(list) do
        local dataType = type(data)

        -- The variable "path" is only useful for logging.
        -- For example, with the option: CharMovementComponent = { MaxWalkSpeed = 350 }
        -- the path will be: "CharMovementComponent.MaxWalkSpeed".
        path = path .. "." .. name
        log.trace("Property: %q; type: %q.", path, dataType)

        if dataType == "table" then
            patchNested(instance[name], data, item, path)
        else
            if dataType == "function" then
                log.debug("Executing function in %q.", name)
                data = data(instance, name) -- run the "option function"
            end

            if data ~= nil then
                -- set new value
                set(instance, name, data, item, path)
            end
        end

        path = string.gsub(path, "%.[^%.]+$", "")
    end
end

---@param variables table
---@param instance UObject
---@return string
---@return table
local function parseVariables(variables, instance)
    local varNames = {}
    local varValues = {}
    local varNamesStr = ""

    -- add current instance
    table.insert(varNames, "instance")
    table.insert(varValues, instance)

    for k, v in pairs(variables) do
        table.insert(varNames, k)
        table.insert(varValues, v)
    end

    for _, value in ipairs(varNames) do
        varNamesStr = varNamesStr .. value .. ","
    end

    -- remove last ","
    varNamesStr = string.sub(varNamesStr, 1, -2)

    return varNamesStr, varValues
end

---@param instance UObject
---@param item Mod_Options_Item
---@return UObject
local function getTargetInstance(instance, item)
    --[[
    If target is a function, targetVars is a list of arguments (arg1, arg2, ..., argN].
    Example:
        targetVars = { M.UEHelpers, "my var", 123 }
    And the target function could be:
        target = function(instance, UEHelpersLib, myStringVar, myNumberVar)
            local viewport = UEHelpersLib.GetGameViewportClient()
            print(myStringVar) -- print "my var"
            print(myNumberVar) -- print "123"
        end

    If target is a string, targetVars is table of var_name with=var_value.
    Example (myStringVar and myNumberVar are not used, it is just for example):
        targetVars = { UEHelpersLib = M.UEHelpers, myStringVar = "my var", myNumberVar = 123 }
    And the target string could be:
        target = "instance:GetSurvivalGameModeManager(UEHelpersLib.GetGameViewportClient())"
    ]]
    -- run the target if it is a function
    if type(item.target) == "function" then
        return item.target(instance, table.unpack(item.targetVars))
    end

    -- evaluate the target if it is a string
    if type(item.target) == "string" and item.target ~= "" then
        -- parse injected variables if any; the instance is automatically added to them
        local varNamesStr, varValues = parseVariables(item.targetVars, instance)

        local targetString = "local " .. varNamesStr .. " = ...; return " .. item.target
        log.debug("Evaluating target: " .. targetString)

        local f, err = load(targetString)
        if f then
            return f(table.unpack(varValues))
        else
            log.error(err)
            return CreateInvalidObject()
        end
    end

    -- else, just return the original instance
    return instance
end

---Update/patch an instance.
---@param instance UObject
---@param item Mod_Options_Item
local function patch(instance, item)
    if not instance:IsValid() then
        log.error("Instance is not valid. Item id: %q.", item.id)
        return
    end

    for i, filter in ipairs(item.filters) do
        local result = filter(instance, item)
        assert(type(result) == "boolean")

        if result == false then
            log.debug(WARN .. "Instance excluded by the filter function n°%i/%i.", i, #item.filters)
            return
        end
    end

    -- replace the current instance by the targeted instance if exists
    local targetInstance = getTargetInstance(instance, item)
    if targetInstance:IsValid() then
        instance = targetInstance
    else
        log.error("Target instance is not valid.")
        return
    end

    log.debug("Patching instance: %q.", instance:GetFullName())

    for _, list in ipairs(item) do
        for name, data in pairs(list) do
            local dataType = type(data)

            log.trace("Property: %q; type: %q.", name, dataType)

            if dataType == "function" then
                log.debug("Executing function in %q.", name)
                data = data(instance, name) -- run the "option function"
            end
            if dataType == "table" then
                patchNested(instance[name], data, item, name)
            else
                -- set new value
                set(instance, name, data, item)
            end
        end
    end
end

---Update/patch a newly created instance.
---@param instance UObject
---@param items Mod_Options_Item[]
local function update(instance, items)
    for index, item in ipairs(items) do
        log.debug("Updating item %i/%i %q.", index, #items, item.id)
        patch(instance, item)
    end
end

---Create functions invoked by NotifyOnNewObject to update/patch newly created object instances.
---@param items Mod_Options_Item[]
local function createFuncToUpdateNewObjects(items)
    local itemsByClassName = {}

    -- create a list of items indexed by class name
    -- We can have multiple items for a single class name.
    for itemIndex, item in ipairs(items) do
        if item.updateNewObjects == true then
            itemsByClassName[item.className] = itemsByClassName[item.className] or {}
            itemsByClassName[item.className][itemIndex] = item
        end
    end

    -- create a update function for each class name in the list
    -- "update" function will be executed for new instances of className and will update/patch them.
    for className, itemsToUpdate in pairs(itemsByClassName) do
        log.debug("NotifyOnNewObject %q.", className)
        ---@diagnostic disable-next-line: redundant-parameter
        NotifyOnNewObject(className, function(instance)
            log.debug("Running NotifyOnNewObject %q %q.", className, instance:GetFullName())
            ExecuteWithDelay(1000, function()
                update(instance, itemsToUpdate)
            end)
        end)
    end
end

---Get enabled items in options file.
---@param options Mod_Options
---@return Mod_Options_Item[]
local function getEnabledItems(options)
    local enabledItems = {}

    for index, item in ipairs(options.items) do
        if item.enabled then
            log.debug("Item enabled n°%i %q.", index, item.id)
            table.insert(enabledItems, item)
        else
            log.debug("Item not enabled n°%i %q.", index, item.id)
        end
    end

    return enabledItems
end

---Set that the mod is started in a shared variable.
local function setModStarted()
    ModRef:SetSharedVariable(utils.mod.name, true)
end

---Return true if the mod has been restarted.
local function isModRestarted()
    return ModRef:GetSharedVariable(utils.mod.name)
end

---@param options Mod_Options
local function main(options)
    local items = getEnabledItems(options)

    local oldLogLevel, oldLogLevelForFatalError

    -- patch only enabled items
    for index, item in ipairs(items) do
        -- set logging level if option exists and not false
        if item.logLevel or item.logLevelForFatalError then
            if oldLogLevel ~= item.logLevel or oldLogLevelForFatalError ~= item.logLevelForFatalError then
                log.setLevel(item.logLevel, item.logLevelForFatalError)
                oldLogLevel = item.logLevel
                oldLogLevelForFatalError = item.logLevelForFatalError
            end
        else
            -- reset log level
            log.setLevel()
        end

        -- Reapply changes if mod was restarted?
        if not config.FORCE_REAPPLY_ON_MOD_RESTART and item.reapplyOnModRestart == false and isModRestarted() then
            log.info(utils.mod.name .. " restarted. Item n°%i (%s) ignored.", index, item.id)
            goto continue
        end

        log.info("Processing of item n°%i/%i %q.", index, #items, item.id)

        -- The "instances" field must be a function that returns a table of UObject.
        if type(item.instances) ~= "function" then
            log.error([[Error in the options file "%s" in item %q. ]] ..
                [[The "instances" field is not a function.]], options.file, index)
            goto continue
        end

        -- run the "instances" field function to find instances for this item
        local instances = item:instances()

        -- The "instances" function must return a table of UObject.
        if type(instances) ~= "table" then
            log.error(
                [[Error in the options file "%s" in item %q. ]] ..
                [[The function in the "instances" field returned a %q instead of a "table".]],
                options.file, index, type(instances))
            goto continue
        end
        if #instances < item.minNumberOfInstancesToFind then
            log.warn("The number of instances of %q found (%i) is less than to " ..
                "the minimum number of instances to find (%i).",
                item.shortClassName, #instances, item.minNumberOfInstancesToFind)
        end

        -- patch/update each instance found for this item
        for _, instance in ipairs(instances) do
            patch(instance, item)
        end

        ::continue::
    end

    -- reset log level if has been changed
    if oldLogLevel or oldLogLevelForFatalError then
        log.setLevel()
    end

    createFuncToUpdateNewObjects(items)
end

-- Set that the mod is started in a shared variable.
-- We will need this to know if the mod has been restarted.
setModStarted()

-- get options files
local optionsFiles = utils.parseConfigOptionsFiles(config.OPTIONS_FILES)

-- load options files
for i, optionsFile in ipairs(optionsFiles) do
    log.info([[Loading options file %i/%i "%s".]], i, #optionsFiles, optionsFile)

    local options, errMsg = utils.loadOptions(optionsFile)
    if errMsg ~= nil then log.error(errMsg) end

    if type(options.loader) == "function" then
        log.debug("Running loadFunction.")
        options.loader(function()
            main(options)
        end)
    else
        main(options)
    end
end
