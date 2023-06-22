AddCSLuaFile()

SWEP.PrintName = "'Stalingrad' PPSh-41 SMG"
SWEP.Description = "Not one step back!"

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 105
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true

	SWEP.VMPos = Vector(-10, -40, -10.5)
end

SWEP.Tier = 5

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_waw_ppsh_new.mdl"
SWEP.WorldModel = "models/weapons/w_waw_ppsh_new.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_UMP45.Single")
SWEP.Primary.Damage = 20
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1

SWEP.Primary.ClipSize = 71
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 0.72
SWEP.FireAnimSpeed = 3

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 6.5
SWEP.ConeMin = 3.6

SWEP.WalkSpeed = SPEED_FAST

--SWEP.Tier = 4


SWEP.IronSightsPos = Vector(10, 10, -10)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:OnZombieKilled()
	local killer = self:GetOwner()

	if killer:IsValid() then
		local reaperstatus = killer:GiveStatus("reaper", 29)
		if reaperstatus and reaperstatus:IsValid() then
			reaperstatus:SetDTInt(1, math.min(reaperstatus:GetDTInt(1) + 1, 3))
			killer:EmitSound("hl1/ambience/particle_suck1.wav", 55, 150 + reaperstatus:GetDTInt(1) * 30, 0.45)
		end
	end
end

function SWEP.BulletCallback(attacker, tr)
	local hitent = tr.Entity
	if hitent:IsValidLivingZombie() and hitent:Health() <= hitent:GetMaxHealthEx() * 0.04 and gamemode.Call("PlayerShouldTakeDamage", hitent, attacker) then
		if SERVER then
			hitent:SetWasHitInHead()
		end
		hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, attacker, attacker:GetActiveWeapon(), tr.HitPos)
		hitent:EmitSound("npc/roller/blade_out.wav", 80, 125)
	end
end

if CLIENT then

   function SWEP:CalcViewModelView(ViewModel, OldEyePos, OldEyeAng, EyePos, EyeAng)
        local owner = self:GetOwner()
    
    	local OffsetRight = 5
        local OffsetForward = 3
        local OffsetUp = -2
    
    
    	if owner:KeyDown(IN_ATTACK2) then
      		OffsetRight = 0.35
            OffsetForward = -10
            OffsetUp = 0  
    	end
    
    	local Mul = 1.0

        local Right 	= EyeAng:Right()
        local Up 		= EyeAng:Up()
        local Forward 	= EyeAng:Forward()

        EyePos = EyePos + OffsetRight * Right * Mul
        EyePos = EyePos + OffsetForward * Forward * Mul
        EyePos = EyePos + OffsetUp * Up * Mul

        return EyePos, EyeAng
	end


	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(3.6, -1, -1)
			local offsetAng = Angle(180, 180, 0)
			
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

SWEP.Offset = {
        Pos = {
        Up = 1,
        Right = 0,
        Forward = 2,
        },
        Ang = {
        Up = 0,
        Right = -9,
        Forward = 180,
        },
		Scale = 1.0
}

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.8125)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.45)


function SWEP:GetViewModelPosition(EyePos, EyeAng)
	local Mul = 1.0

	local Offset = self.IronSightsPos

	--if (self.IronSightsAng) then
        --EyeAng = EyeAng * 1
        
		--EyeAng:RotateAroundAxis(EyeAng:Right(), 	self.IronSightsAng.x * Mul)
		--EyeAng:RotateAroundAxis(EyeAng:Up(), 		self.IronSightsAng.y * Mul)
		--EyeAng:RotateAroundAxis(EyeAng:Forward(),   self.IronSightsAng.z * Mul)
	--end

	local Right 	= EyeAng:Right()
	local Up 		= EyeAng:Up()
	local Forward 	= EyeAng:Forward()

	EyePos = EyePos + Offset.x * Right * 2
	EyePos = EyePos + Offset.y * Forward * 5
	EyePos = EyePos + Offset.z * Up * 6
	
	return EyePos, EyeAng
end
