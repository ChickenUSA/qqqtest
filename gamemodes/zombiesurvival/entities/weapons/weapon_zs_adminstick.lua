AddCSLuaFile()

SWEP.PrintName = "'Punishment' admin stick"
SWEP.Description = "8===============D."

if CLIENT then
	SWEP.Slot = 1
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 75

	SWEP.HUD3DBone = "v_weapon.xm1014_Bolt"
	SWEP.HUD3DPos = Vector(-3.75, -1, -10)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.022

end

SWEP.ShowWorldModel = true
SWEP.ShowViewModel = true

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "melee2"

SWEP.ViewModel = "models/weapons/melee/v_bat.mdl"
SWEP.WorldModel = "models/weapons/melee/w_bat.mdl"
SWEP.UseHands = true

SWEP.Undroppable 			= true
SWEP.UnGiveable 			= true

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(5, -1.7, 5.4)
			local offsetAng = Angle(180, 90, 0)
			
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

SWEP.Primary.Damage = 99999
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.HeadshotMulti = 1.75
SWEP.ReloadSound = Sound("ambient/machines/thumper_startup1.wav")

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 9

SWEP.ConeMax = 0.25
SWEP.ConeMin = 0.25

SWEP.Recoil = 5

SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.FireAnimSpeed = 0.4

SWEP.TracerName = "tracer_colossus"

SWEP.ReloadSpeed = 1
SWEP.Tier = 5

SWEP.MaxStock = 2
SWEP.Pierces = 3

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_RELOAD_SPEED, 0.032)

function SWEP:ShootBullets(dmg, numbul, cone)
	local owner = self:GetOwner()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	local dir = owner:GetAimVector()
	local dirang = dir:Angle()
	local start = owner:GetShootPos()

	dirang:RotateAroundAxis(dirang:Forward(), util.SharedRandom("bulletrotate1", 0, 360))
	dirang:RotateAroundAxis(dirang:Up(), util.SharedRandom("bulletangle1", -cone, cone))

	dir = dirang:Forward()
	local tr = owner:CompensatedPenetratingMeleeTrace(4092, 0.01, start, dir)
	local ent

	local dmgf = function(i) return dmg * (1 - 0.1 * i) end

	owner:LagCompensation(true)
	for i, trace in ipairs(tr) do
		if not trace.Hit then continue end
		if i > self.Pierces - 1 then break end

		ent = trace.Entity

		if ent and ent:IsValid() then
			owner:FireBulletsLua(trace.HitPos, dir, 0, numbul, dmgf(i-1), nil, self.Primary.KnockbackScale, "", self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
		end
	end
	owner:FireBulletsLua(start, dir, cone, numbul, 0, nil, self.Primary.KnockbackScale, self.TracerName, self.BulletCallback, self.Primary.HullSize, nil, self.Primary.MaxDistance, nil, self)
	owner:LagCompensation(false)
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	local owner = self:GetOwner()
	local vm = owner:GetViewModel()
	local speed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()

	if vm:IsValid() then
		vm:SetPlaybackRate(0.25 * speed)
	end

	self:SetReloadFinish(CurTime() + 2.1 / speed)

	if IsFirstTimePredicted() then
		self:EmitSound("ambient/machines/thumper_startup1.wav", 70, 147, 1, CHAN_WEAPON + 21)
	end
end

function SWEP:MockReload()
	local speed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	self:SetReloadFinish(CurTime() + 2.1 / speed)
end

function SWEP:Reload()
	local owner = self:GetOwner()
	if owner:IsHolding() then return end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end

	if self:CanReload() then
		self:MockReload()
	end
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)

	if self:Clip1() <= 0 then
		self:MockReload()
	end

	return true
end

function SWEP:Think()
	self.BaseClass.Think(self)

	if self:Clip1() <= 0 and self:GetPrimaryAmmoCount() <= 0 then
		self:MockReload()
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
	util.Effect("hit_hunter", effectdata)
end

function SWEP:EmitReloadSound()

end

function SWEP:EmitReloadFinishSound()
end

function SWEP:EmitFireSound()
	self:EmitSound("weapons/m4a1/m4a1_unsil-1.wav", 76, 45, 0.35)
	self:EmitSound("weapons/zs_rail/rail.wav", 76, 100, 0.95, CHAN_WEAPON + 20)
end
