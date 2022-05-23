-- Скрипты запускающиеся на 4 день

PATH_TO_DAY4_SCRIPTS = GetMapDataPath().."day4/";
PATH_TO_DAY4_MESSAGES = PATH_TO_DAY4_SCRIPTS.."messages/";

doFile(PATH_TO_DAY4_SCRIPTS.."day4_constants.lua");
sleep(1);

-- Вычисление кэфа дипломатии
function getDiplomacyKoef(heroName)
  print 'getDiplomacyKoef'

  local DIPLOMACY_DEFAULT_COEF = 0.4;

  local dictHeroName = getDictionaryHeroName(heroName);

  if dictHeroName == HEROES.ROLF then
    return 2 * DIPLOMACY_DEFAULT_COEF;
  end;

  return DIPLOMACY_DEFAULT_COEF;
end;

-- Отслеживание изменений в армии гарнизона и очищение его
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
  
  -- Странная херня, если существа нет, то берется ИД = 0
  initArmy[1].id, initArmy[2].id, initArmy[3].id, initArmy[4].id, initArmy[5].id, initArmy[6].id, initArmy[7].id = GetObjectCreaturesTypes(garnisonName);

  -- Считаем, сколько существ есть вначале
  for _, army in initArmy do
    if army.id ~= 0 then
      army.kol = GetObjectCreatures(garnisonName, army.id);
    end;
  end;

  -- Следим, чтобы игрок не взял больше
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

  -- Удаляем все, что осталось из гарнизона
  for _, army in initArmy do
    if army.id ~= 0 then
      local currentCountUnits = GetObjectCreatures(garnisonName, army.id);

      if currentCountUnits > 0 then
        RemoveObjectCreatures(garnisonName, army.id, currentCountUnits);
      end;
    end;
  end;
end;

-- Активация навыка "Дипломатия"
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

  -- Выясняем, какие грейды будем предлагать
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

  -- Добавляем в гарнизон армию, возможную для присоединения через дипломатию
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

  -- Отдаем гарнизон игроку и следим за изменением количества существ в нем
  SetObjectOwner(MAP_GARNISON_FOR_DIPLOMACY[playerId], playerId);
  MakeHeroInteractWithObject(heroName, MAP_GARNISON_FOR_DIPLOMACY[playerId]);

  startThread(clearGarnisonOnChangeTread, MAP_GARNISON_FOR_DIPLOMACY[playerId]);
end;

-- Телепорт героя на арену
function teleportPlayerInToBattle(playerId)
  print "teleportPlayerInToBattle"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

  -- Если герой в городе, вытаскиваем его оттуда
  if IsHeroInTown(mainHeroName, townName, 0, 1) then
    local position = PLAYERS_TELEPORT_FROM_TOWN_POSITION[playerId];

    SetObjectPosition(mainHeroName, position.x, position.y);
  end;
  
  -- Телепортируем героя на выбор зоны
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  
  if raceId ~= RACES.SYLVAN and raceId ~= RACES.ACADEMY then
    teleportHeroToSelectBattlefield(mainHeroName);
  end;
end;

-- Отключение всех кастомных способностей
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

-- Уничтожаем в городе все постройки существ, исключая возможность менять их грейд
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

-- Блокировка всех прочих построек игрока
function disableAllOtherBuildings(playerId)
  print "disableAllOtherBuildings"

  local PLAYERS_MARKET = {
    [PLAYER_1] = 'market1',
    [PLAYER_2] = 'market2',
  };

  SetObjectEnabled(PLAYERS_MARKET[playerId], nil);
end;

-- Удаление всех очков передвижения у всех героев игрока
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

-- Перенос всех артефактов от побочных героев главному
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

-- Перенос всех фракционных войск, забытых в городе или прочих героях
function transferAllArmyToMain(playerId)
  print "transferAllArmyToMain"

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local heroes = RESULT_HERO_LIST[playerId].heroes;

  -- Если есть существа в городе
  local takedUnitFromTown = nil;

  for _, unitData in UNITS[raceId] do
    if GetObjectCreatures(townName, unitData.id) > 0 and not takedUnitFromTown then
      awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."find_additional_army.txt");
    
      MakeHeroInteractWithObject(mainHeroName, townName);
    
      takedUnitFromTown = not nil;
    end;
  end;

  -- Если доступные существа в дополнительных героях
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

-- Подготовка к выбору заклятых врагов
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
  
  -- СОхраняем юнитов в памяти
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
  
  print('opponentRaceId')
  print (opponentRaceId)
  
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

  -- Возвращаем юнитов обратно
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

-- Создание портала, телепортирующего на выбор паля для боя
function createPortalToBattleField(playerId)
  print "createPortalToBattleField"
  
  local portalName = PLAYERS_PORTAL_TO_BATTLE_NAME[playerId];
  local portalPosition = PLAYERS_PORTAL_TO_BATTLE_POSITION[playerId];

  SetObjectPosition(portalName, portalPosition.x, portalPosition.y, GROUND);
  Trigger(OBJECT_TOUCH_TRIGGER, portalName, 'teleportHeroToSelectBattlefield');
  SetObjectEnabled(portalName, nil);
  SetDisabledObjectMode(portalName, 2);
end;

-- Телепорт героя для выбора поля боя
function teleportHeroToSelectBattlefield(triggerHero)
  print "teleportHeroToSelectBattlefield"

  local playerId = GetObjectOwner(triggerHero);
  local position = PLAYERS_TELEPORT_TO_BATTLE_POSITION[playerId];

  SetObjectPosition(triggerHero, position.x, position.y);
  OpenCircleFog(48, 45, GROUND, 15, playerId);

  removeHeroMovePoints(triggerHero);
end;

-- Получение количества ресурсов, получаемых для изготовки миниартефактов
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

-- Подготовка к крафту миниартефактов
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

-- Точка входа
function day4_scripts()
  print "day4_scripts"

  -- Если у расы игроков есть действия на 4 день - вызываем их
  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    
    print('RESULT_HERO_LIST[playerId].raceId')
    print(RESULT_HERO_LIST[playerId].raceId)
    
    removeAllHeroMovePoints(playerId);

    disableAllOtherBuildings(playerId);
    
    SetPlayerResource(playerId, GOLD, 0);
    
    -- Дипломатия
    if HasHeroSkill(mainHeroName, PERK_DIPLOMACY) then
      runDiplomacy(mainHeroName);
    end;

    teleportPlayerInToBattle(playerId);

    disableCustomAbilities(mainHeroName);
    
    downgradeTown(playerId);

    disableAllOtherBuildings(playerId);

    transferAllArtsToMainHero(playerId);

    transferAllArmyToMain(playerId);

    -- Отправляем на выбор заклятых
    if raceId == RACES.SYLVAN then
      prepareForChoiceEnemy(playerId);
    end;
    
    -- Отправляем на крафт миников
    if raceId == RACES.ACADEMY then
      prepareForCraftMiniArtifacts(playerId);
    end;
  end;
end;

-- Точка входа
day4_scripts();
