---@diagnostic disable: need-check-nil, duplicate-set-field

_G.Tests = {}

local lu = require("LuaUnit.luaunit")
local utils = require("lua-mods-libs.utils")
local logging = require("lua-mods-libs.logging")
local UEHelpers = require("UEHelpers")

utils.mod = utils.getModInfo()
__CONFIG = utils.loadConfig()
__LOGGER = __LOGGER or logging.new(__CONFIG.LOG_LEVEL, __CONFIG.MIN_LEVEL_OF_FATAL_ERROR) ---@type Mod_Logger

local log = __LOGGER

local expectedOptionsFile, errMsg = utils.loadOptions([[Scripts\test\test_expected_options.lua]])
if errMsg ~= nil then log.error(errMsg) end

print("Expected options file loaded: " .. expectedOptionsFile.file .. "\n")

local expectedItems = {}

for _, item in ipairs(expectedOptionsFile.items) do
    expectedItems[item.id] = item
end

function Tests:test_SurvivalPlayerCharacter_CharMovementComponent()
    local id = "_TEST_/Script/Maine.SurvivalPlayerCharacter->CharMovementComponent"
    log.info(id)

    ---@type ASurvivalPlayerCharacter[]?
    local t = FindAllOf("SurvivalPlayerCharacter")
    local instances = {}

    lu.assertIsTrue(type(t) == "table")
    if not t then return end

    for i, v in ipairs(t) do
        log.debug("Instance to test (%i/%i): %q.", i, #t, v.CharMovementComponent:GetFullName())
        instances[i] = v.CharMovementComponent
    end

    _G.__TestsMod.testOptions(expectedItems,
        id,
        instances)
end

function Tests:test_Bird()
    local id = "_TEST_/Script/Maine.Bird"
    log.info(id)

    ---@type ABird[]?
    local instances = FindAllOf("Bird")

    lu.assertIsTrue(type(instances) == "table")
    if not instances then return end

    local expectedOptions = expectedItems[id]
    lu.assertIsTrue(type(expectedOptions) == "table",
        string.format("The item %q does not exist in the options file.", id))

    expectedOptions = utils.flattenTable(expectedOptions)

    local msg = "Tested key: "

    for i, instance in ipairs(instances) do
        log.debug("Instance to test (%i/%i): %q.", i, #instances, instance:GetFullName())

        lu.assertEquals(instance.FlySpeed,
            expectedOptions.FlySpeed,
            msg .. "FlySpeed")

        lu.assertEquals(instance.LandedTime.LowerBound.Value,
            expectedOptions.LandedTime.LowerBound.Value,
            msg .. "LandedTime.LowerBound")

        lu.assertEquals(instance.LandedTime.UpperBound.Value,
            expectedOptions.LandedTime.UpperBound.Value,
            msg .. "LandedTime.UpperBound")

        lu.assertEquals(instance.TimeBetweenSpawns.LowerBound.Value,
            expectedOptions.TimeBetweenSpawns.LowerBound.Value,
            msg .. "TimeBetweenSpawns.LowerBound")

        lu.assertEquals(instance.TimeBetweenSpawns.UpperBound.Value,
            expectedOptions.TimeBetweenSpawns.UpperBound.Value,
            msg .. "TimeBetweenSpawns.UpperBound")
    end
end

function Tests:test_GlobalItemData()
    local id = "_TEST_/Script/Maine.GlobalItemData"
    log.info(id)

    local instance = FindFirstOf("GlobalItemData")
    lu.assertIsTrue(instance and instance:IsValid())
    log.debug("Instance to test: %q.", instance:GetFullName())

    ---@cast instance UGlobalItemData

    local expectedOptions = expectedItems[id]
    lu.assertIsTrue(type(expectedOptions) == "table",
        string.format("The item %q does not exist in the options file.", id))

    expectedOptions = utils.flattenTable(expectedOptions)

    local msg = "Tested key: "

    lu.assertEquals(instance.ProcessingData[1].ProcessingTime,
        expectedOptions.ProcessingData[1].ProcessingTime,
        msg .. "ProcessingData[1].ProcessingTime")

    lu.assertEquals(instance.ProcessingData[2].ProcessingTime,
        expectedOptions.ProcessingData[2].ProcessingTime,
        msg .. "ProcessingData[2].ProcessingTime")

    -- ProcessingTime n°3 is not modified.

    lu.assertEquals(instance.ProcessingData[4].ProcessingTime,
        expectedOptions.ProcessingData[4].ProcessingTime,
        msg .. "ProcessingData[4].ProcessingTime")

    lu.assertAlmostEquals(instance.DamageDurabilityThresholds[1],
        expectedOptions.DamageDurabilityThresholds[1], 0.01,
        msg .. "DamageDurabilityThresholds[1]")

    lu.assertAlmostEquals(instance.DamageDurabilityThresholds[2],
        expectedOptions.DamageDurabilityThresholds[2], 0.01,
        msg .. "DamageDurabilityThresholds[2]")
end

function Tests:test_GlobalItemData_method_2()
    local id = "_TEST_2_/Script/Maine.GlobalItemData"
    log.info(id)

    local instance = FindFirstOf("GlobalItemData")
    lu.assertIsTrue(instance and instance:IsValid())
    log.debug("Instance to test: %q.", instance:GetFullName())

    ---@cast instance UGlobalItemData

    local expectedOptions = expectedItems[id]
    lu.assertIsTrue(type(expectedOptions) == "table",
        string.format("The item %q does not exist in the options file.", id))

    expectedOptions = utils.flattenTable(expectedOptions)

    local msg = "Tested key: "

    lu.assertEquals(instance.TotalFireBurnTimeInHours,
        expectedOptions.TotalFireBurnTimeInHours,
        msg .. "TotalFireBurnTimeInHours")
end

function Tests:test_SurvivalModeManagerComponent_with_target_as_string()
    local id = "_TEST_/Script/Maine.SurvivalModeManagerComponent->SurvivalModeManagerComponent"
    log.info(id)

    ---@type USurvivalGameplayStatics
    ---@diagnostic disable-next-line: assign-type-mismatch
    local survivalGameplayStatics = StaticFindObject("/Script/Maine.Default__SurvivalGameplayStatics")
    lu.assertIsTrue(survivalGameplayStatics and survivalGameplayStatics:IsValid())

    local instance = survivalGameplayStatics:GetSurvivalGameModeManager(
        UEHelpers.GetGameViewportClient())
    lu.assertIsTrue(instance and instance:IsValid())
    log.debug("Instance to test: %q.", instance:GetFullName())

    local expectedOptions = expectedItems[id]

    lu.assertIsTrue(type(expectedOptions) == "table",
        string.format("The item %q does not exist in the options file.", id))

    expectedOptions = utils.flattenTable(expectedOptions)

    local msg = "Tested key: "

    lu.assertEquals(instance.CustomSettings.ResourceRespawnMultiplier,
        expectedOptions.CustomSettings.ResourceRespawnMultiplier,
        msg .. "CustomSettings.ResourceRespawnMultiplier")
end

function Tests:test_SurvivalModeManagerComponent_with_target_as_function()
    local id = "_TEST_2_/Script/Maine.SurvivalModeManagerComponent->SurvivalModeManagerComponent"
    log.info(id)

    ---@type USurvivalGameplayStatics
    ---@diagnostic disable-next-line: assign-type-mismatch
    local survivalGameplayStatics = StaticFindObject("/Script/Maine.Default__SurvivalGameplayStatics")
    lu.assertIsTrue(survivalGameplayStatics and survivalGameplayStatics:IsValid())

    local instance = survivalGameplayStatics:GetSurvivalGameModeManager(
        UEHelpers.GetGameViewportClient())
    lu.assertIsTrue(instance and instance:IsValid())
    log.debug("Instance to test: %q.", instance:GetFullName())

    local expectedOptions = expectedItems[id]

    lu.assertIsTrue(type(expectedOptions) == "table",
        string.format("The item %q does not exist in the options file.", id))

    expectedOptions = utils.flattenTable(expectedOptions)

    local msg = "Tested key: "

    lu.assertEquals(instance.CustomSettings.CreatureHealthMultiplier,
        expectedOptions.CustomSettings.CreatureHealthMultiplier,
        msg .. "CustomSettings.CreatureHealthMultiplier")
end

function Tests:test_subclass_LogStorage()
    local id = "_TEST_/Script/Maine.TypeRestrictedStorageBuilding_subclass_BP_LogStorage_C"
    log.info(id)

    ---@type ATypeRestrictedStorageBuilding[]?
    local instances = FindAllOf("BP_LogStorage_C")

    lu.assertIsTrue(type(instances) == "table")
    if not instances then return end
    local expectedOptions = expectedItems[id]

    lu.assertIsTrue(type(expectedOptions) == "table",
        string.format("The item %q does not exist in the options file.", id))

    expectedOptions = utils.flattenTable(expectedOptions)

    for i, instance in ipairs(instances) do
        log.debug("Instance to test (%i/%i): %q.", i, #instances, instance:GetFullName())

        lu.assertEquals(instance.Capacity, expectedOptions.Capacity)
    end
end

function Tests:test_subclass_PlankStorage()
    local id = "_TEST_/Script/Maine.TypeRestrictedStorageBuilding_subclass_BP_PlankStorage_C"
    log.info(id)

    ---@type ATypeRestrictedStorageBuilding[]?
    local instances = FindAllOf("BP_PlankStorage_C")

    lu.assertIsTrue(type(instances) == "table")
    if not instances then return end
    local expectedOptions = expectedItems[id]

    lu.assertIsTrue(type(expectedOptions) == "table",
        string.format("The item %q does not exist in the options file.", id))

    expectedOptions = utils.flattenTable(expectedOptions)

    for i, instance in ipairs(instances) do
        log.debug("Instance to test (%i/%i): %q.", i, #instances, instance:GetFullName())

        lu.assertEquals(instance.Capacity, expectedOptions.Capacity)
    end
end

return lu.LuaUnit.run()
