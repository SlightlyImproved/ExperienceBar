-- Slightly Improved™ Experience Bar
-- The MIT License © 2019 Arthur Corenzan
-- FreeBSD License © 2014 Kevin Douglas

local NAMESPACE = "SlightlyImprovedExperienceBar"

local settings = {}

local panel =
{
    type = "panel",
    name = "Slightly Improved™ Experience Bar",
    displayName = "Slightly Improved™ Experience Bar",
    author = nil,
    version = nil,
}

local options =
{
    {
        type = "dropdown",
        name = "Visibility",
        tooltip = "Controls the visibility of the Experience Bar. When set to automatic the Experience Bar will only appear in useful situations like when you level up or in the inventory screen.",
        choices = {"Automatic", "Always Show"},
        getFunc = function() return settings.visibility end,
        setFunc = function(value) settings.visibility = value end,
        -- requiresReload = true,
    },
}

CALLBACK_MANAGER:RegisterCallback(NAMESPACE.."_OnAddOnLoaded", function(savedVars)
    settings = savedVars

    local LAM = LibAddonMenu2 or LibStub("LibAddonMenu-2.0")
    LAM:RegisterAddonPanel(NAMESPACE, panel)
    LAM:RegisterOptionControls(NAMESPACE, options)
end)
