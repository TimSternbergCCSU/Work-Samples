--[[
	Written by Tim Sternberg
	King of the Hill game mode
--]]

Main = script.Parent.Parent
v = require(Main["Variables"])

local module = function()	
	
	local CapturePoint = v.MapContainer:FindFirstChild("CapturePoint",true)
	if CapturePoint then
		local Team1,Team2
		--local Ended
	
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

		spawns.Parent = v.MapContainer
		
		local Beam = CapturePoint:WaitForChild("Beam")
		
		local Values = game.ReplicatedStorage:WaitForChild("Values")
		local MaxTime = 60 --Values:WaitForChild("CaptureTime").Value*60
		local VicMessage = Values:WaitForChild("VictoryMessage")
		local Timer = Values:WaitForChild("Timer")
		
		Timer.TeamColor.Value = BrickColor.new("White")
		Timer.Value = MaxTime
		
		local function Ended()
			if #v.Maps:GetChildren() == 0 then
				return true
			elseif Timer.Value == 0 then
				local winningTeam
				for i,c in pairs(game:GetService("Teams"):GetChildren()) do
					if c.TeamColor == Timer.TeamColor.Value then
						winningTeam = c
						break
					end
				end
				VicMessage.message.Value = "The " .. winningTeam.Name .. " Team has won!"
				v.Winner = winningTeam
				VicMessage.Value = true
				wait(5)
				VicMessage.Value = false
				v.End()
			end
		end		

		coroutine.resume(coroutine.create(function()
			local t = tick() repeat wait() until #v.Maps:GetChildren() > 0 or tick()-t > 10
			while not Ended() do
				local TeamCapturing
				local count = 0
				for i,c in pairs(game.Players:GetPlayers()) do
					if c.Character and c.Character:FindFirstChild("Torso") then
						if (c.Character.Torso.Position-CapturePoint.Position).magnitude <= CapturePoint.Size.Z/2 then
							if TeamCapturing ~= c.TeamColor then
								TeamCapturing = c.TeamColor
								count = count + 1
							end
						end
					end
					wait()
				end 
				if count == 1 then
					if Timer.TeamColor.Value ~= TeamCapturing then
						Timer.Value = MaxTime
					end
					Timer.TeamColor.Value = TeamCapturing
					Beam.BrickColor = TeamCapturing
					Timer.Value = Timer.Value - 1
				elseif count == 2 then
					Beam.BrickColor = BrickColor.new("White")
				else
					Timer.TeamColor.Value = BrickColor.new("White")
					Timer.Value = MaxTime
					Beam.BrickColor = BrickColor.new("White")
				end

				wait(1)
			end
		end))

	else
		v.End()
		warn("Could not find capture point")
	end
	
end

return module