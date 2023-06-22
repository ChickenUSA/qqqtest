AddCSLuaFile()

SWEP.Base = "weapon_zs_baseshotgun"

SWEP.PrintName = "'Blaster' Pump Shotgun"
SWEP.Description = "12 gauge Mossberg 500 with slugs."

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DPos = Vector(4, -3.5, -1.2)
	SWEP.HUD3DAng = Angle(90, 0, -30)
	SWEP.HUD3DScale = 0.02
	SWEP.HUD3DBone = "SS.Grip.Dummy"
end

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/nmrih/weapons/fa_500a/v_fa_500a.mdl"
SWEP.WorldModel = "models/nmrih/weapons/fa_500a/w_fa_500a.mdl"
SWEP.UseHands = false

--SWEP.Tier = 6

SWEP.Pierces = 10
SWEP.Penetration = 0.9

SWEP.ReloadDelay = 0.4

SWEP.Primary.Sound = Sound("Weapon_Shotgun.NPC_Single")
SWEP.Primary.Damage = 142
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.8

SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 8.75
SWEP.ConeMin = 5

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.PumpSound = Sound("Weapon_M3.Pump")
SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")

SWEP.PumpActivity = ACT_SHOTGUN_PUMP

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Blaster' Slug Gun", "Single accurate slug round, less total damage", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 1.2
	wept.Primary.NumShots = 1
	wept.ConeMin = wept.ConeMin * 0.15
	wept.ConeMax = wept.ConeMax * 0.3
end)


--[[
function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)

	timer.Simple(0.15, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)

			if CLIENT and self:GetOwner() == MySelf then
				self:EmitSound("weapons/m3/m3_pump.wav", 65, 100, 0.4, CHAN_AUTO)
			end
		end
	end)
end
]]--
