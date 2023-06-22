ITEM.Name = 'Knockoff Backpack'
ITEM.Price = 50000 
ITEM.Model = "models/harrypotterobamasonic/harrypotterobamasonic.mdl"
ITEM.Bone = 'ValveBiped.Bip01_Spine2'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(1.2, 0)    
	ang:RotateAroundAxis(ang:Up(), 270) 
	ang:RotateAroundAxis(ang:Forward(), -90)
	pos = pos + (ang:Forward() * 4)
	pos = pos + (ang:Up() * 2)
	return model, pos, ang
end