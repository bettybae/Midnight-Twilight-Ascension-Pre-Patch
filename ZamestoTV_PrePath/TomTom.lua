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

    -- Spanish
    if LOCALE == "esES" and rare.name.es then
        return rare.name.es
    end

    -- French
    if LOCALE == "frFR" and rare.name.fr then
        return rare.name.fr
    end

    -- Chinese (Simplified & Traditional)
    if (LOCALE == "zhCN" or LOCALE == "zhTW") and rare.name.zh then
        return rare.name.zh
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
    { vignetteID=7007,  name={ru="Красноглаз Черепоглод", en="Redeye the Skullchewer", de="Rotauge der Schädelbeißer", zh="嚼颅者赤目", fr="Yeux-Rouges, le Mâchonneur de crânes"} },
    { vignetteID=7043,  name={ru="Т'аавихан Освобожденный", en="T'aavihan the Unbound", de="T'aavihan der Ungebundene", zh="无拘者塔维汉", fr="T'aavihan le Délié"} },
    { vignetteID=6995,  name={ru="Скат Гнили", en="Ray of Putrescence", de="Fäulnisstrahl", zh="腐烂之鳐", fr="Raie de putrescence"} },
    { vignetteID=6997,  name={ru="Икс Кровопадший", en="Ix the Bloodfallen", de="Ix der Blutgefallene", zh="滴血者伊斯", fr="Ix le Déchu sanglant"} },
    { vignetteID=6998,  name={ru="Командир Икс'ваарта", en="Commander Ix'vaarha", de="Kommandant Ix'vaarha", zh="指挥官伊斯瓦拉哈", fr="Commandant Ix'vaarha"} },
    { vignetteID=7004,  name={ru="Шарфади Бастион Ночи", en="Sharfadi, Bulwark of the Night", de="Sharfadi, Bollwerk der Nacht", zh="沙法蒂，玄夜壁垒", fr="Sharfadi, Rempart de la Nuit"} },
    { vignetteID=7001,  name={ru="Из'Хаадош Лиминал", en="Ez'Haadosh the Liminality", de="Ez'Haadosh die Liminalität", zh="阈限者艾兹哈多沙", fr="Ez'Haadosh la Liminalité"} },
    { vignetteID=6755,  name={ru="Берг Чаробой", en="Berg the Spellfist", de="Berg die Zauberfaust", zh="法术拳师贝格", fr="Berg le Sorcepoing"} },
    { vignetteID=6761,  name={ru="Глашатай сумрака Корла", en="Corla, Herald of Twilight", de="Corla, Botin des Zwielichts", zh="柯尔拉，暮光之兆", fr="Coria, héraut du Crépuscule"} },
    { vignetteID=6988,  name={ru="Ревнительница Бездны Девинда", en="Void Zealot Devinda", de="Leerenzelotin Devinda", zh="虚空狂热者德文达", fr="Zélote du Vide Devinda"} },
    { vignetteID=6994,  name={ru="Азира Убийца Зари", en="Asira Dawnslayer", de="Asira Dämmerschlächter", zh="埃希拉·黎明克星", fr="Asira Fauchelaube"} },
    { vignetteID=6996,  name={ru="Архиепископ Бенедикт", en="Archbishop Benedictus", de="Erzbischof Benedictus", zh="大主教本尼迪塔斯", fr="Archevêque Benedictus"} },
    { vignetteID=7008,  name={ru="Недранд Глазоед", en="Nedrand the Eyegorger", de="Nedrand der Augenschlinger", zh="凿目者内德兰德", fr="Nedrand l'Énucléeur"} },
    { vignetteID=7042,  name={ru="Палач Линтельма", en="Executioner Lynthelma", de="Scharfrichterin Lynthelma", zh="处决者林瑟尔玛", fr="Exécuteur Lynthelma"} },
    { vignetteID=7005,  name={ru="Густаван Глашатай Финала", en="Gustavan, Herald of the End", de="Gustavan, Herold des Untergangs", zh="古斯塔梵，终末使徒", fr="Gustavan, Héraut de la fin"} },
    { vignetteID=7009,  name={ru="Коготь Бездны – проклинарий", en="Voidclaw Hexathor", de="Leerenklaue Hexathor", zh="虚爪妖兽", fr="Griffe-du-Vide Hexathor"} },
    { vignetteID=7006,  name={ru="Зеркалвайз", en="Mirrorvise", de="Spiegelzwicker", zh="镜影魔", fr="Pincemirroir"} },
    { vignetteID=7003,  name={ru="Салигрум Наблюдатель", en="Saligrum the Observer", de="Saligrum der Beobachter", zh="观察者萨利格鲁姆", fr="Saligrum l'Observateur"} },
    { vignetteID=7340,  name={ru="Глас Затмения", en="Voice of the Eclipse", de="Stimme der Finsternis", zh="蚀变之声", fr="La Voix de l'Éclipse"} },
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
