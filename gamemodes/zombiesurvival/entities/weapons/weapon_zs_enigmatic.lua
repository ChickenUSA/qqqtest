AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_zombie")
SWEP.PrintName = "Enigmatic nightmare"

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 58
SWEP.ViewModel = "models/weapons/v_pza.mdl"  --SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.ViewModelFOV = 45
SWEP.MeleeReach = 77
SWEP.MeleeForceScaleEntity = 1
SWEP.MeleeDamageType = DMG_ALWAYSGIB
SWEP.MeleeForceScalePlayer = 1
SWEP.MeleeDelay = 0.2


function SWEP:PrimaryAttack()

	BaseClass.PrimaryAttack(self)

	if self:IsSwinging() then 
	end
end

function SWEP:Reload()
if CLIENT then return end
    local owner = self:GetOwner()
	if CurTime() < self:GetNextSecondaryFire() then return end
    self:SetNextSecondaryFire(CurTime() + 5)
    self:GetOwner():EmitSound("npc/combine_gunship/see_enemy.wav", 140, math.random(70,75))
    self:GetOwner():DoAttackEvent(SEQ_SPECIALATTACK)
end

function SWEP:SecondaryAttack()
end

function SWEP:PlayAlertSound()
	self:GetOwner():EmitSound("npc/combine_gunship/see_enemy.wav", 140, math.random(70,75))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayIdleSound()
	self:GetOwner():EmitSound("npc/combine_gunship/see_enemy.wav", 140, math.random(70,75))
end

function SWEP:PlayHitSound()
	self:EmitSound("vehicles/v8/vehicle_impact_heavy"..math.random(4)..".wav", 80, math.random(80, 85))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
local pos = ent:GetPos()
local owner = self:GetOwner()
	if ent:IsPlayer() and ent:Team() == TEAM_HUMAN and not ent.bHasGodMode and ent:Alive() then
		ent:GiveStatus("slow", 4)
		ent:GiveStatus("enfeeble", 4)
		ent:GiveStatus("frightened", 60)
		sound.Play("vo/npc/male01/no0"..math.random(2)..".wav", pos,145, 100)
		ent:KnockDown(1)
		local bleed = ent:GiveStatus("bleed")
		if bleed and bleed:IsValid() then
			bleed:AddDamage(30)
			bleed.Damager = owner
		end
    end
	
	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

if not CLIENT then return end

SWEP.AttackDisplays = {
{
    Name = "Assault",
	Icon = Material("materials/attackicon/claws2.png")
},
{
    bDisabled = true
},
{
	Name = "Howl",
	Icon = Material("materials/attackicon/scream.png")
},
{
    bDisabled = true
}
}

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
	render.SetColorModulation(1, 1, 1)
end

function SWEP:PreDrawViewModel(vm)
	render.SetColorModulation(0.1, 0.1, 0.1)
end
