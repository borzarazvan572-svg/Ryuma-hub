-- [[ RYUMA HUB - THE FINAL PRO EDITION ]] --
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- VALORI SETARI (Din imaginile tale)
_G.DuelSpeed = 60
_G.AimBot = false
_G.AutoLeft = false
_G.AutoRight = false
_G.StealDistance = 7
_G.AntiRagdoll = false
_G.InfJump = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyumaFinal"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- --- 1. HEADER & LOGO ---
local Header = Instance.new("Frame", ScreenGui)
Header.Size = UDim2.new(0, 240, 0, 35)
Header.Position = UDim2.new(0.5, -120, 0.02, 0)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", Header)

local InfoText = Instance.new("TextLabel", Header)
InfoText.Size = UDim2.new(1, 0, 1, 0)
InfoText.Text = "FPS: 60 | RYUMA HUB | 40:PING"
InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoText.BackgroundTransparency = 1
InfoText.Font = Enum.Font.GothamBold

-- --- 2. BUTOANE ECRAN (LATERALE) ---
local function AddScreenBtn(text, pos, callback)
    local btn = Instance.new("TextButton", ScreenGui)
    btn.Size = UDim2.new(0, 110, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.Text = text:upper()
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local act = false
    btn.MouseButton1Click:Connect(function()
        act = not act
        btn.BackgroundColor3 = act and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
        callback(act)
    end)
end

-- Butoanele de actiune rapida
AddScreenBtn("Menu", UDim2.new(0.05, 0, 0.1, 0), function() ScreenGui.MainFrame.Visible = not ScreenGui.MainFrame.Visible end)
AddScreenBtn("Auto Left", UDim2.new(0.8, 0, 0.2, 0), function(v) _G.AutoLeft = v end)
AddScreenBtn("Auto Right", UDim2.new(0.8, 0, 0.3, 0), function(v) _G.AutoRight = v end)
AddScreenBtn("Aim Bat", UDim2.new(0.05, 0, 0.25, 0), function(v) _G.AimBot = v end)
AddScreenBtn("TP Down", UDim2.new(0.05, 0, 0.35, 0), function() root.CFrame *= CFrame.new(0,-12,0) end)

-- --- 3. MENIUL CENTRAL (SETTINGS & SPEED) ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 350)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Content = Instance.new("ScrollingFrame", MainFrame)
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", Content)
layout.Padding = UDim.new(0, 8)

local function AddToggle(text, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

-- Toggle-uri esentiale
AddToggle("Anti-Ragdoll", function(v) _G.AntiRagdoll = v end)
AddToggle("Inf Jump", function(v) _G.InfJump = v end)
AddToggle("Optimizer", function(v) if v then for _,o in pairs(game:GetDescendants()) do if o:IsA("Decal") then o.Transparency = 1 end end end end)

-- Speed Slider (Simulat prin buton)
local SpeedBtn = Instance.new("TextButton", Content)
SpeedBtn.Size = UDim2.new(1, 0, 0, 35)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
SpeedBtn.Text = "DUEL SPEED: " .. _G.DuelSpeed
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.MouseButton1Click:Connect(function()
    _G.DuelSpeed = (_G.DuelSpeed == 60) and 100 or 60
    SpeedBtn.Text = "DUEL SPEED: " .. _G.DuelSpeed
end)

-- --- 4. LOGICA FUNCTIONALA ---
task.spawn(function()
    while task.wait() do
        if _G.AntiRagdoll and hum then hum.PlatformStand = false end
        
        -- Mecanica Auto Left (Steal & Back)
        if _G.AutoLeft then
            root.CFrame = root.CFrame * CFrame.new(-_G.StealDistance, 0, 0)
            task.wait(0.1)
            root.CFrame = root.CFrame * CFrame.new(_G.StealDistance, 0, 0)
            _G.AutoLeft = false
        end

        -- Mecanica Auto Right
        if _G.AutoRight then
            root.CFrame = root.CFrame * CFrame.new(_G.StealDistance, 0, 0)
            task.wait(0.1)
            root.CFrame = root.CFrame * CFrame.new(-_G.StealDistance, 0, 0)
            _G.AutoRight = false
        end

        -- Speed & Aim
        if hum.MoveDirection.Magnitude > 0 then
            root.Velocity = Vector3.new(hum.MoveDirection.X * _G.DuelSpeed, root.Velocity.Y, hum.MoveDirection.Z * _G.DuelSpeed)
        end
    end
end)
