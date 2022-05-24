-- ������� ������������� �� 4 ����

PATH_TO_DAY4_SCRIPTS = GetMapDataPath().."day4/";
PATH_TO_DAY4_MESSAGES = PATH_TO_DAY4_SCRIPTS.."messages/";

doFile(PATH_TO_DAY4_SCRIPTS.."day4_constants.lua");
sleep(1);

-- ���������� ���� ����������
function getDiplomacyKoef(heroName)
  print 'getDiplomacyKoef'

  local DIPLOMACY_DEFAULT_COEF = 0.4;

  local dictHeroName = getDictionaryHeroName(heroName);

  if dictHeroName == HEROES.ROLF then
    return 2 * DIPLOMACY_DEFAULT_COEF;
  end;

  return DIPLOMACY_DEFAULT_COEF;
end;

-- ������������ ��������� � ����� ��������� � �������� ���
function clearGarnisonOnChangeTread(garnisonName)
  print 'clearGarnisonOnChangeTread'
  
  local initArmy = {
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
  };
  
  -- �������� �����, ���� �������� ���, �� ������� �� = 0
  initArmy[1].id, initArmy[2].id, initArmy[3].id, initArmy[4].id, initArmy[5].id, initArmy[6].id, initArmy[7].id = GetObjectCreaturesTypes(garnisonName);

  -- �������, ������� ������� ���� �������
  for _, army in initArmy do
    if army.id ~= 0 then
      army.kol = GetObjectCreatures(garnisonName, army.id);
    end;
  end;

  -- ������, ����� ����� �� ���� ������
  local playerTakeArmy = nil;

  while not playerTakeArmy do
    for _, army in initArmy do
      if army.id ~= 0 then
        local currentCountUnits = GetObjectCreatures(garnisonName, army.id);

        if currentCountUnits < army.kol then
          playerTakeArmy = not nil;
        end;
      end;
    end;

    sleep(1);
  end;

  -- ������� ���, ��� �������� �� ���������
  for _, army in initArmy do
    if army.id ~= 0 then
      local currentCountUnits = GetObjectCreatures(garnisonName, army.id);

      if currentCountUnits > 0 then
        RemoveObjectCreatures(garnisonName, army.id, currentCountUnits);
      end;
    end;
  end;
end;

-- ��������� ������ "����������"
function runDiplomacy(heroName)
  print 'runDiplomacy'

  local playerId = GetObjectOwner(heroName);

  awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."diplomacy.txt");

  local stashArmy = {
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
  };

  stashArmy[1].id1, stashArmy[2].id1, stashArmy[3].id1, stashArmy[4].id1, stashArmy[5].id1, stashArmy[6].id1, stashArmy[7].id1 = GetHeroCreaturesTypes(heroName);

  -- ��������, ����� ������ ����� ����������
  for _, stashItem in stashArmy do
    if stashItem.id1 ~= nil then
      for gradeCreatureId, altGradeCreatureId in MAP_CREATURES_ON_GRADE do
        if stashItem.id1 == gradeCreatureId and GetHeroCreatures(heroName, gradeCreatureId) < GetHeroCreatures(heroName, altGradeCreatureId) then
          stashItem.id2 = altGradeCreatureId;
        end;

        if stashItem.id1 == altGradeCreatureId then
          stashItem.id2 = gradeCreatureId;
        end;
      end;
    end;
  end;

  local diplomacyKoef = getDiplomacyKoef(heroName);

  -- ��������� � �������� �����, ��������� ��� ������������� ����� ����������
  DenyGarrisonCreaturesTakeAway(MAP_GARNISON_FOR_DIPLOMACY[playerId], not nil);

  for _, stashItem in stashArmy do
    for _, raceId in RACES do
      for _, unitData in UNITS[raceId] do
        if stashItem.id1 == unitData.id and stashItem.id2 ~= nil then
          stashItem.kol = diplomacyKoef * unitData.kol;
          AddObjectCreatures(MAP_GARNISON_FOR_DIPLOMACY[playerId], stashItem.id2, stashItem.kol);
        end;
      end;
    end;
  end;

  -- ������ �������� ������ � ������ �� ���������� ���������� ������� � ���
  SetObjectOwner(MAP_GARNISON_FOR_DIPLOMACY[playerId], playerId);
  MakeHeroInteractWithObject(heroName, MAP_GARNISON_FOR_DIPLOMACY[playerId]);

  startThread(clearGarnisonOnChangeTread, MAP_GARNISON_FOR_DIPLOMACY[playerId]);
end;

-- �������� ����� �� �����
function teleportPlayerInToBattle(playerId)
  print "teleportPlayerInToBattle"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

  -- ���� ����� � ������, ����������� ��� ������
  if IsHeroInTown(mainHeroName, townName, 0, 1) then
    local position = PLAYERS_TELEPORT_FROM_TOWN_POSITION[playerId];

    SetObjectPosition(mainHeroName, position.x, position.y);
  end;
  
  -- ������������� ����� �� ����� ����
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  
  if raceId ~= RACES.SYLVAN and raceId ~= RACES.ACADEMY then
    teleportHeroToSelectBattlefield(mainHeroName);
  end;
end;

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
  local takedUnitFromTown = nil;

  for _, unitData in UNITS[raceId] do
    if GetObjectCreatures(townName, unitData.id) > 0 and not takedUnitFromTown then
      awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."find_additional_army.txt");
    
      MakeHeroInteractWithObject(mainHeroName, townName);
    
      takedUnitFromTown = not nil;
    end;
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
  
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;
  local stash = {
    { id = 0, kol = 0 },
    { id = 0, kol = 0 },
    { id = 0, kol = 0 },
    { id = 0, kol = 0 },
    { id = 0, kol = 0 },
    { id = 0, kol = 0 },
    { id = 0, kol = 0 },
  };
  
  awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."avenger_info.txt");
  
  if opponentRaceId ~= RACES.SYLVAN and opponentRaceId ~= RACES.ACADEMY then
    local enemyMainHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;
  
    ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."enemy_avenger_info.txt", enemyMainHeroName, opponentPlayerId, 5.0);
  end;
  
  UpgradeTownBuilding(townName, TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  
  -- ��������� ������ � ������
  stash[1].id, stash[2].id, stash[3].id, stash[4].id, stash[5].id, stash[6].id, stash[7].id = GetHeroCreaturesTypes(mainHeroName);
  for index, stachedUnit in stash do
    if stachedUnit.id > 0 then
      stachedUnit.kol = GetHeroCreatures(mainHeroName, stachedUnit.id);
      RemoveHeroCreatures(mainHeroName, stachedUnit.id, stachedUnit.kol);
      sleep(1);

      if index == 1 then
        AddHeroCreatures(mainHeroName, CREATURE_PHOENIX, 10);
      end;
    end;
  end;
  
  local avengersEnemies = ELF_ENEMY_GARNISONS[opponentRaceId];
  
  StartCombat(
    mainHeroName,
    nil,
    7,
    avengersEnemies[1].id, avengersEnemies[1].kol,
    avengersEnemies[2].id, avengersEnemies[2].kol,
    avengersEnemies[3].id, avengersEnemies[3].kol,
    avengersEnemies[4].id, avengersEnemies[4].kol,
    avengersEnemies[5].id, avengersEnemies[5].kol,
    avengersEnemies[6].id, avengersEnemies[6].kol,
    avengersEnemies[7].id, avengersEnemies[7].kol,
    nil,
    'noop',
    nil,
    not nil
  );

  sleep(20);

  -- ���������� ������ �������
  for index, stachedUnit in stash do
    if stachedUnit.id > 0 then
      AddHeroCreatures(mainHeroName, stachedUnit.id, stachedUnit.kol);
      
      local countPhoenix = GetHeroCreatures(mainHeroName, CREATURE_PHOENIX);

      if countPhoenix > 0 then
        RemoveHeroCreatures(mainHeroName, CREATURE_PHOENIX, countPhoenix);
      end;
    end;
  end;
  
  createPortalToBattleField(playerId)
  
  addHeroMovePoints(mainHeroName);
end;

-- �������� �������, ���������������� �� ����� ���� ��� ���
function createPortalToBattleField(playerId)
  print "createPortalToBattleField"
  
  local portalName = PLAYERS_PORTAL_TO_BATTLE_NAME[playerId];
  local portalPosition = PLAYERS_PORTAL_TO_BATTLE_POSITION[playerId];

  SetObjectPosition(portalName, portalPosition.x, portalPosition.y, GROUND);
  Trigger(OBJECT_TOUCH_TRIGGER, portalName, 'teleportHeroToSelectBattlefield');
  SetObjectEnabled(portalName, nil);
  SetDisabledObjectMode(portalName, 2);
end;

-- �������� ����� ��� ������ ���� ���
function teleportHeroToSelectBattlefield(triggerHero)
  print "teleportHeroToSelectBattlefield"

  local playerId = GetObjectOwner(triggerHero);
  local position = PLAYERS_TELEPORT_TO_BATTLE_POSITION[playerId];

  SetObjectPosition(triggerHero, position.x, position.y);
  OpenCircleFog(48, 45, GROUND, 15, playerId);

  removeHeroMovePoints(triggerHero);
end;

-- ��������� ���������� ��������, ���������� ��� ��������� ��������������
function getCountResourcesForMiniArts(playerId)
  print "getCountResourcesForMiniArts"
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);
  local RESOURCES_BY_ARTIFICIER = 10;
  
  local result = GetHeroSkillMastery(mainHeroName, SKILL_ARTIFICIER) * RESOURCES_BY_ARTIFICIER;
  
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
  
  awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."create_mini_arts_info.txt");
  
  if opponentRaceId ~= RACES.SYLVAN and opponentRaceId ~= RACES.ACADEMY then
    local opponentPlayerId = PLAYERS_OPPONENT[playerId];
    local enemyMainHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

    ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."create_mini_arts_enemy_info.txt", enemyMainHeroName, opponentPlayerId, 5.0);
  end;
  
  local countResources = getCountResourcesForMiniArts(playerId);
  
  local allRecourcesTable = {WOOD, ORE, MERCURY, CRYSTAL, SULFUR, GEM};
  
  for _, recourceId in allRecourcesTable do
    SetPlayerResource(playerId, recourceId, countResources);
  end;
  
  createPortalToBattleField(playerId);
end;

-- ����� � �����������
function getNecromancyCoef(heroName)
  print "getNecromancyCoef"

  local coef = 1;
  
  local dictHeroName = getDictionaryHeroName(heroName);

  -- ����� � ����������� ��� �������
  if dictHeroName == HEROES.BEREIN then
    local MARKEL_KOEF = 0.02;

    coef = coef + MARKEL_KOEF * GetHeroLevel(heroName);
  end;
  
  -- ����� �� ���������� �������
  if HasHeroSkill(heroName, NECROMANCER_FEAT_LORD_OF_UNDEAD) then
    local LORD_OF_UNDEAD_KOEF = 1.301;
    
    coef = coef * LORD_OF_UNDEAD_KOEF;
  end;
  
  return coef;
end;

-- �������������� ����� ������� � �����������
function prepareSelectNecromancy(playerId)
  print "prepareSelectNecromancy"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local countAllowStack = GetHeroSkillMastery(mainHeroName, SKILL_NECROMANCY);
  
  awaitMessageBoxForPlayers(playerId, { PATH_TO_DAY4_MESSAGES.."necromance_info.txt"; eq = countAllowStack });
  
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

        AddObjectCreatures(garnisonName, dictUnit.id, countUnit);
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
          
          -- ���� ���� ������ �������
          if HasHeroSkill(mainHeroName, PERK_NO_REST_FOR_THE_WICKED) then
            -- ���� ����� ������� ����� �������
            local altGradeId = MAP_NECRO_UNIT_ON_GRADE_UNIT[stashedArmy.id];

            if altGradeId ~= nil and GetHeroCreatures(mainHeroName, altGradeId) > 0 then
              AddHeroCreatures(mainHeroName, altGradeId, diffUnits);
              RemoveObjectCreatures(garnisonName, altGradeId, GetObjectCreatures(garnisonName, altGradeId));
              
              -- ������� ���� ������� ��������������� ������, ���� �� ������� ����� ������ �������
              for _, stash in garnisonStash do
                if stash.id == altGradeId then
                  stash.kol = 0;
                end;
              end;
            end;
            
            -- ���� ����� �������������� ����� �������
            local gradeId = MAP_NECRO_GRADE_UNIT_ON_UNIT[stashedArmy.id];

            if gradeId ~= nil and GetHeroCreatures(mainHeroName, gradeId) > 0 then
              AddHeroCreatures(mainHeroName, gradeId, diffUnits);
              RemoveObjectCreatures(garnisonName, gradeId, GetObjectCreatures(garnisonName, gradeId));

              -- ������� ���� ������� ��������������� ������, ���� �� ������� ����� ������ �������
              for _, stash in garnisonStash do
                if stash.id == gradeId then
                  stash.kol = 0;
                end;
              end;
            end;
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

-- ������ ������������� �������� � ����� �� ������
function replaceUnitInHero(heroName, targetUnitId, replaceUnitId)
  print "replaceUnitInHero"

  local countGenie = GetHeroCreatures(heroName, targetUnitId);

  if countGenie > 0 then
    RemoveHeroCreatures(heroName, targetUnitId, countGenie);
    -- ID �������� �� ID ������ � �������������� >_<
    AddHeroCreatures(heroName, replaceUnitId, countGenie);
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
  
  -- ���������� �����
  if HasHeroSkill(mainHeroName, PERK_LUCKY_STRIKE) then
    replaceUnitInHero(mainHeroName, CREATURE_GREMLIN, CREATURE_OBSIDIAN_GARGOYLE);
    replaceUnitInHero(mainHeroName, CREATURE_STORM_LORD, CREATURE_ARCH_MAGI);
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
    stashSkills[indexSkill] = GetHeroSkillMastery(mainHeroName, skillId);
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
  
  RemoveObject(mainHeroName);
  DeployReserveHero(newHeroName, x, y, GROUND);
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
  for _, perkId in mainHeroPerksTable do
    GiveHeroSkill(newHeroName, perkId);
    
    if perkId == RANGER_FEAT_FOREST_GUARD_EMBLEM and GetHeroCreatures(newHeroName, CREATURE_BLADE_SINGER) > 0 then
      RemoveHeroCreatures(newHeroName, CREATURE_BLADE_SINGER, 10);
    end;
    if perkId == HERO_SKILL_DEFEND_US_ALL and GetHeroCreatures(newHeroName, CREATURE_GOBLIN_DEFILER) > 0 then
      RemoveHeroCreatures(newHeroName, CREATURE_GOBLIN_DEFILER, 15);
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
      local PLAYERS_ADD_ALARON = {
        [PLAYER_1] = "Ildar3",
        [PLAYER_2] = "Ildar4",
      };
    
      replaceMainHero(playerId, PLAYERS_ADD_ALARON[playerId]);
    end;

    if lightMagicLevel < 3 and lightMagicLevel > 0 then
      Trigger(HERO_ADD_SKILL_TRIGGER, mainHeroName, 'noop');
      GiveHeroSkill(mainHeroName, SKILL_LIGHT_MAGIC);
    end;
  end;
end;

-- ����� �����
function day4_scripts()
  print "day4_scripts"

  -- ���� � ���� ������� ���� �������� �� 4 ���� - �������� ��
  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    
    removeAllHeroMovePoints(playerId);

    disableAllOtherBuildings(playerId);
    
    SetPlayerResource(playerId, GOLD, 0);
    
    -- ����������
    if HasHeroSkill(mainHeroName, PERK_DIPLOMACY) then
      runDiplomacy(mainHeroName);
    end;

    teleportPlayerInToBattle(playerId);

    disableCustomAbilities(mainHeroName);
    
    downgradeTown(playerId);

    disableAllOtherBuildings(playerId);

    transferAllArtsToMainHero(playerId);

    transferAllArmyToMain(playerId);

    replaceCommonUnitOnSpecial(playerId);
    
    replaceHeroOnSpecial(playerId);

    -- ���������� �� ����� ��������
    if raceId == RACES.SYLVAN then
      prepareForChoiceEnemy(playerId);
    end;
    
    -- ���������� �� ����� �������
    if raceId == RACES.ACADEMY then
      prepareForCraftMiniArtifacts(playerId);
    end;
    
    -- ���������� ������� ������� � �����������
    if raceId == RACES.NECROPOLIS then
      prepareSelectNecromancy(playerId);
    end;
  end;
end;

-- ����� �����
day4_scripts();
