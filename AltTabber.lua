--[[
****************************************************************************************
Alt-Tabber

File date: @file-date-iso@ 
File revision: @file-revision@ 
Project revision: @project-revision@
Project version: @project-version@

Author: Ackis

****************************************************************************************

Please see Wowace.com for more information.

****************************************************************************************
]]

AltTabber 		= LibStub("AceAddon-3.0"):NewAddon("AltTabber", "AceConsole-3.0", "AceEvent-3.0")

local addon = AltTabber

-- Localization
do
	-- enUS stuff
	local L = LibStub("AceLocale-3.0"):NewLocale("AltTabber", "enUS", true)
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

	-- enGB stuff
	local L = LibStub("AceLocale-3.0"):NewLocale("AltTabber", "enGB")
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

	-- deDE stuff
	local L = LibStub("AceLocale-3.0"):NewLocale("AltTabber", "deDE")
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

	-- frFR stuff
	local L = LibStub("AceLocale-3.0"):NewLocale("AltTabber", "frFR")
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

	-- zhCN stuff
	local L = LibStub("AceLocale-3.0"):NewLocale("AltTabber", "zhCN")
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

	-- zhTW stuff
	local L = LibStub("AceLocale-3.0"):NewLocale("AltTabber", "zhTW")
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

	-- koKR stuff
	local L = LibStub("AceLocale-3.0"):NewLocale("AltTabber", "koKR")
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

	-- esES stuff
	local L = LibStub("AceLocale-3.0"):NewLocale("AltTabber", "esES")
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

	-- esMX stuff
	local L = LibStub("AceLocale-3.0"):NewLocale("AltTabber", "esMX")
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

end

local L = LibStub("AceLocale-3.0"):GetLocale("AltTabber", false)

local GetCVar = GetCVar
local PlaySoundFile = PlaySoundFile

function addon:OnInitialize()

	if LibStub:GetLibrary("LibAboutPanel", true) then
		LibStub("LibAboutPanel").new(nil, "AltTabber")
	else
		self:Print("Lib AboutPanel not loaded.")
	end

end

function addon:OnEnable()

	self:RegisterEvent("READY_CHECK")

end

function addon:READY_CHECK()

	-- Abuses a bug? in that PlaySoundFile will still play
	if (GetCVar("Sound_EnableSFX") == "0") then
		if (GetCVar("Sound_EnableSoundWhenGameIsInBG") == "0") then
			self:Print(L["BGSNDON"])
			SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
		end
		--PlaySoundFile("Sound\\interface\\ReadyCheck.wav")
	end
	PlaySoundFile("Sound\\interface\\ReadyCheck.wav")

end
