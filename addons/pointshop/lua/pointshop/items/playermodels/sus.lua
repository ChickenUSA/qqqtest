ITEM.Name = 'sus'
ITEM.Price = 35000
ITEM.Playermodel = true
ITEM.Model = 'models/amongus/player/player.mdl'

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

--this model was requested by folium so blame him 
--should have 0.8 health reduction