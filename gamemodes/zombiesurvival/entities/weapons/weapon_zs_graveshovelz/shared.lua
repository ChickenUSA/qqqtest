SWEP.Base = "weapon_zs_graveshovel"
SWEP.ZombieOnly = true

SWEP.MeleeDamage = 40
SWEP.MeleeKnockBack = 0

SWEP.MeleeRange = 85

	
function SWEP:Initialize()
	
	local owner = self:GetOwner()
	self.MeleeRange = self.MeleeRange * (owner.ZombieRangeMultiplier or 1)
	self.MeleeDamage = self.MeleeDamage * (owner.ZombieDamageMultiplier or 1)
	self.Primary.Delay = self.Primary.Delay / (owner.ZombieAttackMultiplier or 1)
	self.BaseClass.Initialize(self)
end
