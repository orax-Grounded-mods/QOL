---@diagnostic disable: missing-fields, unused-local
local M = require("lua-mods-libs.options_module")
local items = M.items
local default = {}

--#region /Script/Maine.SurvivalPlayerCharacter
--[[
    EXAMPLE JumpMaxCount
]]

--[[
    With this example, the mod will find all instances of SurvivalPlayerCharacter.
    For each instance found, the value of the JumpMaxCount property will set to 10.
    In concrete, the players should jump 10 times instead of just once.
    This might not work in multiplayer mode!

    The function below (example_JumpMaxCount) is an example that can do an equivalent thing.
]]
items:insert({
    id = "EXAMPLE_SurvivalPlayerCharacter",
    className = "/Script/Maine.SurvivalPlayerCharacter",
    shortClassName = "SurvivalPlayerCharacter",
    instances = M.instances.getAllInstances(),
    reapplyOnModRestart = true,
}, {
    JumpMaxCount = 10
} --[[@as ASurvivalPlayerCharacter]])

--#endregion

-- NOTES: this function is not executed.
-- It just helps to understand what the "JumpMaxCount" example1 in that options file does.
---@diagnostic disable-next-line: unused-function
local function example_JumpMaxCount()
    -- find all non-default instances of "SurvivalPlayerCharacter"
    ---@type ASurvivalPlayerCharacter[]?
    local instancesOfSurvivalPlayerCharacter = FindAllOf("SurvivalPlayerCharacter")
    assert(type(instancesOfSurvivalPlayerCharacter) == "table")

    -- for each instance of SurvivalPlayerCharacter...
    for index, instance in ipairs(instancesOfSurvivalPlayerCharacter) do
        -- ensure that the instance inherits from the expected class
        if instance:IsA("/Script/Maine.SurvivalPlayerCharacter") then
            -- change the value of the JumpMaxCount property to 10
            instance.JumpMaxCount = 10
        end
    end
end

return { ---@type Mod_Options
    items = items,
    default = default,
    loader = M.loaders._ifPCExists_or_onPCRestart()
}
