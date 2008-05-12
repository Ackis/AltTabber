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


function addon:OnInitialize()

end

function addon:OnEnable()

	self:RegisterEvent("READY_CHECK")

end

function addon:READY_CHECK()

	-- Abuses a bug? in that PlaySoundFile will still play
	if (GetCVar("Sound_EnableSFX") == "0") then
		PlaySoundFile("Sound\\interface\\ReadyCheck.wav")
	end

end
