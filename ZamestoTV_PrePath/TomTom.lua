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
    {vignetteID=7007,  name={ru="Красноглаз Черепоглод", en="Redeye the Skullchewer", de="Rotauge der Schädelbeißer", zh="啃颅者・红眼"} },
    {vignetteID=7043,  name={ru="Т'аавихан Освобожденный", en="T'aavihan the Unbound", de="T'aavihan der Ungebundene", zh="解缚者・塔阿维汉"} },
    {vignetteID=6995,  name={ru="Скат Гнили", en="Ray of Putrescence", de="Fäulnisstrahl", zh="腐秽之辉"} },
    {vignetteID=6997,  name={ru="Икс Кровопадший", en="Ix the Bloodfallen", de="Ix der Blutgefallene", zh="血陨者 伊克斯"} },
    {vignetteID=6998,  name={ru="Командир Икс'ваарта", en="Commander Ix'vaarha", de="Kommandant Ix'vaarha", zh="指挥官 伊克斯瓦尔哈"} },
    {vignetteID=7004,  name={ru="Шарфади Бастион Ночи", en="Sharfadi, Bulwark of the Night", de="Sharfadi, Bollwerk der Nacht", zh="夜之壁垒・沙法迪"} },
    {vignetteID=7001,  name={ru="Из'Хаадош Лиминал", en="Ez'Haadosh the Liminality", de="Ez'Haadosh die Liminalität", zh="埃兹哈多什・临界"} },
    {vignetteID=6755,  name={ru="Берг Чаробой", en="Berg the Spellfist", de="Berg die Zauberfaust", zh="咒拳师伯格"} },
    {vignetteID=6761,  name={ru="Глашатай сумрака Корла", en="Corla, Herald of Twilight", de="Corla, Botin des Zwielichts", zh="柯尔拉-暮光之兆"} },
    {vignetteID=6988,  name={ru="Ревнительница Бездны Девинда", en="Void Zealot Devinda", de="Leerenzelotin Devinda", zh="虚空狂热者・德文达"} },
    {vignetteID=6994,  name={ru="Азира Убийца Зари", en="Asira Dawnslayer", de="Asira Dämmerschlächter", zh="埃希拉-黎明克星"} },
    {vignetteID=6996,  name={ru="Архиепископ Бенедикт", en="Archbishop Benedictus", de="Erzbischof Benedictus", zh="大主教本尼迪塔斯"} },
    {vignetteID=7008,  name={ru="Недранд Глазоед", en="Nedrand the Eyegorger", de="Nedrand der Augenschlinger", zh="噬眼者・内德兰"} },
    {vignetteID=7042,  name={ru="Палач Линтельма", en="Executioner Lynthelma", de="Scharfrichterin Lynthelma", zh="刽子手 林塞尔玛"} },
    {vignetteID=7005,  name={ru="Густаван Глашатай Финала", en="Gustavan, Herald of the End", de="Gustavan, Herold des Untergangs", zh="终末使者 古斯塔万"} },
    {vignetteID=7009,  name={ru="Коготь Бездны – проклинарий", en="Voidclaw Hexathor", de="Leerenklaue Hexathor", zh="虚空之爪・赫克萨索尔"} },
    {vignetteID=7006,  name={ru="Зеркалвайз", en="Mirrorvise", de="Spiegelzwicker", zh="镜钳"} },
    {vignetteID=7003,  name={ru="Салигрум Наблюдатель", en="Saligrum the Observer", de="Saligrum der Beobachter", zh="观察者・萨利格鲁姆"} },
    {vignetteID=7340, name={ru="Глас Затмения", en="Voice of the Eclipse", de="Stimme der Finsternis", zh="蚀之音"} },
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
