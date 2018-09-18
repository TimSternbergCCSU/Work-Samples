--[[
	Written by Tim Sternberg
	a handler for recording hosting data
--]]

-- Initialization
math.randomseed(tick())

-- Settings
local RequiredForOfficial = 5

-- OnPlayerEnter
game:GetService("Players").PlayerAdded:Connect(function(player) -- Added here to ensure it's triggered, and isn't delayed by getting other values
	repeat wait(0.5) until playerAdded
	playerAdded(player)
end) 

-- Services
local hs = game:GetService("HttpService")
local dss = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RepStorage = game:GetService("ReplicatedStorage")
local SerStorage = game:GetService("ServerStorage")
local GDS = dss:GetGlobalDataStore()

-- DataStores
local hoursStore = dss:GetOrderedDataStore("HostingData")
local eventsStore = dss:GetOrderedDataStore("EventsData")
local HighRanks = GDS:GetAsync("HighRanks")
local timeOfLastQuotaCheck = GDS:GetAsync("QuotaCheckTime")
local Errors = GDS:GetAsync("ErrorMessages")

-- Objects
local rems = game.ReplicatedStorage:WaitForChild("RemoteObjects")
local rep_vals = game.ReplicatedStorage:WaitForChild("Values")
local ser_vals = SerStorage:WaitForChild("Values")
local getQuotaData = rems:WaitForChild("GetQuotaData")
local getRecentEvents = rems:WaitForChild("GetRecentEvents")
local Host = rep_vals:WaitForChild("Host")
local groupId_obj = rep_vals:WaitForChild("GroupId")
local HRNum_obj = rep_vals:WaitForChild("HRNum")
local EventMode = ser_vals["EventMode"]

-- Variables
local Initializing,cachingData = true,true
local groupId = groupId_obj.Value
local HRNum = HRNum_obj.Value
local cachedData = {}
local CurrentlyRecording
local HostingValues,compressedHostingValues = {},{}
	HostingValues.Training = {1} -- index 1 is the points, index 2 is the type in int form
	HostingValues.JointTraining = {1.5}
	HostingValues.Rally = {1.5}
	HostingValues.Spar = {1}
	HostingValues.AcademyPhase = {1}

-- Google spreadsheet info
local hsEntry1 = "550493508"  -- host
local hsEntry2 = "844595960"  -- length
local hsEntry3 = "1726636955" -- to official
local hsEntry4 = "110234801"  -- highest attendance
local hsEntry5 = "649643760"  -- cum attendance
local hsEntry6 = "1529729490" -- attendees
local hsKey    = "1p9ZE_d2oPVw40JfNSplVnSTdU3_tRV7r1l20zsWIld0"
local hsForm   = "1cNEbXBuvxgz369ZSi0sWvNGb-uzF3GQZQmTZa73uagE"
local hsHost   = "https://docs.google.com/"
local function logSheet(hostName, tLength, timeToOfficial, peakPlayers, cumPlayers, attendees)
    local hsLink   = hsHost.."forms/d/"..hsForm.."/formResponse?entry."
                     ..hsEntry1.."="..hostName.."&submit=Submit&formkey="
                     ..hsKey.."&entry."..hsEntry2.."="..tLength.."&ifq"
					 ..hsKey.."&entry."..hsEntry3.."="..timeToOfficial.."&ifq"
					 ..hsKey.."&entry."..hsEntry4.."="..peakPlayers.."&ifq"
					 ..hsKey.."&entry."..hsEntry5.."="..cumPlayers.."&ifq"
					 ..hsKey.."&entry."..hsEntry6.."="..attendees.."&ifq"
    hs:PostAsync(hsLink, "", 2)
end

-- Module Functions
local Time = require(script["Time"])

-- Getter Functions
local function ConvertTime(timeHosted)
	local hours = ("%.2i"):format(timeHosted/60/60)
	local minutes = ("%.2i"):format((timeHosted/60)%60)
	local seconds = ("%.2i"):format(timeHosted%60)
	return hours..":"..minutes..":"..seconds
end

local function saveUserInfo(userid,EventType)
	for i,c in pairs(HighRanks) do
		if c.UserId and c.UserId == userid then
			if HostingValues[ compressedHostingValues[EventType] ] then
				c.Points = c.Points + HostingValues[ compressedHostingValues[EventType] ][1]
			else
				c.Points = c.Points + 1
			end
			return
		end
	end
end

local function recordEvent(HostName,EventType,EventLength,TimeToBecomeOfficial,PeakNumberOfPlayers,CumNumberOfPlayers)
	local value = HostName..","..
								EventType..","..
								EventLength..","..
								TimeToBecomeOfficial..","..
								PeakNumberOfPlayers..","..
								CumNumberOfPlayers
	eventsStore:SetAsync(value, tonumber(("%.i"):format(tick())) )
end

local function saveHighRankData()
		-- Making the changes local
		local hrs = {}
		for i,c in pairs(HighRanks) do hrs[i] = HighRanks[i] end
		-- Encode the HR table
		hrs = hs:JSONEncode(hrs)
		-- Save it
		GDS:SetAsync("HighRanks",hrs)
		-- Allow other scripts to finish
		warn("Saved HR Data")
end

local function GetRank(userid)
	local function getRankByProxy()
		return hs:GetAsync('https://assetgame.rprxy.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&groupid='..groupId..'&playerid='..userid):match'>(%d+)<'
	end
	
	local success,rank = pcall(getRankByProxy)
	if success then
		return tonumber(rank)
	else
		return nil
	end
end

local function needQuotaCheck(currentT)
	return false
	-- return currentT - timeOfLastQuotaCheck > 7*24*60*60 
end

local function QuotaCheck()
	warn("Performing quota check |",tick())
	for i,info in pairs(HighRanks) do
		info.Strikes = 0
--		if info.Points < 2 then
--			info.Strikes = info.Strikes + 1
--		elseif info.Strikes > 0 then
--			info.Strikes = info.Strikes - 1
--		end
		info.Points = 0
	end
	GDS:SetAsync("QuotaCheckTime",tick())
end


-- Main Functions and Events
if game.JobId ~= "" then
	game:BindToClose(function()
		wait(1)
		saveHighRankData()
		repeat wait() until not _G.SavingData	
		wait(1)
	end)
end

function playerAdded(player)
	if player:GetRankInGroup(groupId) >= HRNum then
		if Initializing then repeat wait(1) until not Initializing end
		
		for i,c in pairs(HighRanks) do
			if c.UserId == player.UserId then
				return
			end
		end

		-- We've not recorded this HR yet. Need to do so.
		local info = {}
		info.UserId = player.UserId
		info.Points = 0
		info.Strikes = 0

		cachedData[info] = {}
		cachedData[info].Username = hs:JSONDecode(hs:GetAsync("https://rprxy.xyz/proxy/api/usernames/"..info.UserId))[1]
		cachedData[info].Rank = hs:GetAsync('https://assetgame.rprxy.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&groupid='..groupId..'&playerid='..info.UserId)

		table.insert(HighRanks,info)
	end
end

Host.Changed:connect(function()
	local hostplayer = game.Players:FindFirstChild(Host.Value)
	if hostplayer and hostplayer.Name ~= CurrentlyRecording then -- start recording
		CurrentlyRecording = hostplayer.Name
		local Start = tick()
		local TimeToBecomeOfficial,TimeToBecomeOfficial_String = Start
		local userid = game.Players[hostplayer.Name].UserId
		local OfficialTraining = false
		local PeakNumberOfPlayers = #Players:GetPlayers()
		local CumNumberOfPlayers = 0
		local attendeesTable = {}
		local attendees = ""
		local EventType = HostingValues[EventMode.Value]
		if EventType then EventType = EventType[2] else EventType = 0 end
		local conn = {}
		
		local function checkAttendees()
			if not OfficialTraining and #Players:GetPlayers() > RequiredForOfficial then
				OfficialTraining = true
				TimeToBecomeOfficial = tick() - TimeToBecomeOfficial
			end

			if #Players:GetPlayers() > PeakNumberOfPlayers then 
				PeakNumberOfPlayers = #Players:GetPlayers() 
			end

			for i,c in pairs(game.Players:GetPlayers()) do
				if not attendeesTable[c.Name] then
					attendeesTable[c.Name] = true
					attendees = attendees .. c.Name .. " "
					CumNumberOfPlayers = CumNumberOfPlayers + 1
				end
				wait()
			end
		end
		
		table.insert(conn,Host.Changed:Connect(function()
			if Host.Value ~= hostplayer.Name then
				_G.SavingData = true
				
				for i,c in pairs(conn) do c:Disconnect() end

				GDS:SetAsync("Training",false)
				
				CurrentlyRecording = nil
				if not OfficialTraining then 
					TimeToBecomeOfficial_String = "N/A" 
				elseif TimeToBecomeOfficial < 1 then
					TimeToBecomeOfficial_String = "1 Second"
				else
					TimeToBecomeOfficial_String = TimeToBecomeOfficial/60 .. " Minutes"
				end
				
				local timeHosted = ConvertTime(tick()-Start)
				
				if tick()-Start >= 10*60 then -- If it's more than 10 minutes they had host, log it
					warn("Logging Training Data...")	
					
					local s,m = pcall( function() 
						logSheet(hostplayer.Name,ConvertTime(tick()-Start),TimeToBecomeOfficial_String,PeakNumberOfPlayers,CumNumberOfPlayers,attendees)		
					end) 
					if not s then warn(m) table.insert(Errors,m) end		

					local s,m = pcall( function() 
						saveUserInfo(userid,EventType)
						saveHighRankData()
					end) 
					if not s then warn(m) table.insert(Errors,m) end
					
					local s,m = pcall( function() 
						recordEvent(hostplayer.Name,
												EventType,
												("%.i"):format(tick()-Start),
												TimeToBecomeOfficial,
												PeakNumberOfPlayers,
												CumNumberOfPlayers)
					end ) if not s then warn(m) table.insert(Errors,m) end			
					
					local s,m = pcall( function() 
						hoursStore:IncrementAsync(userid,("%.i"):format(tick()-Start))  
					end ) 
					if not s then warn(m) table.insert(Errors,m) end
					
					_G.SavingData = false
					warn("Training Data Logged")	
				end
			end
		end))
		table.insert(conn,game.Players.PlayerAdded:Connect(checkAttendees))
		table.insert(conn,game.Players.PlayerRemoving:Connect(checkAttendees))
		
		GDS:SetAsync("Training",true)
	end
end)

function getQuotaData.OnServerInvoke(player,PlayerUserId)
	repeat wait(1) until not Initializing and not cachingData
	if PlayerUserId then
		--
	else
		local data = {}
		for i,c in pairs(HighRanks) do
			table.insert(data,c)
			data[i].Username = cachedData[c].Username
			data[i].Rank = cachedData[c].Rank
		end
		return data
	end
end

function getRecentEvents.OnServerInvoke(player,amt)
	local events = eventsStore:GetSortedAsync(false, amt):GetCurrentPage()
	local t = {}
	for i,data in ipairs(events) do
		t[i] = {}
		t[i].Time = data.value
		
		local s = ""
		local temp = {}
		for i = 1,string.len(data.key) do
			if string.sub(data.key,i,i) == "," or i == string.len(data.key) then
				table.insert(temp,s)
				s = ""
			else
				s = s .. string.sub(data.key,i,i)
			end
		end
		
		t[i].HostName = temp[1]
		t[i].EventType = compressedHostingValues[temp[2]]
		t[i].EventLength = tonumber(temp[3])
		t[i].TimeToBecomeOfficial = temp[4]--tonumber(temp[4])
		t[i].PeakNumberOfPlayers = tonumber(temp[5])
		t[i].CumNumberOfPlayers = temp[6]
	end
	
	return t
end

function main()
	if not HighRanks then -- Might need to initialize the table, if it's first time
		HighRanks = {} 
	else -- Decoding HR table.
		HighRanks = hs:JSONDecode(HighRanks)
--		for i,c in pairs(HighRanks) do
--			HighRanks[i] = hs:JSONDecode(c)
--		end
	end

	if not Errors then
		GDS:SetAsync("ErrorMessages",hs:JSONEncode({}))
		Errors = {}
	else
		Errors = hs:JSONDecode(Errors)
	end
	
	local i = 1
	if game.JobId ~= "" then
		while HighRanks[i] do -- Removing people not an HR anymore
			local rank = GetRank(HighRanks[i].UserId)
			if rank and rank < HRNum then
				table.remove(HighRanks,i)
				i = 1
			else
				i = i + 1
			end
		end
	end

	coroutine.resume(coroutine.create(function()
		for i,c in pairs(HighRanks) do
			cachedData[c] = {}
			cachedData[c].Username = hs:JSONDecode(hs:GetAsync("https://rprxy.xyz/proxy/api/usernames/"..c.UserId))[1]
			cachedData[c].Rank = hs:GetAsync('https://assetgame.rprxy.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&groupid='..groupId..'&playerid='..c.UserId)
		end
		cachingData = false
		warn("Finished loading HR Username and Ranks")
	end))

	if needQuotaCheck(tick()) then 
		QuotaCheck() 
	end

	for i,c in pairs(HostingValues) do
		local o = #compressedHostingValues+1
		c[2] = o
		compressedHostingValues[o] = i
	end

	coroutine.resume(coroutine.create(function()
		while wait(60*5) do pcall(saveHighRankData) end
	end))

	warn(script.Name," Loaded | ",tick())	
	Initializing = false
end main()

--print("Done")

--warn("ERRORS:\n")
--for i,c in pairs(Errors) do
--	warn(c)
--	warn()
--end

--local events = eventsStore:GetSortedAsync(false, 20):GetCurrentPage()
--for i,data in ipairs(events) do
--	print(data.key," | ",data.value)
--end

--recordEvent("Test",0,("%.i"):format(tick()),10,10,10,10)

--for i,c in pairs(HighRanks) do
--	local userdata = hs:JSONDecode(hs:GetAsync("https://rprxy.xyz/proxy/api/usernames/"..c.UserId))
--	warn(userdata[1])
--	for o,v in pairs(c) do
--		print(o,v)
--	end
--end

--game:GetService("DataStoreService"):GetGlobalDataStore():SetAsync("HighRanks",game:GetService("HttpService"):JSONEncode({}))

--saveUserInfo("CrushingDev","Training")