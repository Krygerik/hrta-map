
PATH_TO_DAY5_SCRIPTS = GetMapDataPath().."day5/";
PATH_TO_DAY5_MESSAGES = PATH_TO_DAY5_SCRIPTS.."messages/";

doFile(PATH_TO_DAY5_SCRIPTS.."day5_constants.lua");
sleep(1);

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

  awaitMessageBoxForPlayers(playerId, PATH_TO_DAY5_MESSAGES.."diplomacy.txt");

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

-- Получение ИД игрока, выбирающего поле для битвы
function getSelectedBattlefieldPlayerId()
  print "getSelectedBattlefieldPlayerId"

  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    local dictHeroName = getDictionaryHeroName(mainHeroName);

    -- Ниброс имеет приоритет над всем
    if dictHeroName == HEROES.JAZAZ then
      return playerId;
    end;
  end;

  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

    -- Нахождение пути дает возможность выбора
    if HasHeroSkill(mainHeroName, PERK_PATHFINDING) then
      return playerId;
    end;
  end;

  -- Если нет иных причин - по умолчанию выбирает синий
  return PLAYER_2;
end;

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

-- Телепорт героя для выбора поля боя
function teleportHeroToSelectBattlefield(triggerHero)
  print "teleportHeroToSelectBattlefield"

  local playerId = GetObjectOwner(triggerHero);
  local position = PLAYERS_TELEPORT_TO_BATTLE_POSITION[playerId];

  SetObjectPosition(triggerHero, position.x, position.y);
  SetObjectOwner(PLAYERS_BOAT[playerId], playerId);
  SetObjectOwner(PLAYERS_TOWER[playerId], playerId);

  OpenCircleFog(47, 46, GROUND, 16, playerId);

  local choisedFieldPlayerId = getSelectedBattlefieldPlayerId();

  if choisedFieldPlayerId == playerId then
    addHeroMovePoints(triggerHero);
    ShowFlyingSign(PATH_TO_DAY5_MESSAGES.."choise_battlefield.txt", triggerHero, playerId, 5.0);
  else
    removeHeroMovePoints(triggerHero);
    ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."please_skip_turn.txt", triggerHero, playerId, 5.0);
  end;
end;

-- Телепорт героя на арену
function teleportPlayerInToBattle(playerId)
  print "teleportPlayerInToBattle"

  teleportMainHeroToNearTown(playerId);

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  teleportHeroToSelectBattlefield(mainHeroName);
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

-- Точка старта
function day5_scripts()
  print "day5_scripts"

  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    
    -- Дипломатия
    if HasHeroSkill(mainHeroName, PERK_DIPLOMACY) then
      startThread(runDiplomacy, mainHeroName);
    end;
  end;
  
  prepareSelectBattlefield();

  for _, playerId in PLAYER_ID_TABLE do
    teleportPlayerInToBattle(playerId);
  end;
end;

day5_scripts();