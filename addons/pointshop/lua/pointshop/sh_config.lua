PS.Config = {}

-- Edit below

PS.Config.CommunityName = "SRGS ZS"

PS.Config.DataProvider = 'pdata'

PS.Config.Branch = 'https://raw.github.com/adamdburton/pointshop/master/' -- Master is most stable, used for version checking.
PS.Config.CheckVersion = false -- Do you want to be notified when a new version of Pointshop is avaliable?

PS.Config.ShopKey = 'F6' -- Any Uppercase key or blank to disable
PS.Config.ShopCommand = 'PS_OPEN' -- Console command to open the shop, set to blank to disable
PS.Config.ShopChatCommand = '!pointshop' -- Chat command to open the shop, set to blank to disable

PS.Config.NotifyOnJoin = false -- Should players be notified about opening the shop when they spawn?

PS.Config.PointsOverTime = false -- Should players be given points over time?
PS.Config.PointsOverTimeDelay = 1 -- If so, how many minutes apart?
PS.Config.PointsOverTimeAmount = 10 -- And if so, how many points to give after the time?

PS.Config.AdminCanAccessAdminTab = false -- Can Admins access the Admin tab?
PS.Config.SuperAdminCanAccessAdminTab = true -- Can SuperAdmins access the Admin tab?

PS.Config.CanPlayersGivePoints = false -- Can players give points away to other players?
PS.Config.DisplayPreviewInMenu = false -- Can players see the preview of their items in the menu?

PS.Config.PointsName = 'Points' -- What are the points called?
PS.Config.SortItemsBy = 'Price' -- How are items sorted? Set to 'Price' to sort by price.

-- Edit below if you know what you're doing

PS.Config.CalculateBuyPrice = function(ply, item)
	local math = math
	local math_Round = math.Round
	
	return item.Price
end

-- PS.Config.CalculateSellPrice = function(ply, item)
--	return math.Round(item.Price * 0) -- prevent exploits
-- end
