-- Список случайных героев для выбранных рас
randomHeroList = {
  [PLAYER_1] = {
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
  },
  [PLAYER_2] = {
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, manual_change = nil, red_icon = nil, blue_icon = nil },
  },
};

-- Черк по одному герою
function cherkSingleHeroes()
  print "cherkSingleHeroes"
  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);

  removeHeroMovePoints(Djovanni);
  addHeroMovePoints(Biara)

  removeRaceRegionTriggers();

  -- Меняем описание портретов всех героев выбранных рас
  changeDescriptionForSelectedRaceHeroIcons();

  -- Генерируем списки случайных героев для обоих игроков
  generateRandomHeroListByPlayerIdAndRaceId(PLAYER_1, SELECTED_RACE_ID_TABLE[1]);
  generateRandomHeroListByPlayerIdAndRaceId(PLAYER_2, SELECTED_RACE_ID_TABLE[2]);

  -- Расставляем сгенерированных героев для выбора
  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if playerId == PLAYER_1 then
        SetObjectPosition(heroData.red_icon, (31 + heroIndex), 85, GROUND);
        SetObjectPosition(heroData.blue_icon, (38 + heroIndex), 23, GROUND);
      else
        SetObjectPosition(heroData.red_icon, (31 + heroIndex), 88, GROUND);
        SetObjectPosition(heroData.blue_icon, (38 + heroIndex), 20, GROUND);
      end;

      Trigger(OBJECT_TOUCH_TRIGGER, heroData.red_icon, 'handleTouchHero');
      Trigger(OBJECT_TOUCH_TRIGGER, heroData.blue_icon, 'handleTouchHero');
    end;
  end;

  changePlayersTurnForChoosingHero();
end;

-- Удаление триггеров с регионов, где находились расы
function removeRaceRegionTriggers()
  print "removeRaceRegionTriggers"
  
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race1', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race2', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race3', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race4', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race5', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race6', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race7', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race8', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race1', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race2', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race3', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race4', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race5', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race6', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race7', 'noop');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race8', 'noop');
end;

-- Меняем имя и описание для всех героев переданных рас
function changeDescriptionForSelectedRaceHeroIcons()
  print "changeDescriptionForSelectedRaceHeroIcons"

  -- Изменяем название и описание портретов всех героев выбранных рас на карте
  for raceIndex, raceId in SELECTED_RACE_ID_TABLE do
    local currentRaceHeroList = HEROES_BY_RACE[raceId];

    for heroIndex, heroData in currentRaceHeroList do
      local playerList = { PLAYER_1, PLAYER_2 };

      for playerIndex, playerId in playerList do
        for iconsIndex = 1, length(heroData[playerId]) do
          local icons = heroData[playerId][iconsIndex];

          SetObjectEnabled(icons.red_icon, nil);
          OverrideObjectTooltipNameAndDescription(icons.red_icon, PATH_TO_HERO_NAMES..heroData.txt, heroData.dsc);
          SetObjectEnabled(icons.blue_icon, nil);
          OverrideObjectTooltipNameAndDescription(icons.blue_icon, PATH_TO_HERO_NAMES..heroData.txt, heroData.dsc);
        end;
      end;
    end;
  end;
end;

-- Генерация 7 случайных героев переданной расы для выбранного игрока
function generateRandomHeroListByPlayerIdAndRaceId(playerId, raceId)
  print "generateRandomHeroListByPlayerIdAndRaceId"

  for generateIndex = 1, 7 do
    local currentRaceHeroList = HEROES_BY_RACE[raceId];
    local randomHeroIndex, randomHeroName, isHeroExist;

    repeat
      randomHeroIndex = random(length(currentRaceHeroList)) + 1;
      randomHeroName = currentRaceHeroList[randomHeroIndex].name;

      isHeroExist = getHasHeroInHeroRandomList(playerId, randomHeroName);
    until not isHeroExist;

    randomHeroList[playerId][generateIndex] = {
      name = randomHeroName,
      raceId = raceId,
      red_icon = currentRaceHeroList[randomHeroIndex][playerId][1].red_icon,
      blue_icon = currentRaceHeroList[randomHeroIndex][playerId][1].blue_icon,
    };
  end;
end;

-- Получение признака, есть ли такой герой в списке для выбора у определенного игрока
function getHasHeroInHeroRandomList(playerId, heroName)
  print "getHasHeroInHeroRandomList"

  local count = 0;
  local randomHeroes = randomHeroList[playerId]

  for indexHero = 1, length(randomHeroes) do
    if (randomHeroes[indexHero].name == heroName) then
      count = count + 1;
    end;
  end;

  return count > 0;
end;

-- Обработчик касания героев для выбора
function handleTouchHero(triggerPlayerHero, triggeredHeroIconName)
  print "handleTouchHero"

  -- игрок, которому принадлежит этот герой
  local player, heroName = getRelatedPlayerAndHeroNameByHeroIconName(triggeredHeroIconName);

  local triggerPlayer = GetPlayerFilter(GetObjectOwner(triggerPlayerHero));
  local action = getCurrentTurnAction();
  local question = action == TURN_ACTIONS.CHOOSING and "question_add_hero.txt" or "question_delete_hero.txt";

  QuestionBoxForPlayers(triggerPlayer, PATH_TO_DAY1_MESSAGES..question, "handlerAddOrDeleteHero('"..player.."', '"..heroName.."')", 'noop');
end;

-- Получение игрока, которому принадлежит выбранный герой
function getRelatedPlayerAndHeroNameByHeroIconName(heroIconName)
  print "getRelatedPlayerAndHeroNameByHeroIconName"

  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if (heroData.red_icon == heroIconName or heroData.blue_icon == heroIconName) then
        return playerId, heroData.name;
      end;
    end;
  end;
end;

-- Признак, что идет первым: выбор или удаление: 0 - сначала добавляем, 1 - сначала удаляем
RANDOM_CHOOSE_FIRST_FLAG = random(2);

-- Перечисление типов хода при черке героев: 0 - Вычеркиваем, 1 - Добавляем
TURN_ACTIONS = {
  CHOOSING = 1,
  DELETING = 0,
};

-- Получение типа действия текущего хода:
function getCurrentTurnAction()
  print "getCurrentTurnAction"

  -- Соотношение хода героя к типу действия при черке
  local mapFlagToTurnAction = {
    [0] = { TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING },
    [1] = { TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING },
  };
  local turn = getHeroTurn();

  return mapFlagToTurnAction[RANDOM_CHOOSE_FIRST_FLAG][turn + 1];
end;

-- Получение номера текущего хода
function getHeroTurn()
  print "getHeroTurn"

  local count = 0;

  -- Считаем всех героев, которые были добавлены или удалены игроками
  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if (heroData.manual_change) then
        count = count + 1;
      end;
    end;
  end;

  return count;
end;

-- Обработчик удаления или добавления героя
function handlerAddOrDeleteHero(playerId, heroName)
  print "handlerAddOrDeleteHero"

  -- Преобразование строки к числу
  local playerId = playerId + 0;

  local action = getCurrentTurnAction();
  if action == TURN_ACTIONS.CHOOSING then
    addHeroForPlayer(playerId, heroName, true);
  else
    deleteHeroFromList(playerId, heroName, true);
  end;

  checkOnSelectMaximumHeroes();
  changePlayersTurnForChoosingHero();
end;

-- Проставление герою признака выбранного
function addHeroForPlayer(playerId, heroName, manual)
  print "addHeroForPlayer"

  for heroIndex = 1, length(randomHeroList[playerId]) do
    local heroData = randomHeroList[playerId][heroIndex];

    if (heroData.name == heroName) then
      heroData.selected = true;
      heroData.manual_change = manual;

      for indexDictHero = 1, length(HEROES_BY_RACE[heroData.raceId]) do
        local dictHero = HEROES_BY_RACE[heroData.raceId][indexDictHero];

        if (dictHero.name == heroName) then
          local icons = dictHero[playerId][1];

          if playerId == PLAYER_1 then
            SetObjectPosition(icons.red_icon, (31 + heroIndex), 84, GROUND);
            SetObjectPosition(icons.blue_icon, (38 + heroIndex), 24, GROUND);
          else
            SetObjectPosition(icons.red_icon, (31 + heroIndex), 89, GROUND);
            SetObjectPosition(icons.blue_icon, (38 + heroIndex), 19, GROUND);
          end;

          Trigger(OBJECT_TOUCH_TRIGGER, icons.red_icon, 'noop');
          Trigger(OBJECT_TOUCH_TRIGGER, icons.blue_icon, 'noop');
        end;
      end;
    end;
  end;
end;

-- Удаление героя из набора
function deleteHeroFromList(playerId, heroName, manual)
  print "deleteHeroFromList"

  for heroIndex = 1, length(randomHeroList[playerId]) do
    local heroData = randomHeroList[playerId][heroIndex];

    if (heroData.name == heroName) then
      heroData.deleted = true;
      heroData.manual_change = manual;

      RemoveObject(heroData.red_icon);
      RemoveObject(heroData.blue_icon);
    end;
  end;
end;

-- Проверка на максимум выбранных героев на каждой стороне
function checkOnSelectMaximumHeroes()
  print "checkOnSelectMaximumHeroes"

  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];
    local countDeletedHero = 0;
    local countSelectedHero = 0;

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if heroData.deleted then
        countDeletedHero = countDeletedHero + 1;
      end;

      if heroData.selected then
        countSelectedHero = countSelectedHero + 1;
      end;
    end;

    -- Если вычеркнуто 3 героя, добавляем всех оставшихся героев в набор
    if countDeletedHero > 2 then
      for heroIndex = 1, length(heroList) do
        local heroData = heroList[heroIndex];

        if (not heroData.deleted and not heroData.selected) then
          addHeroForPlayer(playerId, heroData.name)
        end;
      end;
    end;

    -- Если добавлено 3 героя, удаляем всех оставшихся героев в набор
    if countSelectedHero > 3 then
      for heroIndex = 1, length(heroList) do
        local heroData = heroList[heroIndex];

        if (not heroData.deleted and not heroData.selected) then
          deleteHeroFromList(playerId, heroData.name);
        end;
      end;
    end;
  end;
end;

-- Обработчик изменения
function changePlayersTurnForChoosingHero()
  print "changePlayersTurnForChoosingHero"

  -- Номер текущего хода черка героев
  local turn = getHeroTurn();
  local turnAction = getCurrentTurnAction();
  local countSideFullfied = getCountSideFullfied();
  local message = turnAction == TURN_ACTIONS.CHOOSING and "include_single_hero.txt" or "exclude_single_hero.txt";

  -- Если 2 списка заполнены - заканчиваем черк
  if countSideFullfied == 2 then
    setResultHeroes();
    return '';
  end;

  -- Четные ходы выбирает красный, Нечетные - синий
  if mod(turn, 2) == 0 then
    removeHeroMovePoints(Djovanni);
    addHeroMovePoints(Biara);
    ShowFlyingSign(PATH_TO_DAY1_MESSAGES..message, Biara, PLAYER_1, 7.0);
  else
    removeHeroMovePoints(Biara);
    addHeroMovePoints(Djovanni);
    ShowFlyingSign(PATH_TO_DAY1_MESSAGES..message, Djovanni, PLAYER_2, 7.0);
  end;
end;

-- Признак заполнена ли одна из сторон или нет: 0 - Не заполнены, 1 - Заполнена
function getCountSideFullfied()
  print "getCountSideFullfied"

  local countSide = 0;

  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];

    local countSelectedHero = 0;

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if heroData.selected then
        countSelectedHero = countSelectedHero + 1;
      end;
    end;

    if countSelectedHero == 4 then
      countSide = countSide + 1;
    end;
  end;

  return countSide;
end;

-- Получение конечного списка героев для обоих игроков
function setResultHeroes()
  print "setResultHeroes"

  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId]
    -- Список выбранных героев для рандомного выбора
    local selectedHero = {};

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if heroData.selected then
        local pushedIndex = length(selectedHero) + 1;

        selectedHero[pushedIndex] = heroData.name;
      end;
    end;

    -- Заполняем итоговый список 2 случайными выбранными героями и 1 рандомным
    setRandomHeroFromHeroList(playerId, heroList[1].raceId, selectedHero);
  end;
end;

-- Выбор случайных 2 героев из переданного списка и 1 рандомным
function setRandomHeroFromHeroList(playerId, raceId, heroList)
  print "setRandomHeroFromHeroList"

  RESULT_HERO_LIST[playerId].raceId = raceId;

  local resultHeroes = RESULT_HERO_LIST[playerId].heroes;

  for resultHeroIndex = 1, 2 do
    local randomSelectedHero;
    local countEqualHeroNames = 0;

    -- Повторять, пока не сгенерируем индекс героя, которого не выбрали
    repeat
      local randomIndex = random(length(heroList)) + 1;
      randomSelectedHero = heroList[randomIndex];
      countEqualHeroNames = 0;

      for heroIndex, heroName in resultHeroes do
        if heroName == randomSelectedHero then
          countEqualHeroNames = countEqualHeroNames + 1;
        end;
      end;
    until countEqualHeroNames == 0;

    resultHeroes[resultHeroIndex] = randomSelectedHero;
  end;

  -- Заполняем список еще одним случайным героем этой расы
  local allHeroesByRace = HEROES_BY_RACE[raceId];
  local randomHero;
  local countEqualHeroNames = 0;

  -- Повторяем, пока не зарандомим не выбранного героя
  repeat
    local randomIndex = random(length(allHeroesByRace)) + 1;
    randomHero = allHeroesByRace[randomIndex];
    countEqualHeroNames = 0;

    for i, resultHero in resultHeroes do
      if resultHero == randomHero.name then
        countEqualHeroNames = countEqualHeroNames + 1;
      end;
    end;
  until countEqualHeroNames == 0;

  resultHeroes[3] = randomHero.name;
end;

cherkSingleHeroes();