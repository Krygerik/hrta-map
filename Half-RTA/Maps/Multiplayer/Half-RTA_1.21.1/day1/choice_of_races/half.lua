-- ������, ����������� �������� ������ ���� ��� ���������

-- ����������� ������ �����������
doFile(PATH_TO_DAY1_MODULE.."choice_of_races/common.lua");
sleep(1);

-- ������ ��� �������, ����������� � ������ ��������������� ����
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

-- ����� �����
function half_choice_of_races()
  print "half_choice_of_races"
  
  disableAreaInteractive();
  changeChooseArea();

  -- ����������� ������ ������� �� ������� ��� �����
  SetObjectPosition(Biara, 34, 87, GROUND);
  SetObjectPosition(Djovanni, 43, 22, GROUND);

  for raceIndex = 0, 9 do
    local randomRaceId;
    local countEqualRace;

    -- ���������, ���� �� ����������� ����������� ����
    -- (�� ������������ ������ ������� ����� ����)
    repeat
      randomRaceId = getRandomRace();
      -- ���������� ���������� ���, ������ ���������
      countEqualRace = getCountRacesByRaceId(randomRaceId);
    until countEqualRace < 2;

    randomGenerateRaceList[raceIndex].raceId = randomRaceId;

    -- ��������� id ������������ ������ ���� ����
    setCreaturesPairInToRace(raceIndex, randomRaceId);

    -- �������� ������� ��� ������ ���� � ����� �������
    createRaceRepresentativeForEveryPlayer(raceIndex, randomRaceId);
  end;
end;

-- ��������� ���������� ������� � ������, ������ ����������
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

-- ��������� ������� ��� ������ � ��������������� ����
function setCreaturesPairInToRace(index, raceId)
  print "setCreaturesPairInToRace"
  
  randomGenerateRaceList[index].red_unit.unitId = MAPPING_RACE_TO_CREATURES[raceId].ID1;
  randomGenerateRaceList[index].blue_unit.unitId = MAPPING_RACE_TO_CREATURES[raceId].ID2;
end;

-- �������� �������-�������������� ��� ������ ���� ��� ����� �������
function createRaceRepresentativeForEveryPlayer(raceIndex, raceId)
  print "createRaceRepresentativeForEveryPlayer"
  
  local red_unit = randomGenerateRaceList[raceIndex].red_unit;
  local blue_unit = randomGenerateRaceList[raceIndex].blue_unit;

  createRaceRepresentativeUtil(red_unit.name, red_unit.unitId, red_unit.x, red_unit.y, red_unit.rot);
  createRaceRepresentativeUtil(blue_unit.name, blue_unit.unitId, blue_unit.x, blue_unit.y, blue_unit.rot);
end;

-- �������� ������������� � ����������� ���������
function createRaceRepresentativeUtil(creatureName, creatureId, x, y, rotation)
  print "createRaceRepresentativeUtil"

  CreateMonster(creatureName, creatureId, 1, x, y, GROUND, 1, 2, rotation, 0);
  SetObjectEnabled(creatureName, nil);
  Trigger(OBJECT_TOUCH_TRIGGER, creatureName, "SelectRaceQuestion");
end;

-- ������ ��� ������ ����
function SelectRaceQuestion(triggerHero, triggeredUnitName)
  print "SelectRaceQuestion"
  
  local countPickedRace = getCountSelectedRace();
  local textQuestion = countPickedRace < 4 and "question_choose_race_yourself.txt" or "question_choose_race_opponent.txt";

  QuestionBoxForPlayers (GetPlayerFilter(GetObjectOwner(triggerHero)), PATH_TO_DAY1_MESSAGES..textQuestion, "confirmSelectRace('"..triggeredUnitName.."')", 'noop');
end;

-- ��������� ���������� ��������� ���
function getCountSelectedRace()
  print "getCountSelectedRace"
  
  local count = 0;

  for i = 0, length(randomGenerateRaceList)-1 do
    if (randomGenerateRaceList[i].selected == 1) then
      count = count + 1;
    end;
  end;

  return count;
end;

-- ����� ����
function confirmSelectRace(unitName)
  print "confirmSelectRace"
  
  local selectedRaceIndex = getSelectedRaceIndexByUnitName(unitName);

  -- ����������� ���� ��������, ��� ��� �������
  randomGenerateRaceList[selectedRaceIndex].selected = true;

  local selectedRace = randomGenerateRaceList[selectedRaceIndex]

  pushSelectedRaceToRacePair(selectedRace);
  changePlayersTurn();
end;

-- ��������� ������� ��������������� ���� �� name ������ �� �������������� �� ������
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

-- �������� ����� ����� �������� ����� ������ ����
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
    addHeroMovePoints(Biara);
    ShowFlyingSign({PATH_TO_DAY1_MESSAGES.."choose_race_opponent.txt"; number_of_matchup = 4 }, Biara, PLAYER_1, 5.0);
  end;
  if (countSelectedRace == 7) then
    removeHeroMovePoints(Biara);
    addHeroMovePoints(Djovanni);
    ShowFlyingSign({PATH_TO_DAY1_MESSAGES.."choose_race_opponent.txt"; number_of_matchup = 4 }, Djovanni, PLAYER_2, 5.0);
  end;
  if (countSelectedRace == 8) then
    -- ��������� ������ � ���������� ��������
    SetRegionBlocked ('block5', nil);
    SetRegionBlocked ('block6', nil);

    -- ������� � ���� ���������, ���������� ����
    for indexRace, race in randomGenerateRaceList do
      if (race.visible and not race.selected) then
        RemoveObject(race.red_unit.name);
        RemoveObject(race.blue_unit.name);
        race.visible = true;
      end;
    end;

    ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."delete_matchup.txt", Djovanni, PLAYER_2, 5.0);
  end;
end;

-- ����� ���������� ���
function showHiddenRaces()
  print "showHiddenRaces"
  -- ������� ���, ������� ����� �������� �� ������ ������ ������
  local hiddenRaceIndexList = {
    6, 7, 8, 9
  };

  -- ���������� �� ������� ����� ��� � �������� ��������� ���� �� ��, ��� �������� � ������
  for raceIndex = 0, 5 do
    if randomGenerateRaceList[raceIndex].selected then
      -- ���� - ��������� ������ ����
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

-- ������ ���������� ��� ���
selectedRacePair = {
  {
    { raceId = nil, deleted = nil, owner = PLAYER_1, red_unit = { name = nil, x = 38, y = 90, rot = 90 }, blue_unit = { name = nil, x = 39, y = 25, rot = 270 } },
    { raceId = nil, deleted = nil, owner = PLAYER_2, red_unit = { name = nil, x = 39, y = 90, rot = 270 }, blue_unit = { name = nil, x = 38, y = 25, rot = 90 } },
  },
  {
    { raceId = nil, deleted = nil, owner = PLAYER_2, red_unit = { name = nil, x = 39, y = 88, rot = 270 }, blue_unit = { name = nil, x = 38, y = 23, rot = 90 } },
    { raceId = nil, deleted = nil, owner = PLAYER_1, red_unit = { name = nil, x = 38, y = 88, rot = 90 }, blue_unit = { name = nil, x = 39, y = 23, rot = 270 } },
  },
  {
    { raceId = nil, deleted = nil, owner = PLAYER_1, red_unit = { name = nil, x = 38, y = 86, rot = 90 }, blue_unit = { name = nil, x = 39, y = 21, rot = 270 } },
    { raceId = nil, deleted = nil, owner = PLAYER_2, red_unit = { name = nil, x = 39, y = 86, rot = 270 }, blue_unit = { name = nil, x = 38, y = 21, rot = 90 } },
  },
  {
    { raceId = nil, deleted = nil, owner = PLAYER_2, red_unit = { name = nil, x = 39, y = 84, rot = 270 }, blue_unit = { name = nil, x = 38, y = 19, rot = 90 } },
    { raceId = nil, deleted = nil, owner = PLAYER_1, red_unit = { name = nil, x = 38, y = 84, rot = 90 }, blue_unit = { name = nil, x = 39, y = 19, rot = 270 } },
  },
};

-- ������ ��������� ���� � ������ ���
function pushSelectedRaceToRacePair(selectedRace)
  print "pushSelectedRaceToRacePair"
  
  local pushed = nil;
  
  for pairIndex = 1, length(selectedRacePair) do
    local pair =  selectedRacePair[pairIndex];
    
    if pushed then
      break;
    end;

    for sideIndex = 1, length(pair) do
      local side = pair[sideIndex];

      if (not side.raceId and not pushed) then
        -- ������ ��������� ���� � ������ ���
        side.raceId = selectedRace.raceId
        side.red_unit.name = selectedRace.red_unit.name
        side.blue_unit.name = selectedRace.blue_unit.name

        -- ��������� �������������� ��������� �������

        SetObjectPosition(side.red_unit.name, side.red_unit.x, side.red_unit.y, GROUND);
        SetObjectRotation(side.red_unit.name, side.red_unit.rot);
        SetObjectPosition(side.blue_unit.name, side.blue_unit.x, side.blue_unit.y, GROUND);
        SetObjectRotation(side.blue_unit.name, side.blue_unit.rot);

        Trigger(OBJECT_TOUCH_TRIGGER, side.red_unit.name, 'questionDeleteMatchup');
        Trigger(OBJECT_TOUCH_TRIGGER, side.blue_unit.name, 'questionDeleteMatchup');

        pushed = 1;
        break;
      end;
    end
  end;
end;

-- ������ �� ������������ �������
function questionDeleteMatchup(triggerHero, triggerUnitName)
  print "questionDeleteMatchup"
  
  selectedIndexPair = getPairIndexByUnitName(triggerUnitName);

  local triggerPlayer = GetPlayerFilter(GetObjectOwner(triggerHero));
  local pathToQuestion = PATH_TO_DAY1_MESSAGES.."question_delete_matchup.txt";

  QuestionBoxForPlayers(triggerPlayer, pathToQuestion, "handleDeleteMatchup('"..triggerHero.."', '"..selectedIndexPair.."')", 'noop');
end;

-- ��������� ������� ��������� ���� �� �����
function getPairIndexByUnitName(unitName)
  print "getPairIndexByUnitName"
  
  for indexPair = 1, length(selectedRacePair) do
    local pair = selectedRacePair[indexPair];

    for indexSide = 1, length(pair) do
      local side = pair[indexSide];

      if (side.red_unit.name == unitName or side.blue_unit.name == unitName) then
        return indexPair;
      end;
    end;
  end;
end;

-- ���������� �������� ���������� �������
function handleDeleteMatchup(hero, indexPair)
  print "handleDeleteMatchup"

  -- ���� �� �������� ������� � ��������, ��������� ������, ���������� ������ ������������� ������� � �����
  indexPair = indexPair + 0;

  deleteMatchupByIndexPair(indexPair);

  local countDeletedPair = getCountDeletedPair();

  -- ��������� ������� ������� 2 ����
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

-- �������� ���� ��� �� ������� ����
function deleteMatchupByIndexPair(indexPair)
  print "deleteMatchupByIndexPair"

  for indexSide = 1, length(selectedRacePair[indexPair]) do
    local side = selectedRacePair[indexPair][indexSide];

    side.deleted = true
    RemoveObject(side.red_unit.name);
    RemoveObject(side.blue_unit.name);
  end;
end;


-- ��������� ���������� ��������� ���
function getCountDeletedPair()
  print "getCountDeletedPair"
  
  local count = 0;

  for i = 1, length(selectedRacePair) do
    local pair = selectedRacePair[i];

    for indexSide = 1, length(pair) do
      local side = pair[indexSide];

      if (side.deleted) then
        count = count + 1;
        break;
      end;
    end;
  end;

  return count;
end;

-- �������� � ����� ����� ���, ������� � ����� ������
function finishCherkRace()
  print "finishCherkRace"

  local randomPairIndexForDelete = getNotDeletedRandomPairIndex();
  deleteMatchupByIndexPair(randomPairIndexForDelete);
  sleep(10);

  -- ������������ �� ��������� ����
  local resultPairIndex = getNotDeletedRandomPairIndex();
  deleteMatchupByIndexPair(resultPairIndex);

  sleep(3);
  removePairDelimeters();

  -- ������� � ����� ������
  startChoosingHeroes(resultPairIndex);
end;

-- ��������� ���������� ������� �� ��������� ����
function getNotDeletedRandomPairIndex()
  print "getNotDeletedRandomPairIndex"
  local notDeletedPairKeys = {};

  for indexPair = 1, length(selectedRacePair) do
    local pair = selectedRacePair[indexPair];

    for indexSide = 1, length(pair) do
      local side = pair[indexSide];

      if not side.deleted then
        if (notDeletedPairKeys[1] == nil) then
          notDeletedPairKeys[1] = indexPair;
        else
          notDeletedPairKeys[2] = indexPair;
        end;
      end;

      break;
    end;
  end;

  return notDeletedPairKeys[random(length(notDeletedPairKeys))+1];
end;

-- ���� ������
function startChoosingHeroes(resultPairIndex)
  print "startChoosingHeroes"

  local selectedPair = selectedRacePair[resultPairIndex];
  local redRaceId, blueRaceId;

  for sideIndex = 1, length(selectedPair) do
    local side = selectedPair[sideIndex];

    if (side.owner == PLAYER_1) then
      SELECTED_RACE_ID_TABLE[1] = side.raceId;
    else
      SELECTED_RACE_ID_TABLE[2] = side.raceId;
    end;
  end;

  if random(2) == 0 then
    doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_single_heroes.lua");
  else
    doFile(PATH_TO_DAY1_MODULE.."choice_of_heroes/cherk_group_heroes.lua");
  end;
end;

-- �������� �������� �����, ����������� ����
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

-- ��������� ��������� ��� ����
function changeChooseArea()
  print "changeChooseArea"

  -- �������� ����������� ����� ������
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
  -- ����������� ��������� �����������
  SetObjectPosition('red1', 38, 89);
  SetObjectPosition('red2', 38, 87);
  SetObjectPosition('red3', 38, 85);
  SetObjectPosition('red4', 39, 24);
  SetObjectPosition('red5', 39, 22);
  SetObjectPosition('red6', 39, 20);
  -- ���������� ������������ ������ � ��������� �����
  SetRegionBlocked ('block5', true);
  SetRegionBlocked ('block6', true);
end;

half_choice_of_races();