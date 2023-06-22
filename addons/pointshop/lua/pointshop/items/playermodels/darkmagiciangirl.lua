ITEM.Name = 'Dark Magician Girl'
ITEM.Price = 10000 
ITEM.Playermodel = true
ITEM.Model = 'models/konnie/jumpforce/darkmagiciangirl.mdl'

ITEM.Bodygroups = {
	['Hat'] = { id = 1, values = { 0, 1 } },
	['Staff'] = { id = 2, values = { 0, 1 } },
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

--95% hp 
