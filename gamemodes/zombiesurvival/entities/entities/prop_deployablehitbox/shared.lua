ENT.Type = "anim"

ENT.IgnoreMelee = true
ENT.IgnoreBullets = true
ENT.IgnoreTraces = true

ENT.CanPackUp = true

ENT.BoxMin = Vector(-8, -8, 0)
ENT.BoxMax = Vector(8, 8, 8)

function ENT:ShouldNotCollide(ent)
	return false
end

function ENT:GetObjectOwner()
	local parent = self:GetParent()
	if parent:IsValid() then return parent:GetObjectOwner() end

	return NULL
end
