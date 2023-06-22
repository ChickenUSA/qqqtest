if SERVER then
	util.AddNetworkString("zs_damage_number")
	hook.Add("PostEntityTakeDamage", "PostEntityTakeDamage.HitNumbers", function(ent, dmginfo, tookdmg)
		if IsValid(ent) and ent:IsPlayer() then
			local attacker = dmginfo:GetAttacker()
			if IsValid(attacker) and attacker:IsPlayer() and ent ~= attacker then
				local dmg = dmginfo:GetDamage()
				net.Start("zs_damage_number")
				net.WriteUInt(math.ceil(dmg), 14)
				net.Send(attacker)
			end
		end
	end)
end

if CLIENT then
	local playertotaldamage = 0
	local playerdamage = 0
	local curtime = CurTime()
	local DPS = 0
	local lasthit = 0

	local function hudNum()
		if playertotaldamage > 0 and GAMEMODE.DamageHUD2D then
			local y = ScrW() * 0.3
			surface.SetFont("ZSHUDFontSmall")
			surface.SetTextPos(15,y)
			surface.SetTextColor(255, 255, 255)
		    surface.DrawText("Player damage: "..tostring(playertotaldamage))

		    if curtime - CurTime() <= 0 then
		    	DPS = playerdamage
		    	curtime = CurTime() + 3
		    	playerdamage = 0

		    	if lasthit == playertotaldamage then
		    		playertotaldamage = 0
		    	end

		    	lasthit = playertotaldamage
		    end

		    surface.SetFont("ZSHUDFontSmall")
			surface.SetTextPos(15,y - 30)
			surface.SetTextColor(255, 255, 255)
		    surface.DrawText("DPS: "..tostring(math.floor(DPS))*0.33)
		end
	end

	net.Receive("zs_damage_number", function(Length)
		local dmg = net.ReadUInt(14)
		playerdamage = playerdamage + dmg
		playertotaldamage = playertotaldamage + dmg
		hook.Add("HUDPaint", "2dhuddmg", hudNum)
	end)
end