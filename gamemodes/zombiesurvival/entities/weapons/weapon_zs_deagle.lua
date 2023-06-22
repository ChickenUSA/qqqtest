AddCSLuaFile()

SWEP.PrintName = "'Zombie Drill' Desert Eagle"
SWEP.Description = "This handgun uses high-powered rounds that have more knockback than others." --SWEP.Description = "This high-powered handgun has the ability to pierce through multiple zombies. The bullet's power decreases by half which each zombie it hits."
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55

	SWEP.HUD3DBone = "v_weapon.Deagle_Slide"
	SWEP.IronsightsMultiplier = .6
	SWEP.IronSightsPos = Vector(-1.68, 10, 0.80)
	

end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/c_iw3_deserteagle.mdl"
SWEP.WorldModel = "models/weapons/w_iw3_deserteagle.mdl" --the positioning on this is fucked up and idk how to fix it
--SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

SWEP.UseHands = true

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(-.5, -1, -1)
			local offsetAng = Angle(0, 0, 180)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end




SWEP.Primary.Sound = Sound("weapons/deagle/fire.wav")
SWEP.Primary.Sound_World = Sound("weapons/deagle/npc.wav")
SWEP.Primary.Damage = 33
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.32
SWEP.Primary.KnockbackScale = 2
SWEP.HeadshotMulti = 3.33

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Pierces = 3
SWEP.Penetration = 0.6

SWEP.ConeMax = 3.4
SWEP.ConeMin = 1.25

SWEP.FireAnimSpeed = 1.3

SWEP.Tier = 3

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 2)
