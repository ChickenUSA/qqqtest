AddCSLuaFile()

SWEP.Base = "weapon_zs_butcherknife"

SWEP.ZombieOnly = true
SWEP.MeleeDamage = 28
SWEP.OriginalMeleeDamage = SWEP.MeleeDamage
SWEP.Primary.Delay = 0.45

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitent:IsPlayer() then
		self.MeleeDamage = 18
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	self.MeleeDamage = self.OriginalMeleeDamage
end

function SWEP:SetNextAttack()
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * armdelay)
end

function SWEP:Deploy()
	self.BaseClass.BaseClass.Deploy(self)
	
	local owner = self:GetOwner()
	self.MeleeRange = self.MeleeRange * (owner.ZombieRangeMultiplier or 1)
	self.MeleeDamage = self.MeleeDamage * (owner.ZombieDamageMultiplier or 1)
	self.Primary.Delay = self.Primary.Delay / (owner.ZombieAttackMultiplier or 1)
	
end