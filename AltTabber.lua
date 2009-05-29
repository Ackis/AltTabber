--[[

****************************************************************************************
Alt-Tabber

File date: @file-date-iso@ 
Project version: @project-version@

Author: Ackis

****************************************************************************************

]]

local MODNAME	= "AltTabber"

AltTabber		= LibStub("AceAddon-3.0"):NewAddon(MODNAME, "AceConsole-3.0", "AceEvent-3.0")

local addon		= LibStub("AceAddon-3.0"):GetAddon(MODNAME)

-- Localization
do
	-- enUS stuff
	local L = LibStub("AceLocale-3.0"):NewLocale(MODNAME, "enUS", true)

	if not L then return end

	--@localization(locale="enUS", format="lua_additive_table", handle-unlocalized="english", escape-non-ascii=false, same-key-is-true=true)@

	-- deDE stuff
	local L = LibStub("AceLocale-3.0"):NewLocale(MODNAME, "deDE")

	if not L then return end

	--@localization(locale="deDE", format="lua_additive_table", handle-unlocalized="ignore", escape-non-ascii=false, same-key-is-true=true)@

	-- frFR stuff
	local L = LibStub("AceLocale-3.0"):NewLocale(MODNAME, "frFR")

	if not L then return end

	--@localization(locale="frFR", format="lua_additive_table", handle-unlocalized="ignore", escape-non-ascii=false, same-key-is-true=true)@

	-- zhCN stuff
	local L = LibStub("AceLocale-3.0"):NewLocale(MODNAME, "zhCN")

	if not L then return end

	--@localization(locale="zhCN", format="lua_additive_table", handle-unlocalized="ignore", escape-non-ascii=false, same-key-is-true=true)@

	-- zhTW stuff
	local L = LibStub("AceLocale-3.0"):NewLocale(MODNAME, "zhTW")

	if not L then return end

	--@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized="ignore", escape-non-ascii=false, same-key-is-true=true)@

	-- koKR stuff
	local L = LibStub("AceLocale-3.0"):NewLocale(MODNAME, "koKR")
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

	-- esES stuff
	local L = LibStub("AceLocale-3.0"):NewLocale(MODNAME, "esES")
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

	-- esMX stuff
	local L = LibStub("AceLocale-3.0"):NewLocale(MODNAME, "esMX")
	if L then
		L["BGSNDON"] = "Enabling sound in background so you can hear ready checks while alt-tabbed."
	end

end

local L = LibStub("AceLocale-3.0"):GetLocale(MODNAME, false)

local GetCVar = GetCVar
local PlaySoundFile = PlaySoundFile

function addon:OnInitialize()

	if LibStub:GetLibrary("LibAboutPanel", true) then
		LibStub("LibAboutPanel").new(nil, MODNAME)
	else
		self:Print("Lib AboutPanel not loaded.")
	end

end

function addon:OnEnable()

	self:RegisterEvent("READY_CHECK")

end

function addon:READY_CHECK()

	-- Abuses a bug? in that PlaySoundFile will still play
	-- If sound is off, we want to play the readycheck
	if (GetCVar("Sound_EnableSFX") == "0") then
		-- If background sound is on, we can't do anything
		if (GetCVar("Sound_EnableSoundWhenGameIsInBG") == "0") then
			self:Print(L["BGSNDON"])
			-- Change the option to be on
			SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
		else
			PlaySoundFile("Sound\\interface\\ReadyCheck.wav")
		end
	end
end
