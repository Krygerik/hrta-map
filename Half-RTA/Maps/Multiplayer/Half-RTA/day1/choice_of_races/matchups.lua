-- Скрипт, описывающий механизм выбора расы при черке матчапов

-- Подключение общего функционала
doFile(PATH_TO_DAY1_MODULE.."choice_of_races/common.lua");
sleep(1);

-- Список всех матчапов, для заполнения и предоставления игрокам
MATCHUPS = {
  {
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm111', poster = 'PosterRed_1', x = 31, y = 90, rot = 90 },
      {name = 'm112', poster = 'PosterRed_7', x = 39, y = 25, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm211', poster = 'PosterBlue_7', x = 32, y = 90, rot = 270 },
      {name = 'm212', poster = 'PosterBlue_1', x = 38, y = 25, rot = 90 },
    }},
  },
  {
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm121', poster = 'PosterRed_2', x = 38, y = 90, rot = 90 },
      {name = 'm122', poster = 'PosterRed_8', x = 46, y = 25, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm222', poster = 'PosterBlue_8', x = 39, y = 90, rot = 270 },
      {name = 'm221', poster = 'PosterBlue_2', x = 45, y = 25, rot = 90 },
    }},
  },
  {
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm131', poster = 'PosterRed_3', x = 31, y = 87, rot = 90 },
      {name = 'm132', poster = 'PosterRed_9', x = 39, y = 22, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm232', poster = 'PosterBlue_9', x = 32, y = 87, rot = 270 },
      {name = 'm231', poster = 'PosterBlue_3', x = 38, y = 22, rot = 90 },
    }},
  },
  {
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm141', poster = 'PosterRed_4', x = 38, y = 87, rot = 90 },
      {name = 'm142', poster = 'PosterRed_10', x = 46, y = 22, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm242', poster = 'PosterBlue_10', x = 39, y = 87, rot = 270 },
      {name = 'm241', poster = 'PosterBlue_4',  x = 45, y = 22, rot = 90 },
    }},
  },
  {
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm151', poster = 'PosterRed_5',  x = 31, y = 84, rot = 90 },
      {name = 'm152', poster = 'PosterRed_11', x = 39, y = 19, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm252', poster = 'PosterBlue_11', x = 32, y = 84, rot = 270 },
      {name = 'm251', poster = 'PosterBlue_5',  x = 38, y = 19, rot = 90 },
    }},
  },
  {
    [PLAYER_1] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm161', poster = 'PosterRed_6',  x = 38, y = 84, rot = 90 },
      {name = 'm162', poster = 'PosterRed_12', x = 46, y = 19, rot = 270 },
    }},
    [PLAYER_2] = { raceId = nil, creatureId = nil, score = nil, creatures = {
      {name = 'm262', poster = 'PosterBlue_12', x = 39, y = 84, rot = 270 },
      {name = 'm261', poster = 'PosterBlue_6',  x = 45, y = 19, rot = 90 },
    }},
  },
};

-- Точка входа
function choiseMatchupsOfRaces()
  print "choiseMatchupsOfRaces"
  
  deleteAllDelimeters();
  
  generateAllMatchups();
  
  showAllMatchups();
end;

-- Генерация всех матчапов для выбора
function generateAllMatchups()
  print "generateAllMatchups"
  
  for indexMatchups = 1, length(MATCHUPS) do
    local matchup = MATCHUPS[indexMatchups];
    local randomMatchup, countMatchups, countMirrors;
    
    repeat
      randomMatchup = generateRandomMatchup();
      countMatchups = getCountMatchups(randomMatchup);
      countMirrors = getCountMirrorMatchups(randomMatchup);
    until countMatchups == 0 and countMirrors < 2;
    
    matchup[PLAYER_1].raceId = randomMatchup[1];
    matchup[PLAYER_1].creatureId = MAPPING_RACE_TO_CREATURES[randomMatchup[1]].ID1;
    matchup[PLAYER_2].raceId = randomMatchup[2];
    matchup[PLAYER_2].creatureId = MAPPING_RACE_TO_CREATURES[randomMatchup[2]].ID1;
    
    changeMatchupPostersDescription(matchup);
  end;
end;

-- Изменение описания постеров
function changeMatchupPostersDescription(matchup)
  print "changePostersDescription"
  
  for playerId = 1, length(matchup) do
    local sideData = matchup[playerId];
  
    for indexUnit = 1, length(sideData.creatures) do
      local unit = sideData.creatures[indexUnit];


      OverrideObjectTooltipNameAndDescription(unit.poster, MAP_RACE_ID_TO_RACE_NAME[sideData.raceId], GetMapDataPath().."notext.txt");
    end;
  end;
end;

-- Получение случайных данных для нового матчапа
function generateRandomMatchup()
  print "generateRandomMatchup"

  local randomRace1 = getRandomRace();
  local randomRace2 = getRandomRace();
  
  return {
    randomRace1,
    randomRace2,
  };
end;

-- Получение количества переданных матчапов
function getCountMatchups(matchup)
  print "getCountMatchups"
  
  local count = 0;
  
  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];

    if (
      currentMatchup[PLAYER_1].raceId == matchup[1]
      and currentMatchup[PLAYER_2].raceId == matchup[2]
    ) then
      count = count + 1;
    end;
  end;
  
  return count
end;

-- Получение количества зеркальных матчапов включая переданный
function getCountMirrorMatchups(matchup)
  print "getCountMirrorMatchups"

  local count = 0;

  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];

    if (
     currentMatchup[PLAYER_1].raceId and currentMatchup[PLAYER_2].raceId
     and currentMatchup[PLAYER_1].raceId == currentMatchup[PLAYER_2].raceId
    ) then
      count = count + 1;
    end;
  end;
  
  if matchup[1] == matchup[2] then
     count = count + 1;
  end

  return count;
end;

-- Отображение всех сгенерированных матчапов и навешивание триггеров
function showAllMatchups()
  print "showAllMatchups"
  
  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];

    for playerId = 1, 2 do
      local playerData = currentMatchup[playerId];
      
      for indexUnit = 1, length(playerData.creatures) do
        local unit = playerData.creatures[indexUnit];
        
        showSingleUnit(unit, playerData.creatureId);
      end;
    end;
  end;
end;

-- Показ одиночного юнита и навешивание на него триггера
function showSingleUnit(unit, creatureId)
  print "showSingleUnit"
  
  SetObjectPosition(unit.poster, unit.x, unit.y, GROUND);
  SetObjectEnabled(unit.poster, nil);
  CreateMonster(unit.name, creatureId, 1, unit.x, unit.y, GROUND, 1, 2, unit.rot, 0);
  SetObjectEnabled(unit.name, nil);
  Trigger(OBJECT_TOUCH_TRIGGER, unit.name, 'questionRemoveMatchup');
  SetObjectPosition(unit.name, unit.x, unit.y, GROUND);
end;

-- Вопрос желает ли игрок вычеркнуть этот матчап
function questionRemoveMatchup(triggeredHero, triggerUnit)
  print "questionRemoveMatchup"
  
  local playerId = GetPlayerFilter(GetObjectOwner(triggeredHero))

  QuestionBoxForPlayers(playerId, PATH_TO_DAY1_MESSAGES.."question_delete_matchup.txt", 'removeMatchup("'..playerId..'", "'..triggerUnit..'")', 'noop');
end;

-- Получение матчапа по name переданного существа
function getMatchupByUnit(inputUnit)
  print "getMatchupByUnit"

  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];

    for playerId = 1, 2 do
      local playerData = currentMatchup[playerId];

      for indexUnit = 1, length(playerData.creatures) do
        local unit = playerData.creatures[indexUnit];

        if unit.name == inputUnit then
          return currentMatchup;
        end;
      end;
    end;
  end;
end;

-- Получение количества удаленных матчапов у переданного игрока
function getCountRemoveMatchupByPlayer(playerId)
  print "getCountRemoveMatchupByPlayer"
  
  local count = 0;

  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];
    local matchupPlayerData = currentMatchup[playerId];
    
    if matchupPlayerData.score then
      count = count + 1;
    end;
  end;
  
  return count;
end;

-- Скрытие переданного матчапа для переданного игрока
function hideMatchupForPlayer(matchup, player)
  print "hideMatchupForPlayer"
  
  for playerId = 1, length(matchup) do
    local unit = matchup[playerId].creatures[player];
    
    RemoveObject(unit.name);
    RemoveObject(unit.poster);
  end;
end;

-- Удаление последнего оставшегося матчапа у игрока
function removeLastMatchupForPlayer(player)
  print "removeLastMatchupForPlayer"
  
  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];
    local matchupPlayerData = currentMatchup[player];

    if not matchupPlayerData.score then
      matchupPlayerData.score = 5;
      ShowFlyingSign({ PATH_TO_DAY1_MESSAGES.."score.txt"; eq = 5}, matchupPlayerData.creatures[player].name, player, 2.0);
      
      hideMatchupForPlayer(currentMatchup, player);
    end;
  end;
end;

-- Получение количества сторон, закончивших черк
function getCountSideFinishedCherk()
  print "getCountSideFinishedCherk"

  local count = 0;
  
  for playerId = 1, 2 do
    local countRemoveMA = getCountRemoveMatchupByPlayer(playerId);
    
    if countRemoveMA == 6 then
      count = count + 1;
    end;
  end;
  
  return count;
end;

-- Завершение черка переданному игроку
function finishPlayerChoise(playerId)
  print "finishPlayerChoise"

  local hero = playerId == PLAYER_1 and Biara or Djovanni;
  
  removeHeroMovePoints(hero);
  removeLastMatchupForPlayer(playerId);
  
  local countSideFinished = getCountSideFinishedCherk();
  
  if countSideFinished == 2 then
    finishChoiseOfMatchups();
  end;
end;

-- Получение матчапа с максимальным количеством очков
function getMaximumScoreMatchup()
  print "getMaximumScoreMatchup"
  
  local maxSummaryScoreMatchupIndex = 0;
  local maxSummareScore = 0;

  for indexMatchups = 1, length(MATCHUPS) do
    local currentMatchup = MATCHUPS[indexMatchups];

    local sumScore = currentMatchup[PLAYER_1].score + currentMatchup[PLAYER_2].score;

    if sumScore > maxSummareScore then
      maxSummaryScoreMatchupIndex = indexMatchups;
      maxSummareScore = sumScore;
    end;
  end;
  
  return MATCHUPS[maxSummaryScoreMatchupIndex];
end;

-- Окончание черка матчапов
function finishChoiseOfMatchups()
  print "finishChoiseOfMatchups"
  
  local resultMatchup = getMaximumScoreMatchup();
  
  for playerId = 1, 2 do
    SELECTED_RACE_ID_TABLE[playerId] = resultMatchup[playerId].raceId;
  end;

  doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_group_heroes.lua");
end;

-- Обработчик удаления матчапа и выставления очков матчу
function removeMatchup(playerId, unit)
  print "removeMatchup"
  
  local playerId = playerId + 0;
  local matchup = getMatchupByUnit(unit);

  local countPlayerDeletedMatchups = getCountRemoveMatchupByPlayer(playerId);
  
  matchup[playerId].score = countPlayerDeletedMatchups;
  ShowFlyingSign({ PATH_TO_DAY1_MESSAGES.."score.txt"; eq = countPlayerDeletedMatchups}, unit, playerId, 2.0);
  
  hideMatchupForPlayer(matchup, playerId);
  
  if countPlayerDeletedMatchups == 4 then
    finishPlayerChoise(playerId);
  end;
end;

choiseMatchupsOfRaces();
