CLASS.Name = "Hunter"
CLASS.TranslationName = "class_hunter"
CLASS.Description = "description_hunter"
CLASS.Help = "controls_hunter"

CLASS.Model = Model("models/player/zombie_classic_hbfix.mdl")
CLASS.OverrideModel = Model("models/Zombie/Poison.mdl")
CLASS.NoGibs = true
CLASS.Wave = 7 / 6
CLASS.Base = "zombie"
CLASS.Unlocked = false
CLASS.IsDefault = false
CLASS.Order = 0
CLASS.Brains = 8
CLASS.Price = 5800
CLASS.NoRebirth = false
CLASS.BetterClass = "Extirpator"
CLASS.UniqueRebirth = true
CLASS.SemiBoss = true
CLASS.Hidden = true
CLASS.Points = 55
CLASS.Revives = false
CLASS.VoicePitch = 0.65
CLASS.ZombieVariants = {}
CLASS.Fundamentals = 30
CLASS.Blueprints = 15
CLASS.Speed = 100
CLASS.Health = 5000
CLASS.SeekLevel = 20
CLASS.RebirthInfo = "A Hunter that has consumed enough human flesh to mutate into this beast. One slash from it can have horrible\nconsequences on humans. Large-unearthly screams can identify its presence on the field."
CLASS.SWEP = "weapon_zs_zombie_hunter"
CLASS.FearPerInstance = 0.5
CLASS.ModelScale = 1.15
CLASS.StopSounds = {"npc/stalker/breathing3.wav","npc/zombie/zombie_pain1.wav","npc/zombie/zombie_pain2.wav","npc/zombie/zombie_pain3.wav","npc/antlion_guard/angry1.wav","npc/antlion_guard/angry2.wav","npc/antlion_guard/angry3.wav","npc/zombie/zombie_pain4.wav","npc/zombie/zombie_pain6.wav","npc/zombie/zombie_pain5.wav"}
local math = math
local math_random = math.random

local GESTURE_SLOT_ATTACK_AND_RELOAD = GESTURE_SLOT_ATTACK_AND_RELOAD

function CLASS:KnockedDown(pl, status, exists)
	pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
end

function CLASS:DoesntGiveFear(pl)
	return IsValid(pl.FeignDeath)
end

function CLASS:AltUse(pl)
end

function CLASS:PlayPainSound(pl)
	if (pl.NextPainSound or 0) > CurTime() then return end
	pl:EmitSound("npc/zombie/zombie_pain"..math_random(6)..".wav", 75, math_random(57, 82))
	pl.NextPainSound = CurTime() + 1.5
	return true
end

function CLASS:IgnoreLegDamage(pl, dmginfo)
	return true
end

local StepSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	pl:EmitSound(StepSounds[math.random(#StepSounds)], 77, 50)
	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	return GAMEMODE.BaseClass.PlayerStepSoundTime(GAMEMODE.BaseClass, pl, iType, bWalking) * 1.8
end

function CLASS:CalcMainActivity(pl, velocity)
	if pl:WaterLevel() >= 3 then
		return ACT_HL2MP_SWIM_PISTOL, -1
	elseif pl:Crouching() then
		if velocity:Length2DSqr() <= 1 then
			return ACT_HL2MP_IDLE_CROUCH_ZOMBIE, -1
		else
			return ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3), -1
		end
	else
		return ACT_HL2MP_WALK_ZOMBIE_02, -1
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local len2d = velocity:Length2D()
	if len2d > 1 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.5 , 3))
	else
		pl:SetPlaybackRate(1 / self.ModelScale)
	end

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, pl:LookupSequence( "zombie_attack_07" ), 0, true)
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_RELOAD then
		pl:AnimRestartGesture(GESTURE_SLOT_GRENADE, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
		return ACT_INVALID
	end
end

if not CLIENT then return end
function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/zombie/zombie_alert1.wav", 75, 90)
	return true
end
local surface = surface
local surface_GetTextureID = surface.GetTextureID
local render_SetColorModulation = render.SetColorModulation

CLASS.HealthBar = surface_GetTextureID("zombiesurvival/healthbar_poisonzombie")
CLASS.Icon = "zombiesurvival/killicons/hunter1_hg"

local render = render
local render_SetColorModulation = render.SetColorModulation
local render_ModelMaterialOverride = render.ModelMaterialOverride

local math = math
local math_random = math.random

local matSkin = Material("Models/Barnacle/barnacle_sheet")
function CLASS:PrePlayerDrawOverrideModel(pl)
	render_ModelMaterialOverride(matSkin)
	render_SetColorModulation(0.35, 0, 0)
end

function CLASS:PostPlayerDrawOverrideModel(pl)
	render_ModelMaterialOverride(nil)
	render_SetColorModulation(1, 1, 1)
end
