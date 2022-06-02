-- Скрипт, описывающий механизм выбора расы при смешанном черке

-- Подключение общего функционала
doFile(PATH_TO_DAY1_MODULE.."choice_of_races/common.lua");
sleep(1);

-- Набор выбранных рас и героев для первого игрока
PLAYER_1_RACE_LIST = {
  {
    raceId = nil, heroes = {
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_1', x = 32, y = 90 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_5', x = 43, y = 25 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_2', x = 32, y = 89 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_6', x = 43, y = 24 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_3', x = 32, y = 88 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_7', x = 43, y = 23 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_4', x = 32, y = 87 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_8', x = 43, y = 22 },
        },
      },
    }
  },
  {
    raceId = nil, heroes = {
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_9', x = 33, y = 90 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_13', x = 44, y = 25 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_10', x = 33, y = 89 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_14', x = 44, y = 24 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_11', x = 33, y = 88 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_15', x = 44, y = 23 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_12', x = 33, y = 87 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_16', x = 44, y = 22 },
        },
      },
    }
  },
  {
    raceId = nil, heroes = {
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_17', x = 34, y = 90 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_21', x = 45, y = 25 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_18', x = 34, y = 89 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_22', x = 45, y = 24 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_19', x = 34, y = 88 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_23', x = 45, y = 23 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterRed_20', x = 34, y = 87 },
          [PLAYER_2] = { name = nil, poster = 'PosterRed_24', x = 45, y = 22 },
        },
      },
    }
  },
}
-- Набор выбранных рас и героев для второго игрока
PLAYER_2_RACE_LIST = {
  {
    raceId = nil, heroes = {
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_1', x = 36, y = 90 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_5', x = 39, y = 25 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_2', x = 36, y = 89 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_6', x = 39, y = 24 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_3', x = 36, y = 88 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_7', x = 39, y = 23 },
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_4', x = 36, y = 87 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_8', x = 39, y = 22 },
        },
      },
    }
  },
  {
    raceId = nil, heroes = {
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_9', x = 37, y = 90 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_13', x = 40, y = 25 }
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_10', x = 37, y = 89 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_14', x = 40, y = 24 }
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_11', x = 37, y = 88 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_15', x = 40, y = 23 }
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_12', x = 37, y = 87 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_16', x = 40, y = 22 }
        },
      },
    }
  },
  {
    raceId = nil, heroes = {
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_17', x = 38, y = 90 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_21', x = 41, y = 25 }
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_18', x = 38, y = 89 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_22', x = 41, y = 24 }
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_19', x = 38, y = 88 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_23', x = 41, y = 23 }
        },
      },
      {
        hero = nil, icons = {
          [PLAYER_1] = { name = nil, poster = 'PosterBlue_20', x = 38, y = 87 },
          [PLAYER_2] = { name = nil, poster = 'PosterBlue_24', x = 41, y = 22 }
        },
      },
    }
  },
}

-- Список случайных героев для выбора
RANDOM_HEROES_LIST = {
  {
    raceId = nil, hero = nil, units = {
      [PLAYER_1] = { name = nil, x = 33, y = 85 },
      [PLAYER_2] = { name = nil, x = 40, y = 20 },
    }
  },
  {
    raceId = nil, hero = nil, units = {
      [PLAYER_1] = { name = nil, x = 34, y = 85 },
      [PLAYER_2] = { name = nil, x = 41, y = 20 },
    }
  },
  {
    raceId = nil, hero = nil, units = {
      [PLAYER_1] = { name = nil, x = 35, y = 85 },
      [PLAYER_2] = { name = nil, x = 42, y = 20 },
    }
  },
  {
    raceId = nil, hero = nil, units = {
      [PLAYER_1] = { name = nil, x = 36, y = 85 },
      [PLAYER_2] = { name = nil, x = 43, y = 20 },
    }
  },
  {
    raceId = nil, hero = nil, units = {
      [PLAYER_1] = { name = nil, x = 37, y = 85 },
      [PLAYER_2] = { name = nil, x = 44, y = 20 },
    }
  },
};

-- Точка входа
function mixChoiseOfRace()
  print "mixChoiseOfRace"

  deleteAllDelimeters();
  
  showPosters();
  
  generateInitialHeroes();
  
  changeHeroTurn();
end;

-- Показ постеров переданного набора
function showPostersForSingleSet(raceList)
  print "showPostersForSingleSet"
  
  for raceIndex = 1, length(raceList) do
    local raceData = raceList[raceIndex];

    for heroesIndex = 1, length(raceData.heroes) do
      local heroData = raceData.heroes[heroesIndex];
      
      -- Показываем для черка только 3 героя, 4 сгенерим рандомно
      if heroesIndex == 4 then
        break;
      end;
      
      for playerId = 1, length(heroData.icons) do
        local iconByPlayer = heroData.icons[playerId];
      
        OverrideObjectTooltipNameAndDescription(iconByPlayer.poster, GetMapDataPath().."notext.txt", GetMapDataPath().."notext.txt");
        SetObjectPosition(iconByPlayer.poster, iconByPlayer.x, iconByPlayer.y, GROUND);
        SetObjectEnabled(iconByPlayer.poster, nil);
      end;
    end;
  end;
end;

-- Расставляем постеры, обозначающие места, где будут храниться выбранные герои игроков
function showPosters()
  print "showPosters"

  showPostersForSingleSet(PLAYER_1_RACE_LIST);
  showPostersForSingleSet(PLAYER_2_RACE_LIST);
end;

-- Генерация начальных героев для выбора
function generateInitialHeroes()
  print "generateInitialHeroes"

  for heroIndex = 1, length(RANDOM_HEROES_LIST) do
    local heroData = RANDOM_HEROES_LIST[heroIndex];

    generateHeroForCell(heroData);
  end;
end;

-- Перегенерация героев в списке для выбора
function regenerateHeroAndUpdateSelectList(heroName)
  print "regenerateHeroAndUpdateSelectList"
  
  local preferRaces = getPreferRaces();
  
  -- Индекс выбранного героя в списке героев для выбора
  local changedHeroIndex;

  for indexHero = 1, length(RANDOM_HEROES_LIST) do
    local heroData = RANDOM_HEROES_LIST[indexHero];
    
    if heroData.hero == heroName then
      changedHeroIndex = indexHero;
      generateHeroForCell(heroData, preferRaces);
    end;
  end;
  
  -- Перегенерация другого случайного героя в списке
  local randomIndex;
  
  repeat
    randomIndex = random(length(RANDOM_HEROES_LIST)) + 1;
  until randomIndex ~= preferRaces;
  
  generateHeroForCell(RANDOM_HEROES_LIST[randomIndex], preferRaces, true);
end;

-- Получение ИД расы для ячейки в списке выбора героев
function getRandomRaceForSelectList(preferRaces)
  print "getRandomRaceForSelectList"

  local randomRaceId;
  
  if preferRaces then
    local randomIndex = random(length(preferRaces)) + 1;
    
    randomRaceId = preferRaces[randomIndex];
  else
    randomRaceId = getRandomRace();
  end;

  return randomRaceId;
end;

-- Получение случайного не выбранного героя конкретной расы
function getRandomUnselectedHeroByRace(raceId)
  print "getRandomUnselectedHeroByRace"
  
  local allHeroListRandomRace = HEROES_BY_RACE[raceId];
  local allSelectedHero = getAllSelectedHeroList();
  
  local randomHero, countIdentityHeroes;
  
  repeat
    countIdentityHeroes = 0;
    randomHero = allHeroListRandomRace[random(length(allHeroListRandomRace)) + 1];
  
    -- Проверка наличия героя в наборе у обоих игроков
    for _, selectedHero in allSelectedHero do
      if selectedHero == randomHero.name then
        countIdentityHeroes = countIdentityHeroes + 1
      end
    end;
    
    -- Проверка наличия героя в списке для выбора
    for indexHero = 1, length(RANDOM_HEROES_LIST) do
      local heroData = RANDOM_HEROES_LIST[indexHero];
      
      if heroData.hero == randomHero.name then
        countIdentityHeroes = countIdentityHeroes + 1
      end
    end;
  until countIdentityHeroes == 0;
  
  return randomHero;
end;

-- Заполнение ячейки случайным героем
function generateHeroForCell(heroData, preferRaces, withRemove)
  print "generateHeroForCell"
  
  -- Удаление иконки героя, если происходит замена не выбранного
  if withRemove then
    for _, playerId in { PLAYER_1, PLAYER_2 } do
      local icon = heroData.units[playerId];
      
      SetObjectPosition(icon.name, icon.x, icon.y, UNDERGROUND);
    end;
  end;

  local randomRaceId = getRandomRaceForSelectList(preferRaces);
  
  heroData.raceId = randomRaceId;
  
  local randomHero = getRandomUnselectedHeroByRace(randomRaceId);

  heroData.hero = randomHero.name;

  heroData.units[PLAYER_1].name = randomHero[PLAYER_1][1].red_icon;
  heroData.units[PLAYER_2].name = randomHero[PLAYER_1][1].blue_icon;
  
  changeHeroIconsDescription(randomRaceId, heroData.hero);
  
  for playerId = 1, length(heroData.units) do
    local unit = heroData.units[playerId];

    SetObjectPosition(unit.name, unit.x, unit.y, GROUND);
    SetObjectEnabled(unit.name, nil);
    Trigger(OBJECT_TOUCH_TRIGGER, unit.name, 'questionSelectHero' );
  end;
end;

-- Вопрос перед выбором героя
function questionSelectHero(triggerHero, triggeredIconName)
  print "questionSelectHero"

  local player = GetPlayerFilter(GetObjectOwner(triggerHero));

  QuestionBoxForPlayers(player, PATH_TO_DAY1_MESSAGES.."question_select_hero.txt", 'selectHero("'..triggerHero..'", "'..triggeredIconName..'")', 'noop');
end;

-- Получение названия героя по названию одного из его иконок (вложенностей, конечно, многовато)
function getRaceIdAndHeroNameByIconName(iconName)
  print "getRaceIdAndHeroNameByIconName"

  for raceId = 0, length(HEROES_BY_RACE)-1 do
    local raceHeroes = HEROES_BY_RACE[raceId];
    
    for heroIndex = 1, length(raceHeroes) do
      local heroData = raceHeroes[heroIndex];
      
      for playerId = 1, 2 do
        local playerHeroIcons = heroData[playerId];
        
        for iconIndex = 1, length(playerHeroIcons) do
          local icon = playerHeroIcons[iconIndex];
          
          if (icon.red_icon == iconName or icon.blue_icon == iconName) then
            return raceId, heroData.name;
          end
        end;
      end;
    end;
  end;
end;

-- Установка на портрет героя его описание
function changeHeroIconsDescription(raceId, heroName)
  print "changeHeroIconsDescription"
  
  for indexHero = 1, length(HEROES_BY_RACE[raceId]) do
    local heroData = HEROES_BY_RACE[raceId][indexHero];
    
    if heroData.name == heroName then
      for indexPlayer = 1, 2 do
        local playerIcons = heroData[indexPlayer];
        
        for indexIcon = 1, length(playerIcons) do
          local icons = playerIcons[indexIcon];
          
          OverrideObjectTooltipNameAndDescription(icons.red_icon, PATH_TO_HERO_NAMES..heroData.txt, heroData.dsc);
          OverrideObjectTooltipNameAndDescription(icons.blue_icon, PATH_TO_HERO_NAMES..heroData.txt, heroData.dsc);
        end;
      end;
    end;
  end;
end;

-- Получение количества рас, аналогичных переданной
function getCountIdentityRace(playerId, raceId)
  print "getCountIdentityRace"

  local raceList = getPlayerRaceListByPlayerId(playerId);
  local count = 0;
  
  for indexRace = 1, length(raceList) do
    local raceData = raceList[indexRace];
  
    if raceData.raceId == raceId then
      count = count + 1;
    end;
  end;
  
  return count;
end;

-- Действия при выборе героя
function selectHero(triggerHero, iconName)
  print "selectHero"

  local player = GetPlayerFilter(GetObjectOwner(triggerHero));
  local raceId, heroName = getRaceIdAndHeroNameByIconName(iconName);
  
  -- Количества выбранных рас у игрока
  local countSelectedRace = getCountSelectedRace(player);
  -- Количество похожих рас у игрока
  local countIdentityRace = getCountIdentityRace(player, raceId);
  -- Количество выбранных героев в наборе игрока
  local countHeroInRace = getCountHeroInRace(player, raceId);
  
  if (countIdentityRace == 0 and countSelectedRace == 3) then
    ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."impossible_add_race.txt", triggerHero, player, 5);
  elseif countHeroInRace == 3 then
    ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."impossible_add_hero.txt", triggerHero, player, 5);
  else
    addHeroToPlayerHeroList(player, raceId, heroName);

    regenerateHeroAndUpdateSelectList(heroName);

    changeHeroTurn();
  end;
end;

-- Добавление героя в список рас и героев игрока
function addHeroToPlayerHeroList(playerId, raceId, heroName)
  print "addHeroToPlayerHeroList"

  local raceList = getPlayerRaceListByPlayerId(playerId);
  local countPlayerIdentityRace = getCountPlayerIdentityRace(playerId, raceId);
  
  for indexRace = 1, length(raceList) do
    local raceData = raceList[indexRace];
    
    if (countPlayerIdentityRace > 0 and raceData.raceId == raceId) then
      moveHeroIconFromSelectedListToPlayerList(raceData, raceId, heroName);
      
      break;
    end;
    
    if (countPlayerIdentityRace and not raceData.raceId) then
      moveHeroIconFromSelectedListToPlayerList(raceData, raceId, heroName);
      
      break;
    end;
  end;
end;

-- Перенос иконки героев из списка для выбора в список игрока
function moveHeroIconFromSelectedListToPlayerList(raceData, raceId, heroName)
  print "moveHeroIconFromSelectedListToPlayerList"
  
  raceData.raceId = raceId;

  for heroIndex = 1, length(raceData.heroes) do
    local heroData = raceData.heroes[heroIndex];

    if not heroData.hero then
      heroData.hero = heroName;

      local selectedHeroData = getHeroDataFromSelectList(heroName);

      for playerIndex = 1, length(heroData.icons) do
        local playerIcon = heroData.icons[playerIndex]

        playerIcon.name = selectedHeroData.units[playerIndex].name;
        
        SetObjectPosition(playerIcon.name, playerIcon.x, playerIcon.y, GROUND);
        Trigger(OBJECT_TOUCH_TRIGGER, playerIcon.name, 'noop');
      end;

      break;
    end;
  end;
end;

-- Получение данных о герое из списка героев для выбора
function getHeroDataFromSelectList(heroName)
  print "getHeroDataFromSelectList"

  for heroIndex = 1, length(RANDOM_HEROES_LIST) do
    local heroData = RANDOM_HEROES_LIST[heroIndex];

    if heroData.hero == heroName then
      return heroData;
    end;
  end;
end;

-- Получение количества похожих рас в наборе у игрока
function getCountPlayerIdentityRace(playerId, raceId)
  print "getCountPlayerIdentityRace"

  local raceList = getPlayerRaceListByPlayerId(playerId);
  local countIndentityRace = 0;
  
  for indexRace = 1, length(raceList) do
    local raceData = raceList[indexRace];
    
    if raceData.raceId == raceId then
      countIndentityRace = countIndentityRace + 1;
    end;
  end;
  
  return countIndentityRace;
end;

-- Получение набора игрока по ИД героя
function getPlayerRaceListByPlayerId(playerId)
  print "getPlayerRaceListByPlayerId"

  return playerId == PLAYER_1 and PLAYER_1_RACE_LIST or PLAYER_2_RACE_LIST;
end;

-- Получение количество выбранных героев (аналогично количеству ходов игроков)
function getCountSelectedHero()
  print "getCountSelectedHero"
  
  local countSelectedHero = 0;

  for playerId = 1, 2 do
    local raceList = getPlayerRaceListByPlayerId(playerId);
    
    for raceIndex = 1, length(raceList) do
      local raceData = raceList[raceIndex];
      
      if raceData.raceId then
        for heroIndex = 1, length(raceData.heroes) do
          local heroData = raceData.heroes[heroIndex];
          
          if heroData.hero then
            countSelectedHero = countSelectedHero + 1;
          end;
        end;
      end;
    end;
  end;
  
  return countSelectedHero;
end;

-- Получение список всех выбранных героев в черке
function getAllSelectedHeroList()
  print "getAllSelectedHeroList"

  local heroList = {};

  for _, playerId in { PLAYER_1, PLAYER_2 } do
    local raceList = getPlayerRaceListByPlayerId(playerId);
    
    for indexRace = 1, length(raceList) do
      local raceData = raceList[indexRace];
      
      if raceData.raceId then
        for indexHero = 1, length(raceData.heroes) do
          local heroData = raceData.heroes[indexHero];
          
          if heroData.hero then
            heroList[length(heroList)+1] = heroData.hero;
          end;
        end;
      end;
    end;
  end;
  
  for heroIndex = 1, length(RANDOM_HEROES_LIST) do
    local heroData = RANDOM_HEROES_LIST[heroIndex];
    
    if heroData.hero then
      heroList[length(heroList)+1] = heroData.hero;
    end;
  end;
  
  return heroList;
end;

-- Получение поличества выбранных рас у переданного игрока
function getCountSelectedRace(playerId)
  print "getCountSelectedRace"

  -- Количество выбранных рас
  local count = 0;
  local raceList = getPlayerRaceListByPlayerId(playerId);
  
  for raceIndex = 1, length(raceList) do
    local raceData = raceList[raceIndex];

    if raceData.raceId then
      count = count + 1;
    end;
  end;
  
  return count;
end;

-- Получение количества героев определенной расы в наборе игрока
function getCountHeroInRace(playerId, raceId)
  print "getCountHeroInRace"

  local count = 0;
  local raceList = getPlayerRaceListByPlayerId(playerId);
  
  for raceIndex = 1, length(raceList) do
    local raceData = raceList[raceIndex];
    
    if raceData.raceId == raceId then
      for indexHero = 1, length(raceData.heroes) do
        local heroData = raceData.heroes[indexHero];

        if heroData.hero then
          count = count + 1;
        end;
      end;
    end;
  end;
  
  return count;
end;

-- Получение списка заполненных раз у игрока
function getFulfilledRaceList(playerId)
  print "getFulfilledRaceList"

  local fulfilledRaceList = {};
  local raceList = getPlayerRaceListByPlayerId(playerId);

  for raceIndex = 1, length(raceList) do
    local raceData = raceList[raceIndex];

    -- Проверяем, заполнен ли список героев
    local countHero = getCountHeroInRace(playerId, raceData.raceId);

    if countHero == 3 then
      fulfilledRaceList[length(fulfilledRaceList) + 1] = raceData.raceId;
    end;
  end;
  
  return fulfilledRaceList;
end;

-- Получение предпочтительных рас для выбранного игрока
function getPreferRaces()
  print "getPreferRaces"
  
  -- Список предпочтительных рас, если их меньше 2 - любая раса предпочтительна
  local preferRaceTable = {};
  local playerId = getCurrentTurnPlayerId();
  local raceList = getPlayerRaceListByPlayerId(playerId);
  
  -- Количество выбранных рас
  local countSelectedRace = getCountSelectedRace(playerId);
  -- Список рас, список героев которой заполнен максимально
  local fulfilledRaceList = getFulfilledRaceList(playerId);
  
  -- Если список рас не заполнен до конца - актуальны все расы
  if (countSelectedRace == 3 and length(fulfilledRaceList) < 3) then
    for raceIndex = 1, length(raceList) do
      local raceData = raceList[raceIndex];
      
      -- Если раса заполнена героями - не генерировать новых такой же
      local countIdentityRace = 0;
      for _, fulfilledRace in fulfilledRaceList do
        if raceData.raceId == fulfilledRace then
          countIdentityRace = countIdentityRace + 1;
        end;
      end;
      
      if countIdentityRace == 0 then
        preferRaceTable[length(preferRaceTable)+1] = raceData.raceId;
      end;
    end;
  else
    local allRaceList = {
      RACES.HAVEN,
      RACES.INFERNO,
      RACES.NECROPOLIS,
      RACES.SYLVAN,
      RACES.ACADEMY,
      RACES.DUNGEON,
      RACES.FORTRESS,
      RACES.STRONGHOLD,
    };
    
    for _, dictRaceId in allRaceList do
      local countIdentityRace = 0;

      for _, fulfilledRace in fulfilledRaceList do
        if dictRaceId == fulfilledRace then
          countIdentityRace = countIdentityRace + 1;
        end;
      end;
      
      if countIdentityRace == 0 then
        preferRaceTable[length(preferRaceTable)+1] = dictRaceId;
      end;
    end;
  end;
  
  return preferRaceTable;
end;

-- Получение ИД игрока, чей ход начался
function getCurrentTurnPlayerId()
  print "getCurrentTurnPlayerId"

  local countSelectedHero = getCountSelectedHero();

  -- Четные ходы - красный, нечетные - синий
  return mod(countSelectedHero, 2) == 0 and PLAYER_1 or PLAYER_2;
end

-- Обработчик передачи хода между игроками
function changeHeroTurn()
  print "changeHeroTurn"

  if getCurrentTurnPlayerId() == PLAYER_1 then
    removeHeroMovePoints(Djovanni);
    addHeroMovePoints(Biara);
  else
    removeHeroMovePoints(Biara);
    addHeroMovePoints(Djovanni);
  end;
  
  local countSelectedHero = getCountSelectedHero();
  
  -- Если все списки героев заполнены, приступаем к выбору рас
  if countSelectedHero == 18 then
    startSelectRace();
  end;
end;

-- Переход к выбору рас
function startSelectRace()
  print "startSelectRace"
  
  hideSelectHeroes();

  addRandomHeroForAllRaces();
  
  setSelectRaceTriggers();
end;

-- Навешивание триггеров для выбора любого получившегося набора героев
function setSelectRaceTriggers()
  print "setSelectRaceTriggers"

  for _, playerId in { PLAYER_1, PLAYER_2 } do
    local raceList = getPlayerRaceListByPlayerId(playerId);

    for indexRace = 1, length(raceList) do
      local raceData = raceList[indexRace];
      
      for indexHero = 1, length(raceData.heroes) do
        local heroData = raceData.heroes[indexHero];
        
        for indexIcon = 1, length(heroData.icons) do
          local iconData = heroData.icons[indexIcon];
           
          Trigger(OBJECT_TOUCH_TRIGGER, iconData.name, 'questionMixChoiseOfRaceSelectRace');
        end;
      end;
    end;
  end;
end;

-- Вопрос выбора расы
function questionMixChoiseOfRaceSelectRace(triggerHeroName, triggeredIconName)
  print "questionMixChoiseOfRaceSelectRace"
  
  local triggerPlayer = GetPlayerFilter(GetObjectOwner(triggerHeroName));
  local playerOwner = getPlayerIdByIconName(triggeredIconName);
  local message = triggerPlayer == playerOwner and "question_choose_race_yourself.txt" or "question_choose_race_opponent.txt"

  QuestionBoxForPlayers(triggerPlayer, PATH_TO_DAY1_MESSAGES..message, 'handleMixChoiseOfRaceSelectRace("'..triggeredIconName..'")', 'noop');
end;

-- Обработчик добавления расы игроку
function handleMixChoiseOfRaceSelectRace(iconName)
  print "handleMixChoiseOfRaceSelectRace"
  
  local player = getPlayerIdByIconName(iconName);
  local raceId, heroName = getRaceIdAndHeroNameByIconName(iconName);
  local raceList = getPlayerRaceListByPlayerId(player);
  
  for indexRace = 1, length(raceList) do
    local raceData = raceList[indexRace];
    
    for indexHero = 1, length(raceData.heroes) do
      local heroData = raceData.heroes[indexHero];
      
      for indexIcon = 1, length(heroData.icons) do
        local iconData = heroData.icons[indexIcon];
        
        if raceData.raceId == raceId then
          Trigger(OBJECT_TOUCH_TRIGGER, iconData.name, 'noop');
        else
          SetObjectPosition(iconData.name, iconData.x, iconData.y, UNDERGROUND);
        end;
      end;
    end
  end;
  
  addRaceToResultList(player, raceId);
  
  local countHeroList = getCountResultHeroList();
  
  if countHeroList < 2 then
    -- Конец черка
    removeHeroMovePoints(Biara);
    removeHeroMovePoints(Djovanni);
  else
    changePlayerTurnOnSelectRace();
  end
end;

-- Получение количества итоговых наборов
function getCountResultHeroList()
  print "getCountResultHeroList"

  local count = 0;

  for playerId = 1, length(RESULT_HERO_LIST) do
    local playerData = RESULT_HERO_LIST[playerId];
    
    if playerData.raceId then
      count = count + 1;
    end;
  end;
  
  return count;
end;

-- Передача хода между игроками при выборе наборов героев
function changePlayerTurnOnSelectRace()
  print "changePlayerTurnOnSelectRace"
  
  local countHeroList = getCountResultHeroList();
  
  if mod(countHeroList, 2) == 0 then
    removeHeroMovePoints(Djovanni);
    addHeroMovePoints(Biara);
  else
    removeHeroMovePoints(Biara);
    addHeroMovePoints(Djovanni);
  end;
end;

-- Добавление случайных героев из набора игрока в итоговый список героев
function addRaceToResultList(playerId, raceId)
  print "addRaceToResultList"
  
  local resultPlayerData = RESULT_HERO_LIST[playerId];
  
  resultPlayerData.raceId = raceId;
  
  local raceList = getPlayerRaceListByPlayerId(playerId);
  
  for indexRace = 1, length(raceList) do
    local raceData = raceList[indexRace];

    if raceData.raceId == raceId then
      for indexHero = 1, 2 do
        local randomHeroName, countIdentityHero;
        
        repeat
          countIdentityHero = 0;
          
          local randomHeroIndex = random(length(raceData.heroes)) + 1;
          randomHeroName = raceData.heroes[randomHeroIndex];
          
          for _, heroName in resultPlayerData.heroes do
            if heroName == randomHeroName then
              countIdentityHero = countIdentityHero + 1;
            end;
          end;
        until countIdentityHero == 0;
        
        resultPlayerData.heroes[indexHero] = randomHeroName;
      end;
    end;
  end;
  
  -- Генерируем дополнительного случайного героя этой расы, отличного от имеющихся 2
  local randomHeroName, countIdentityHero;
  
  repeat
    countIdentityHero = 0;
    
    local randomHeroIndex = random(length(HEROES_BY_RACE[raceId])) + 1;
    randomHeroName = HEROES_BY_RACE[raceId][randomHeroIndex];
    
    for _, heroName in resultPlayerData.heroes do
      if heroName == randomHeroName then
        countIdentityHero = countIdentityHero + 1;
      end;
    end;
  until countIdentityHero == 0;

  resultPlayerData.heroes[3] = randomHeroName;
end

-- Получение ИД игрока-владельца переданного портрета
function getPlayerIdByIconName(iconName)
  print "getPlayerIdByIconName"

  for _, playerId in { PLAYER_1, PLAYER_2 } do
    local raceList = getPlayerRaceListByPlayerId(playerId);

    for indexRace = 1, length(raceList) do
      local raceData = raceList[indexRace];

      for indexHero = 1, length(raceData.heroes) do
        local heroData = raceData.heroes[indexHero];

        for indexIcon = 1, length(heroData.icons) do
          local iconData = heroData.icons[indexIcon];

          if iconData.name == iconName then
            return playerId;
          end;
        end;
      end;
    end;
  end;
end;

-- Добавление в списки рас игроков случайных героев
function addRandomHeroForAllRaces()
  print "addRandomHeroForAllRaces"

  for _, playerId in { PLAYER_1, PLAYER_2 } do
    local raceList = getPlayerRaceListByPlayerId(playerId);
    
    for indexRace = 1, length(raceList) do
      local raceData = raceList[indexRace];
      local randomHero = getRandomUnselectedHeroByRace(raceData.raceId);
      local mapPlayerIdByIcon = {
        [PLAYER_1] = randomHero[PLAYER_1][1].red_icon,
        [PLAYER_2] = randomHero[PLAYER_1][1].blue_icon,
      }
      
      raceData.heroes[4].hero = randomHero.name;

      for iconIndex = 1, length(raceData.heroes[4].icons) do
        local icon = raceData.heroes[4].icons[iconIndex];
        
        icon.name = mapPlayerIdByIcon[iconIndex];
        
        SetObjectPosition(icon.name, icon.x, icon.y, GROUND);
        SetObjectEnabled(icon.name, nil);
        Trigger(OBJECT_TOUCH_TRIGGER, icon.name, 'noop');
      end;
    end;
  end;
end;

-- Скрытие списка героев для выбора
function hideSelectHeroes()
  print "hideSelectHeroes"

  for heroIndex = 1, length(RANDOM_HEROES_LIST) do
    local heroData = RANDOM_HEROES_LIST[heroIndex];
    
    for _, playerId in { PLAYER_1, PLAYER_2 } do
      local icon = heroData.units[playerId];
      
      SetObjectPosition(icon.name, icon.x, icon.y, UNDERGROUND);
    end;
  end;
end;

mixChoiseOfRace();
