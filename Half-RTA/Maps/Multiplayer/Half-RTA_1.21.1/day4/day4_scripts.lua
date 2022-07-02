-- Скрипты запускающиеся на 4 день

PATH_TO_DAY4_SCRIPTS = GetMapDataPath().."day4/";
PATH_TO_DAY4_MESSAGES = PATH_TO_DAY4_SCRIPTS.."messages/";

doFile(PATH_TO_DAY4_SCRIPTS.."day4_constants.lua");
sleep(1);

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
  
  addHeroMovePoints(mainHeroName);
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
  
  local countResources = getCountResourcesForMiniArts(playerId);
  
  local allRecourcesTable = {WOOD, ORE, MERCURY, CRYSTAL, SULFUR, GEM};
  
  for _, recourceId in allRecourcesTable do
    SetPlayerResource(playerId, recourceId, countResources);
  end;
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  addHeroMovePoints(mainHeroName);
end;

-- Бонус к некромантии
function getNecromancyCoef(heroName)
  print "getNecromancyCoef"

  local coef = 1;
  
  local dictHeroName = getDictionaryHeroName(heroName);

  -- Бонус к некромантии для Маркела
  if dictHeroName == HEROES.BEREIN then
    local MARKEL_KOEF = 0.02;

    coef = coef + MARKEL_KOEF * GetHeroLevel(heroName);
  end;
  
  -- Бонус за повелителя мертвых
  if HasHeroSkill(heroName, NECROMANCER_FEAT_LORD_OF_UNDEAD) then
    local LORD_OF_UNDEAD_KOEF = 1.301;
    
    coef = coef * LORD_OF_UNDEAD_KOEF;
  end;
  
  return coef;
end;

-- Подготавливаем выбор существ с некромантии
function prepareSelectNecromancy(playerId)
  print "prepareSelectNecromancy"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local countAllowStack = GetHeroSkillMastery(mainHeroName, SKILL_NECROMANCY);
  
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
        
        -- Если появилась разница в количестве войск - значит ее взял игрок
        if diffUnits > 0 then
          countTakedUnits = countTakedUnits + 1;
          
          stashedArmy.kol = 0;

          -- Если игрок отделил часть юнитов - считаем, что он использовал на них некромантию
          if currentCountUnits > 0 then
            RemoveObjectCreatures(garnisonName, stashedArmy.id, currentCountUnits);
          end;
          
          -- Если есть вечное рабство
          if HasHeroSkill(mainHeroName, PERK_NO_REST_FOR_THE_WICKED) then
            -- Если взяли обычный грейд существ
            local altGradeId = MAP_NECRO_UNIT_ON_GRADE_UNIT[stashedArmy.id];

            if altGradeId ~= nil and GetHeroCreatures(mainHeroName, altGradeId) > 0 then
              AddHeroCreatures(mainHeroName, altGradeId, diffUnits);
              RemoveObjectCreatures(garnisonName, altGradeId, GetObjectCreatures(garnisonName, altGradeId));
              
              -- Убираем всех существ альтернативного грейда, если их забрали через вечное рабство
              for _, stash in garnisonStash do
                if stash.id == altGradeId then
                  stash.kol = 0;
                end;
              end;
            end;
            
            -- Если взяли альтернативный грейд существ
            local gradeId = MAP_NECRO_GRADE_UNIT_ON_UNIT[stashedArmy.id];

            if gradeId ~= nil and GetHeroCreatures(mainHeroName, gradeId) > 0 then
              AddHeroCreatures(mainHeroName, gradeId, diffUnits);
              RemoveObjectCreatures(garnisonName, gradeId, GetObjectCreatures(garnisonName, gradeId));

              -- Убираем всех существ альтернативного грейда, если их забрали через вечное рабство
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
  
  -- Забираем все оставшиеся войска из гарнизона
  for _, stashedArmy in garnisonStash do
    if stashedArmy.kol > 0 then
      RemoveObjectCreatures(garnisonName, stashedArmy.id, stashedArmy.kol);
    end;
  end;
end;

-- Выдача гному ресурсов в соответствии с его навыками
function giveRuneResources(playerId)
  print "giveRuneResources"
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  local countLowRes = 7;
  local countHighRes = 5;

  -- Бранд
  if dictHeroName == HEROES.BRAND then
    -- Количество уровней для увеличения ресурсов на 1
    local BRAND_LEVEL_BY_RUNE = 6;
    local brandResCount = floor(GetHeroLevel(mainHeroName)/BRAND_LEVEL_BY_RUNE);

    countLowRes = countLowRes + brandResCount;
    countHighRes = countHighRes + brandResCount;
  end;
  
  -- Завершенка дает по 3 каждого ресурса
  if HasHeroSkill(mainHeroName, HERO_SKILL_FINE_RUNE) then
    countLowRes = countLowRes + 3;
    countHighRes = countHighRes + 3;
  end;

  for _, resId in { WOOD, ORE } do
    SetPlayerResource(playerId, resId, countLowRes);
  end;
  
  for _, resId in { MERCURY, CRYSTAL, SULFUR, GEM } do
    SetPlayerResource(playerId, resId, countHighRes);
  end;
end;

-- Запуск фракционных плюшек
function runRaceAbility(playerId)
  print "runRaceAbility"

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  
  -- Отправляем на выбор заклятых
  if raceId == RACES.SYLVAN then
    startThread(prepareForChoiceEnemy, playerId);
  end;

  -- Отправляем на крафт миников
  if raceId == RACES.ACADEMY then
    startThread(prepareForCraftMiniArtifacts, playerId);
  end;

  -- Предлагаем выбрать существ с некромантии
  if raceId == RACES.NECROPOLIS then
    startThread(prepareSelectNecromancy, playerId);
  end;

  -- Гному даем ресурсы на руны
  if raceId == RACES.FORTRESS then
    giveRuneResources(playerId);
  end;
end;

-- Телепорт главного героя перед городом
function teleportMainHeroToNearTown(playerId)
  print "teleportMainHeroToNearTown"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local position = PLAYERS_TELEPORT_NEAR_TOWN_POSITION[playerId];

  SetObjectPosition(mainHeroName, position.x, position.y);
  
  local rotate = playerId == PLAYER_2 and 3.14 or 0;
  
  MoveCameraForPlayers(playerId, position.x, position.y, GROUND, 50, 1.57, rotate, 0, 0, 1);
end;

-- Показ игроку информацию о необходимых действиях на текущий день
function showDay4InfoMessage(playerId)
  print "showDay4InfoMessage"
  
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  
  if raceId == RACES.SYLVAN then
    awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."avenger_info.txt");
  end;
  
  if raceId == RACES.ACADEMY then
    awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."create_mini_arts_info.txt");
  end;
  
  if raceId == RACES.NECROPOLIS then
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    
    awaitMessageBoxForPlayers(playerId, { PATH_TO_DAY4_MESSAGES.."necromance_info.txt"; eq = GetHeroSkillMastery(mainHeroName, SKILL_NECROMANCY) });
  end;
  
  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;

  if raceId ~= RACES.SYLVAN and raceId ~= RACES.ACADEMY and raceId ~= RACES.NECROPOLIS then
    if opponentRaceId == RACES.SYLVAN then
      awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."enemy_avenger_info.txt");
    end;
    
    if opponentRaceId == RACES.ACADEMY then
      awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."create_mini_arts_enemy_info.txt");
    end;
  end;
  
  if (
    raceId ~= RACES.SYLVAN and raceId ~= RACES.ACADEMY and raceId ~= RACES.NECROPOLIS
    and opponentRaceId ~= RACES.SYLVAN and opponentRaceId ~= RACES.ACADEMY
  ) then
    awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."please_skip_turn.txt");
  end
end;

-- Точка входа
function day4_scripts()
  print "day4_scripts"

  -- Если у расы игроков есть действия на 4 день - вызываем их
  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

    removeAllHeroMovePoints(playerId);

    disableAllOtherBuildings(playerId);
    
    SetPlayerResource(playerId, GOLD, 0);

    disableCustomAbilities(mainHeroName);
    
    downgradeTown(playerId);

    transferAllArtsToMainHero(playerId);

    transferAllArmyToMain(playerId);
    
    teleportMainHeroToNearTown(playerId);
    
    showDay4InfoMessage(playerId);
    
    runRaceAbility(playerId);
  end;
end;

-- Точка входа
day4_scripts();
