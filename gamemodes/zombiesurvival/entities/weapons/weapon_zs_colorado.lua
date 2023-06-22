AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Colorado' Hi-Point Carbine"
SWEP.Description = "Rifle damage for the price of pistol ammo, what a deal."
SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	
	SWEP.IronSightsPos = Vector(-2.55, 2.01, 0.40)
	
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_hipoint.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"
--SWEP.WorldModel = "models/weapons/w_hipoint.mdl"--disabled until i can figure out how to reposition world models
SWEP.UseHands = false

SWEP.Primary.Sound = Sound("weapons/hipoint/fire.wav")
SWEP.Primary.Damage = 27
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.10

SWEP.NoDismantle = false

SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2.3
SWEP.ConeMin = 1.1

SWEP.ReloadSpeed = 1
SWEP.HeadshotMulti = 2

--SWEP.Tier = 2

