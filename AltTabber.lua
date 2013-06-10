--[[
************************************************************************
AltTabber.lua
Core functions for Alt-Tabber
************************************************************************
File date: @file-date-iso@
File hash: @file-abbreviated-hash@
Project hash: @project-abbreviated-hash@
Project version: @project-version@
************************************************************************
Please see http://www.wowace.com/addons/alttaber/ for more information.
************************************************************************
This source code is released under All Rights Reserved.
************************************************************************
]]

local LibStub = _G.LibStub

local MODNAME	= "AltTabber"

AltTabber		= LibStub("AceAddon-3.0"):NewAddon(MODNAME, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

local addon		= LibStub("AceAddon-3.0"):GetAddon(MODNAME)
local AL3		= LibStub("AceLocale-3.0")

local L = AL3:GetLocale(MODNAME, false)

--@alpha@
_G.AT = addon
--@end-alpha@

local GetCVar = GetCVar
local SetCVar = SetCVar
local PlaySoundFile = PlaySoundFile
local GetCurrentMapAreaID = GetCurrentMapAreaID

local BrawlerLocationEnabled = false

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

-- Checks the CVars to determine if we can actually play sound.
local function CheckCVars(sound_on)

	local Sound_EnableSFX = GetCVar("Sound_EnableSFX")
	local Sound_EnableAllSound = GetCVar("Sound_EnableAllSound")
	local Sound_MasterVolume = GetCVar("Sound_MasterVolume")
	local Sound_EnableSoundWhenGameIsInBG = GetCVar("Sound_EnableSoundWhenGameIsInBG")

	-- If our master volume is set to 0.0 then we won't hear a damn thing.
	if (Sound_MasterVolume == 0.0) then
		addon:Print(L["MASTERSOUNDOFF"])
	end

	-- If sound is off, we want to play the readycheck
	if (Sound_EnableSFX == "0") and not sound_on then
		-- If background sound is off, we can't do anything
		-- Set the background sound to on and inform the user
		if (Sound_EnableSoundWhenGameIsInBG == "0") then
			addon:Print(L["BGSNDON"])
			SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
			return false

		-- If the entire sound processing is off, we can't play sound.
		-- Set the variables and inform the user
		elseif (Sound_EnableAllSound == "0") then
			addon:Print(L["ENABLESOUNDSYSTEM"])
			SetCVar("Sound_EnableAllSound","1")
			-- Disable all the other types of sounds
			SetCVar("Sound_EnableSFX","0")
			SetCVar("Sound_EnableAmbience","0")
			SetCVar("Sound_EnableMusic","0")
			return false
		-- We just have sound off, but conditions are correct so we will
		-- hear the sounds.
		else
			return true
		end
	-- Sound is on but we want the notification anyways
	-- Useful for things like the Brawler's guild where there is no
	-- default sound played.
	elseif sound_on then
		return true
	else
		return false
	end

end

-- Plays the PVP queue popping sound.
local function PlayPVPSound(sound_on)
	if CheckCVars(sound_on) then
		PlaySoundFile("Sound\\Spells\\PVPEnterQueue.wav", "Master")
	end
end

-- Plays the ready check sound
local function PlayReadyCheck(sound_on)
	if CheckCVars(sound_on) then
		PlaySoundFile("Sound\\interface\\ReadyCheck.wav", "Master")
	end
end

function addon:OnEnable()

	self:RegisterEvent("READY_CHECK") -- Raid Ready Checks
	self:RegisterEvent("LFG_PROPOSAL_SHOW") -- LFG System
	self:RegisterEvent("BATTLEFIELD_MGR_ENTRY_INVITE") -- World PVP (Tol Barad, WG)
	self:RegisterEvent("PET_BATTLE_QUEUE_STATUS") -- PVP Pet Battles

	-- Check zones for the Brawler's Guild.
	-- We don't want to always scan for buffs.
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Hook into the battleground pvp queue window
	self:SecureHook(StaticPopupDialogs["CONFIRM_BATTLEFIELD_ENTRY"], "OnShow", PlayPVPSound)

end

function addon:PET_BATTLE_QUEUE_STATUS()
	local queue = C_PetBattles.GetPVPMatchmakingInfo()
	if queue == "proposal" then
		PlayReadyCheck(true)
	end
end

function addon:READY_CHECK()
	PlayReadyCheck()
end

function addon:LFG_PROPOSAL_SHOW()
	PlayReadyCheck()
end

function addon:BATTLEFIELD_MGR_ENTRY_INVITE()
	PlayPVPSound()
end

function BrawlersGuildEvents(currentZone)
	-- We're in the Brawler's Guild
	if currentZone == 922 or currentZone == 925 then
		BrawlerLocationEnabled = true
		addon:RegisterEvent("UNIT_AURA")
	-- Not in the Brawler's guild and we're checking for buffs
	elseif BrawlerLocationEnabled then
		addon:UnregisterEvent("UNIT_AURA")
	end
end

function addon:ZONE_CHANGED()
	local currentZone = GetCurrentMapAreaID()
	BrawlersGuildEvents(currentZone)
end

function addon:ZONE_CHANGED_INDOORS()
	local currentZone = GetCurrentMapAreaID()
	BrawlersGuildEvents(currentZone)
end

function addon:ZONE_CHANGED_NEW_AREA()
	local currentZone = GetCurrentMapAreaID()
	BrawlersGuildEvents(currentZone)
end

function addon:PLAYER_ENTERING_WORLD()
	local currentZone = GetCurrentMapAreaID()
	BrawlersGuildEvents(currentZone)
end

-- Brawler's Guild Buff
local QueuedBuff = GetSpellInfo(132639)
local WarningGiven = false

-- Code developed from MysticalOS DBM-Brawler's Guild Module with permission
function addon:UNIT_AURA(uId)
	local currentQueueRank = select(15, UnitBuff("player", QueuedBuff))
	if not currentQueueRank then
		WarningGiven = false
	elseif currentQueueRank == 1 and not WarningGiven then
		PlayReadyCheck(true)
		WarningGiven = true
	elseif currentQueueRank ~= 1 then
		WarningGiven = false
	end
end
