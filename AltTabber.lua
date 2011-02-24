--[[

****************************************************************************************
Alt-Tabber

File date: @file-date-iso@ 
Project version: @project-version@

Author: Ackis

****************************************************************************************

]]

local MODNAME	= "AltTabber"

AltTabber		= LibStub("AceAddon-3.0"):NewAddon(MODNAME, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

local addon		= LibStub("AceAddon-3.0"):GetAddon(MODNAME)
local AL3		= LibStub("AceLocale-3.0")

local L = AL3:GetLocale(MODNAME, false)

local GetCVar = GetCVar
local SetCVar = SetCVar
local PlaySoundFile = PlaySoundFile

-------------------------------------------------------------------------------
-- Check to see if we have mandatory libraries loaded. If not, notify the user
-- which are missing and return.
-------------------------------------------------------------------------------
local MissingLibraries
do
	local REQUIRED_LIBS = {
		"AceLocale-3.0",
		"AceEvent-3.0",
		"AceConsole-3.0",
		"AceHook-3.0",
	}
	function MissingLibraries()
		local missing = false

		for idx, lib in ipairs(REQUIRED_LIBS) do
			if not LibStub:GetLibrary(lib, true) then
				missing = true
				addon:Print(strformat(L["MISSING_LIBRARY"], lib))
			end
		end
		return missing
	end
end -- do

if MissingLibraries() then
	--@debug@
	addon:Print("You are using a development version of Alt-Tabber.  As per WowAce standards, externals are not set up.  You will have to install all necessary libraries in order for the addon to function correctly.")
	--@end-debug@
	_G.AltTabber = nil
	return
end

function addon:OnInitialize()

end

local function PlayPVPSound()
	PlaySoundFile("Sound\\Spells\\PVPEnterQueue.wav", "Master")
end

function addon:OnEnable()

	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("LFG_PROPOSAL_SHOW")
	self:RegisterEvent("BATTLEFIELD_MGR_ENTRY_INVITE") -- World PVP (Tol Barad, WG)

	-- Hook each battleground queue so that it plays a sound when the pop-up shows up.
	-- This will play a sound for when the BG queue pops for you
	-- Code should also work when new battlegrounds are added
	for index = 1, NUM_DISPLAYED_BATTLEGROUNDS do
		local frame = _G["PVPHonorFrameBgButton"..index]
		self:HookScript(frame, "OnShow", PlayPVPSound)
	end

--[[
	-- If the Battlefield Entry doesn't have an onshow, create one.
	if (not StaticPopupDialogs["CONFIRM_BATTLEFIELD_ENTRY"].OnShow) then
		StaticPopupDialogs["CONFIRM_BATTLEFIELD_ENTRY"].OnShow = function()
			PlaySoundFile("Sound\\Spells\\PVPEnterQueue.wav", "Master")
		end
	end
]]--
end

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
			PlaySoundFile("Sound\\interface\\ReadyCheck.wav", "Master")
		end
	end

end

function addon:LFG_PROPOSAL_SHOW()

	-- Hack, lets just call the ready check code so that we still play some sound
	self:READY_CHECK()

end

function addon:BATTLEFIELD_MGR_ENTRY_INVITE()

	-- Hack, lets just call the ready check code so that we still play some sound
	self:READY_CHECK()

end