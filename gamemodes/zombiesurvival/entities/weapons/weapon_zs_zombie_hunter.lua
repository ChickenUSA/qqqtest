AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_zombie")
SWEP.PrintName = "Hunter"

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 18
SWEP.BleedDamageMul = 0.5
SWEP.MeleeDamageVsProps = 30
SWEP.MeleeDamageType = DMG_ALWAYSGIB
SWEP.MeleeForceScalePlayer = -2
SWEP.AlertDelay = 2.75
SWEP.MovementFreezeTime = 0
SWEP.SwingCount = 1
SWEP.MultiAttackDelay = 0.75
SWEP.MultiSwingCount = 1
SWEP.MeleeDelay = 0.2
SWEP.DeathType = "gibbed"
SWEP.ForceRuin = true

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:PlayAttackSound()
	self:GetOwner():EmitSound("npc/antlion_guard/angry"..math.random(3)..".wav", 75, math.random(115, 135))
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/zombie/zombie_alert"..math.random(3)..".wav", 70, math.random(87, 92))
end

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("npc/stalker/breathing3.wav", 70, 115)
end

AccessorFuncDT(SWEP, "MovementFreeze", "Float", 3)
AccessorFuncDT(SWEP, "MultiAttackTime", "Float", 4)

function SWEP:Swung()
	local owner = self:GetOwner()
	if SERVER then
		local hit = false
		local traces = owner:CompensatedZombieMeleeTrace(self.MeleeReach * (owner.ZombieRangeMultiplier or 1), self.MeleeSize)
		local prehit = self.PreHit
		if prehit then
			local ins = true
			for _, tr in pairs(traces) do
				if tr.HitNonWorld then
					ins = false
					break
				end
			end
			if ins then
				local eyepos = owner:EyePos()
				if prehit.Entity:IsValid() and prehit.Entity:NearestPoint(eyepos):DistToSqr(eyepos) <= self.MeleeReach * self.MeleeReach then
					table.insert(traces, prehit)
				end
			end
			self.PreHit = nil
		end

		local damage = self:GetDamage(self:GetTracesNumPlayers(traces))
		local effectdata = EffectData()
		local ent

		for _, trace in ipairs(traces) do
			ent = trace.Entity
			hit = true

			if trace.HitWorld then
				self:MeleeHitWorld(trace)
			elseif ent and ent:IsValid() then
				self:MeleeHit(ent, trace, damage)
			end

			--util.ImpactTrace(nil, trace, self.MeleeDamageType)
		end

		if hit then
			self:PlayHitSound()
		else
			self:PlayMissSound()
		end
	end
end

function SWEP:PrimaryAttack()
	self.MultiSwingCount = 0

	BaseClass.PrimaryAttack(self)

	self:SetMovementFreeze(CurTime() + self.MovementFreezeTime)
	self:SetMultiAttackTime(CurTime() + self.MultiAttackDelay)
end

function SWEP:MeleeHit(ent, trace, damage, forcescale)
	if not ent:IsPlayer() then
		damage = self.MeleeDamageVsProps
	end

	local owner = self:GetOwner()
	self.BaseClass.MeleeHit(self, ent, trace, damage, forcescale)
end

function SWEP:PlayHitSound()
	self:GetOwner():EmitSound("ambient/machines/slicer"..math.random(4)..".wav", 100, 120)
end

function SWEP:Think()
	if self:GetMovementFreeze() ~= 0 and self:GetMovementFreeze() < CurTime() then
		if self.FrozenWhileSwinging then
			self:GetOwner():ResetSpeed()
		end

		self:SetMovementFreeze(0)
	end

	if self:GetMultiAttackTime() ~= 0 and self:GetMultiAttackTime() < CurTime() and self.MultiSwingCount < self.SwingCount then
		self.MultiSwingCount = self.MultiSwingCount + 1
		self:Swung()
		self:SetMultiAttackTime(CurTime() + self.MultiAttackDelay)
	end

	self:CheckMeleeAttack()
	self:CheckIdleAnimation()
end

function SWEP:CheckIdleAnimation()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:Deploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	BaseClass.Deploy(self)
	return true
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if SERVER and ent:IsPlayer() and ent:Team() == TEAM_HUMAN and not ent.IsRoasterRock then
		local bleed = ent:GiveStatus("bleed")
		if bleed and bleed:IsValid() then
			bleed:AddDamage(10,self:GetOwner())
		end
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

hook.Add("DoPlayerDeath", "HunterKill", function(pl, attacker, dmginfo)
	if pl:Team() == TEAM_HUMAN then
	if attacker:IsValid() and attacker:IsPlayer() then
		local attackerwep = attacker:GetActiveWeapon()
		if IsValid(attackerwep) and attackerwep:GetClass() == "weapon_zs_zombie_hunter" then
				attacker:GiveStatus("zombie_battlecry", 5)
				pl:EmitSound("physics/flesh/flesh_bloody_break.wav")
				pl:EmitSound("physics/body/body_medium_break2.wav")
				attacker:SetHealth(attacker:Health() + 150)
				attacker:SetArmor(attacker:Armor() + 50)
				attacker:EmitSound("npc/headcrab_poison/ph_poisonbite3.wav", 70, 46)
				attacker:EmitSound("npc/stalker/breathing3.wav", 70, 115)
			end
		end
	end
end)

if not CLIENT then return end

SWEP.AttackDisplays = {}
SWEP.AttackDisplays[3] = {bDisabled = true}
SWEP.AttackDisplays[4] = {bDisabled = true}

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
	render.SetColorModulation(1, 1, 1)
end

local matSheet = Material("Models/humans/corpse/corpse1.vtf")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
	render.SetColorModulation(0.9, 0, 0)
end