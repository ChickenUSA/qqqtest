DEFINE_BASECLASS("weapon_zs_base")
SWEP.Base = "weapon_zs_base"

SWEP.PrintName = "M1911"
SWEP.Purpose = "lol fuck off"

SWEP.CSMuzzleFlashes = true

SWEP.Primary.Damage = 45
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 14
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.DefaultClip = 14 * 3
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.25


SWEP.ConeMax = 1
SWEP.ConeMin = 0.5

SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_basecolt191.mdl"
SWEP.WorldModel = "models/weapons/w_basecolt191.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Tier = 4
SWEP.Slot = 1
SWEP.SlotPos = 74

SWEP.ReloadSound = Sound("")
SWEP.Primary.Sound = Sound("weapons/basecolt191/basecolt191shoot.wav")

SWEP.HUD3DBone = "body"
	SWEP.HUD3DPos = Vector(-1, -1.2, -1.5)
	SWEP.HUD3DAng = Angle(90, 270, 90)

SWEP.VElements = {
	["GUN"] = { type = "Model", model = "models/weapons/1911/w_m1911.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-1.706, -12.382, 3.019), angle = Angle(0, 76.981, 104.151), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["GUN2"] = { type = "Model", model = "models/weapons/1911/w_m1911.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-1.3, -12.075, -2.013), angle = Angle(0, 79.245, 72.453), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.IronSightsPos = Vector(-2, -3, 0.35)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.RTOpaque	= true

SWEP.Type = "American .45 ACP Semi Automatic Pistol"

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.DrawAmmo = true
