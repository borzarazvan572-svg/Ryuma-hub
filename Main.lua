-- [[ RYUMA HUB FINAL - FIXED SPEED, AIMBOT & AUTO STEAL ]] --

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- SETĂRI (VALORI MODIFICABILE)
_G.SpeedValue = 16
_G.InfJump = false
_G.AutoLeft = false
_G.AutoRight = false
_G.AimBot = false
_G.AutoSteal = false

-- 1. CREARE INTERFAȚĂ (BUTOANE DEZ LIPITE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyumaPro"
ScreenGui.Parent = game.CoreGui

local function CreateContainer(pos)
    local frame = Instance.new("Frame")
    frame.Parent = ScreenGui
    frame.Size = UDim2.new(0, 140, 0, 240)
    frame.Position = pos
    frame.BackgroundTransparency = 1 -- Invizibil pentru a vedea butoanele clar
    local layout = Instance.new("UIListLayout")
    layout.Parent = frame
    layout.Padding = UDim.new(0, 6)
    return frame
end

local LeftSide = CreateContainer(UDim2.new(0.02, 0, 0.3, 0))
local RightSide = CreateContainer(UDim2.new(0.85, 0, 0.3, 0))

local function AddBtn(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    btn.Parent = parent
end

-- --- BUTOANE STÂNGA (VITEZĂ, JUMP, AIM) ---
AddBtn("SPEED: 16", LeftSide, function(btn)
    if _G.SpeedValue == 16 then _G.SpeedValue = 50 
    elseif _G.SpeedValue == 50 then _G.SpeedValue = 100 
    else _G.SpeedValue = 16 end
    btn.Text = "SPEED: " .. _G.SpeedValue
end)

AddBtn("INF JUMP: OFF", LeftSide, function(btn)
    _G.InfJump = not _G.InfJump
    btn.Text = _G.InfJump and "INF JUMP: ON" or "INF JUMP: OFF"
end)

AddBtn("AIMBOT: OFF", LeftSide, function(btn)
    _G.AimBot = not _G.AimBot
    btn.Text = _G.AimBot and "AIMBOT: ON" or "AIMBOT: OFF"
end)

-- --- BUTOANE DREAPTA (MIȘCARE & STEAL) ---
AddBtn("AUTO LEFT: OFF", RightSide, function(btn)
    _G.AutoLeft = not _G.AutoLeft
    _G.AutoRight = false
    btn.Text = _G.AutoLeft and "LEFT: ON" or "LEFT: OFF"
end)

AddBtn("AUTO RIGHT: OFF", RightSide, function(btn)
    _G.AutoRight = not _G.AutoRight
    _G.AutoLeft = false
    btn.Text = _G.AutoRight and "RIGHT: ON" or "RIGHT: OFF"
end)

AddBtn("AUTO STEAL: OFF", RightSide, function(btn)
    _G.AutoSteal = not _G.AutoSteal
    btn.Text = _G.AutoSteal and "STEAL: ON" or "STEAL: OFF"
end)

AddBtn("TP DOWN", RightSide, function()
    root.CFrame = root.CFrame * CFrame.new(0, -10, 0)
end)

-- 2. LOGICĂ FUNCȚII (BUCLE)

-- Fix Speed (Folosește Velocity pentru a nu muri și a trece de anti-cheat)
task.spawn(function()
    while task.wait() do
        if hum and root and _G.SpeedValue > 16 then
            local dir = hum.MoveDirection
            root.Velocity = Vector3.new(dir.X * _G.SpeedValue, root.Velocity.Y, dir.Z * _G.SpeedValue)
        end
        if hum then hum.PlatformStand = false end -- Anti-Ragdoll
    end
end)

-- Auto Left/Right Safe (CFrame progresiv pentru a nu declanșa "Insta-Kill")
task.spawn(function()
    while task.wait(0.02) do
        if _G.AutoLeft and root then root.CFrame = root.CFrame * CFrame.new(-1.2, 0, 0) end
        if _G.AutoRight and root then root.CFrame = root.CFrame * CFrame.new(1.2, 0, 0) end
    end
end)

-- AimBot (Te rotește spre inamic)
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

-- Auto Steal (Colectează iteme prin firetouchinterest)
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

-- Inf Jump Fix
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and root then root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z) end
end)
