-- ������ ���������� � ������������� �����

-- ����������� ������� ������������ ���� ����� �� �������������
MAP_CUSTOM_SKILL_TO_INNER = {
  [TYPE_MAGICS.LIGHT] = SKILL_LIGHT_MAGIC,
  [TYPE_MAGICS.DARK] = SKILL_DARK_MAGIC,
  [TYPE_MAGICS.DESTRUCTIVE] = SKILL_DESTRUCTIVE_MAGIC,
  [TYPE_MAGICS.SUMMON] = SKILL_SUMMONING_MAGIC,
  [TYPE_MAGICS.RUNES] = HERO_SKILL_RUNELORE,
  [TYPE_MAGICS.WARCRIES] = HERO_SKILL_DEMONIC_RAGE,
};

-- ������� �� ���������� � ������� ������ ������
function getSpellHasInPlayerSet(playerId, spellId)
  print "getSpellHasInPlayerSet"

  -- ����� ������ ����������
  local spellSetNumber = mod(PLAYERS_GENERATED_SPELLS[playerId].countResetSpells, 2) + 1;
  local spellSet = PLAYERS_GENERATED_SPELLS[playerId].spells[spellSetNumber];

  for _, spellData in spellSet do
    if spellData.id == spellId then
      return not nil;
    end;
  end;

  return nil;
end;

-- ������� �� ���� � ������� ������ ������
function getRunesHasInPlayerSet(playerId, runeId)
  print "getRunesHasInPlayerSet"

  -- ����� ������ ���
  local runesSetNumber = mod(PLAYERS_GENERATED_SPELLS[playerId].countResetRunes, 2) + 1;
  local runesSet = PLAYERS_GENERATED_SPELLS[playerId].runes[runesSetNumber];

  for _, runeData in runesSet do
    if runeData.id == runeId then
      return not nil;
    end;
  end;

  return nil;
end;

-- ���������� ����
function refreshPlayerMana(playerId)
  print "refreshPlayerMana"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  ChangeHeroStat(mainHeroName, STAT_MANA_POINTS, 1000);
end;

-- �������� �� ������ ���� ��������� �����������
function teachMainHeroSpells(playerId)
  print "teachMainHeroSpells"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  for skillId, skillSpellSet in SPELLS do
    for _, spellData in skillSpellSet do
      if skillId ~= TYPE_MAGICS.RUNES and skillId ~= TYPE_MAGICS.WARCRIES then
        local playerHasSpell = getSpellHasInPlayerSet(playerId, spellData.id);

        if playerHasSpell then
          local innerSkillId = MAP_CUSTOM_SKILL_TO_INNER[skillId];

          if spellData.level < 3 then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;

          if (
            spellData.level == 3
            and (HasHeroSkill(mainHeroName, PERK_WISDOM) or GetHeroSkillMastery(mainHeroName, innerSkillId) > 0)
          ) then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;

          if (
            spellData.level == 4
            and (
              (HasHeroSkill(mainHeroName, PERK_WISDOM) and HasArtefact(mainHeroName, ARTIFACT_NECROMANCER_PENDANT, 1))
              or GetHeroSkillMastery(mainHeroName, innerSkillId) > 1
            )
          ) then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;

          if spellData.level == 5 and GetHeroSkillMastery(mainHeroName, innerSkillId) > 2 then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;
        end;
      end;

      -- ����
      if skillId == TYPE_MAGICS.RUNES then
        local playerHasRune = getRunesHasInPlayerSet(playerId, spellData.id);

        if playerHasRune then
          if spellData.level < 4 then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;

          if spellData.level < 5 and GetHeroSkillMastery(mainHeroName, HERO_SKILL_RUNELORE) > 1 then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;

          if spellData.level == 5 and GetHeroSkillMastery(mainHeroName, HERO_SKILL_RUNELORE) > 2 then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;
        end;
      end;

      -- �����
      if skillId == TYPE_MAGICS.WARCRIES then
        local playerHasSpell = getSpellHasInPlayerSet(playerId, spellData.id);

        if playerHasSpell then
          TeachHeroSpell(mainHeroName, spellData.id);
        end;
      end;
    end;
  end;

  -- ����� ��� ��������� �����
  local bonusSpells = PLAYERS_GENERATED_SPELLS[playerId].bonus_spells;

  for _, spellData in bonusSpells do
    TeachHeroSpell(mainHeroName, spellData.id);
  end;
end;

-- ���������, �� ��������� �� ����� �� ����������
function checkNeedAutoTransferHero()
  print "checkNeedAutoTransferHero"

  local activePlayerId = getSelectedBattlefieldPlayerId();
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[activePlayerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  if HasHeroSkill(mainHeroName, PERK_PATHFINDING) == nil and dictHeroName ~= HEROES.JAZAZ then
    -- �������� ������������ ����� ��
  end;
end;

-- ������� ���
function generateSeed()
  print "generateSeed"

  local t = {};

	for i=1,6 do
		t[i] = random(16777216)
	end;

	consoleCmd([[@SetGameVar('combat_prng_seed', 'return {]] .. concat(t, ',') .. [[}')]])
end;

-- ����������� ������ �� ������� � ������ �������
function saveHeroesInfoInToBattle()
  print "saveHeroesInfoInToBattle"

  local customConsoleCommand = {[[@SetGameVar('heroes_info', 'return {]]};

  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

    append(customConsoleCommand, '["' .. mainHeroName .. '"]={');

    -- ������� --
		append(customConsoleCommand, 'level=' .. GetHeroLevel(mainHeroName) .. ',')

		-- ����� --
		append(customConsoleCommand, 'luck=' .. GetHeroStat(mainHeroName, STAT_LUCK) .. ',')

		-- ��������� --
		append(customConsoleCommand, 'ArtSet={')
    for artset = 0, 9 do
      local artsetlevel = GetArtifactSetItemsCount(mainHeroName, artset, 1)
      if artsetlevel > 0 then
        append(customConsoleCommand, '[' .. artset .. ']=' .. artsetlevel .. ',')
      end
    end
    append(customConsoleCommand, '},')

		-- ������ � ������ --
		append(customConsoleCommand, 'skills={')
		for skill = 1, 220 do
			local mastery = GetHeroSkillMastery(mainHeroName, skill)
			if mastery > 0 then
				append(customConsoleCommand, '[' .. skill .. ']=' .. mastery .. ',')
			end
		end
		append(customConsoleCommand, '},')

		append(customConsoleCommand, '},')
  end;

  append(customConsoleCommand, [[}')]])
	consoleCmd(concat(customConsoleCommand))
end;

-- ��������� �� ��������� �������, �� ����������� � ��������� �������
function getOtherRandomRaceId()
  print "getOtherRandomRaceId"

  local player1RaceId = RESULT_HERO_LIST[PLAYER_1].raceId;
  local player2RaceId = RESULT_HERO_LIST[PLAYER_2].raceId;

  local resultRaceIdTable = {};

  for _, raceId in RACES do
    if raceId ~= RACES.NEUTRAL and raceId ~= player1RaceId and raceId ~= player2RaceId then
      resultRaceIdTable[length(resultRaceIdTable)] = raceId;
    end;
  end;

  local randomIndex = random(length(resultRaceIdTable));

  return resultRaceIdTable[randomIndex];
end;

-- �������� ������� ������ �� ������ ������ � ��������� ������������ �� �����������
function checkAndMoveHeroFromFrendlyField()
  print "checkAndMoveHeroFromFrendlyField"

  local RACE_ON_FRENDLY_FIELD_POSITION = {
    [RACES.HAVEN] = { x = 52, y = 51 },
    [RACES.INFERNO] = { x = 56, y = 51 },
    [RACES.NECROPOLIS] = { x = 48, y = 51 },
    [RACES.SYLVAN] = { x = 52, y = 51 },
    [RACES.ACADEMY] = { x = 48, y = 49 },
    [RACES.DUNGEON] = { x = 40, y = 51 },
    [RACES.FORTRESS] = { x = 44, y = 51 },
    [RACES.STRONGHOLD] = { x = 50, y = 45 },
  };

  local choisePlayerId = getSelectedBattlefieldPlayerId();
  local choiseHeroName = PLAYERS_MAIN_HERO_PROPS[choisePlayerId].name;
  local choisePlayerRaceId = RESULT_HERO_LIST[choisePlayerId].raceId;
  local choiseDictHeroName = getDictionaryHeroName(choiseHeroName);

  local opponentPlayerId = PLAYERS_OPPONENT[choisePlayerId];
  local opponentPlayerRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;
    
  -- ������� �� ��������� ���������� �� ��� ������ ������
  if choiseDictHeroName == HEROES.JAZAZ then
    return nil;
  end;

  -- � ����������� ���� ����� �������������� ��� ������
  if HasHeroSkill(choiseHeroName, PERK_PATHFINDING) then
    return nil;
  end;

  for regionRaceId, raceRegion in MAP_RACE_ON_NATIVE_REGIONS do
    if IsObjectInRegion(choiseHeroName, raceRegion) and (regionRaceId == choisePlayerRaceId or regionRaceId == opponentPlayerRaceId) then
      local randomRaceId = getOtherRandomRaceId();
      local raceFieldPosition = RACE_ON_FRENDLY_FIELD_POSITION[randomRaceId];

      MoveHeroRealTime(choiseHeroName, raceFieldPosition.x, raceFieldPosition.y);

      return nil;
    end;
  end;
end;

-- ����������
function skillMentoring(heroName)
  print "skillMentoring"

  local MENTORINT_ADDITIONAL_LEVEL = 8;

  local heroLevel = GetHeroLevel(heroName);
  local needExp = TOTAL_EXPERIENCE_BY_LEVEL[heroLevel + MENTORINT_ADDITIONAL_LEVEL] - TOTAL_EXPERIENCE_BY_LEVEL[heroLevel];

  WarpHeroExp(heroName, GetHeroStat(heroName, STAT_EXPERIENCE) + needExp);
end;

-- ������ (���� ��� ���������� 1-2 �������, ��������� ���������)
function perkScholar(playerId)
  print "perkScholar"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

  local MAGIC_SCHOOL_TABLE = {
    TYPE_MAGICS.LIGHT,
    TYPE_MAGICS.DARK,
    TYPE_MAGICS.DESTRUCTIVE,
    TYPE_MAGICS.SUMMON,
  };

  for _, customSkillId in MAGIC_SCHOOL_TABLE do
    local skillSpellSet = SPELLS[customSkillId];

    for _, spellData in skillSpellSet do
      if spellData.level < 3 and KnowHeroSpell(opponentHeroName, spellData.id) then
        TeachHeroSpell(mainHeroName, spellData.id);
      end
    end;
  end;
end;

-- ���� �����
function perkRecruitment(playerId)
  print "perkRecruitment"

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  -- ����������� ���������� ������ �� ������
  local RECRUIMENT_COEF = 0.1

  local stash = {};

  stash[1], stash[2], stash[3], stash[4], stash[5], stash[6], stash[7] = GetHeroCreaturesTypes(mainHeroName);

  for _, armyId in stash do
    for _, dictUnit in UNITS[raceId] do
      if armyId == dictUnit.id and dictUnit.lvl < 4 then
        local unitInTown = RESULT_ARMY_INTO_TOWN[playerId][dictUnit.lvl];

        AddHeroCreatures(mainHeroName, dictUnit.id, floor(unitInTown.count * RECRUIMENT_COEF));
      end;
    end;
  end;
end;

-- ���� �������
function perkFeatMarchOfTheMachines(heroName)
  print "perkFeatMarchOfTheMachines"
  local heroLevel = GetHeroLevel(heroName);
  print(heroName)
  local BONUS_VALUE = 10 + 10 * (floor(heroLevel/10));

    if (GetHeroCreatures(heroName,  CREATURE_OBSIDIAN_GOLEM) > 0) then
      AddHeroCreatures(heroName,  CREATURE_OBSIDIAN_GOLEM, BONUS_VALUE);
    elseif (GetHeroCreatures(heroName, CREATURE_IRON_GOLEM) > 0) then
      AddHeroCreatures(heroName, CREATURE_IRON_GOLEM, BONUS_VALUE);
    end;
end;


-- ������ ���������� ������ �����
function checkAndRunHeroPerks(playerId)
  print "checkAndRunHeroPerks"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- ����������
  if HasHeroSkill(mainHeroName, HERO_SKILL_MENTORING) then
    skillMentoring(mainHeroName);
  end;

  -- ������
  if HasHeroSkill(mainHeroName, PERK_SCHOLAR) then
    perkScholar(playerId);
  end;

  -- ���� �����
  if HasHeroSkill(mainHeroName, PERK_RECRUITMENT) then
    perkRecruitment(playerId);
  end;
  
  -- ���� ����� (������ �������)
  if HasHeroSkill(mainHeroName, WIZARD_FEAT_MARCH_OF_THE_MACHINES) then
    perkFeatMarchOfTheMachines(mainHeroName);
  end;

  -- �������
  if HasHeroSkill(mainHeroName, NECROMANCER_FEAT_TWILIGHT) then
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, 5);
    ChangeHeroStat(mainHeroName, STAT_MANA_POINTS, 30);
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, -5);
  end;

  -- �������������
  if HasHeroSkill(mainHeroName, WIZARD_FEAT_SEAL_OF_PROTECTION) then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_HITPOINTS, 10);
  end;

  -- ������������
  if HasHeroSkill(mainHeroName, HERO_SKILL_BODYBUILDING) then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_HITPOINTS, 5);
  end;

  -- �����������
  if HasHeroSkill(mainHeroName, HERO_SKILL_SNATCH) then
    local opponentPlayerId = PLAYERS_OPPONENT[playerId];
    local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

    GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_SPEED, -1);
  end;

  -- ������ �����
  if HasHeroSkill(mainHeroName, KNIGHT_FEAT_ROAD_HOME) then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_SPEED, 1);
  end;

  -- ���� ������ �����
  if HasHeroSkill(mainHeroName, HERO_SKILL_MIGHT_OVER_MAGIC) then
    if frac(GetHeroStat(mainHeroName, STAT_SPELL_POWER) / 2) == 0.5 then
      ChangeHeroStat(mainHeroName, STAT_SPELL_POWER, 1);
    end;
  end;

  -- ������ ���������
  if HasHeroSkill(mainHeroName, RANGER_FEAT_CUNNING_OF_THE_WOODS) then
    local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

    UpgradeTownBuilding(townName, TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  end;

  -- ������� ������
  if HasHeroSkill(mainHeroName, NECROMANCER_FEAT_ABSOLUTE_FEAR) then
    local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

    SetTownBuildingLimitLevel(townName, TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS, 1);
    UpgradeTownBuilding(townName, TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS);
  end;

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local leadershipLevel = GetHeroSkillMastery(mainHeroName, SKILL_LEADERSHIP);

  -- ��������������
  if raceId == RACES.NECROPOLIS and leadershipLevel > 0 then
    local opponentPlayerId = PLAYERS_OPPONENT[playerId];
    local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;
    local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

    local opponentLeadershipLevel = GetHeroSkillMastery(opponentHeroName, SKILL_LEADERSHIP);

    if opponentLeadershipLevel > 0 and leadershipLevel >= opponentLeadershipLevel then
      GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_MORALE, 0 - opponentLeadershipLevel);
    end;

    if opponentLeadershipLevel > 0 and leadershipLevel < opponentLeadershipLevel then
      GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_MORALE, 0 - leadershipLevel);
    end;
  end;

  -- ���������� ��������
  if GetHeroSkillMastery(mainHeroName, SKILL_WAR_MACHINES) > 0 then
    GiveHeroWarMachine(mainHeroName, WAR_MACHINE_BALLISTA);
    GiveHeroWarMachine(mainHeroName, WAR_MACHINE_FIRST_AID_TENT);
    GiveHeroWarMachine(mainHeroName, WAR_MACHINE_AMMO_CART);
  end;

  -- �����-���������
  if HasHeroSkill(mainHeroName, KNIGHT_FEAT_GUARDIAN_ANGEL) then
    local ANGEL_MAP = {
      [CREATURE_ANGEL] = CREATURE_GOBLIN_TRAPPER,
      [CREATURE_SERAPH] = CREATURE_WAR_UNICORN,
    };

    for angelId, superAngelId in ANGEL_MAP do
      replaceUnitInHero(mainHeroName, angelId, superAngelId);
    end;
  end;

  -- ���������� �����
  if HasHeroSkill(mainHeroName, PERK_LUCKY_STRIKE) then
    local MAP_UNIT_ON_UNIT_WITH_LUCKY_STRIKE = {
      [CREATURE_SUCCUBUS_SEDUCER] = CREATURE_IMP,
      [CREATURE_DEVIL] = CREATURE_FRIGHTFUL_NIGHTMARE,
      [CREATURE_POLTERGEIST] = CREATURE_SKELETON_ARCHER,
      [CREATURE_DRYAD] = CREATURE_SPRITE,
      [CREATURE_STONE_DEFENDER] = CREATURE_STOUT_DEFENDER,
      [CREATURE_SHADOW_MISTRESS] = CREATURE_BLACK_DRAGON,
      [CREATURE_THANE] = CREATURE_WARLORD,
      [CREATURE_THUNDER_THANE] = CREATURE_AXE_THROWER,
      [CREATURE_ANGEL] = CREATURE_ARCHANGEL,
      [CREATURE_GOBLIN_TRAPPER] = CREATURE_MASTER_GENIE,
    };

    for unitId, unitWithLucky in MAP_UNIT_ON_UNIT_WITH_LUCKY_STRIKE do
      replaceUnitInHero(mainHeroName, unitId, unitWithLucky);
    end;
  end;
end;

-- ����� ������
function kiganSpec(heroName)
  print "kiganSpec"

  local KIGAN_BY_LVL_COEF = 6;
  local heroLevel = GetHeroLevel(heroName);


  if GetHeroCreatures(heroName, CREATURE_GOBLIN) > 0 then
    AddHeroCreatures(heroName, CREATURE_GOBLIN, KIGAN_BY_LVL_COEF * heroLevel);
  else
    AddHeroCreatures(heroName, CREATURE_GOBLIN_DEFILER, KIGAN_BY_LVL_COEF * heroLevel);
  end;
end;

-- ����� �������
function orlandoSpec(heroName)
  print "orlandoSpec"

  local ORLANDO_BONUS_BY_LEVEL = 0.1;
  local heroLevel = GetHeroLevel(heroName);

  if GetHeroCreatures(heroName, CREATURE_DEVIL) >= GetHeroCreatures(heroName, CREATURE_ARCH_DEMON) then
    AddHeroCreatures(heroName, CREATURE_DEVIL, 1 + floor(heroLevel * ORLANDO_BONUS_BY_LEVEL));
  else
    AddHeroCreatures(heroName, CREATURE_ARCH_DEMON, 1 + floor(heroLevel * ORLANDO_BONUS_BY_LEVEL));
  end;
end;

-- ������������� ����
function specInga(heroName)
  print "specInga"

  -- �� ������� ������� ���� ���� ����
  local LVL_FOR_TEACH_RUNE = 7;

  local playerId = GetObjectOwner(heroName);
  local ingaLevel = GetHeroLevel(heroName);

  local countIngaRune = floor(ingaLevel / LVL_FOR_TEACH_RUNE);
  local playerRuneSet = getCurrentPlayerRuneSet(playerId);

  if countIngaRune > 0 then
    local allowRuneLevel = MAP_RUNELORE_TO_ALLOW_RUNE_LEVELS[GetHeroSkillMastery(heroName, HERO_SKILL_RUNELORE)]
    local canTeachRunesTable = {};

    -- ��������� ������ ��������� ��� �������� ���
    for _, runeData in SPELLS[TYPE_MAGICS.RUNES] do
      if allowRuneLevel >= runeData.level then
        local heroKnowThisRune = nil;

        for _, heroRuneData in playerRuneSet do
          if heroRuneData.id == runeData.id then
            heroKnowThisRune = not nil;
          end;
        end;

        if not heroKnowThisRune then
          canTeachRunesTable[length(canTeachRunesTable) + 1] = runeData.id
        end;
      end
    end;

    -- ��������� �������� ������ ��� ��� ��������
    local teachRuneTable = {};

    for indexTeachRune = 1, countIngaRune do
      local isAddedRune;
      local randomIndex;

      repeat
        isAddedRune = nil;
        randomIndex = random(length(canTeachRunesTable)) + 1;

        for _, addedRune in teachRuneTable do
          if addedRune == canTeachRunesTable[randomIndex] then
            isAddedRune = not nil;
          end;
        end;
      until not isAddedRune

      teachRuneTable[length(teachRuneTable) + 1] = canTeachRunesTable[randomIndex];
    end;

    -- ������� ����� ����� �����
    for _, newRuneId in teachRuneTable do
      TeachHeroSpell(heroName, newRuneId);
    end;
  end;
end;

-- ������������ ����� �������
function specValeriaTread(heroName)
  print "specValeriaTread"

  local MAP_SPELLS_ON_MASS_SPELLS = {
    [SPELL_CURSE] = SPELL_MASS_CURSE,
    [SPELL_SLOW] = SPELL_MASS_SLOW,
    [SPELL_DISRUPTING_RAY] = SPELL_MASS_DISRUPTING_RAY,
    [SPELL_PLAGUE] = SPELL_MASS_PLAGUE,
    [SPELL_WEAKNESS] = SPELL_MASS_WEAKNESS,
    [SPELL_FORGETFULNESS] = SPELL_MASS_FORGETFULNESS,
  };

  for spellId, massSpellId in MAP_SPELLS_ON_MASS_SPELLS do
    if KnowHeroSpell(heroName, spellId) then
      TeachHeroSpell(heroName, massSpellId);
    end;
  end;
end;

-- ������ ���������� ������������� ������
function runHeroSpecialization(playerId)
  print "runHeroSpecialization"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  if dictHeroName == HEROES.UNA then
    specInga(mainHeroName);
  end;
  
  if dictHeroName == HEROES.RED_HEAVEN_HERO then
    specValeriaTread(mainHeroName);
  end;

  -- �����
  if dictHeroName == HEROES.KIGAN then
    kiganSpec(mainHeroName);
  end;

  -- �������
  if dictHeroName == HEROES.ORLANDO then
    orlandoSpec(mainHeroName);
  end;

  -- �������
  if dictHeroName == HEROES.NADAUR then
    local MAP_REPLACE_UNIT = {
      [45] = 46,
      [146] = 18,
      [47] = 48,
      [147] = 20,
      [49] = 50,
      [148] = 22,
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;
  end;

  -- �������
  if dictHeroName == HEROES.HEAM then
    local MAP_REPLACE_UNIT = {
      [47] = 62,
      [147] = 76,
      [49] = 72,
      [148] = 74,
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;
  end;

  -- ����
  if dictHeroName == HEROES.ERUINA then
    local MAP_REPLACE_UNIT = {
      [81] = 82,
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;
  end;

  -- ������
  if dictHeroName == HEROES.FERIGL then
    local MAP_REPLACE_UNIT = {
      [77] = 200 + ceil(0.5 * (GetHeroLevel(mainHeroName) - FREE_LEARNING_LEVEL)),
      [141] = 210 + ceil(0.5 * (GetHeroLevel(mainHeroName) - FREE_LEARNING_LEVEL)),
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;
  end;

  -- ���������
  if dictHeroName == HEROES.WULFSTAN then
    local MAP_REPLACE_UNIT = {
      [98] = 99,
      [169] = 80,
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;
  end;

  -- ����
  if dictHeroName == HEROES.GROK then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_SPEED, 1);
  end;

  -- ������
  if dictHeroName == HEROES.MARDER then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_HITPOINTS, round(0.4 * GetHeroLevel(mainHeroName)));
  end;

  -- ������
  if dictHeroName == HEROES.KUJIN then
    local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

    UpgradeTownBuilding(townName, TOWN_BUILDING_STRONGHOLD_PILE_OF_OUR_FOES);
  end;
end;

-- ����� � ������ ���������
function crownOfLeader(heroName)
  print "crownOfLeader"

  local CROWN_OF_LEADER_BONUS = 1;
  local units = {};

  units[1], units[2], units[3], units[4], units[5], units[6], units[7] = GetHeroCreaturesTypes(heroName);

  for _, unitId in units do
    if unitId > 0 then
      AddHeroCreatures(heroName, unitId, CROWN_OF_LEADER_BONUS);
    end;
  end;
end;

-- ���� � ����� ���� ������������� ���� - ���������� ��
function runScriptingArtifacts(playerId)
  print "runScriptingArtifacts"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  
  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;
  local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

  -- ������ ���������
  if HasArtefact(mainHeroName, ARTIFACT_CROWN_OF_LEADER, 1) then
    crownOfLeader(mainHeroName);
  end;

  -- ����� �����������
  if HasArtefact(mainHeroName, 7, 1) then
    GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_INITIATIVE, -1);
  end;

  -- ���� ������
  if raceId == RACES.INFERNO and HasArtefact(mainHeroName, ARTIFACT_NIGHTMARISH_RING, 1) and HasArtefact(mainHeroName, ARTIFACT_HELM_OF_CHAOS, 1) then
    local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

    UpgradeTownBuilding(townName, TOWN_BUILDING_INFERNO_INFERNAL_LOOM);
  end;

  -- ������� ������
  if HasArtefact(mainHeroName, 7, 1) and HasArtefact(mainHeroName, 33, 1) then
    local MAP_RACE_ON_PRIMARY_STAT = {
      [RACES.HAVEN] = STAT_ATTACK,
      [RACES.INFERNO] = STAT_ATTACK,
      [RACES.NECROPOLIS] = STAT_DEFENCE,
      [RACES.SYLVAN] = STAT_DEFENCE,
      [RACES.ACADEMY] = STAT_SPELL_POWER,
      [RACES.DUNGEON] = STAT_ATTACK,
      [RACES.FORTRESS] = STAT_DEFENCE,
      [RACES.STRONGHOLD] = STAT_ATTACK,
    };
    local MAP_RACE_ON_SECONDARY_STAT = {
      [RACES.HAVEN] = STAT_DEFENCE,
      [RACES.INFERNO] = STAT_KNOWLEDGE,
      [RACES.NECROPOLIS] = STAT_SPELL_POWER,
      [RACES.SYLVAN] = STAT_KNOWLEDGE,
      [RACES.ACADEMY] = STAT_KNOWLEDGE,
      [RACES.DUNGEON] = STAT_SPELL_POWER,
      [RACES.FORTRESS] = STAT_SPELL_POWER,
      [RACES.STRONGHOLD] = STAT_DEFENCE,
    };

    ChangeHeroStat(opponentHeroName, MAP_RACE_ON_PRIMARY_STAT[opponentRaceId], -2);
    ChangeHeroStat(opponentHeroName, MAP_RACE_ON_SECONDARY_STAT[opponentRaceId], -2);
  end;

  -- ������ ����
  if HasArtefact(mainHeroName, 10, 1) then
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, 50);
    ChangeHeroStat(mainHeroName, STAT_MANA_POINTS, 25);
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, -50);
  end;

  -- ������ ���������
  if HasArtefact(mainHeroName, 70, 1) then
    local artCount = GetHeroArtifactsCount(mainHeroName, 70, 1);

    GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_LUCK, -artCount);
  end;

  -- ��� ������
  local countDwarfSet = GetArtifactSetItemsCount(mainHeroName, 5, 1);

  if countDwarfSet > 1 then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_HITPOINTS, 5 * countDwarfSet);

    if raceId == RACES.FORTRESS then
      ChangeHeroStat(mainHeroName, STAT_SPELL_POWER, 4);
    end;
  end;
end;

-- ������������ ���������� � ������ �����
function runBattle()
  print "runBattle"
  
  local p1MainHeroName = PLAYERS_MAIN_HERO_PROPS[PLAYER_1].name;
  local p2MainHeroName = PLAYERS_MAIN_HERO_PROPS[PLAYER_2].name;
  
  local choisePlayerId = getSelectedBattlefieldPlayerId();

  -- ���������� ������ �������
  StartCombat(PLAYERS_MAIN_HERO_PROPS[choisePlayerId].name, nil, 1, 1, 1, '/scripts/RTA_TestExecutionThread.(Script).xdb#xpointer(/Script)')

  sleep(5);

  saveHeroesInfoInToBattle();
  generateSeed();

  checkAndMoveHeroFromFrendlyField();

  sleep(5);

  while IsHeroAlive(p1MainHeroName) and IsHeroAlive(p2MainHeroName) do
    if choisePlayerId == PLAYER_2 then
      MakeHeroInteractWithObject(p1MainHeroName, p2MainHeroName);
    else
      MakeHeroInteractWithObject(p2MainHeroName, p1MainHeroName);
    end;

    sleep(10);
  end;
end;

function startBattle()
  print "startBattle"

  for _, playerId in PLAYER_ID_TABLE do
    refreshPlayerMana(playerId);

    teachMainHeroSpells(playerId);

    checkAndRunHeroPerks(playerId);

    runHeroSpecialization(playerId);

    runScriptingArtifacts(playerId);
  end;
  
  runBattle();
end;