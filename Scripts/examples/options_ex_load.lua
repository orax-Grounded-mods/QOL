---@diagnostic disable: missing-fields, unused-local
local M = require("lua-mods-libs.options_module")
local items = M.items
local default = {}

--#region "/Script/Maine.GlobalItemData"
-- The mod will get all instances of GlobalItemData and
-- will ensure that those instances inherit from "/Script/Maine.GlobalItemData".
items:insert({
    id = "/Script/Maine.GlobalItemData",
    className = "/Script/Maine.GlobalItemData",
    shortClassName = "GlobalItemData",
    instances = M.instances.getAllInstances(),
    reapplyOnModRestart = true,
}, {

    --[[
    /!\ Advanced example. You probably do not need to do this kind of things. /!\

    This example load a chunk with the "load" Lua function. See: https://www.lua.org/manual/5.4/manual.html#pdf-load
    In the chunk, there are special local variables:
    - instance: the current object instance;
    - property: the name of the property;
    ]]

    -- The LOAD function will return the property AttackDurability + 1.
    -- AttackDurability will be incremented by 1.
    AttackDurability = M.LOAD([[
        print(string.format("[EX] Set %q + 1", property))
        print(string.format("[EX] %s + 1 = %s", instance[property], instance[property] + 1))
        return instance[property] + 1
    ]]),

    -- BlockDurability will have a random value from 1 to 100.
    BlockDurability = M.LOAD(
        [[print("[EX] BlockDurability"); print("[EX] " .. instance[property]); instance[property] = math.random(1, 100); print("[EX] " .. instance[property])]]),

    -- This function will just print the value of the ThrowDurability property,
    -- but the value will not be modified.
    ThrowDurability = M.LOAD([[print("[EX] " .. property .. " = " .. instance[property])]]),

    -- You can also create a function instead of using "load".
    -- This function will just print the value of the ArmorHitDurability property,
    -- but the value will not be modified.
    ArmorHitDurability = function(...) ---@diagnostic disable-line: assign-type-mismatch
        local instance, property = ...
        print(print("[EX] ArmorHitDurability = " .. instance["ArmorHitDurability"]))
    end,
} --[[@as UGlobalItemData]])
--#endregion

return { ---@type Mod_Options
    items = items,
    default = default,
    loader = M.loaders._ifPCExists_or_onPCRestart()
}
