INC_SERVER()

SWEP.OriginalMeleeDamage = SWEP.MeleeDamage

function SWEP:Deploy()
	self.BaseClass.BaseClass.Deploy(self)
	
	local owner = self:GetOwner()
	self.MeleeRange = self.MeleeRange * (owner.ZombieRangeMultiplier or 1)
	self.MeleeDamage = self.MeleeDamage * (owner.ZombieDamageMultiplier or 1)
	self.Primary.Delay = self.Primary.Delay / (owner.ZombieAttackMultiplier or 1)
	self.BaseClass.Initialize(self)
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitent:IsPlayer() then
		self.MeleeDamage = 30
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	self.MeleeDamage = self.OriginalMeleeDamage
end
