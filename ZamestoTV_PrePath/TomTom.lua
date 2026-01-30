------------------------------------------------------------
-- Addon Init
------------------------------------------------------------
local addonName = ...
local ADDON = CreateFrame("Frame", addonName)

------------------------------------------------------------
-- Locale
------------------------------------------------------------

local LOCALE = GetLocale()

local function GetLocalizedName(rare)
    if not rare or not rare.name then return "" end

    -- Russian
    if LOCALE == "ruRU" and rare.name.ru then
        return rare.name.ru
    end

    -- German
    if LOCALE == "deDE" and rare.name.de then
        return rare.name.de
    end

    -- Spanish (Spain)
    if LOCALE == "esES" and rare.name.esES then
        return rare.name.esES
    end

    -- Spanish (Mexico)
    if LOCALE == "esMX" and rare.name.esMX then
        return rare.name.esMX
    end

    -- French
    if LOCALE == "frFR" and rare.name.fr then
        return rare.name.fr
    end

    -- Italian
    if LOCALE == "itIT" and rare.name.itIT then
        return rare.name.itIT
    end

    -- Korean
    if LOCALE == "koKR" and rare.name.koKR then
        return rare.name.koKR
    end

    -- Chinese (Simplified)
    if LOCALE == "zhCN" and rare.name.zh then
        return rare.name.zh
    end

    -- Chinese (Traditional)
    if LOCALE == "zhTW" and rare.name.zhTW then
        return rare.name.zhTW
    end

    -- Fallback to English
    return rare.name.en or ""
end

------------------------------------------------------------
-- Data
------------------------------------------------------------
PreData = {}
PreData.MAP_ID = 241

PreData.RARES = {
    { vignetteID=7007,  name={ru="Красноглаз Черепоглод", en="Redeye the Skullchewer", de="Rotauge der Schädelbeißer", zh="嚼颅者赤目", zhTW="『嚼顱者』紅眼", fr="Yeux-Rouges, le Mâchonneur de crânes", esES="Ojorrojo el Masticacráneos", esMX="Ojorrojo, el Masticacráneos", itIT="Occhiorosso il Masticacrani", koKR="해골으적이 붉은눈"} },
    { vignetteID=7043,  name={ru="Т'аавихан Освобожденный", en="T'aavihan the Unbound", de="T'aavihan der Ungebundene", zh="无拘者塔维汉", zhTW="『無縛者』塔維罕", fr="T'aavihan le Délié", esES="T'aavihan el Desatado", esMX="T'aavihan, el Desatado", itIT="T'aavihan l'Indomabile", koKR="해방된 타비한"} },
    { vignetteID=6995,  name={ru="Скат Гнили", en="Ray of Putrescence", de="Fäulnisstrahl", zh="腐烂之鳐", zhTW="腐敗鰭刺", fr="Raie de putrescence", esES="Raya de putrescencia", esMX="Rayo de podredumbre", itIT="Razza della Putrescenza", koKR="부패의 가오리"} },
    { vignetteID=6997,  name={ru="Икс Кровопадший", en="Ix the Bloodfallen", de="Ix der Blutgefallene", zh="滴血者伊斯", zhTW="血殞蟲伊克斯", fr="Ix le Déchu sanglant", esES="Ix el Sangricaído", esMX="Ix, el Sangrecaído", itIT="Ix il Sangue Dannato", koKR="피의 몰락자 익스"} },
    { vignetteID=6998,  name={ru="Командир Икс'ваарта", en="Commander Ix'vaarha", de="Kommandant Ix'vaarha", zh="指挥官伊斯瓦拉哈", zhTW="指揮官伊仕瓦哈", fr="Commandant Ix'vaarha", esES="Comandante Ix'vaarha", esMX="Comandante Ix'vaarha", itIT="Comandante Ix'vaarha", koKR="사령관 익스바르하"} },
    { vignetteID=7004,  name={ru="Шарфади Бастион Ночи", en="Sharfadi, Bulwark of the Night", de="Sharfadi, Bollwerk der Nacht", zh="沙法蒂，玄夜壁垒", zhTW="『暗夜壁壘』煞法迪", fr="Sharfadi, Rempart de la Nuit", esES="Sharfadi, Baluarte Nocturno", esMX="Sharfadi, Bastión de la Noche", itIT="Sharfadi, Baluardo della Notte", koKR="밤의 보루 샤르파디"} },
    { vignetteID=7001,  name={ru="Из'Хаадош Лиминал", en="Ez'Haadosh the Liminality", de="Ez'Haadosh die Liminalität", zh="阈限者艾兹哈多沙", zhTW="『閾限者』艾茲哈德許", fr="Ez'Haadosh la Liminalité", esES="Ez'Haadosh del Umbral", esMX="Ez'Haadosh, la Liminalidad", itIT="Ez'haadosh la Soglia", koKR="경계의 에즈하도쉬"} },
    { vignetteID=6755,  name={ru="Берг Чаробой", en="Berg the Spellfist", de="Berg die Zauberfaust", zh="法术拳师贝格", zhTW="『法拳』柏格", fr="Berg le Sorcepoing", esES="Berg el Puñohechizo", esMX="Berg, el Puño Mágico", itIT="Berg il Pugnomagico", koKR="주문철권 베르그"} },
    { vignetteID=6761,  name={ru="Глашатай сумрака Корла", en="Corla, Herald of Twilight", de="Corla, Botin des Zwielichts", zh="柯尔拉，暮光之兆", zhTW="暮光信使柯爾菈", fr="Coria, héraut du Crépuscule", esES="Corla, Heraldo del Crepúsculo", esMX="Corla, Heraldo del Crepúsculo", itIT="Corla, l'Alfiera del Crepuscolo", koKR="황혼의 전령 코를라"} },
    { vignetteID=6988,  name={ru="Ревнительница Бездны Девинда", en="Void Zealot Devinda", de="Leerenzelotin Devinda", zh="虚空狂热者德文达", zhTW="虛無狂熱者戴雯妲", fr="Zélote du Vide Devinda", esES="Zelote del Vacío Devinda", esMX="Zelote del Vacío Devinda", itIT="Zelota del Vuoto Devinda", koKR="공허 광신도 데빈다"} },
    { vignetteID=6994,  name={ru="Азира Убийца Зари", en="Asira Dawnslayer", de="Asira Dämmerschlächter", zh="埃希拉·黎明克星", zhTW="阿希拉黎明殺戮者", fr="Asira Fauchelaube", esES="Asira Puñal del Alba", esMX="Asira Puñal del Alba", itIT="Asira Vesprorosso", koKR="아시라 돈슬레이어"} },
    { vignetteID=6996,  name={ru="Архиепископ Бенедикт", en="Archbishop Benedictus", de="Erzbischof Benedictus", zh="大主教本尼迪타스", zhTW="大主教本尼迪塔斯", fr="Archevêque Benedictus", esES="Arzobispo Benedictus", esMX="Arzobispo Benedictus", itIT="Arcivescovo Benedictus", koKR="대주교 베네딕투스"} },
    { vignetteID=7008,  name={ru="Недранд Глазоед", en="Nedrand the Eyegorger", de="Nedrand der Augenschlinger", zh="凿目者内德兰德", zhTW="『食眼者』奈德倫", fr="Nedrand l'Énucléeur", esES="Nedrand el Devoraojos", esMX="Nedrand, el Sacaojos", itIT="Nedrand il Mangiaocchi", koKR="눈 포식자 네드란드"} },
    { vignetteID=7042,  name={ru="Палач Линтельма", en="Executioner Lynthelma", de="Scharfrichterin Lynthelma", zh="处决者林瑟尔玛", zhTW="處決者萊瑟瑪", fr="Exécuteur Lynthelma", esES="Verduga Lynthelma", esMX="Verduga Lynthelma", itIT="Lynthelma la Carnefice", koKR="집행자 린셀마"} },
    { vignetteID=7005,  name={ru="Густаван Глашатай Финала", en="Gustavan, Herald of the End", de="Gustavan, Herold des Untergangs", zh="古斯塔梵，终末使徒", zhTW="『末日使者』古斯塔凡", fr="Gustavan, Héraut de la fin", esES="Gustavan, Heraldo del Fin", esMX="Gustavan, Heraldo del Fin", itIT="Gustavan, Alfiere della Fine", koKR="최후의 전령 구스타반"} },
    { vignetteID=7009,  name={ru="Коготь Бездны – проклинарий", en="Voidclaw Hexathor", de="Leerenklaue Hexathor", zh="虚爪妖兽", zhTW="虛爪赫薩索", fr="Griffe-du-Vide Hexathor", esES="Hexathor de la Garra del Vacío", esMX="Garra del Vacío Hexathor", itIT="Hexathor l'Artiglio del Vuoto", koKR="공허발톱 헥사토르"} },
    { vignetteID=7006,  name={ru="Зеркалвайз", en="Mirrorvise", de="Spiegelzwicker", zh="镜影魔", zhTW="米洛維斯", fr="Pincemirroir", esES="Tornillespejil", esMX="Espejavis", itIT="Specchiomorsa", koKR="거울죔쇠"} },
    { vignetteID=7003,  name={ru="Салигрум Наблюдатель", en="Saligrum the Observer", de="Saligrum der Beobachter", zh="观察者萨利格鲁姆", zhTW="『觀察者』賽爾古朗", fr="Saligrum l'Observateur", esES="Saligrum el Observador", esMX="Saligrum, el Observador", itIT="Saligrum l'Osservatore", koKR="관찰자 살리그룸"} },
    { vignetteID=7340,  name={ru="Глас Затмения", en="Voice of the Eclipse", de="Stimme der Finsternis", zh="蚀变之声", zhTW="月蝕之聲", fr="La Voix de l'Éclipse", esES="Voz del Eclipse", esMX="Voz del eclipse", itIT="Voce dell'Eclissi", koKR="일식의 목소리"} },
}

------------------------------------------------------------
-- Fast lookup
------------------------------------------------------------
local RARE_BY_VIGNETTE = {}
for _, rare in ipairs(PreData.RARES) do
    RARE_BY_VIGNETTE[rare.vignetteID] = rare
end

------------------------------------------------------------
-- TomTom
------------------------------------------------------------
local activeWaypoints = {}

local function AddWaypoint(mapID, x, y, vignetteID)
    if not TomTom then return end
    if activeWaypoints[vignetteID] then return end

    local rare = RARE_BY_VIGNETTE[vignetteID]
    if not rare then return end

    local uid = TomTom:AddWaypoint(mapID, x, y, {
        title = GetLocalizedName(rare),
        persistent = false,
        minimap = true,
        world = true,
    })

    activeWaypoints[vignetteID] = uid
end

local function RemoveWaypoint(vignetteID)
    if not TomTom then return end

    local uid = activeWaypoints[vignetteID]
    if uid then
        TomTom:RemoveWaypoint(uid)
        activeWaypoints[vignetteID] = nil
    end
end

------------------------------------------------------------
-- Vignette scanning
------------------------------------------------------------
local activeVignettes = {}

local function ScanVignettes()
    local seen = {}

    for _, guid in ipairs(C_VignetteInfo.GetVignettes()) do
        local info = C_VignetteInfo.GetVignetteInfo(guid)
        if info and RARE_BY_VIGNETTE[info.vignetteID] then
            seen[info.vignetteID] = true

            if not activeVignettes[info.vignetteID] then
                local pos = C_VignetteInfo.GetVignettePosition(guid, PreData.MAP_ID)
                if pos then
                    local x, y = pos:GetXY()
                    AddWaypoint(PreData.MAP_ID, x, y, info.vignetteID)
                    activeVignettes[info.vignetteID] = true
                end
            end
        end
    end

    -- remove disappeared rares
    for vignetteID in pairs(activeVignettes) do
        if not seen[vignetteID] then
            RemoveWaypoint(vignetteID)
            activeVignettes[vignetteID] = nil
        end
    end
end

------------------------------------------------------------
-- Events
------------------------------------------------------------
ADDON:RegisterEvent("VIGNETTES_UPDATED")
ADDON:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")

ADDON:SetScript("OnEvent", function()
    ScanVignettes()
end)
