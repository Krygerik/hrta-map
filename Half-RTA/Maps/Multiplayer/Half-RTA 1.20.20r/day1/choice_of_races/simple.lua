-- ������, ����������� �������� ������ ���� ��� ������� ������

-- ����������� ������ �����������
doFile(PATH_TO_DAY1_MODULE.."choice_of_races/common.lua");
sleep(1);

-- ������ ���� ������� � ������� ��� ����� ������� � ������������ �� ��������� ����������
ALL_RACES_WITH_COORDINATES = {
  { raceId = RACES.HAVEN,       question = "question_play_haven.txt",          [PLAYER_1] = { unit = 'human1', x = 31, y = 88 }, [PLAYER_2] = { unit = 'human2vrag', x = 46, y = 23 } },
  { raceId = RACES.INFERNO,     question = "question_play_inferno.txt",        [PLAYER_1] = { unit = 'demon1', x = 31, y = 86 }, [PLAYER_2] = { unit = 'demon2vrag', x = 46, y = 21 } },
  { raceId = RACES.NECROPOLIS,  question = "question_play_necropolis.txt",     [PLAYER_1] = { unit = 'nekr1',  x = 31, y = 90 }, [PLAYER_2] = { unit = 'nekr2vrag',  x = 46, y = 25 } },
  { raceId = RACES.SYLVAN,      question = "question_play_sylvan.txt",         [PLAYER_1] = { unit = 'elf1',   x = 31, y = 84 }, [PLAYER_2] = { unit = 'elf2vrag',   x = 46, y = 19 } },
  { raceId = RACES.ACADEMY,     question = "question_play_academy.txt",        [PLAYER_1] = { unit = 'mag1',   x = 38, y = 23 }, [PLAYER_2] = { unit = 'mag2vrag',   x = 39, y = 88 } },
  { raceId = RACES.DUNGEON,     question = "question_play_dungeon.txt",        [PLAYER_1] = { unit = 'liga1',  x = 38, y = 21 }, [PLAYER_2] = { unit = 'liga2vrag',  x = 39, y = 86 } },
  { raceId = RACES.FORTRESS,    question = "question_play_fortress.txt",       [PLAYER_1] = { unit = 'gnom1',  x = 38, y = 25 }, [PLAYER_2] = { unit = 'gnom2vrag',  x = 39, y = 90 } },
  { raceId = RACES.STRONGHOLD,  question = "question_play_stronghold.txt",     [PLAYER_1] = { unit = 'ork1',   x = 38, y = 19 }, [PLAYER_2] = { unit = 'ork2vrag',   x = 39, y = 84 } },
};

-- ����� �����
function simple_choice_of_races()
  print "simple_choice_of_races"

  -- ����������� �����������
  disableAreaInteractive();
  changeChoiceArea();
  
  -- ������������� ����� ��� ���������� ������ ���
  showMummy();
  
  -- ��� ����
  showAllRaces();
end;

-- ��������� ��������� �����������
function changeChoiceArea()
  print "changeChoiceArea"

  SetObjectPosition('blue1', 44, 24);
  SetObjectPosition('blue2', 45, 24);
  SetObjectPosition('blue3', 46, 24);
  SetObjectPosition('blue4', 44, 22);
  SetObjectPosition('blue5', 45, 22);
  SetObjectPosition('blue6', 46, 22);
  SetObjectPosition('blue7', 44, 20);
  SetObjectPosition('blue8', 45, 20);
  SetObjectPosition('blue9', 46, 20);
  SetObjectPosition('red12', 37, 89);
  SetObjectPosition('red13', 38, 89);
  SetObjectPosition('red14', 39, 89);
  SetObjectPosition('red15', 37, 87);
  SetObjectPosition('red16', 38, 87);
  SetObjectPosition('red17', 39, 87);
  SetObjectPosition('red18', 37, 85);
  SetObjectPosition('red19', 38, 85);
  SetObjectPosition('red20', 39, 85);
end;

-- ������������� ����� � ���������� �������
function showMummy()
  print "showMummy"

  SetObjectEnabled('mumiya', nil);
  SetObjectPosition('mumiya', 35, 91);
  SetDisabledObjectMode('mumiya', DISABLED_INTERACT);
  Trigger(OBJECT_TOUCH_TRIGGER, 'mumiya', 'questionRandomRace');
end;

-- ������ ������ ��������� ����
function questionRandomRace()
  print "questionRandomRace"
  
  QuestionBoxForPlayers(GetPlayerFilter(PLAYER_1), PATH_TO_DAY1_MESSAGES.."question_random_race.txt", 'setRandomRace', 'noop');
end;

-- ��������� ��������� ��� ��� ����� �������
function setRandomRace()
  print "setRandomRace"
  
  for playerIndex = 1, 2 do
    SELECTED_RACE_ID_TABLE[playerIndex] = random(8);
  end;
  
  finishSimpleChoiseOfRaces();
end;

-- ��������� ���� ��� ��� ������� ������
function showAllRaces()
  print "showAllRaces"

  for indexRace = 1, length(ALL_RACES_WITH_COORDINATES) do
    local currentRace = ALL_RACES_WITH_COORDINATES[indexRace];
    
    setHanderOnRace(currentRace[PLAYER_1]);
    setHanderOnRace(currentRace[PLAYER_2]);
  end;
end;

-- ��������� ���������� ���� � ������������ ����� � ����������� ��������
function setHanderOnRace(race)
  print "setHanderOnRace"
  
  SetObjectPosition(race.unit, race.x, race.y);
  SetDisabledObjectMode(race.unit, DISABLED_INTERACT);
  Trigger(OBJECT_TOUCH_TRIGGER, race.unit, 'questionPickRace');
end;

-- ������ ��� ������ ����
function questionPickRace(triggeredHero, triggerRaceUnit)
  print "questionPickRace"
  
  local race = getRaceByRaceUnit(triggerRaceUnit);
  local player = GetPlayerFilter(GetObjectOwner(triggeredHero));

  QuestionBoxForPlayers(player, PATH_TO_DAY1_MESSAGES..race.question, 'selectRace("'..player..'","'..race.raceId..'")', 'noop');
end;

-- ��������� ���� �� ������ �� �� ������
function getRaceByRaceUnit(unitName)
  print "getRaceByRaceUnit"
  
  for indexRace = 1, length(ALL_RACES_WITH_COORDINATES) do
    local currentRace = ALL_RACES_WITH_COORDINATES[indexRace];
    
    if (currentRace[PLAYER_1].unit == unitName or currentRace[PLAYER_2].unit == unitName) then
      return currentRace;
    end;
  end;
end;

-- ������ ��������� ���� � ������ ��� ��� ����� ������
function selectRace(playerId, raceId)
  print "selectRace"

  -- �������� �� ������ � �����
  local playerId = playerId + 0;
  local raceId = raceId + 0;
  
  SELECTED_RACE_ID_TABLE[playerId] = raceId;
  
  if playerId == PLAYER_1 then
    removeHeroMovePoints(Biara);
  else
    removeHeroMovePoints(Djovanni);
  end;
  
  local countSelectedRace = getSimpleChoiseCountSelectedRace();
  
  if countSelectedRace == 2 then
    finishSimpleChoiseOfRaces();
  end;
end;

-- ��������� ���������� ��������� ���
function getSimpleChoiseCountSelectedRace()
  print "getSimpleChoiseCountSelectedRace"
  
  local countSelectedRace = 0;
  
  for playerIndex = 1, 2 do
    if SELECTED_RACE_ID_TABLE[playerIndex] then
      countSelectedRace = countSelectedRace + 1;
    end;
  end;

  return countSelectedRace;
end;

-- ��������� �������� ������ ���
function finishSimpleChoiseOfRaces()
  print "finishSimpleChoiseOfRaces"
  
  RemoveObject('mumiya');
  deleteAllDelimeters();
  deleteAllRacesUnit();

  doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_group_heroes.lua");
end;

-- �������� ���� ������, ��� ������ ���
function deleteAllRacesUnit()
  print "deleteAllRacesUnit"
  
  for indexRace = 1, length(ALL_RACES_WITH_COORDINATES) do
    local currentRace = ALL_RACES_WITH_COORDINATES[indexRace];

    RemoveObject(currentRace[PLAYER_1].unit)
    RemoveObject(currentRace[PLAYER_2].unit)
  end;
end;

simple_choice_of_races();