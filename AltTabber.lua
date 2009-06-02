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
local AL3		= LibStub("AceLocale-3.0")

local L = AL3:GetLocale(MODNAME, false)

local GetCVar = GetCVar
local SetCVar = SetCVar
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

	--@alpha@
	self:RegisterEvent("CVAR_UPDATED")
	self:RegisterEvent("CVAR_UPDATE")
	self:RegisterEvent("PVPQUEUE_ANYWHERE_UPDATE_AVAILABLE")
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
	--@end-alpha@

end

--@alpha@

function addon:PVPQUEUE_ANYWHERE_UPDATE_AVAILABLE()
	self:Print("PVPQUEUE_ANYWHERE_UPDATE_AVAILABLE")
end

function addon:UPDATE_BATTLEFIELD_STATUS()
	self:Print("UPDATE_BATTLEFIELD_STATUS")
end

function addon:CVAR_UPDATE()

	self:Print("CVAR_UPDATE")
	self:Print("Sound_EnableAllSound " .. GetCVar("Sound_EnableAllSound"))
	self:Print("Sound_EnableSFX " .. GetCVar("Sound_EnableSFX"))
	self:Print("Sound_EnableSoundWhenGameIsInBG " .. GetCVar("Sound_EnableSoundWhenGameIsInBG"))

end

function addon:CVAR_UPDATED()

	self:Print("CVAR_UPDATED")
	self:Print("Sound_EnableAllSound " .. GetCVar("Sound_EnableAllSound"))
	self:Print("Sound_EnableSFX " .. GetCVar("Sound_EnableSFX"))
	self:Print("Sound_EnableSoundWhenGameIsInBG " .. GetCVar("Sound_EnableSoundWhenGameIsInBG"))

end

--@end-alpha@

function addon:READY_CHECK()

	local Sound_EnableSFX = GetCVar("Sound_EnableSFX")
	local Sound_EnableAllSound = GetCVar("Sound_EnableAllSound")

	-- Abuses a bug? in that PlaySoundFile will still play
	-- If sound is off, we want to play the readycheck
	if (Sound_EnableSFX == "0") then
		-- If background sound is on, we can't do anything
		if (GetCVar("Sound_EnableSoundWhenGameIsInBG") == "0") then
			self:Print(L["BGSNDON"])
			SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
		-- If the entire sound processing is off, we can't deal with it
		elseif (Sound_EnableAllSound == "0") then
			self:Print(L["ENABLESOUNDSYSTEM"])
			SetCVar("Sound_EnableAllSound","1")
			-- Disable all the other types of sounds
			SetCVar("Sound_EnableSFX","0")
			SetCVar("Sound_EnableAmbience","0")
			SetCVar("Sound_EnableMusic","0")
		-- We just have sound off so we can play it
		else
			PlaySoundFile("Sound\\interface\\ReadyCheck.wav")
		end
	end

end
