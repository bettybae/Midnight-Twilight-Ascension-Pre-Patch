local ADDON = ...

--------------------------------------------------
-- CONFIG
--------------------------------------------------
local CELL_SIZE = 60
local ICON_SIZE = 36

local ICONS = {
    Horde    = "Interface\\GroupFrame\\UI-Group-PVP-Horde",
    Alliance = "Interface\\GroupFrame\\UI-Group-PVP-Alliance",
}

--------------------------------------------------
-- STATE
--------------------------------------------------
local board = {} 
local playerFaction
local enemyFaction
local cells = {}

--------------------------------------------------
-- WIN LINES
--------------------------------------------------
local WIN_LINES = {
    {1,2,3},{4,5,6},{7,8,9},
    {1,4,7},{2,5,8},{3,6,9},
    {1,5,9},{3,5,7},
}

--------------------------------------------------
-- FRAME
--------------------------------------------------
local frame = CreateFrame("Frame", "TicTacHintsFrame", UIParent, "BackdropTemplate")
frame:SetSize(260, 330)
frame:SetPoint("CENTER")
frame:SetBackdrop({
    bgFile   = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 12,
})
frame:SetBackdropColor(0,0,0,0.9)
frame:Hide()

frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

--------------------------------------------------
-- CLOSE BUTTON
--------------------------------------------------
local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -4, -4)

--------------------------------------------------
-- TITLE
--------------------------------------------------
frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
frame.title:SetPoint("TOP", 0, -12)
frame.title:SetText("TicTac Hints")

--------------------------------------------------
-- GAME LOGIC
--------------------------------------------------
local function CheckWinner(b)
    for _, l in ipairs(WIN_LINES) do
        local a,b1,c = l[1],l[2],l[3]
        if b[a] ~= 0 and b[a] == b[b1] and b[a] == b[c] then
            return b[a]
        end
    end
    return nil
end

local function IsFull(b)
    for i=1,9 do
        if b[i]==0 then return false end
    end
    return true
end

local function Minimax(b, isPlayerTurn)
    local w = CheckWinner(b)
    if w == 1 then return  1 end
    if w == 2 then return -1 end
    if IsFull(b) then return 0 end

    if isPlayerTurn then
        local best = -math.huge
        for i=1,9 do
            if b[i]==0 then
                b[i]=1
                best = math.max(best, Minimax(b,false))
                b[i]=0
            end
        end
        return best
    else
        local best = math.huge
        for i=1,9 do
            if b[i]==0 then
                b[i]=2
                best = math.min(best, Minimax(b,true))
                b[i]=0
            end
        end
        return best
    end
end

local function FindBestMove()
    local bestScore = -math.huge
    local bestMove

    for i=1,9 do
        if board[i]==0 then
            board[i]=1
            local score = Minimax(board,false)
            board[i]=0

            if score > bestScore then
                bestScore = score
                bestMove = i
            end
        end
    end

    return bestMove
end

--------------------------------------------------
-- PLAYER TURN LOGIC
--------------------------------------------------
local function IsPlayerTurn()
    local playerCount = 0
    local enemyCount = 0

    for i=1, 9 do
        if board[i] == 1 then
            playerCount = playerCount + 1
        elseif board[i] == 2 then
            enemyCount = enemyCount + 1
        end
    end

    return playerCount <= enemyCount
end

--------------------------------------------------
-- UI HELPERS
--------------------------------------------------
local function ClearHints()
    for i=1,9 do
        cells[i]:SetBackdropColor(0.15,0.15,0.15,1)
    end
end

local function ShowHint()
    ClearHints()
    local move = FindBestMove()
    if move then
        cells[move]:SetBackdropColor(0,0.85,0,0.9)
    end
end

local function ClearBoard()
    for i=1,9 do
        board[i]=0
        cells[i].icon:Hide()
        cells[i]:SetBackdropColor(0.15,0.15,0.15,1)
    end
end

--------------------------------------------------
-- CELLS
--------------------------------------------------
local function CreateCell(i)
    local b = CreateFrame("Button", nil, frame, "BackdropTemplate")
    b:SetSize(CELL_SIZE, CELL_SIZE)
    b:SetBackdrop({
        bgFile   = "Interface/Buttons/WHITE8x8",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 10,
    })
    b:SetBackdropColor(0.15,0.15,0.15,1)

    local row = math.floor((i-1)/3)
    local col = (i-1)%3
    b:SetPoint("TOPLEFT", 20 + col*(CELL_SIZE+5), -40 - row*(CELL_SIZE+5))

    b.icon = b:CreateTexture(nil,"ARTWORK")
    b.icon:SetSize(ICON_SIZE,ICON_SIZE)
    b.icon:SetPoint("CENTER")
    b.icon:Hide()

b:SetScript("OnClick", function()
    if board[i] ~= 0 or not playerFaction then return end

    ClearHints()

    if IsPlayerTurn() then
        -- Ход игрока
        board[i] = 1
        b.icon:SetTexture(ICONS[playerFaction])
        b.icon:Show()
        -- Проверка победителя
        if CheckWinner(board) then
            ClearBoard()
            return
        end
        -- После хода игрока — ждём ход врага, подсказку не показываем
    else
        -- Ход противника
        board[i] = 2
        b.icon:SetTexture(ICONS[enemyFaction])
        b.icon:Show()
        -- Проверка победителя
        if CheckWinner(board) then
            ClearBoard()
            return
        end
        -- После хода врага — показываем подсказку
        ShowHint()
    end
end)

    cells[i]=b
end

for i=1,9 do
    board[i]=0
    CreateCell(i)
end

--------------------------------------------------
-- BUTTONS
--------------------------------------------------
local function Button(text,x,y,fn)
    local b = CreateFrame("Button",nil,frame,"UIPanelButtonTemplate")
    b:SetSize(100,24)
    b:SetPoint("BOTTOMLEFT",x,y)
    b:SetText(text)
    b:SetScript("OnClick",fn)
end

Button("Clear",20,20,ClearBoard)

Button("Horde",140,50,function()
    playerFaction="Horde"
    enemyFaction="Alliance"
    ClearBoard()
end)

Button("Alliance",140,20,function()
    playerFaction="Alliance"
    enemyFaction="Horde"
    ClearBoard()
end)

--------------------------------------------------
-- SLASH COMMAND
--------------------------------------------------
SLASH_TICTACHINTS1="/tth"
SlashCmdList.TICTACHINTS=function()
    frame:SetShown(not frame:IsShown())
end
