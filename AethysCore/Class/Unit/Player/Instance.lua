--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
  local addonName, AC = ...;
  -- AethysCore
  local Cache, Utils = AethysCache, AC.Utils;
  local Unit = AC.Unit;
  local Player, Pet, Target = Unit.Player, Unit.Pet, Unit.Target;
  local Focus, MouseOver = Unit.Focus, Unit.MouseOver;
  local Arena, Boss, Nameplate = Unit.Arena, Unit.Boss, Unit.Nameplate;
  local Party, Raid = Unit.Party, Unit.Raid;
  local Spell = AC.Spell;
  local Item = AC.Item;
  -- Lua
  local pairs = pairs;
  local select = select;
  local tablesort = table.sort;
  local tostring = tostring;
  -- File Locals
  


--- ============================ CONTENT ============================
  -- Get the instance information about the current area.
  -- Returns
    -- name - Name of the instance or world area (string)
    -- type - Type of the instance (string)
    --   arena - A PvP Arena instance
    --   none - Normal world area (e.g. Northrend, Kalimdor, Deeprun Tram)
    --   party - An instance for 5-man groups
    --   pvp - A PvP battleground instance
    --   raid - An instance for raid groups
    --   scenario - A scenario instance
    -- difficulty - Difficulty setting of the instance (number)
    --   0 - None; not in an Instance.
    --   1 - 5-player Instance.
    --   2 - 5-player Heroic Instance.
    --   3 - 10-player Raid Instance.
    --   4 - 25-player Raid Instance.
    --   5 - 10-player Heroic Raid Instance.
    --   6 - 25-player Heroic Raid Instance.
    --   7 - 25-player Raid Finder Instance.
    --   8 - Challenge Mode Instance.
    --   9 - 40-player Raid Instance.
    --   10 - Not used.
    --   11 - Heroic Scenario Instance.
    --   12 - Scenario Instance.
    --   13 - Not used.
    --   14 - 10-30-player Normal Raid Instance.
    --   15 - 10-30-player Heroic Raid Instance.
    --   16 - 20-player Mythic Raid Instance .
    --   17 - 10-30-player Raid Finder Instance.
    --   18 - 40-player Event raid (Used by the level 100 version of Molten Core for WoW's 10th anniversary).
    --   19 - 5-player Event instance (Used by the level 90 version of UBRS at WoD launch).
    --   20 - 25-player Event scenario (unknown usage).
    --   21 - Not used.
    --   22 - Not used.
    --   23 - Mythic 5-player Instance.
    --   24 - Timewalker 5-player Instance.
    -- difficultyName - String representing the difficulty of the instance. E.g. "10 Player" (string)
    -- maxPlayers - Maximum number of players allowed in the instance (number)
    -- playerDifficulty - Unknown (number)
    -- isDynamicInstance - True for raid instances that can support multiple maxPlayers values (10 and 25) - eg. ToC, DS, ICC, etc (boolean)
    -- mapID - (number)
    -- instanceGroupSize - maxPlayers for fixed size raids, holds the actual raid size for the new flexible raid (between (8?)10 and 25) (number)
  function Player:InstanceInfo (Index)
    if Index then
      return Cache.Get("UnitInfo", self:GUID(), "InstanceInfo",
                        function() return {GetInstanceInfo()}; end)[Index];
    else
      return unpack(Cache.Get("UnitInfo", self:GUID(), "InstanceInfo",
                        function() return {GetInstanceInfo()}; end));
    end
  end

  -- Get the player instance type.
  function Player:InstanceType ()
    return self:InstanceInfo(2);
  end

  -- Get the player instance difficulty.
  function Player:InstanceDifficulty ()
    return self:InstanceInfo(3);
  end

  -- Get wether the player is in an instanced pvp area.
  function Player:IsInInstancedPvP ()
    local InstanceType = self:InstanceType();
    return (InstanceType == "arena" or InstanceType == "pvp") or false;
  end

  -- Get wether the player is in a raid area.
  function Player:IsInRaid ()
    return self:InstanceType() == "raid" or false;
  end