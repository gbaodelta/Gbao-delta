-- [[ GBAO REBEL V4 - COMPACT EDITION ]] --
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local PL = game:GetService("Players")
local LP = PL.LocalPlayer
local CG = game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")

if CG:FindFirstChild("GBAO_V4") then CG.GBAO_V4:Destroy() end
local sg = Instance.new("ScreenGui", CG); sg.Name = "GBAO_V4"

-- COMPACT CREATOR FUNCTION
local function create(class, parent, props)
    local obj = Instance.new(class, parent)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

-- 1. LOGO TRÒN VIỀN 7 MÀU
local Logo = create("TextButton", sg, {Size = UDim2.new(0,45,0,45), Position = UDim2.new(0,30,0,150), Text = "GBAO", Font = Enum.Font.LuckiestGuy, TextSize = 14, TextColor3 = Color3.new(1,1,1), BackgroundColor3 = Color3.new(0.05,0.05,0.05)})
create("UICorner", Logo, {CornerRadius = UDim.new(1,0)})
local L_Str = create("UIStroke", Logo, {Thickness = 2.5})

-- 2. MENU VIỀN 7 MÀU BO GÓC
local Main = create("Frame", sg, {Size = UDim2.new(0,240,0,260), Position = UDim2.new(0.5,-120,0.4,-130), BackgroundColor3 = Color3.new(0.05,0.05,0.05), Visible = false})
create("UICorner", Main, {CornerRadius = UDim.new(0,12)})
local M_Str = create("UIStroke", Main, {Thickness = 2.5})

-- HIỆU ỨNG 7 MÀU (RAINBOW ENGINE)
task.spawn(function() while task.wait(0.02) do for i = 0, 1, 0.01 do local c = Color3.fromHSV(i,1,1); L_Str.Color = c; M_Str.Color = c end end end)

-- KÉO THẢ LOGO
local drag, dStart, sPos, dTime = false, nil, nil, 0
Logo.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag, dStart, sPos, dTime = true, i.Position, Logo.Position, tick() end end)
UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dStart; Logo.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
Logo.MouseButton1Click:Connect(function() if tick() - dTime < 0.3 then Main.Visible = not Main.Visible end end)

-- CÁC MỤC TRONG MENU
create("TextLabel", Main, {Size = UDim2.new(1,0,0,40), Text = "GBAO REBEL V4", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.SourceSansBold, TextSize = 18, BackgroundTransparency = 1})
local Input = create("TextBox", Main, {Size = UDim2.new(0,200,0,35), Position = UDim2.new(0,20,0,50), PlaceholderText = "Nhập ID nạn nhân...", Text = "", BackgroundColor3 = Color3.new(0.1,0.1,0.1), TextColor3 = Color3.new(1,1,1)})
create("UICorner", Input, {CornerRadius = UDim.new(0,6)})

local SlapBtn = create("TextButton", Main, {Size = UDim2.new(0,200,0,35), Position = UDim2.new(0,20,0,95), Text = "TÁT VĂNG XA (OFF)", BackgroundColor3 = Color3.new(0.12,0.12,0.12), TextColor3 = Color3.new(1,1,1)})
create("UICorner", SlapBtn, {CornerRadius = UDim.new(0,6)})

local LagBtn = create("TextButton", Main, {Size = UDim2.new(0,200,0,40), Position = UDim2.new(0,20,0,150), Text = "KÍCH HOẠT GIẢM LAG", BackgroundColor3 = Color3.new(0.12,0.12,0.12), TextColor3 = Color3.new(0,1,0)})
create("UICorner", LagBtn, {CornerRadius = UDim.new(0,6)})

-- LOGIC CHỨC NĂNG (SLAP & LAG)
local TargetID, SlapActive = nil, false
SlapBtn.MouseButton1Click:Connect(function()
    if Input.Text ~= "" then
        TargetID, SlapActive = tonumber(Input.Text), not SlapActive
        SlapBtn.Text = SlapActive and "ĐANG TÁT NẠN NHÂN..." or "TÁT VĂNG XA (OFF)"
        SlapBtn.BackgroundColor3 = SlapActive and Color3.new(0.6,0,0) or Color3.new(0.12,0.12,0.12)
    end
end)

RS.Heartbeat:Connect(function()
    if SlapActive and TargetID then
        local p = PL:GetPlayerByUserId(TargetID)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myHrp, tHrp = LP.Character.HumanoidRootPart, p.Character.HumanoidRootPart
            myHrp.CFrame = tHrp.CFrame + tHrp.CFrame.LookVector * -1
            myHrp.Velocity = Vector3.new(20000, 20000, 20000) -- Ép max lực va chạm vật lý để văng xa hơn bản cũ
        end
    end
end)

LagBtn.MouseButton1Click:Connect(function()
    LagBtn.Text, LagBtn.BackgroundColor3 = "ĐÃ GIẢM LAG!", Color3.new(0,0.3,0)
    game:GetService("Lighting").GlobalShadows = false
    for _, o in pairs(workspace:GetDescendants()) do
        if o:IsA("Part") or o:IsA("MeshPart") or o:IsA("UnionOperation") then o.Material, o.Reflectance = Enum.Material.SmoothPlastic, 0
        elseif o:IsA("Decal") or o:IsA("Texture") then o:Destroy()
        elseif o:IsA("ParticleEmitter") or o:IsA("Trail") then o.Enabled = false end
    end
end)
