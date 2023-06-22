AddCSLuaFile()

SWEP.PrintName = "'Saigon' M16A1 Assault Rifle"
SWEP.Description = "Found deep in the jungle of south Vietnam, still in working condition."

SWEP.Slot = 2
SWEP.SlotPos = 0



if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 80

	SWEP.HUD3DBone = "tag_weapon"
    SWEP.HUD3DPos = Vector(1, -2, 1)
    SWEP.HUD3DAng = Angle(0, 270, 90)
    SWEP.HUD3DScale = 0.015
	
	SWEP.IronSightsPos = Vector(-2.89, 1, 0.5)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_m16a1_vn.mdl"
SWEP.WorldModel = "models/weapons/w_m16a1_vn.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_FAMAS.Clipout")
SWEP.Primary.Sound = Sound("weapons/tfa_nam_m16a1_remake/m4a1_fp.wav")
SWEP.Primary.Damage = 17
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.125

SWEP.Primary.ClipSize = 19
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2.8 --0.045
SWEP.ConeMin = 1.5 --0.019

SWEP.ReloadSpeed = 0.6

SWEP.WalkSpeed = SPEED_SLOW


GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.375, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.2, 1)

SWEP.Offset = {
	Pos = {
		Up = -1.1,
		Right = 0.8,
		Forward = 4.295
	},
	Ang = {
		Up = -1.043,
		Right = 0,
		Forward = 180,
	},
	Scale = 1.0
}
