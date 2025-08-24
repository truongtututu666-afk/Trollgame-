-- ====== Gen Z Troll Combo + GUI Thông Báo ======
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ====== GUI ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GenZTrollGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 350)
frame.Position = UDim2.new(0,50,0,50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- ====== Thông báo popup ======
local notif = Instance.new("TextLabel")
notif.Size = UDim2.new(0,220,0,40)
notif.Position = UDim2.new(0,10,0,300)
notif.BackgroundColor3 = Color3.fromRGB(40,40,40)
notif.TextColor3 = Color3.fromRGB(255,255,255)
notif.Text = ""
notif.Visible = false
notif.Parent = frame

local function showNotif(msg)
    notif.Text = msg
    notif.Visible = true
    delay(2, function() notif.Visible = false end) -- hiện 2 giây
end

-- Toggle Auto TP
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0,220,0,40)
tpBtn.Position = UDim2.new(0,10,0,10)
tpBtn.Text = "Auto TP: OFF"
tpBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.Parent = frame

local isTPOn = false
tpBtn.MouseButton1Click:Connect(function()
    isTPOn = not isTPOn
    tpBtn.Text = isTPOn and "Auto TP: ON" or "Auto TP: OFF"
    showNotif(isTPOn and "✅ Auto TP Bật!" or "❌ Auto TP Tắt!")
end)

-- Nhảy X1→X5
local speedSettings = {50,100,150,200,250}
local currentJump = speedSettings[1]

for i=1,5 do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,220,0,40)
    btn.Position = UDim2.new(0,10,0, 60 + (i-1)*45)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = "Jump X"..i
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        currentJump = speedSettings[i]
        showNotif("🏃 Jump X"..i.." Bật!")
    end)
end

-- ====== Troll logic ======
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Vật thể bay & âm thanh troll
local function spawnTrollObject(target)
    local part = Instance.new("Part", Workspace)
    part.Size = Vector3.new(2,2,2)
    part.Position = target.HumanoidRootPart.Position + Vector3.new(0,10,0)
    part.Anchored = true
    part.BrickColor = BrickColor.Random()

    local sound = Instance.new("Sound", part)
    sound.SoundId = "rbxassetid://301964312" -- nhạc troll vui
    sound.Looped = false
    sound.Volume = 1
    sound:Play()
end

-- RenderStepped loop
RunService.RenderStepped:Connect(function(deltaTime)
    -- Auto TP
    if isTPOn then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0,0,3)
            end
        end
    end

    -- Nhảy cao tự động theo currentJump
    humanoid.JumpPower = currentJump
    humanoid.WalkSpeed = 24

    -- Tạo vật thể troll ngẫu nhiên
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and math.random() < 0.01 then
            spawnTrollObject(plr.Character)
        end
    end
end)

print("✅ Gen Z Troll Combo sẵn sàng! GUI + Auto TP + Jump X1→X5 + vật thể + âm thanh troll!")
