---@diagnostic disable: missing-fields, unused-local, unused-function
local M = require("lua-mods-libs.options_module")
local items = M.items
local default = {}

--[[
    The "pre" and "post" functions receive these arguments: instance, key, value, item.
]]

-- example functions
-- This example function prints received arguments.
local function example1(instance, property, value, item)
    print("[EX] Pre function 1: ", instance, property, value, item, "\n")
end

-- This example is an equivalent of example1.
local function example1_alternative(...)
    print("[EX] Pre function 1 (alt): ", ...)
end

local function example2(instance, property, value, item)
    print("[EX] Pre function 2: " .. property .. " = " .. tostring(instance[property]) .. "\n")
end

--#region /Script/Maine.SurvivalPlayerCharacter.CharMovementComponent

--[[
This example will print something like in the UE4SS.log file (and in the console if activated):

[Lua] Pre function 1: 		UObject: 000001B5E75A1818		MaxWalkSpeed		361.0		table: 000001B65CC42EB0
[Lua] Pre function 2: MaxWalkSpeed = 360.0
[Lua] Post function: MaxWalkSpeed = 361.0
[Lua] Pre function 1: 		UObject: 000001B5E75A1818		MaxSprintSpeed		589.0		table: 000001B65CC42EB0
[Lua] Pre function 2: MaxSprintSpeed = 590.0
[Lua] Post function: MaxSprintSpeed = 589.0
]]

-- The mod will get all instances of SurvivalPlayerCharacter and
-- will ensure that those instances inherit from "/Script/Maine.SurvivalPlayerCharacter".
-- And for each instance found, it will get the CharMovementComponent instance.
items:insert({
    id = "/Script/Maine.SurvivalPlayerCharacter->CharMovementComponent",
    className = "/Script/Maine.SurvivalPlayerCharacter",
    shortClassName = "SurvivalPlayerCharacter",
    target = "instance.CharMovementComponent",
    instances = M.instances.getAllInstances(),
    reapplyOnModRestart = true,

    -- The "pre" functions (example1 and example2) will be executed *before* setting the new property value.
    pre = { example1, example2 },

    -- The "post" function below will be executed *after* setting the new property value.
    post = { function(instance, property, value, item)
        print("[EX] Post function: " .. property .. " = " .. tostring(instance[property]) .. "\n")
    end },
}, {
    MaxWalkSpeed = M.ADD(1),   -- 350.0
    MaxSprintSpeed = M.SUB(1), -- 600.0
} --[[@as UMaineCharMovementComponent]])

--#endregion

return { ---@type Mod_Options
    items = items,
    default = default,
    loader = M.loaders._ifPCExists_or_onPCRestart()
}
