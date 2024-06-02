-- ������� ������������� �� 4 ����

PATH_TO_DAY4_SCRIPTS = GetMapDataPath().."day4/";
PATH_TO_DAY4_MESSAGES = PATH_TO_DAY4_SCRIPTS.."messages/";

doFile(PATH_TO_DAY4_SCRIPTS.."day4_constants.lua");
sleep(1);

-- ����������� ������� �� Id ���������� ��� ������ ����� �� ������
MAP_GARNISON_FOR_TOWN_STASHE = {
  [PLAYER_1] = 'Garrison3',
  [PLAYER_2] = 'Garrison4',
};

-- ����������� ������� � �� �������
MAP_CREATURES_ON_GRADE = {
  -- ����������� �������� �� �����
  [CREATURE_PRIEST] = CREATURE_ZEALOT,
  [CREATURE_CAVALIER] = CREATURE_CHAMPION,
  [CREATURE_ANGEL] = CREATURE_SERAPH,
  [CREATURE_SUCCUBUS] = CREATURE_SUCCUBUS_SEDUCER,
  [CREATURE_NIGHTMARE] = CREATURE_HELLMARE,
  [CREATURE_PIT_FIEND] = CREATURE_PIT_SPAWN,
  [CREATURE_DEVIL] = CREATURE_ARCH_DEMON,
  [CREATURE_VAMPIRE] = CREATURE_NOSFERATU,
  [CREATURE_LICH] = CREATURE_LICH_MASTER,
  [CREATURE_WIGHT] = CREATURE_BANSHEE,
  [CREATURE_BONE_DRAGON] = CREATURE_HORROR_DRAGON,
  [CREATURE_DRUID] = CREATURE_HIGH_DRUID,
  [CREATURE_UNICORN] = CREATURE_WHITE_UNICORN,
  [CREATURE_TREANT] = CREATURE_ANGER_TREANT,
  [CREATURE_GREEN_DRAGON] = CREATURE_RAINBOW_DRAGON,
  [CREATURE_MAGI] = CREATURE_COMBAT_MAGE,
  [CREATURE_GENIE] = CREATURE_DJINN_VIZIER,
  [CREATURE_RAKSHASA] = CREATURE_RAKSHASA_KSHATRI,
  [CREATURE_RAKSHASA_RUKH] = CREATURE_TITAN,
  [CREATURE_GIANT] = CREATURE_STORM_LORD,
  [CREATURE_RIDER] = CREATURE_BLACK_RIDER,
  [CREATURE_HYDRA] = CREATURE_ACIDIC_HYDRA,
  [CREATURE_MATRON] = CREATURE_SHADOW_MISTRESS,
  [CREATURE_DEEP_DRAGON] = CREATURE_RED_DRAGON,
  [CREATURE_BROWLER] = CREATURE_BATTLE_RAGER,
  [CREATURE_RUNE_MAGE] = CREATURE_FLAME_KEEPER,
  [CREATURE_THANE] = CREATURE_THUNDER_THANE,
  [CREATURE_MAGMA_DRAGON] = CREATURE_LAVA_DRAGON,
  [CREATURE_SHAMAN] = CREATURE_SHAMAN_HAG,
  [CREATURE_ORCCHIEF_BUTCHER] = CREATURE_ORCCHIEF_CHIEFTAIN,
  [CREATURE_WYVERN] = CREATURE_WYVERN_PAOKAI,
  [CREATURE_CYCLOP] = CREATURE_CYCLOP_BLOODEYED,

  -- ����������� ��������, ���������� �������� ��� ��� ���������������
  [CREATURE_ROYAL_GRIFFIN] = CREATURE_BATTLE_GRIFFIN, -- �������� ��� ����?
};

-- ���������� ���� ��������� ������������
function disableCustomAbilities(heroName)
  print "disableCustomAbilities"

  local allCustomAbilityTable = {
    CUSTOM_ABILITY_1,
    CUSTOM_ABILITY_2,
    CUSTOM_ABILITY_3,
    CUSTOM_ABILITY_4,
  };
  
  for _, ability in allCustomAbilityTable do
    ControlHeroCustomAbility(heroName, ability, CUSTOM_ABILITY_DISABLED);
  end;
end;

-- ���������� � ������ ��� ��������� �������, �������� ����������� ������ �� �����
function downgradeTown(playerId)
  print "downgradeTown"

  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  
  local allTownDwellTable = {
    TOWN_BUILDING_DWELLING_1,
    TOWN_BUILDING_DWELLING_2,
    TOWN_BUILDING_DWELLING_3,
    TOWN_BUILDING_DWELLING_4,
    TOWN_BUILDING_DWELLING_5,
    TOWN_BUILDING_DWELLING_6,
    TOWN_BUILDING_DWELLING_7,
  };
  
  if raceId == RACES.ACADEMY then
    DestroyTownBuildingToLevel(townName, TOWN_BUILDING_ACADEMY_ARTIFACT_MERCHANT, 0, 0);
  end;
  
  for _, dwellId in allTownDwellTable do
    DestroyTownBuildingToLevel(townName, dwellId, 0, 0);
  end;
end;

-- ���������� ���� ������ �������� ������
function disableAllOtherBuildings(playerId)
  print "disableAllOtherBuildings"

  local PLAYERS_MARKET = {
    [PLAYER_1] = 'market1',
    [PLAYER_2] = 'market2',
  };

  SetObjectEnabled(PLAYERS_MARKET[playerId], nil);
end;

-- �������� ���� ����� ������������ � ���� ������ ������
function removeAllHeroMovePoints(playerId)
  print "removeAllHeroMovePoints"

  local heroes = RESULT_HERO_LIST[playerId].heroes;
  
  for _, heroName in heroes do
    local reservedHeroName = getReservedHeroName(playerId, heroName);

    removeHeroMovePoints(reservedHeroName);
  end;
  
  local hero = playerId == PLAYER_1 and Biara or Djovanni;
  
  removeHeroMovePoints(hero);
end;

-- ������� ���� ���������� �� �������� ������ ��������
function transferAllArtsToMainHero(playerId)
  print "transferAllArtsToMainHero"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local heroes = RESULT_HERO_LIST[playerId].heroes;
  
  for _, heroName in heroes do
    local reservedHeroName = getReservedHeroName(playerId, heroName);

    if reservedHeroName ~= mainHeroName then
      transferAllArts(reservedHeroName, mainHeroName);
    end;
  end;
end;

-- ������� ���� ����������� �����, ������� � ������ ��� ������ ������
function transferAllArmyToMain(playerId)
  print "transferAllArmyToMain"

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local heroes = RESULT_HERO_LIST[playerId].heroes;
  -- ���� ���� �������� � ������
  local hasArmyIsTown = nil;

  for _, unitData in UNITS[raceId] do
    local countUnitInTown = GetObjectCreatures(townName, unitData.id);
  
    if countUnitInTown > 0 then
      if not hasArmyIsTown then
        hasArmyIsTown = not nil;
      end;
      
      AddObjectCreatures(MAP_GARNISON_FOR_TOWN_STASHE[playerId], unitData.id, countUnitInTown);
      RemoveObjectCreatures(townName, unitData.id, countUnitInTown)
    end;
  end;
  
  if hasArmyIsTown then
    awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."find_additional_army.txt");
    
    SetObjectOwner(MAP_GARNISON_FOR_TOWN_STASHE[playerId], playerId);
    MakeHeroInteractWithObject(mainHeroName, MAP_GARNISON_FOR_TOWN_STASHE[playerId]);
  end;

  -- ���� ��������� �������� � �������������� ������
  for _, heroName in heroes do
    local reservedHeroName = getReservedHeroName(playerId, heroName);

    if reservedHeroName ~= mainHeroName then

      local takedUnitFromTownFromHero = nil;
      
      for _, unitData in UNITS[raceId] do
        if GetObjectCreatures(reservedHeroName, unitData.id) > 0 and not takedUnitFromTownFromHero then
          awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."find_additional_army.txt");
        
          MakeHeroInteractWithObject(mainHeroName, reservedHeroName);

          takedUnitFromTownFromHero = not nil;
        end;
      end;
    end;
  end;
end;

-- ���������� � ������ �������� ������
function prepareForChoiceEnemy(playerId)
  print "prepareForChoiceEnemy"

  while HOTSEAT_STATUS and GetCurrentPlayer() ~= playerId do sleep() end;

  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentMainHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;
  local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;
  
  -- ������ �������� �� ���������
  local NEUTRAL_PLAYERS = {
    [PLAYER_1] = PLAYER_3,
    [PLAYER_2] = PLAYER_4,
  };

  -- �������� ������������ ����� ����� � �������
  local stash = {};
  local tempCaravanName = "caravan"..playerId;

  CreateCaravan(tempCaravanName, NEUTRAL_PLAYERS[playerId], UNDERGROUND, 1, 1, UNDERGROUND, 1, 1);
  stash[1], stash[2], stash[3], stash[4], stash[5], stash[6], stash[7] = GetHeroCreaturesTypes(mainHeroName);

  for i = 1, 7 do
    if stash[i] ~= 0 then
      AddObjectCreatures(tempCaravanName, stash[i], GetHeroCreatures(mainHeroName, stash[i]));
    end;
  end;

  for i = 1, 7 do
    if stash[i] ~= 0 then
      RemoveHeroCreatures(mainHeroName, stash[i], GetHeroCreatures(mainHeroName, stash[i]));
    end;

    if i == 1 then
      AddHeroCreatures(mainHeroName, CREATURE_PHOENIX, 100);
    end;
  end;

  -- ��������� �� ������� ��������� ����������� ����� ��� �����
  local stashEnemies = {};
  local tempOpponentCaravanName = "caravan"..opponentPlayerId;
  local avengerCaravan = "avenger"..playerId;

  -- ��� �������� 1 1 ������, ��� ������ 2 2
  CreateCaravan(avengerCaravan, NEUTRAL_PLAYERS[playerId], UNDERGROUND, 1, 1, UNDERGROUND, 1, 1);

  -- �� ����������� ��������� ��������� �������� �� ����� ���������
  if HasHeroSkill(mainHeroName, PERK_SNIPE_DEAD) then
    if IsObjectExists(tempOpponentCaravanName) then
      stashEnemies[8], stashEnemies[9], stashEnemies[10], stashEnemies[11], stashEnemies[12], stashEnemies[13], stashEnemies[14] = GetObjectCreaturesTypes(tempOpponentCaravanName);
    end;

    stashEnemies[1], stashEnemies[2], stashEnemies[3], stashEnemies[4], stashEnemies[5], stashEnemies[6], stashEnemies[7] = GetHeroCreaturesTypes(opponentMainHeroName);

    for i = 1, 14 do
      if stashEnemies[i] ~= CREATURE_PHOENIX and stashEnemies[i] ~= 0 and stashEnemies[i] ~= nil then
        local avengerCreature;

        for _, unitData in UNITS[opponentRaceId] do
          if unitData.id == stashEnemies[i] then
            avengerCreature = ELF_ENEMY_GARNISONS[opponentRaceId][unitData.lvl];
          end
        end;

        if avengerCreature ~= nil then
          AddObjectCreatures(avengerCaravan, avengerCreature.id, avengerCreature.kol);
        end;
      end;
    end;
  end;

  -- ��� ������������ �������� ��������� �� ���� ��������� ������
  if not HasHeroSkill(mainHeroName, PERK_SNIPE_DEAD) then
    for _, enemyData in ELF_ENEMY_GARNISONS[opponentRaceId] do
      AddObjectCreatures(avengerCaravan, enemyData.id, enemyData.kol);
    end;
  end;

  -- ��������� �������� ����
  sleep();
  SetHeroesExpCoef(0);
  MakeHeroInteractWithObject(mainHeroName, avengerCaravan)
  sleep();
  UpgradeTownBuilding(townName, TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);

  -- ���������� ����� ����� �� ��������� ����
  startThread(function ()
    while GetDate(DAY) ~= 5 do sleep() end;

    for i = 1, 7 do
      if i == 7 then
        RemoveHeroCreatures(%mainHeroName, CREATURE_PHOENIX, GetHeroCreatures(%mainHeroName, CREATURE_PHOENIX));
      end;

      if %stash[i] ~= 0 then
        AddHeroCreatures(%mainHeroName, %stash[i], GetObjectCreatures(%tempCaravanName, %stash[i]));
      end;
    end;
  end)
end;

-- ��������� ���������� ��������, ���������� ��� ��������� ��������������
function getCountResourcesForMiniArts(playerId)
  print "getCountResourcesForMiniArts"
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);
  local RESOURCES_BY_ARTIFICIER = 30;
  
  local result = RESOURCES_BY_ARTIFICIER;
  
  if dictHeroName == HEROES.MAAHIR then
    local MAAHIR_BONUS_RESOURCES = 15;

    result = result + MAAHIR_BONUS_RESOURCES;
  end;
  
  return result;
end;

-- ���������� � ������ ��������������
function prepareForCraftMiniArtifacts(playerId)
  print "prepareForCraftMiniArtifacts"
  
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  
  UpgradeTownBuilding(townName, TOWN_BUILDING_ACADEMY_ARCANE_FORGE);
  
  local countResources = getCountResourcesForMiniArts(playerId);
  
  local allRecourcesTable = {WOOD, ORE, MERCURY, CRYSTAL, SULFUR, GEM};
  
  for _, recourceId in allRecourcesTable do
    SetPlayerResource(playerId, recourceId, countResources);
  end;
end;

-- ����� � �����������
function getNecromancyCoef(heroName)
  print "getNecromancyCoef"

  local coef = 1;
  
  local dictHeroName = getDictionaryHeroName(heroName);
  
  local extraLvl = 0;

  -- ����� � ����������� ��� �������
  if dictHeroName == HEROES.BEREIN then
    local MARKEL_KOEF = 0.017;
    if HasHeroSkill(heroName,HERO_SKILL_MENTORING) then
      extraLvl = 6;
    end;

    coef = coef + MARKEL_KOEF * (GetHeroLevel(heroName) + extraLvl);
  end;

  return coef;
end;

-- �������������� ����� ������� � �����������
function prepareSelectNecromancy(playerId)
  print "prepareSelectNecromancy"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local countAllowStack = GetHeroSkillMastery(mainHeroName, SKILL_NECROMANCY);

  if HasHeroSkill(mainHeroName, NECROMANCER_FEAT_LORD_OF_UNDEAD) then
    countAllowStack = countAllowStack + 1;
  end;
  
  local stash = {
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
  };
  
  local garnisonName = MAP_GARNISON_FOR_NECROMANCY[playerId];

  DenyGarrisonCreaturesTakeAway(garnisonName, 1);
  SetObjectOwner(garnisonName, playerId);
  
  stash[1].id, stash[2].id, stash[3].id, stash[4].id, stash[5].id, stash[6].id, stash[7].id = GetHeroCreaturesTypes(mainHeroName);
  
  local coef = getNecromancyCoef(mainHeroName);

  for _, stachedUnit in stash do
    for _, dictUnit in UNITS[RACES.NECROPOLIS] do
      if stachedUnit.id == dictUnit.id then
        local countUnit = MAP_UNIT_LEVEL_ON_DEFAULT_UNIT_COUNT[dictUnit.lvl] * coef;
        print(countUnit)
        AddObjectCreatures(garnisonName, dictUnit.id, rounding(countUnit));
      end;
    end;
  end;
  
  MakeHeroInteractWithObject(mainHeroName, garnisonName);
  
  local garnisonStash = {
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
    { kol = 0, id = 0 },
  };

  garnisonStash[1].id, garnisonStash[2].id, garnisonStash[3].id, garnisonStash[4].id, garnisonStash[5].id, garnisonStash[6].id, garnisonStash[7].id = GetObjectCreaturesTypes(garnisonName);
  
  for _, stashedArmy in garnisonStash do
    if stashedArmy.id > 0 then
      stashedArmy.kol = GetObjectCreatures(garnisonName, stashedArmy.id);
    end;
  end;
  
  local countTakedUnits = 0;
  
  while countTakedUnits < countAllowStack do
    for _, stashedArmy in garnisonStash do
      if stashedArmy.id > 0 then
        local currentCountUnits = GetObjectCreatures(garnisonName, stashedArmy.id);
        local diffUnits = stashedArmy.kol - currentCountUnits;
        
        -- ���� ��������� ������� � ���������� ����� - ������ �� ���� �����
        if diffUnits > 0 then
          countTakedUnits = countTakedUnits + 1;
          
          stashedArmy.kol = 0;

          -- ���� ����� ������� ����� ������ - �������, ��� �� ����������� �� ��� �����������
          if currentCountUnits > 0 then
            RemoveObjectCreatures(garnisonName, stashedArmy.id, currentCountUnits);
          end;
        end;
      end;
    end;
    
    sleep(1);
  end;
  
  -- �������� ��� ���������� ������ �� ���������
  for _, stashedArmy in garnisonStash do
    if stashedArmy.kol > 0 then
      RemoveObjectCreatures(garnisonName, stashedArmy.id, stashedArmy.kol);
    end;
  end;
end;

-- ������ ����� �������� � ������������ � ��� ��������
function giveRuneResources(playerId)
  print "giveRuneResources"
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  local countLowRes = 6;
  local countHighRes = 6;

  -- �����
  if dictHeroName == HEROES.BRAND then
    -- ���������� ������� ��� ���������� �������� �� 1
    local BRAND_LEVEL_BY_RUNE = 6;
    local brandResCount = floor(GetHeroLevel(mainHeroName)/BRAND_LEVEL_BY_RUNE);

    countLowRes = countLowRes + brandResCount;
    countHighRes = countHighRes + brandResCount;
  end;
  
  -- ���������� ���� �� 3 ������� �������
  if HasHeroSkill(mainHeroName, HERO_SKILL_FINE_RUNE) then
    countLowRes = countLowRes + 2;
    countHighRes = countHighRes + 2;
  end;

  for _, resId in { WOOD, ORE } do
    SetPlayerResource(playerId, resId, countLowRes);
  end;
  
  for _, resId in { MERCURY, CRYSTAL, SULFUR, GEM } do
    SetPlayerResource(playerId, resId, countHighRes);
  end;
end;

ACTIVE_TRAINING_STATUS = nil;

-- ������ ����������� ������
function runRaceAbility(playerId)
  print "runRaceAbility"

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  
  -- ���������� �� ����� ��������
  if raceId == RACES.SYLVAN then
    startThread(prepareForChoiceEnemy, playerId);
  end;

  -- ���������� �� ����� �������
  if raceId == RACES.ACADEMY then
    startThread(prepareForCraftMiniArtifacts, playerId);
  end;

  -- ���������� ������� ������� � �����������
  if raceId == RACES.NECROPOLIS then
    startThread(prepareSelectNecromancy, playerId);
  end;

  -- ����� ���� ������� �� ����
  if raceId == RACES.FORTRESS then
    giveRuneResources(playerId);
  end;

  -- ����� ������ ����� ���������
  if raceId == RACES.HAVEN and not ACTIVE_TRAINING_STATUS then
    ACTIVE_TRAINING_STATUS = not nil;
    
    doFile(PATH_TO_DAY4_SCRIPTS..'modules/training.lua');
  end
end;

-- ����� ������ ���������� � ����������� ��������� �� ������� ����
function showDay4InfoMessage(playerId)
  print "showDay4InfoMessage"
  
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  if raceId == RACES.SYLVAN then
    ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."avenger_info.txt", mainHeroName, playerId, 5);
  end;
  
  if raceId == RACES.ACADEMY then
    ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."create_mini_arts_info.txt", mainHeroName, playerId, 5);
  end;
  
  if raceId == RACES.NECROPOLIS then
    ShowFlyingSign({ PATH_TO_DAY4_MESSAGES.."necromance_info.txt"; eq = GetHeroSkillMastery(mainHeroName, SKILL_NECROMANCY) }, mainHeroName, playerId, 5);
  end;
  
  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;

  if
    raceId ~= RACES.SYLVAN
    and raceId ~= RACES.ACADEMY
    and raceId ~= RACES.NECROPOLIS
    and raceId ~= RACES.HAVEN
  then
    if opponentRaceId == RACES.SYLVAN then
      ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."enemy_avenger_info.txt", mainHeroName, playerId, 5);
    end;
    
    if opponentRaceId == RACES.ACADEMY then
      ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."create_mini_arts_enemy_info.txt", mainHeroName, playerId, 5);
    end;

    if opponentRaceId == RACES.HAVEN then
      ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."training_enemy_info.txt", mainHeroName, playerId, 5);
    end;
  end;
end;

-- �������� �������� ����� ����� �������
function teleportMainHeroToNearTown(playerId)
  print "teleportMainHeroToNearTown"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local position = PLAYERS_TELEPORT_NEAR_TOWN_POSITION[playerId];
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  
  DisableAutoEnterTown(townName, true)
  SetObjectPosition(mainHeroName, position.x, position.y);
  local rotate = playerId == PLAYER_2 and 3.14 or 0;

  MoveCameraForPlayers(playerId, position.x, position.y, GROUND, 50, 1.57, rotate, 0, 0, 1);
--  DisableAutoEnterTown(townName,enable)
  addHeroMovePoints(mainHeroName);
end;

-- ������������� ������ � �� ����� �� �����
function additionalDayBeforeSelectBattlefield()
  print "additionalDayBeforeSelectBattlefield"

  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    
    if raceId == RACES.SYLVAN or raceId == RACES.ACADEMY or raceId == RACES.HAVEN then
      teleportMainHeroToNearTown(playerId);
    else
      preliminaryTeleportHeroToSelectBattlefield(playerId);
    end;
  end;
end;


-- �������� ����� ���������� � ����� ������
-- � ���� ������� ���� ���� ����������� �� ���������� ����
function replaceMainHero(playerId, newHeroName)
  print "replaceMainHero"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- ������
  local stashSkills = {};

  for indexSkill, skillId in ALL_SKILLS_TABLE do
    local masteryLvl = GetHeroSkillMastery(mainHeroName, skillId);

    for _, raceSkillId in ALL_RACES_SKILL_LIST do
      if skillId == raceSkillId then
        masteryLvl = masteryLvl - 1;
      end;
    end;

    stashSkills[indexSkill] = masteryLvl;
  end;

  -- ������
  local mainHeroPerksTable = {};

  for _, perkId in ALL_PERKS_TABLE do
    if HasHeroSkill(mainHeroName, perkId) then
      mainHeroPerksTable[length(mainHeroPerksTable) + 1] = perkId;
    end;
  end;

  -- ���������
  local mainHeroArtsTable = {};

  for _, artData in ALL_ARTS_LIST do
    if HasArtefact(mainHeroName, artData.id) then
      mainHeroArtsTable[length(mainHeroArtsTable) - 1] = artData.id;
    end;
  end;

  -- ��������
  local stashUnits = {
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
  };

  stashUnits[1].id, stashUnits[2].id, stashUnits[3].id, stashUnits[4].id, stashUnits[5].id, stashUnits[6].id, stashUnits[7].id = GetHeroCreaturesTypes(mainHeroName);

  for _, unit in stashUnits do
    if unit.id > 0 then
      unit.kol = GetHeroCreatures(mainHeroName, unit.id);
    end;
  end;

  -- �������
  local warMachinesTable = {};

  for machineId = 1, 4 do
    if HasHeroWarMachine(mainHeroName, machineId) and machineId ~= 2 then
      warMachinesTable[length(warMachinesTable) + 1] = machineId;
    end;
  end;

  -- ���������� ������ � ������� �����
  local x, y = GetObjectPosition(mainHeroName);
  local heroExp = GetHeroStat(mainHeroName, STAT_EXPERIENCE);

  print(mainHeroName)
  print(newHeroName)

  RemoveObject(mainHeroName);
  DeployReserveHero(newHeroName, x, y, GROUND);
  
  repeat sleep() until IsObjectExists(newHeroName);
  
  Trigger(HERO_ADD_SKILL_TRIGGER, newHeroName, 'noop');
  WarpHeroExp(newHeroName, heroExp);

  -- ������� �������
  for skillId, skillMastery in stashSkills do
    if skillMastery > 0 then
      for i = 1, skillMastery do
        GiveHeroSkill(newHeroName, skillId);
      end;
    end;
  end;

  -- ������� �������
  local allPerkExist = not nil
  while allPerkExist do
    allPerkExist = nil
    for _, perkId in mainHeroPerksTable do
      GiveHeroSkill(newHeroName, perkId);
      if HasHeroSkill(newHeroName, perkId) == nil then
        allPerkExist = not nil
      end
      if perkId == RANGER_FEAT_FOREST_GUARD_EMBLEM and GetHeroCreatures(newHeroName, CREATURE_BLADE_SINGER) > 0 then
        RemoveHeroCreatures(newHeroName, CREATURE_BLADE_SINGER, 10);
      end;
      if perkId == HERO_SKILL_DEFEND_US_ALL and GetHeroCreatures(newHeroName, CREATURE_GOBLIN_DEFILER) > 0 then
        RemoveHeroCreatures(newHeroName, CREATURE_GOBLIN_DEFILER, 15);
      end;
    end;
  end;

  -- �������� �����
  for index, unit in stashUnits do
    if unit.id > 0 then
      AddHeroCreatures(newHeroName, unit.id, unit.kol);

      local countAirElem = GetHeroCreatures(newHeroName, CREATURE_AIR_ELEMENTAL);

      if countAirElem > 0 then
        RemoveHeroCreatures(newHeroName, CREATURE_AIR_ELEMENTAL, countAirElem);
      end;
    end;
  end;

  -- �������� ����
  for _, artId in mainHeroArtsTable do
    GiveArtefact(newHeroName, artId);
  end;

  -- �������
  for _, machineId in warMachinesTable do
    GiveHeroWarMachine(newHeroName, machineId);
  end;

  -- ���������� ������� � ���������
  PLAYERS_MAIN_HERO_PROPS[playerId].name = newHeroName;

  refreshMainHeroStats(playerId);
end;

-- ������ �������� ����� �� ����� � �������� �������������
function replaceHeroOnSpecial(playerId)
  print "replaceHeroOnSpecial"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  -- ������
  if dictHeroName == HEROES.ILDAR then
    local lightMagicLevel = GetHeroSkillMastery(mainHeroName, SKILL_LIGHT_MAGIC);

    if lightMagicLevel == 3 then
      local PLAYERS_SUPER_EXPERT_HERO = {
        [PLAYER_1] = "Ildar3",
        [PLAYER_2] = "Ildar4",
      };

      replaceMainHero(playerId, PLAYERS_SUPER_EXPERT_HERO[playerId]);
    end;

    if lightMagicLevel < 3 and lightMagicLevel > 0 then
      Trigger(HERO_ADD_SKILL_TRIGGER, mainHeroName, 'noop');
      GiveHeroSkill(mainHeroName, SKILL_LIGHT_MAGIC);
    end;
  end;

  -- �����
  if dictHeroName == HEROES.SHADWYN then
    local invocationLevel = GetHeroSkillMastery(mainHeroName, SKILL_INVOCATION);

    if invocationLevel == 3 then
      local PLAYERS_SUPER_EXPERT_HERO = {
        [PLAYER_1] = "Shadwyn3",
        [PLAYER_2] = "Shadwyn4",
      };

      replaceMainHero(playerId, PLAYERS_SUPER_EXPERT_HERO[playerId]);
    end;

    if invocationLevel < 3 and invocationLevel > 0 then
      Trigger(HERO_ADD_SKILL_TRIGGER, mainHeroName, 'noop');
      GiveHeroSkill(mainHeroName, SKILL_INVOCATION);
    end;
  end;
  

  -- �������
  if dictHeroName == HEROES.ORLANDO then
    local raceSkillLevel = GetHeroSkillMastery(mainHeroName, SKILL_GATING);

    if raceSkillLevel == 3 then
      local PLAYERS_SUPER_EXPERT_HERO = {
        [PLAYER_1] = "Orlando3",
        [PLAYER_2] = "Orlando4",
      };

      replaceMainHero(playerId, PLAYERS_SUPER_EXPERT_HERO[playerId]);
    end;

-- ������ ��������, ���� ��� � ������� ����������� (������)
--    if raceSkillLevel < 3 and raceSkillLevel > 0 then
--      Trigger(HERO_ADD_SKILL_TRIGGER, mainHeroName, 'noop');
--      GiveHeroSkill(mainHeroName, SKILL_GATING);
--    end;
  end;
end;

-- ������ ������������� �������� � ����� �� ������
function replaceUnitInHero(heroName, targetUnitId, replaceUnitId)
  print "replaceUnitInHero"

  local creatureCount = GetHeroCreatures(heroName, targetUnitId);

  if creatureCount > 0 then
    RemoveHeroCreatures(heroName, targetUnitId, creatureCount);
    AddHeroCreatures(heroName, replaceUnitId, creatureCount);
  end;
end;

-- ������ ������� ������� �� ������� � �������� �������������
-- ��� ����� ������� � ID ������� ���������, ��� �������� >_<
function replaceCommonUnitOnSpecial(playerId)
  print "replaceCommonUnitOnSpecial"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  -- ������
  if dictHeroName == HEROES.TAN then
    replaceUnitInHero(mainHeroName, CREATURE_GENIE, CREATURE_RAKSHASA_RUKH);
    replaceUnitInHero(mainHeroName, CREATURE_DJINN_VIZIER, CREATURE_TITAN);
  end;
  
  -- ������
  if dictHeroName == HEROES.NARHIZ then
    replaceUnitInHero(mainHeroName, CREATURE_MAGI, 907);
    replaceUnitInHero(mainHeroName, CREATURE_COMBAT_MAGE, 908);
  end;

  -- ���� ���� � ��������� (����� ������������ �� ���� ���)
  replaceUnitInHero(mainHeroName, CREATURE_GRIFFIN, CREATURE_ROYAL_GRIFFIN);
end;


-- ����� �����
function day4_scripts()
  print "day4_scripts"

  -- ���� � ���� ������� ���� �������� �� 4 ���� - �������� ��
  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

    removeAllHeroMovePoints(playerId);

    disableAllOtherBuildings(playerId);
    
    SetPlayerResource(playerId, GOLD, 0);

    disableCustomAbilities(mainHeroName);
    
    downgradeTown(playerId);

    transferAllArtsToMainHero(playerId);

    transferAllArmyToMain(playerId);
  end;
  
  for _, playerId in PLAYER_ID_TABLE do
    replaceHeroOnSpecial(playerId);
  end;
  
  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

    replaceCommonUnitOnSpecial(playerId);

    showDay4InfoMessage(playerId);
    
    runRaceAbility(playerId);
  end;

  if needPostponeBattle() then
    -- ��������� ������������� ���� ��� ����������� ������
    additionalDayBeforeSelectBattlefield();
  else
    -- ���������� �� ����� ������
    selectBattlefield();
  end;
end;

-- ����� �����
day4_scripts();
