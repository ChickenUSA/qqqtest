ITEM.Name = 'Felix Argyle'
ITEM.Price = 250000
ITEM.Playermodel = true
ITEM.Model = 'models/player/shi/Felix_Argyle.mdl'

ITEM.Bodygroups = {
	['Arm Ribbon'] = { id = 3, values = { 0, 1 } },
	['Arm Sleeves'] = { id = 4, values = { 0, 1 } },
	['Back Ribbon'] = { id = 6, values = { 0, 1 } },
	['Choker'] = { id = 7, values = { 0, 1, 2 } },
	['Leg Ribbon'] = { id = 8, values = { 0, 1 } },
	['Socks'] = { id = 9, values = { 0, 1 } },
	['Shoes'] = { id = 11, values = { 0, 1 } },
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

--this model added by chicken no one else is allowed to use
