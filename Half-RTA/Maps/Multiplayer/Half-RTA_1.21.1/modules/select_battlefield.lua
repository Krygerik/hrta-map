-- Модуль предназначен для выбора поля боя

PATH_TO_MODULES = GetMapDataPath().."modules/";
PATH_TO_MODULES_MESSAGES = PATH_TO_MODULES.."messages/";

-- Место для телепортации героя на выбор зон
PLAYERS_TELEPORT_TO_BATTLE_POSITION = {
  [PLAYER_1] = { x = 35, y = 46 },
  [PLAYER_2] = { x = 60, y = 46 },
};

-- Элементы декора на выборе поля для боя
PLAYERS_BOAT = {
  [PLAYER_1] = 'boat1',
  [PLAYER_2] = 'boat2',
};

PLAYERS_TOWER = {
  [PLAYER_1] = 'tow1',
  [PLAYER_2] = 'tow2',
};

-- Был ли совершен предварительный телепорт героя на поляну
HAS_BEEN_PRELIMINARY_TELEPORT = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

function getHasBeenPreliminaryTeleport()
  print "getHasBeenPreliminaryTeleport"
  
  for _, hasBeen in HAS_BEEN_PRELIMINARY_TELEPORT do
    if hasBeen then
      return not nil;
    end;
  end;
  
  return nil;
end;

-- Соотношение расы на регион родной земли с маленькими препятствиями
MAP_RACE_ON_NATIVE_REGIONS = {
  [RACES.HAVEN] = 'land_block_race1',
  [RACES.INFERNO] = 'land_block_race2',
  [RACES.NECROPOLIS] = 'land_block_race3',
  [RACES.SYLVAN] = 'land_block_race1',
  [RACES.ACADEMY] = 'land_block_race5',
  [RACES.DUNGEON] = 'land_block_race6',
  [RACES.FORTRESS] = 'land_block_race7',
  [RACES.STRONGHOLD] = 'land_block_race8',
};

-- Соотношение расы на регион родной земли с большими препятствиями
MAP_RACE_ON_ADDITIONAL_REGIONS = {
  [RACES.HAVEN] = 'land_block1',
  [RACES.INFERNO] = 'land_block2',
  [RACES.NECROPOLIS] = 'land_block3',
  [RACES.SYLVAN] = 'land_block1',
  --[RACES.ACADEMY] = '',
  [RACES.DUNGEON] = 'land_block6',
  [RACES.FORTRESS] = 'land_block7',
  --[RACES.STRONGHOLD] = '',
};

-- Соотношение существ к их грейдам
MAP_CREATURES_ON_GRADE = {
  -- Стандартные существа из замка
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

  -- Специальные существа, замененные навыками или или специализациями
  [CREATURE_ROYAL_GRIFFIN] = CREATURE_BATTLE_GRIFFIN, -- Гриффоны без бага?
  [CREATURE_RAKSHASA_RUKH] = CREATURE_TITAN, -- Джины Джалиба
};

-- Гарнизоны для сражения с эльфом
ELF_ENEMY_GARNISONS = {
  [RACES.HAVEN] = {
    { kol = 44, id =  1 },
    { kol = 24, id =  3 },
    { kol = 20, id =  5 },
    { kol = 10, id =  7 },
    { kol =  6, id =  9 },
    { kol =  4, id = 11 },
    { kol =  2, id = 13 },
  },
  [RACES.INFERNO] = {
    { kol = 32, id = 15 },
    { kol = 30, id = 17 },
    { kol = 16, id = 19 },
    { kol = 10, id = 21 },
    { kol =  6, id = 23 },
    { kol =  4, id =136 },
    { kol =  2, id = 27 },
  },
  [RACES.NECROPOLIS] = {
    { kol = 40, id = 29 },
    { kol = 30, id = 31 },
    { kol = 18, id = 34 },
    { kol = 10, id = 35 },
    { kol =  6, id = 37 },
    { kol =  4, id = 39 },
    { kol =  2, id = 41 },
  },
  [RACES.SYLVAN] = {
    { kol = 30, id = 43 },
    { kol = 18, id = 45 },
    { kol = 14, id = 47 },
    { kol =  8, id = 49 },
    { kol =  6, id = 51 },
    { kol =  4, id = 53 },
    { kol =  2, id = 55 },
  },
  [RACES.ACADEMY] = {
    { kol = 40, id = 57 },
    { kol = 28, id = 59 },
    { kol = 18, id = 61 },
    { kol = 10, id = 63 },
    { kol =  6, id = 65 },
    { kol =  4, id = 67 },
    { kol =  2, id = 69 },
  },
  [RACES.DUNGEON] = {
    { kol = 14, id = 92 },
    { kol = 10, id = 73 },
    { kol = 12, id = 75 },
    { kol =  8, id = 77 },
    { kol =  6, id = 79 },
    { kol =  4, id = 81 },
    { kol =  2, id = 83 },
  },
  [RACES.FORTRESS] = {
    { kol = 36, id =  71 },
    { kol = 28, id =  94 },
    { kol = 14, id =  96 },
    { kol = 12, id =  98 },
    { kol =  6, id = 100 },
    { kol =  4, id = 102 },
    { kol =  2, id = 105 },
  },
  [RACES.STRONGHOLD] = {
    { kol = 50, id = 117 },
    { kol = 28, id = 119 },
    { kol = 22, id = 121 },
    { kol = 10, id = 123 },
    { kol = 10, id = 125 },
    { kol =  4, id = 127 },
    { kol =  2, id = 129 },
  },
};

-- Соотношение игроков на Id гарнизонов для дипломатии
MAP_GARNISON_FOR_DIPLOMACY = {
  [PLAYER_1] = 'Garrison3',
  [PLAYER_2] = 'Garrison4',
};

-- Запрет выбора родных земель
function blockFriendlyBattlefield()
  print "blockFriendlyBattlefield"

  local choisePlayerId = getSelectedBattlefieldPlayerId();
  local choisePlayerRaceId = RESULT_HERO_LIST[choisePlayerId].raceId;
  local choiseHeroName = PLAYERS_MAIN_HERO_PROPS[choisePlayerId].name;
  local choiseDictHeroName = getDictionaryHeroName(choiseHeroName);

  -- Блокируем родные поляны с маленькими препятствиями
  for _, playerId in PLAYER_ID_TABLE do
    local playerRaceId = RESULT_HERO_LIST[playerId].raceId;

    -- Т.к. через их поля надо проходить, блокировать их низя :(
    if playerRaceId ~= RACES.STRONGHOLD and playerRaceId ~= RACES.ACADEMY then
      SetRegionBlocked(MAP_RACE_ON_NATIVE_REGIONS[playerRaceId], not nil);
    end;
  end;

  -- Придурку-Нибросу разрешаем посещать его родную поляну
  if choiseDictHeroName == HEROES.JAZAZ then
    SetRegionBlocked(MAP_RACE_ON_NATIVE_REGIONS[RACES.INFERNO], nil);
  end;

  local opponentPlayerId = PLAYERS_OPPONENT[choisePlayerId];
  local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

  -- При отсутствии "Нахождения пути" или наличии его у обоих игроков, выбрать поляну с большими препятствиями невозможно
  if (
    HasHeroSkill(choiseHeroName, PERK_PATHFINDING) == nil
    or (HasHeroSkill(choiseHeroName, PERK_PATHFINDING) and HasHeroSkill(opponentHeroName, PERK_PATHFINDING))
  ) then
    for _, region in MAP_RACE_ON_ADDITIONAL_REGIONS do
      SetRegionBlocked(region, not nil);
    end;

    -- Каменные залы
    SetRegionBlocked('land_block0', not nil);
  end;

  -- Если у игрока есть "Нахождение пути", блочим родные земельки с большими препятствиями
  -- Также разрешаем выбрать родные земли с маленькими препятствиями
  if HasHeroSkill(choiseHeroName, PERK_PATHFINDING) and HasHeroSkill(opponentHeroName, PERK_PATHFINDING) == nil then
    SetRegionBlocked(MAP_RACE_ON_NATIVE_REGIONS[choisePlayerRaceId], nil);

    for _, playerId in PLAYER_ID_TABLE do
      local playerRaceId = RESULT_HERO_LIST[playerId].raceId;

      if playerRaceId ~= RACES.STRONGHOLD and playerRaceId ~= RACES.ACADEMY then
        SetRegionBlocked(MAP_RACE_ON_ADDITIONAL_REGIONS[playerRaceId], not nil);
      end;
    end;
  end;
end;

-- Подготовка места для выбора поля боя
function prepareSelectBattlefield()
  print "prepareSelectBattlefield"

  local choicePlayerId = getSelectedBattlefieldPlayerId();

  -- Если поле выбирает красный игрок, то рокируем их
  if choicePlayerId == PLAYER_1 then
    local opponentPlayerId = PLAYERS_OPPONENT[choicePlayerId];
    local playerPosition = PLAYERS_TELEPORT_TO_BATTLE_POSITION[choicePlayerId];
    local opponentPosition = PLAYERS_TELEPORT_TO_BATTLE_POSITION[opponentPlayerId];

    -- Меняем их точки для телепортации
    PLAYERS_TELEPORT_TO_BATTLE_POSITION[choicePlayerId] = opponentPosition;
    PLAYERS_TELEPORT_TO_BATTLE_POSITION[opponentPlayerId] = playerPosition;

    -- Меняем их декор
    PLAYERS_BOAT[choicePlayerId], PLAYERS_BOAT[opponentPlayerId] = PLAYERS_BOAT[opponentPlayerId], PLAYERS_BOAT[choicePlayerId];
    PLAYERS_TOWER[choicePlayerId], PLAYERS_TOWER[opponentPlayerId] = PLAYERS_TOWER[opponentPlayerId], PLAYERS_TOWER[choicePlayerId];
  end;

  blockFriendlyBattlefield();
end;

-- Предварительный телепорт героя на выбор поляны
function preliminaryTeleportHeroToSelectBattlefield(playerId)
  print "preliminaryTeleportHeroToSelectBattlefield"
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  prepareSelectBattlefield();
  
  teleportHeroToSelectBattlefield(playerId);

  ShowFlyingSign(PATH_TO_MODULES_MESSAGES.."please_skip_turn.txt", mainHeroName, playerId, 5.0);
  
  HAS_BEEN_PRELIMINARY_TELEPORT[playerId] = not nil;
end;

-- Показываем игроку сообщение с необходимым действием
function showSelectBattlefieldMessage(playerId)
  print "showSelectBattlefieldMessage"
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  local choisedFieldPlayerId = getSelectedBattlefieldPlayerId();
  
  local pathToMsg = choisedFieldPlayerId == playerId and PATH_TO_MODULES_MESSAGES.."choise_battlefield.txt" or PATH_TO_MODULES_MESSAGES.."please_skip_turn.txt";

  ShowFlyingSign(pathToMsg, mainHeroName, playerId, 5.0);
end;

-- Телепорт героя для выбора поля боя
function teleportHeroToSelectBattlefield(playerId)
  print "teleportHeroToSelectBattlefield"

  local position = PLAYERS_TELEPORT_TO_BATTLE_POSITION[playerId];
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  SetObjectPosition(mainHeroName, position.x, position.y);
  SetObjectOwner(PLAYERS_BOAT[playerId], playerId);
  SetObjectOwner(PLAYERS_TOWER[playerId], playerId);

  MoveCameraForPlayers(playerId, position.x, position.y, GROUND, 50, 1.57, 0, 0, 0, 1);
  OpenCircleFog(47, 46, GROUND, 16, playerId);
end;

-- Проверка необходимости телепорта игрока для выбора поля боя
function checkAndTeleportHeroToSelectBattlefield(playerId)
  print "checkAndTeleportHeroToSelectBattlefield"
  
  if HAS_BEEN_PRELIMINARY_TELEPORT[playerId] then
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    local x, y = GetObjectPosition(mainHeroName);
    local position = PLAYERS_TELEPORT_TO_BATTLE_POSITION[playerId];
    
    -- Если герой уже стоит на свое месте для телепортации - оставляем его там, иначе - телепортируем
    if position.x ~= x or position.y ~= y then
      teleportHeroToSelectBattlefield(playerId);
    end;
  else
    teleportHeroToSelectBattlefield(playerId);
  end;
end;

-- Даем мувы выбирающему герою
function giveMovePointsSelectableHero()
  print "giveMovePointsSelectableHero"
  
  local choisedFieldPlayerId = getSelectedBattlefieldPlayerId();
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[choisedFieldPlayerId].name;

  addHeroMovePoints(mainHeroName);
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

-- Активация навыка "Дипломатия"
function runDiplomacy(heroName)
  print 'runDiplomacy'

  local playerId = GetObjectOwner(heroName);

  awaitMessageBoxForPlayers(playerId, PATH_TO_MODULES_MESSAGES.."diplomacy.txt");

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
        if stashItem.id1 == gradeCreatureId or stashItem.id1 == altGradeCreatureId then
          if GetHeroCreatures(heroName, gradeCreatureId) == 0 then
            stashItem.id2 = gradeCreatureId;
          elseif GetHeroCreatures(heroName, altGradeCreatureId) == 0 then
            stashItem.id2 = altGradeCreatureId;
          else
            -- Чтобы эффект не дублировался
            if stashItem.id1 == gradeCreatureId then
              if GetHeroCreatures(heroName, gradeCreatureId) >= GetHeroCreatures(heroName, altGradeCreatureId) then
                stashItem.id2 = altGradeCreatureId;
              else
                stashItem.id2 = gradeCreatureId;
              end;
            end;
          end;
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

-- Навык дипломатии
function checkAndRunDiplomacy()
  print "checkAndRunDiplomacy"

  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

    -- Дипломатия
    if HasHeroSkill(mainHeroName, PERK_DIPLOMACY) then
      startThread(runDiplomacy, mainHeroName);
    end;
  end;
end;

function selectBattlefield()
  print "selectBattlefield"

  if not getHasBeenPreliminaryTeleport() then
    prepareSelectBattlefield();
  end;

  for _, playerId in PLAYER_ID_TABLE do
    checkAndTeleportHeroToSelectBattlefield(playerId);
    
    showSelectBattlefieldMessage(playerId);
  end;
  
  checkAndRunDiplomacy();
  
  giveMovePointsSelectableHero();
end;
