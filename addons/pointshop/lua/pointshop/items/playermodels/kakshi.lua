ITEM.Name = 'Kakashi'
ITEM.Price = 15000 
ITEM.Playermodel = true
ITEM.Model = 'models/kryptonite/kakashi/kakashi_2.mdl'

ITEM.Bodygroups = {
	['Headband'] = { id = 2, values = { 0, 1, 3 } },
	['Sharingan'] = { id = 3, values = { 0, 1 } },
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
