-- Загрузка библиотеки интерфейса
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("BF MOBILE PREMIUM HUB", "DarkTheme")

-- Глобальные переменные для работы функций
_G.AutoClick = false
_G.FruitESP = false

-- ГЛАВНАЯ ВКЛАДКА: ФАРМ
local FarmTab = Window:NewTab("Автофарм")
local FarmSection = FarmTab:NewSection("Основные функции")

FarmSection:NewToggle("Авто-кликер (Melee/Sword)", "Бьет ближайших врагов", function(state)
    _G.AutoClick = state
    spawn(function()
        while _G.AutoClick do
            local vim = game:GetService("VirtualInputManager")
            vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            task.wait(0.1)
        end
    end)
end)

FarmSection:NewButton("Fruit ESP (Поиск фруктов)", "Подсвечивает фрукты на карте", function()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if string.find(v.Name, "Fruit") then
            if not v:FindFirstChild("Highlight") then
                local h = Instance.new("Highlight", v)
                h.FillColor = Color3.fromRGB(0, 255, 0)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end)

-- ВКЛАДКА: ИГРОК
local PlayerTab = Window:NewTab("Игрок")
local PSection = PlayerTab:NewSection("Характеристики")

PSection:NewSlider("Скорость бега", "Стандарт: 16", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

PSection:NewSlider("Сила прыжка", "Стандарт: 50", 500, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

-- ВКЛАДКА: ТЕЛЕПОРТЫ (C1 - Первый мир)
local TPTab = Window:NewTab("Телепорты")
local TPSection = TPTab:NewSection("Острова Первого моря")

TPSection:NewButton("Jungle (Джунгли)", "Телепорт к квесту обезьян", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1612, 36, 147)
end)

TPSection:NewButton("Pirate Village", "Телепорт к клоуну Багги", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1146, 4, 3827)
end)

-- ВКЛАДКА: АДМИНКА
local AdminTab = Window:NewTab("Дополнительно")
AdminTab:NewSection("Скрипты"):NewButton("Infinite Yield", "Командная строка (;fly и т.д.)", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

-- АНТИ-АФК (Защита от вылета)
local VirtualUser = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- СОЗДАНИЕ ПЛАВАЮЩЕЙ КНОПКИ (Чтобы открывать/закрывать меню)
local ScreenGui = Instance.new("ScreenGui")
local Toggle = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
Toggle.Parent = ScreenGui
Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Toggle.BorderSizePixel = 2
Toggle.Position = UDim2.new(0.1, 0, 0.1, 0)
Toggle.Size = UDim2.new(0, 45, 0, 45)
Toggle.Text = "MENU"
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Draggable = true -- Кнопку можно двигать пальцем

Toggle.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)
