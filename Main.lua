-- [[ RYUMA HUB - MOBILE SPLIT GUI ]] --

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- VARIABILE
_G.WalkSpeed = 16
_G.InfJump = false
_G.AutoDribble = false

-- 1. CREARE INTERFAȚĂ (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyumaGui"
ScreenGui.Parent = game.CoreGui

-- Funcție pentru panouri
local function CreatePanel(name, pos)
    local Frame = Instance.new("Frame")
    Frame.Name = name
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 140, 0, 180)
    Frame.Position = pos
    Frame.BackgroundTransparency = 0.5 -- Transparent să vezi jocul
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Frame
    Layout.Padding = UDim.new(0, 8)
    return Frame
end

-- Panou STÂNGA (Mugări/Mișcare)
local LeftPanel = CreatePanel("Left", UDim2.new(0.05, 0, 0.4, 0))
-- Panou DREAPTA (Luptă/Funcții)
local RightPanel = CreatePanel("Right", UDim2.new(0.8, 0, 0.4, 0))

-- Funcție pentru Butoane
local function AddBtn(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
    btn.Parent = parent
    return btn
end

-- --- BUTOANE STÂNGA ---
AddBtn("SPEED +10", LeftPanel, function()
    _G.WalkSpeed = _G.WalkSpeed + 10
end)

AddBtn("RESET SPEED", LeftPanel, function()
    _G.WalkSpeed = 16
end)

AddBtn("INF JUMP: OFF", LeftPanel, function(btn)
    _G.InfJump = not _G.InfJump
    btn.Text = _G.InfJump and "INF JUMP: ON" or "INF JUMP: OFF"
end)

-- --- BUTOANE DREAPTA ---
AddBtn("AUTO DRIB: OFF", RightPanel, function(btn)
    _G.AutoDribble = not _G.AutoDribble
    btn.Text = _G.AutoDribble and "AUTO DRIB: ON" or "AUTO DRIB: OFF"
end)

AddBtn("TP DOWN", RightPanel, function()
    root.CFrame = root.CFrame * CFrame.new(0, -10, 0)
end)

AddBtn("SEND TAUNT", RightPanel, function()
    local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chat then chat.SayMessageRequest:FireServer("RYUMA HUB ON TOP!", "All") end
end)

-- 2. LOGICA PENTRU FUNCȚII (Loop-uri)

-- Speed & Anti-Ragdoll
task.spawn(function()
    while task.wait() do
        if hum then 
            hum.WalkSpeed = _G.WalkSpeed 
            hum.PlatformStand = false -- Anti-Ragdoll
        end
    end
end)

-- Inf Jump Fix (Fără kill)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and root then
        root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
    end
end)

-- Auto Left/Right (Dribbling)
task.spawn(function()
    while task.wait(0.4) do
        if _G.AutoDribble and root then
            root.CFrame = root.CFrame * CFrame.new(7, 0, 0) -- Right
            task.wait(0.4)
            root.CFrame = root.CFrame * CFrame.new(-7, 0, 0) -- Left
        end
    end
end)

print("Ryuma Hub actualizat cu butoane separate!")
