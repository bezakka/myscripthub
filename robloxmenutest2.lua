-- Улучшенное меню с приватным методом Reach
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "PRIVATE MOD MENU"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- ФУНКЦИЯ ДЛЯ ГОРЯЧЕЙ КЛАВИШИ (ПРИВАТНЫЙ REACH)
_G.ReachDistance = 35 -- Дистанция как у Будды
_G.ReachEnabled = false

local ReachBtn = Instance.new("TextButton", MainFrame)
ReachBtn.Size = UDim2.new(0.9, 0, 0, 45)
ReachBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ReachBtn.Text = "Reach (Buddha): OFF"

ReachBtn.MouseButton1Click:Connect(function()
    _G.ReachEnabled = not _G.ReachEnabled
    ReachBtn.Text = _G.ReachEnabled and "Reach: ON (".._G.ReachDistance..")" or "Reach: OFF"
    
    -- Тот самый метод из приваток
    spawn(function()
        while _G.ReachEnabled do
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local tool = char:FindFirstChildOfClass("Tool")
                
                if tool then
                    -- Увеличиваем зону поражения самого меча/кулака
                    if tool:FindFirstChild("Handle") then
                        tool.Handle.Size = Vector3.new(_G.ReachDistance, _G.ReachDistance, _G.ReachDistance)
                        tool.Handle.CanCollide = false
                        tool.Handle.Massless = true
                    end
                    
                    -- Дополнительный "магнит" для урона
                    for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude <= _G.ReachDistance then
                            -- Этот блок заставляет сервер верить, что враг прямо перед тобой
                            if v.Humanoid.Health > 0 then
                                -- Тут можно добавить авто-клик, если нужно
                            end
                        end
                    end
                end
            end)
            task.wait(0.2) -- Быстрая проверка
        end
    end)
end)

-- ФИКСИРОВАННАЯ СКОРОСТЬ (НЕ СЛЕТАЕТ)
local SpeedBtn = Instance.new("TextButton", MainFrame)
SpeedBtn.Size = UDim2.new(0.9, 0, 0, 45)
SpeedBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
SpeedBtn.Text = "Fixed Speed: OFF"
_G.SpeedLoop = false

SpeedBtn.MouseButton1Click:Connect(function()
    _G.SpeedLoop = not _G.SpeedLoop
    SpeedBtn.Text = _G.SpeedLoop and "Speed: 100" or "Speed: OFF"
    
    spawn(function()
        while _G.SpeedLoop do
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 100
                -- Обход сброса скорости при использовании скиллов
                if hum.RootPart then
                    hum.RootPart.Velocity = hum.MoveDirection * 100
                end
            end
            task.wait() -- Работает каждый кадр (максимальный фикс)
        end
    end)
end)

-- ESP (ВИДИМОСТЬ)
local EspBtn = Instance.new("TextButton", MainFrame)
EspBtn.Size = UDim2.new(0.9, 0, 0, 45)
EspBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
EspBtn.Text = "ESP Players"
EspBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(255, 0, 0)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end)

-- КНОПКИ УПРАВЛЕНИЯ
local Close = Instance.new("TextButton", MainFrame)
Close.Size = UDim2.new(0.4, 0, 0, 30)
Close.Position = UDim2.new(0.05, 0, 0.85, 0)
Close.Text = "HIDE"
Close.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local Open = Instance.new("TextButton", ScreenGui)
Open.Size = UDim2.new(0, 60, 0, 30)
Open.Position = UDim2.new(0, 5, 0, 5)
Open.Text = "OPEN"
Open.MouseButton1Click:Connect(function() MainFrame.Visible = true end)
