-- Ultimate Mobile Admin Hub (With ESP & Fixed Fly)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Переменные Состояния
local States = {
    Fly = false,
    Noclip = false,
    InfJump = false,
    Godmode = false,
    ESP_Box = false,
    ESP_Name = false,
    ESP_Tracers = false,
    Fullbright = false,
    WalkOnWater = false,
    AntiAFK = false,
    Bhop = false,
    Spinbot = false,
    RainbowChar = false,
    Xray = false,
    NoFog = false,
    AutoClicker = false
}

local Config = {
    Speed = 16,
    JumpPower = 50,
    FOV = 70,
    Gravity = 196.2,
    FlySpeed = 50,
    SpinSpeed = 20
}

local ESP_Storage = {}

-- ==========================================
-- 1. СОЗДАНИЕ GUI И КНОПКИ
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaAdminGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Кнопка открытия/закрытия
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Name = "ToggleMenuBtn"
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 15, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 120, 220)
ToggleButton.Text = "MENU"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 12
ToggleButton.Active = true
ToggleButton.Draggable = true

local ToggleCorner = Instance.new("UICorner", ToggleButton)
ToggleCorner.CornerRadius = UDim.new(0, 10)

-- Главное Окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local MainUICorner = Instance.new("UICorner", MainFrame)
MainUICorner.CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(60, 60, 90)
MainStroke.Thickness = 1.5

-- Боковая Панель (Sidebar)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 125, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
Sidebar.BorderSizePixel = 0

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 10)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 40)
Logo.Text = "⚡ DELTA HUB"
Logo.TextColor3 = Color3.fromRGB(100, 180, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 13
Logo.BackgroundTransparency = 1

local TabButtonContainer = Instance.new("Frame", Sidebar)
TabButtonContainer.Position = UDim2.new(0, 0, 0, 45)
TabButtonContainer.Size = UDim2.new(1, 0, 1, -45)
TabButtonContainer.BackgroundTransparency = 1

local TabListLayout = Instance.new("UIListLayout", TabButtonContainer)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 3)

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Position = UDim2.new(0, 135, 0, 10)
ContentArea.Size = UDim2.new(1, -145, 1, -20)
ContentArea.BackgroundTransparency = 1

local Pages = {}

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(100, 180, 255)
    Page.Visible = false
    
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 5)
    
    Pages[name] = Page
    return Page
end

CreatePage("Movement")
CreatePage("Visuals")
CreatePage("Player")
CreatePage("World")
CreatePage("Fun")

Pages["Movement"].Visible = true

local CurrentTabBtn = nil
local function AddTab(name, order)
    local Btn = Instance.new("TextButton", TabButtonContainer)
    Btn.Size = UDim2.new(0.9, 0, 0, 30)
    Btn.Position = UDim2.new(0.05, 0, 0, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(160, 160, 180)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 11
    Btn.LayoutOrder = order
    
    local BtnCorner = Instance.new("UICorner", Btn)
    BtnCorner.CornerRadius = UDim.new(0, 6)
    
    if order == 1 then
        Btn.BackgroundColor3 = Color3.fromRGB(35, 120, 220)
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentTabBtn = Btn
    end
    
    Btn.MouseButton1Click:Connect(function()
        for pageName, pageFrame in pairs(Pages) do
            pageFrame.Visible = (pageName == name)
        end
        if CurrentTabBtn then
            TweenService:Create(CurrentTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 24, 32), TextColor3 = Color3.fromRGB(160, 160, 180)}):Play()
        end
        CurrentTabBtn = Btn
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 120, 220), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
end

AddTab("Movement", 1)
AddTab("Visuals", 2)
AddTab("Player", 3)
AddTab("World", 4)
AddTab("Fun", 5)

-- ==========================================
-- 2. ЭЛЕМЕНТЫ ИНТЕРФЕЙСА
-- ==========================================

local function CreateToggle(page, text, flag, callback)
    local ToggleFrame = Instance.new("Frame", page)
    ToggleFrame.Size = UDim2.new(0.96, 0, 0, 34)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    
    local Corner = Instance.new("UICorner", ToggleFrame)
    Corner.CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(210, 210, 225)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    
    local Switch = Instance.new("Frame", ToggleFrame)
    Switch.Position = UDim2.new(1, -38, 0.5, -8)
    Switch.Size = UDim2.new(0, 30, 0, 16)
    Switch.BackgroundColor3 = States[flag] and Color3.fromRGB(40, 180, 100) or Color3.fromRGB(45, 45, 60)
    
    local SwitchCorner = Instance.new("UICorner", Switch)
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    
    local Circle = Instance.new("Frame", Switch)
    Circle.Position = States[flag] and UDim2.new(1, -14, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
    Circle.Size = UDim2.new(0, 10, 0, 10)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local CircleCorner = Instance.new("UICorner", Circle)
    CircleCorner.CornerRadius = UDim.new(1, 0)
    
    local Btn = Instance.new("TextButton", ToggleFrame)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    
    Btn.MouseButton1Click:Connect(function()
        States[flag] = not States[flag]
        local targetColor = States[flag] and Color3.fromRGB(40, 180, 100) or Color3.fromRGB(45, 45, 60)
        local targetPos = States[flag] and UDim2.new(1, -14, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
        
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        callback(States[flag])
    end)
end

local function CreateSlider(page, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", page)
    SliderFrame.Size = UDim2.new(0.96, 0, 0, 42)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    
    local Corner = Instance.new("UICorner", SliderFrame)
    Corner.CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Position = UDim2.new(0, 10, 0, 3)
    Label.Size = UDim2.new(0.6, 0, 0, 16)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(210, 210, 225)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    
    local ValueLabel = Instance.new("TextLabel", SliderFrame)
    ValueLabel.Position = UDim2.new(0.6, 0, 0, 3)
    ValueLabel.Size = UDim2.new(0.4, -10, 0, 16)
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.BackgroundTransparency = 1
    
    local BarBack = Instance.new("Frame", SliderFrame)
    BarBack.Position = UDim2.new(0, 10, 0, 26)
    BarBack.Size = UDim2.new(1, -20, 0, 4)
    BarBack.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    
    local BarCorner = Instance.new("UICorner", BarBack)
    BarCorner.CornerRadius = UDim.new(1, 0)
    
    local BarFill = Instance.new("Frame", BarBack)
    BarFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    
    local FillCorner = Instance.new("UICorner", BarFill)
    FillCorner.CornerRadius = UDim.new(1, 0)
    
    local Dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - BarBack.AbsolutePosition.X) / BarBack.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        BarFill.Size = UDim2.new(pos, 0, 1, 0)
        ValueLabel.Text = tostring(value)
        callback(value)
    end
    
    BarBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            Update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input)
        end
    end)
end

local function CreateButton(page, text, callback)
    local BtnFrame = Instance.new("Frame", page)
    BtnFrame.Size = UDim2.new(0.96, 0, 0, 32)
    BtnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    
    local Corner = Instance.new("UICorner", BtnFrame)
    Corner.CornerRadius = UDim.new(0, 6)
    
    local Btn = Instance.new("TextButton", BtnFrame)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 11
    
    Btn.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- 3. НАПОЛНЕНИЕ ВКЛАДОК
-- ==========================================

-- Movement
CreateToggle(Pages["Movement"], "Fly (Плавный полет)", "Fly", function(val) end)
CreateSlider(Pages["Movement"], "Скорость полета", 10, 200, Config.FlySpeed, function(val) Config.FlySpeed = val end)
CreateToggle(Pages["Movement"], "Noclip (Сквозь стены)", "Noclip", function(val) end)
CreateToggle(Pages["Movement"], "Infinite Jump (Беск. прыжок)", "InfJump", function(val) end)
CreateToggle(Pages["Movement"], "Bunny Hop (Авто-прыжок)", "Bhop", function(val) end)
CreateSlider(Pages["Movement"], "Скорость Бега", 16, 250, Config.Speed, function(val)
    Config.Speed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)
CreateSlider(Pages["Movement"], "Сила Прыжка", 50, 300, Config.JumpPower, function(val)
    Config.JumpPower = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

-- Visuals (ESP)
CreateToggle(Pages["Visuals"], "ESP Boxes (Квадраты)", "ESP_Box", function(val) end)
CreateToggle(Pages["Visuals"], "ESP Names (Ники)", "ESP_Name", function(val) end)
CreateToggle(Pages["Visuals"], "ESP Tracers (Линии)", "ESP_Tracers", function(val) end)
CreateToggle(Pages["Visuals"], "X-Ray (Прозрачные стены)", "Xray", function(val)
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
            part.Transparency = val and 0.5 or 0
        end
    end
end)

-- Player
CreateToggle(Pages["Player"], "Godmode (Бессмертие)", "Godmode", function(val) end)
CreateToggle(Pages["Player"], "Anti-AFK (Защита от кика)", "AntiAFK", function(val) end)
CreateToggle(Pages["Player"], "Auto-Clicker (Автотач)", "AutoClicker", function(val) end)
CreateButton(Pages["Player"], "Tp Up (Телепорт вверх 100м)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
    end
end)
CreateButton(Pages["Player"], "Rejoin Server (Перезайти)", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

-- World
CreateToggle(Pages["World"], "Fullbright (Яркий свет)", "Fullbright", function(val) end)
CreateToggle(Pages["World"], "No Fog (Убрать туман)", "NoFog", function(val)
    Lighting.FogEnd = val and 1e10 or 100000
end)
CreateToggle(Pages["World"], "Walk On Water (Ходить по воде)", "WalkOnWater", function(val) end)
CreateSlider(Pages["World"], "Гравитация мира", 0, 500, Config.Gravity, function(val)
    Config.Gravity = val
    workspace.Gravity = val
end)

-- Fun
CreateToggle(Pages["Fun"], "Rainbow Character (Цвета радуги)", "RainbowChar", function(val) end)
CreateToggle(Pages["Fun"], "Spinbot (Крутиться)", "Spinbot", function(val) end)
CreateSlider(Pages["Fun"], "Скорость Spinbot", 5, 50, Config.SpinSpeed, function(val) Config.SpinSpeed = val end)
CreateButton(Pages["Fun"], "Sit (Сесть)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Sit = true
    end
end)

-- ==========================================
-- 4. ЛОГИКА И БЭКЕНД
-- ==========================================

local FlyBV, FlyBG
RunService.RenderStepped:Connect(function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") and Char:FindFirstChild("Humanoid") then
        local HRP = Char.HumanoidRootPart
        local Hum = Char.Humanoid
        
        Hum.WalkSpeed = Config.Speed
        Hum.JumpPower = Config.JumpPower
        
        if States.Fly then
            Hum.PlatformStand = true
            if not FlyBV then
                FlyBV = Instance.new("BodyVelocity")
                FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                FlyBV.Velocity = Vector3.new(0, 0, 0)
                FlyBV.Parent = HRP
                
                FlyBG = Instance.new("BodyGyro")
                FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                FlyBG.P = 9e4
                FlyBG.Parent = HRP
            end
            
            local Cam = workspace.CurrentCamera
            local MoveDir = Hum.MoveDirection
            local Velocity = Vector3.new(0, 0, 0)
            
            if MoveDir.Magnitude > 0 then
                Velocity = Cam.CFrame.LookVector * (MoveDir.Z * -Config.FlySpeed) + Cam.CFrame.RightVector * (MoveDir.X * Config.FlySpeed)
            end
            
            FlyBV.Velocity = Velocity
            FlyBG.CFrame = Cam.CFrame
        else
            Hum.PlatformStand = false
            if FlyBV then FlyBV:Destroy() FlyBV = nil end
            if FlyBG then FlyBG:Destroy() FlyBG = nil end
        end
        
        if States.Noclip then
            for _, Part in pairs(Char:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.CanCollide = false
                end
            end
        end
        
        if States.Godmode then
            Hum.MaxHealth = 1e9
            Hum.Health = 1e9
        end
        
        if States.Spinbot and HRP then
            HRP.CFrame = HRP.CFrame * CFrame.Angles(0, math.rad(Config.SpinSpeed), 0)
        end
        
        if States.RainbowChar then
            for _, part in pairs(Char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    local Hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if Hum then
        if States.InfJump or States.Bhop then
            Hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if States.Fullbright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
    end
end)

local WaterPlatform = Instance.new("Part")
WaterPlatform.Size = Vector3.new(12, 1, 12)
WaterPlatform.Anchored = true
WaterPlatform.Transparency = 1
WaterPlatform.Parent = workspace

RunService.RenderStepped:Connect(function()
    if States.WalkOnWater and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        WaterPlatform.CFrame = CFrame.new(HRP.Position.X, (HRP.Position.Y - 3.2), HRP.Position.Z)
    else
        WaterPlatform.CFrame = CFrame.new(0, -1000, 0)
    end
end)

LocalPlayer.Idled:Connect(function()
    if States.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if States.AutoClicker then
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:Button1Down(Vector2.new(0,0))
            task.wait(0.05)
            VirtualUser:Button1Up(Vector2.new(0,0))
        end
    end
end)

-- ==========================================
-- 5. ESP СИСТЕМА
-- ==========================================

local function RemoveESP(plr)
    if ESP_Storage[plr] then
        for _, obj in pairs(ESP_Storage[plr]) do
            if type(obj) == "userdata" and obj.Remove then
                obj:Remove()
            elseif typeof(obj) == "Instance" then
                obj:Destroy()
            end
        end
        ESP_Storage[plr] = nil
    end
end

local function CreateESP(plr)
    if plr == LocalPlayer then return end
    
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(100, 180, 255)
    Box.Thickness = 1.5
    Box.Filled = false
    
    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Size = 12
    Name.Center = true
    Name.Outline = true
    
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.fromRGB(100, 180, 255)
    Tracer.Thickness = 1
    
    ESP_Storage[plr] = {Box = Box, Name = Name, Tracer = Tracer}
end

for _, plr in pairs(Players:GetPlayers()) do
    CreateESP(plr)
end

Players.PlayerAdded:Connect(CreateESP)
Players.P
