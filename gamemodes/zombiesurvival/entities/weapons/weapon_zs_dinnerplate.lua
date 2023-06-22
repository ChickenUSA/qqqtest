AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Dinner Plate' DP-28 Machine Gun"
SWEP.Description = "Slow fire rate for an lmg, but the damage makes up for it."

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 90

    SWEP.VMPos = Vector(0, 0, 0)     
  --SWEP.VMAng = Vector(2, 0, 0)
  
end

SWEP.Base = "weapon_zs_base"

SWEP.Tier = 2

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_waw_dp28_new.mdl"
SWEP.WorldModel = "models/weapons/w_waw_dp28_new.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_SG552.Clipout")
SWEP.Primary.Sound = Sound("Weapon_SG552.Single")
SWEP.Primary.Damage = 18.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.12

SWEP.Primary.ClipSize = 47
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 2
SWEP.ConeMin = 0.8
SWEP.HeadshotMulti = 2.1

SWEP.ReloadSpeed = 1.1

SWEP.WalkSpeed = SPEED_SLOW

--SWEP.Tier = 2

SWEP.IronSightsPos = Vector(3.53, 10, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

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


function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:SetNextShot(nextshot)
	self:SetDTFloat(5, nextshot)
end

function SWEP:GetNextShot()
	return self:GetDTFloat(5)
end

function SWEP:SetShotsLeft(shotsleft)
	self:SetDTInt(1, shotsleft)
end

function SWEP:GetShotsLeft()
	return self:GetDTInt(1)
end
