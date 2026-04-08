-- RYUMA DUELS (LOADER + HUB + ANTI-DEATH FIX)
local lp = game.Players.LocalPlayer
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "RyumaHub"

-- 1. LOADERUL (SA SE VADA CA IN LINK-UL TAU)
local Loader = Instance.new("Frame", sg)
Loader.Size = UDim2.new(0, 220, 0, 90)
Loader.Position = UDim2.new(0.5, -110, 0.5, -45)
Loader.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Loader.BorderSizePixel = 0
Instance.new("UICorner", Loader).CornerRadius = UDim.new(0, 15)

local LTitle = Instance.new("TextLabel", Loader)
LTitle.Text = "RYUMA HUB"
LTitle.Size = UDim2.new(1, 0, 0.6, 0)
LTitle.BackgroundTransparency = 1
LTitle.TextColor3 = Color3.new(1, 1, 1)
LTitle.Font = Enum.Font.GothamBold
LTitle.TextSize = 18

local LStatus = Instance.new("TextLabel", Loader)
LStatus.Text = "Checking Script..."
LStatus.Position = UDim2.new(0, 0, 0.5, 0)
LStatus.Size = UDim2.new(1, 0, 0.4, 0)
LStatus.BackgroundTransparency = 1
LStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
LStatus.Font = Enum.Font.Gotham
LStatus.TextSize = 12

-- SIMULARE INCARCARE
task.wait(1.2)
LStatus.Text = "Loading Features..."
task.wait(0.8)
Loader:Destroy()

-- 2. FUNCTIA DE CREARE BUTOANE (DESIGNUL TAU 100%)
local function CreateBtn(name, pos, callback)
    local b = Instance.new("TextButton", sg)
    b.Text = name
    b.Size = UDim2.new(0, 110, 0, 35)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.Draggable = true
    b.Active = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    local st = false
    b.MouseButton1Click:Connect(function()
        st = not st
        b.TextColor3 = st and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
        callback(st)
    end)
end

-- 3. LOGICA PENTRU CARACTER (SA NU SE STRICE CAND MORI)
local char = lp.Character or lp.CharacterAdded:Wait()
lp.CharacterAdded:Connect(function(newChar)
    char = newChar
end)

-- 4. BUTOANELE TALE FUNCTIONALE
CreateBtn("AIM BAT", UDim2.new(0.2, 0, 0.2, 0), function(s)
    _G.AimBat = s
    task.spawn(function()
        while _G.AimBat do
            task.wait()
            pcall(function()
                local target = nil
                local dist = 100
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then dist = d; target = v end
                    end
                end
                if target then
                    char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position, Vector3.new(target.Character.HumanoidRootPart.Position.X, char.HumanoidRootPart.Position.Y, target.Character.HumanoidRootPart.Position.Z))
                end
            end)
        end
    end)
end)

CreateBtn("TP DOWN", UDim2.new(0.2, 0, 0.3, 0), function(s)
    pcall(function()
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, s and -8 or 8, 0)
    end)
end)

CreateBtn("SPEED 60", UDim2.new(0.2, 0, 0.4, 0), function(s)
    _G.Speed60 = s
    task.spawn(function()
        while _G.Speed60 do
            task.wait()
            if char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 60
            end
        end
        if char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 16 end
    end)
end)

CreateBtn("INF JUMP", UDim2.new(0.2, 0, 0.5, 0), function(s)
    _G.IJ = s
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.IJ and char:FindFirstChild("Humanoid") then
        char.Humanoid:ChangeState(3)
    end
end)
