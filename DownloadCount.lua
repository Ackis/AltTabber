--[[
****************************************************************************************
AckisRecipeList Download Count
$Date$
$Rev$

Author: Ackis on Illidan US Horde

****************************************************************************************

Require socket.  You can get it from: http://luaforge.net/projects/luasocket/

This is not to be run in WoW.  It will query all of the release sites and obtain download information for
Ackis Recipe List

****************************************************************************************
]]--


http = require("socket.http")

function GetCurseDownloads()
	local addonurl = "http://www.curse.com/downloads/details/12774"
	local patternmatch = "<td>(%d%d%d)</td>"

	local _,_,temp = string.find(http.request(addonurl), patternmatch)

	local numberdownloads = string.gsub(temp,",","")

	return numberdownloads
end

function GetWoWUIDownloads()
	local addonurl = "http://wowui.worldofwar.net/?p=mod&m=6460"
	local patternmatch = "<b>(%d%d%d)</b> total downloads</b>"

	local _,_,temp = string.find(http.request(addonurl), patternmatch)

	local numberdownloads = string.gsub(temp,",","")

	return numberdownloads
end

function GetWoWIDownloads()
	local addonurl = "http://www.wowinterface.com/downloads/info9197-AltTabber.html"
	local patternmatch = "<td class=\"alt1\"><div class=\"smallfont\">(%d%d)</div></td>"

	local _,_,temp = string.find(http.request(addonurl), patternmatch)

	local numberdownloads = string.gsub(temp,",","")

	return numberdownloads
end

do
	local curse = GetCurseDownloads()
	local WoWUI = GetWoWUIDownloads()
	local WoWI = GetWoWIDownloads()

	print("Downloads by site:")
	print("Curse: " .. curse)
	print("WoWUI: " .. WoWUI)
	print("WoWI: " .. WoWI)
	print("Total: " .. curse + WoWUI + WoWI)

	--os.execute("pause")

end
