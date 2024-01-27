-- Устанавливаем мумию и навешиваем триггер
function showMummy()
  print "showMummy"

  SetObjectEnabled('mumiya', nil);
  SetObjectPosition('mumiya', 35, 91);
  SetDisabledObjectMode('mumiya', DISABLED_INTERACT);
  Trigger(OBJECT_TOUCH_TRIGGER, 'mumiya', 'questionRandomRace');
end;

-- Вопрос выбора случайных фракций
function questionRandomRace()
  print "questionRandomRace"

  QuestionBoxForPlayers(GetPlayerFilter(PLAYER_1), PATH_TO_DAY1_MESSAGES.."question_random_race.txt", 'prepareForRandomChoise', 'questionRandomMirror');
end;

-- Вопрос выбора случайной зеркалки
function questionRandomMirror()
  print "questionRandomMirror"

  QuestionBoxForPlayers(GetPlayerFilter(PLAYER_1), PATH_TO_DAY1_MESSAGES.."question_random_mirror.txt", 'prepareForRandomMirror', 'noop');
end;

-- Подготовка к рандомному черку фракции
function prepareForRandomChoise()
  print "prepareForRandomChoise"

  RemoveObject('mumiya');
  moveDelimetersToRandomChoise();
  deleteAllRacesUnit();
  setRandomRace();
  
  RemoveObject('golem');
  SetObjectPosition('red10', 35, 83, GROUND);

  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);
  
  initPlayerControl();
  showGeneratedRaces();
end;

-- Подготовка к зеркальному черку
function prepareForRandomMirror()
  print "prepareForRandomMirror"
  
  CUSTOM_GAME_MODE_ONLY_MIRROR = 1;
  prepareForRandomChoise()
end;


-- Установка рандомных рас для обоих игроков
function setRandomRace()
  print "setRandomRace"

  SELECTED_RACE_ID_TABLE[PLAYER_1] = random(8);

  local randomSecondPlayerRaceId;

  repeat
    randomSecondPlayerRaceId = random(8);
  until randomSecondPlayerRaceId ~= SELECTED_RACE_ID_TABLE[PLAYER_1];
  
  SELECTED_RACE_ID_TABLE[PLAYER_2] = randomSecondPlayerRaceId;
  
  if CUSTOM_GAME_MODE_ONLY_MIRROR == 1 then
    SELECTED_RACE_ID_TABLE[PLAYER_2] = SELECTED_RACE_ID_TABLE[PLAYER_1];
  end;
end;

--Генерация возможности перегенерации и соглашения
function initPlayerControl()
  print "initPlayerControl"
  local POSITIVE_OBJECTS = {
    [PLAYER_1] = { name = "spell_nabor1", x = 34, y = 87 },
    [PLAYER_2] = { name = "spell_nabor2", x = 41, y = 22 },
  }

  local NEGATIVE_OBJECTS = {
    [PLAYER_1] = { name = "spell_nabor3", x = 36, y = 87 },
    [PLAYER_2] = { name = "spell_nabor4", x = 43, y = 22 },
  }

  for playerIndex = 1, 2 do

    local positiveObject = POSITIVE_OBJECTS[playerIndex];

    SetObjectPosition(positiveObject.name, positiveObject.x, positiveObject.y, GROUND);
    SetObjectEnabled (positiveObject.name, nil);
    Trigger(OBJECT_TOUCH_TRIGGER, positiveObject.name, 'questionApproval');
    OverrideObjectTooltipNameAndDescription (
      positiveObject.name,
      PATH_TO_DAY1_MODULE.."choice_of_races/mummy/positive_choise.txt",
      PATH_TO_DAY1_MODULE.."choice_of_races/mummy/positive_choise_description.txt"
    );

    local negativeObject = NEGATIVE_OBJECTS[playerIndex];

    SetObjectPosition(negativeObject.name, negativeObject.x, negativeObject.y, GROUND);
    SetObjectEnabled (negativeObject.name, nil);
    Trigger(OBJECT_TOUCH_TRIGGER, negativeObject.name, 'questionReroll');
    OverrideObjectTooltipNameAndDescription (
      negativeObject.name,
      PATH_TO_DAY1_MODULE.."choice_of_races/mummy/negative_choise.txt",
      PATH_TO_DAY1_MODULE.."choice_of_races/mummy/negative_choise_description.txt"
    );
  end;
end;

-- Показывает сгенерированные фракции
function showGeneratedRaces()
  print "showGeneratedRaces"
  
  local RED_FIELD = {
    [PLAYER_1] = {x = 31, y = 87 },
    [PLAYER_2] = {x = 39, y = 87 },
  }
  
  local BLUE_FIELD = {
    [PLAYER_1] = {x = 46, y = 22 },
    [PLAYER_2] = {x = 38, y = 22 },
  }
  for playerIndex = 1, 2 do

    local raceId = SELECTED_RACE_ID_TABLE[playerIndex];
    local raceData = ALL_RACES_WITH_COORDINATES[raceId+1];
    
    local unitForRedFiend = raceData[PLAYER_1].unit;
    local unitForBlueFiend = raceData[PLAYER_2].unit;

    SetObjectPosition(unitForRedFiend, RED_FIELD[playerIndex].x, RED_FIELD[playerIndex].y, GROUND)
    SetObjectPosition(unitForBlueFiend, BLUE_FIELD[playerIndex].x, BLUE_FIELD[playerIndex].y, GROUND)
    SetObjectRotation(unitForRedFiend, 0);
    SetObjectRotation(unitForBlueFiend, 0);
  end;
  
end;

-- Вопрос согласия
function questionApproval(trigerhero)
print "questionApproval"
  local playerId = GetPlayerFilter(GetObjectOwner(trigerhero))
  QuestionBoxForPlayers(playerId, PATH_TO_DAY1_MODULE.."choice_of_races/mummy/check_question.txt", 'playerApproval('..playerId..')', 'noop');
end;

PLAYERS_APPROVAL = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
}

-- После согласия на вопрос
function playerApproval(strPlayerId)
print "playerApproval"
  local playerId = strPlayerId + 0;
  PLAYERS_APPROVAL[playerId] = not nil;

  if PLAYERS_APPROVAL[PLAYER_1] and PLAYERS_APPROVAL[PLAYER_2] then
    finishRandomChoise();
  end;

end;

PLAYERS_MOMENT_REROLL = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
}

-- Вопрос для реролла
function questionReroll(trigerhero)
print "questionReroll"

  local playerId = GetPlayerFilter(GetObjectOwner(trigerhero))
  PLAYERS_MOMENT_REROLL[playerId] = PLAYERS_REROLL_COUNT[playerId == PLAYER_1 and PLAYER_2 or PLAYER_1]
  print('PLAYERS_MOMENT_REROLL', PLAYERS_MOMENT_REROLL[playerId])
  print('PLAYERS_REROLL_COUNT', PLAYERS_REROLL_COUNT[playerId == PLAYER_1 and PLAYER_2 or PLAYER_1])
  QuestionBoxForPlayers(playerId, PATH_TO_DAY1_MODULE.."choice_of_races/mummy/check_reroll.txt", 'playerReroll('..playerId..')', 'noop');
end;

PLAYERS_REROLL_COUNT = {
  [PLAYER_1] = 1,
  [PLAYER_2] = 1,
}

-- После реролла
function playerReroll(strPlayerId)
print "playerReroll"

  local playerId = strPlayerId + 0;
  print('2_PLAYERS_MOMENT_REROLL_2', PLAYERS_MOMENT_REROLL[playerId])
  print('PLAYERS_REROLL_COUNT', PLAYERS_REROLL_COUNT[playerId == PLAYER_1 and PLAYER_2 or PLAYER_1])

  if PLAYERS_MOMENT_REROLL[playerId] ~= PLAYERS_REROLL_COUNT[playerId == PLAYER_1 and PLAYER_2 or PLAYER_1] then
    local hero = playerId == PLAYER_1 and Biara or Djovanni;
    ShowFlyingSign(PATH_TO_DAY1_MODULE.."choice_of_races/mummy/reroll_canceled.txt", hero, playerId, 5.0);
    return nil;
  end;
  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);
  PLAYERS_REROLL_COUNT[playerId] = PLAYERS_REROLL_COUNT[playerId] - 1;
  
   local NEGATIVE_OBJECTS = {
    [PLAYER_1] = "spell_nabor3",
    [PLAYER_2] = "spell_nabor4",
  }
  
  for playerIndex = 1, 2 do
    PLAYERS_APPROVAL[playerIndex] = nil;
  end;
  
  if PLAYERS_REROLL_COUNT[playerId] < 1 then
    Trigger(OBJECT_TOUCH_TRIGGER, NEGATIVE_OBJECTS[playerId], 'noop');
    PLAYERS_APPROVAL[playerId] = not nil;
  end;
  


  deleteAllRacesUnit();
  setRandomRace();
  showGeneratedRaces();
  
  if PLAYERS_REROLL_COUNT[PLAYER_1] + PLAYERS_REROLL_COUNT[PLAYER_2] < 1 then
    finishRandomChoise();
  end;
  
end;

--Убираем ненужные объекты после черка и выбираем нужный черк
function finishRandomChoise()
    deleteAllDelimeters();
    SetObjectPosition('spell_nabor1', 1, 1, UNDERGROUND)
    SetObjectPosition('spell_nabor2', 1, 1, UNDERGROUND)
    SetObjectPosition('spell_nabor3', 1, 1, UNDERGROUND)
    SetObjectPosition('spell_nabor4', 1, 1, UNDERGROUND)
    deleteAllRacesUnit();
    
    checkCustomGamemode()
end;

--Проверка игрового мода и смена черка героев
function checkCustomGamemode()
print"checkCustomGamemode"

  if CUSTOM_GAME_MODE_ONLY_CHERK_SINGLE_HEROES == 1 then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_single_heroes.lua");
  else
    doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_group_heroes.lua");
  end;
end;

showMummy()