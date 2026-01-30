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
PrePathData.INTERVAL = 300

PrePathData.RARES = {
    { criteriaID=105744, vignetteID=7007,  name={ru="Красноглаз Черепоглод", en="Redeye the Skullchewer", de="Rotauge der Schädelbeißer", zh="嚼颅者赤目", zhTW="『嚼顱者』紅眼", fr="Yeux-Rouges, le Mâchonneur de crânes", esES="Ojorrojo el Masticacráneos", esMX="Ojorrojo, el Masticacráneos", itIT="Occhiorosso il Masticacrani", koKR="해골으적이 붉은눈"}, x=0.650, y=0.526 },
    { criteriaID=105729, vignetteID=7043,  name={ru="Т'аавихан Освобожденный", en="T'aavihan the Unbound", de="T'aavihan der Ungebundene", zh="无拘者塔维汉", zhTW="『無縛者』塔維罕", fr="T'aavihan le Délié", esES="T'aavihan el Desatado", esMX="T'aavihan, el Desatado", itIT="T'aavihan l'Indomabile", koKR="해방된 타비한"}, x=0.576, y=0.756 },
    { criteriaID=105732, vignetteID=6995,  name={ru="Скат Гнили", en="Ray of Putrescence", de="Fäulnisstrahl", zh="腐烂之鳐", zhTW="腐敗鰭刺", fr="Raie de putrescence", esES="Raya de putrescencia", esMX="Rayo de podredumbre", itIT="Razza della Putrescenza", koKR="부패의 가오리"}, x=0.710, y=0.299 },
    { criteriaID=105736, vignetteID=6997,  name={ru="Икс Кровопадший", en="Ix the Bloodfallen", de="Ix der Blutgefallene", zh="滴血者伊斯", zhTW="血殞蟲伊克斯", fr="Ix le Déchu sanglant", esES="Ix el Sangricaído", esMX="Ix, el Sangrecaído", itIT="Ix il Sangue Dannato", koKR="피의 몰락자 익스"}, x=0.467, y=0.252 },
    { criteriaID=105739, vignetteID=6998,  name={ru="Командир Икс'ваарта", en="Commander Ix'vaarha", de="Kommandant Ix'vaarha", zh="指挥官伊斯瓦拉哈", zhTW="指揮官伊仕瓦哈", fr="Commandant Ix'vaarha", esES="Comandante Ix'vaarha", esMX="Comandante Ix'vaarha", itIT="Comandante Ix'vaarha", koKR="사령관 익스바르하"}, x=0.452, y=0.488 },
    { criteriaID=105742, vignetteID=7004,  name={ru="Шарфади Бастион Ночи", en="Sharfadi, Bulwark of the Night", de="Sharfadi, Bollwerk der Nacht", zh="沙法蒂，玄夜壁垒", zhTW="『暗夜壁壘』煞法迪", fr="Sharfadi, Rempart de la Nuit", esES="Sharfadi, Baluarte Nocturno", esMX="Sharfadi, Bastión de la Noche", itIT="Sharfadi, Baluardo della Notte", koKR="밤의 보루 샤르파디"}, x=0.418, y=0.165 },
    { criteriaID=105745, vignetteID=7001,  name={ru="Из'Хаадош Лиминал", en="Ez'Haadosh the Liminality", de="Ez'Haadosh die Liminalität", zh="阈限者艾兹哈多沙", zhTW="『閾限者』艾茲哈德許", fr="Ez'Haadosh la Liminalité", esES="Ez'Haadosh del Umbral", esMX="Ez'Haadosh, la Liminalidad", itIT="Ez'haadosh la Soglia", koKR="경계의 에즈하도쉬"}, x=0.652, y=0.522 },
    { criteriaID=105727, vignetteID=6755,  name={ru="Берг Чаробой", en="Berg the Spellfist", de="Berg die Zauberfaust", zh="法术拳师贝格", zhTW="『法拳』柏格", fr="Berg le Sorcepoing", esES="Berg el Puñohechizo", esMX="Berg, el Puño Mágico", itIT="Berg il Pugnomagico", koKR="주문철권 베르그"}, x=0.576, y=0.756 },
    { criteriaID=105730, vignetteID=6761,  name={ru="Глашатай сумрака Корла", en="Corla, Herald of Twilight", de="Corla, Botin des Zwielichts", zh="柯尔拉，暮光之兆", zhTW="暮光信使柯爾菈", fr="Coria, héraut du Crépuscule", esES="Corla, Heraldo del Crepúsculo", esMX="Corla, Heraldo del Crepúsculo", itIT="Corla, l'Alfiera del Crepuscolo", koKR="황혼의 전령 코를라"}, x=0.712, y=0.299 },
    { criteriaID=105733, vignetteID=6988,  name={ru="Ревнительница Бездны Девинда", en="Void Zealot Devinda", de="Leerenzelotin Devinda", zh="虚空狂热者德文达", zhTW="虛無狂熱者戴雯妲", fr="Zélote du Vide Devinda", esES="Zelote del Vacío Devinda", esMX="Zelote del Vacío Devinda", itIT="Zelota del Vuoto Devinda", koKR="공허 광신도 데빈다"}, x=0.468, y=0.248 },
    { criteriaID=105737, vignetteID=6994,  name={ru="Азира Убийца Зари", en="Asira Dawnslayer", de="Asira Dämmerschlächter", zh="埃希拉·黎明克星", zhTW="阿希拉黎明殺戮者", fr="Asira Fauchelaube", esES="Asira Puñal del Alba", esMX="Asira Puñal del Alba", itIT="Asira Vesprorosso", koKR="아시라 돈슬레이어"}, x=0.452, y=0.492 },
    { criteriaID=105740, vignetteID=6996,  name={ru="Архиепископ Бенедикт", en="Archbishop Benedictus", de="Erzbischof Benedictus", zh="大主教本尼迪塔斯", zhTW="大主教本尼迪塔斯", fr="Archevêque Benedictus", esES="Arzobispo Benedictus", esMX="Arzobispo Benedictus", itIT="Arcivescovo Benedictus", koKR="대주교 베네딕투스"}, x=0.426, y=0.176 },
    { criteriaID=105743, vignetteID=7008,  name={ru="Недранд Глазоед", en="Nedrand the Eyegorger", de="Nedrand der Augenschlinger", zh="凿目者内德兰德", zhTW="『食眼者』奈德倫", fr="Nedrand l'Énucléeur", esES="Nedrand el Devoraojos", esMX="Nedrand, el Sacaojos", itIT="Nedrand il Mangiaocchi", koKR="눈 포식자 네드란드"}, x=0.654, y=0.530 },
    { criteriaID=105728, vignetteID=7042,  name={ru="Палач Линтельма", en="Executioner Lynthelma", de="Scharfrichterin Lynthelma", zh="处决者林瑟尔玛", zhTW="處決者萊瑟瑪", fr="Exécuteur Lynthelma", esES="Verduga Lynthelma", esMX="Verduga Lynthelma", itIT="Lynthelma la Carnefice", koKR="집행자 린셀마"}, x=0.576, y=0.756 },
    { criteriaID=105731, vignetteID=7005,  name={ru="Густаван Глашатай Финала", en="Gustavan, Herald of the End", de="Gustavan, Herold des Untergangs", zh="古斯塔梵，终末使徒", zhTW="『末日使者』古斯塔凡", fr="Gustavan, Héraut de la fin", esES="Gustavan, Heraldo del Fin", esMX="Gustavan, Heraldo del Fin", itIT="Gustavan, Alfiere della Fine", koKR="최후의 전령 구스타반"}, x=0.712, y=0.316 },
    { criteriaID=105734, vignetteID=7009,  name={ru="Коготь Бездны – проклинарий", en="Voidclaw Hexathor", de="Leerenklaue Hexathor", zh="虚爪妖兽", zhTW="虛爪赫薩索", fr="Griffe-du-Vide Hexathor", esES="Hexathor de la Garra del Vacío", esMX="Garra del Vacío Hexathor", itIT="Hexathor l'Artiglio del Vuoto", koKR="공허발톱 헥사토르"}, x=0.466, y=0.254 },
    { criteriaID=105738, vignetteID=7006,  name={ru="Зеркалвайз", en="Mirrorvise", de="Spiegelzwicker", zh="镜影魔", zhTW="米洛維斯", fr="Pincemirroir", esES="Tornillespejil", esMX="Espejavis", itIT="Specchiomorsa", koKR="거울죔쇠"}, x=0.452, y=0.490 },
    { criteriaID=105741, vignetteID=7003,  name={ru="Салигрум Наблюдатель", en="Saligrum the Observer", de="Saligrum der Beobachter", zh="观察者萨利格鲁姆", zhTW="『觀察者』賽爾古朗", fr="Saligrum l'Observateur", esES="Saligrum el Observador", esMX="Saligrum, el Observador", itIT="Saligrum l'Osservatore", koKR="관찰자 살리그룸"}, x=0.426, y=0.176 },
    { criteriaID=109583, name={ru="Глас Затмения", en="Voice of the Eclipse", de="Stimme der Finsternis", zh="蚀变之声", zhTW="月蝕之聲", fr="La Voix de l'Éclipse", esES="Voz del Eclipse", esMX="Voz del eclipse", itIT="Voce dell'Eclissi", koKR="일식의 목소리"}, noTimer=true },
}

PrePathData.CHAT_TRIGGERS = {
    ru = {
        "Сектанты Сумеречного Клинка призывают подкрепление. Убейте предводителей ритуалистов!"
    },
    en = {
        "The Twilight's Blade have begun summoning more forces. Defeat their ritual leaders!"
    },
    de = {
        "Die Zwielichtklinge hat begonnen, weitere Truppen herbeizurufen. Besiegt ihre Ritualleiter!"
    },
    fr = {
        "La Lame du Crépuscule commence à invoquer davantage de troupes. Éliminez les personnes qui dirigent le rituel !"
    },
    zh = {
        "暮光之刃已经开始召唤援军。击败他们的仪式首领！"
    },
    zhTW = {
        "暮光之刃已經開始召喚援軍。擊敗他們的儀式首領！"
    },
    esES = {
        "La Hoja Crepuscular ha empezado a invocar más tropas. ¡Derrota a sus líderes rituales!"
    },
    esMX = {
        "La Daga Crepuscular ha comenzado a invocar más fuerzas. ¡Derrota a los líderes del ritual!"
    }
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
    local locale = GetLocale()

    if locale == "ruRU" then
        return "ru"
    elseif locale == "deDE" then
        return "de"
    elseif locale == "esES" then
        return "esES"
    elseif locale == "esMX" then
        return "esMX"
    elseif locale == "frFR" then
        return "fr"
    elseif locale == "itIT" then
        return "itIT"
    elseif locale == "koKR" then
        return "koKR"
    elseif locale == "zhCN" then
        return "zh"
    elseif locale == "zhTW" then
        return "zhTW"
    else
        return "en"
    end
end

local function FormatTime(seconds, showDays)
    if seconds < 0 then seconds = 0 end

    local days = 0
    if showDays then
        days = math.floor(seconds / 86400)
        seconds = seconds - days * 86400
    end

    local hours = math.floor(seconds / 3600)
    seconds = seconds - hours * 3600

    local minutes = math.floor(seconds / 60)
    local secondsRemaining = seconds - minutes * 60

    if showDays then
        return string.format("%dd %02d:%02d:%02d", days, hours, minutes, secondsRemaining)
    end

    return string.format("%02d:%02d:%02d", hours, minutes, secondsRemaining)
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
button.text:SetText("Pre-Patch")

------------------------------------------------------------
-- MAIN FRAME
------------------------------------------------------------
local frame = CreateFrame("Frame", "PrePathMainFrame", UIParent, "BackdropTemplate")
frame:SetSize(390, 480)
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
    row:SetPoint("TOPLEFT", 20, yOffset)

    row.name = row:CreateFontString(nil,"OVERLAY","GameFontNormal")
    row.name:SetPoint("LEFT")

row.mapButton = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
row.mapButton:SetSize(50, 18)
row.mapButton:SetPoint("LEFT", row.name, "RIGHT", 8, 0)
row.mapButton:SetText("Map")
row.mapButton:SetScript("OnClick", function()
    local r = PrePathData.RARES[index]
    if not r then return end

    local mapID = r.mapID or PrePathData.MAP_ID
    local x = r.x
    local y = r.y

    if not x or not y then
        print("|cffFF0000Pre-Patch|r: Coordinates missing for "..(r.name[GetLocaleString()] or "unknown"))
        return
    end

    local point = UiMapPoint.CreateFromCoordinates(mapID, x, y)
    if C_Map and C_Map.SetUserWaypoint then
        C_Map.SetUserWaypoint(point)
    end

    if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    end
end)

    row.timer = row:CreateFontString(nil,"OVERLAY","GameFontNormal")
    row.timer:SetPoint("LEFT", row.mapButton, "RIGHT", 8, 0)

    PrePathFrame.rows[index] = row
    yOffset = yOffset - 22
end


------------------------------------------------------------
-- UPDATE ROWS
------------------------------------------------------------
local ACTIVE_TEXT = {
    ru   = "Активен",
    en   = "Active",
    de   = "Aktiv",
    fr   = "Actif",
    esES = "Activo",
    esMX = "Activo",
    itIT = "Attivo",
    koKR = "활성",
    zh   = "激活",
    zhTW = "啟用",
}

function PrePathFrame:UpdateRows()
    for index, row in ipairs(self.rows) do
        local data = PrePathData.RARES[index]
        local localeKey = GetLocaleString()

        if index == self.activeIndex then
            row.name:SetTextColor(1,1,0)
        elseif self.criteriaCompleted[data.criteriaID] then
            row.name:SetTextColor(0,1,0)
        else
            row.name:SetTextColor(1,1,1)
        end

        if data.noTimer then
            row.timer:SetText("")
        elseif index == self.activeIndex then
            row.timer:SetText(ACTIVE_TEXT[localeKey] or ACTIVE_TEXT.en)
        elseif self.cycleStartTime and self.activeIndex then
            local steps = 0
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

        row.name:SetText(
            data.name[localeKey]
            or data.name.en
            or ""
        )
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
-- CHAT HANDLER (FIXED)
------------------------------------------------------------
function PrePathFrame:HandleChatEvent(event, text)
    if type(text) ~= "string" then return end

    local localeKey = GetLocaleString()
    local triggers = PrePathData.CHAT_TRIGGERS[localeKey]
        or PrePathData.CHAT_TRIGGERS.en

    if not triggers then return end

    for _, trigger in ipairs(triggers) do
        if string.find(text, trigger, 1, true) then
            self:StartPollingDelayed()
            return
        end
    end
end

function PrePathFrame:CHAT_MSG_MONSTER_SAY(event, text)
    self:HandleChatEvent(event, text)
end

function PrePathFrame:CHAT_MSG_MONSTER_YELL(event, text)
    self:HandleChatEvent(event, text)
end

function PrePathFrame:CHAT_MSG_MONSTER_EMOTE(event, text)
    self:HandleChatEvent(event, text)
end

function PrePathFrame:CHAT_MSG_RAID_BOSS_EMOTE(event, text)
    self:HandleChatEvent(event, text)
end

------------------------------------------------------------
-- MAIN LOOP
------------------------------------------------------------
local END_TEXT = {
    ru   = "До конца: ",
    en   = "Ends in: ",
    de   = "Endet in: ",
    fr   = "Se termine dans : ",
    esES = "Termina en: ",
    esMX = "Termina en: ",
    itIT = "Termina tra: ",
    koKR = "종료까지: ",
    zh   = "结束于：",
    zhTW = "結束於：",
}

C_Timer.NewTicker(1, function()
    local currentTime = time()
    local localeKey = GetLocaleString()

    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(PrePathData.CURRENCY_ID)
    currencyText:SetText(currencyInfo and currencyInfo.quantity or 0)

    endText:SetText(
        (END_TEXT[localeKey] or END_TEXT.en)
        .. FormatTime(PrePathData.EVENT_END - currentTime, true)
    )

    PrePathFrame:UpdateRows()
end)

------------------------------------------------------------
-- SLASH
------------------------------------------------------------
SLASH_PREPATCH1 = "/prepatch"
SlashCmdList["PREPATCH"] = function(message)
    if message == "check" then
        PrePathFrame:StartPollingDelayed()
    else
        frame:SetShown(not frame:IsShown())
    end
end



