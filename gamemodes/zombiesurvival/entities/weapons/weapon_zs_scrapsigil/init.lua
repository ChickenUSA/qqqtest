INC_SERVER()

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self:GetOwner(), self)

	self:SpawnGhost()

	return true
end

function SWEP:OnRemove()
	self:RemoveGhost()
end

function SWEP:Holster()
	self:RemoveGhost()
	return true
end

function SWEP:SpawnGhost()
	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		owner:GiveStatus("ghost_sigil")
	end
end

function SWEP:RemoveGhost()
	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		owner:RemoveStatus("ghost_sigil", false, true)
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local owner = self:GetOwner()
	
	if GAMEMODE:NumSigils() >= 6 then
		GAMEMODE:ConCommandErrorMessage(owner, translate.ClientGet(owner, "too_many_sigils"))
		return
	end
	
	if owner.zlisted then
		owner:PrintTranslatedMessage(HUD_PRINTCENTER, "you_are_zlisted")
		return
	end
	
	local status = owner.status_ghost_sigil
	if not (status and status:IsValid()) then return end
	status:RecalculateValidity()
	if not status:GetValidPlacement() then return end

	local pos, ang = status:RecalculateValidity()
	if not pos or not ang then return end

	self:SetNextPrimaryAttack(CurTime() + self.Primary.Delay)

	local ent = ents.Create("prop_obj_sigil")
	owner:StripWeapon("weapon_zs_scrapsigil")
	if ent:IsValid() then
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:Spawn()

		ent:EmitSound("npc/dog/dog_servo12.wav")

		ent:GhostAllPlayersInMe(5)

		--self:TakePrimaryAmmo(1)
		owner:StripWeapon("weapon_zs_scrapsigil")

		local stored = owner:PopPackedItem(ent:GetClass())
		if stored then
			ent:SetObjectHealth(stored[1])
		end
--[[
		if self:GetPrimaryAmmoCount() <= 0 then
			owner:StripWeapon(self:GetClass())
		end
--]]
	end
end

function SWEP:Think()
	local count = self:GetPrimaryAmmoCount()
	if count ~= self:GetReplicatedAmmo() then
		self:SetReplicatedAmmo(count)
		self:GetOwner():ResetSpeed()
	end
end
