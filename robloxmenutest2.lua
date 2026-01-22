-- GOD BRAINROT EDITION: FULL MENU + ADMIN + NOCLIP
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 420) -- Увеличил размер под все кнопки
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "GOD BRAINROT HUB 💀"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.TextSize = 18
Instance.new("UICorner", Title)

-- УТИЛИТА ДЛЯ КНОПОК
local function makeBtn(name, pos, color, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. АДМИН ПАНЕЛЬ (INFINITE YIELD)
makeBtn("OPEN ADMIN PANEL", 55, Color3.fromRGB(50, 50, 150), function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

-- 2. GOD MODE (БЕССМЕРТИЕ)
makeBtn("GOD MODE: ACTIVE", 100, Color3.fromRGB(40, 40, 40), function()
    local lp = game.Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("Health") then
        lp.Character.Health:Destroy()
    end
end)

-- 3. NOCLIP (СКВОЗЬ СТЕНЫ)
_G.Noclip = false
local nbtn = makeBtn("NOCLIP: OFF", 145, Color3.fromRGB(40, 40, 40), function()
    _G.Noclip = not _G.Noclip
    MainFrame:FindFirstChild("NOCLIP: OFF").Text = _G.Noclip and "NOCLIP: ON ✅" or "NOCLIP: OFF"
end)
game:GetService("RunService").Stepped:Connect(function()
    if _G.Noclip and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 4. FLY (ПОЛЁТ)
_G.Flying = false
makeBtn("FLY: TOGGLE", 190, Color3.fromRGB(40, 40, 40), function()
    _G.Flying = not _G.Flying
    local lp = game.Players.LocalPlayer
    local hrp = lp.Character.HumanoidRootPart
    if _G.Flying then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Name = "SigmaFly"
        spawn(function()
            while _G.Flying do
                bv.Velocity = lp.Character.Humanoid.MoveDirection * 100 + Vector3.new(0, 0.1, 0)
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- 5. SPEED (БЫСТРЫЙ ОБХОД)
makeBtn("MAX SPEED", 235, Color3.fromRGB(40, 40, 40), function()
    spawn(function()
        while task.wait() do
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 120 end
        end
    end)
end)

-- 6. REACH (УДАРЫ ДАЛЕКО)
makeBtn("REACH (BUDDHA)", 280, Color3.fromRGB(40, 40, 40), function()
    spawn(function()
        while task.wait(1) do
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                tool.Handle.Size = Vector3.new(40, 40, 40)
                tool.Handle.CanCollide = false
            end
        end
    end)
end)

-- ВЫХОД
makeBtn("CLOSE MENU", 360, Color3.fromRGB(150, 0, 0), function() MainFrame.Visible = false end)

-- КНОПКА ОТКРЫТИЯ
local Open = Instance.new("TextButton", ScreenGui)
Open.Size = UDim2.new(0, 60, 0, 60)
Open.Position = UDim2.new(0, 10, 0, 10)
Open.Text = "GOD"
Open.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Open.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Open).CornerRadius = UDim.new(1, 0)
Open.MouseButton1Click:Connect(function() MainFrame.Visible = true end)
