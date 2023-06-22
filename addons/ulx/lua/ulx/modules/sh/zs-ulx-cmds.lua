local category = GetGlobalString( "zs-ulx-cmds_category", "Zombie Survival" )


-- save the player's position and return a function that restores it
local function SavePlayerPositon( player )
	local pos, vel, ang = player:GetPos(), player:GetVelocity(), player:EyeAngles()

	return function()
		player:SetPos( pos )
		player:SetEyeAngles( ang )

		timer.Simple( 0, function() player:SetVelocity( vel ) end )
	end
end

function ulx.restartmap(calling_ply)
	ulx.fancyLogAdmin( calling_ply, "#A restarted the map.")
	game.ConsoleCommand("changelevel "..string.format(game.GetMap(),".bsp").."\n")
end
local restartmap = ulx.command(CATEGORY_NAME, "ulx restartmap", ulx.restartmap, "!restartmap")
restartmap:defaultAccess( ULib.ACCESS_SUPERADMIN )
restartmap:help( "Reloads the level." )

function ulx.redeem( caller, targets, inPlace )
	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team() == TEAM_UNDEAD then
			local restorePos = SavePlayerPositon( target )

			local lastSpawned = target.SpawnedTime

			target:Redeem()

			-- Redeem will update SpawnedTime if it succeeded
			if lastSpawned ~= target.SpawnedTime then
				table.insert( affected, target )

				if inPlace then restorePos() end
			end
		else
			ULib.tsayError( caller, target:Nick() .. " isn't a zombie!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A redeemed #T", affected )
end

local redeem = ulx.command( category, "ulx redeem", ulx.redeem, "!redeem" )
redeem:addParam{ type = ULib.cmds.PlayersArg }
redeem:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "respawn in place", ULib.cmds.optional }
redeem:defaultAccess( ULib.ACCESS_ADMIN )
redeem:help( "Redeem target(s)" )

function ulx.human( caller )

	local sigils = GAMEMODE:GetSigils()
	local validSig = false
	for _, sig in pairs(sigils) do
		if sig and sig:IsValid() and not sig:GetSigilCorrupted() then
			validSig = true
			break
		end
	end

	if not validSig then
		ULib.tsayError(caller, " There are no uncorrupted sigils left ", true )
		return
	end

	local lastSpawned = caller.selfRedeemTime
	
	if GAMEMODE:GetWave() >= 6 then
		ULib.tsayError(caller, " You cannot redeem past wave 5 ", true )
		return
	end

	if lastSpawned and  CurTime() - lastSpawned < 30 then
		ULib.tsayError(caller, " You must wait 30 seconds between respawns ", true )
		return
	end



	if caller:Team() == TEAM_UNDEAD then
		local restorePos = SavePlayerPositon( caller )

		caller.selfRedeemTime = CurTime()

		caller:Redeem()

	else
		ULib.tsayError(caller, " you aren't a zombie!", true )
	end
	--ulx.fancyLogAdmin( caller, "#A redeemed", affected )
end

local human = ulx.command( category, "ulx human", ulx.human, "!human" )
human:addParam{ type = ULib.cmds.PlayersArg,  ULib.cmds.optional  }
human:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "respawn in place", ULib.cmds.optional }
human:defaultAccess( ULib.ACCESS_ADMIN )
human:help( "Redeem target(s)" )

function ulx.forceboss( caller, targets, inPlace, silent )
	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team() == TEAM_UNDEAD then
			local restorePos = SavePlayerPositon( target )

			gamemode.Call( "SpawnBossZombie", target, silent )

			if inPlace then restorePos() end

			table.insert( affected, target )
		else
			ULib.tsayError( caller, target:Nick() .. " isn't a zombie!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A forced #T to be boss", affected )
end

local forceboss = ulx.command( category, "ulx forceboss", ulx.forceboss, "!forceboss" )
forceboss:addParam{ type = ULib.cmds.PlayersArg }
forceboss:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "respawn in place", ULib.cmds.optional }
forceboss:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "silent", ULib.cmds.optional }
forceboss:defaultAccess( ULib.ACCESS_ADMIN )
forceboss:help( "Respawn target(s) as boss" )

function ulx.zlist( calling_ply, target_plys )
	local affected_plys = {}

	for i=1, #target_plys do
		local v = target_plys[ i ]

		if ulx.getExclusive( v, calling_ply ) then
			ULib.tsayError( calling_ply, ulx.getExclusive( v, calling_ply ), true )
		elseif v.zlisted then
			ULib.tsayError( calling_ply, v:Nick() .. " is already zlisted!", true )
		else
			v.zlisted = true
			table.insert( affected_plys, v )
		end
	end

	ulx.fancyLogAdmin( calling_ply, "#A zlisted #T", affected_plys )
end
local zlist = ulx.command( CATEGORY_NAME, "ulx zlist", ulx.zlist, "!zlist" )
zlist:addParam{ type=ULib.cmds.PlayersArg }
zlist:defaultAccess( ULib.ACCESS_ADMIN )
zlist:help( "Zlists target(s)." )

function ulx.unzlist( calling_ply, target_plys )
	local affected_plys = {}

	for i=1, #target_plys do
		local v = target_plys[ i ]

		if ulx.getExclusive( v, calling_ply ) then
			ULib.tsayError( calling_ply, ulx.getExclusive( v, calling_ply ), true )
		elseif not v.zlisted then
			ULib.tsayError( calling_ply, v:Nick() .. " is not zlisted!", true )
		else
			v.zlisted = false
			table.insert( affected_plys, v )
		end
	end

	ulx.fancyLogAdmin( calling_ply, "#A unzlisted #T", affected_plys )
end
local unzlist = ulx.command( CATEGORY_NAME, "ulx unzlist", ulx.unzlist, "!unzlist" )
unzlist:addParam{ type=ULib.cmds.PlayersArg }
unzlist:defaultAccess( ULib.ACCESS_ADMIN )
unzlist:help( "UnZlists target(s)." )


function ulx.zspawn( calling_ply)
	if not calling_ply:IsValid() then
		Msg( "You are the console, you can't create a ZSpawn since you can't see the world!\n" )
		return
	end

	local pos = calling_ply:WorldSpaceCenter()
	local ang = calling_ply:EyeAngles()
	ang.pitch = 0
	ang.roll = 0
	local forward = ang:Forward()
	local right = ang:Right()
	local endpos = pos + forward * 32

	local tr = util.TraceLine({start = pos, endpos = endpos, filter = allzombies, mask = MASK_PLAYERSOLID})
	local hitnormal = tr.HitNormal
	local hitpos = tr.HitPos
	local uid = calling_ply:UniqueID()
	
	local ent = ents.Create("prop_creepernest")
	if ent:IsValid() then
		local nestang = hitnormal:Angle()
		--nestang:RotateAroundAxis(nestang:Right(), 270)

		ent:SetPos(hitpos)
		ent:SetAngles(nestang)
		ent:DropToFloor()
		ent:Spawn()

		ent.OwnerUID = uid
		ent:SetNestHealth(ent:GetNestMaxHealth())
		ent:SetNestBuilt(true)

		ent:SetNestOwner(calling_ply)

	end
	ent:SetNestBuilt(true)


	--if target_plyn then
		--ulx.fancyLogAdmin( calling_ply, "#A created a ZSpawn") -- We don't want to log otherwise
	--end

	ulx.fancyLogAdmin( calling_ply, "#A created a zombie spawn", caller )

end
local zspawn = ulx.command( CATEGORY_NAME, "ulx zspawn", ulx.zspawn, "!zspawn" )
zspawn:defaultAccess( ULib.ACCESS_ADMIN )
zspawn:help( "Creates ZSpawn" )


function ulx.forceclass( caller, targets, className, inPlace )
	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team() == TEAM_UNDEAD then
			local restorePos = SavePlayerPositon( target )

			-- set zombie class and respawn
			target:SetZombieClassName( className )
			target:UnSpectateAndSpawn()

			if inPlace then restorePos() end

			table.insert( affected, target )
		else
			ULib.tsayError( caller, target:Nick() .. " isn't a zombie!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A forced #T to be #s", affected, className )
end


local TeamLookup = { zombies = TEAM_UNDEAD, humans = TEAM_SURVIVOR }
function ulx.forceteam( caller, targets, teamName )
	local affected = {}

	local teamIndex = TeamLookup[ teamName ]
	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team() ~= teamIndex then
			target:SetTeam( teamIndex )

			table.insert( affected, target )
		end
	end

	ulx.fancyLogAdmin( caller, "#A made #T join #s", affected, team.GetName( teamIndex ) )
end

local forceteam = ulx.command( category, "ulx forceteam", ulx.forceteam, "!forceteam" )
forceteam:addParam{ type = ULib.cmds.PlayersArg }
forceteam:addParam{ type = ULib.cmds.StringArg, hint = "team name", completes = { "zombies", "humans" }, ULib.cmds.restrictToCompletes }
forceteam:defaultAccess( ULib.ACCESS_ADMIN )
forceteam:help( "Make target(s) join the specified team without respawning" )


function ulx.respawn( caller, targets, inPlace, asTeam )
	asTeam = asTeam ~= "" and asTeam or nil

	local teamIndex = TeamLookup[ asTeam ]
	for i = 1, #targets do
		local target = targets[ i ]

		local restorePos = SavePlayerPositon( target )

		if asTeam and target:Team() ~= teamIndex then
			target:SetTeam( teamIndex )
		end

		target:UnSpectateAndSpawn()
		-- DoHulls isn't called for humans
		target:DoHulls()

		if inPlace then restorePos() end
	end

	ulx.fancyLogAdmin( caller, "#A respawned #T" .. ( asTeam and " as #s" or "" ), targets, team.GetName( teamIndex ) )
end

local respawn = ulx.command( category, "ulx respawn", ulx.respawn, "!respawn" )
respawn:addParam{ type = ULib.cmds.PlayersArg }
respawn:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "respawn in place", ULib.cmds.optional }
respawn:addParam{ type = ULib.cmds.StringArg, hint = "as team", completes = { "zombies", "humans" }, ULib.cmds.restrictToCompletes, ULib.cmds.optional }
respawn:defaultAccess( ULib.ACCESS_ADMIN )
respawn:help( "Respawn target(s)" )


function ulx.waveactive( caller, active )
	if active ~= gamemode.Call( "GetWaveActive" ) then
		gamemode.Call( "SetWaveActive", active )

		ulx.fancyLogAdmin( caller, "#A #s the wave", active and "started" or "ended" )
	end
end

local waveactive = ulx.command( category, "ulx waveactive", ulx.waveactive, "!waveactive" )
waveactive:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "active" }
waveactive:defaultAccess( ULib.ACCESS_ADMIN )
waveactive:help( "Start or end the wave" )


function ulx.wavetime( caller, time )
	time = time * 60

	if time > 0 then
		gamemode.Call(
			gamemode.Call( "GetWaveActive" ) and "SetWaveEnd" or "SetWaveStart",
			CurTime() + time
		);

		ulx.fancyLogAdmin( caller, "#A set time until wave start/end to #s", ULib.secondsToStringTime( time ) )
	else
		local active = not gamemode.Call( "GetWaveActive" )
		gamemode.Call( "SetWaveActive", active )

		ulx.fancyLogAdmin( caller, "#A #s the wave", active and "started" or "ended" )
	end
end

local wavetime = ulx.command( category, "ulx wavetime", ulx.wavetime, "!wavetime" )
wavetime:addParam{ type = ULib.cmds.NumArg, hint = "time (0 starts/ends wave)", max = 60, ULib.cmds.allowTimeString }
wavetime:defaultAccess( ULib.ACCESS_ADMIN )
wavetime:help( "Set time until wave start/end" )

function ulx.giveweapon( caller, targets, weapon, giveAmmo )
	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Alive() then
			target:Give( weapon, not giveAmmo )

			table.insert( affected, target )
		else
			ULib.tsayError( caller, target:Nick() .. " is dead!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A gave #s to #T", weapon, targets )
end

local AmmoLookup = {}

do
	local GAMEMODE = gmod.GetGamemode()
	if GAMEMODE and GAMEMODE.AmmoNames then
		for class, name in pairs( GAMEMODE.AmmoNames ) do
			AmmoLookup[ name ] = class
		end
	end
end

-- these commands depend on data that doesn't exist until the gamemode is fully loaded
hook.Add( "Initialize", "zs_ulx_cmds",
	function()
		local GAMEMODE = gmod.GetGamemode()

		TeamLookup = { zombies = TEAM_UNDEAD, humans = TEAM_SURVIVOR }

		local forceclassCompletes
		if GAMEMODE.ZombieClasses then
			forceclassCompletes = {}

			for k in pairs( GAMEMODE.ZombieClasses ) do
				if isstring( k ) then
					table.insert( forceclassCompletes, k )
				end
			end
		end

		local forceclass = ulx.command( category, "ulx forceclass", ulx.forceclass, "!forceclass" )
		forceclass:addParam{ type = ULib.cmds.PlayersArg }
		forceclass:addParam{ type = ULib.cmds.StringArg, hint = "class", completes = forceclassCompletes, ULib.cmds.restrictToCompletes }
		forceclass:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "respawn in place", ULib.cmds.optional }
		forceclass:defaultAccess( ULib.ACCESS_ADMIN )
		forceclass:help( "Respawn target(s) as the specified class" )


		local weaponClasses = {}
		for _, tbl in pairs( weapons.GetList() ) do
			table.insert( weaponClasses, tbl.ClassName )
		end

		local giveweapon = ulx.command( category, "ulx giveweapon", ulx.giveweapon, "!giveweapon" )
		giveweapon:addParam{ type = ULib.cmds.PlayersArg }
		giveweapon:addParam{ type = ULib.cmds.StringArg, hint = "weapon class name", completes = weaponClasses, ULib.cmds.restrictToCompletes }
		giveweapon:addParam{ type = ULib.cmds.BoolArg, default = true, hint = "give ammo", ULib.cmds.optional }
		giveweapon:defaultAccess( ULib.ACCESS_ADMIN )
		giveweapon:help( "Give weapon to target(s)" )


		local ammoClasses = {}
		if GAMEMODE.AmmoNames then
			for class, name in pairs( GAMEMODE.AmmoNames ) do
				AmmoLookup[ name ] = class
				table.insert( ammoClasses, name )
			end
		end
	end
)
