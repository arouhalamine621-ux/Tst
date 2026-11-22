-- XV FLAG CHECKER - compact standalone UI
-- UI is scaled to 50% for smaller phone screens.
-- Uses the same cached FocusLost + Activated form-handler submission path.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local parent = player:WaitForChild("PlayerGui")

local old = parent:FindFirstChild("XVFlagChecker")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(12, 14, 20), panel = Color3.fromRGB(20, 23, 32),
    panel2 = Color3.fromRGB(28, 32, 44), stroke = Color3.fromRGB(49, 56, 74),
    text = Color3.fromRGB(239, 242, 250), muted = Color3.fromRGB(143, 151, 170),
    accent = Color3.fromRGB(119, 92, 255), green = Color3.fromRGB(91, 208, 146),
    amber = Color3.fromRGB(245, 184, 76), red = Color3.fromRGB(235, 93, 105),
}

local function make(class, props, parentObj)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parentObj
    return obj
end

local function corner(obj, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, obj)
end

local function label(parentObj, value, size, color, font, pos, dims)
    return make("TextLabel", {
        BackgroundTransparency = 1, Text = value, TextColor3 = color or C.text,
        TextSize = size or 13, Font = font or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
        Position = pos or UDim2.new(), Size = dims or UDim2.new(1, 0, 0, 22),
    }, parentObj)
end

local gui = make("ScreenGui", {
    Name = "XVFlagChecker", ResetOnSpawn = false,
    IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, parent)

local window = make("Frame", {
    Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(390, 405),
    BackgroundColor3 = C.bg, BorderSizePixel = 0, ClipsDescendants = true,
}, gui)
make("UIScale", {Scale = 0.5}, window)
corner(window, 15)
make("UIStroke", {Color = C.stroke, Thickness = 1}, window)

local top = make("Frame", {
    Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = C.panel, BorderSizePixel = 0
}, window)
local accent = make("Frame", {
    Position = UDim2.fromOffset(0, 9), Size = UDim2.new(0, 4, 1, -18),
    BackgroundColor3 = C.accent, BorderSizePixel = 0
}, top)
corner(accent, 4)

label(top, "XV TOOLS", 10, C.muted, Enum.Font.GothamBold,
    UDim2.fromOffset(18, 7), UDim2.new(1, -100, 0, 14))
label(top, "XV Flag Checker", 17, C.text, Enum.Font.GothamBold,
    UDim2.fromOffset(18, 24), UDim2.new(1, -105, 0, 23))

local close = make("TextButton", {
    Text = "×", TextSize = 22, Font = Enum.Font.Gotham, TextColor3 = C.muted,
    BackgroundColor3 = C.panel2, AutoButtonColor = false,
    Size = UDim2.fromOffset(32, 32), Position = UDim2.new(1, -44, 0, 14)
}, top)
corner(close, 9)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local body = make("Frame", {
    BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 75),
    Size = UDim2.new(1, -32, 1, -90)
}, window)

label(body, "SEQUENTIAL CODE TIMING", 10, C.muted, Enum.Font.GothamBold,
    UDim2.fromOffset(2, 0), UDim2.new(1, -4, 0, 18))
label(body, "10s between codes  •  sold-out response timing", 11, C.muted,
    Enum.Font.Gotham, UDim2.fromOffset(2, 20), UDim2.new(1, -4, 0, 25))

local codes = {"NOVA", "DRAGON", "SAMMY", "DIVINECURSED"}
local rows = {}

for i, code in ipairs(codes) do
    local row = make("Frame", {
        Position = UDim2.fromOffset(0, 54 + (i - 1) * 42),
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = C.panel, BorderSizePixel = 0
    }, body)
    corner(row, 8)
    label(row, code, 11, C.text, Enum.Font.GothamBold,
        UDim2.fromOffset(11, 0), UDim2.new(0.55, -11, 1, 0))
    local value = label(row, "NOT TESTED", 10, C.muted, Enum.Font.GothamBold,
        UDim2.new(0.55, 0, 0, 0), UDim2.new(0.45, -10, 1, 0))
    value.TextXAlignment = Enum.TextXAlignment.Right
    rows[code] = value
end

local resultPanel = make("Frame", {
    Position = UDim2.fromOffset(0, 226), Size = UDim2.new(1, 0, 0, 54),
    BackgroundColor3 = C.panel, BorderSizePixel = 0
}, body)
corner(resultPanel, 9)
make("UIStroke", {Color = C.stroke, Thickness = 1}, resultPanel)
local resultText = label(resultPanel, "RESULT: NOT CHECKED", 14, C.muted,
    Enum.Font.GothamBold, UDim2.fromOffset(12, 0), UDim2.new(1, -24, 1, 0))

local toggle = make("TextButton", {
    Name = "FlagCheck", Position = UDim2.fromOffset(0, 292),
    Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = C.accent,
    BorderSizePixel = 0, AutoButtonColor = false,
    Text = "FLAG CHECK  •  OFF", TextColor3 = Color3.new(1, 1, 1),
    TextSize = 13, Font = Enum.Font.GothamBold
}, body)
corner(toggle, 10)

label(body, "GREEN: under 2.0s  •  RED: 2.0s or longer / no reply", 10,
    C.muted, Enum.Font.Gotham, UDim2.fromOffset(2, 342), UDim2.new(1, -4, 0, 22))

-- Draggable window
local dragging, dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, window.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Cache the game's Codes form handlers
local redeemCache = {box = nil, btn = nil, actFns = nil, lostFns = nil}

local function grabFns(signal)
    local out = {}
    local gc = getconnections or (debug and debug.getconnections)
    if type(gc) ~= "function" or not signal then return out end
    local ok, list = pcall(gc, signal)
    if not ok or type(list) ~= "table" then return out end

    for _, conn in ipairs(list) do
        if conn and conn.Enabled ~= false and type(conn.Function) == "function" then
            out[#out + 1] = conn.Function
        end
    end
    return out
end

local function warmCodesForm()
    local pg = player:FindFirstChildOfClass("PlayerGui")
    if not pg then return false, "NO PLAYERGUI" end
    local root = pg:FindFirstChild("Codes")
    if not root then return false, "CODES FORM NOT FOUND" end
    pcall(function() root.Enabled = true end)

    local box, btn = redeemCache.box, redeemCache.btn
    if not (box and box.Parent and btn and btn.Parent) then
        box, btn = nil, nil

        for _, obj in ipairs(root:GetDescendants()) do
            if not box and obj:IsA("TextBox") then box = obj end
            if not btn and obj:IsA("GuiButton") then
                local n = (obj.Name or ""):lower()
                if n == "confirm" or n == "submit" or n == "redeem"
                    or n:find("confirm", 1, true) or n:find("submit", 1, true)
                    or n:find("redeem", 1, true) then
                    btn = obj
                end
            end
            if box and btn then break end
        end

        if box and not btn then
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("GuiButton") then btn = obj break end
            end
        end

        redeemCache.box, redeemCache.btn = box, btn
        redeemCache.actFns, redeemCache.lostFns = nil, nil
    end

    if not box or not btn then return false, "TEXTBOX / SUBMIT BUTTON NOT FOUND" end
    if not redeemCache.actFns or #redeemCache.actFns == 0 then
        redeemCache.actFns = grabFns(btn.Activated)
        redeemCache.lostFns = grabFns(box.FocusLost)
    end
    return true
end

local function submitCode(code)
    local ready, why = warmCodesForm()
    if not ready then return false, why end

    local box = redeemCache.box
    box.Text = tostring(code):upper():gsub("%s+", ""):gsub("[^%w_%-]", "")

    for _, fn in ipairs(redeemCache.lostFns or {}) do
        if fn then pcall(fn) end
    end

    local fired = false
    for _, fn in ipairs(redeemCache.actFns or {}) do
        if fn and pcall(fn) then fired = true end
    end

    if not fired then
        local fs = firesignal or (debug and debug.firesignal)
        if type(fs) == "function" then
            pcall(fs, box.FocusLost)
            local ok = pcall(fs, redeemCache.btn.Activated)
            if ok then fired = true end
        end
    end

    return fired, fired and "SUBMIT HANDLER FIRED" or "NO SUBMIT HANDLER FIRED"
end

local function setStatus(code, value, color)
    if rows[code] and rows[code].Parent then
        rows[code].Text = value
        rows[code].TextColor3 = color or C.muted
    end
end

local function collectReplySnapshot()
    local snap = {}
    local pg = player:FindFirstChildOfClass("PlayerGui")
    if not pg then return snap end

    for _, obj in ipairs(pg:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local ok, value = pcall(function() return obj.Text end)
            if ok and type(value) == "string" and value ~= "" then snap[obj] = value end
        end
    end
    return snap
end

local function findNewSoldOut(before)
    local pg = player:FindFirstChildOfClass("PlayerGui")
    if not pg then return nil end

    for _, obj in ipairs(pg:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local ok, value = pcall(function() return obj.Text end)
            if ok and type(value) == "string" then
                local lower = value:lower()
                local soldOut = lower:find("sold out", 1, true)
                    or lower:find("soldout", 1, true)
                if soldOut and (before[obj] == nil or before[obj] ~= value) then
                    return value
                end
            end
        end
    end
    return nil
end

local running = false
local RESPONSE_TIMEOUT, GAP_SECONDS, FLAG_THRESHOLD = 12, 10, 2.0

toggle.MouseButton1Click:Connect(function()
    if running then return end
    running = true
    toggle.Text = "FLAG CHECK  •  RUNNING"
    toggle.BackgroundColor3 = C.panel2
    resultText.Text = "CHECKING..."
    resultText.TextColor3 = C.amber

    for _, code in ipairs(codes) do setStatus(code, "WAITING", C.muted) end

    task.spawn(function()
        local flaggedCount, cleanCount, unknownCount = 0, 0, 0

        for index, code in ipairs(codes) do
            if not gui.Parent then break end

            local before = collectReplySnapshot()
            task.wait(0.05)
            local started = os.clock()
            local callOK, fired, detail = pcall(submitCode, code)

            if not callOK or not fired then
                unknownCount += 1
                setStatus(code, "SUBMIT FAILED", C.red)
            else
                local reply
                while gui.Parent and os.clock() - started < RESPONSE_TIMEOUT do
                    reply = findNewSoldOut(before)
                    if reply then break end
                    task.wait(0.03)
                end

                local elapsed = os.clock() - started
                if reply and elapsed < FLAG_THRESHOLD then
                    cleanCount += 1
                    setStatus(code, string.format("UNFLAGGED • %.2fs", elapsed), C.green)
                elseif reply then
                    flaggedCount += 1
                    setStatus(code, string.format("FLAGGED • %.2fs", elapsed), C.red)
                else
                    unknownCount += 1
                    setStatus(code, string.format("NO SOLD-OUT REPLY • %dms",
                        math.floor(elapsed * 1000 + 0.5)), C.red)
                end
            end

            if index < #codes and gui.Parent then
                for remaining = GAP_SECONDS, 1, -1 do
                    if not gui.Parent then break end
                    toggle.Text = "NEXT CODE IN " .. remaining .. "s"
                    task.wait(1)
                end
            end
        end

        if gui.Parent then
            if flaggedCount > 0 or unknownCount > 0 then
                resultText.Text = string.format(
                    "RESULT: %d FLAGGED • %d CLEAN • %d UNKNOWN",
                    flaggedCount, cleanCount, unknownCount
                )
                resultText.TextColor3 = C.red
            else
                resultText.Text = string.format("RESULT: UNFLAGGED • %d/4 CLEAN", cleanCount)
                resultText.TextColor3 = C.green
            end
            toggle.Text = "FLAG CHECK  •  OFF"
            toggle.BackgroundColor3 = C.accent
        end
        running = false
    end)
end)
