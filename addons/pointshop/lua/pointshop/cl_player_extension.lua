local meta = FindMetaTable("Player")
if not meta then return end
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
local net_ReadInt = net.ReadInt
local net_ReadString = net.ReadString
local net_ReadTable = net.ReadTable
local net_ReadUInt = net.ReadUInt
local net_ReadEntity = net.ReadEntity
-- items

function meta:PS_GetItems()
	return self.PS_Items or {}
end

function meta:PS_HasItem(item_id)
	if not self.PS_Items then return false end
	return self.PS_Items[item_id] and true or false
end

function meta:PS_HasItemEquipped(item_id)
	if not self:PS_HasItem(item_id) then return false end
	
	return self.PS_Items[item_id].Equipped or false
end

function meta:PS_BuyItem(item_id)
	if self:PS_HasItem(item_id) then return false end
	--if not self:PS_HasPoints(PS.Config.CalculateBuyPrice(self, PS.Items[item_id])) then return false end
	
	net_Start('PS_BuyItem')
		net_WriteString(item_id)
	net_SendToServer()
end

function meta:PS_SellItem(item_id)
	if not self:PS_HasItem(item_id) then return false end
	
	net_Start('PS_SellItem')
		net_WriteString(item_id)
	net_SendToServer()
end

function meta:PS_EquipItem(item_id)
	if not self:PS_HasItem(item_id) then return false end
	if self:Team() ~= TEAM_HUMAN then return false end
	
	net_Start('PS_EquipItem')
		net_WriteString(item_id)
	net_SendToServer()
end

function meta:PS_HolsterItem(item_id)
	if not self:PS_HasItem(item_id) then return false end
	
	net_Start('PS_HolsterItem')
		net_WriteString(item_id)
	net_SendToServer()
end

-- points

function meta:PS_GetPoints()
	return self.PS_Points or 0
end

function meta:PS_HasPoints(points)
	return self:PS_GetPoints() >= points
end

-- clientside models

function meta:PS_AddClientsideModel(item_id)
	if not PS.Items[item_id] then return false end
	
	local ITEM = PS.Items[item_id]
	
	local mdl = ClientsideModel(ITEM.Model, RENDERGROUP_OPAQUE)
	mdl:SetNoDraw(true)
	
	if not PS.ClientsideModels[self] then PS.ClientsideModels[self] = {} end
	PS.ClientsideModels[self][item_id] = mdl
end

function meta:PS_RemoveClientsideModel(item_id)
	if not PS.Items[item_id] then return false end
	if not PS.ClientsideModels[self] then return false end
	if not PS.ClientsideModels[self][item_id] then return false end
	
	PS.ClientsideModels[self][item_id] = nil
end
