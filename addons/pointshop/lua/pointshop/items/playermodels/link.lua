ITEM.Name = 'Link'
ITEM.Price = 35000 
ITEM.Playermodel = true
ITEM.Model = 'models/auditor/botw/femininelookinboi/botw_link_player.mdl'

ITEM.Bodygroups = {
	['Sword Belt'] = { id = 1, values = { 0, 1 } },
	['Earrings'] = { id = 2, values = { 0, 1 } },
	['Gauntlet'] = { id = 3, values = { 0, 1 } },
	['Shield'] = { id = 4, values = { 0, 1, 2 } },
	['Sword'] = { id = 6, values = { 0, 1, 2 } },
	['Sword Belt'] = { id = 7, values = { 0, 1, 2 } },
	['Slate'] = { id = 8, values = { 0, 1 } },
}

function ITEM:OnEquip(ply, modifications)
	if not ply._OldModel then
		ply._OldModel = ply:GetModel()
	end
	
	timer.Simple (2, function()
		ply:SetModel(self.Model)
		self:SetBodygroups (ply, modifications)
	end)
end

function ITEM:OnHolster(ply)
	if ply._OldModel then
		ply:SetModel(self.Model)
	end
end

function ITEM:PlayerSetModel(ply)
	ply:SetModel(self.Model)
end
