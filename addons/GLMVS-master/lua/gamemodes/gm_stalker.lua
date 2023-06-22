local GAME = {}

GAME.ID			= "stalker"
GAME.Name		= "The Stalker"
GAME.MapPrefix	= {"ts"}
GAME.MapFileDB	= "map_stalker.txt"

GAME.HookRound	= "LoadNextMap"

function GAME:OnInitialize()
	function GAMEMODE:LoadNextMap() return end
end

function GAME:GetEndTime()
	return 30
end

function GAME:GetPlayerVote( pl )
	return math.ceil( pl:Frags() * 1.5 )
end

function GAME:OnStartVote()
	timer.Simple( self:GetEndTime(), GLMVS_EndVote )
end

GLoader.RegisterGamemode( GAME )