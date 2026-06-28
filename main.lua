-- [[ GBAO ADVANCED MASTER v9 ]] --
local UIS = game:GetService("UserInputService")
local PL = game:GetService("Players"); local LP = PL.LocalPlayer
local CG = game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")
local SG = game:GetService("StarterGui")
local RS = game:GetService("RunService")

if CG:FindFirstChild("GBAO_MASTER") then CG.GBAO_MASTER:Destroy() end
local sg = Instance.new("ScreenGui", CG); sg.Name = "GBAO_MASTER"

-- THÔNG BÁO CHÀO MẶC ĐỊNH GBAO
task.spawn(function()
    pcall(function() SG:SetCore("ChatMakeSystemMessage", {Text = ""}) end)
    task.wait(0.5)
    SG:SetCore("SendNotification", {
        Title = "⚡ GBAO SYSTEM",
        Text = "Chào mừng bạn, cảm ơn bạn đã dùng script gbao",
        Duration = 6
    })
end)

local function create(c, p, prop) local o = Instance.new(c, p) for k, v in pairs(prop) do o[k] = v end return o end

-- HÀM KÉO THẢ (MẶC ĐỊNH)
local function makeDraggable(obj)
    local drag, dStart, sPos = false, nil, nil
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag, dStart, sPos = true, i.Position, obj.Position end end)
    UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dStart; obj.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
end

-- 1. LOGO ĐÈ DELTA (DI CHUYỂN ĐƯỢC, 7 MÀU)
local Logo = create("TextButton", sg, {Size = UDim2.new(0,45,0,45), Position = UDim2.new(0.5,-22,0,10), Text = "GBAO", Font = Enum.Font.RobotoMono, TextSize = 13, BackgroundColor3 = Color3.new(0.05,0.05,0.05), ZIndex = 10})
create("UICorner", Logo, {CornerRadius = UDim.new(1,0)})
local L_Str = create("UIStroke", Logo, {Thickness = 2.5})
makeDraggable(Logo)

-- 2. MENU CHỮ NHẬT XỊN XÒ (DI CHUYỂN ĐƯỢC, VIỀN 7 MÀU)
local M = create("Frame", sg, {Size = UDim2.new(0,280,0,320), Position = UDim2.new(0.5,-140,0.3,-160), BackgroundColor3 = Color3.new(0.05,0.05,0.05), Visible = false, ZIndex = 5})
create("UICorner", M, {CornerRadius = UDim.new(0,12)})
local M_Str = create("UIStroke", M, {Thickness = 2.5})
makeDraggable(M)

create("TextLabel", M, {Size = UDim2.new(1,0,0,35), Text = "GBAO PREMIUM HUB", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.RobotoMono, TextSize = 14, BackgroundTransparency = 1})

-- ĐỒNG BỘ HIỆU ỨNG 7 MÀU MẶC ĐỊNH
task.spawn(function() while task.wait(0.02) do for i = 0, 1, 0.02 do local c = Color3.fromHSV(i,1,1); Logo.TextColor3 = c; L_Str.Color = c; M_Str.Color = c end end end)
Logo.MouseButton1Click:Connect(function() M.Visible = not M.Visible end)

-- CONTAINER CHỨA CÁC NÚT TÍNH NĂNG (SCROLL)
local SC = create("ScrollingFrame", M, {Size = UDim2.new(1,-20,1,-50), Position = UDim2.new(0,10,0,40), BackgroundTransparency = 1, CanvasSize = UDim2.new(0,0,0,360), ScrollBarThickness = 4})

local function createToggle(text, pos, callback)
    local btn = create("TextButton", SC, {Size = UDim2.new(1,0,0,35), Position = pos, Text = text .. " (OFF)", Font = Enum.Font.RobotoMono, TextSize = 12, BackgroundColor3 = Color3.new(0.1,0.1,0.1), TextColor3 = Color3.new(1,1,1)})
    create("UICorner", btn, {CornerRadius = UDim.new(0,6)})
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = text .. (active and " (ON)" or " (OFF)")
        btn.BackgroundColor3 = active and Color3.new(0,0.4,0) or Color3.new(0.1,0.1,0.1)
        callback(active)
    end)
    return btn
end

-- =======================================================
-- LẬP TRÌNH CÁC TÍNH NĂNG (CÓ BẬT / TẮT)
-- =======================================================

-- 1. ĐỊNH VỊ (ESP BOX)
local EspActive = false
createToggle("ĐỊNH VỊ (ESP)", UDim2.new(0,0,0,0), function(val) EspActive = val end)

RS.RenderStepped:Connect(function()
    for _, p in pairs(PL:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local box = hrp:FindFirstChild("GbaoEsp")
            if EspActive then
                if not box then
                    box = Instance.new("BoxHandleAdornment", hrp)
                    box.Name = "GbaoEsp"
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Adornee = hrp
                    box.Color3 = Color3.new(1, 0, 0)
                    box.Transparency = 0.5
                end
                -- Tự động điều chỉnh kích thước hộp bọc quanh nhân vật
                box.Size = p.Character:FindFirstChild("UpperTorso") and Vector3.new(4, 6, 4) or Vector3.new(4, 5, 4)
            else
                if box then box:Destroy() end
            end
        end
    end
end)

-- 2. INFINITE JUMP
local InfJumpActive = false
createToggle("INFINITE JUMP", UDim2.new(0,0,0,45), function(val) InfJumpActive = val end)
UIS.JumpRequest:Connect(function()
    if InfJumpActive and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 3. SPEED HACK
local SpeedActive = false
createToggle("SPEED HACK (100)", UDim2.new(0,0,0,90), function(val) SpeedActive = val end)
task.spawn(function()
    while task.wait(0.1) do
        if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
            LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = SpeedActive and 100 or 16
        end
    end
end)

-- 4. INVISIBLE (TÀNG HÌNH BẰNG CÁCH HẠ THẤP TÂM)
local InvisibleActive = false
local OriginalCFrame = nil
createToggle("INVISIBLE (TÀNG HÌNH)", UDim2.new(0,0,0,135), function(val)
    InvisibleActive = val
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        if InvisibleActive then
            OriginalCFrame = hrp.CFrame
            -- Dịch chuyển phần gốc xuống dưới lòng đất để giấu thực thể khỏi máy chủ
            hrp.CFrame = hrp.CFrame * CFrame.new(0, -50, 0)
        else
            if OriginalCFrame then hrp.CFrame = OriginalCFrame end
        end
    end
end)

-- 5. AIM BOT & VÒNG TRÒN FOV
local AimActive = false
createToggle("AIM BOT LOCK", UDim2.new(0,0,0,180), function(val) AimActive = val end)

-- Vòng tròn FOV tâm ngắm giả lập bằng UI (Mượt mà trên điện thoại)
local FOV_Circle = create("Frame", sg, {
    Size = UDim2.new(0, 150, 0, 150),
    BackgroundColor3 = Color3.new(1,1,1),
    BackgroundTransparency = 0.9,
    Visible = false,
    ZIndex = 1
})
create("UICorner", FOV_Circle, {CornerRadius = UDim.new(1,0)})
local FOV_Stroke = create("UIStroke", FOV_Circle, {Thickness = 1.5, Color = Color3.new(1,0,0)})

-- Cập nhật vòng ngắm theo tâm màn hình
RS.RenderStepped:Connect(function()
    if AimActive then
        local cam = workspace.CurrentCamera
        local center = cam.ViewportSize / 2
        FOV_Circle.Visible = true
        FOV_Circle.Position = UDim2.new(0, center.X - 75, 0, center.Y - 75)
        
        -- Tìm mục tiêu gần tâm nhất
        local target = nil
        local maxDist = 75 -- Giới hạn trong vòng tròn FOV
        
        for _, p in pairs(PL:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local hrp = p.Character.HumanoidRootPart
                local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local mouseDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if mouseDist < maxDist then
                        maxDist = mouseDist
                        target = hrp
                    end
                end
            end
        end
        
        -- Khóa camera vào mục tiêu
        if target then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
        end
    else
        FOV_Circle.Visible = false
    end
end)
