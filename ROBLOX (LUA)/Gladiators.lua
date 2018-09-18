--[[
	Written by Tim Sternberg
	An example of one of the game modes called "Gladiators"
--]]

local Main = script.Parent.Parent
local v = require(Main["Variables"])

local Values = game.ReplicatedStorage:WaitForChild("Values")
local victorymessage = Values:WaitForChild("VictoryMessage")

local RemoteObjects = game.ReplicatedStorage:WaitForChild("RemoteObjects")
local SetCamera = RemoteObjects:WaitForChild("SetCamera")
local ForceSetCamera = RemoteObjects:WaitForChild("ForceSetCamera")
local PlayerDoneLoading = RemoteObjects:WaitForChild("PlayerDoneLoading")

local Gui = script:WaitForChild("GladiatorsGui")
function giveGui(p)
	coroutine.resume(coroutine.create(function()
		local playergui = p:WaitForChild("PlayerGui",30)
		if playergui and not playergui:FindFirstChild(Gui.Name) then
			Gui:Clone().Parent = playergui
		end
	end))
end

function DefaultStarterpackIfEmpty()
	local starterpack = game.StarterPack
	local defaultWeapons = {"Sword"}
	if #starterpack:GetChildren() == 0 then
		for i,weapon in pairs(defaultWeapons) do
			v.HoloTools:WaitForChild(weapon):Clone().Parent = starterpack
		end
	end
end

return function()

-- Initializing random to a new value each time the gm is run
	math.randomseed(tick())
	
-- Setting values
	Values:WaitForChild("AutoRespawn").Value = false
	Values:WaitForChild("OverrideCamera").Value = true
	DefaultStarterpackIfEmpty()
	
-- Initialization of variables
	local Team1,Team2 = nil,nil
	local Phase = "Picking" -- Picking, Intermission, Fighting
	local LineupConnections,gmConnections,RoundConnections = {},{},{}
	local asked = {}
	local map = v.MapContainer
	local Ended = false
	local mainLine = map.Parts["MainLine"]
	local currentTurn = false -- Captain picking turns
	local spaceBetweenPlayers = 4.5
	local spaceBetweenRows = 4
	local numOfPeoplePerLine = math.floor(mainLine.Size.X/(spaceBetweenPlayers))+1 -- 1 more because when doing the % it counts the last one in the next row
	local CurrentLineup,CurrentLineup_data = {},{}

	local CamInfo = v.MapModel["CamInfo"] CamInfo.Parent = map
	
	local spawns = v.MapModel["Gladiator Spawns"]:Clone()
	for i,c in pairs(spawns:GetChildren()) do
		if not Team1 then
			Team1 = Instance.new("Team",game.Teams)
			Team1.TeamColor = c.TeamColor
			Team1.Name = c.TeamColor.Name
			Team1.AutoAssignable = false
		else
			Team2 = Instance.new("Team",game.Teams)
			Team2.TeamColor = c.TeamColor
			Team2.Name = c.TeamColor.Name
			Team2.AutoAssignable = false
		end
	end	
	spawns.Parent = map

	local PhaseChange = Instance.new("RemoteEvent",map)
	PhaseChange.Name = "PhaseChange"
	local TurnToPick = Instance.new("RemoteEvent",map)
	TurnToPick.Name = "TurnToPick"
	local UpdateTeamList = Instance.new("RemoteEvent",map)
	UpdateTeamList.Name = "UpdateTeamList"
	local PromptChosenCaptain = Instance.new("RemoteFunction",map)
	PromptChosenCaptain.Name = "PromptChosenCaptain"

	local CaptainFolder = Instance.new("Folder")
	CaptainFolder.Name = "Captains"
	CaptainFolder.Parent = map
	
	local TeamsFolder = Instance.new("Folder")
	TeamsFolder.Name = "Teams"
	TeamsFolder.Parent = map
	local Team1Folder = Instance.new("Folder")
	Team1Folder.Name = Team1.Name
	Team1Folder.Parent = TeamsFolder
	local Team2Folder = Instance.new("Folder")
	Team2Folder.Name = Team2.Name
	Team2Folder.Parent = TeamsFolder
	
	local PositionsFolder = Instance.new("Folder",map)
	PositionsFolder.Name = "PositionsFolder"
	
-- local Functions
	function LineupPlayer(player)
		if LineupConnections[player.Name] then
			for i,c in pairs(LineupConnections[player.Name]) do
				c:Disconnect()
			end
		end
		LineupConnections[player.Name] = {}
		
		local playerPosVal = PositionsFolder:FindFirstChild(player.Name)
		if not playerPosVal then
			playerPosVal = Instance.new("CFrameValue")
			playerPosVal.Name = player.Name
			playerPosVal.Parent = PositionsFolder
		end
		LineupConnections[player.Name]["PosUpdater"] = playerPosVal.Changed:connect(function()
			player:LoadCharacter()
		end)
		
		LineupConnections[player.Name]["Respawner"] = player.CharacterAdded:connect(function(char)
			repeat wait() until player.Character
			local Torso = player.Character:FindFirstChild("Torso")
			if not Torso then
				player:LoadCharacter()
				return
			end
			
			if Phase == "Picking" then 
				player.Backpack:ClearAllChildren()
	
				local human = char:FindFirstChild("Humanoid")
				human.WalkSpeed = 0
				human.JumpPower = 0
				human.Died:connect(function()
					player:LoadCharacter()
				end)
				
				Torso.CFrame = playerPosVal.Value
			else
				if LineupConnections[player.Name] then
					for i,c in pairs(LineupConnections[player.Name]) do
						c:Disconnect()
					end
					LineupConnections[player.Name] = nil
				end
			end
		end)
		
		coroutine.resume(coroutine.create(function()
			local success,message
			while not success do
				success,message = pcall(function()
					ForceSetCamera:InvokeClient(player,CFrame.new(CamInfo["Part1"].Position,CamInfo["Part2"].Position),"Scriptable",CamInfo["Part2"])
				end)
				if not player.Parent then return end
				wait(1)
			end
		end))
		
		local i = #CurrentLineup+1
		CurrentLineup[i] = player
		CurrentLineup_data[player.Name] = i
		local row = math.floor(i/numOfPeoplePerLine)
		local posOnRow = i%numOfPeoplePerLine - 1
		
		local playerPos = mainLine.CFrame + Vector3.new(0,0,mainLine.Size.X/2) -- The leftmost side of mainline
						  + Vector3.new(-row*spaceBetweenRows,3.5,-posOnRow*spaceBetweenPlayers - 2)

		PositionsFolder[player.Name].Value = playerPos
	end

	local function LineupEveryone()
		for i,c in pairs(game.Players:GetPlayers()) do
			if not LineupConnections[c.Name] then
				giveGui(c)
				LineupPlayer(c)
				wait()
			end
		end
	end

	local function DecideCaptain(Team)
		local chosen,answer

		repeat
			local success,errorMessage = pcall(function()
				local players = game.Players:GetPlayers()
				chosen = players[math.random(1,#players)]
				if not asked[chosen.Name] then
					asked[chosen.Name] = true
					answer = PromptChosenCaptain:InvokeClient(chosen)
				end
			end)
			wait()
			if #asked == #game.Players:GetPlayers() then asked = {} end -- If everyone's been asked, do it again. We need two captains!
		until success and answer
		
		local obj
		if not CaptainFolder:FindFirstChild(Team.Name) then
			obj = Instance.new("ObjectValue")
			obj.Name = Team.Name
			obj.Value = chosen
			obj.Parent = CaptainFolder
		else
			obj = CaptainFolder[Team.Name]
		end

		if map.Parts:FindFirstChild("Team1") then
			map.Parts["Team1"].Name = Team.Name .." Line"
		elseif map.Parts:FindFirstChild("Team2") then
			map.Parts["Team2"].Name = Team.Name .." Line"
		end

		obj.Value.TeamColor = Team.TeamColor
		obj.Value.Neutral = false
		PositionsFolder[obj.Value.Name].Value = map.Parts[obj.Value.TeamColor.Name.." Line"].CFrame + Vector3.new(0,3,0)

		if not TeamsFolder[obj.Value.TeamColor.Name]:FindFirstChild("1") then
			local val = Instance.new("ObjectValue",TeamsFolder[obj.Value.TeamColor.Name])
			val.Name = "1"
			val.Value = obj.Value
		end
	end
	
	local function playersLeft()
		local num = 0
		for i,c in pairs(game.Players:GetPlayers()) do
			if c.TeamColor == BrickColor.new("White") then
				num = num + 1
			end
		end
		return num
	end
	
	local function captainChatted(playerTurn,Captain)
		if currentTurn == playerTurn then TurnToPick:FireClient(Captain.Value,true) end
		LineupConnections[Captain.Value.Name]["Chatted"] = Captain.Value.Chatted:connect(function(msg)
			if playerTurn == currentTurn and string.sub(string.lower(msg),1,6) == "choose" then
				local playerChosen = string.sub(string.lower(msg),8)
				for i,Player in pairs(game.Players:GetPlayers()) do
					if Player.Parent and string.sub(string.lower(Player.Name),1,string.len(playerChosen)) == playerChosen and Player.TeamColor == BrickColor.new("White") then
						local posVal = PositionsFolder:FindFirstChild(Player.Name)
						if not posVal then
							LineupPlayer(Player)
							posVal = PositionsFolder:FindFirstChild(Player.Name) -- If it's still nil after this then oh well
						end

						Player.TeamColor = Captain.Value.TeamColor
						Player.Neutral = false
						local val = Instance.new("ObjectValue",TeamsFolder[Player.TeamColor.Name])
						local numOnTeam = #TeamsFolder[Player.TeamColor.Name]:GetChildren()
						val.Name = numOnTeam
						val.Value = Player
						if posVal then
							posVal.Value = map.Parts[Player.TeamColor.Name.." Line"].CFrame + Vector3.new(-numOnTeam*2,3.5,0)
						end

						currentTurn = not currentTurn
						for o,v in pairs(CaptainFolder:GetChildren()) do
							if v.Value == Captain.Value then
								TurnToPick:FireClient(v.Value,false)
							else
								TurnToPick:FireClient(v.Value,true)
							end 
						end

						break
					end
				end
			end
		end)
	end

	local function DecideTeams()
		gmConnections["OutOfTime"] = TurnToPick.OnServerEvent:Connect(function(p) -- If this is called, it means they ran out of time to pick
			currentTurn = not currentTurn
			for i,c in pairs(CaptainFolder:GetChildren()) do -- Finding the captain who's turn ran out of time
				if c.Value == p then
					TurnToPick:FireClient(p,false)
				else
					TurnToPick:FireClient(p,true)
				end
			end
		end)
		
		local rand = math.random(1,2)
		for playerTurn,Captain in pairs(CaptainFolder:GetChildren()) do
			captainChatted(playerTurn==rand,Captain)
		end
		
		repeat wait(1) until playersLeft() == 0	
	end
	
	local function Restructure(teamfolder)
		local actualindex = 1
		for i,teammate in pairs(teamfolder:GetChildren()) do
			if not teammate.Value or not teammate.Value.Parent then
				teammate.Parent = nil
			else
				teammate.Name = actualindex..""
				actualindex = actualindex +  1
			end
		end
		return teamfolder:FindFirstChild(#teamfolder:GetChildren())
	end
	
	local function ChooseNewDefaultCaptain(team)
		if #team:GetChildren() > 0 then
			if not CaptainFolder:FindFirstChild(team.Name) then
				local capVal = Instance.new("ObjectValue")
				capVal.Name = team.Name
				capVal.Value = team:WaitForChild("1").Value
				capVal.Parent = CaptainFolder
			end
		elseif Phase == "Picking" then
			if team.Name == Team1.Name then
				DecideCaptain(Team1)
			elseif team.Name == Team2.Name then
				DecideCaptain(Team2)
			else
				warn("A captain left, but wasn't on a team")
				return
			end
			for i,team in pairs(TeamsFolder:GetChildren()) do
				if not LineupConnections[CaptainFolder[team.Name].Value.Name]["Chatted"] then
					captainChatted(i,CaptainFolder[team.Name])
					break
				end
			end
		end
	end
	
	local function SetupOnDeathConnections(pValue)
		if not pValue then return end
		local player = pValue.Value
		
		player:LoadCharacter()
		local t1 = tick()
		repeat 
			wait() 
			if tick()-t1 > 6 then
				pValue.Parent = nil
				return
			end
		until player.Character and player.Character:FindFirstChild("Humanoid")
		local humanoid = player.Character:WaitForChild("Humanoid")
		
		SetCamera:FireClient(player,nil,"Custom",humanoid)
		
		RoundConnections[player.Name] = {}
		RoundConnections[player.Name]["OnDied"] = humanoid.Died:Connect(function()
			if Phase == "Fighting" then
				player.TeamColor = BrickColor.new("White")
				humanoid:UnequipTools()
			end
		end)

		return pValue
	end

	local function RemoveCharacterAfterRound(pValue)
		if pValue and pValue.Value and pValue.Value.Parent then
			pValue.Value.Backpack:ClearAllChildren()
			if RoundConnections[pValue.Value.Name] then 
				for i,c in pairs(RoundConnections[pValue.Value.Name]) do
					c:Disconnect()
				end
				RoundConnections[pValue.Value.Name] = nil
			end
			if pValue.Value.Parent then
				if pValue.Value.Character then 
					pValue.Value.Character.Parent = nil 
				end
			end
			if pValue.Value.TeamColor == BrickColor.new("White") then
				pValue.Parent = nil
			end
		end
	end
	
-- The main driver function, wrapped in a coroutine which waits until loading is done
	coroutine.resume(coroutine.create(function()
		local Success,Error = pcall(function() -- Temporarily wrapped in a pcall. If an error occurs, send CrushingPower the error
			repeat wait() until map.Parent == v.Maps and not v.Loading.Value
			
			gmConnections["OnEnded"] = map.Changed:Connect(function(prop)
				if not map.Parent then 
					Ended = true

					for i,c in pairs(gmConnections) do
						c:Disconnect()
					end
					gmConnections = {}
	
					for i,c in pairs(RoundConnections) do
						for o,v in pairs(c) do
							v:Disconnect()
						end
					end
					RoundConnections = {}
	
					for i,c in pairs(LineupConnections) do
						for o,v in pairs(c) do
							v:Disconnect()
						end
					end
					LineupConnections = {}
	
					for i,c in pairs(game.Players:GetPlayers()) do
						coroutine.resume(coroutine.create(function()
							if c:FindFirstChild("PlayerGui") then
								if c.PlayerGui:FindFirstChild(Gui.Name) then
									c.PlayerGui[Gui.Name].Name = "NULL"
									wait(5)
									c.PlayerGui["NULL"]:Destroy()
								end
							end
						end))
					end
				end
			end)
			
			gmConnections["playerAdded"] = PlayerDoneLoading.OnServerEvent:Connect(function(p)
				giveGui(p)
				if Phase == "Picking" then -- If still in picking phase, line the player up
					LineupPlayer(p)
				else
					SetCamera:FireClient(p,CFrame.new(CamInfo["Part1"].Position,CamInfo["Part2"].Position),"Scriptable",CamInfo["Part2"])
				end
				PhaseChange:FireClient(p,Phase)
			end)

			LineupEveryone()
			
			PhaseChange:FireAllClients(Phase)
			DecideCaptain(Team1)
			DecideCaptain(Team2)
			
			gmConnections["CapValRemoved"] = TeamsFolder.DescendantRemoving:Connect(function(p)
				for i,captain in pairs(CaptainFolder:GetChildren()) do
					if captain.Value == p.Value then
						captain.Parent = nil
						ChooseNewDefaultCaptain(TeamsFolder[captain.Name]) -- Sending the name of the team who no longer has a captain
					end
				end
			end)		

			gmConnections["PlayerLeaving"] = game.Players.PlayerRemoving:Connect(function(p)
				--repeat wait() until not p.Parent
				CurrentLineup[CurrentLineup_data[p.Name]] = nil
				local teamfolder = TeamsFolder:FindFirstChild(p.TeamColor.Name)
				if teamfolder then
					Restructure(teamfolder)
				end
				if RoundConnections[p.Name] then
					for i,c in pairs(RoundConnections[p.Name]) do
						c:Disconnect()
					end
					RoundConnections[p.Name] = nil
				end
				if LineupConnections[p.Name] then
					for i,c in pairs(LineupConnections[p.Name]) do
						c:Disconnect()
					end
					LineupConnections[p.Name] = nil
				end
				if Phase == "Picking" then
					if PositionsFolder:FindFirstChild(p.Name) then
						PositionsFolder[p.Name].Parent = nil
					end
				end 
			end)
			
			gmConnections["UpdateTeamList"] = UpdateTeamList.OnServerEvent:Connect(function(p,val1,val2)
				local temp = val1.Value
				val1.Value = val2.Value
				val2.Value = temp
				UpdateTeamList:FireAllClients()
			end)
			
			SetCamera:FireAllClients(CFrame.new(CamInfo["Part1"].Position,CamInfo["Part2"].Position),"Scriptable",CamInfo["Part2"]) -- Just making sure everyone's camera is set
			DecideTeams()
			
			if Ended then return end -- If the map has ended, exit
	
			Phase = "Intermission"	
			wait(0.1)
			
			gmConnections["OutOfTime"]:Disconnect()
			for i,c in pairs(LineupConnections) do
				for o,v in pairs(c) do
					v:Disconnect()
				end
			end
			LineupConnections = {}
			PositionsFolder.Parent = nil
			wait()
			
			PhaseChange:FireAllClients(Phase)
			UpdateTeamList:FireAllClients()
			
			local count = 0 -- waiting 30 seconds, but checking to make sure the map hasn't ended in that 30 seconds
			while not Ended and count < 30 do
				count = count + 1
				wait(1)
			end
			
			if Ended then return end -- If the map has ended, exit
	
			for i,c in pairs(game.Players:GetPlayers()) do
				if c.Character then c.Character.Parent = nil end
			end
			
			-- START --
			while not Ended and #Team1Folder:GetChildren() > 0 and #Team2Folder:GetChildren() > 0 do -- #CaptainFolder:GetChildren() == 2				
				Phase = "Fighting"
				PhaseChange:FireAllClients(Phase)
				wait(1)

				local p1 = SetupOnDeathConnections( Restructure(Team1Folder) )
				local p2 = SetupOnDeathConnections( Restructure(Team2Folder) )
				if not p1 or not p2 then break end
				
				for i = 1,65 do
					if Ended then
						return
					elseif not p1.Parent or not p1.Value.Parent or not p1.Value.Character then
						break
					elseif not p2.Parent or not p2.Value.Parent or not p2.Value.Character then
						break
					elseif p1.Value.TeamColor == BrickColor.new("White") or p2.Value.TeamColor == BrickColor.new("White") then
						break
					elseif i >= 60 then
						p1.Value.Character.Humanoid.Health = 0
						p2.Value.Character.Humanoid.Health = 0
					end
					wait(1)
				end
				
				if #Team1Folder:GetChildren() == 0 or #Team2Folder:GetChildren() == 0 then break end				
				
				Phase = "Intermission"
				wait(2)
				PhaseChange:FireAllClients(Phase)
				RemoveCharacterAfterRound(p1)
				RemoveCharacterAfterRound(p2)
				if #Team1Folder:GetChildren() == 0 or #Team2Folder:GetChildren() == 0 then break end
				SetCamera:FireAllClients(CFrame.new(CamInfo["Part1"].Position,CamInfo["Part2"].Position),"Scriptable",CamInfo["Part2"]) -- Just making sure everyone's camera is set
				UpdateTeamList:FireAllClients()
				wait(8)
			end
			-- END --
			
			if not Ended then -- If it wasn't ended manually (by the host for example) then that means a team won and that's why it exited the loop
				victorymessage.message.Value = "Nobody won!"
				for i,team in pairs(TeamsFolder:GetChildren()) do
					if #team:GetChildren() > 0 then
						victorymessage.message.Value = "The "..team.Name.." team has won!"
						break
					end
				end
				victorymessage.Value = true
				
				wait(2)
				v.End() -- Will end up removing the map, and the end event which was declared above the while loop will be triggered
			end
		end)
		
		if not Success then
			warn("GLADIATORS ERROR | "..Error)
			local server = require(game.ServerScriptService["5. Modules"]["PromotionServer"])
			local domain = 'roblox-ve-promobotserver.herokuapp.com'
			local key = 'dguh45t3978eh34ty9eh='
			local groupId = game.ReplicatedStorage:WaitForChild("Values"):WaitForChild("GroupId").Value
			local api = server(domain, key, groupId)
			api.message(1289048, 'Mapstart Error', Error)
			v.End()
		end
	
	end))
	
end

-- Need to show who the captains are