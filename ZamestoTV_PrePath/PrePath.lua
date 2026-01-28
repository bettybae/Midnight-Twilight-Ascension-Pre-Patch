PrePathDB = PrePathDB or {}

local addonName = ...
local PrePathFrame = CreateFrame("Frame", "PrePathFrameRoot", UIParent)
PrePathFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

------------------------------------------------------------
-- DATA
------------------------------------------------------------
PrePathData = {}

PrePathData.MAP_ID = 241
PrePathData.ACHIEVEMENT_ID = 42300
PrePathData.EVENT_END = 1772492400
PrePathData.CURRENCY_ID = 3319
PrePathData.CURRENCY_ICON = 7195171
PrePathData.INTERVAL = 600

PrePathData.RARES = {
    { criteriaID=105744, vignetteID=7007,  name={ru="Красноглаз Черепоглод",en="Redeye the Skullchewer",de="Rotauge der Schädelbeißer"} },
    { criteriaID=105729, vignetteID=7043,  name={ru="Т'аавихан Освобожденный",en="T'aavihan the Unbound",de="T'aavihan der Ungebundene"} },
    { criteriaID=105732, vignetteID=6995,  name={ru="Скат Гнили",en="Ray of Putrescence",de="Fäulnisstrahl"} },
    { criteriaID=105736, vignetteID=6997,  name={ru="Икс Кровопадший",en="Ix the Bloodfallen",de="Ix der Blutgefallene"} },	
    { criteriaID=105739, vignetteID=6998,  name={ru="Командир Икс'ваарта",en="Commander Ix'vaarha",de="Kommandant Ix'vaarha"} },	
    { criteriaID=105742, vignetteID=7004,  name={ru="Шарфади Бастион Ночи",en="Sharfadi, Bulwark of the Night",de="Sharfadi, Bollwerk der Nacht"} },	
    { criteriaID=105745, vignetteID=7001,  name={ru="Из'Хаадош Лиминал",en="Ez'Haadosh the Liminality",de="Ez'Haadosh die Liminalität"} },	
    { criteriaID=105727, vignetteID=6755,  name={ru="Берг Чаробой",en="Berg the Spellfist",de="Berg die Zauberfaust"} },
    { criteriaID=105730, vignetteID=6761,  name={ru="Глашатай сумрака Корла",en="Corla, Herald of Twilight",de="Corla, Botin des Zwielichts"} },	
    { criteriaID=105733, vignetteID=6988,  name={ru="Ревнительница Бездны Девинда",en="Void Zealot Devinda",de="Leerenzelotin Devinda"} },	
    { criteriaID=105737, vignetteID=6994,  name={ru="Азира Убийца Зари",en="Asira Dawnslayer",de="Asira Dämmerschlächter"} },	
    { criteriaID=105740, vignetteID=6996,  name={ru="Архиепископ Бенедикт",en="Archbishop Benedictus",de="Erzbischof Benedictus"} },
    { criteriaID=105743, vignetteID=7008,  name={ru="Недранд Глазоед",en="Nedrand the Eyegorger",de="Nedrand der Augenschlinger"} },
    { criteriaID=105728, vignetteID=7042,  name={ru="Палач Линтельма",en="Executioner Lynthelma",de="Scharfrichterin Lynthelma"} },
    { criteriaID=105731, vignetteID=7005,  name={ru="Густаван Глашатай Финала",en="Gustavan, Herald of the End",de="Gustavan, Herold des Untergangs"} },
    { criteriaID=105734, vignetteID=7009,  name={ru="Коготь Бездны – проклинарий",en="Voidclaw Hexathor",de="Leerenklaue Hexathor"} },
    { criteriaID=105738, vignetteID=7006,  name={ru="Зеркалвайз",en="Mirrorvise",de="Spiegelzwicker"} },
    { criteriaID=105741, vignetteID=7003,  name={ru="Салигрум Наблюдатель",en="Saligrum the Observer", de="Saligrum der Beobachter"} },
    { criteriaID=109583, name={ru="Глас Затмения",en="Voice of the Eclipse",de="Stimme der Finsternis"}, noTimer=true },
}

PrePathData.CHAT_TRIGGERS = {
    ru = { "Сектанты Сумеречного Клинка призывают подкрепление. Убейте предводителей ритуалистов!" },
    en = { "The Twilight's Blade have begun summoning more forces. Defeat their ritual leaders!" },
    de = { "Die Zwielichtklinge hat begonnen, weitere Truppen herbeizurufen. Besiegt ihre Ritualleiter!" }
}

------------------------------------------------------------
-- STATE
------------------------------------------------------------
PrePathFrame.rows = {}
PrePathFrame.criteriaCompleted = {}
PrePathFrame.activeIndex = nil
PrePathFrame.cycleStartTime = nil
PrePathFrame.pollTicker = nil
PrePathFrame.waitingForNewCycle = false
PrePathFrame.chatTriggerTime = nil

------------------------------------------------------------
-- UTILS
------------------------------------------------------------
local function GetLocaleString()
        return GetLocale() == "ruRU" and "ru" or "deDE" and "de" or "en"
end

local function FormatTime(seconds)
    if seconds < 0 then seconds = 0 end
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secondsRemaining = seconds % 60
    return string.format("%dd %02d:%02d:%02d", days, hours, minutes, secondsRemaining)
end

local function IsCriteriaDone(criteriaID)
    local _, _, completed = GetAchievementCriteriaInfoByID(PrePathData.ACHIEVEMENT_ID, criteriaID)
    return completed
end

------------------------------------------------------------
-- ACHIEVEMENT CACHE
------------------------------------------------------------
local function UpdateAchievementCache()
    wipe(PrePathFrame.criteriaCompleted)
    for _, data in ipairs(PrePathData.RARES) do
        if data.criteriaID then
            PrePathFrame.criteriaCompleted[data.criteriaID] = IsCriteriaDone(data.criteriaID)
        end
    end
end

------------------------------------------------------------
-- UI BUTTON
------------------------------------------------------------
local button = CreateFrame("Button", "PrePathButton", UIParent, "BackdropTemplate")
button:SetSize(110, 30)
button:SetPoint("CENTER", UIParent, "CENTER", 0, 220)
button:SetBackdrop({ bgFile="Interface/Tooltips/UI-Tooltip-Background" })
button:SetBackdropColor(0,0,0,0.85)
button:SetMovable(true)
button:EnableMouse(true)
button:RegisterForDrag("LeftButton")
button:SetScript("OnDragStart", button.StartMoving)
button:SetScript("OnDragStop", button.StopMovingOrSizing)
button.text = button:CreateFontString(nil,"OVERLAY","GameFontNormal")
button.text:SetPoint("CENTER")
button.text:SetText("Pre-Path")

------------------------------------------------------------
-- MAIN FRAME
------------------------------------------------------------
local frame = CreateFrame("Frame", "PrePathMainFrame", UIParent, "BackdropTemplate")
frame:SetSize(430, 480)
frame:SetPoint("CENTER")
frame:SetBackdrop({ bgFile="Interface/Tooltips/UI-Tooltip-Background" })
frame:SetBackdropColor(0,0,0,0.92)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()

button:SetScript("OnClick", function()
    frame:SetShown(not frame:IsShown())
end)

------------------------------------------------------------
-- TOP BAR
------------------------------------------------------------
local currencyText = frame:CreateFontString(nil,"OVERLAY","GameFontNormal")
currencyText:SetPoint("TOPLEFT",10,-10)

local currencyIcon = frame:CreateTexture(nil,"OVERLAY")
currencyIcon:SetSize(16,16)
currencyIcon:SetPoint("LEFT", currencyText, "RIGHT", 4, 0)
currencyIcon:SetTexture(PrePathData.CURRENCY_ICON)

local endText = frame:CreateFontString(nil,"OVERLAY","GameFontNormal")
endText:SetPoint("TOPRIGHT",-10,-10)

------------------------------------------------------------
-- LIST
------------------------------------------------------------
local yOffset = -50
for index, data in ipairs(PrePathData.RARES) do
    local row = CreateFrame("Frame", nil, frame)
    row:SetSize(390, 20)
    row:SetPoint("TOPLEFT",20,yOffset)
    row.name = row:CreateFontString(nil,"OVERLAY","GameFontNormal")
    row.name:SetPoint("LEFT")
    row.timer = row:CreateFontString(nil,"OVERLAY","GameFontNormal")
    row.timer:SetPoint("RIGHT")
    PrePathFrame.rows[index] = row
    yOffset = yOffset - 22
end

------------------------------------------------------------
-- UPDATE ROWS
------------------------------------------------------------
function PrePathFrame:UpdateRows()
    for index, row in ipairs(self.rows) do
        local data = PrePathData.RARES[index]

        -- COLOR
        if index == self.activeIndex then
            row.name:SetTextColor(1,1,0)
        elseif self.criteriaCompleted[data.criteriaID] then
            row.name:SetTextColor(0,1,0)
        else
            row.name:SetTextColor(1,1,1)
        end

        -- TIMER
        if data.noTimer then
            row.timer:SetText("")
        elseif index == self.activeIndex then
            row.timer:SetText(GetLocaleString()=="ru" and "Активен" or "Active")
        elseif self.cycleStartTime and self.activeIndex then
            local steps = 0

            -- считаем только редких с таймером
            local i = self.activeIndex
            while i ~= index do
                i = i + 1
                if i > #PrePathData.RARES then
                    i = 1
                end

                if not PrePathData.RARES[i].noTimer then
                    steps = steps + 1
                end
            end

            local targetTime = self.cycleStartTime + steps * PrePathData.INTERVAL
            row.timer:SetText(FormatTime(targetTime - GetTime()))
        else
            row.timer:SetText("")
        end

        row.name:SetText(data.name[GetLocaleString()])
    end
end

------------------------------------------------------------
-- EVENTS
------------------------------------------------------------
PrePathFrame:RegisterEvent("ADDON_LOADED")
PrePathFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PrePathFrame:RegisterEvent("CRITERIA_UPDATE")
PrePathFrame:RegisterEvent("ACHIEVEMENT_EARNED")
PrePathFrame:RegisterEvent("CHAT_MSG_MONSTER_SAY")
PrePathFrame:RegisterEvent("CHAT_MSG_MONSTER_YELL")
PrePathFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
PrePathFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

function PrePathFrame:ADDON_LOADED(name)
    if name ~= addonName then return end
    UpdateAchievementCache()
end

function PrePathFrame:PLAYER_ENTERING_WORLD()
    UpdateAchievementCache()
end

function PrePathFrame:CRITERIA_UPDATE()
    UpdateAchievementCache()
end

function PrePathFrame:ACHIEVEMENT_EARNED()
    UpdateAchievementCache()
end

------------------------------------------------------------
-- VIGNETTE SEARCH
------------------------------------------------------------
function PrePathFrame:FindActiveVignette()
    for _, guid in ipairs(C_VignetteInfo.GetVignettes()) do
        local info = C_VignetteInfo.GetVignetteInfo(guid)
        if info then
            for index, data in ipairs(PrePathData.RARES) do
                if info.vignetteID == data.vignetteID then
                    return index
                end
            end
        end
    end
end

------------------------------------------------------------
-- DELAYED POLLING
------------------------------------------------------------
function PrePathFrame:StartPollingDelayed()
    if self.waitingForNewCycle then return end

    self.waitingForNewCycle = true
    self.activeIndex = nil
    self.cycleStartTime = nil

    if self.pollTicker then
        self.pollTicker:Cancel()
        self.pollTicker = nil
    end

    C_Timer.After(5, function()
        local startTime = GetTime()

        self.pollTicker = C_Timer.NewTicker(0.2, function()
            local idx = PrePathFrame:FindActiveVignette()

            if idx then
                PrePathFrame.activeIndex = idx
                PrePathFrame.cycleStartTime = GetTime()
                self.waitingForNewCycle = false
                self.pollTicker:Cancel()
                self.pollTicker = nil
            elseif GetTime() - startTime > 5 then
                self.waitingForNewCycle = false
                self.pollTicker:Cancel()
                self.pollTicker = nil
            end
        end)
    end)
end

------------------------------------------------------------
-- CHAT HANDLER
------------------------------------------------------------
function PrePathFrame:HandleChatMessage(text)
    if not text then return end

    for _, trigger in ipairs(PrePathData.CHAT_TRIGGERS[GetLocaleString()]) do
        if string.find(text, trigger, 1, true) then
            PrePathFrame:StartPollingDelayed()
            return
        end
    end
end

PrePathFrame.CHAT_MSG_MONSTER_SAY = PrePathFrame.HandleChatMessage
PrePathFrame.CHAT_MSG_MONSTER_YELL = PrePathFrame.HandleChatMessage
PrePathFrame.CHAT_MSG_MONSTER_EMOTE = PrePathFrame.HandleChatMessage
PrePathFrame.CHAT_MSG_RAID_BOSS_EMOTE = PrePathFrame.HandleChatMessage

------------------------------------------------------------
-- MAIN LOOP
------------------------------------------------------------
C_Timer.NewTicker(1, function()
    local currentTime = time()
    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(PrePathData.CURRENCY_ID)
    currencyText:SetText(currencyInfo and currencyInfo.quantity or 0)
    endText:SetText((GetLocaleString()=="ru" and "До конца: " or GetLocaleString()=="de" and "Endet in: " or "Ends in: ") .. FormatTime(PrePathData.EVENT_END - currentTime))
    PrePathFrame:UpdateRows()
end)

------------------------------------------------------------
-- SLASH
------------------------------------------------------------
SLASH_PREPATH1 = "/prepath"
SlashCmdList["PREPATH"] = function(message)
    if message == "check" then
        PrePathFrame:StartPollingDelayed()
    else
        frame:SetShown(not frame:IsShown())
    end
end

