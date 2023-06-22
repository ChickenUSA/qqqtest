ITEM.Name = 'Trixie"s Hat' 	--alternatively, autism hat 2
ITEM.Price = 15000 
ITEM.Model = "models/vn_trixie_hat_trixie.mdl"
ITEM.Attachment = 'eyes'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -2)
	pos = pos + (ang:Up() * -17)
	pos = pos + (ang:Right() * -5)
	model:SetModelScale(0.45, 0)
	
	ang:RotateAroundAxis(ang:Up(), -90)
	
 

	return model, pos, ang
end

