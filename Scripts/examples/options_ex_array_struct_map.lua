---@diagnostic disable: missing-fields, unused-local, unused-function
local M = require("lua-mods-libs.options_module")
local items = M.items
local default = {}

--[[
    Modifying an "ArrayProperty" or a "StructProperty" can be done with a Lua table or with IMPORT_TEXT.
    Modifying an "MapProperty" can be done with IMPORT_TEXT.
]]

--#region /Script/Maine.Bird
items:insert({
    id = "/Script/Maine.Bird",
    className = "/Script/Maine.Bird",
    shortClassName = "Bird",
    instances = M.instances.getAllInstances(),
    reapplyOnModRestart = true,
}, {
    -- In the "Bird" instance, you can see that "LandedTime" is a "StructProperty".
    LandedTime = {
        LowerBound = { Value = M.ADD(1) }, -- "LandedTime.LowerBound.Value" will be set to "LandedTime.LowerBound.Value + 1"
        UpperBound = { Value = M.MULT(2) } -- "LandedTime.UpperBound.Value" will be set to "LandedTime.UpperBound.Value * 2"
    },
    TimeBetweenSpawns = {
        LowerBound = { Value = 456 }, -- "TimeBetweenSpawns.LowerBound.Value" will be set to 456
        UpperBound = { Value = 800 }
    }
} --[[@as ABird]])
--#endregion

--#region "/Script/Maine.GlobalItemData"
items:insert({
    id = "/Script/Maine.GlobalItemData",
    className = "/Script/Maine.GlobalItemData",
    shortClassName = "GlobalItemData",
    instances = M.instances.getAllInstances(),
    reapplyOnModRestart = true,
}, {
    -- "ProcessingData" is an "ArrayProperty".
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
    -- You can do something equivalent with IMPORT_TEXT. For example:
    --ProcessingData = IMPORT_TEXT(
    --    [[((ProcessingTag=(TagName="ItemProcessing.Cooking"),DamageType=4096,ProcessingTime=111,bAllowPlayerRemoval=False),(ProcessingTag=(TagName="ItemProcessing.Drying"),DamageType=2048,ProcessingTime=222.000000,bAllowPlayerRemoval=False),(ProcessingTag=(TagName="ItemProcessing.Spinning"),ProcessingTime=1.200000,bAllowPlayerRemoval=False),(ProcessingTag=(TagName="ItemProcessing.Smelting"),bAllowPlayerRemoval=False),(ProcessingTag=(TagName="ItemProcessing.Refining"),ProcessingTime=0.500000,bAllowPlayerRemoval=False))]]),

    -- "DamageDurabilityThresholds" is an "ArrayProperty".
    DamageDurabilityThresholds = {
        123,
        456
    },
    -- You can do something equivalent with IMPORT_TEXT. For example:
    -- DamageDurabilityThresholds = IMPORT_TEXT("(123.000000,456.000000)"),

    -- "StackSizes" is a "MapProperty".
    -- Actually, in UE4SS 3.0.1, the property type "MapProperty" is not supported.
    -- But you can use "IMPORT_TEXT" to change the property value.
    StackSizes = M.IMPORT_TEXT(
        [[(((TagName="StackSize.Default"), 123),((TagName="StackSize.Ammo"), 456),((TagName="StackSize.Single"), 1),((TagName="StackSize.Food"), 789),((TagName="StackSize.Resource"), 10),((TagName="StackSize.LargeResource"), 5),((TagName="StackSize.UpgradeStones"), 99))]]),
} --[[@as UGlobalItemData]])
--#endregion

return { ---@type Mod_Options
    items = items,
    default = default,
    loader = M.loaders._ifPCExists_or_onPCRestart()
}
