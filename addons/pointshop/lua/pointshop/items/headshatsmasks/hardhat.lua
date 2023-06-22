ITEM.Name = 'Hard Hat'
ITEM.Price = 10000 
ITEM.Model = "models/helpers_hardhat.mdl"
ITEM.Attachment = 'eyes'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -8)
	pos = pos + (ang:Up() * -75)
	pos = pos + (ang:Right() * 0)
	model:SetModelScale(1, 0)
	
	ang:RotateAroundAxis(ang:Up(), 0)
	
 

	return model, pos, ang
end

