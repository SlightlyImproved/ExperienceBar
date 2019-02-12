-- Slightly Improved™ Experience Bar
-- The MIT License © 2016 Arthur Corenzan
-- FreeBSD License © 2014 Kevin Douglas

local NAMESPACE = "SlightlyImprovedExperienceBar"

--
--
--



--
--
--

local defaultSavedVars = {
}

CALLBACK_MANAGER:RegisterCallback(NAMESPACE.."_OnAddOnLoaded", function(savedVars)

end)

--
--
--

-- Add-on entrypoint. You should NOT need to edit below this line.
-- Make sure you have set a NAMESPACE variable and you're good to go.
--
-- If you need to hook into the AddOnLoaded event use the NAMESPACE.."_OnAddOnLoaded" callback. e.g.
-- CALLBACK_MANAGER:RegisterCallback(NAMESPACE.."_OnAddOnLoaded", function(savedVars)
--     ...
-- end)
--
-- To listen to saved variables being changed use the NAMESPACE.."_OnSavedVarChanged" callback. e.g.
-- CALLBACK_MANAGER:RegisterCallback(NAMESPACE.."_OnSavedVarChanged", function(key, newValue, previousValue)
--     ...
-- end)
--
EVENT_MANAGER:RegisterForEvent(NAMESPACE, EVENT_ADD_ON_LOADED, function(eventCode, addOnName)
    if (addOnName == NAMESPACE) then
        local savedVars = ZO_SavedVars:New(NAMESPACE.."_SavedVars", 1, nil, defaultSavedVars)
        do
            local mt = getmetatable(savedVars)
            local __newindex = mt.__newindex
            function mt.__newindex(self, key, value)
                CALLBACK_MANAGER:FireCallbacks(NAMESPACE.."_OnSavedVarChanged", key, value, self[key])
                __newindex(self, key, value)
            end
        end
        CALLBACK_MANAGER:FireCallbacks(NAMESPACE.."_OnAddOnLoaded", savedVars)
    end
end)
