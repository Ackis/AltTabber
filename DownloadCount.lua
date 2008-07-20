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
	local patternmatch1 = "<th>Downloads Total:</th>\n                                            <td>(%d+,%d+)</td>"
	local patternmatch2 = "<th>Downloads Total:</th>\n                                            <td>(%d+)</td>"

	local _,_,temp = string.find(http.request(addonurl), patternmatch1)
	local _,_,temp1 = string.find(http.request(addonurl), patternmatch2)

	local numberdownloads

	if (temp) then
		local numberdownloads = string.gsub(temp,",","")
		return numberdownloads
	else
		return temp1
	end

end

function GetWoWUIDownloads()

	local addonurl = "http://wowui.worldofwar.net/?p=mod&m=6460"
	local patternmatch1 = "<b>(%d+,%d+)</b> total downloads</b>"
	local patternmatch2 = "<b>(%d+)</b> total downloads</b>"

	local _,_,temp = string.find(http.request(addonurl), patternmatch1)
	local _,_,temp1 = string.find(http.request(addonurl), patternmatch2)

	local numberdownloads

	if (temp) then
		local numberdownloads = string.gsub(temp,",","")
		return numberdownloads
	else
		return temp1
	end

end

function GetWoWIDownloads()

	local addonurl = "http://www.wowinterface.com/downloads/info9197-AltTabber.html"
	local patternmatch1 = "<td class=\"alt1\"><div class=\"smallfont\">(%d+,%d+)</div></td>"
	local patternmatch2 = "<td class=\"alt1\"><div class=\"smallfont\">(%d+)</div></td>"

	local _,_,temp = string.find(http.request(addonurl), patternmatch1)
	local _,_,temp1 = string.find(http.request(addonurl), patternmatch2)

	local numberdownloads

	if (temp) then
		local numberdownloads = string.gsub(temp,",","")
		return numberdownloads
	else
		return temp1
	end

end

do
	local curse = GetCurseDownloads()
	local WoWUI = GetWoWUIDownloads()
	local WoWI = GetWoWIDownloads()

	print("Downloads by site:")
	print("Curse Gaming:   " .. curse)
	print("WoW UI:         " .. WoWUI)
	print("WoW Interface:  " .. WoWI)
	print("--------------------")
	print("Total: " .. curse + WoWUI + WoWI)

	--os.execute("pause")

end
