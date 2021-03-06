-- Скрипт, выполняющийся при загрузке карты сразу же, в первый день

-- Путь до текущей папки
local MODULE_PATH = GetMapDataPath().."day1/";
-- Путь до папки с сообщениями
PATH_TO_DAY1_MESSAGES = MODULE_PATH.."messages/";

print(10);

-- Список пар существ, относящихся к каждой сгенерированной расе
randomGenerateRaceList = {
  [0] = {
    raceId = nil,
    selected = nil,
    visible = true,
    red_unit = {
      unitId = nil, name = 'm11', x = 32, y = 89, rot = 30,
    },
    blue_unit = {
      unitId = nil, name = 'm21', x = 42, y = 24, rot = 30,
    },
  },
  [1] = {
    raceId = nil,
    selected = nil,
    visible = true,
    red_unit = {
      unitId = nil, name = 'm12', x = 35, y = 89, rot = 330,
    },
    blue_unit = {
      unitId = nil, name = 'm22', x = 45, y = 24, rot = 330,
    },
  },
  [2] = {
    raceId = nil,
    selected = nil,
    visible = true,
    red_unit = {
      unitId = nil, name = 'm13', x = 36, y = 87, rot = 270,
    },
    blue_unit = {
      unitId = nil, name = 'm23', x = 46, y = 22, rot = 270,
    },
  },
  [3] = {
    raceId = nil,
    selected = nil,
    visible = true,
    red_unit = {
      unitId = nil, name = 'm14', x = 35, y = 85, rot = 210,
    },
    blue_unit = {
      unitId = nil, name = 'm24', x = 45, y = 20, rot = 210,
    },
  },
  [4] = {
    raceId = nil,
    selected = nil,
    visible = true,
    red_unit = {
      unitId = nil, name = 'm15', x = 32, y = 85, rot = 150,
    },
    blue_unit = {
      unitId = nil, name = 'm25', x = 42, y = 20, rot = 150,
    },
  },
  [5] = {
    raceId = nil,
    selected = nil,
    visible = true,
    red_unit = {
      unitId = nil, name = 'm16', x = 31, y = 87, rot = 90,
    },
    blue_unit = {
      unitId = nil, name = 'm26', x = 41, y = 22, rot = 90,
    },
  },
  [6] = {
    raceId = nil,
    selected = nil,
    visible = nil,
    red_unit = {
      unitId = nil, name = 'm17', x = 46, y = 43, rot = 0,
    },
    blue_unit = {
      unitId = nil, name = 'm27', x = 46, y = 46, rot = 0,
    },
  },
  [7] = {
    raceId = nil,
    selected = nil,
    visible = nil,
    red_unit = {
      unitId = nil, name = 'm18', x = 48, y = 43, rot = 0,
    },
    blue_unit = {
      unitId = nil, name = 'm28', x = 48, y = 46, rot = 0,
    },
  },
  [8] = {
    raceId = nil,
    selected = nil,
    visible = nil,
    red_unit = {
      unitId = nil, name = 'm19', x = 50, y = 43, rot = 0,
    },
    blue_unit = {
      unitId = nil, name = 'm29', x = 50, y = 46, rot = 0,
    },
  },
  [9] = {
    raceId = nil,
    selected = nil,
    visible = nil,
    red_unit = {
      unitId = nil, name = 'm110', x = 52, y = 43, rot = 0,
    },
    blue_unit = {
      unitId = nil, name = 'm210', x = 52, y = 46, rot = 0,
    },
  },
};

-- Получение количества записей в списке, равных переданной
function getCountRacesByRaceId(findRaceId)
  print "getCountRacesByRaceId"
  local count = 0;

  for i = 0, length(randomGenerateRaceList)-1 do
    if (randomGenerateRaceList[i].raceId == value) then
      count = count + 1;
    end;
  end;

  return count;
end;

-- Получение ключа случайной расы
function getRandomRace()
  return random(8);
end;

-- Установка существ для показа в сгенерированную расу
function setCreaturesPairInToRace(index, raceId)
  -- соотношение расы с отображаемыми при черке существами
  local MAPPING_RACE_TO_CREATURES = {
     -- Орден Порядка - латник и ревнитель веры
     [RACES.HAVEN] = { ID1 = CREATURE_FOOTMAN, ID2 = CREATURE_VINDICATOR },
     -- Инферно - черт и дьяволенок
     [RACES.INFERNO] = { ID1 = CREATURE_IMP, ID2 = CREATURE_QUASIT },
     -- Некрополис - вампир и князья вампиров
     [RACES.NECROPOLIS] = { ID1 = CREATURE_VAMPIRE, ID2 = CREATURE_NOSFERATU },
     -- Лесной Союз - лучник и стрелок
     [RACES.SYLVAN] = { ID1 = CREATURE_WOOD_ELF, ID2 = CREATURE_SHARP_SHOOTER },
     -- Акадения Волшебства - маг и боевой маг
     [RACES.ACADEMY] = { ID1 = CREATURE_MAGI, ID2 = CREATURE_COMBAT_MAGE },
     -- Лига Теней - бестия и фурия
     [RACES.DUNGEON] = { ID1 = CREATURE_WITCH, ID2 = CREATURE_BLOOD_WITCH_2 },
     -- Дварфы - жрец рун и служитель огня
     [RACES.FORTRESS] = { ID1 = CREATURE_RUNE_MAGE, ID2 = CREATURE_FLAME_KEEPER },
     -- Орда - палач и вожак
     [RACES.STRONGHOLD] = { ID1 = CREATURE_ORCCHIEF_BUTCHER, ID2 = CREATURE_ORCCHIEF_CHIEFTAIN },
  };

  randomGenerateRaceList[index].red_unit.unitId = MAPPING_RACE_TO_CREATURES[raceId].ID1;
  randomGenerateRaceList[index].blue_unit.unitId = MAPPING_RACE_TO_CREATURES[raceId].ID2;
end;

-- Точка входа для выполнения скриптов модулю
function main()
  print "__MAIN__"
  -- Биара (герой красного)
  local Biara = GetPlayerHeroes(PLAYER_1)[0]
  -- Джованни (негой синего)
  local Djovanni = GetPlayerHeroes(PLAYER_2)[0]

  if GAME_MODE.HALF then
    disableAreaInteractive();
    changeChooseArea();

    -- Перемещение героев игроков на позиции для черка
    SetObjectPosition(Biara, 34, 87, 0);
    SetObjectPosition(Djovanni, 43, 22, 0);

    for raceIndex = 0, 9 do
      local randomRaceId;
      local countEqualRace;

      -- Повторять, пока не сгенерируем разрешенную расу
      -- (не генерировать больше выборов одной расы)
      repeat
        randomRaceId = getRandomRace();
        -- Количество записанных рас, равных рандомной
        countEqualRace = getCountRacesByRaceId(randomRaceId);
      until countEqualRace < 2;

      randomGenerateRaceList[raceIndex].raceId = randomRaceId;

      -- Получение id отображаемых юнитов этой расы
      setCreaturesPairInToRace(raceIndex, randomRaceId);

      -- Создание существ для выбора расы у обоих игроков
      createRaceRepresentativeForEveryPlayer(raceIndex, randomRaceId);
    end;
  end;
end;

-- Создание существ-представителей для выбора расы для обоих игроков
function createRaceRepresentativeForEveryPlayer(raceIndex, raceId)
  print "createRaceRepresentativeForEveryPlayer"
  local red_unit = randomGenerateRaceList[raceIndex].red_unit;
  local blue_unit = randomGenerateRaceList[raceIndex].blue_unit;

  createRaceRepresentativeUtil(red_unit.name, red_unit.unitId, red_unit.x, red_unit.y, red_unit.rot);
  createRaceRepresentativeUtil(blue_unit.name, blue_unit.unitId, blue_unit.x, blue_unit.y, blue_unit.rot);
end;

-- Создание представителя и навешивание триггеров
function createRaceRepresentativeUtil(creatureName, creatureId, x, y, rotation)
  print "createRaceRepresentativeUtil"
  CreateMonster(creatureName, creatureId, 1, x, y, GROUND, 1, 2, rotation, 0);
  SetObjectEnabled(creatureName, nil);
  Trigger(OBJECT_TOUCH_TRIGGER, creatureName, "SelectRaceQuestion");
end;

-- Получение количества выбранных рас
function getCountSelectedRace()
  print "getCountSelectedRace"
  local count = 0;

  for i = 0, length(randomGenerateRaceList)-1 do
    if (randomGenerateRaceList[i].selected) then
      count = count + 1;
    end;
  end;
  
  return count;
end;

-- Функция, не делающая ничего
function noop()
end;

-- Вопрос при выборе расы
function SelectRaceQuestion(triggerHero, triggeredUnitName)
  print "SelectRaceQuestion"
  local countPickedRace = getCountSelectedRace();
  local textQuestion = countPickedRace < 4 and "question_choose_race_yourself.txt" or "question_choose_race_opponent.txt";

  QuestionBoxForPlayers (GetPlayerFilter(GetObjectOwner(triggerHero)), PATH_TO_DAY1_MESSAGES..textQuestion, "confirmSelectRace('"..triggeredUnitName.."')", 'noop');
end;

-- Получение индекса сгенерированной расы по name одного из представляющих ее юнитов
function getSelectedRaceIndexByUnitName(selectedCreatureName)
  print "getSelectedRaceIndexByUnitName"
  for i = 0, length(randomGenerateRaceList)-1 do
    local race = randomGenerateRaceList[i];

    if (
      race.red_unit.name == selectedCreatureName
      or race.blue_unit.name == selectedCreatureName
    ) then
      return i;
    end;
  end;
end;

-- Список полученных пар рас
selectedRacePair = {
  [0] = {
    [0] = { raceId = nil, deleted = nil, red_unit = { name = nil, x = 38, y = 90, rot = 90 }, blue_unit = { name = nil, x = 39, y = 25, rot = 270 } },
    [1] = { raceId = nil, deleted = nil, red_unit = { name = nil, x = 39, y = 90, rot = 270 }, blue_unit = { name = nil, x = 38, y = 25, rot = 90 } },
  },
  [1] = {
    [0] = { raceId = nil, deleted = nil, red_unit = { name = nil, x = 39, y = 88, rot = 270 }, blue_unit = { name = nil, x = 38, y = 23, rot = 90 } },
    [1] = { raceId = nil, deleted = nil, red_unit = { name = nil, x = 38, y = 88, rot = 90 }, blue_unit = { name = nil, x = 39, y = 23, rot = 270 } },
  },
  [2] = {
    [0] = { raceId = nil, deleted = nil, red_unit = { name = nil, x = 38, y = 86, rot = 90 }, blue_unit = { name = nil, x = 39, y = 21, rot = 270 } },
    [1] = { raceId = nil, deleted = nil, red_unit = { name = nil, x = 39, y = 86, rot = 270 }, blue_unit = { name = nil, x = 38, y = 21, rot = 90 } },
  },
  [3] = {
    [0] = { raceId = nil, deleted = nil, red_unit = { name = nil, x = 39, y = 84, rot = 270 }, blue_unit = { name = nil, x = 38, y = 19, rot = 90 } },
    [1] = { raceId = nil, deleted = nil, red_unit = { name = nil, x = 38, y = 84, rot = 90 }, blue_unit = { name = nil, x = 39, y = 19, rot = 270 } },
  },
};

-- Запись выбранной расы в список пар
function pushSelectedRaceToRacePair(selectedRace)
  print "pushSelectedRaceToRacePair"
  for pairIndex = 0, 3 do
    for sideIndex = 0, 1 do
      if (selectedRacePair[pairIndex][sideIndex].raceId == nil) then
        selectedRacePair[pairIndex][sideIndex].raceId = selectedRace.raceId
        selectedRacePair[pairIndex][sideIndex].red_unit.name = selectedRace.red_unit.name
        selectedRacePair[pairIndex][sideIndex].blue_unit.name = selectedRace.blue_unit.name

        return '';
      end;
    end
  end;
end;

print(300);

-- Выбор расы
function confirmSelectRace(unitName)
  print "confirmSelectRace"
  local selectedRaceIndex = getSelectedRaceIndexByUnitName(unitName);
  
  -- Проставляем расе свойство, что оно выбрано
  randomGenerateRaceList[selectedRaceIndex].selected = true;

  local selectedRace = randomGenerateRaceList[selectedRaceIndex]

  SetObjectPosition(selectedRace.red_unit.name, selectedRace.red_unit.x, selectedRace.red_unit.y, GROUND);
  SetObjectRotation(selectedRace.red_unit.name, selectedRace.red_unit.rot);
  SetObjectPosition(selectedRace.blue_unit.name, selectedRace.blue_unit.x, selectedRace.blue_unit.y, GROUND);
  SetObjectRotation(selectedRace.blue_unit.name, selectedRace.blue_unit.rot);

  Trigger(OBJECT_TOUCH_TRIGGER, selectedRace.red_unit.name, 'questionDeleteMatchup');
  Trigger(OBJECT_TOUCH_TRIGGER, selectedRace.blue_unit.name, 'questionDeleteMatchup');

  pushSelectedRaceToRacePair(selectedRace);
  changePlayersTurn();
end;

-- Получение индекса выбранной пары по юниту
function getPairIndexByUnitName(unitName)
  print "questionDeleteMatchup"
  for indexPair = 0, length(selectedRacePair)-1 do
    for indexSide = 0, 1 do
      if (
        selectedRacePair[indexPair][indexSide].red_unit.name == unitName
        or selectedRacePair[indexPair][indexSide].blue_unit.name == unitName
      ) then
        return indexPair;
      end;
    end;
  end;
end;

-- Вопрос по вычеркиванию матчапа
function questionDeleteMatchup(triggerHero, triggerUnitName)
  print "questionDeleteMatchup"
  selectedIndexPair = getPairIndexByUnitName(triggerUnitName);
  
  local triggerPlayer = GetPlayerFilter(GetObjectOwner(triggerHero));
  local pathToQuestion = PATH_TO_DAY1_MESSAGES.."question_delete_matchup.txt";

  QuestionBoxForPlayers(triggerPlayer, pathToQuestion, "handleDeleteMatchup('"..triggerHero.."', '"..selectedIndexPair.."')", 'noop');
end;

-- Получение количества удаленных пар
function getCountDeletedPair()
  print "getCountDeletedPair"
  local count = 0;
  
  for i = 0, length(selectedRacePair)-1 do
    if (selectedRacePair[0].deleted ~= nil) then
      count = count + 1;
    end;
  end;

  return count;
end;

-- Удаление пары рас по индексу пары
function deleteMatchupByIndexPair(indexPair)
  print "deleteMatchupByIndexPair"
  selectedRacePair[indexPair].deleted = true;

  for indexSide = 0, 1 do
    local deletedRace = selectedRacePair[indexPair][indexSide];

    RemoveObject(deletedRace.red_unit.name);
    RemoveObject(deletedRace.blue_unit.name);
  end;
end;

-- Обработчик удаления выбранного матчапа
function handleDeleteMatchup(hero, indexPair)
  print "handleDeleteMatchup"
  deleteMatchupByIndexPair(indexPair);

  local countDeletedPair = getCountDeletedPair();
      -- Биара (герой красного)
  local Biara = GetPlayerHeroes(PLAYER_1)[0];
  -- Джованни (негой синего)
  local Djovanni = GetPlayerHeroes(PLAYER_2)[0];

  -- Разрешаем игрокам удалить 2 пары
  if (countDeletedPair < 2) then
    if (GetObjectOwner(hero) == PLAYER_1) then
      removeHeroMovePoints(Biara);
      addHeroMovePoints(Djovanni);
      ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."delete_matchup.txt", Djovanni, PLAYER_2, 5.0);
    else
      removeHeroMovePoints(Djovanni);
      addHeroMovePoints(Biara);
      ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."delete_matchup.txt", Biara, PLAYER_1, 5.0);
    end;
  else
    finishCherkRace();
  end;
end;

-- Получение случайного индекса не удаленной пары
function getNotDeletedRandomPairIndex()
  print "getNotDeletedRandomPairIndex"
  local notDeletedPairKeys = {};

  for indexPair = 0, length(selectedRacePair)-1 do
    if (selectedRacePair[indexPair].deleted ~= nil) then
      if (notDeletedPairKeys[0] == nil) then
        notDeletedPairKeys[0] = indexPair;
      else
        notDeletedPairKeys[1] = indexPair;
      end;
    end;
  end;

  return notDeletedPairKeys[random(2)];
end;

-- Удаление объектов карты, разделяющих пары
function removePairDelimeters()
  print "removePairDelimeters"
  RemoveObject('blue3');
  RemoveObject('blue6');
  RemoveObject('blue9');
  RemoveObject('blue12');
  RemoveObject('blue15');
  RemoveObject('blue18');
  RemoveObject('red1');
  RemoveObject('red2');
  RemoveObject('red3');
  RemoveObject('red4');
  RemoveObject('red5');
  RemoveObject('red6');
end;

-- Действия в конце черка рас, переход к черку героев
function finishCherkRace()
  print "finishCherkRace"
  local randomPairIndexForDelete = getNotDeletedRandomPairIndex();

  deleteMatchupByIndexPair(randomPairIndexForDelete);
  sleep(10);

  -- Единственная не удаленная пара
  local resultPairIndex = getNotDeletedRandomPairIndex();
  deleteMatchupByIndexPair(resultPairIndex);

  sleep(3);
  removePairDelimeters();

  -- Переход к черку героев
  startChoosingHeroes();
end;

-- Черк героев
function startChoosingHeroes()
  print "startChoosingHeroes"
  x11=41; x12=44; y11=78; y12=78;
  x21=43; x22=41; y21=15; y22=15;

  if random(2) == 0 then    -- ПОМЕНЯТЬ НА 2
    CherkPossibleHeroes();
  else
    SetPossibleHeroes();
  end;
end;

-- Снимает все очки передвижения у переданного героя до 0
function removeHeroMovePoints(hero)
  print "removeHeroMovePoints"
  local currentHeroMovePoints = GetHeroMovePoints(hero);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints);
end;

-- Добавляет очки передвижения у переданному герою
function addHeroMovePoints(hero)
  print "addHeroMovePoints"
  local ADD_MOVE_POINTS = 50000;
  local currentHeroMovePoints = GetHeroMovePoints(hero);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints+ADD_MOVE_POINTS);
end;

-- Показ оставшихся рас
function showHiddenRaces()
  print "showHiddenRaces"
  -- индексы рас, которые нужно показать во второй стадии выбора
  local hiddenRaceIndexList = {
    6, 7, 8, 9
  };

  -- Проходимся по первому кругу рас и заменяем выбранные пары на те, что остались в списке
  for raceIndex = 0, 5 do
    if randomGenerateRaceList[raceIndex].selected then
      -- флаг - произошла замена расы
      local replaced = 0;

      for i = 1, length(hiddenRaceIndexList) do
        local hiddenRaceIndex = hiddenRaceIndexList[i];

        if (replaced == 0 and randomGenerateRaceList[hiddenRaceIndex].visible == nil) then
          local selectedRace = randomGenerateRaceList[raceIndex];
          local hiddenRace = randomGenerateRaceList[hiddenRaceIndex];

          SetObjectPosition(hiddenRace.red_unit.name, selectedRace.red_unit.x, selectedRace.red_unit.y, GROUND);
          SetObjectRotation(hiddenRace.red_unit.name, selectedRace.red_unit.rot);
          SetObjectPosition(hiddenRace.blue_unit.name, selectedRace.blue_unit.x, selectedRace.blue_unit.y, GROUND);
          SetObjectRotation(hiddenRace.blue_unit.name, selectedRace.blue_unit.rot);

          randomGenerateRaceList[hiddenRaceIndex].visible = true;
          replaced = 1;
        end;
      end;
    end;
  end;
end;

-- Передача ходов между игроками после выбора расы
function changePlayersTurn()
  print "changePlayersTurn"
  -- Биара (герой красного)
  local Biara = GetPlayerHeroes(PLAYER_1)[0];
  -- Джованни (негой синего)
  local Djovanni = GetPlayerHeroes(PLAYER_2)[0];

  local countSelectedRace = getCountSelectedRace();

  if (countSelectedRace == 1) then
    removeHeroMovePoints(Biara);
    addHeroMovePoints(Djovanni);
    ShowFlyingSign({PATH_TO_DAY1_MESSAGES.."choose_race_yourself.txt"; number_of_matchup = 1 }, Djovanni, PLAYER_2, 5.0);
  end;
  if (countSelectedRace == 2) then
    ShowFlyingSign({PATH_TO_DAY1_MESSAGES.."choose_race_yourself.txt"; number_of_matchup = 2 }, Djovanni, PLAYER_2, 5.0);
  end;
  if (countSelectedRace == 3) then
    removeHeroMovePoints(Djovanni);
    addHeroMovePoints(Biara);
    ShowFlyingSign({PATH_TO_DAY1_MESSAGES.."choose_race_yourself.txt"; number_of_matchup = 2 }, Biara, PLAYER_1, 5.0);
  end;
  if (countSelectedRace == 4) then
    showHiddenRaces();

    removeHeroMovePoints(Biara);
    addHeroMovePoints(Djovanni);
    ShowFlyingSign({PATH_TO_DAY1_MESSAGES.."choose_race_opponent.txt"; number_of_matchup = 3 }, Djovanni, PLAYER_2, 5.0);
  end;
  if (countSelectedRace == 5) then
    removeHeroMovePoints(Djovanni);
    addHeroMovePoints(Biara);
    ShowFlyingSign({PATH_TO_DAY1_MESSAGES.."choose_race_opponent.txt"; number_of_matchup = 3 }, Biara, PLAYER_1, 5.0);
  end;
  if (countSelectedRace == 6) then
    ShowFlyingSign({PATH_TO_DAY1_MESSAGES.."choose_race_opponent.txt"; number_of_matchup = 4 }, Biara, PLAYER_1, 5.0);
  end;
  if (countSelectedRace == 7) then
    removeHeroMovePoints(Biara);
    addHeroMovePoints(Djovanni);
    ShowFlyingSign({PATH_TO_DAY1_MESSAGES.."choose_race_opponent.txt"; number_of_matchup = 4 }, Djovanni, PLAYER_2, 5.0);
  end;
  if (countSelectedRace == 8) then
    -- Разрешаем пройти к полученным матчапам
    SetRegionBlocked ('block5', false);
    SetRegionBlocked ('block6', false);

    -- Убираем с поля последнюю, оставшуюся расу
    for i = 0, 9 do
      if randomGenerateRaceList[i].visible then
        local unselectedRace = randomGenerateRaceList[i];

        RemoveObject(unselectedRace.red_unit.name);
        RemoveObject(unselectedRace.blue_unit.name);
        unselectedRace.visible = true;
      end;
    end;

    ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."delete_matchup.txt", Djovanni, PLAYER_2, 5.0);
  end;
end;

-- Выключение взаимодействия игроков с окружением
function disableAreaInteractive()
  print "disableAreaInteractive"
  SetObjectEnabled('red1', nil);  SetDisabledObjectMode('red1', DISABLED_BLOCKED);
  SetObjectEnabled('red2', nil);  SetDisabledObjectMode('red2', DISABLED_BLOCKED);
  SetObjectEnabled('red3', nil);  SetDisabledObjectMode('red3', DISABLED_BLOCKED);
  SetObjectEnabled('red4', nil);  SetDisabledObjectMode('red4', DISABLED_BLOCKED);
  SetObjectEnabled('red5', nil);  SetDisabledObjectMode('red5', DISABLED_BLOCKED);
  SetObjectEnabled('red6', nil);  SetDisabledObjectMode('red6', DISABLED_BLOCKED);
  SetObjectEnabled('red7', nil);  SetDisabledObjectMode('red7', DISABLED_BLOCKED);
  SetObjectEnabled('red8', nil);  SetDisabledObjectMode('red8', DISABLED_BLOCKED);
  SetObjectEnabled('red9', nil);  SetDisabledObjectMode('red9', DISABLED_BLOCKED);
  SetObjectEnabled('red10', nil); SetDisabledObjectMode('red10', DISABLED_BLOCKED);
  SetObjectEnabled('red11', nil); SetDisabledObjectMode('red11', DISABLED_BLOCKED);
  SetObjectEnabled('red12', nil); SetDisabledObjectMode('red12', DISABLED_BLOCKED);
  SetObjectEnabled('red13', nil); SetDisabledObjectMode('red13', DISABLED_BLOCKED);
  SetObjectEnabled('red14', nil); SetDisabledObjectMode('red14', DISABLED_BLOCKED);
  SetObjectEnabled('red15', nil); SetDisabledObjectMode('red15', DISABLED_BLOCKED);
  SetObjectEnabled('red16', nil); SetDisabledObjectMode('red16', DISABLED_BLOCKED);
  SetObjectEnabled('red17', nil); SetDisabledObjectMode('red17', DISABLED_BLOCKED);
  SetObjectEnabled('red18', nil); SetDisabledObjectMode('red18', DISABLED_BLOCKED);
  SetObjectEnabled('red19', nil); SetDisabledObjectMode('red19', DISABLED_BLOCKED);
  SetObjectEnabled('red20', nil); SetDisabledObjectMode('red20', DISABLED_BLOCKED);

  SetObjectEnabled('blue1', nil);  SetDisabledObjectMode('blue1', DISABLED_BLOCKED);
  SetObjectEnabled('blue2', nil);  SetDisabledObjectMode('blue2', DISABLED_BLOCKED);
  SetObjectEnabled('blue3', nil);  SetDisabledObjectMode('blue3', DISABLED_BLOCKED);
  SetObjectEnabled('blue4', nil);  SetDisabledObjectMode('blue4', DISABLED_BLOCKED);
  SetObjectEnabled('blue5', nil);  SetDisabledObjectMode('blue5', DISABLED_BLOCKED);
  SetObjectEnabled('blue6', nil);  SetDisabledObjectMode('blue6', DISABLED_BLOCKED);
  SetObjectEnabled('blue7', nil);  SetDisabledObjectMode('blue7', DISABLED_BLOCKED);
  SetObjectEnabled('blue8', nil);  SetDisabledObjectMode('blue8', DISABLED_BLOCKED);
  SetObjectEnabled('blue9', nil);  SetDisabledObjectMode('blue9', DISABLED_BLOCKED);
  SetObjectEnabled('blue10', nil); SetDisabledObjectMode('blue10', DISABLED_BLOCKED);
  SetObjectEnabled('blue11', nil); SetDisabledObjectMode('blue11', DISABLED_BLOCKED);
  SetObjectEnabled('blue12', nil); SetDisabledObjectMode('blue12', DISABLED_BLOCKED);
  SetObjectEnabled('blue13', nil); SetDisabledObjectMode('blue13', DISABLED_BLOCKED);
  SetObjectEnabled('blue14', nil); SetDisabledObjectMode('blue14', DISABLED_BLOCKED);
  SetObjectEnabled('blue15', nil); SetDisabledObjectMode('blue15', DISABLED_BLOCKED);
  SetObjectEnabled('blue16', nil); SetDisabledObjectMode('blue16', DISABLED_BLOCKED);
  SetObjectEnabled('blue17', nil); SetDisabledObjectMode('blue17', DISABLED_BLOCKED);
  SetObjectEnabled('blue18', nil); SetDisabledObjectMode('blue18', DISABLED_BLOCKED);
  SetObjectEnabled('blue19', nil); SetDisabledObjectMode('blue19', DISABLED_BLOCKED);
  SetObjectEnabled('blue20', nil); SetDisabledObjectMode('blue20', DISABLED_BLOCKED);

  SetObjectEnabled('human1', nil); SetDisabledObjectMode('human1', DISABLED_BLOCKED);
  SetObjectEnabled('human2', nil); SetDisabledObjectMode('human2', DISABLED_BLOCKED);
  SetObjectEnabled('demon1', nil); SetDisabledObjectMode('demon1', DISABLED_BLOCKED);
  SetObjectEnabled('demon2', nil); SetDisabledObjectMode('demon2', DISABLED_BLOCKED);
  SetObjectEnabled('nekr1', nil);  SetDisabledObjectMode('nekr1', DISABLED_BLOCKED);
  SetObjectEnabled('nekr2', nil);  SetDisabledObjectMode('nekr2', DISABLED_BLOCKED);
  SetObjectEnabled('elf1', nil);   SetDisabledObjectMode('elf1', DISABLED_BLOCKED);
  SetObjectEnabled('elf2', nil);   SetDisabledObjectMode('elf2', DISABLED_BLOCKED);
  SetObjectEnabled('mag1', nil);   SetDisabledObjectMode('mag1', DISABLED_BLOCKED);
  SetObjectEnabled('mag2', nil);   SetDisabledObjectMode('mag2', DISABLED_BLOCKED);
  SetObjectEnabled('liga1', nil);  SetDisabledObjectMode('liga1', DISABLED_BLOCKED);
  SetObjectEnabled('liga2', nil);  SetDisabledObjectMode('liga2', DISABLED_BLOCKED);
  SetObjectEnabled('gnom1', nil);  SetDisabledObjectMode('gnom1', DISABLED_BLOCKED);
  SetObjectEnabled('gnom2', nil);  SetDisabledObjectMode('gnom2', DISABLED_BLOCKED);
  SetObjectEnabled('ork1', nil);   SetDisabledObjectMode('ork1', DISABLED_BLOCKED);
  SetObjectEnabled('ork2', nil);   SetDisabledObjectMode('ork2', DISABLED_BLOCKED);

  SetObjectEnabled('human1vrag', nil); SetDisabledObjectMode('human1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('human2vrag', nil); SetDisabledObjectMode('human2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('demon1vrag', nil); SetDisabledObjectMode('demon1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('demon2vrag', nil); SetDisabledObjectMode('demon2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('nekr1vrag', nil);  SetDisabledObjectMode('nekr1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('nekr2vrag', nil);  SetDisabledObjectMode('nekr2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('elf1vrag', nil);   SetDisabledObjectMode('elf1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('elf2vrag', nil);   SetDisabledObjectMode('elf2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('mag1vrag', nil);   SetDisabledObjectMode('mag1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('mag2vrag', nil);   SetDisabledObjectMode('mag2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('liga1vrag', nil);  SetDisabledObjectMode('liga1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('liga2vrag', nil);  SetDisabledObjectMode('liga2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('gnom1vrag', nil);  SetDisabledObjectMode('gnom1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('gnom2vrag', nil);  SetDisabledObjectMode('gnom2vrag', DISABLED_BLOCKED);
  SetObjectEnabled('ork1vrag', nil);   SetDisabledObjectMode('ork1vrag', DISABLED_BLOCKED);
  SetObjectEnabled('ork2vrag', nil);   SetDisabledObjectMode('ork2vrag', DISABLED_BLOCKED);
end;

-- Изменение ландшафта под черк
function changeChooseArea()
  print "changeChooseArea"
  -- Удаление перегородок между расами
  RemoveObject('blue1');
  RemoveObject('blue2');
  RemoveObject('blue4');
  RemoveObject('blue5');
  RemoveObject('blue7');
  RemoveObject('blue8');
  RemoveObject('blue13');
  RemoveObject('blue14');
  RemoveObject('blue16');
  RemoveObject('blue17');
  RemoveObject('blue19');
  RemoveObject('blue20');
  RemoveObject('red7');
  RemoveObject('red8');
  RemoveObject('red9');
  RemoveObject('red11');
  RemoveObject('red12');
  RemoveObject('red13');
  RemoveObject('red14');
  RemoveObject('red15');
  RemoveObject('red16');
  RemoveObject('red17');
  RemoveObject('red18');
  RemoveObject('red19');
  RemoveObject('red20');
  -- Перемещение остальных перегородок
  SetObjectPosition('red1', 38, 89);
  SetObjectPosition('red2', 38, 87);
  SetObjectPosition('red3', 38, 85);
  SetObjectPosition('red4', 39, 24);
  SetObjectPosition('red5', 39, 22);
  SetObjectPosition('red6', 39, 20);
  -- Блокировка передвижения игрока к выбранным расам
  SetRegionBlocked ('block5', true);
  SetRegionBlocked ('block6', true);
end;

print(700);

-- Точка входа в модуль
main();