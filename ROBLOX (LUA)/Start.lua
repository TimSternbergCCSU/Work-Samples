--[[
	Written by Tim Sternberg
	Main driver called "start" which upon a client event will add a map to the queue
--]]

Main = script.Parent.Parent
v = require(Main["Variables"])

function Start(info)
	local MapName = info.MapName
	local GameMode = info.GameMode
	local Weapons = info.Weapons
	local Settings = info.Settings
	
	--Making sure it's a valid queue. If not, abort.
	if not (MapName and GameMode) then return end
	
	--Clearing everything
	--If there's already a map, let's make loading = true so we don't see the ugly removal of maps :)
	if v.CurrentMap() then v.Loading.Value = true v.End() end
	v.ResetStats()
	
	--Setting custom values
	for name,option in pairs(Settings) do -- option[1] being the name, option[2] being true/false, option[3] being the amount (if specified)
		if v.Values:FindFirstChild(name) then
			v.Values[name].Value = option[1] -- Setting true/false to the value specified in options
			if option[1] and option[2] and v.Values[name]:FindFirstChild("Amount") then -- If value is true and amount is specified then set the amount to it
				v.Values[name].Amount.Value = option[2]
			elseif option[1] and option[2] then
				v.Values[name].Value = option[2]
			end
		end
	end
	
	-- Finding the map model
	v.Loading.Value = true
	for i,c in pairs(game.Players:GetPlayers()) do
		if c.Character then
			c.Character:Remove()
		end
	end
	wait()
	if v.Lobby.Parent == workspace then
		v.Lobby.Parent = nil
		wait()
	end
	v.MapModel = v.MAPS:FindFirstChild(MapName)
	if v.MapModel.Value ~= 0 then
		local AssetId = v.MapModel.Value
		local success, err = pcall(function()
			v.MapModel = game:GetService("InsertService"):LoadAsset(AssetId)
			for i,c in pairs(v.MapModel:GetChildren()) do
				v.MapModel = c
			end
		end)
		if not success then
			warn("unable to insert model because " .. err)
			v.End()
			return
		end
	elseif v.MAPS2:FindFirstChild(v.MapModel.Name) then
		v.MapModel = v.MAPS2:FindFirstChild(v.MapModel.Name).Map:Clone()
		v.MapModel.Name = MapName
	else
		v.End()
		return
	end

	v.MapContainer = Instance.new("Model")
	v.MapContainer.Name = v.MapModel.Name
	v.MapModel.Parts:Clone().Parent = v.MapContainer
	
	-- Setting up the game mode
	local gmstorage = v.MapModel:FindFirstChild("Storage")
	if gmstorage and gmstorage:FindFirstChild(GameMode)  then
		for i,c in pairs(gmstorage:FindFirstChild(GameMode):GetChildren()) do
			c:Clone().Parent = v.MapContainer
		end
	end
	
	--Finalizing settings
	local Mode = v.ListOfModes:FindFirstChild(GameMode)
	if Mode then
		v.AddGuns(Weapons,game.StarterPack)
		v.GameMode.Value = GameMode
		require(Mode)() -- players are respawned once MakeTeams is finished placing everyone on a team. MakeTeams is called by the game mode.
		v.UpdateForcefield(v.MapContainer)
		v.MapContainer.Parent = v.Maps
		v.MapContainer:MakeJoints()
		v.Loading.Value = false
	else
		error("There was a problem starting maps; Mode '" .. GameMode .. "' does not exist")
		v.End()
		return
	end
	repeat
		wait(1)
		if v.Time.Value then v.Time.Amount.Value = v.Time.Amount.Value - 1 end
	until not v.MapContainer.Parent or (v.Time.Value and v.Time.Amount.Value <= 0)
	if v.MapContainer.Parent then v.End() end
	
	if #v.Queue > 0 then -- If #Queue == 0 then that means the queue was cleared somewhere else. Just end the function if that's the case
		table.remove(v.Queue,1)
	end
end

function Receive(info,place)
	if place == 1 then
		if (not v.Queue[place]) or (info.MapName ~= v.Queue[place].MapName) then
			v.Queue = {}
			v.Queue[place] = info
			
			while #v.Queue > 0 do
				v.Start( v.Queue[1] )
				wait()
			end
			
			v.Lobby.Parent = workspace
			wait()
			v.RespawnAllPlayers()
			v.Loading.Value = false
		else
			v.Queue[place] = info
		end
	else
		v.Queue[place] = info
	end 
end

v.MapStart.OnServerEvent:connect(function(player,info,place)
	Receive(info,place)
end)
v.GlobalMapStart.Event:connect(Receive)

return StartMain = script.Parent.Parent
v = require(Main["Variables"])

function Start(info)
	local MapName = info.MapName
	local GameMode = info.GameMode
	local Weapons = info.Weapons
	local Settings = info.Settings
	
	--Making sure it's a valid queue. If not, abort.
	if not (MapName and GameMode) then return end
	
	--Clearing everything
	--If there's already a map, let's make loading = true so we don't see the ugly removal of maps :)
	if v.CurrentMap() then v.Loading.Value = true v.End() end
	v.ResetStats()
	
	--Setting custom values
	for name,option in pairs(Settings) do -- option[1] being the name, option[2] being true/false, option[3] being the amount (if specified)
		if v.Values:FindFirstChild(name) then
			v.Values[name].Value = option[1] -- Setting true/false to the value specified in options
			if option[1] and option[2] and v.Values[name]:FindFirstChild("Amount") then -- If value is true and amount is specified then set the amount to it
				v.Values[name].Amount.Value = option[2]
			elseif option[1] and option[2] then
				v.Values[name].Value = option[2]
			end
		end
	end
	
	-- Finding the map model
	v.Loading.Value = true
	for i,c in pairs(game.Players:GetPlayers()) do
		if c.Character then
			c.Character:Remove()
		end
	end
	wait()
	if v.Lobby.Parent == workspace then
		v.Lobby.Parent = nil
		wait()
	end
	v.MapModel = v.MAPS:FindFirstChild(MapName)
	if v.MapModel.Value ~= 0 then
		local AssetId = v.MapModel.Value
		local success, err = pcall(function()
			v.MapModel = game:GetService("InsertService"):LoadAsset(AssetId)
			for i,c in pairs(v.MapModel:GetChildren()) do
				v.MapModel = c
			end
		end)
		if not success then
			warn("unable to insert model because " .. err)
			v.End()
			return
		end
	elseif v.MAPS2:FindFirstChild(v.MapModel.Name) then
		v.MapModel = v.MAPS2:FindFirstChild(v.MapModel.Name).Map:Clone()
		v.MapModel.Name = MapName
	else
		v.End()
		return
	end

	v.MapContainer = Instance.new("Model")
	v.MapContainer.Name = v.MapModel.Name
	v.MapModel.Parts:Clone().Parent = v.MapContainer
	
	-- Setting up the game mode
	local gmstorage = v.MapModel:FindFirstChild("Storage")
	if gmstorage and gmstorage:FindFirstChild(GameMode)  then
		for i,c in pairs(gmstorage:FindFirstChild(GameMode):GetChildren()) do
			c:Clone().Parent = v.MapContainer
		end
	end
	
	--Finalizing settings
	local Mode = v.ListOfModes:FindFirstChild(GameMode)
	if Mode then
		v.AddGuns(Weapons,game.StarterPack)
		v.GameMode.Value = GameMode
		require(Mode)() -- players are respawned once MakeTeams is finished placing everyone on a team. MakeTeams is called by the game mode.
		v.UpdateForcefield(v.MapContainer)
		v.MapContainer.Parent = v.Maps
		v.MapContainer:MakeJoints()
		v.Loading.Value = false
	else
		error("There was a problem starting maps; Mode '" .. GameMode .. "' does not exist")
		v.End()
		return
	end
	repeat
		wait(1)
		if v.Time.Value then v.Time.Amount.Value = v.Time.Amount.Value - 1 end
	until not v.MapContainer.Parent or (v.Time.Value and v.Time.Amount.Value <= 0)
	if v.MapContainer.Parent then v.End() end
	
	if #v.Queue > 0 then -- If #Queue == 0 then that means the queue was cleared somewhere else. Just end the function if that's the case
		table.remove(v.Queue,1)
	end
end

function Receive(info,place)
	if place == 1 then
		if (not v.Queue[place]) or (info.MapName ~= v.Queue[place].MapName) then
			v.Queue = {}
			v.Queue[place] = info
			
			while #v.Queue > 0 do
				v.Start( v.Queue[1] )
				wait()
			end
			
			v.Lobby.Parent = workspace
			wait()
			v.RespawnAllPlayers()
			v.Loading.Value = false
		else
			v.Queue[place] = info
		end
	else
		v.Queue[place] = info
	end 
end

v.MapStart.OnServerEvent:connect(function(player,info,place)
	Receive(info,place)
end)
v.GlobalMapStart.Event:connect(Receive)

return Start