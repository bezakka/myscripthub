local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("MOD MENU: BLOX FRUITS EDITION", "Midnight")

-- Глобальные настройки
_G.AttackRange = 15
_G.AutoAttack = false

-- ВКЛАДКА: СРАЖЕНИЕ
local CombatTab = Window:NewTab("Бой")
local CombatSection = CombatTab:NewSection("Улучшения атаки")

CombatSection:NewSlider("Дальность ударов (Range)", "Как у Будды (аккуратно!)", 50, 15, function(v)
    _G.AttackRange = v
end)

CombatSection:NewToggle("Включить Reach/Range", "Удары будут доставать дальше", function(state)
    _G.AutoRange = state
    spawn(function()
        while _G.AutoRange do
            pcall(function()
                -- Увеличиваем хитбокс активного оружия
                local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    tool.Handle.Size = Vector3.new(_G.AttackRange, _G.AttackRange, _G.AttackRange)
                    tool.Handle.CanCollide = false
                end
            end)
            task.wait(0.5)
        end
    end)
end)

-- ВКЛАДКА: ESP (ВИЗУАЛЫ)
local VisualTab = Window:NewTab("Визуал/ESP")
local VSection = VisualTab:NewSection("Продвинутый ESP")

VSection:NewButton("Включить Full ESP", "Ники + Дистанция + ХП", function()
    local function createESP(plr)
        local bgui = Instance.new("BillboardGui", plr.Character.Head)
        bgui.Name = "ESP_UI"
        bgui.AlwaysOnTop = true
        bgui.Size = UDim2.new(0, 200, 0, 50)
        bgui.StudsOffset = Vector3.new(0, 3, 0)

        local info = Instance.new("TextLabel", bgui)
        info.Size = UDim2.new(1, 0, 1, 0)
        info.BackgroundTransparency = 1
        info.TextColor3 = Color3.fromRGB(255, 0, 0)
        info.TextStrokeTransparency = 0
        info.TextScaled = false
        info.TextSize = 14

        spawn(function()
            while plr and plr.Character and plr.Character:FindFirstChild("Head") do
                local dist = math.floor((game.Players.LocalPlayer.Character.Head.Position - plr.Character.Head.Position).Magnitude)
                local hp = math.floor(plr.Character:FindFirstChildOfClass("Humanoid").Health)
                info.Text = string.format("%s\n[%s m] | HP: %s", plr.Name, dist, hp)
                task.wait(0.1)
            end
            bgui:Destroy()
        end)
    end

    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            createESP(p)
        end
    end
end)

-- ВКЛАДКА: ПЕРЕМЕЩЕНИЕ
local MoveTab = Window:NewTab("Движение")
MoveTab:NewSection("Скорость"):NewSlider("WalkSpeed", "Бег", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- ПЛАВАЮЩАЯ КНОПКА (UI TOGGLE)
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 50, 0, 50)
btn.Position = UDim2.new(0, 20, 0, 20)
btn.Text = "MOD"
btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
btn.Draggable = true
btn.MouseButton1Click:Connect(function() Library:ToggleUI() end)
