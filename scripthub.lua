-- BF SHARK HUB 🦈 (DEV: ZXCIMPACT) - ULTIMATE VERSION
local SharkHub = {}
SharkHub.States = {
    SharkAura = false,
    SharkSpeed = false,
    AutoClick = false,
    AutoFarm = false,
    NoClip = false,
    InfiniteJump = false,
    FlyMode = false
}
SharkHub.Connections = {}
SharkHub.Settings = {
    Speed = 100,
    JumpPower = 50,
    ClickDelay = 0.1,
    FlySpeed = 2
}

-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Utility Functions
local function safeCall(func)
    local success, err = pcall(func)
    if not success then
        warn("SharkHub Error:", err)
    end
end

local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 8)
    corner.Parent = parent
    return corner
end

local function createUIStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 2
    stroke.Parent = parent
    return stroke
end

local function notify(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "SHARK HUB 🦈",
        Text = text,
        Duration = 3
    })
end

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SharkHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 550)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

createUICorner(MainFrame)
createUIStroke(MainFrame, Color3.fromRGB(0, 150, 255))

-- ScrollingFrame for buttons
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -60)
ScrollFrame.Position = UDim2.new(0, 5, 0, 55)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
ScrollFrame.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "SHARK HUB | zxcimpact 🦈"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.BackgroundColor3 = Color3.fromRGB(15, 30, 45)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame
createUICorner(Title)

-- Button Factory
local yOffset = 10
local function createButton(name, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yOffset)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = ScrollFrame
    createUICorner(btn)
    
    btn.MouseButton1Click:Connect(function()
        safeCall(callback)
    end)
    
    yOffset = yOffset + 50
    return btn
end

-- Slider Factory
local function createSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 60)
    frame.Position = UDim2.new(0.05, 0, 0, yOffset)
    frame.BackgroundColor3 = Color3.fromRGB(20, 30, 40)
    frame.Parent = ScrollFrame
    createUICorner(frame)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 5)
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = frame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(0.9, 0, 0, 20)
    slider.Position = UDim2.new(0.05, 0, 0, 30)
    slider.Text = ""
    slider.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
    slider.Parent = frame
    createUICorner(slider)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.Parent = slider
    createUICorner(fill)
    
    local dragging = false
    slider.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = LocalPlayer:GetMouse()
            local relPos = math.clamp((mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(relPos, 0, 1, 0)
            local value = math.floor(min + (max - min) * relPos)
            label.Text = name .. ": " .. value
            callback(value)
        end
    end)
    
    yOffset = yOffset + 70
    return frame
end

-- Feature 1: Shark Aura (Reach)
local sharkAuraBtn = createButton("SHARK AURA: OFF", Color3.fromRGB(30, 50, 70), function()
    SharkHub.States.SharkAura = not SharkHub.States.SharkAura
    sharkAuraBtn.Text = SharkHub.States.SharkAura and "SHARK AURA: ON" or "SHARK AURA: OFF"
    sharkAuraBtn.BackgroundColor3 = SharkHub.States.SharkAura and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 50, 70)
    notify(SharkHub.States.SharkAura and "Shark Aura Enabled" or "Shark Aura Disabled")
    
    if SharkHub.States.SharkAura then
        SharkHub.Connections.SharkAura = task.spawn(function()
            while SharkHub.States.SharkAura do
                safeCall(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Handle") then
                        tool.Handle.Size = Vector3.new(45, 45, 45)
                        tool.Handle.CanCollide = false
                        tool.Handle.Transparency = 0.8
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)

-- Feature 2: Anti-Stun
createButton("ANTI-STUN: ACTIVATE", Color3.fromRGB(30, 50, 70), function()
    notify("Anti-Stun Activated")
    SharkHub.Connections.AntiStun = task.spawn(function()
        while task.wait(0.1) do
            safeCall(function()
                local char = LocalPlayer.Character
                if not char then return end
                
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
                
                local stun = char:FindFirstChild("Stun")
                if stun then stun:Destroy() end
                
                local busy = char:FindFirstChild("Busy")
                if busy then busy:Destroy() end
            end)
        end
    end)
end)

-- Feature 3: Shark Speed with Slider
local speedBtn = createButton("SHARK SPEED: OFF", Color3.fromRGB(30, 50, 70), function()
    SharkHub.States.SharkSpeed = not SharkHub.States.SharkSpeed
    speedBtn.Text = SharkHub.States.SharkSpeed and "SHARK SPEED: ON" or "SHARK SPEED: OFF"
    speedBtn.BackgroundColor3 = SharkHub.States.SharkSpeed and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 50, 70)
    notify(SharkHub.States.SharkSpeed and "Shark Speed Enabled" or "Shark Speed Disabled")
    
    if SharkHub.States.SharkSpeed then
        SharkHub.Connections.SharkSpeed = task.spawn(function()
            while SharkHub.States.SharkSpeed do
                safeCall(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = SharkHub.Settings.Speed
                        if humanoid.MoveDirection.Magnitude > 0 then
                            char:TranslateBy(humanoid.MoveDirection * 0.4)
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
end)

createSlider("Speed", 16, 200, 100, function(val)
    SharkHub.Settings.Speed = val
end)

-- Feature 4: Auto Clicker with Slider
local clickBtn = createButton("AUTO CLICKER: OFF", Color3.fromRGB(30, 50, 70), function()
    SharkHub.States.AutoClick = not SharkHub.States.AutoClick
    clickBtn.Text = SharkHub.States.AutoClick and "AUTO CLICKER: ON" or "AUTO CLICKER: OFF"
    clickBtn.BackgroundColor3 = SharkHub.States.AutoClick and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 50, 70)
    notify(SharkHub.States.AutoClick and "Auto Clicker Enabled" or "Auto Clicker Disabled")
    
    if SharkHub.States.AutoClick then
        SharkHub.Connections.AutoClick = task.spawn(function()
            while SharkHub.States.AutoClick do
                safeCall(function()
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.01)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end)
                task.wait(SharkHub.Settings.ClickDelay)
            end
        end)
    end
end)

createSlider("Click Delay (ms)", 10, 500, 100, function(val)
    SharkHub.Settings.ClickDelay = val / 1000
end)

-- Feature 5: Infinite Jump
local jumpBtn = createButton("INFINITE JUMP: OFF", Color3.fromRGB(30, 50, 70), function()
    SharkHub.States.InfiniteJump = not SharkHub.States.InfiniteJump
    jumpBtn.Text = SharkHub.States.InfiniteJump and "INFINITE JUMP: ON" or "INFINITE JUMP: OFF"
    jumpBtn.BackgroundColor3 = SharkHub.States.InfiniteJump and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 50, 70)
    notify(SharkHub.States.InfiniteJump and "Infinite Jump Enabled" or "Infinite Jump Disabled")
end)

UserInputService.JumpRequest:Connect(function()
    if SharkHub.States.InfiniteJump then
        safeCall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)

-- Feature 6: NoClip
local noclipBtn = createButton("NOCLIP: OFF", Color3.fromRGB(30, 50, 70), function()
    SharkHub.States.NoClip = not SharkHub.States.NoClip
    noclipBtn.Text = SharkHub.States.NoClip and "NOCLIP: ON" or "NOCLIP: OFF"
    noclipBtn.BackgroundColor3 = SharkHub.States.NoClip and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 50, 70)
    notify(SharkHub.States.NoClip and "NoClip Enabled" or "NoClip Disabled")
    
    if SharkHub.States.NoClip then
        SharkHub.Connections.NoClip = RunService.Stepped:Connect(function()
            safeCall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end)
    else
        if SharkHub.Connections.NoClip then
            SharkHub.Connections.NoClip:Disconnect()
        end
    end
end)

-- Feature 7: Fly Mode
local flyBtn = createButton("FLY MODE: OFF", Color3.fromRGB(30, 50, 70), function()
    SharkHub.States.FlyMode = not SharkHub.States.FlyMode
    flyBtn.Text = SharkHub.States.FlyMode and "FLY MODE: ON (E)" or "FLY MODE: OFF"
    flyBtn.BackgroundColor3 = SharkHub.States.FlyMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(30, 50, 70)
    notify(SharkHub.States.FlyMode and "Fly Mode: Press E to toggle" or "Fly Mode Disabled")
end)

local flying = false
local flyConnection
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E and SharkHub.States.FlyMode then
        flying = not flying
        
        if flying then
            local char = LocalPlayer.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                local bg = Instance.new("BodyGyro", rootPart)
                bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                
                local bv = Instance.new("BodyVelocity", rootPart)
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Velocity = Vector3.new(0, 0, 0)
                
                flyConnection = RunService.RenderStepped:Connect(function()
                    if not flying then return end
                    
                    local camera = workspace.CurrentCamera
                    bg.CFrame = camera.CFrame
                    
                    local velocity = Vector3.new(0, 0, 0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        velocity = velocity + camera.CFrame.LookVector * SharkHub.Settings.FlySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        velocity = velocity - camera.CFrame.LookVector * SharkHub.Settings.FlySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        velocity = velocity - camera.CFrame.RightVector * SharkHub.Settings.FlySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        velocity = velocity + camera.CFrame.RightVector * SharkHub.Settings.FlySpeed
                    end
                    
                    bv.Velocity = velocity
                end)
            end
        else
            if flyConnection then flyConnection:Disconnect() end
            local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, v in pairs(rootPart:GetChildren()) do
                    if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
                        v:Destroy()
                    end
                end
            end
        end
    end
end)

createSlider("Fly Speed", 1, 10, 2, function(val)
    SharkHub.Settings.FlySpeed = val
end)

-- Feature 8: ESP
createButton("ESP: ACTIVATE", Color3.fromRGB(30, 50, 70), function()
    notify("ESP Activated")
    for _, obj in pairs(workspace:GetDescendants()) do
        safeCall(function()
            if obj:IsA("Tool") and obj.Name:match("Fruit") then
                if not obj:FindFirstChildOfClass("Highlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = obj
                end
            end
        end)
    end
end)

-- Feature 9: Teleport to Player
createButton("TP TO PLAYER", Color3.fromRGB(0, 100, 200), function()
    local playerName = ""
    -- Simple input prompt (you'd need to add a TextBox UI for this)
    notify("Feature requires custom input UI")
end)

-- Feature 10: Admin Panel
createButton("INFINITE YIELD", Color3.fromRGB(0, 100, 200), function()
    notify("Loading Infinite Yield...")
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

-- Feature 11: Reset Character
createButton("RESET CHARACTER", Color3.fromRGB(100, 50, 0), function()
    safeCall(function()
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
    end)
end)

-- Feature 12: Destroy All
createButton("DESTROY HUB", Color3.fromRGB(150, 0, 0), function()
    notify("Destroying Shark Hub...")
    for _, connection in pairs(SharkHub.Connections) do
        if typeof(connection) == "thread" then
            task.cancel(connection)
        elseif typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    if flyConnection then flyConnection:Disconnect() end
    ScreenGui:Destroy()
end)

-- Close Button
createButton("CLOSE MENU", Color3.fromRGB(100, 0, 0), function()
    MainFrame.Visible = false
end)

-- Open Button
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 60, 0, 60)
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.Text = "🦈"
OpenButton.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 24
OpenButton.Parent = ScreenGui
createUICorner(OpenButton, UDim.new(1, 0))
createUIStroke(OpenButton, Color3.fromRGB(0, 150, 255))

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
end)

-- Keybind to toggle UI (Right Shift)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

notify("🦈 SHARK HUB Ultimate Loaded!")
print("🦈 SHARK HUB Ultimate Version loaded successfully!")
print("Press Right Shift to toggle UI")
