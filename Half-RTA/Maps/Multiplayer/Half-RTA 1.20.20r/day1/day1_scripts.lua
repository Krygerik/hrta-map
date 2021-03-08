-- Скрипт, выполняющийся при загрузке карты сразу же, в первый день

-- Путь до текущей папки
local MODULE_PATH = GetMapDataPath().."day1/";
-- Путь до папки с сообщениями
PATH_TO_DAY1_MESSAGES = MODULE_PATH.."messages/";
-- Путь до папки с сообщениями
PATH_TO_HERO_NAMES = MODULE_PATH.."hero_names/";

-- Биара (герой красного)
Biara = GetPlayerHeroes(PLAYER_1)[0]
-- Джованни (негой синего)
Djovanni = GetPlayerHeroes(PLAYER_2)[0]

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
    if (randomGenerateRaceList[i].raceId == findRaceId) then
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
    if (randomGenerateRaceList[i].selected == true) then
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
    [0] = { raceId = nil, deleted = nil, owner = PLAYER_1, red_unit = { name = nil, x = 38, y = 90, rot = 90 }, blue_unit = { name = nil, x = 39, y = 25, rot = 270 } },
    [1] = { raceId = nil, deleted = nil, owner = PLAYER_2, red_unit = { name = nil, x = 39, y = 90, rot = 270 }, blue_unit = { name = nil, x = 38, y = 25, rot = 90 } },
  },
  [1] = {
    [0] = { raceId = nil, deleted = nil, owner = PLAYER_2, red_unit = { name = nil, x = 39, y = 88, rot = 270 }, blue_unit = { name = nil, x = 38, y = 23, rot = 90 } },
    [1] = { raceId = nil, deleted = nil, owner = PLAYER_1, red_unit = { name = nil, x = 38, y = 88, rot = 90 }, blue_unit = { name = nil, x = 39, y = 23, rot = 270 } },
  },
  [2] = {
    [0] = { raceId = nil, deleted = nil, owner = PLAYER_1, red_unit = { name = nil, x = 38, y = 86, rot = 90 }, blue_unit = { name = nil, x = 39, y = 21, rot = 270 } },
    [1] = { raceId = nil, deleted = nil, owner = PLAYER_2, red_unit = { name = nil, x = 39, y = 86, rot = 270 }, blue_unit = { name = nil, x = 38, y = 21, rot = 90 } },
  },
  [3] = {
    [0] = { raceId = nil, deleted = nil, owner = PLAYER_2, red_unit = { name = nil, x = 39, y = 84, rot = 270 }, blue_unit = { name = nil, x = 38, y = 19, rot = 90 } },
    [1] = { raceId = nil, deleted = nil, owner = PLAYER_1, red_unit = { name = nil, x = 38, y = 84, rot = 90 }, blue_unit = { name = nil, x = 39, y = 19, rot = 270 } },
  },
};

-- Запись выбранной расы в список пар
function pushSelectedRaceToRacePair(selectedRace)
  print "pushSelectedRaceToRacePair"
  for pairIndex = 0, 3 do
    for sideIndex = 0, 1 do
      local checkedSide = selectedRacePair[pairIndex][sideIndex];

      if (checkedSide.raceId == nil) then
        -- Запись выбранной расы в список пар
        checkedSide.raceId = selectedRace.raceId
        checkedSide.red_unit.name = selectedRace.red_unit.name
        checkedSide.blue_unit.name = selectedRace.blue_unit.name
        
        -- Изменение местоположения выбранных существ
        
        SetObjectPosition(checkedSide.red_unit.name, checkedSide.red_unit.x, checkedSide.red_unit.y, GROUND);
        SetObjectRotation(checkedSide.red_unit.name, checkedSide.red_unit.rot);
        SetObjectPosition(checkedSide.blue_unit.name, checkedSide.blue_unit.x, checkedSide.blue_unit.y, GROUND);
        SetObjectRotation(checkedSide.blue_unit.name, checkedSide.blue_unit.rot);

        Trigger(OBJECT_TOUCH_TRIGGER, checkedSide.red_unit.name, 'questionDeleteMatchup');
        Trigger(OBJECT_TOUCH_TRIGGER, checkedSide.blue_unit.name, 'questionDeleteMatchup');

        return '';
      end;
    end
  end;
end;

-- Выбор расы
function confirmSelectRace(unitName)
  print "confirmSelectRace"
  local selectedRaceIndex = getSelectedRaceIndexByUnitName(unitName);
  
  -- Проставляем расе свойство, что оно выбрано
  randomGenerateRaceList[selectedRaceIndex].selected = true;

  local selectedRace = randomGenerateRaceList[selectedRaceIndex]

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
  startChoosingHeroes(resultPairIndex);
end;

-- Черк героев
function startChoosingHeroes(resultPairIndex)
  print "startChoosingHeroes"
  
  local selectedPair = selectedRacePair[resultPairIndex];
  local redRaceId, blueRaceId;

  for sideIndex = 0, length(selectedPair)-1 do
    local currentSide = selectedPair[sideIndex];
  
    if (currentSide.owner == PLAYER_1) then
      redRaceId = currentSide.raceId;
    else
      blueRaceId = currentSide.raceId;
    end;
  end;

  if random(2) == 0 then
    cherkPossibleHeroes(redRaceId, blueRaceId);
  else
    SetPossibleHeroes();
  end;
end;

-- Оставил как есть
function deleteRace()
  print "deleteRace"
  RemoveObject('human1vrag');
  RemoveObject('demon1vrag');
  RemoveObject('nekr1vrag');
  RemoveObject('elf1vrag');
  RemoveObject('mag1vrag');
  RemoveObject('liga1vrag');
  RemoveObject('gnom1vrag');
  RemoveObject('ork1vrag');
  RemoveObject('human2vrag');
  RemoveObject('demon2vrag');
  RemoveObject('nekr2vrag');
  RemoveObject('elf2vrag');
  RemoveObject('mag2vrag');
  RemoveObject('liga2vrag');
  RemoveObject('gnom2vrag');
  RemoveObject('ork2vrag');
  RemoveObject('human1');
  RemoveObject('demon1');
  RemoveObject('nekr1');
  RemoveObject('elf1');
  RemoveObject('mag1');
  RemoveObject('liga1');
  RemoveObject('gnom1');
  RemoveObject('ork1');
  RemoveObject('human2');
  RemoveObject('demon2');
  RemoveObject('nekr2');
  RemoveObject('elf2');
  RemoveObject('mag2');
  RemoveObject('liga2');
  RemoveObject('gnom2');
  RemoveObject('ork2');
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

-- Список случайный героев для выбранных рас
randomHeroList = {
  [PLAYER_1] = {
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
  },
  [PLAYER_2] = {
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
    { raceId = nil, name = nil, selected = nil, deleted = nil, red_icon = nil, blue_icon = nil },
  },
};

-- Получение признака, есть ли такой герой в списке для выбора у определенного игрока
function getHasHeroInHeroRandomList(playerId, heroName)
  print "getHasHeroInHeroRandomList"
  local count = 0;

  for i, savedHeroName in randomHeroList[playerId] do
    if (savedHeroName == heroName) then
      count = count + 1;
    end;
  end;
  
  return count ~= 0;
end;

-- Генерация 7 случайных героев переданной расы для выбранного игрока
function generateRandomHeroListByPlayerIdAndRaceId(playerId, raceId)
  print "generateRandomHeroListByPlayerIdAndRaceId"
  for generateIndex = 1, 7 do
    local currentRaceHeroList = HEROES_BY_RACE[raceId];
    local randomHeroIndex, randomHeroName;

    repeat
      randomHeroIndex = random(length(currentRaceHeroList)) + 1;
      randomHeroName = currentRaceHeroList[randomHeroIndex].name;

      local isHeroNotExist = getHasHeroInHeroRandomList(playerId, randomHeroName);
    until isHeroNotExist;

    randomHeroList[playerId][generateIndex] = {
      hero = randomHeroName,
      raceId = raceId,
      red_icon = currentRaceHeroList[randomHeroIndex][playerId].red_icon,
      blue_icon = currentRaceHeroList[randomHeroIndex][playerId].blue_icon,
    };
  end;
end;

-- Признак, как первым черкаются герои: 0 - сначала добавляем, 1 - сначала удаляем
RANDOM_CHOOSE_FIRST_FLAG = random(2);

-- Черк по одному герою
function cherkPossibleHeroes(redRaceId, blueRaceId)
  print "cherkPossibleHeroes"
  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);

  removeHeroMovePoints(Djovanni);
  addHeroMovePoints(Biara)

  deleteRace();
  removeRaceRegionTriggers();
  
  -- Список выбранных рас
  local selectedRaceIdList = { redRaceId, blueRaceId };

  -- Изменяем название и описание портретов всех героев на карте
  for raceIndex, raceId in selectedRaceIdList do
    local currentRaceHeroList = HEROES_BY_RACE[raceId];
    
    for heroIndex, heroData in currentRaceHeroList do
      local playerList = { PLAYER_1, PLAYER_2 };
      
      for playerIndex, playerId in playerList do
        for iconIndex, iconName in heroData[playerId] do
           SetObjectEnabled(iconName, nil);
           OverrideObjectTooltipNameAndDescription(iconName, PATH_TO_HERO_NAMES..heroData.txt, heroData.dsc);
        end;
      end;
    end;
  end;

  -- Генерируем списки случайных героев для обоих игроков
  generateRandomHeroListByPlayerIdAndRaceId(PLAYER_1, redRaceId);
  generateRandomHeroListByPlayerIdAndRaceId(PLAYER_2, blueRaceId);
  
  -- Расставляем сгенерированных героев для выбора
  for playerId, heroList in randomHeroList do
    for heroIndex, heroData in heroList do
      SetObjectPosition(heroData.red_icon, (31 + heroIndex), 85, GROUND);
      SetObjectPosition(heroData.blue_icon, (38 + heroIndex), 23, GROUND);
      Trigger(OBJECT_TOUCH_TRIGGER, heroData.red_icon, 'handleTouchHero');
      Trigger(OBJECT_TOUCH_TRIGGER, heroData.blue_icon, 'handleTouchHero');
    end;
  end;
  
  changePlayersTurnForChoosingHero();
end;

-- Получение игрока, которому принадлежит выбранный герой
function getRelatedPlayerAndHeroNameByHeroIconName(heroIconName)
  print "getRelatedPlayerAndHeroNameByHeroIconName"
  for playerId, randomHeroList in randomHeroList do
    for heroIndex, heroData in randomHeroList do
      if (heroData.red_unit == heroIconName or heroData.blue_unit == heroIconName) then
          return playerId, heroData.name;
        end;
    end;
  end;
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

-- Обработчик удаления или добавления героя
function handlerAddOrDeleteHero(playerId, heroName)
  print "handlerAddOrDeleteHero"
  local action = getCurrentTurnAction();
  
  if action == TURN_ACTIONS.CHOOSING then
    addHeroForPlayer(playerId, heroName);
  else
    deleteHeroFromList(playerId, heroName);
  end;
  
  checkOnSelectMaximumHeroes();
  changePlayersTurnForChoosingHero();
end;

-- Проставление герою признака выбранного
function addHeroForPlayer(playerId, heroName)
  print "addHeroForPlayer"
  for heroIndex, heroData in randomHeroList[playerId] do
    if (heroData.hero == heroName) then
      heroData.selected = true;
      
      for indexDictHero, dictHero in HEROES_BY_RACE[heroData.raceId] do
        if (dictHero.name == heroName) then
          local icons = dictHero[playerId];

          SetObjectPosition(icons.red_icon, 31 + heroIndex, 84, GROUND);
          SetObjectPosition(icons.blue_icon, 38 + heroIndex, 24, GROUND);
          Trigger(icons.red_icon, 'noop');
          Trigger(icons.blue_icon, 'noop');
        end;
      end;
    end;
  end;
end;

-- Удаление героя из набора
function deleteHeroFromList(playerId, heroName)
  print "deleteHeroFromList"
  for heroIndex, heroData in randomHeroList[playerId] do
    if (heroData.hero == heroName) then
      heroData.deleted = true;

      RemoveObject(heroData.red_icon);
      RemoveObject(heroData.blue_icon);
    end;
  end;
end;

-- Проверка на максимум выбранных героев на каждой стороне
function checkOnSelectMaximumHeroes()
  print "checkOnSelectMaximumHeroes"
  for playerId, heroList in randomHeroList do
    local countDeletedHero, countSelectedHero = 0, 0;
    
    for heroIndex, heroData in heroList do
      if heroData.deleted then
        countDeletedHero = countDeletedHero + 1;
      end;

      if heroData.selected then
        countSelectedHero = countSelectedHero + 1;
      end;
    end;
    
    -- Если вычеркнуто 3 героя, добавляем всех оставшихся героев в набор
    if countDeletedHero == 3 then
      for heroIndex, heroData in heroList do
        if (not heroData.deleted and not heroData.selected) then
          addHeroForPlayer(playerId, heroData.name)
        end;
      end;
    end;

    -- Если добавлено 3 героя, удаляем всех оставшихся героев в набор
    if countSelectedHero == 4 then
      for heroIndex, heroData in heroList do
        if (not heroData.deleted and not heroData.selected) then
          deleteHeroFromList(playerId, heroData.name);
        end;
      end;
    end;
  end;
end;

-- Признак заполнена ли одна из сторон или нет: 0 - Не заполнены, 1 - Заполнена
function getCountSideFullfied()
  print "getCountSideFullfied"
  for playerId, heroList in randomHeroList do
    local countDeletedHero, countSelectedHero = 0, 0;

    for heroIndex, heroData in heroList do
      if heroData.selected then
        countSelectedHero = countSelectedHero + 1;
      end;
    end;
    
    if countSelectedHero == 4 then
      return 1;
    end;
  end;
  
  return 0;
end;

-- Получение номера текущего хода
function getHeroTurn()
  print "getHeroTurn"
  local count = 0;
  local countSideFullfied = getCountSideFullfied();
  
  for playerId, heroList in randomHeroList do
    for heroIndex, heroData in heroList do
      if (heroData.deleted or heroData.selected) then
        count = count + 1;
      end;
    end;
  end;
  
  return count - countSideFullfied;
end;

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
    [0] = { TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING },
    [1] = { TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING },
  };
  local turn = getHeroTurn();
  
  return mapFlagToTurnAction[RANDOM_CHOOSE_FIRST_FLAG][turn + 1];
end;

-- Обработчик изменения
function changePlayersTurnForChoosingHero()
  print "changePlayersTurnForChoosingHero"
  -- Номер текущего хода черка героев
  local turn = getHeroTurn();
  local turnAction = getCurrentTurnAction();
  local message = turnAction == TURN_ACTIONS.CHOOSING and "include_single_hero.txt" or "exclude_single_hero.txt";
  
  -- разрешаем черкнуть 10 героев
  if turn > 9 then
    return setResultHeroes();
  end;
  
  -- Четные ходы выбирает красный, Нечетные - синий
  if mod(turn, 2) then
    removeHeroMovePoints(Djovanni);
    addHeroMovePoints(Biara);
    ShowFlyingSign(PATH_TO_DAY1_MESSAGES..text, Biara, PLAYER_1, 7.0);
  else
    removeHeroMovePoints(Biara);
    addHeroMovePoints(Djovanni);
    ShowFlyingSign(PATH_TO_DAY1_MESSAGES..text, Djovanni, PLAYER_2, 7.0);
  end;
end;

-- Итоговый список героев для игры
RESULT_HERO_LIST = {
  [PLAYER_1] = { raceId = nil, heroes = {} },
  [PLAYER_2] = { raceId = nil, heroes = {} },
};

-- Получение конечного списка героев для обоих игроков
function setResultHeroes()
  print "setResultHeroes"
  for playerId, heroList in randomHeroList do
    -- Список выбранных героев для рандомного выбора
    local selectedHero = {};

    for heroIndex, heroData in heroList do
      if heroData.selected then
        local pushedIndex = length(selectedHero) + 1;

        selectedHero[pushedIndex] = {
          hero = heroData.hero,
          raceId = heroData.raceId,
          selected = nil,
        };
      end;
    end;
    
    -- Заполняем итоговый список 2 случайными выбранными героями
    for resultHeroIndex = 1, 2 do
      local randomSelectedHero;
      
      -- Повторять, пока не сгенерируем индекс героя, которого не выбрали
      repeat
        local randomIndex = random(length(selectedHero)) + 1;
        randomSelectedHero = selectedHero[randomIndex];
      until not randomSelectedHero.selected;
      
      RESULT_HERO_LIST[playerId].raceId = randomSelectedHero.raceId;
      RESULT_HERO_LIST[playerId].heroes[resultHeroIndex] = randomSelectedHero.hero;
      
      randomSelectedHero.selected = true;
    end;
    
    -- Заполняем список 3 случайным героем этой расы
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    local resultHeroes = RESULT_HERO_LIST[playerId].heroes;
    local allHeroesByRace = HEROES_BY_RACE[raceId];
    local randomHero;
    
    -- Повторяем, пока не зарандомим не выбранного героя
    repeat
      local randomIndex = random(length(allHeroesByRace)) + 1;
      randomHero = allHeroesByRace[randomIndex];
      local isNotExist = true;
      
      for i, resultHero in resultHeroes do
        if resultHero == randomHero.name then
          isNotExist = nil;
        end;
      end;
      
    until isNotExist;

    RESULT_HERO_LIST[playerId].heroes[3] = randomHero.name;
  end;
end;

-- Снимает все очки передвижения у переданного героя до 0
function removeHeroMovePoints(hero)
  print "removeHeroMovePoints"
  local currentHeroMovePoints = GetHeroStat(hero, STAT_MOVE_POINTS);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints);
end;

-- Добавляет очки передвижения у переданному герою
function addHeroMovePoints(hero)
  print "addHeroMovePoints"
  local ADD_MOVE_POINTS = 50000;
  local currentHeroMovePoints = GetHeroStat(hero, STAT_MOVE_POINTS);

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

-- Точка входа в модуль
main();