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
	self:RegisterEvent("UNIT_AURA") -- Brawler guild message from boss
	self:RegisterEvent("PET_BATTLE_QUEUE_STATUS") -- PVP Pet Battles

	-- Hook each battleground queue so that it plays a sound when the pop-up shows up.
	-- This will play a sound for when the BG queue pops for you
	-- Code should also work when new battlegrounds are added
--[[
	for index = 1, NUM_DISPLAYED_BATTLEGROUNDS do
		local frame = _G["PVPHonorFrameBgButton"..index]
		self:HookScript(frame, "OnShow", PlayPVPSound)
	end
]]--

--[[
	-- If the Battlefield Entry doesn't have an onshow, create one.
	if (not StaticPopupDialogs["CONFIRM_BATTLEFIELD_ENTRY"].OnShow) then
		StaticPopupDialogs["CONFIRM_BATTLEFIELD_ENTRY"].OnShow = function()
			PlaySoundFile("Sound\\Spells\\PVPEnterQueue.wav", "Master")
		end
	end
]]--

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

-- Brawler's Guild Buff
local QueuedBuff = GetSpellInfo(132639)

-- Code developed from MysticalOS DBM-Brawler's Guild Module with permission
function addon:UNIT_AURA(uId)
	local currentQueueRank = select(15, UnitBuff("player", QueuedBuff))
	if currentQueueRank == 1 then
		PlayReadyCheck(true)
	end
end