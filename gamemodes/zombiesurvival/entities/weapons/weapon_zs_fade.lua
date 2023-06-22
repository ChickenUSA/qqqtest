AddCSLuaFile()

local math = math
local math_random = math.random
local math_Rand = math.Rand
local math_Clamp = math.Clamp

SWEP.PrintName = "'Fade' M9 Bayonet"
SWEP.Description = "Stab zombies to build up speed, miss and it resets."

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
end

--SWEP.DismantlePrice = 100

SWEP.NoDismantle = false

SWEP.Base = "weapon_zs_basemelee"

SWEP.Tier = 4

SWEP.ViewModel = "models/weapons/v_fadee_5.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true
SWEP.HoldType = "melee2"
SWEP.MeleeDamage = 95
SWEP.MeleeRange = 85
SWEP.MeleeSize = 0.9
SWEP.MeleeKnockBack = -10
SWEP.Primary.Delay = 0.55

SWEP.WalkSpeed = SPEED_FASTEST

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.AllowQualityWeapons = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.125)

function SWEP:GetAttackTime( Time )
	local owner = self:GetOwner()
	return (owner.DoubleTapRate and (Time / owner.DoubleTapRate) or Time) * self:GetAttackTimeMultipliers()
end

function SWEP:GetAttackTimeMultipliers()
	return 1
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math_random(75, 95))
end

function SWEP:PlayHitSound()
	self:EmitSound("ambient/machines/slicer"..math.random(4)..".wav", 105)
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("ambient/machines/slicer"..math.random(4)..".wav", 95)
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() then
		local combo = self:GetDTInt(2)
		self:SetNextPrimaryFire(CurTime() + self:GetAttackTime(math.max(0.2, self.Primary.Delay * (1 - combo / 10))))
		self:SetDTInt(2, combo + 1)
	end
end

function SWEP:PostOnMeleeMiss(tr)
	self:SetDTInt(2, 0)
end
