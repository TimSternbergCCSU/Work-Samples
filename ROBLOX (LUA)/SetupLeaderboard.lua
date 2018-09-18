--[[
	Written by Tim Sternberg
	sets up the leaderboard for a player
--]]

local DSS = game:GetService("DataStoreService")
local SStorage = game:GetService("ServerStorage")
local RStorage = game:GetService("ReplicatedStorage")

local oldstore = DSS:GetDataStore("StratumData")
local StratumDataStoreBackup = DSS:GetDataStore("StratumDataStore")
local StratumCache = DSS:GetDataStore("StratumCache")
local UploadError = DSS:GetDataStore("UploadError")

local Values = RStorage["Values"]
local GroupId = Values["GroupId"].Value

local StratumFolder = Instance.new("Folder")
StratumFolder.Name = "PlayerStratum"
StratumFolder.Parent = SStorage

local SecurityKey = SStorage:FindFirstChild("Security"):FindFirstChild("Security Key").Value

local Scripts = RStorage["Scripts"]
local StratumInfo = require(Scripts["StratumInfo"])
local CalculateLevel = require(Scripts["CalculateLevel"])

local Database = require(game.ServerScriptService["Modules"]["ClanlabsAPI"])

return function(newPlayer)
	local numrank = newPlayer:GetRankInGroup(GroupId)
	local playerKey = "user_" .. newPlayer.UserId .. "stratum" .. SecurityKey

	local f = Instance.new("Folder")
	f.Name = "P_Values"
	local Dueling = Instance.new("BoolValue")
	Dueling.Name = "Dueling"
	Dueling.Parent = f
	f.Parent = newPlayer

	local stats = Instance.new("IntValue")
	stats.Name = "leaderstats"
	local kills = Instance.new("IntValue")
	kills.Name = "Kills"
	kills.Value = 0
	local deaths = Instance.new("IntValue")
	deaths.Name = "Deaths"
	deaths.Value = 0
	
	local systemDown

	if StratumFolder:FindFirstChild(newPlayer.Name) then StratumFolder:FindFirstChild(newPlayer.Name):Destroy() end
	local Points = Instance.new("NumberValue")
	Points.Name = newPlayer.Name
	local stratum,backupstratum,databaseStratum
	
	--if game.JobId ~= "" then
		local success,message = pcall(function()
			coroutine.resume(coroutine.create(function()
				-- Use a seperate variable, that way if it does end up working 10 seconds later, it doesn't mess with anything
				databaseStratum = Database:GetProfile(newPlayer.UserId)["experience"] -- StratumDataStore:GetAsync(playerKey) or 0
			end))
			for i = 1,5 do
				if not databaseStratum then
					wait(1)
				else
					break
				end
			end
			if not databaseStratum then error("Couldn't retrieve player "..newPlayer.Name.."'s data from Database") end
		end)
	--end
	backupstratum = StratumDataStoreBackup:GetAsync(playerKey)
	
	if not success then
		systemDown = true
		stratum = StratumDataStoreBackup:GetAsync(playerKey)
	else
		stratum = databaseStratum
		if UploadError:GetAsync(playerKey) == 1 and not systemDown then
			systemDown = true
			warn(newPlayer.Name.." had an error in a previous server with uploading to Databse")
			local newStratum = StratumDataStoreBackup:GetAsync(playerKey)
			local success,m = pcall(function() Database:ChangeExperience(newPlayer.UserId,stratum-newStratum) end)
			if success then
				systemDown = false
				stratum = newStratum
				wait()
				UploadError:SetAsync(playerKey,0)
			end
		end
		
		local cached = StratumCache:GetAsync(playerKey) or 0
		if not systemDown then
			if cached > 0 then -- update databse and clear cache
				warn("Updating database with "..newPlayer.Name.."'s cache data, then clearing")
				Database:ChangeExperience(newPlayer.UserId,cached)
				StratumDataStoreBackup:SetAsync(playerKey,Database:GetProfile(newPlayer.UserId)["experience"])
				StratumCache:SetAsync(playerKey,0)
			else -- all good, do as normal
				print("Syncing backup with "..newPlayer.Name.."'s data from the Database")
				StratumDataStoreBackup:SetAsync(playerKey,stratum)
			end
		else
			warn("Database down, could not update player info")
		end
	end
	
	Points.Value = stratum
	
	local ToCache = Instance.new("IntValue") -- This is the amount of points that haven't been saved to cache
	ToCache.Name = "ToCache"
	
	local FakePoints = Instance.new("IntValue")
	FakePoints.Name = "Stratum"
	FakePoints.Value = Points.Value
	
	local rank = Instance.new("StringValue")
	rank.Name = "Rank"
	rank.Value = string.sub(newPlayer:GetRoleInGroup(GroupId),1,3)
	
	local RealRank = Instance.new("IntValue")
	RealRank.Name = "RealRank"
	RealRank.Value = newPlayer:GetRankInGroup(GroupId)
	
	RealRank.Parent = rank
	rank.Parent = stats
	kills.Parent = stats
	deaths.Parent = stats
	FakePoints.Parent = stats
	ToCache.Parent = Points
	
	local oldPoints = Points.Value
	Points.Changed:connect(function()
		ToCache.Value = ToCache.Value + (Points.Value - oldPoints)
		oldPoints = Points.Value
		if Points.Parent then 
			FakePoints.Value = Points.Value 
		end 
	end)
	
	stats.Parent = newPlayer
	Points.Parent = StratumFolder
end

------ TEMPORARY ------
--		if stratum == 0 or backupstratum == 0 then -- Let's see if they've got stratum in the old datastore
--			warn("Initial Syncing "..newPlayer.Name.."'s data with Database")
--			local oldStratum = oldstore:GetAsync(playerKey) or 0
--			if oldStratum ~= stratum then
--				stratum = oldStratum/10 -- converting it
--				backupstratum = stratum
--				StratumDataStoreBackup:SetAsync(playerKey,stratum)
--				local success,m = pcall(function() Database:ChangeExperience(newPlayer.UserId,stratum) end)
--				if not success then warn(m) UploadError(playerKey,1) end
--			end
-----------------------
