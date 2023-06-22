ITEM.Name = 'Aeon(alt)'
ITEM.Price = 25000 
ITEM.Playermodel = true
ITEM.Model = 'models/aeonpm/aeon2.mdl'


ITEM.Bodygroups = {
	['Frill'] = { id = 1, values = { 0, 1 } },
	['Fins'] = { id = 2, values = { 0, 1 } },
	['Chestpad'] = { id = 3, values = { 0, 1 } },
	['Shoulderpads'] = { id = 4, values = { 0, 1 } },
	['Wristguards'] = { id = 5, values = { 0, 1 } },
	['Legpads'] = { id = 6, values = { 0, 1 } },
	['Ankleguards'] = { id = 7, values = { 0, 1 } },
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
