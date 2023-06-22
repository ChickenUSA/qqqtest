ITEM.Name = 'Reagan Hat'
ITEM.Price = 2000
ITEM.Model = "models/reaganbush/reaganbushhat.mdl"
ITEM.Attachment = 'eyes'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -3.5)
	pos = pos + (ang:Up() * 3)
	pos = pos + (ang:Right() * 0)
	model:SetModelScale(1, 0)

	ang:RotateAroundAxis(ang:Up(), -90)

	return model, pos, ang
end

