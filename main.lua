----Welcome to the "main.lua" file! Here is where all the magic happens, everything from functions to callbacks are dJATTESTOR_Character.
--Startup
local mod = RegisterMod("Commission Template - Character + Tainted", 1)
local json = require("json")
local game = Game()
local rng = RNG()

--Stat Functions
local function toTears(fireDelay) --thanks oat for the cool functions for calculating firerate!
	return 30 / (fireDelay + 1)
end
local function fromTears(tears)
	return math.max((30 / tears) - 1, -0.99)
end

--Character Functions
---@param name string
---@param isTainted boolean
---@return table
local function addCharacter(name, isTainted) -- This is the function used to determine the stats of your character, you can simply leave it as you will use it later!
	local character = { -- these stats are added to Isaac's base stats.
		NAME = name,
		ID = Isaac.GetPlayerTypeByName(name, isTainted), -- string, boolean
	}
	return character
end
mod.JATTESTOR_Character = addCharacter("JATTESTOR", false)
mod.TAINTED_JATTESTOR_Character = addCharacter("TAINTED JATTESTOR", true)

function mod:evalCache(player, cacheFlag) -- this function applies all the stats the character gains/loses on a new run.
	---@param name string
	---@param speed number
	---@param tears number
	---@param damage number
	---@param range number
	---@param shotspeed number
	---@param luck number
	---@param tearcolor Color
	---@param flying boolean
	---@param tearflag TearFlags
	local function addStats(name, speed, tears, damage, range, shotspeed, luck, tearcolor, flying, tearflag) -- This is the function used to determine the stats of your character, you can simply leave it as you will use it later!
		if player:GetPlayerType(name) then
			if cacheFlag == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed + speed
			end
			if cacheFlag == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = math.max(1.0, fromTears(toTears(player.MaxFireDelay) + tears))
			end
			if cacheFlag == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + damage
			end
			if cacheFlag == CacheFlag.CACHE_RANGE then
				player.TearRange = player.TearRange + range * 40
			end
			if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
				player.ShotSpeed = player.ShotSpeed + shotspeed
			end
			if cacheFlag == CacheFlag.CACHE_LUCK then
				player.Luck = player.Luck + luck
			end
			if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
				player.TearColor = tearcolor
			end
			if cacheFlag == CacheFlag.CACHE_FLYING and flying then
				player.CanFly = true
			end
			if cacheFlag == CacheFlag.CACHE_TEARFLAG then
				player.TearFlags = player.TearFlags | tearflag
			end
		end
	end
	mod.JATTESTOR_Stats = addStats("JATTESTOR", 0, 0, 0, 0, 0, 0, Color(1, 1, 1, 1.0, 0, 0, 0), false, TearFlags.TEAR_NORMAL)
	mod.TAINTED_JATTESTOR_Stats = addStats("TAINTED JATTESTOR", 0, 0, 0, 0, 0, 0, Color(1, 1, 1, 1.0, 0, 0, 0), false, TearFlags.TEAR_NORMAL)
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,mod.evalCache)

function mod:playerSpawn(player)
    if player:GetName() == mod.JATTESTOR_Character.NAME then
        player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/JATTESTOR-head.anm2"))
		player:AddCollectible(CollectibleType.COLLECTIBLE_POKE_GO)
		player:AddCollectible(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)
		player:AddCollectible(CollectibleType.COLLECTIBLE_BUDDY_IN_A_BOX)
    end
    if player:GetName() == mod.TAINTED_JATTESTOR_Character.NAME then
        player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/TAINTED JATTESTOR-head.anm2"))
		player:AddCollectible(CollectibleType.COLLECTIBLE_POKE_GO)
		player:AddCollectible(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)
		player:AddCollectible(CollectibleType.COLLECTIBLE_BUDDY_IN_A_BOX)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.playerSpawn)