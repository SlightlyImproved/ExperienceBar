-- Slightly Improved™ Experience Bar
-- The MIT License © 2016 Arthur Corenzan
-- FreeBSD License © 2014 Kevin Douglas

local NAMESPACE = "SlightlyImprovedExperienceBar"

--
--
--

local function TrapPlayerProgressBarHide(savedVars)
end

local function ShowPlayerProgressBar()
    PLAYER_PROGRESS_BAR_FRAGMENT:Show()

    if (CanUnitGainChampionPoints("player")) then
        PLAYER_PROGRESS_BAR:SetBaseType(PPB_CP)
    else
        PLAYER_PROGRESS_BAR:SetBaseType(PPB_XP)
    end
end

local function UpdatePlayerProgressBarLabel(label)
    local barTypeInfo = nil
    local level = 0
    local current = 0
    local levelSize = 0
    barTypeInfo = PLAYER_PROGRESS_BAR:GetBarTypeInfo()
    level, current, levelSize = PLAYER_PROGRESS_BAR:GetMostRecentlyShownInfo()

    if barTypeInfo then
        if levelSize then
            if current < levelSize then
                local percentageXP = zo_floor(current / levelSize * 100)
                label:SetText(zo_strformat(barTypeInfo.tooltipCurrentMaxFormat, ZO_CommaDelimitNumber(current), ZO_CommaDelimitNumber(levelSize), percentageXP))
            end
        end
    end
end
--
--
--

local defaultSavedVars = {
    visibility = "Always Show"
}

CALLBACK_MANAGER:RegisterCallback(NAMESPACE.."_OnSavedVarChanged", function(key, newValue, previousValue)
    if key == "visibility" then
        if newValue == "Always Show" then
            ShowPlayerProgressBar()
        else
            PLAYER_PROGRESS_BAR_FRAGMENT:Hide()
        end
    end
end)

CALLBACK_MANAGER:RegisterCallback(NAMESPACE.."_OnAddOnLoaded", function(savedVars)
    -- Trap the method Hide() of the experience bar so we
    -- can skip it if its visibility is set to "always show".
    local playerProgressBarHide = PLAYER_PROGRESS_BAR.Hide
    function PLAYER_PROGRESS_BAR:Hide()
        if savedVars.visibility ~= "Always Show" then
            playerProgressBarHide(self)
        end
    end

    if savedVars.visibility == "Always Show" then
        ShowPlayerProgressBar()
    end

    local label = CreateControl("ZO_PlayerProgressBarLabel", ZO_PlayerProgressBar, CT_LABEL)
    label:SetFont("ZoFontWinH4")
    label:SetAnchor(CENTER, ZO_PlayerProgressBar)

    EVENT_MANAGER:RegisterForEvent(NAMESPACE, EVENT_EXPERIENCE_UPDATE, function(eventCode)
        UpdatePlayerProgressBarLabel(label)
    end)
    UpdatePlayerProgressBarLabel(label)
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
            local t = getmetatable(savedVars)
            local __newindex = t.__newindex
            function t.__newindex(self, key, value)
                CALLBACK_MANAGER:FireCallbacks(NAMESPACE.."_OnSavedVarChanged", key, value, self[key])
                __newindex(self, key, value)
            end
        end
        CALLBACK_MANAGER:FireCallbacks(NAMESPACE.."_OnAddOnLoaded", savedVars)
    end
end)
