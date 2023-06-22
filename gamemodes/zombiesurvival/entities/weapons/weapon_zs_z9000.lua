AddCSLuaFile()

SWEP.PrintName = "'Z9000' Pulse Pistol"
SWEP.Description = "Although the Z9000 does not deal that much damage, the pulse shots it fires will slow targets."
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
	
	SWEP.ShowViewModel = false

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 2, -4.092), angle = Angle(170, 10, 10), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_alyx_gun.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("weapons/alyx_gun/alyx_shotgun_cock1.wav")
SWEP.Primary.Sound = Sound("weapons/alyx_gun/alyx_gun_fire3.wav")
SWEP.Primary.Damage = 14.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.2

SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 50

SWEP.ConeMax = 2
SWEP.ConeMin = 1.5

SWEP.IronSightsPos = Vector(-5.95, 3, 2.75)
SWEP.IronSightsAng = Vector(-0.15, -1, 2)

SWEP.TracerName = "AR2Tracer"

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.25)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.0175, 1)

SWEP.PointsMultiplier = GAMEMODE.PulsePointsMultiplier

local branch = GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Curie-osity' Rad-Blaster", "Shoots an irradiated particle that deals area damage but does not slow", function(wept)	
	function wept.BulletCallback(attacker, tr, dmginfo)
		local ent = tr.Entity
			
		if ent:IsValidZombie() then
			util.BlastDamageEx(attacker:GetActiveWeapon(), attacker, ent:GetPos(), 88, wept.Primary.Damage/3, DMG_DISSOLVE, 0.94)
		end
		
	end
end)
branch.Colors = {Color(150, 110, 180), Color(130, 90, 160), Color(110, 60, 150)}
branch.NewNames = {"Accelerated", "Phased", "Amplified"}


function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValidZombie() then
		ent:AddLegDamageExt(4.5, attacker, attacker:GetActiveWeapon(), SLOWTYPE_PULSE)
	end

	if IsFirstTimePredicted() then
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
	end
end
