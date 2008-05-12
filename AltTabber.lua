--[[
****************************************************************************************
Alt-Tabber
$Date$
$Rev$

Author: Ackis on Illidan US Horde
****************************************************************************************
]]

AltTabber = LibStub("AceAddon-3.0"):NewAddon("AltTabber", "AceConsole-3.0", "AceEvent-3.0")

local addon = AltTabber
local AceConfig = LibStub("AceConfig-3.0")
local GetCVar = GetCVar
local PlaySoundFile = PlaySoundFile

function addon:OnInitialize()

end

function addon:OnEnable()

	self:RegisterEvent("READY_CHECK")

end

function addon:READY_CHECK()

	-- Abuses a bug? in that PlaySoundFile will still play
	if (GetCVar("Sound_EnableSFX") == "0") then
		if (GetCVar("Sound_EnableSoundWhenGameIsInBG") == "0") then
			self:Print("Enabling sound in background so you can hear ready checks while alt-tabbed.")
			SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
		end
		PlaySoundFile("Sound\\interface\\ReadyCheck.wav")
	end

end
