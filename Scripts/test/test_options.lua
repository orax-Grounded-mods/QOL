---@diagnostic disable: missing-fields
local M = require("lua-mods-libs.options_module")
local items = M.items
---@type Mod_Options_Item
local default = {
    instances = M.instances.getAllInstances(),
    minNumberOfInstancesToFind = 1,
    logLevelForFatalError = "WARN",
    pre = { M.pre.checkPropertyValidity() },
    post = { M.post.checkPropertyValueChange(0.01) },
    reapplyOnModRestart = true,
}

--#region initialize game defaults
local function initGameDefaults()
    print("Init tests.\n")

    local _items = {}

    --#region CharMovementComponent
    ---@type UMaineCharMovementComponent
    _items.CharMovementComponent_init_test = {
        -- Player speed
        MaxWalkSpeed = 350,
        MaxSprintSpeed = 600,
        MaxSwimSpeed = 330,
        MaxSwimSprintSpeed = 500,

        -- Zipline
        ZiplineIgnoreCollisionDistance = 250,
        ZiplineMaxSpeedMultiplier = 2.5,
        ZiplineExitVelocityMultiplier = 0.5,
        ZiplineAscendAccel = 600,
        ZiplineMaxAscendSpeed = 1000
    }
    --#endregion

    local function initGameValues()
        local options = {}

        ---@type ASurvivalPlayerCharacter[]?
        ---@diagnostic disable-next-line: redefined-local
        local instances = FindAllOf("SurvivalPlayerCharacter")
        assert(type(instances) == "table")

        options = _items.CharMovementComponent_init_test

        for _, instance in ipairs(instances) do
            assert(instance:IsValid())
            local charMovementComponent = instance.CharMovementComponent
            assert(charMovementComponent:IsValid())
            for k, v in pairs(options) do
                charMovementComponent[k] = v
            end
        end

        ---@type ABird[]?
        ---@diagnostic disable-next-line: redefined-local
        local instances = FindAllOf("Bird")
        assert(type(instances) == "table")

        options = _items.Bird_init_test

        for _, instance in ipairs(instances) do
            assert(instance:IsValid())
            instance.FlySpeed = 20000
            -- test UScriptStruct LandedTime and TimeBetweenSpawns
            instance.LandedTime.LowerBound.Value = 120
            instance.LandedTime.UpperBound.Value = 300
            instance.TimeBetweenSpawns.LowerBound.Value = 400
            instance.TimeBetweenSpawns.UpperBound.Value = 800
        end


        ---@type UGlobalItemData[]?
        ---@diagnostic disable-next-line: redefined-local
        local instances = FindAllOf("GlobalItemData")
        assert(type(instances) == "table")

        for _, instance in ipairs(instances) do
            assert(instance and instance:IsValid())

            instance.ProcessingData[1].ProcessingTime = 0.25
            instance.ProcessingData[2].ProcessingTime = 8
            instance.ProcessingData[3].ProcessingTime = 1.2
            instance.ProcessingData[4].ProcessingTime = 1
            instance.ProcessingData[5].ProcessingTime = 0.5

            instance.DamageDurabilityThresholds[1] = 10
            instance.DamageDurabilityThresholds[2] = 50

            instance.TotalFireBurnTimeInHours = 5
        end

        ---@type USurvivalGameplayStatics
        ---@diagnostic disable-next-line: assign-type-mismatch
        local survivalGameplayStatics = StaticFindObject("/Script/Maine.Default__SurvivalGameplayStatics")
        local survivalModeManagerComponent = survivalGameplayStatics:GetSurvivalGameModeManager(
            M.UEHelpers.GetGameViewportClient())

        survivalModeManagerComponent.CustomSettings.ResourceRespawnMultiplier = 1
        survivalModeManagerComponent.CustomSettings.CreatureHealthMultiplier = 1

        ---@type ATypeRestrictedStorageBuilding[]?
        ---@diagnostic disable-next-line: redefined-local
        local instances = FindAllOf("TypeRestrictedStorageBuilding")
        assert(type(instances) == "table")

        for _, instance in ipairs(instances) do
            assert(instance:IsValid())
            instance.Capacity = 10
        end
    end

    initGameValues()
end
--#endregion

--#region CharMovementComponent
items:insert({
    id = "_TEST_/Script/Maine.SurvivalPlayerCharacter->CharMovementComponent",
    className = "/Script/Maine.SurvivalPlayerCharacter",
    shortClassName = "SurvivalPlayerCharacter",
    target = "instance.CharMovementComponent",
    enabled = true,
    updateNewObjects = true,
    reapplyOnModRestart = true,
    post = { M.post.checkPropertyValueChange(0.01) },
    instances = M.instances.getAllInstances()
}, {
    -- Player speed
    MaxWalkSpeed = M.MULT(10),  -- 350.0 * 10 = 3500
    MaxSprintSpeed = M.MULT(5), -- 600.0 * 5 = 3000
    MaxSwimSpeed = 330,         -- 330.0
    MaxSwimSprintSpeed = 900,   -- 500.0
} --[[@as ASurvivalPlayerCharacter]], {
    -- Zipline
    -- https://grounded.fandom.com/wiki/Zipline_Anchor
    -- /!\ You might need the "ZIP.R" if it doesn't work.
    ZiplineIgnoreCollisionDistance = M.ADD(5),  -- 250.0 + 5 = 255
    ZiplineMaxSpeedMultiplier = M.SUB(1),       -- 2.5 - 1 = 1.5
    ZiplineExitVelocityMultiplier = M.ADD(0.5), -- 0.5 + 0.5 = 1
    ZiplineAscendAccel = M.DIV(2),              -- 600.0 / 2 = 300
    ZiplineMaxAscendSpeed = 10000               -- 1000.0
} --[[@as ASurvivalPlayerCharacter]])
--#endregion

--#region Bird
items:insert({
    id = "_TEST_/Script/Maine.Bird",
    className = "/Script/Maine.Bird",
    shortClassName = "Bird",
    reapplyOnModRestart = true,
    pre = {},
    instances = M.instances.getAllInstances(),
}, {
    FlySpeed = 12345,
    LandedTime = {
        LowerBound = { Value = M.ADD(30) }, -- 120.0 + 30 = 150
        UpperBound = { Value = M.MULT(2) }  -- 300.0 * 2 = 600
    },
    TimeBetweenSpawns = {
        LowerBound = { Value = 500 },
        UpperBound = { Value = 900 }
    },
} --[[@as ABird]])
--#endregion

--#region GlobalItemData
items:insert({
    id = "_TEST_/Script/Maine.GlobalItemData",
    className = "/Script/Maine.GlobalItemData",
    shortClassName = "GlobalItemData",
}, {
    ProcessingData = {
        { -- [0] 0x0
            ProcessingTime = 111
        },
        { -- [1] 0x28
            ProcessingTime = 222
        }
        ,
        { -- [2] 0x50
            -- do nothing
        },
        { -- [3] 0x78
            ProcessingTime = 333
        },
        { -- [4] 0xA0
            ProcessingTime = 444
        }
    },
    DamageDurabilityThresholds = M.IMPORT_TEXT("(123.750000,456.95000)")
} --[[@as UGlobalItemData]])
--#endregion

--#region GlobalItemData
items:insert({
    id = "_TEST_2_/Script/Maine.GlobalItemData",
    className = "/Script/Maine.Default__SurvivalGameplayStatics",
    target = [[instance:GetGlobalItemData()]],
    instances = M.instances.getStaticObject(),
    reapplyOnModRestart = true,
}, {
    TotalFireBurnTimeInHours = 10
} --[[@as UGlobalItemData]])
--#endregion

--#region SurvivalModeManagerComponent
-- test "target" as a string
items:insert({
    id = "_TEST_/Script/Maine.Default__SurvivalGameplayStatics->SurvivalModeManagerComponent",
    className = "/Script/Maine.Default__SurvivalGameplayStatics",
    target = [[instance:GetSurvivalGameModeManager(UEHelpers.GetGameViewportClient())]],
    targetVars = { UEHelpers = M.UEHelpers },
    instances = M.instances.getStaticObject(),
    post = { M.post.checkPropertyValueChange(0.001) },
}, {
    CustomSettings = { ResourceRespawnMultiplier = 1.75 }
} --[[@as USurvivalModeManagerComponent]])
--#endregion

--#region SurvivalGameModeManager
-- test "target" as a function
items:insert({
    id = "_TEST_2_/Script/Maine.Default__SurvivalGameplayStatics->SurvivalGameModeManager",
    className = "/Script/Maine.Default__SurvivalGameplayStatics",
    target = function(instance, UEHelpers) ---@cast instance USurvivalGameplayStatics
        return instance:GetSurvivalGameModeManager(UEHelpers.GetGameViewportClient())
    end,
    targetVars = { M.UEHelpers },
    instances = M.instances.getStaticObject(),
}, {
    CustomSettings = { CreatureHealthMultiplier = 2.5 }
} --[[@as USurvivalModeManagerComponent]])
--#endregion

--#region Storage
-- test with filters
--[[
    Log storage
]]
items:insert({
    id = "_TEST_/Script/Maine.TypeRestrictedStorageBuilding__BP_LogStorage_C",
    className = "/Script/Maine.TypeRestrictedStorageBuilding",
    shortClassName = "TypeRestrictedStorageBuilding",
    filters = { M.filters.isA("/Game/Blueprints/Items/Buildings/Storage/BP_LogStorage.BP_LogStorage_C") },
}, {
    Capacity = 111
} --[[@as ATypeRestrictedStorageBuilding]])

--[[
    Plank storage
]]
items:insert({
    id = "_TEST_/Script/Maine.TypeRestrictedStorageBuilding__BP_PlankStorage_C",
    className = "/Script/Maine.TypeRestrictedStorageBuilding",
    shortClassName = "TypeRestrictedStorageBuilding",
    filters = { M.filters.isA("/Game/Blueprints/Items/Buildings/Storage/BP_PlankStorage.BP_PlankStorage_C") },
}, {
    Capacity = 222
} --[[@as ATypeRestrictedStorageBuilding]])
--#endregion

return { ---@type Mod_Options
    items = items,
    default = default,
    loader = function(injectedFunc)
        if M.getPlayerController() then
            initGameDefaults() -- initialize game default values if player is already spawned
            injectedFunc()
            return
        end

        local preId, postId
        preId, postId = RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
            UnregisterHook("/Script/Engine.PlayerController:ClientRestart", preId, postId)
            ExecuteWithDelay(1000, function()
                initGameDefaults() -- initialize game default values when player spawn/respawn
                injectedFunc()
            end)
        end)
    end
}
