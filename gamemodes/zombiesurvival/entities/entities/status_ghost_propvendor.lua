AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status_ghost_base"

ENT.GhostModel = Model("models/props/cs_office/vending_machine.mdl")
ENT.GhostRotation = Angle(270, 180, 0)
ENT.GhostPosition = Vector(180, 136, 180)
ENT.GhostEntity = "prop_propvendor"
ENT.GhostWeapon = "weapon_zs_propvendor"
ENT.GhostDistance = 128
ENT.GhostLimitedNormal = 0.75
ENT.GhostHitNormalOffset = 23
