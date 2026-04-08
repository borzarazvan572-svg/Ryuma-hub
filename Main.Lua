-- [[ RYUGA HUB V4 - DRAGGABLE & PRO DUEL MODE ]] --

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- SETĂRI
_G.SpeedValue = 16
_G.InfJump = false
_G.AutoDuel = false -- Am combinat Left/Right într-un mod de Duel
_G.AimBot = false
_G.AutoSteal = false

-- 1. CREARE UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyugaHubV4"
ScreenGui.Parent = game.CoreGui

-- TITLU SUS (DRAGGABLE)
local MainTitle = Instance.new("TextLabel")
MainTitle.Parent = ScreenGui
MainTitle.Size = UDim2.new(0, 200, 0, 40)
MainTitle.Position = UDim2.new(0.5, -100, 0.05, 0)
MainTitle.Text = "RYUGA HUB"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
MainTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.TextSize = 20
MainTitle.Active = true
MainTitle.Draggable = true -- Îl poți mișca

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = MainTitle

-- CONTAINERE BUTOANE (DRAGGABLE)
local function CreateContainer(pos, name)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Parent = ScreenGui
    frame.Size = UDim2.new(0, 140, 0, 260)
    frame.Position = pos
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.7
    frame.Active = true
    frame.Draggable = true -- Acum poți mișca panourile cu butoane!
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = frame
    layout.Padding = UDim.new(0, 8)
    
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    
    return frame
end

local LeftSide = CreateContainer(UDim2.new(0.02, 0, 0.3, 0), "LeftPanel")
local RightSide = CreateContainer(UDim2.new(0.85, 0, 0.3, 0), "RightPanel")

local function AddBtn(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    btn.Parent = parent
    return btn
end

-- --- BUTOANE STÂNGA ---
local SpeedDisplay = AddBtn("SPEED: 16", LeftSide, function() end)

local SpeedControls = Instance.new("Frame")
SpeedControls.Size = UDim2.new(1, 0, 0, 30)
SpeedControls.BackgroundTransparency = 1
SpeedControls.Parent = LeftSide

local btnMinus = Instance.new("TextButton")
btnMinus.Size = UDim2.new(0.45, 0, 1, 0)
btnMinus.Text = "-"
btnMinus.Parent = SpeedControls
btnMinus.MouseButton1Click:Connect(function()
    _G.SpeedValue = math.max(16, _G.SpeedValue - 5)
    SpeedDisplay.Text = "SPEED: " .. _G.SpeedValue
end)

local btnPlus = Instance.new("TextButton")
btnPlus.Size = UDim2.new(0.45, 0, 1, 0)
btnPlus.Position = UDim2.new(0.55, 0, 0, 0)
btnPlus.Text = "+"
btnPlus.Parent = SpeedControls
btnPlus.MouseButton1Click:Connect(function()
    _G.SpeedValue = _G.SpeedValue + 5
    SpeedDisplay.Text = "SPEED: " .. _G.SpeedValue
end)

AddBtn("INF JUMP: OFF", LeftSide, function(btn)
    _G.InfJump = not _G.InfJump
    btn.Text = _G.InfJump and "INF JUMP: ON" or "INF JUMP: OFF"
end)

-- --- BUTOANE DREAPTA ---
AddBtn("PRO DUEL: OFF", RightSide, function(btn)
    _G.AutoDuel = not _G.AutoDuel
    btn.Text = _G.AutoDuel and "PRO DUEL: ON" or "PRO DUEL: OFF"
end)

AddBtn("AIMBOT: OFF", RightSide, function(btn)
    _G.AimBot = not _G.AimBot
    btn.Text = _G.AimBot and "AIMBOT: ON" or "AIMBOT: OFF"
end)

AddBtn("STEAL: OFF", RightSide, function(btn)
    _G.AutoSteal = not _G.AutoSteal
    btn.Text = _G.AutoSteal and "STEAL: ON" or "STEAL: OFF"
end)

AddBtn("TP DOWN", RightSide, function()
    root.CFrame = root.CFrame * CFrame.new(0, -12, 0)
end)

-- 2. LOGICA (PRO DUEL & FIZICĂ)

task.spawn(function()
    local t = 0
    while task.wait() do
        if hum and root then
            t = t + 0.1
            local moveDir = hum.MoveDirection
            local duelVel = Vector3.new(0,0,0)

            -- LOGICA DE DUEL (Stânga-Dreapta rapid + Înaintare ușoară)
            if _G.AutoDuel then
                local sideMag = math.sin(t * 10) * 35 -- Mișcare laterală rapidă (Oscilație)
                local forwardMag = 5 -- Împingere ușoară în față
                
                local cameraCF = workspace.CurrentCamera.CFrame
                duelVel = (cameraCF.RightVector * sideMag) + (cameraCF.LookVector * forwardMag)
            end

            -- Aplicăm viteza
            if _G.SpeedValue > 16 or _G.AutoDuel then
                root.Velocity = Vector3.new(
                    (moveDir.X * _G.SpeedValue) + duelVel.X,
                    root.Velocity.Y,
                    (moveDir.Z * _G.SpeedValue) + duelVel.Z
                )
            end
            hum.PlatformStand = false
        end
    end
end)

-- AIMBOT & AUTOSTEAL (Rămân neschimbate)
task.spawn(function()
    while task.wait() do
        if _G.AimBot then
            local target = nil
            local dist = 100
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; target = v.Character.HumanoidRootPart end
                end
            end
            if target then
                root.CFrame = CFrame.new(root.Position, Vector3.new(target.Position.X, root.Position.Y, target.Position.Z))
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSteal then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchInterest") and v.Parent then
                    firetouchinterest(root, v.Parent, 0)
                    task.wait()
                    firetouchinterest(root, v.Parent, 1)
                end
            end
        end
    end
end)

-- INF JUMP
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and root then root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z) end
end)
