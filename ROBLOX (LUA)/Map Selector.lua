--[[
	Written by Tim Sternberg, around 2015
	The local code for selecting a map, game mode, and various settings
	Is within a GUI, parts of which are pre-rendered.
--]]

-- Settings
local DoNotWarnIfNoWeapons = {["Obstacle Course"]=true}

-- Player variables
local player = game.Players.LocalPlayer
local PlayerGui = player.PlayerGui
local gui = script.Parent
local mouse = player:GetMouse()

-- Folders
local WorkspaceMaps = workspace:WaitForChild("Maps")
local Values = game.ReplicatedStorage:WaitForChild("Values")
local RemObjects = game.ReplicatedStorage:WaitForChild("RemoteObjects")
local Maps = game.ReplicatedStorage:WaitForChild("Storage"):WaitForChild("MAPS")
local GameModes = game.ReplicatedStorage:WaitForChild("Storage"):WaitForChild("Game Modes")
local Tools = game.ReplicatedStorage:WaitForChild("Storage"):WaitForChild("HoloTools")

-- Remote Events
local MapStart = RemObjects:WaitForChild("MapStart")
local EndMapEvent = RemObjects:WaitForChild("EndMap")
local EndQueueEvent = RemObjects:WaitForChild("EndQueue")

-- Remote Functions
local GetQueue = RemObjects:WaitForChild("GetQueue")

-- Data
local EndMapKey = "gh79gh347gh379g3y9g349gh934g394tg3g3g4"
local EndQueueKey = "grioeghrgh3479gh349hg934hg93g5g4f439yg49"

-- GUIs
local Main = gui:WaitForChild("Main") Main.Visible = false
local WarningF = Main:WaitForChild("Warning")
local Answer_Warn = WarningF:WaitForChild("Answer")
local GoBack_Warn = WarningF:WaitForChild("No") GoBack_Warn.MouseButton1Click:Connect(function() Answer_Warn.Value = 0 end)
local Continue_Warn = WarningF:WaitForChild("Yes") Continue_Warn.MouseButton1Click:Connect(function() Answer_Warn.Value = 1 end)
local OpenButton = PlayerGui:WaitForChild("Selection"):WaitForChild("Main"):WaitForChild("Holder"):WaitForChild(script.Parent.Name)
local QTitle = Main:WaitForChild("Queue_Title")
local QBackground = Main:WaitForChild("QueueBackground")
local QFrame = Main:WaitForChild("Queue")
	local QueueLabel = QFrame:WaitForChild("Example") QueueLabel.Parent = script
local ScrHolder = Main:WaitForChild("ScrHolder")
local Scr1 = ScrHolder:WaitForChild("Scr1")
	local MapLabel = Scr1:WaitForChild("Example") MapLabel.Parent = script
local Scr2 = ScrHolder:WaitForChild("Scr2")
	local GMFrame = Scr2:WaitForChild("GameMode")
		local GMLabel = GMFrame:WaitForChild("Example") GMLabel.Parent = script
	local SettFrame = Scr2:WaitForChild("Settings")
		local SettingLabel = SettFrame:WaitForChild("Example") SettingLabel.Parent = script
	local WeapFrame = Scr2:WaitForChild("Weapons")
		local WeaponLabel = WeapFrame:WaitForChild("Example") WeaponLabel.Parent = script
local Toolbar = Main:WaitForChild("Toolbar")
	local AddButton = Toolbar:WaitForChild("Add")
		local AddButtonPos = AddButton.Position
	local Search = Toolbar:WaitForChild("Search")
		local ClearSearchButton = Search:WaitForChild("Clear")
		local SearchPos = Search.Position
	local StartButton = Toolbar:WaitForChild("Start")
		local StartButtonPos = StartButton.Position
	local BackButton = Toolbar:WaitForChild("Back")
		local BackPos = BackButton.Position
	local ListType = Toolbar:WaitForChild("ListType")
		local ListTypePos = ListType.Position
	local EndMapButton = Toolbar:WaitForChild("EndMap")
		local EndMapPos = EndMapButton.Position
	local ClearQueueButton = Toolbar:WaitForChild("ClearQueue")
		local ClearQueuePos = ClearQueueButton.Position
	local CloseButton = Toolbar:WaitForChild("Close")

-- Modules
local Scripts = game.ReplicatedStorage:WaitForChild("Scripts")
local AvailableSettings = require(Scripts:WaitForChild("AvailableSettings"))

-- Local Variables
local dragging = false
local ListingByGM = false
local FirstOpen = false
local Queue = {}
local RowLength = math.floor(Scr1.AbsoluteSize.X/MapLabel.AbsoluteSize.X)
local RowSpace = (Scr1.AbsoluteSize.X - (MapLabel.AbsoluteSize.X*RowLength))/RowLength
local CurrList
local PrevList

local CurrentQueue = {
	["MapName"] = nil;
	["GameMode"] = nil;
	["Weapons"] = {};
	["Settings"] = {};
}

All_Maps = {}
for i,c in pairs(Maps:GetChildren()) do
	table.insert(All_Maps,c.Name)
end
table.sort(All_Maps)

All_GM = {}
for i,c in pairs(GameModes:GetChildren()) do
	table.insert(All_GM,c.Name)
end

-- Functions
function QueueUpdate()
	Queue = GetQueue:InvokeServer()
	
	for i,label in pairs(QFrame:GetChildren()) do
		label:TweenPosition(label.Position+UDim2.new((-1)^i,0,0,0),"Out","Quad",0.5,true)
	end
	wait(0.5)
	QFrame:ClearAllChildren()
	for i = 1,#Queue do
		AddToQueueFrame(i)
	end
end

function ClearQueue()
	EndQueueEvent:FireServer(EndQueueKey)
	for i,label in pairs(QFrame:GetChildren()) do
		label:TweenPosition(label.Position+UDim2.new((-1)^i,0,0,0),"Out","Quad",0.5,true)
	end
	wait(0.5)
	QFrame:ClearAllChildren()
	Queue = {}
end

function EndMap()
	EndMapEvent:FireServer(EndMapKey)
end

function Open()
	Main.Position = UDim2.new(0.5,-Main.AbsoluteSize.X/2,0.5,-Main.AbsoluteSize.Y/2) - UDim2.new(1,0,0,0)
	Main.Visible = true
	Main:TweenPosition(UDim2.new(0.5,-Main.AbsoluteSize.X/2,0.5,-Main.AbsoluteSize.Y/2), "Out", "Quart", 0.5, true)
	if not FirstOpen then
		FirstOpen = true
		Scr2.Visible = false
		Scr1.Position = UDim2.new(0,0,0,10)
		Scr1.Visible = true
		QFrame.Visible = true
		QTitle.Visible = true
		QFrame:TweenSizeAndPosition(UDim2.new(0,187,0,380),UDim2.new(1,10,0,80),"Out","Quad",0.5,true)
		QTitle:TweenPosition(UDim2.new(1,10,0,50),"Out","Quad",0.5,true)
		QBackground:TweenSize(UDim2.new(0,207,1,-70),"Out","Quad",0.5,true)
		ListMaps(All_Maps)
	end
end

function Close()
	Main:TweenPosition(Main.Position + UDim2.new(1,0,0,0), "Out", "Quart", 0.5, true)
	wait(0.5)
	Main.Visible = false
end

function ToMapScreen()
	CurrentQueue.MapName = nil
	CurrentQueue.GameMode = nil
	CurrentQueue.Weapons = {}
	CurrentQueue.Settings = {}
	
	Scr2:TweenPosition(UDim2.new(-1,0,0,0),"Out","Quad",0.5,true)
	AddButton:TweenPosition(AddButtonPos+UDim2.new(0,0,0,-40),"Out","Quad",0.5,true)
	BackButton:TweenPosition(BackPos+UDim2.new(0,0,0,-40),"Out","Quad",0.5,true)
	EndMapButton:TweenPosition(EndMapPos,"Out","Quad",0.5,true)
	ClearQueueButton:TweenPosition(ClearQueuePos,"Out","Quad",0.5,true)
	
	wait(0.5)
	Scr2.Visible = false
	AddButton.Visible = false
	BackButton.Visible = false
	
	Search.Position = SearchPos+UDim2.new(0,0,0,-40)
	ListType.Position = ListTypePos+UDim2.new(0,0,0,-40)
	Scr1.Position = UDim2.new(-1,0,0,10)
	Scr1.Visible = true
	Search.Visible = true
	ListType.Visible = true
	
	Scr1:TweenPosition(UDim2.new(0,0,0,10),"Out","Quad",0.5,true)
	Search:TweenPosition(SearchPos,"Out","Quad",0.5,true)
	ListType:TweenPosition(ListTypePos,"Out","Quad",0.5,true)
	QFrame:TweenSizeAndPosition(UDim2.new(0,187,0,380),UDim2.new(1,10,0,80),"Out","Quad",0.5,true)
	QTitle:TweenPosition(UDim2.new(1,10,0,50),"Out","Quad",0.5,true)
	QBackground:TweenSize(UDim2.new(0,207,1,-70),"Out","Quad",0.5,true)
	if ListingByGM then
		BackButton.Text = "GAMEMODES"
		BackButton.Visible = true
		BackButton:TweenPosition(BackPos,"Out","Quad",0.5,true)
	end
end

function Back()
	ClearSearch()
	if BackButton.Text == "MAPS" then
		ToMapScreen()
	elseif BackButton.Text == "GAMEMODES" then
		BackButton:TweenPosition(BackPos+UDim2.new(0,0,0,-40),"Out","Quad",0.5,true)
		ListGameModes()
		wait(0.5)
		BackButton.Visible = false
	end
end

function SearchFocusLost()
	if Search.Text == "" then
		ClearSearch(true)
	else
		ClearSearchButton.Visible = true
		local list = {}
		local text = Search.Text
		for _,n in pairs(CurrList) do -- Going through the current list on the screen
			for i = 1,string.len(n) do
				if string.lower( string.sub(n,i,i-1+string.len(text)) ) == string.lower(text) then
					table.insert(list,n)
					break
				end
			end
		end

		ListMaps(list,false,true)
	end
end

function SearchFocused()
	Search.TextColor3 = Color3.new(50/255,50/255,50/255)
end

function ClearSearchEnter()
	ClearSearchButton.TextColor3 = Color3.new(0,0,0)
end

function ClearSearchLeave()
	ClearSearchButton.TextColor3 = Color3.new(130/255,130/255,130/255)
end

function ClearSearchClick()
	ClearSearch(true)
end

function AddToQueueFrame(QueuePlace)
	local label = QueueLabel:Clone()
	label.Name = QueuePlace
	label.Text = QueuePlace .. ". " .. Queue[QueuePlace].MapName --CurrentQueue.MapName
	label.Position = UDim2.new(-1,0,0,25*(#QFrame:GetChildren()-1))
	label.Parent = QFrame
	label:TweenPosition(UDim2.new(0.025,0,0,25*(#QFrame:GetChildren()-1)),"Out","Quad",0.25,true)
	QFrame.CanvasSize = UDim2.new(0,0,0,#QFrame:GetChildren()*25)
	label.MouseEnter:connect(function()
		if not dragging then
			label:WaitForChild("Remove").Visible = true
			label:WaitForChild("Move").Visible = true
		end
	end)
	label.MouseLeave:connect(function()
		if not dragging then
			label:WaitForChild("Remove").Visible = false
			label:WaitForChild("Move").Visible = false
		end
	end)
	label:WaitForChild("Remove").MouseButton1Click:connect(function()
		local ObjectToRemove = label.Name
		
		table.remove(Queue,ObjectToRemove)
		
		for i = ObjectToRemove+1,#QFrame:GetChildren() do
			QFrame[i]:TweenPosition(UDim2.new(0.025,0,0,25*(i-2)),"Out","Quad",0.5,true)
			QFrame[i].Text = i-1 .. ". " .. string.sub(QFrame[i].Text,4)
			QFrame[i].Name = i-1
		end
		
		label:TweenPosition(label.Position-UDim2.new(1,0,0,0),"Out","Quad",0.1,true)
		wait(0.1)
		label:Destroy()
	end)
	label:WaitForChild("Move").MouseButton1Down:connect(function()
		dragging = true
		label:Destroy()
		label.Parent = QFrame
		label.BackgroundColor3 = Color3.new(130/255,130/255,130/255)
		label.TextTransparency = 0.5
		label:WaitForChild("Remove").Visible = false
		label:WaitForChild("Move").Visible = false
		local Mpos = UDim2.new(0,mouse.X,0,mouse.Y)
		local Lpos = label.Position
		move = mouse.Move:connect(function()
			label.Position = Lpos + UDim2.new(0,mouse.X-Mpos.X.Offset,0,mouse.Y-Mpos.Y.Offset)
			
			local relativePos = label.AbsolutePosition.Y - QFrame.AbsolutePosition.Y - (25*(tonumber(label.Name)-1))
			
			local function TweenObjects(ToSpot)
				if not QFrame:FindFirstChild(tonumber(label.Name)+ToSpot) then return end
				
				local label2 = QFrame[tonumber(label.Name)+ToSpot]
				label2.Name = tonumber(label.Name)
				label2.Text = tonumber(label2.Name) .. ". " .. string.sub(label2.Text,4)
				label2:TweenPosition(UDim2.new(0.025,0,0,25*(tonumber(label2.Name)-1)),"Out","Quad",0.5,true)
				local old = Queue[tonumber(label2.Name)]
				Queue[tonumber(label2.Name)] = Queue[tonumber(label.Name)]
				
				label.Name = tonumber(label2.Name) +ToSpot
				label.Text =  tonumber(label.Name) .. ". " .. string.sub(label.Text,4)
				Queue[tonumber(label.Name)] = old
			end			
			
			if relativePos > 13 then
				TweenObjects(1)
			elseif relativePos <= -13 then
				TweenObjects(-1)
			end 
		end)
		up = label.MouseButton1Up:connect(function()
			dragging = false
			move:disconnect()
			up:disconnect()
			label.BackgroundColor3 = Color3.new(166/255,166/255,166/255)
			label.TextTransparency = 0
			label:TweenPosition(UDim2.new(0.025,0,0,25*(tonumber(label.Name)-1)),"Out","Quad",0.25,true)
			label:WaitForChild("Remove").Visible = true
			label:WaitForChild("Move").Visible = true
		end)
	end)
end

local AddToQueue_debounce
function AddToQueue()
	if AddToQueue_debounce then return end
	AddToQueue_debounce = true

	if not (CurrentQueue.MapName and CurrentQueue.GameMode) then AddToQueue_debounce = false return end

	if #CurrentQueue.Weapons == 0 and not DoNotWarnIfNoWeapons[CurrentQueue.GameMode] then
		WarningF.Visible = true
		Answer_Warn.Value = -1
		repeat wait(0.1) until Answer_Warn.Value ~= -1
		WarningF.Visible = false
		if Answer_Warn.Value == 0 then
			AddToQueue_debounce = false
			return 
		end
	end
	
	for i,c in pairs(SettFrame:GetChildren()) do -- Populating the saved settings before we Add it to the queue
		if c.Enabled.BackgroundColor3 == Color3.new(124/255,124/255,124/255) then
			local amount
			if c:FindFirstChild("Amount") then
				amount = c["Amount"].TextBox.Text
			end
			CurrentQueue.Settings[c.Name] = {true,amount}
		else
			CurrentQueue.Settings[c.Name] = {false}
		end
	end
	local QueuePlace = #Queue+1
	table.insert(Queue,{
		["MapName"]= CurrentQueue.MapName;
		["GameMode"] = CurrentQueue.GameMode;
		["Weapons"] = CurrentQueue.Weapons;
		["Settings"] = CurrentQueue.Settings;
	})
	
	AddToQueueFrame(QueuePlace)

	ToMapScreen() -- Needs to be last since everything is cleared in the function
	
	AddToQueue_debounce = false
end

function Start()
	if #Queue > 0 then
		coroutine.resume(coroutine.create(function() Close() ToMapScreen() end))
			
		AddButton:TweenPosition(AddButtonPos+UDim2.new(0,0,0,-40),"Out","Quad",0.25,true)
		StartButton:TweenPosition(StartButtonPos+UDim2.new(0,0,0,-40),"Out","Quad",0.25,true)
		BackButton:TweenPosition(BackPos+UDim2.new(0,0,0,-40),"Out","Quad",0.25,true)
		EndMapButton:TweenPosition(EndMapPos,"Out","Quad",0.5,true)
		ClearQueueButton:TweenPosition(ClearQueuePos,"Out","Quad",0.5,true)
		
		for i,c in pairs(Queue) do
			MapStart:FireServer(Queue[i],i)
			wait(1)
		end	
		
		wait(3)
		StartButton:TweenPosition(StartButtonPos,"Out","Quad",0.25,true)
	end
end

function ListGameModes()
	Scr1:TweenPosition(UDim2.new(-1,0,0,10),"Out","Quad",0.5,true)
	Search:TweenPosition(SearchPos+UDim2.new(0,0,0,-40),"Out","Quad",0.5,true)
	wait(0.5)
	
	local function GMClicked(GM)
		Scr1:TweenPosition(UDim2.new(-1,0,0,10),"Out","Quad",0.5,true)
		wait(0.5)
		local maps = {}
		for i,c in pairs(All_Maps) do
			if Maps[c]:FindFirstChild(GM.Name) then
				table.insert(maps,c)
			end
		end
		table.sort(maps)
		ListMaps(maps,true)
		BackButton.Text = "GAMEMODES"
		BackButton.Position = BackPos+UDim2.new(0,0,0,-40)
		BackButton.Visible = true
		BackButton:TweenPosition(BackPos,"Out","Quad",0.5,true)
		Scr1:TweenPosition(UDim2.new(0,0,0,10),"Out","Quad",0.5,true)
	end
	
	if CurrList then PrevList = CurrList end
	CurrList = All_GM
	
	Scr1:ClearAllChildren()
	Scr1.CanvasSize = UDim2.new( 0,0,0,math.floor((#All_GM/RowLength)+0.999)*(MapLabel.AbsoluteSize.Y) + 10)
	local yPos = 0
	for i,v in pairs(All_GM) do
		local c = GameModes[v]
		local label = MapLabel:Clone()
		label.Name = c.Name
		label.Parent = Scr1
		label.TextButton.Text = c.Name
		label.ImageButton.Image = "http://assetgame.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId="..c.Value
		label.Position = UDim2.new(0,( (i-1)%RowLength )*( MapLabel.AbsoluteSize.X+RowSpace ),0,yPos)
		if i%RowLength == 0 then
			yPos = (i/RowLength)*label.AbsoluteSize.Y -- Setting a new column
		end
		label.MouseEnter:connect(function()
			label.BackgroundTransparency = 0
		end)
		label.MouseLeave:connect(function()
			label.BackgroundTransparency = 1
		end)
		label.ImageButton.MouseButton1Click:connect( function() GMClicked(c) end )
		label.TextButton.MouseButton1Click:connect( function() GMClicked(c) end )
		--wait()
	end
	
	Scr1:TweenPosition(UDim2.new(0,0,0,10),"Out","Quad",0.5,true)
end

function ChangeListType()
	local GMColor = Color3.new(0,85/255,0)
	local MapColor = Color3.new(132/255,132/255,0)
	
	ClearSearch()
	
	if ListType.BackgroundColor3 == GMColor then
		ListGameModes()
		ListType.BackgroundColor3 = MapColor
		ListType.Text = "LIST BY MAP"
	elseif ListType.BackgroundColor3 == MapColor then
		Scr1:TweenPosition(UDim2.new(-1,0,0,10),"Out","Quad",0.5,true)
		BackButton:TweenPosition(BackPos+UDim2.new(0,0,0,-40),"Out","Quad",0.5,true)
		wait(0.5)
		BackButton.Visible = false
		ListMaps(All_Maps)
		ListType.BackgroundColor3 = GMColor
		ListType.Text = "LIST BY GAMEMODE"
		Scr1:TweenPosition(UDim2.new(0,0,0,10),"Out","Quad",0.5,true)
	end
end

function ClearSearch(ReList)
	Search.Text = "Search by Map Name"
	Search.TextColor3 = Color3.new(145/255,145/255,145/255)
	ClearSearchButton.Visible = false
	ClearSearchButton.TextColor3 = Color3.new(130/255,130/255,130/255)
	if ReList then
		ListMaps(PrevList,ListingByGM)
	end
end

function FindInTable(Table,name)
	for i,c in pairs(Table) do
		if c == name then
			return i
		end
	end
end

function CheckSettings(c)
	if not c.Setting then
		return true
	else
		for _,Condition in pairs(c.Condition) do
			if CurrentQueue[c.Setting] == Condition then
				return true
			else
				local function TableTest()
					for i,c in pairs(CurrentQueue[c.Setting]) do
						break
					end
				end
				local success,message = pcall(TableTest)
				if success then
					for _,item in pairs(CurrentQueue[c.Setting]) do
						if item == Condition then
							return true
						end
					end
				else
				end
			end
		end
	end
end

function PopulateSettingsFrame()
local lines = 0
	SettFrame:ClearAllChildren()
	for i,c in pairs(AvailableSettings) do
		local enabled = CheckSettings(c)
		local value = Values:FindFirstChild(i)
		if value then
			local label = SettingLabel:Clone()
			label.Name = value.Name
			label.Parent = SettFrame
			label.Position = UDim2.new(0.025,0,0,25*lines)
			lines = lines + 1
			local LocalLines = 1
			local c = value:FindFirstChild("Amount")
			local function Enable() label.Enabled.BackgroundColor3 = Color3.new(124/255,124/255,124/255) end
			local function Disable() label.Enabled.BackgroundColor3 = Color3.new(230/255,230/255,230/255) end
			if value:IsA("BoolValue") then
				label.Enabled.MouseButton1Click:connect(function()
					if label.Enabled.BackgroundColor3 == Color3.new(124/255,124/255,124/255) then
						Disable()
					else
						Enable()
					end
				end)
			elseif value:IsA("IntValue") or value:IsA("NumberValue") then
				c = value
			end
			if value.Value then Enable() end
			if c then
				local label2 = label:WaitForChild("Example"):Clone()
				label2.Name = "Amount" --c.Name
				label2.Parent = label
				label2.Position = UDim2.new(0.1,0,1*LocalLines,0)
				label2.TextBox.Text = c.Value
				LocalLines = LocalLines + 1
				lines = lines + 1
				if value:FindFirstChild("ViewName") then
					label2.Title.Text = value["ViewName"].Value
				else
					label2.Title.Text = "Amount" --c.Name
				end
				label2.TextBox.FocusLost:connect(function()
					if c.ClassName ~= "StringValue" and not tonumber(label2.TextBox.Text) then
						label2.TextBox.Text = c.Value
					end
				end)
			end
			label:WaitForChild("Example").Parent = nil
			label.Title.Text = value.Name
		else
			warn(i .. " not found in 'Values' folder")
		end
	end
end

function ListMaps(maps,GMList,SearchList) -- ( List of STRING values of map names, Whether it's a list of game modes (bool), Whether it's a list from a search (bool) )
	CurrentQueue.MapName = nil
	CurrentQueue.GameMode = nil
	CurrentQueue.Weapons = {}
	CurrentQueue.Settings = {}
	
	local function UpdateSettings()
		for i,c in pairs(AvailableSettings) do
			local enabled = CheckSettings(c)
			local label = SettFrame:FindFirstChild(i)
			if label and enabled then
				label.Enabled:TweenPosition(UDim2.new(0,5,0,6),"Out","Quad",0.5,true)
			elseif label and not enabled then
				label.Enabled:TweenPosition(UDim2.new(0,-30,0,6),"Out","Quad",0.5,true)
			end
		end
	end
	
	--PopulateSettingsFrame()
	
	local function ListGM(map)
		GMFrame:ClearAllChildren()
		GMFrame.CanvasSize = UDim2.new(0,0,0,#map:GetChildren()*25)
		for i,c in pairs(map:GetChildren()) do
			local label = GMLabel:Clone()
			label.Name = c.Name
			label.Parent = GMFrame
			label.Text = c.Name
			label.Position = UDim2.new(0.025,0,0,25*(i-1))
			label.MouseButton1Click:connect(function()
				if CurrentQueue.GameMode ~= label.Name then
					label.BackgroundColor3 = Color3.new(85/255,85/255,127/255)
					label.TextColor3 = Color3.new(1,1,1)
					if CurrentQueue.GameMode then
						GMFrame[CurrentQueue.GameMode].BackgroundColor3 = Color3.new(212/255,212/255,212/255)
						GMFrame[CurrentQueue.GameMode].TextColor3 = Color3.new(81/255,81/255,81/255)
					end
					CurrentQueue.GameMode = label.Name
				end
				UpdateSettings(map)
			end)
		end
	end
	
	local function ListWeapon()
		WeapFrame:ClearAllChildren()
		WeapFrame.CanvasSize = UDim2.new(0,0,0,#Tools:GetChildren()*25)
		for i,c in pairs(Tools:GetChildren()) do
			local label = WeaponLabel:Clone()
			label.Name = c.Name
			label.Parent = WeapFrame
			label.Text = c.Name
			label.Position = UDim2.new(0.025,0,0,25*(i-1))
			label.MouseButton1Click:connect(function()
				if WarningF.Visible then return end
				if not FindInTable(CurrentQueue.Weapons,label.Name) then
					label.BackgroundColor3 = Color3.new(85/255,85/255,127/255)
					label.TextColor3 = Color3.new(1,1,1)
					table.insert(CurrentQueue.Weapons,label.Name)
				else
					label.BackgroundColor3 = Color3.new(212/255,212/255,212/255)
					label.TextColor3 = Color3.new(81/255,81/255,81/255)
					table.remove(CurrentQueue.Weapons,FindInTable(CurrentQueue.Weapons,label.Name))
				end
				UpdateSettings()
			end)
		end
	end
	
	local function MapClicked(label,map)
		CurrentQueue.MapName = map.Name
		ListGM(map)
		ListWeapon()
		PopulateSettingsFrame()
		UpdateSettings(map)
		Scr2:WaitForChild("ImageLabel").Image = label.ImageButton.Image
		Scr2:WaitForChild("ImageLabel"):WaitForChild("NameLabel").Text = label.Name
		
		label.BackgroundTransparency = 1
		Scr1:TweenPosition(UDim2.new(-1,0,0,10),"Out","Quad",0.5,true)
		Search:TweenPosition(SearchPos+UDim2.new(0,0,0,-40),"Out","Quad",0.5,true)
		ListType:TweenPosition(ListTypePos+UDim2.new(0,0,0,-40),"Out","Quad",0.5,true)
		BackButton:TweenPosition(BackPos+UDim2.new(0,0,0,-40),"Out","Quad",0.5,true)
		wait(0.5)
		ListType.Visible = false
		Search.Visible = false
		Scr1.Visible = false
		
		Scr2.Position = UDim2.new(-1,0,0,0)
		AddButton.Position = AddButtonPos+UDim2.new(0,0,0,-40)
		if not StartButton.Visible then StartButton.Position = StartButtonPos+UDim2.new(0,0,0,-40) end -- Show start and then keep it shown so we can start from the map screen
		BackButton.Position = BackPos+UDim2.new(0,0,0,-40)
		
		Scr2.Visible = true
		AddButton.Visible = true
		BackButton.Visible = true
		BackButton.Text = "MAPS"
		
		Scr2:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",0.5,true)
		AddButton:TweenPosition(AddButtonPos,"Out","Quad",0.5,true)
		EndMapButton:TweenPosition(EndMapPos+UDim2.new(0,0,0,-40),"Out","Quad",0.5,true)
		ClearQueueButton:TweenPosition(ClearQueuePos+UDim2.new(0,0,0,-40),"Out","Quad",0.5,true)
		if not StartButton.Visible then StartButton.Visible = true StartButton:TweenPosition(StartButtonPos,"Out","Quad",0.5,true) end
		BackButton:TweenPosition(BackPos,"Out","Quad",0.5,true)
		QFrame:TweenSizeAndPosition(UDim2.new(0,187,0,171),UDim2.new(0.75,3,0,80),"Out","Quad",0.5,true)
		QTitle:TweenPosition(UDim2.new(0.75,3,0,50),"Out","Quad",0.5,true)
		QBackground:TweenSize(UDim2.new(0,0,1,-70),"Out","Quad",0.5,true)
	end
	
	Search:TweenPosition(SearchPos,"Out","Quad",0.5,true)
	
	ListingByGM = GMList -- Letting everyone know that we're listing by game modes
	if not SearchList then
		if CurrList then
			PrevList = CurrList
		end
		CurrList = maps
	elseif not PrevList then -- In case prevlist isn't filled, so we don't get thrown an error
		PrevList = CurrList
	end
	
	Scr1:ClearAllChildren()
	Scr1.CanvasSize = UDim2.new( 0,0,0,math.floor((#maps/RowLength)+0.999)*(MapLabel.AbsoluteSize.Y) + 10)
	local yPos = 0
	for i,v in pairs(maps) do
		local c = Maps:FindFirstChild(v)
		if not c then return end
		local label = MapLabel:Clone()
		label.Name = c.Name
		label.Parent = Scr1
		label.TextButton.Text = c.Name
		if string.sub(c.Name,1,5) == "*NEW*" then label.TextButton.TextColor3 = Color3.new(148/255, 148/255, 221/255) end
		label.ImageButton.Image = "http://assetgame.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId="..c.Value
		label.Position = UDim2.new(0,( (i-1)%RowLength )*( MapLabel.AbsoluteSize.X+RowSpace ) + 1,0,yPos + 1)
		if i%RowLength == 0 then
			yPos = (i/RowLength)*label.AbsoluteSize.Y -- Setting a new column
		end
		label.MouseEnter:connect(function()
			label.BackgroundTransparency = 0
		end)
		label.MouseLeave:connect(function()
			label.BackgroundTransparency = 1
		end)
		label.ImageButton.MouseButton1Click:connect( function() MapClicked(label,c) end )
		label.TextButton.MouseButton1Click:connect( function() MapClicked(label,c) end )
		--wait()
	end
end

-- Connections
OpenButton.MouseButton1Click:connect(Open)
CloseButton.MouseButton1Click:connect(Close)
BackButton.MouseButton1Click:connect(Back)
Search.FocusLost:connect(SearchFocusLost)
Search.Focused:connect(SearchFocused)
ClearSearchButton.MouseEnter:connect(ClearSearchEnter)
ClearSearchButton.MouseLeave:connect(ClearSearchLeave)
ClearSearchButton.MouseButton1Click:connect(ClearSearchClick)
AddButton.MouseButton1Click:connect(AddToQueue)
StartButton.MouseButton1Click:connect(Start)
ListType.MouseButton1Click:connect(ChangeListType)
EndMapButton.MouseButton1Click:connect(EndMap)
ClearQueueButton.MouseButton1Click:connect(ClearQueue)
WorkspaceMaps.ChildRemoved:connect(QueueUpdate)