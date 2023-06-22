--[[
	pointshop/sv_init.lua
	first file included serverside.
]]--

include "sh_init.lua"
include "sv_player_extension.lua"
include "sv_manifest.lua"
local util_AddNetworkString = util.AddNetworkString
local player_GetAll = player.GetAll()
local net_Start = net.Start
local net_WriteString = net.WriteString
local net_WriteVector = net.WriteVector
local net_WriteEntity = net.WriteEntity
local net_WriteFloat = net.WriteFloat
local net_Send = net.Send
local net_Broadcast = net.Broadcast
local net_WriteUInt = net.WriteUInt
local net_WriteBit = net.WriteBit
local net_WriteBool = net.WriteBool
local net_WriteInt = net.WriteInt
local net_WriteTable = net.WriteTable
local net_SendToServer = net.SendToServer
local net_Receive = net.Receive
local net_ReadEntity = net.ReadEntity
local net_ReadInt = net.ReadInt
local net_ReadString = net.ReadString
local net_ReadTable = net.ReadTable
local net_ReadUInt = net.ReadUInt
-- net hooks

net_Receive('PS_BuyItem', function(length, ply)
	ply:PS_BuyItem(net_ReadString())
end)

net_Receive('PS_SellItem', function(length, ply)
	ply:PS_SellItem(net_ReadString())
end)

net_Receive('PS_EquipItem', function(length, ply)
	ply:PS_EquipItem(net_ReadString())
end)

net_Receive('PS_HolsterItem', function(length, ply)
	ply:PS_HolsterItem(net_ReadString())
end)

net_Receive('PS_ModifyItem', function(length, ply)
	ply:PS_ModifyItem(net_ReadString(), net_ReadTable())
end)

-- player to player

net_Receive('PS_SendPoints', function(length, ply)
	local other = net_ReadEntity()
	local points = math.Clamp(net_ReadInt(32), 0, 1000000)
	
	if not PS.Config.CanPlayersGivePoints then return end
	if not points or points == 0 then return end
	if not other or not IsValid(other) or not other:IsPlayer() then return end
	if not ply or not IsValid(ply) or not ply:IsPlayer() then return end
	if not ply:PS_HasPoints(points) then
		ply:PS_Notify("You can't afford to give away ", points, " of your ", PS.Config.PointsName, ".")
		return
	end

	ply.PS_LastGavePoints = ply.PS_LastGavePoints or 0
	if ply.PS_LastGavePoints + 5 > CurTime() then
		ply:PS_Notify("Slow down! You can't give away points that fast.")
		return
	end

	ply:PS_TakePoints(points)
	ply:PS_Notify("You gave ", other:Nick(), " ", points, " of your ", PS.Config.PointsName, ".")
		
	other:PS_GivePoints(points)
	other:PS_Notify(ply:Nick(), " gave you ", points, " of their ", PS.Config.PointsName, ".")

	ply.PS_LastGavePoints = CurTime()
end)

-- admin points

net_Receive('PS_GivePoints', function(length, ply)
	local other = net_ReadEntity()
	local points = net_ReadInt(32)
	
	if not PS.Config.AdminCanAccessAdminTab and not PS.Config.SuperAdminCanAccessAdminTab then return end
	
	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsSuperAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsDeveloper()
	
	if (admin_allowed or super_admin_allowed) and other and points and IsValid(other) and other:IsPlayer() then
		other:PS_GivePoints(points)
		other:PS_Notify(ply:Nick(), ' gave you ', points, ' ', PS.Config.PointsName, '.')
	end
end)

net_Receive('PS_TakePoints', function(length, ply)
	local other = net_ReadEntity()
	local points = net_ReadInt(32)
	
	if not PS.Config.AdminCanAccessAdminTab and not PS.Config.SuperAdminCanAccessAdminTab then return end
	
	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()
	
	if (admin_allowed or super_admin_allowed) and other and points and IsValid(other) and other:IsPlayer() then
		other:PS_TakePoints(points)
		other:PS_Notify(ply:Nick(), ' took ', points, ' ', PS.Config.PointsName, ' from you.')
	end
end)

net_Receive('PS_SetPoints', function(length, ply)
	local other = net_ReadEntity()
	local points = net_ReadInt(32)
	
	if not PS.Config.AdminCanAccessAdminTab and not PS.Config.SuperAdminCanAccessAdminTab then return end
	
	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()
	
	if (admin_allowed or super_admin_allowed) and other and points and IsValid(other) and other:IsPlayer() then
		other:PS_SetPoints(points)
		other:PS_Notify(ply:Nick(), ' set your ', PS.Config.PointsName, ' to ', points, '.')
	end
end)

-- admin items

net_Receive('PS_GiveItem', function(length, ply)
	local other = net_ReadEntity()
	local item_id = net_ReadString()
	
	if not PS.Config.AdminCanAccessAdminTab and not PS.Config.SuperAdminCanAccessAdminTab then return end
	
	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()
	
	if (admin_allowed or super_admin_allowed) and other and item_id and PS.Items[item_id] and IsValid(other) and other:IsPlayer() and not other:PS_HasItem(item_id) then
		other:PS_GiveItem(item_id)
	end
end)

net_Receive('PS_TakeItem', function(length, ply)
	local other = net_ReadEntity()
	local item_id = net_ReadString()
	
	if not PS.Config.AdminCanAccessAdminTab and not PS.Config.SuperAdminCanAccessAdminTab then return end
	
	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()
	
	if (admin_allowed or super_admin_allowed) and other and item_id and PS.Items[item_id] and IsValid(other) and other:IsPlayer() and other:PS_HasItem(item_id) then
		-- holster it first without notificaiton
		other.PS_Items[item_id].Equipped = false
	
		local ITEM = PS.Items[item_id]
		ITEM:OnHolster(other)
		other:PS_TakeItem(item_id)
	end
end)

-- hooks

-- Ability to use any button to open pointshop.
hook.Add("PlayerButtonDown", "PS_ToggleKey", function(ply, btn)
	if PS.Config.ShopKey and PS.Config.ShopKey ~= "" then
		local psButton = _G["KEY_" .. string.upper(PS.Config.ShopKey)]
		if psButton and psButton == btn then
			ply:PS_ToggleMenu()
		end
	end
end)

hook.Add('PlayerSpawn', 'PS_PlayerSpawn', function(ply) ply:PS_PlayerSpawn() end)
hook.Add('PlayerDeath', 'PS_PlayerDeath', function(ply) ply:PS_PlayerDeath() end)
hook.Add('PlayerInitialSpawn', 'PS_PlayerInitialSpawn', function(ply) ply:PS_PlayerInitialSpawn() end)
hook.Add('PlayerDisconnected', 'PS_PlayerDisconnected', function(ply) ply:PS_PlayerDisconnected() end)

hook.Add('PlayerSay', 'PS_PlayerSay', function(ply, text)
	if string.len(PS.Config.ShopChatCommand) > 0 and ply:Team()==TEAM_HUMAN then
		if string.sub(text, 0, string.len(PS.Config.ShopChatCommand)) == PS.Config.ShopChatCommand then
			ply:PS_ToggleMenu()
			return ''
		end
	end
end)

-- ugly networked strings

util_AddNetworkString('PS_Items')
util_AddNetworkString('PS_Points')
util_AddNetworkString('PS_BuyItem')
util_AddNetworkString('PS_SellItem')
util_AddNetworkString('PS_EquipItem')
util_AddNetworkString('PS_HolsterItem')
util_AddNetworkString('PS_ModifyItem')
util_AddNetworkString('PS_SendPoints')
util_AddNetworkString('PS_GivePoints')
util_AddNetworkString('PS_TakePoints')
util_AddNetworkString('PS_SetPoints')
util_AddNetworkString('PS_GiveItem')
util_AddNetworkString('PS_TakeItem')
util_AddNetworkString('PS_AddClientsideModel')
util_AddNetworkString('PS_RemoveClientsideModel')
util_AddNetworkString('PS_SendClientsideModels')
util_AddNetworkString('PS_SendNotification')
util_AddNetworkString('PS_ToggleMenu')

-- console commands

concommand.Add(PS.Config.ShopCommand, function(ply, cmd, args)
	ply:PS_ToggleMenu()
end)

concommand.Add('ps_clear_points', function(ply, cmd, args)
	if IsValid(ply) then return end -- only allowed from server console
	
	for _, ply in ipairs(player_GetAll) do
		ply:PS_SetPoints(0)
	end
	
	sql.Query("DELETE FROM playerpdata WHERE infoid LIKE '%PS_Points%'")
end)

concommand.Add('ps_clear_items', function(ply, cmd, args)
	if IsValid(ply) then return end -- only allowed from server console
	
	for _, ply in ipairs(player_GetAll) do
		ply.PS_Items = {}
		ply:PS_SendItems()
	end
	
	sql.Query("DELETE FROM playerpdata WHERE infoid LIKE '%PS_Items%'")
end)

-- version checker

PS.CurrentBuild = 0
PS.LatestBuild = 0
PS.BuildOutdated = false

local function CompareVersions()
	if PS.CurrentBuild < PS.LatestBuild then
		MsgN('PointShop is out of date!')
		MsgN('Local version: ' .. PS.CurrentBuild .. ', Latest version: ' .. PS.LatestBuild)

		PS.BuildOutdated = true
	else
		MsgN('PointShop is on the latest version.')
	end
end

function PS:CheckVersion()
	if file.Exists('data/pointshop_build.txt', 'GAME') then
		PS.CurrentBuild = tonumber(file.Read('data/pointshop_build.txt', 'GAME')) or 0
	end

	local url = self.Config.Branch .. 'data/pointshop_build.txt'
	http.Fetch( url,
		function( content ) -- onSuccess
			PS.LatestBuild = tonumber( content ) or 0
			CompareVersions()
		end,
		function(failCode) -- onFailure
			MsgN('PointShop couldn\'t check version.')
			MsgN(url, ' returned ', failCode)
		end
	)
end

-- data providers

function PS:LoadDataProvider()
	local path = "pointshop/providers/" .. self.Config.DataProvider .. ".lua"
	if not file.Exists(path, "LUA") then
		error("Pointshop data provider not found. " .. path)
	end

	PROVIDER = {}
	PROVIDER.__index = {}
	PROVIDER.ID = self.Config.DataProvider
		
	include(path)
		
	self.DataProvider = PROVIDER
	PROVIDER = nil
end

function PS:GetPlayerData(ply, callback)
	self.DataProvider:GetData(ply, function(points, items)
		callback(PS:ValidatePoints(tonumber(points)), PS:ValidateItems(items))
	end)
end

function PS:SetPlayerData(ply, points, items)
	self.DataProvider:SetData(ply, points, items)
end

function PS:SetPlayerPoints(ply, points)
	self.DataProvider:SetPoints(ply, points)
end

function PS:GivePlayerPoints(ply, points)
	self.DataProvider:GivePoints(ply, points, items)
end

function PS:TakePlayerPoints(ply, points)
	self.DataProvider:TakePoints(ply, points)
end

function PS:SavePlayerItem(ply, item_id, data)
	self.DataProvider:SaveItem(ply, item_id, data)
end

function PS:GivePlayerItem(ply, item_id, data)
	self.DataProvider:GiveItem(ply, item_id, data)
end

function PS:TakePlayerItem(ply, item_id)
	self.DataProvider:TakeItem(ply, item_id)
end