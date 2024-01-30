-- ������, ����������� �������� ������ ���� ��� ������� ������

-- ����������� ������ �����������
doFile(PATH_TO_DAY1_MODULE.."choice_of_races/common.lua");
sleep(1);

-- ����� �����
function simple_choice_of_races()
  print "simple_choice_of_races"

  -- ����������� �����������
  disableAreaInteractive();
  changeChoiceArea();
  
  -- ������������� ����� ��� ���������� ������ ���
  doFile(PATH_TO_DAY1_MODULE.."choice_of_races/mummy/mummy.lua");

  -- ������������� ������ ��� ������ ����-����
  doFile(PATH_TO_DAY1_MODULE.."choice_of_races/game_mode/golem.lua");
  
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
  RemoveObject('golem');
  SetObjectPosition('red10', 35, 83, GROUND);
  deleteAllDelimeters();
  deleteAllRacesUnit();

  if CUSTOM_GAME_MODE_ONLY_CHERK_SINGLE_HEROES == 1 then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_single_heroes.lua");
  else
    doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_group_heroes.lua");
  
  end;
end;



simple_choice_of_races();