CLASS.Name = "Enigmatic"
CLASS.TranslationName = "class_enigmatic"
CLASS.Description = "description_enigmatic"
CLASS.Help = "controls_enigmatic"

CLASS.Wave = 6 / 6

CLASS.Health = 210
CLASS.Speed = 450

CLASS.CanTaunt = true

CLASS.Points = CLASS.Health/GM.HumanoidZombiePointRatio

CLASS.SWEP = "weapon_zs_enigmatic"

CLASS.Model = Model("models/deathclaw_player/deathclaw_player_proporti.mdl")
--CLASS.OverrideModel = Model("models/Zombie/Poison.mdl")

CLASS.VoicePitch = 0.6

local math_ceil = math.ceil
local math_random = math.random
local math_min = math.min
local CurTime = CurTime
local STEPSOUNDTIME_NORMAL = STEPSOUNDTIME_NORMAL
local STEPSOUNDTIME_WATER_FOOT = STEPSOUNDTIME_WATER_FOOT
local STEPSOUNDTIME_ON_LADDER = STEPSOUNDTIME_ON_LADDER
local STEPSOUNDTIME_WATER_KNEE = STEPSOUNDTIME_WATER_KNEE
local ACT_ZOMBIE_LEAP_START = ACT_ZOMBIE_LEAP_START
local ACT_ZOMBIE_LEAPING = ACT_ZOMBIE_LEAPING
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_ZOMBIE_FAST = ACT_HL2MP_RUN_ZOMBIE_FAST
local ACT_GMOD_GESTURE_TAUNT_ZOMBIE = ACT_GMOD_GESTURE_TAUNT_ZOMBIE
local ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL = ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL
local ACT_HL2MP_RUN_CHARGING = ACT_HL2MP_RUN_CHARGING
local ACT_INVALID = ACT_INVALID

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:DoZombieAttackAnim(data)
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_RELOAD then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
		return ACT_INVALID
	end
end

function CLASS:CalcMainActivity(pl, velocity)

	if pl:WaterLevel() >= 3 then
		return ACT_HL2MP_SWIM_PISTOL, -1
	end

	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsMoaning and wep:IsMoaning() then
		return ACT_HL2MP_RUN_ZOMBIE, -1
	end

	if velocity:Length2DSqr() <= 1 then
		if pl:Crouching() and pl:OnGround() then
			return ACT_HL2MP_IDLE_CROUCH_ZOMBIE, -1
		end

		return ACT_HL2MP_IDLE_ZOMBIE, -1
	end

	if pl:Crouching() and pl:OnGround() then
		return ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math_ceil((CurTime() / 4 + pl:EntIndex()) % 3), -1
	end

	return ACT_HL2MP_WALK_ZOMBIE_01 - 1 + math_ceil((CurTime() / 3 + pl:EntIndex()) % 3), -1
end

function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end

	if mv:GetForwardSpeed() <= 0 then
		mv:SetMaxSpeed(math_min(mv:GetMaxSpeed(), 440))
		mv:SetMaxClientSpeed(math_min(mv:GetMaxClientSpeed(), 440))
	end
end

function CLASS:ScalePlayerDamage(pl, hitgroup, dmginfo)
	return true
end

local GearFoley = {
	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear5.wav",
	"npc/combine_soldier/gear6.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		pl:EmitSound("npc/antlion_guard/foot_heavy1.wav", 70, math_random(120,133), 0.4)
	else
		pl:EmitSound("npc/antlion_guard/foot_heavy2.wav", 70, math_random(120,133), 0.4)
	end
	pl:EmitSound(GearFoley[math_random(#GearFoley)], 70, 100, 0.6)

	return true
end

function CLASS:IgnoreLegDamage(pl, dmginfo)
	return true
end

function CLASS:PlayPainSound(pl)
	pl:EmitSound("npc/fast_zombie/leap1.wav", 75, math_random(70, 80))

	pl.NextPainSound = CurTime() + .5

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/zombie/zombie_die"..math_random(3)..".wav",70, math_random(80,85))

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetCharge and wep:GetCharge() > 0 and (iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT) then
		return 640 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 580 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 400
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 550
	end

	return 250
end

function CLASS:PrePlayerDraw(pl)
	render.SetColorModulation(0.38, 0.38, 0.38)
end

function CLASS:PostPlayerDraw(pl)
	render.SetColorModulation(0.38, 0.38, 0.38)
end
