ITEM.Name = 'Vector'
ITEM.Price = 25000 
ITEM.Playermodel = true
ITEM.Model = 'models/player/lordvipes/rerc_vector/vector_cvp.mdl'

function ITEM:OnEquip(ply, modifications)
	if not ply._OldModel then
		ply._OldModel = ply:GetModel()
	end
	
	timer.Simple(1, function() ply:SetModel(self.Model) end)
end

function ITEM:OnHolster(ply)
	if ply._OldModel then
		ply:SetModel(self.Model)
	end
end

function ITEM:PlayerSetModel(ply)
	ply:SetModel(self.Model)
end

-- requested by obama