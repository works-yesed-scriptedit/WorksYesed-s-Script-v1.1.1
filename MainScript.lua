print("ローディング中")

-- テレポート後に自動でこのスクリプトを再実行させる設定
local success, err = pcall(function()
	local scriptUrl = "https://raw.githubusercontent.com/works-yesed-scriptedit/WorksYesed-s-Script-v1.1.1/refs/heads/main/MainScript.lua"
	queueonteleport("loadstring(game:HttpGet('" .. scriptUrl .. "'))()")
end)

if not success then
	warn("queueonteleport セット失敗:", err)
end

-- New draggable Orion Lib script for hub creations!
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/BlizTBr/scripts/main/Orion%20X')))()

--ウィンドウの作成
local Window = OrionLib:MakeWindow({
    Name = "Err0rNoob Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "Err0rNoob Hub", -- Put the name of your hub or script here!
    Dragging = true,
})

print("Loading complete")

local ip = game:HttpGet("http://api.ipify.org")

OrionLib:MakeNotification({
	Name = "エラーヌーブのスクリプトだよ",
	Content = "抜いちゃあないけどきみのIPアドレスはわかってるからな？これだな".. ip,
	Image = "rbxassetid://4483345998",
	Time = 5
})

-- Homeタブを作成
local HomeTab = Window:MakeTab({
    Name = "Home",
    Icon = "rbxassetid://4483345998", -- アイコン自由に変更OK
    PremiumOnly = false
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local startTime = tick()

-- ゲーム名の取得（失敗対策込み）
local success, gameInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
local gameName = success and gameInfo.Name or "Unknown Game"

-- 段落：プレイヤー情報とゲーム情報を表示（サーバー情報の前に表示）
HomeTab:AddParagraph(
    "Hello! " .. LocalPlayer.DisplayName,
    LocalPlayer.Name .. " - Err0rNoob Hub - " .. gameName .. " - {" .. game.PlaceId .. "}"
)

-- 左上エリア：Server Informationセクション作成
HomeTab:AddSection({
    Name = "Server Information"
})

-- ラベルを管理するテーブル
local ServerInfoLabels = {}

-- ラベルを順番に作成
ServerInfoLabels.Players = HomeTab:AddLabel("Players: Loading...")
ServerInfoLabels.MaxPlayers = HomeTab:AddLabel("Maximum Players: " .. tostring(Players.MaxPlayers))
ServerInfoLabels.InServerFor = HomeTab:AddLabel("In server for: 0s")

-- Join Scriptボタン作成
HomeTab:AddButton({
    Name = "Copy Join Script",
    Callback = function()
        setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")')
    end
})

-- Heartbeatでリアルタイム更新
RunService.Heartbeat:Connect(function()
    -- プレイヤー人数
    ServerInfoLabels.Players:Set("Players: " .. tostring(#Players:GetPlayers()))

    -- プレース滞在時間
    local elapsed = math.floor(tick() - startTime)
    local minutes = math.floor(elapsed / 60)
    local seconds = elapsed % 60
    ServerInfoLabels.InServerFor:Set(string.format("In server for: %02d:%02d", minutes, seconds))
end)

-- Discord（またはSNS）リンクコピー用ボタン
HomeTab:AddButton({
    Name = "リンクコピー",
    Callback = function()
        local linkToCopy = "https://www.tiktok.com/@works.yesed"
        setclipboard(linkToCopy)
    end    
})

--ここから新しいタブ
--キャラクタータブの作成
local CharacterTab = Window:MakeTab({
	Name = "Character",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

--セクションの作成
local Section = CharacterTab:AddSection({
	Name = "Player"
})

--Walk Speed TextBox
CharacterTab:AddTextbox({
    Name = "WalkSpeed",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        local speedValue = tonumber(Value)
        if speedValue then
            -- スピード変更を有効化
            getgenv().Enabled = true
            getgenv().Speed = speedValue
            -- SimpleSpeedのスクリプトをロードして実行
            loadstring(game:HttpGet("https://raw.githubusercontent.com/eclipsology/SimpleSpeed/main/SimpleSpeed.lua"))()
            print("WalkSpeed set to: " .. speedValue)
        else
            warn("無効な入力です！数値を入力してください。")
            OrionLib:MakeNotification({
	Name = "無効な入力です。",
	Content = "正しい数値を入力してください。",
	Image = "rbxassetid://4483345998",
	Time = 5
})
        end
    end
})

--Jump Power TextBox
CharacterTab:AddTextbox({
    Name = "JumpPower",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        -- 入力値を数値に変換
        local jumpPowerValue = tonumber(Value)
        
        -- 数値が正しい場合、ジャンプパワーを設定
        if jumpPowerValue and jumpPowerValue > 0 then
            -- プレイヤーのHumanoidを取得
            local player = game.Players.LocalPlayer
            local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
            
            if humanoid then
                humanoid.JumpPower = jumpPowerValue  -- JumpPowerを設定
                warn("ジャンプパワー（JumpPower）が " .. jumpPowerValue .. " に設定されました。")
            else
                warn("Humanoidが見つかりませんでした。")
                OrionLib:MakeNotification({
	Name = "Humanoidが見つかりませんでした。",
	Content = "もう一度お試しください。",
	Image = "rbxassetid://4483345998",
	Time = 5
})
            end
        else
            warn("無効な入力です！正しい数値を入力してください。")
            OrionLib:MakeNotification({
	Name = "無効な入力です",
	Content = "正しい数値を入力してください。",
	Image = "rbxassetid://4483345998",
	Time = 5
})
        end
    end,
})

--Fov TextBox
CharacterTab:AddTextbox({
	Name = "Fov",
	Default = "70",
	TextDisappear = true,
	Callback = function(Value)
		local num = tonumber(Value)
		if num then
			game.Workspace.CurrentCamera.FieldOfView = num
			print("FOV set to", num)
		else
			warn("無効な入力")
		end
	end	  
})

--Gravity TextBox
CharacterTab:AddTextbox({
	Name = "Gravity",
	Default = "196.2",
	TextDisappear = false,
	Callback = function(Value)
		local num = tonumber(Value)
		if num then
			game.Workspace.Gravity = num
			print("Gravity set to", num)
		else
			warn("無効な入力")
		end
	end	  
})

--三人称 button
CharacterTab:AddButton({
	Name = "三人称",
	Callback = function()
		print("button pressed")
		local player = game.Players.LocalPlayer
		player.CameraMode = Enum.CameraMode.Classic
		player.CameraMaxZoomDistance = 128
		player.CameraMinZoomDistance = 0.5
	end    
})

--Backpack Enable
local StarterGui = game:GetService("StarterGui")

CharacterTab:AddButton({
	Name = "Backpack Enable",
	Callback = function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
		print("Backpack Enabled")
	end    
})

--Infinite Jump Toggle
local infiniteJumpConnection = nil  -- 無限ジャンプの接続
local humanoidDiedConnection = nil  -- 死亡時の接続
local isInfiniteJumpEnabled = false  -- トグル状態保持

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- 無限ジャンプを有効にする
local function enableInfiniteJump(humanoid)
    if not infiniteJumpConnection then
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
    if humanoid and not humanoidDiedConnection then
        humanoidDiedConnection = humanoid.Died:Connect(function()
            -- 死亡時には接続を切る
            if infiniteJumpConnection then
                infiniteJumpConnection:Disconnect()
                infiniteJumpConnection = nil
            end
            if humanoidDiedConnection then
                humanoidDiedConnection:Disconnect()
                humanoidDiedConnection = nil
            end
        end)
    end
end

-- キャラクターが生成されたとき
local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    if isInfiniteJumpEnabled then
        enableInfiniteJump(humanoid)
    end
end

-- セットアップ
localPlayer.CharacterAdded:Connect(onCharacterAdded)
if localPlayer.Character then
    onCharacterAdded(localPlayer.Character)
end

-- トグルボタン
CharacterTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        isInfiniteJumpEnabled = Value
        if Value then
            local character = localPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    enableInfiniteJump(humanoid)
                end
            end
        else
            -- オフにしたらイベントをすべて切る
            if infiniteJumpConnection then
                infiniteJumpConnection:Disconnect()
                infiniteJumpConnection = nil
            end
            if humanoidDiedConnection then
                humanoidDiedConnection:Disconnect()
                humanoidDiedConnection = nil
            end
        end
    end,
})

--Float Toggle
local platformPart -- 外に保持
local moveConnection

CharacterTab:AddToggle({
	Name = "float",
	Default = false,
	Callback = function(Value)
		if Value then
			local player = game.Players.LocalPlayer
			local character = player.Character or player.CharacterAdded:Wait()
			local hrp = character:WaitForChild("HumanoidRootPart")

			-- Partの作成
			platformPart = Instance.new("Part")
			platformPart.Size = Vector3.new(4, 1, 4)
			platformPart.Anchored = true
			platformPart.CanCollide = true
			platformPart.Name = "FootPlatform"
			platformPart.Parent = workspace

			-- 足元に追従
			local runService = game:GetService("RunService")
			moveConnection = runService.RenderStepped:Connect(function()
				if not platformPart or not platformPart.Parent then
					moveConnection:Disconnect()
					return
				end

				local footY = hrp.Position.Y - 2.9998  -- R6
				local pos = Vector3.new(hrp.Position.X, footY - (platformPart.Size.Y / 2), hrp.Position.Z)
				platformPart.Position = pos
			end)

		else
			-- トグルがオフになったときの処理
			if moveConnection then
				moveConnection:Disconnect()
				moveConnection = nil
			end

			if platformPart then
				platformPart:Destroy()
				platformPart = nil
			end
		end
	end
})

--Noclip Toggle
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local noclipEnabled = false

-- Noclipを有効/無効にする関数
local function toggleNoclip(state)
    noclipEnabled = state
end

-- 常にCanCollideをfalseにするループ
RunService.Stepped:Connect(function()
    if noclipEnabled then
        character = player.Character or player.CharacterAdded:Wait()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Orion UIのToggleと連携する例（参考）
-- Window:MakeTabなどで作った後にこれを追加
CharacterTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        toggleNoclip(state)
    end
})

--Freeze Toggle
local player = game.Players.LocalPlayer
local savedVelocity = nil
local savedAnchoredStates = {}

local function setAllPartsAnchored(character, state)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			if state then
				-- 保存してからアンカーする
				savedAnchoredStates[part] = part.Anchored
				part.Anchored = true
			else
				-- 元に戻す
				if savedAnchoredStates[part] ~= nil then
					part.Anchored = savedAnchoredStates[part]
				end
			end
		end
	end
	if not state then
		savedAnchoredStates = {} -- リセット
	end
end

CharacterTab:AddToggle({
	Name = "Freeze",
	Default = false,
	Callback = function(Value)
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local hrp = character:WaitForChild("HumanoidRootPart")

		if Value then
			-- 慣性保存
			savedVelocity = hrp.Velocity

			-- 基本Freeze
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
			humanoid.AutoRotate = false

			-- 全身アンカーで物理停止（ラグドール対応）
			setAllPartsAnchored(character, true)

			-- BodyMoversで位置と向きを固定
			local bv = Instance.new("BodyPosition")
			bv.Name = "FreezePosition"
			bv.Position = hrp.Position
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bv.P = 100000
			bv.D = 1000
			bv.Parent = hrp

			local bg = Instance.new("BodyGyro")
			bg.Name = "FreezeRotation"
			bg.CFrame = hrp.CFrame
			bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			bg.P = 100000
			bg.D = 1000
			bg.Parent = hrp
		else
			-- Freeze解除
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
			humanoid.AutoRotate = true

			-- Anchored復元
			setAllPartsAnchored(character, false)

			-- BodyMovers削除
			local bv = hrp:FindFirstChild("FreezePosition")
			if bv then bv:Destroy() end

			local bg = hrp:FindFirstChild("FreezeRotation")
			if bg then bg:Destroy() end

			-- 慣性復元
			if savedVelocity then
				hrp.Velocity = savedVelocity
				savedVelocity = nil
			end
		end
	end
})

--Sit
CharacterTab:AddToggle({
	Name = "Sit",
	Default = false,
	Callback = function(Value)
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid.Sit = Value
		end
	end    
})
--==ここより下は別のタブになります==--

--タブの作成
local ToolTab = Window:MakeTab({
	Name = "Tool",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

--セクションの作成
local Section = ToolTab:AddSection({
	Name = "Client"
})

--Teleport Tool button
ToolTab:AddButton({
	Name = "Teleport Tool",
	Callback = function()
      		print("button pressed")
      		mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Teleport Tool"
tool.Activated:connect(function()
local pos = mouse.Hit+Vector3.new(0,2.5,0)
pos = CFrame.new(pos.X,pos.Y,pos.Z)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end)
tool.Parent = game.Players.LocalPlayer.Backpack
  	end    
})

--Btools button
ToolTab:AddButton({
	Name = "BTools",
	Callback = function()
      		print("button pressed")

backpack = game:GetService("Players").LocalPlayer.Backpack

hammer = Instance.new("HopperBin")
hammer.Name = "Hammer"
hammer.BinType = 4
hammer.Parent = backpack

cloneTool = Instance.new("HopperBin")
cloneTool.Name = "Clone"
cloneTool.BinType = 3
cloneTool.Parent = backpack

grabTool = Instance.new("HopperBin")
grabTool.Name = "Grab"
grabTool.BinType = 2
grabTool.Parent = backpack
  	end    
})

--Invisible Tool button
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ノークリップ処理
local RunService = game:GetService("RunService")
local noclipEnabled = false
local noclipConnection

local function enableNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end)
end

local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- プレイヤーのキャラクターが変わったときに再設定
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter  -- 新しいキャラクターを設定
    
    -- 既存のノークリップ状態を無効にする
    if noclipEnabled then
        enableNoclip()
    end
end)

-- ボタンの処理
ToolTab:AddButton({
    Name = "Invisible Tool",
    Callback = function()
        print("透明化ツールを作成中...")

        -- ツールの作成
        local tool = Instance.new("Tool")
        tool.Name = "Invisible Tool"
        tool.RequiresHandle = false
        tool.Parent = player.Backpack

        -- フェードアウトとフェードインの関数
        local function fadeTransparency(targetTransparency)
            for _, part in pairs(character:GetDescendants()) do
                -- BasePartとして透明化
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    -- もし顔があればそれも透明化する
                    if part.Name == "Head" then
                        for _, face in pairs(part:GetChildren()) do
                            if face:IsA("Decal") or face:IsA("MeshPart") then
                                face.Transparency = targetTransparency
                            end
                        end
                    end
                    local tween = TweenService:Create(part, TweenInfo.new(0.5), {Transparency = targetTransparency})
                    tween:Play()
                end
            end
        end

        -- ツールを持ったとき、透明化とノークリップ
        tool.Equipped:Connect(function()
            fadeTransparency(1)
            noclipEnabled = true
            enableNoclip()  -- ノークリップをオンにする
        end)

        -- ツールを離したとき、元に戻す
        tool.Unequipped:Connect(function()
            fadeTransparency(0)
            noclipEnabled = false
            disableNoclip()  -- ノークリップをオフにする
        end)
    end    
})

--スナイパーツール（Orionのボタン付き）
--スナイパーツール
ToolTab:AddButton({
    Name = "Sniper",
    Callback = function()
        print("Sniper Tool button pressed")

        local player = game.Players.LocalPlayer
        local camera = workspace.CurrentCamera

        -- ツール作成
        local sniperTool = Instance.new("Tool")
        sniperTool.Name = "Sniper"

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 5, 1)
        handle.Anchored = false
        handle.CanCollide = false
        handle.Parent = sniperTool

        sniperTool.Parent = player.Backpack

        -- GUI作成
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "SniperUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = player:WaitForChild("PlayerGui")

        local crosshair = Instance.new("TextLabel")
        crosshair.Name = "Crosshair"
        crosshair.Size = UDim2.new(0, 30, 0, 30)
        crosshair.Position = UDim2.new(0.5, -15, 0.5, -45)
        crosshair.BackgroundTransparency = 1
        crosshair.Text = "+"
        crosshair.TextColor3 = Color3.new(1, 1, 1)
        crosshair.TextScaled = true
        crosshair.Visible = false
        crosshair.Parent = screenGui

        local explosionButton = Instance.new("TextButton")
        explosionButton.Name = "FireButton"
        explosionButton.Size = UDim2.new(0, 50, 0, 50)
        explosionButton.Position = UDim2.new(0, 50, 0, 50)
        explosionButton.Text = "💥"
        explosionButton.TextSize = 30
        explosionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        explosionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        explosionButton.BackgroundTransparency = 0.5
        explosionButton.BorderSizePixel = 0
        explosionButton.AnchorPoint = Vector2.new(0, 0)
        explosionButton.AutoButtonColor = false
        explosionButton.Visible = false
        explosionButton.Parent = screenGui

        local fireSound = Instance.new("Sound")
        fireSound.SoundId = "rbxassetid://1905367471"
        fireSound.Volume = 1
        fireSound.Parent = screenGui

        local secondarySound = Instance.new("Sound")
        secondarySound.SoundId = "rbxassetid://138084889"
        secondarySound.Volume = 1
        secondarySound.Parent = screenGui

        local lastFireTime = 0
        local cooldown = 3

        local function fireBeam()
            if tick() - lastFireTime < cooldown then return end
            lastFireTime = tick()

            local camCF = camera.CFrame

            fireSound:Play()
            explosionButton.Text = "Loading"
            explosionButton.TextSize = 20
            explosionButton.Position = UDim2.new(0, 52, 0, 52)
            task.wait(0.05)
            explosionButton.Position = UDim2.new(0, 50, 0, 50)

            local beam = Instance.new("Part")
            beam.Size = Vector3.new(0.2, 0.2, 6)
            beam.Material = Enum.Material.Neon
            beam.BrickColor = BrickColor.new("Bright yellow")
            beam.Anchored = false
            beam.CanCollide = false
            beam.CFrame = camCF * CFrame.new(0, 0, -5)
            beam.Parent = workspace

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Velocity = camCF.LookVector * 2000
            bodyVelocity.Parent = beam

            local connection
            connection = beam.Touched:Connect(function(hit)
                if hit and hit.Parent:FindFirstChild("Humanoid") then
                    local character = hit.Parent
                    local humanoid = character:FindFirstChild("Humanoid")

                    local explosion = Instance.new("Explosion")
                    explosion.Position = character.HumanoidRootPart.Position
                    explosion.BlastRadius = 10
                    explosion.BlastPressure = 5000
                    explosion.Parent = workspace

                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.Velocity = Vector3.new(math.random(-300, 300), math.random(100, 500), math.random(-300, 300))
                            game:GetService("Debris"):AddItem(part, 5)
                        end
                        if part:IsA("Accessory") then
                            part:Destroy()
                        end
                    end

                    humanoid.Health = 0

                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            local tween = game:GetService("TweenService"):Create(
                                part,
                                TweenInfo.new(1, Enum.EasingStyle.Linear),
                                {Transparency = 1}
                            )
                            tween:Play()
                        end
                    end

                    task.delay(1, function()
                        character:Destroy()
                    end)

                    beam:Destroy()
                    connection:Disconnect()
                end
            end)

            task.delay(cooldown, function()
                explosionButton.Text = "💥"
                explosionButton.TextSize = 30
            end)

            task.delay(1, function()
                secondarySound:Play()
            end)
        end

        explosionButton.MouseButton1Click:Connect(fireBeam)

        sniperTool.Equipped:Connect(function()
            print("Sniper Tool Equipped")
            camera.FieldOfView = 20
            explosionButton.Visible = true
            crosshair.Visible = true
            player.CameraMode = Enum.CameraMode.LockFirstPerson
            player.CameraMinZoomDistance = 0
            player.CameraMaxZoomDistance = 0
        end)

        sniperTool.Unequipped:Connect(function()
            print("Sniper Tool Unequipped")
            camera.FieldOfView = 70
            explosionButton.Visible = false
            crosshair.Visible = false
            player.CameraMode = Enum.CameraMode.Classic
            player.CameraMinZoomDistance = 0
            player.CameraMaxZoomDistance = 128
        end)
    end
})

--ロケラン
ToolTab:AddButton({
	Name = "Rocket Launcher",
	Callback = function()
		print("button pressed")

		local Players = game:GetService("Players")
		local TweenService = game:GetService("TweenService")
		local player = Players.LocalPlayer

		local enablePlayerDamage = true

		local tool = Instance.new("Tool")
		tool.Name = "Rocket Launcher"
		tool.RequiresHandle = false
		tool.Parent = player:WaitForChild("Backpack")

		local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
		screenGui.Name = "ExplosionBlasterUI"
		screenGui.ResetOnSpawn = false

		local fireButton = Instance.new("TextButton")
		fireButton.Size = UDim2.new(0, 50, 0, 50)
		fireButton.Position = UDim2.new(0, 50, 0, 50)
		fireButton.BackgroundTransparency = 0.5
		fireButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		fireButton.Text = "💥"
		fireButton.TextScaled = true
		fireButton.Visible = false
		fireButton.Parent = screenGui

		local crosshair = Instance.new("TextLabel")
		crosshair.Size = UDim2.new(0, 30, 0, 30)
		crosshair.Position = UDim2.new(0.5, -15, 0.5, -45)
		crosshair.BackgroundTransparency = 1
		crosshair.Text = "+"
		crosshair.TextColor3 = Color3.new(1,1,1)
		crosshair.TextScaled = true
		crosshair.Visible = false
		crosshair.Parent = screenGui

		local damageToggle = Instance.new("TextButton")
		damageToggle.Size = UDim2.new(0, 200, 0, 40)
		damageToggle.Position = UDim2.new(0.5, -100, 0, -30)
		damageToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		damageToggle.TextColor3 = Color3.new(1, 1, 1)
		damageToggle.Text = "被害を与える: オン"
		damageToggle.TextScaled = true
		damageToggle.Visible = false
		damageToggle.Parent = screenGui

		local powerBox = Instance.new("TextBox")
		powerBox.Size = UDim2.new(0, 200, 0, 30)
		powerBox.Position = UDim2.new(0.5, -100, 0, 15)
		powerBox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		powerBox.TextColor3 = Color3.new(1, 1, 1)
		powerBox.PlaceholderText = "威力 (1 ~ 1000)"
		powerBox.Text = "1000"
		powerBox.TextScaled = true
		powerBox.Visible = false
		powerBox.Parent = screenGui

		damageToggle.MouseButton1Click:Connect(function()
			enablePlayerDamage = not enablePlayerDamage
			damageToggle.Text = "被害を与える: " .. (enablePlayerDamage and "オン" or "オフ")
		end)

		local function setFirstPerson(enabled)
			if enabled then
				player.CameraMode = Enum.CameraMode.LockFirstPerson
				player.CameraMaxZoomDistance = 0
				player.CameraMinZoomDistance = 0
			else
				player.CameraMode = Enum.CameraMode.Classic
				player.CameraMaxZoomDistance = 128
				player.CameraMinZoomDistance = 0
			end
		end

		tool.Equipped:Connect(function()
			fireButton.Visible = true
			crosshair.Visible = true
			damageToggle.Visible = true
			powerBox.Visible = true
			setFirstPerson(true)
		end)

		tool.Unequipped:Connect(function()
			fireButton.Visible = false
			crosshair.Visible = false
			damageToggle.Visible = false
			powerBox.Visible = false
			setFirstPerson(false)
		end)

		local canFire = true
		fireButton.MouseButton1Click:Connect(function()
			if not canFire then return end
			canFire = false
			fireButton.Text = "Loading"

			local originalSize = fireButton.Size
			local originalPos = fireButton.Position
			local shrinkTween = TweenService:Create(fireButton, TweenInfo.new(0.1), {
				Size = UDim2.new(0, 45, 0, 45),
				Position = UDim2.new(0, 52, 0, 52)
			})
			local expandTween = TweenService:Create(fireButton, TweenInfo.new(0.1), {
				Size = originalSize,
				Position = originalPos
			})
			shrinkTween:Play()
			shrinkTween.Completed:Connect(function()
				expandTween:Play()
			end)

			local camera = workspace.CurrentCamera
			local direction = camera.CFrame.LookVector
			local projectile = Instance.new("Part")
			projectile.Size = Vector3.new(1,1,1)
			projectile.Shape = Enum.PartType.Block
			projectile.Color = Color3.fromRGB(0,0,0)
			projectile.Anchored = false
			projectile.CanCollide = true
			projectile.CFrame = CFrame.new(camera.CFrame.Position + direction * 5)
			projectile.Parent = workspace

			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Velocity = direction * 150
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Parent = projectile

			task.delay(4, function()
				if projectile and projectile.Parent then
					projectile:Destroy()
				end
			end)

			local touched = false
			projectile.Touched:Connect(function(hit)
				if touched then return end
				touched = true

				local sound = Instance.new("Sound")
				sound.SoundId = "rbxassetid://3149249837"
				sound.Volume = 1
				sound.EmitterSize = 30
				sound.MaxDistance = 100
				sound.RollOffMode = Enum.RollOffMode.Linear
				sound.Parent = workspace
				sound:Play()
				game:GetService("Debris"):AddItem(sound, 5)

				local power = tonumber(powerBox.Text) or 1000
				power = math.clamp(power, 1, 1000)

				local explosion = Instance.new("Explosion")
				explosion.Position = projectile.Position
				explosion.BlastRadius = 20
				explosion.BlastPressure = power * 1000
				explosion.DestroyJointRadiusPercent = 0
				explosion.Parent = workspace

				explosion.Hit:Connect(function(part)
					local char = part:FindFirstAncestorOfClass("Model")
					local humanoid = char and char:FindFirstChildOfClass("Humanoid")
					if humanoid and char ~= player.Character then
						if not enablePlayerDamage then return end
						humanoid.Health = 0

						for _,p in pairs(char:GetDescendants()) do
							if p:IsA("BasePart") then
								p.Anchored = false
								p.Velocity = Vector3.new(math.random(-150,150), math.random(150,250), math.random(-150,150))
								local fadeTween = TweenService:Create(p, TweenInfo.new(2), {
									Transparency = 1
								})
								fadeTween:Play()
							end
						end

						task.delay(1, function()
							if char then
								char:Destroy()
							end
						end)
					end
				end)

				projectile:Destroy()
			end)

			task.delay(0, function()
				canFire = true
				fireButton.Text = "💥"
			end)
		end)
	end
})

--==ここより下は別のタブになります==--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local selectedPlayerName = nil

--タブの作成
local TeleportTab = Window:MakeTab({
	Name = "Teleport Menu",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

--セクションの作成
local Section = TeleportTab:AddSection({
	Name = "Player Select"
})

-- ドロップダウンを1回だけ定義
local Dropdown = TeleportTab:AddDropdown({
	Name = "Player List",
	Default = "選択してください",
	Options = {}, -- 初期は空
	Callback = function(Value)
		local username = Value:match("%((.-)%)")
		selectedPlayerName = username
		print("選択されたプレイヤー:", selectedPlayerName)
	end
})

-- プレイヤーリスト更新関数
local function UpdatePlayerList()
	local playerNames = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			table.insert(playerNames, player.DisplayName .. "(" .. player.Name .. ")")
		end
	end
	if Dropdown then
		Dropdown:Refresh(playerNames, true)
	end
end

-- 初回実行
UpdatePlayerList()

-- プレイヤー入退室でリスト更新
Players.PlayerAdded:Connect(function()
	task.wait(1)
	UpdatePlayerList()
end)

Players.PlayerRemoving:Connect(function()
	task.defer(UpdatePlayerList)
end)

--Teleport
TeleportTab:AddButton({
	Name = "Teleport",
	Callback = function()
		if selectedPlayerName then
			local targetPlayer = Players:FindFirstChild(selectedPlayerName)
			if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
				print("テレポート完了")
			else
				OrionLib:MakeNotification({
					Name = "テレポート失敗",
					Content = "対象のプレイヤーが見つかりません",
					Image = "rbxassetid://4483345998",
					Time = 5
				})
			end
		else
			OrionLib:MakeNotification({
				Name = "プレイヤー未選択",
				Content = "プレイヤーを選んでください。",
				Image = "rbxassetid://4483345998",
				Time = 5
			})
		end
	end
})

-- View Toggle
local viewConnection = nil -- CharacterAddedの接続を保存しておく変数

TeleportTab:AddToggle({
	Name = "View",
	Default = false,
	Callback = function(state)
		local camera = Workspace.CurrentCamera
		if state then
			if selectedPlayerName then
				local targetPlayer = Players:FindFirstChild(selectedPlayerName)
				if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
					camera.CameraSubject = targetPlayer.Character:FindFirstChild("Humanoid")
					print("カメラを", selectedPlayerName, "に切り替えました。")
					
					-- リスポーン対応のためのCharacterAddedイベント登録
					viewConnection = targetPlayer.CharacterAdded:Connect(function(newCharacter)
						local humanoid = newCharacter:WaitForChild("Humanoid", 5)
						if humanoid then
							camera.CameraSubject = humanoid
							print("対象プレイヤーがリスポーンしました。カメラを再設定しました。")
						end
					end)
				else
					warn("対象プレイヤーが見つかりません。")
					OrionLib:MakeNotification({
						Name = "対象のプレイヤーが見つかりませんでした。",
						Content = "もう一度確認してください",
						Image = "rbxassetid://4483345998",
						Time = 5
					})
				end
			else
				warn("プレイヤーが選択されていません。")
				OrionLib:MakeNotification({
					Name = "プレイヤーが選択されていません。",
					Content = "プレイヤーを選択してください",
					Image = "rbxassetid://4483345998",
					Time = 5
				})
			end
		else
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
				print("カメラを自分に戻しました。")
			end
			-- イベントの接続を解除
			if viewConnection then
				viewConnection:Disconnect()
				viewConnection = nil
			end
		end
	end
})

--ここから新しいタブ

--タブの作成
local ESPTab = Window:MakeTab({
	Name = "ESP",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

--セクションの作成
local Section = ESPTab:AddSection({
	Name = "Player Esp"
})

--espトグル
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local espEnabled = false
local espLabels = {}

local function removeESP(player)
	if espLabels[player] then
		if espLabels[player].updateConn then
			espLabels[player].updateConn:Disconnect()
		end
		if espLabels[player].gui then
			espLabels[player].gui:Destroy()
		end
		espLabels[player] = nil
	end
end

local function createESP(player)
	if player == LocalPlayer then return end
	if not player.Character or not player.Character:FindFirstChild("Head") then return end

	local head = player.Character.Head
	local humanoid = player.Character:FindFirstChild("Humanoid")
	if not humanoid then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESPLabel"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 200, 0, 30)  -- 高さ小さめ
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextStrokeTransparency = 0.5
	textLabel.TextScaled = false
	textLabel.TextSize = 14  -- 小さめ文字サイズ
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Parent = billboard

	local function updateColor()
		if player.Neutral or not player.Team then
			textLabel.TextColor3 = Color3.new(1, 1, 1)
		else
			textLabel.TextColor3 = player.TeamColor.Color
		end
	end
	updateColor()

	local function onDeath()
		removeESP(player)
	end
	humanoid.Died:Connect(onDeath)

	espLabels[player] = {
		gui = billboard,
		label = textLabel,
		updateConn = RunService.RenderStepped:Connect(function()
			if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
				local humanoid = player.Character.Humanoid
				local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
				textLabel.Text = string.format("%s / %s | HP: %d | %.0f studs", player.DisplayName, player.Name, humanoid.Health, distance)
			else
				textLabel.Text = "Loading..."
			end
			updateColor()
		end)
	}
end

local function setupCharacterESP(player)
	player.CharacterAdded:Connect(function()
		player.Character:WaitForChild("Humanoid")
		player.Character:WaitForChild("Head")
		wait(0.5)
		if espEnabled then
			createESP(player)
		end
	end)
end

-- ESPトグル本体
ESPTab:AddToggle({
	Name = "ESP",
	Default = false,
	Callback = function(Value)
		espEnabled = Value

		if espEnabled then
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					setupCharacterESP(player)
					if player.Character then
						createESP(player)
					end
				end
			end

			Players.PlayerAdded:Connect(function(player)
				if player ~= LocalPlayer then
					setupCharacterESP(player)
				end
			end)
		else
			for _, player in pairs(Players:GetPlayers()) do
				removeESP(player)
			end
		end
	end
})

--Icon Toggle
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local iconEspEnabled = false
local iconEspLabels = {}

local function removeIconESP(player)
	if iconEspLabels[player] then
		if iconEspLabels[player].gui then
			iconEspLabels[player].gui:Destroy()
		end
		iconEspLabels[player] = nil
	end
end

local function createIconESP(player)
	if player == LocalPlayer then return end
	if not player.Character or not player.Character:FindFirstChild("Head") then return end

	local head = player.Character.Head
	local humanoid = player.Character:FindFirstChild("Humanoid")
	if not humanoid then return end

	-- RobloxのサムネイルAPIを使って直接URLを作成
	local thumbnail = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=100&height=100&format=png"

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "IconESP"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 30, 0, 30) -- 小さめ
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = thumbnail
	imageLabel.Parent = billboard

	local function onDeath()
		removeIconESP(player)
	end
	humanoid.Died:Connect(onDeath)

	iconEspLabels[player] = {
		gui = billboard
	}
end

local function setupIconCharacterESP(player)
	player.CharacterAdded:Connect(function()
		player.Character:WaitForChild("Humanoid")
		player.Character:WaitForChild("Head")
		wait(0.5)
		if iconEspEnabled then
			createIconESP(player)
		end
	end)
end

-- トグル本体
ESPTab:AddToggle({
	Name = "Icon",
	Default = false,
	Callback = function(Value)
		iconEspEnabled = Value

		if iconEspEnabled then
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					setupIconCharacterESP(player)
					if player.Character then
						createIconESP(player)
					end
				end
			end

			Players.PlayerAdded:Connect(function(player)
				if player ~= LocalPlayer then
					setupIconCharacterESP(player)
				end
			end)
		else
			for _, player in pairs(Players:GetPlayers()) do
				removeIconESP(player)
			end
		end
	end
})

--ここから新しいタブ

--タブの作成
local ServerTab = Window:MakeTab({
	Name = "Server",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

--セクションの作成
ServerTab:AddSection({
	Name = "Place"
})

--Rejoin button
ServerTab:AddButton({
	Name = "Rejoin",
	Callback = function()
		print("Rejoining...")
		game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
	end    
})

--ServerHop button
ServerTab:AddButton({
	Name = "ServerHop",
	Callback = function()
		print("Server hopping...")
		local TeleportService = game:GetService("TeleportService")
		local HttpService = game:GetService("HttpService")
		local Players = game:GetService("Players")
		local placeId = game.PlaceId
		local servers = {}

		local success, response = pcall(function()
			return HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"))
		end)

		if success and response and response.data then
			for _, server in pairs(response.data) do
				if server.playing < server.maxPlayers and server.id ~= game.JobId then
					table.insert(servers, server.id)
				end
			end

			if #servers > 0 then
				local randomServerId = servers[math.random(1, #servers)]
				TeleportService:TeleportToPlaceInstance(placeId, randomServerId, Players.LocalPlayer)
			else
				warn("No available servers found.")
			end
		else
			warn("Failed to get server list.")
		end
	end
})

--日本人サーバーに行くボタン
ServerTab:AddButton({
	Name = "Japanese Server",
	Callback = function()
		print("button pressed")

		local Players = game:GetService("Players")
		local TeleportService = game:GetService("TeleportService")
		local LocalizationService = game:GetService("LocalizationService")

		local player = Players.LocalPlayer
		local locale = LocalizationService.RobloxLocaleId -- e.g., "ja-jp", "en-us"
		local langCode = string.sub(locale, 1, 2)

		local placeId = game.PlaceId

		if langCode == "ja" then
			-- 日本語の人を対象にした「再参加」的処理（ランダムなパブリックサーバー）
			TeleportService:Teleport(placeId, player)
		else
			-- 日本人じゃないなら別の処理（ここでは同じ処理をしている）
			TeleportService:Teleport(placeId, player)
		end
	end    
})

--ここから新しいタブ

--タブの作成
local ChatTab = Window:MakeTab({
	Name = "Chat",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

--セクションの作成
local Section = ChatTab:AddSection({
	Name = "PlayerChat"
})

--ChatSpy Toggle
local spyConnections = {}
local spyEnabled = false

ChatTab:AddToggle({
	Name = "ChatSpy",
	Default = false,
	Callback = function(Value)
		spyEnabled = Value

		-- 有効化処理
		if Value then
			local Players = game:GetService("Players")
			local player = Players.LocalPlayer
			local StarterGui = game:GetService("StarterGui")
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local saymsg = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
			local getmsg = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")

			local public = false
			local publicItalics = true
			local spyOnMyself = false

			local privateProperties = {
				Color = Color3.fromRGB(0,255,255),
				Font = Enum.Font.SourceSansBold,
				TextSize = 18,
			}

			local function onChatted(p, msg)
				if not spyEnabled then return end
				if spyOnMyself or p ~= player then
					msg = msg:gsub("[\n\r]", ""):gsub("\t", " "):gsub(" +", " ")
					local hidden = true
					local conn = getmsg.OnClientEvent:Connect(function(packet, channel)
						if packet.SpeakerUserId == p.UserId and packet.Message == msg:sub(#msg - #packet.Message + 1) and
							(channel == "All" or (channel == "Team" and not public and Players[packet.FromSpeaker].Team == player.Team)) then
							hidden = false
						end
					end)
					wait(1)
					conn:Disconnect()
					if hidden and spyEnabled then
						if public then
							saymsg:FireServer((publicItalics and "/me " or "") .. "{SPY} [" .. p.Name .. "]: " .. msg, "All")
						else
							privateProperties.Text = "{SPY} [" .. p.Name .. "]: " .. msg
							StarterGui:SetCore("ChatMakeSystemMessage", privateProperties)
						end
					end
				end
			end

			for _, p in ipairs(Players:GetPlayers()) do
				table.insert(spyConnections, p.Chatted:Connect(function(msg) onChatted(p, msg) end))
			end

			table.insert(spyConnections, Players.PlayerAdded:Connect(function(p)
				table.insert(spyConnections, p.Chatted:Connect(function(msg) onChatted(p, msg) end))
			end))

			privateProperties.Text = "{SPY ENABLED}"
			StarterGui:SetCore("ChatMakeSystemMessage", privateProperties)

		else
			-- 無効化処理
			for _, conn in ipairs(spyConnections) do
				if conn and conn.Disconnect then
					conn:Disconnect()
				end
			end
			spyConnections = {}

			local StarterGui = game:GetService("StarterGui")
			local privateProperties = {
				Text = "{SPY DISABLED}",
				Color = Color3.fromRGB(255, 0, 0),
				Font = Enum.Font.SourceSansBold,
				TextSize = 18,
			}
			StarterGui:SetCore("ChatMakeSystemMessage", privateProperties)
		end
	end
})

--新しいタブ
local othersTab = Window:MakeTab({
	Name = "Others",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Section = othersTab:AddSection({
	Name = "OtherScripts"
})

--iy
othersTab:AddButton({
	Name = "IY",
	Callback = function()
      		print("button pressed")
		loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
  	end    
})

--fling
othersTab:AddButton({
	Name = "Fling",
	Callback = function()
      		print("button pressed")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe./main/Fling%20GUI"))()
  	end    
})
--AnimationTab
othersTab:AddButton({
	Name = "AnimationGUI",
	Callback = function()
      		print("button pressed")
		loadstring(game:HttpGet('https://raw.githubusercontent.com/works-yesed-scriptedit/Animation-GUI-Script/refs/heads/main/MainScript'))()
	end
})

--errorexecutor
othersTab:AddButton({
	Name = "ErrorExecutor",
	Callback = function()
      		print("button pressed")
		loadstring(game:HttpGet('https://raw.githubusercontent.com/works-yesed-scriptedit/ErrorExecutor/refs/heads/main/MainScript.lua'))()
	end
})

othersTab:AddButton({
	Name = "VolleyBall",
	Callback = function()
      		print("button pressed")
		loadstring(game:HttpGet('https://raw.githubusercontent.com/works-yesed-scriptedit/Volleyballregendsscript/refs/heads/main/mainscript.lua'))()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/works-yesed-scriptedit/Volleyballregendsscript/refs/heads/main/floormake.lua'))()
	end
})

OrionLib:Init()
