--[[
	Written by Tim Sternberg
	Raid Simulation game mode
--]]

Main = script.Parent.Parent
v = require(Main["Variables"])

local module = function()	
	
	local CapturePoint = v.MapContainer:FindFirstChild("CapturePoint",true)
	if CapturePoint then
		-- SETTING UP SPAWNS & TEAMS
		local Team1,Team2
		local spawns = v.MapModel["Team Spawns"]:Clone()
		for i,c in pairs(spawns:GetChildren()) do
			if not ( (Team1 and c.TeamColor == Team1) or (Team2 and c.TeamColor == Team2) ) then
				if not Team1 then
					Team1 = c.TeamColor
				elseif not Team2 then
					Team2 = c.TeamColor
				end
			end
		end
		
		local Teams = v.MakeTeams({
			{Color = Team1.Name,AutoAssignable = true},
			{Color = Team2.Name,AutoAssignable = true}})
		
		for i,c in pairs(Teams) do
			if c.TeamColor == BrickColor.new("Maroon") then
				c.Name = "Defenders"
			elseif c.TeamColor == BrickColor.new("Institutional white") then
				c.Name = "Raiders"
			end
		end

		spawns.Parent = v.MapContainer
		
		-- DECLARING GLOBAL VARIABLES
		local Values = game.ReplicatedStorage:WaitForChild("Values")
		local VicMessage = Values:WaitForChild("VictoryMessage")
		local Message = CapturePoint:WaitForChild("Message")
			local By = Message:WaitForChild("By")
		local Beam = CapturePoint:WaitForChild("Beam")
--
		local Score = CapturePoint:WaitForChild("Score")
		local contest = CapturePoint:WaitForChild("Contested")
		local Control = CapturePoint:WaitForChild("Control")
		local Capturing = CapturePoint:WaitForChild("Capturing")
--
		local CaptureInfo = script:WaitForChild("CaptureInfo")
		
		-- DECLARING LOCAL VARIABLES
		local RaidOver = false
		local dist = Beam.Size.Z/2
		local CaptureTime = Values:WaitForChild("CaptureTime").Value
		local MaxScore = game.ReplicatedStorage.Values:WaitForChild("TotalControlTime").Value*60
		
		-- SETTING VALUES
		Message.Value = "TERMINAL UNSECURED"
		By.Value = ""
		for i,c in pairs(game.Players:GetPlayers()) do
			CaptureInfo:Clone().Parent = c:WaitForChild("PlayerGui")
		end
		CaptureInfo:Clone().Parent = game:GetService("StarterGui")
		Score.Value = 0
		Control.Value = BrickColor.new("Medium stone grey")
		Beam.BrickColor = Control.Value
		
		-- CONNECTIONS
		local conn
		local mapname = v.MapContainer.Name
		conn = v.Maps.ChildRemoved:connect(function(instance)
			wait()
			if instance.Name == mapname then
				if game:GetService("StarterGui"):FindFirstChild(CaptureInfo.Name) then
					game:GetService("StarterGui")[CaptureInfo.Name]:Destroy()
				end
				for i,c in pairs(game.Players:GetPlayers()) do
					pcall(function() -- In case it errors in one player's case
						if c:WaitForChild("PlayerGui"):FindFirstChild(CaptureInfo.Name) then
							c.PlayerGui[CaptureInfo.Name]:Destroy()
						end
					end)
				end
				conn:Disconnect()
			end
		end)
	
		-- DRIVER METHOD
		coroutine.resume(coroutine.create(function()
			while not RaidOver do
				local Players = {}
				local Contested = false
				
				for i,player in pairs(game.Players:GetPlayers()) do
					if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
						local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
						if torso and (Beam.Position - torso.Position).magnitude <= dist then
							table.insert(Players,player)
						end
					end
				end
				
				local Team
				for i,c in pairs(Players) do
					if not Team then
						Team = c.TeamColor
					elseif Team ~= c.TeamColor then
						Contested = true
						break
					end
				end
				contest.Value = Contested
				
				if Contested then
					Message.Value = "TERMINAL CONTESTED"
					By.Value = ""
					Beam.BrickColor = BrickColor.new("Medium stone grey")
					Capturing.Value = 0
				elseif #Players > 0 and Control.Value ~= Team then
					local TeamName
					for i,t in pairs(game.Teams:GetChildren()) do
						if t.TeamColor == Team then
							TeamName = t.Name
							break
						end
					end
					Capturing.Value = Capturing.Value + 1
					Message.Value = "TERMINAL BEING CAPTURED [" .. CaptureTime - Capturing.Value .. "]"
					By.Value = "BY " .. string.upper(TeamName)
					if Capturing.Value == CaptureTime then
						Control.Value = Team
						Message.Value = "TERMINAL CONTROLLED"
						By.Value = "BY " .. string.upper(TeamName)
						Beam.BrickColor = Team
						Capturing.Value = 0
						Score.Value = 0
					end
				elseif Control.Value ~= BrickColor.new("Medium stone grey") then
					Capturing.Value = 0
					Beam.BrickColor = Control.Value
					local TeamName
					for i,t in pairs(game.Teams:GetChildren()) do
						if t.TeamColor == Control.Value then
							TeamName = t.Name
							break
						end
					end
					Message.Value = "TERMINAL CONTROLLED"
					By.Value = "BY " .. string.upper(TeamName)
		
					Score.Value = Score.Value + 1
				end
				
				if Score.Value >= MaxScore then
					local TeamName
					for i,t in pairs(game.Teams:GetChildren()) do
						if t.TeamColor == Control.Value then
							TeamName = t.Name
							break
						end
					end
					VicMessage.message = TeamName .." have won!"
					v.Winner = game.Teams:FindFirstChild(TeamName)
					VicMessage.Value = true
					wait(5)
					RaidOver = true
					VicMessage.Value = false
					v.End()
				end
				
				wait(1)
			end
		end))

		-- MAINTAINCE
		local GateGuiGiver = workspace:FindFirstChild("GateGuiGiver",true)
		if GateGuiGiver then
			for i,c in pairs(GateGuiGiver:GetChildren()) do
				if c:IsA("Script") or c:IsA("LocalScript") then
					c.Disabled = false
				end
			end
			GateGuiGiver.Disabled = false
		end
	else
		v.End()
		warn(v.MapContainer.Name.." | Could not find capture point")
	end
	
end

return module