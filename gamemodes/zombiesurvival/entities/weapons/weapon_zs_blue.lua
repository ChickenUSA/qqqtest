AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Blue' .44 Magnum"
SWEP.Description = "This gun's bullets will bounce off of walls which will then deal extra damage."
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "ValveBiped.Bip01_R_Hand"
	SWEP.HUD3DPos = Vector(2, 3, -3.5)
    SWEP.HUD3DAng = Angle(0, 90, 270)
    SWEP.HUD3DScale = 0.015

end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/tfre/c_Bungholio_m29.mdl"
SWEP.WorldModel = "models/weapons/TFRE/W_Bungholio_m29.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("weapons/tfre/bungholio_m29/m29_fire.wav")
SWEP.Primary.Delay = 0.7
SWEP.Primary.Damage = 149
SWEP.Primary.NumShots = 1

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
GAMEMODE:SetupDefaultClip(SWEP.Primary)

--SWEP.Tier = 6

SWEP.ConeMax = 3.5
SWEP.ConeMin = 1.75
SWEP.BounceMulti = 6.66

SWEP.IronSightsPos = Vector(-3.22, 4, 1.13)
SWEP.IronSightsAng = Vector(0, 0, 1)



local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
	local RicoCallback = function(att, tr, dmginfo)
		local ent = tr.Entity
		local wep = att:GetActiveWeapon()
		if wep.Branch == 1 and ent:IsValidZombie() then
			wep:SetDTInt(9, wep:GetDTInt(9) + 2)
		end
	end

	attacker.RicochetBullet = true
	if attacker:IsValid() then
		attacker:FireBulletsLua(hitpos, 2 * hitnormal * hitnormal:Dot(normal * -1) + normal, 0, 1, damage, nil, nil, "tracer_rico", RicoCallback, nil, nil, nil, nil, attacker:GetActiveWeapon())
	end
	attacker.RicochetBullet = nil
end
function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if SERVER and tr.HitWorld and not tr.HitSky then
		local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * attacker:GetActiveWeapon().BounceMulti
		timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
	end

	if SERVER then
		local wep = attacker:GetActiveWeapon()
		if wep.Branch == 1 and ent:IsValidZombie() then
			wep:SetDTInt(9, wep:GetDTInt(9) + 1)
		end
	end
end
