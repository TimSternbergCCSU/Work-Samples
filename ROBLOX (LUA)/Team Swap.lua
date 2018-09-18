--[[
	Written by Tim Sternberg
	Team Swap game mode
--]]

Main = script.Parent.Parent
v = require(Main["Variables"])

local module = function()
	
	local Values = game.ReplicatedStorage:WaitForChild("Values")
	local victorymessage = Values:WaitForChild("VictoryMessage")
	local Scores = Values:WaitForChild("TeamScores")
	local Outscore = Values:FindFirstChild("Outscore")
	local endkill = Values:WaitForChild("End at amount of kills")

	local RawTeams,declaredTeams = {},{}
	local TeamWon = nil

	local spawns = v.MapModel["Team Spawns"]:Clone()
	spawns.Parent = v.MapContainer
	for i,c in pairs(spawns:GetChildren()) do
		if not declaredTeams[c.TeamColor.Name] then
			declaredTeams[c.TeamColor.Name] = true
			table.insert(RawTeams,{Color = c.TeamColor.Name,AutoAssignable = not Outscore.Value})
		end
	end
	
	local Teams = v.MakeTeams(RawTeams)
	for _,team in pairs(Teams) do
		local val = Instance.new("NumberValue")
		val.Name = team.TeamColor.Name
		val.Parent = Scores
	end
	
	local timeout = tick()
	coroutine.resume(coroutine.create(function()
		repeat wait() until ((not v.Loading.Value) and (not v.MakingTeams)) or tick()-timeout > 30
		while v.MapContainer.Parent and not TeamWon do
			local teams = {}
			for _,team in pairs(Teams) do
				teams[team.TeamColor.Name] = 0
			end

			-- Calculating people on each team
			for _,player in pairs(game.Players:GetPlayers()) do
				if player.TeamColor ~= BrickColor.new("White") then
					teams[player.TeamColor.Name] = teams[player.TeamColor.Name] + 1
				end
			end
			
			-- Populating the seeable scores in values, then checking if we should end
			local TeamsStillIn = {}
			for team,count in pairs(teams) do
				if Scores:FindFirstChild(team) then
					Scores[team].Value = count
					
					-- If kills > 0 then that team is still in the game
					if count > 0 then
						table.insert(TeamsStillIn,team)
					end
				end
			end
			if #TeamsStillIn == 1 then
				TeamWon = TeamsStillIn[1]
			elseif #TeamsStillIn == 0 then
				TeamWon = "NIL"
			end
			wait(1)
		end

		if TeamWon and v.MapContainer.Parent then
			victorymessage.message.Value = "The " .. TeamWon .. " Team has won!"
			v.Winner = game.Teams:FindFirstChild(TeamWon)
			victorymessage.Value = true
			wait(5)
			victorymessage.Value = false
			v.End()
		end
	end))

end

return module
