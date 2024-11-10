---@diagnostic disable: missing-fields
local M = require("lua-mods-libs.options_module")
local items = M.items

--#region >CharMovementComponent
items:insert({
    id = "_TEST_/Script/Maine.SurvivalPlayerCharacter->CharMovementComponent",
}, {
    -- Player speed
    MaxWalkSpeed = 3500,      -- 350.0 * 10 = 3500
    MaxSprintSpeed = 3000,    -- 600.0 * 5 = 3000
    MaxSwimSpeed = 330,       -- 330.0
    MaxSwimSprintSpeed = 900, -- 500.0
} --[[@as UMaineCharMovementComponent]], {

    -- Zipline
    ZiplineIgnoreCollisionDistance = 255, -- 250.0 + 5 = 255
    ZiplineMaxSpeedMultiplier = 1.5,      -- 2.5 - 1 = 1.5
    ZiplineExitVelocityMultiplier = 1,    -- 0.5 + 0.5 = 1
    ZiplineAscendAccel = 300,             -- 600.0 / 2 = 300
    ZiplineMaxAscendSpeed = 10000         -- 1000.0
} --[[@as UMaineCharMovementComponent]])

--#endregion

--#region Bird
-- Bird (Crow)
items:insert({
    id = "_TEST_/Script/Maine.Bird",
}, {
    FlySpeed = 12345,                 -- 20000.0
    LandedTime = {
        LowerBound = { Value = 150 }, -- 120.0 + 30 = 150
        UpperBound = { Value = 600 }  -- 300.0 * 2 = 600
    },
    TimeBetweenSpawns = {
        LowerBound = { Value = 500 }, -- 400.0
        UpperBound = { Value = 900 }  -- 800.0
    },
} --[[@as ABird]])
--#endregion

--#region "GlobalItemData"
items:insert({
    id = "_TEST_/Script/Maine.GlobalItemData",
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
        },
    },
    DamageDurabilityThresholds = {
        123.75,
        456.95
    },
} --[[@as UGlobalItemData]])
--#endregion

--#region "GlobalItemData"
items:insert({
    id = "_TEST_2_/Script/Maine.GlobalItemData",
}, {
    TotalFireBurnTimeInHours = 10,
} --[[@as UGlobalItemData]])
--#endregion

--#region "SurvivalModeManagerComponent"
items:insert({
    id = "_TEST_/Script/Maine.SurvivalModeManagerComponent->SurvivalModeManagerComponent",
}, {
    CustomSettings = { ResourceRespawnMultiplier = 1.75, }
} --[[@as USurvivalModeManagerComponent]])
--#endregion

--#region "SurvivalModeManagerComponent"
items:insert({
    id = "_TEST_2_/Script/Maine.SurvivalModeManagerComponent->SurvivalModeManagerComponent",
}, {
    CustomSettings = { CreatureHealthMultiplier = 2.5, }
} --[[@as USurvivalModeManagerComponent]])
--#endregion

--#region Storage
-- Log storage
items:insert({
    id = "_TEST_/Script/Maine.TypeRestrictedStorageBuilding_subclass_BP_LogStorage_C",
}, {
    Capacity = 111,
} --[[@as ATypeRestrictedStorageBuilding]])

-- Plank storage
items:insert({
    id = "_TEST_/Script/Maine.TypeRestrictedStorageBuilding_subclass_BP_PlankStorage_C",
}, {
    Capacity = 222,
} --[[@as ATypeRestrictedStorageBuilding]])
--#endregion

return { default = {}, items = items }
