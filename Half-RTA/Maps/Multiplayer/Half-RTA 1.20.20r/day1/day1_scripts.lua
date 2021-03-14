-- ������, ������������� ��� �������� ����� ����� ��, � ������ ����

-- ���� �� ������� �����
local MODULE_PATH = GetMapDataPath().."day1/";
-- ���� �� ����� � �����������
PATH_TO_DAY1_MESSAGES = MODULE_PATH.."messages/";
-- ���� �� ����� � �����������
PATH_TO_HERO_NAMES = MODULE_PATH.."hero_names/";

-- ����� (����� ��������)
Biara = GetPlayerHeroes(PLAYER_1)[0]
-- �������� (����� ������)
Djovanni = GetPlayerHeroes(PLAYER_2)[0]

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

-- ��������� ����� ��������� ����
function getRandomRace()
  return random(8);
end;

-- ��������� ������� ��� ������ � ��������������� ����
function setCreaturesPairInToRace(index, raceId)
  -- ����������� ���� � ������������� ��� ����� ����������
  local MAPPING_RACE_TO_CREATURES = {
     -- ����� ������� - ������ � ��������� ����
     [RACES.HAVEN] = { ID1 = CREATURE_FOOTMAN, ID2 = CREATURE_VINDICATOR },
     -- ������� - ���� � ����������
     [RACES.INFERNO] = { ID1 = CREATURE_IMP, ID2 = CREATURE_QUASIT },
     -- ���������� - ������ � ������ ��������
     [RACES.NECROPOLIS] = { ID1 = CREATURE_VAMPIRE, ID2 = CREATURE_NOSFERATU },
     -- ������ ���� - ������ � �������
     [RACES.SYLVAN] = { ID1 = CREATURE_WOOD_ELF, ID2 = CREATURE_SHARP_SHOOTER },
     -- �������� ���������� - ��� � ������ ���
     [RACES.ACADEMY] = { ID1 = CREATURE_MAGI, ID2 = CREATURE_COMBAT_MAGE },
     -- ���� ����� - ������ � �����
     [RACES.DUNGEON] = { ID1 = CREATURE_WITCH, ID2 = CREATURE_BLOOD_WITCH_2 },
     -- ������ - ���� ��� � ��������� ����
     [RACES.FORTRESS] = { ID1 = CREATURE_RUNE_MAGE, ID2 = CREATURE_FLAME_KEEPER },
     -- ���� - ����� � �����
     [RACES.STRONGHOLD] = { ID1 = CREATURE_ORCCHIEF_BUTCHER, ID2 = CREATURE_ORCCHIEF_CHIEFTAIN },
  };

  randomGenerateRaceList[index].red_unit.unitId = MAPPING_RACE_TO_CREATURES[raceId].ID1;
  randomGenerateRaceList[index].blue_unit.unitId = MAPPING_RACE_TO_CREATURES[raceId].ID2;
end;

-- ����� ����� ��� ���������� �������� ������
function main()
  print "__MAIN__"
  
  removeHeroMovePoints(Biara);
  removeHeroMovePoints(Djovanni);

  if GAME_MODE.HALF then
    disableAreaInteractive();
    changeChooseArea();

    -- ����������� ������ ������� �� ������� ��� �����
    SetObjectPosition(Biara, 34, 87, 0);
    SetObjectPosition(Djovanni, 43, 22, 0);

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

-- �������, �� �������� ������
function noop()
end;

-- ������ ��� ������ ����
function SelectRaceQuestion(triggerHero, triggeredUnitName)
  print "SelectRaceQuestion"
  local countPickedRace = getCountSelectedRace();
  local textQuestion = countPickedRace < 4 and "question_choose_race_yourself.txt" or "question_choose_race_opponent.txt";

  QuestionBoxForPlayers (GetPlayerFilter(GetObjectOwner(triggerHero)), PATH_TO_DAY1_MESSAGES..textQuestion, "confirmSelectRace('"..triggeredUnitName.."')", 'noop');
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
  for pairIndex = 1, length(selectedRacePair) do
    local pair =  selectedRacePair[pairIndex];
    
    for sideIndex = 1, length(pair) do
      local side = pair[sideIndex];

      if (side.raceId == nil) then
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

        return '';
      end;
    end
  end;
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

-- ������ �� ������������ �������
function questionDeleteMatchup(triggerHero, triggerUnitName)
  print "questionDeleteMatchup"
  selectedIndexPair = getPairIndexByUnitName(triggerUnitName);
  
  local triggerPlayer = GetPlayerFilter(GetObjectOwner(triggerHero));
  local pathToQuestion = PATH_TO_DAY1_MESSAGES.."question_delete_matchup.txt";

  QuestionBoxForPlayers(triggerPlayer, pathToQuestion, "handleDeleteMatchup('"..triggerHero.."', '"..selectedIndexPair.."')", 'noop');
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

-- ���� ������
function startChoosingHeroes(resultPairIndex)
  print "startChoosingHeroes"
  
  local selectedPair = selectedRacePair[resultPairIndex];
  local redRaceId, blueRaceId;

  for sideIndex = 1, length(selectedPair) do
    local side = selectedPair[sideIndex];
  
    if (side.owner == PLAYER_1) then
      redRaceId = side.raceId;
    else
      blueRaceId = side.raceId;
    end;
  end;

  if random(2) == 0 then
    cherkSingleHeroes(redRaceId, blueRaceId);
  else
    cherkGroupHeroes(redRaceId, blueRaceId);
  end;
end;

-- �������� ��������� ��������� ����� ������ ����� ������
function removeRegionTriggersForHeroGroupSelect()
  print "removeRegionTriggersForHeroGroupSelect"
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race1', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race2', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race3', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race4', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race5', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race6', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race7', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl1_race8', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race1', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race2', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race3', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race4', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race5', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race6', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race7', 'no');
  Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, 'pl2_race8', 'no');
end;

-- ���������, ����������� ������, ��������� �� 6 ��������� ������ ��������� ����� ���
RANDOM_GROUPS_HERO_ICONS = {
  [PLAYER_1] = {
    raceId = nil,
    heroGroups = {
      {
        deleted = nil,
        selected = nil,
        heroes = {
          { name = nil, red = { icon = nil, x = 31, y = 90 }, blue = { icon = nil, x = 46, y = 25 } },
          { name = nil, red = { icon = nil, x = 32, y = 90 }, blue = { icon = nil, x = 45, y = 25 } },
          { name = nil, red = { icon = nil, x = 33, y = 90 }, blue = { icon = nil, x = 44, y = 25 } },
          { name = nil, red = { icon = nil, x = 31, y = 89 }, blue = { icon = nil, x = 46, y = 24 } },
          { name = nil, red = { icon = nil, x = 32, y = 89 }, blue = { icon = nil, x = 45, y = 24 } },
          { name = nil, red = { icon = nil, x = 31, y = 88 }, blue = { icon = nil, x = 46, y = 23 } },
        }
      },
      {
        deleted = nil,
        selected = nil,
        heroes = {
          { name = nil, red = { icon = nil, x = 31, y = 84 }, blue = { icon = nil, x = 46, y = 19 } },
          { name = nil, red = { icon = nil, x = 32, y = 84 }, blue = { icon = nil, x = 45, y = 19 } },
          { name = nil, red = { icon = nil, x = 33, y = 84 }, blue = { icon = nil, x = 44, y = 19 } },
          { name = nil, red = { icon = nil, x = 31, y = 85 }, blue = { icon = nil, x = 46, y = 20 } },
          { name = nil, red = { icon = nil, x = 32, y = 85 }, blue = { icon = nil, x = 45, y = 20 } },
          { name = nil, red = { icon = nil, x = 31, y = 86 }, blue = { icon = nil, x = 46, y = 21 } },
        }
      },
    },
  },
  [PLAYER_2] = {
    raceId = nil,
    heroGroups = {
      {
        deleted = nil,
        selected = nil,
        heroes = {
          { name = nil, red = { icon = nil, x = 39, y = 90 }, blue = { icon = nil, x = 38, y = 25 } },
          { name = nil, red = { icon = nil, x = 38, y = 90 }, blue = { icon = nil, x = 39, y = 25 } },
          { name = nil, red = { icon = nil, x = 37, y = 90 }, blue = { icon = nil, x = 40, y = 25 } },
          { name = nil, red = { icon = nil, x = 39, y = 89 }, blue = { icon = nil, x = 38, y = 24 } },
          { name = nil, red = { icon = nil, x = 38, y = 89 }, blue = { icon = nil, x = 39, y = 24 } },
          { name = nil, red = { icon = nil, x = 39, y = 88 }, blue = { icon = nil, x = 38, y = 23 } },
        }
      },
      {
        deleted = nil,
        selected = nil,
        heroes = {
          { name = nil, red = { icon = nil, x = 39, y = 84 }, blue = { icon = nil, x = 38, y = 19 } },
          { name = nil, red = { icon = nil, x = 38, y = 84 }, blue = { icon = nil, x = 39, y = 19 } },
          { name = nil, red = { icon = nil, x = 37, y = 84 }, blue = { icon = nil, x = 40, y = 19 } },
          { name = nil, red = { icon = nil, x = 39, y = 85 }, blue = { icon = nil, x = 38, y = 20 } },
          { name = nil, red = { icon = nil, x = 38, y = 85 }, blue = { icon = nil, x = 39, y = 20 } },
          { name = nil, red = { icon = nil, x = 39, y = 86 }, blue = { icon = nil, x = 38, y = 21 } },
        }
      },
    },
  },
};

-- ���� ������� ������
function cherkGroupHeroes(redRaceId, blueRaceId)
  print "cherkGroupHeroes"

  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);

  -- �� ����, ����� ���
  DeleteRace();
  
  -- ������� �������� �� �������
  removeRegionTriggersForHeroGroupSelect();
  -- ������ �������� ��������� ���� ������ ��������� ���
  changeDescriptionForSelectedRaceHeroIcons(redRaceId, blueRaceId);
  -- ��������� ����� ��������� ������ ��������� ���
  generateRandomGroupHero(redRaceId, blueRaceId);
  -- ����� ��������������� ����� � ����������� ���������
  showAllRandomHeroGroups();
  
  -- �������� ���� ������� ������
  changeTurnSelectedHeroGroup(PLAYER_1);
end;

-- �������� ���� ����� �������� ��� ����� ����� ������
function changeTurnSelectedHeroGroup(currentPlayerId)
  if currentPlayerId == PLAYER_1 then
    removeHeroMovePoints(Djovanni);
    addHeroMovePoints(Biara);
    ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."delete_any_group_hero.txt", Biara, PLAYER_1, 7.0);
  else
    removeHeroMovePoints(Biara);
    addHeroMovePoints(Djovanni);
    ShowFlyingSign(PATH_TO_DAY1_MESSAGES.."delete_any_group_hero.txt", Djovanni, PLAYER_2, 7.0);
  end;
end;

-- ��������� ������������� ���������� �� ������������� �������� ������ �� ����
function generateRandomHeroIndexesByRace(raceId, count)
  print "generateRandomHeroIndexesByRace"
  
  local resultIndexList = {};
  
  for i = 1, count do
    local allHeroes = HEROES_BY_RACE[raceId];
    local randomHeroName;
    local countExistIndex = 0;
    local randomHeroIndex = 0;
    
    repeat
      randomHeroIndex = random(length(allHeroes)) + 1;
      countExistIndex = 0;
      
      for i, index in resultIndexList do
        if index == randomHeroIndex then
          countExistIndex = countExistIndex + 1;
        end;
      end;
    until countExistIndex == 0;

    resultIndexList[i] = randomHeroIndex;
  end;
  
  return resultIndexList;
end;

-- ��������� ���� ����� ��������� ������ ��� ����� �������
function generateRandomGroupHero(redRaceId, blueRaceId)
  print "generateRandomGroupHero"
  
  for playerId = 1, length(RANDOM_GROUPS_HERO_ICONS) do
    local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];
    
    playerData.raceId = playerId == PLAYER_1 and redRaceId or blueRaceId;
    
    for groupIndex = 1, length(playerData.heroGroups) do
      local group = playerData.heroGroups[groupIndex];
      local randomHeroIndexList = generateRandomHeroIndexesByRace(playerData.raceId, 6);
      
      for randomIndex, heroIndex in randomHeroIndexList do
        local dictionaryHero = HEROES_BY_RACE[playerData.raceId][heroIndex];

        group.heroes[randomIndex].name = dictionaryHero.name;
        group.heroes[randomIndex].red.icon = dictionaryHero[playerId][groupIndex].red_icon;
        group.heroes[randomIndex].blue.icon = dictionaryHero[playerId][groupIndex].blue_icon;
      end;
    end;
  end;
end;

-- ����� � ��������� ��������� �� ��� ������ ������
function showAllRandomHeroGroups()
  print "showAllRandomHeroGroups"
  for playerId = 1, length(RANDOM_GROUPS_HERO_ICONS) do
    local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];

    for groupIndex = 1, length(playerData.heroGroups) do
      local group = playerData.heroGroups[groupIndex];

      for heroIndex = 1, length(group.heroes) do
        local heroData = group.heroes[heroIndex];

        SetObjectPosition(heroData.red.icon, heroData.red.x, heroData.red.y, GROUND);
        SetObjectPosition(heroData.blue.icon, heroData.blue.x, heroData.blue.y, GROUND);
        
        Trigger(OBJECT_TOUCH_TRIGGER, heroData.red.icon, "QuestionDeleteHeroGroup");
        Trigger(OBJECT_TOUCH_TRIGGER, heroData.blue.icon, "QuestionDeleteHeroGroup");
      end;
    end;
  end;
end;

-- ��������� ������ ������ �� �������� ����� ����� �� ���
function getGroupDataByIconName(iconName)
  print "getGroupDataByIconName"
  for playerId = 1, length(RANDOM_GROUPS_HERO_ICONS) do
    local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];

    for groupIndex = 1, length(playerData.heroGroups) do
      local group = playerData.heroGroups[groupIndex];

      for heroIndex = 1, length(group.heroes) do
        local heroData = group.heroes[heroIndex];

        if (heroData.red.icon == iconName or heroData.blue.icon == iconName) then
           return playerId, groupIndex;
        end;
      end;
    end;
  end;
end;

-- ��������� ���������� ��������� ������� ������
function getCountDeletedHeroGroup()
  print "getCountDeletedHeroGroup"
  local count = 0;

  for playerId = 1, length(RANDOM_GROUPS_HERO_ICONS) do
    local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];
    
    for groupIndex = 1, length(playerData.heroGroups) do
      local group = playerData.heroGroups[groupIndex];

      if group.deleted then
        count = count + 1;
      end;
    end;
  end;

  return count
end;

-- �������������� ������ ��� ������ ������ ������
function QuestionDeleteHeroGroup(triggerHero, triggeredIconName)
  print "QuestionDeleteHeroGroup"
  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  
  QuestionBoxForPlayers(playerId, PATH_TO_DAY1_MESSAGES.."question_delete_group_hero.txt", "DeleteHeroGroupByIconName('"..triggeredIconName.."')", 'noop')
end;

-- �������� ������ ������
function DeleteHeroGroupByIconName(iconName)
  print "DeleteHeroGroupByIconName"
  
  -- ������� ��������� ����� � ������� � ������� ������ ��������
  local playerId, deleteGroupIndex = getGroupDataByIconName(iconName);

  for groupIndex = 1, length(RANDOM_GROUPS_HERO_ICONS[playerId].heroGroups) do
    local group = RANDOM_GROUPS_HERO_ICONS[playerId].heroGroups[groupIndex];
    
    if groupIndex == deleteGroupIndex then
      group.deleted = true;
      
      for heroIndex = 1, length(group.heroes) do
        local heroData = group.heroes[heroIndex];

        RemoveObject(heroData.red.icon);
        RemoveObject(heroData.blue.icon);
      end;
    else
      group.selected = true;
      
      for heroIndex = 1, length(group.heroes) do
        local heroData = group.heroes[heroIndex];

        Trigger(OBJECT_TOUCH_TRIGGER, heroData.red.icon, 'noop');
        Trigger(OBJECT_TOUCH_TRIGGER, heroData.blue.icon, 'noop');
      end;
    end;
  end;

  -- ��������� ���� ����� ������
  local countDeletedGroup = getCountDeletedHeroGroup();
  if countDeletedGroup == 2 then
    finishGroupCherk();

    return '';
  end;
  
  -- ���� 2 ����� ��� �� �����, �������� ��� ���
  changeTurnSelectedHeroGroup(PLAYER_2);
end;

-- ��������� ����� ������ ������ � ���������� �������� ����� ������ ��� 2 �������
function finishGroupCherk()
  removeHeroMovePoints(Djovanni);
  removeHeroMovePoints(Biara);
  
  sleep(10);
  
  -- ��������� �������� ������ ��� ���� �������
  for playerId = 1, length(RANDOM_GROUPS_HERO_ICONS) do
    local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];
    local selectedHeroes = {};

    for groupIndex = 1, length(playerData.heroGroups) do
      local group = playerData.heroGroups[groupIndex];
      
      if group.selected then
        for heroIndex = 1, length(group.heroes) do
          local heroData = group.heroes[heroIndex];

          raceId = heroData.raceId
          selectedHeroes[heroIndex] = heroData.name;
        end;
      end;
    end;
    
    -- ����� 2 ��������� ������ �� ����������� ������
    setRandomHeroFromHeroList(playerId, playerData.raceId, selectedHeroes);
  end;
end;

-- ������� ��� ����
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

-- �������� ��������� � ��������, ��� ���������� ����
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

-- ������ ��������� ������ ��� ��������� ���
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

-- ��������� ��������, ���� �� ����� ����� � ������ ��� ������ � ������������� ������
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

-- ��������� 7 ��������� ������ ���������� ���� ��� ���������� ������
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

-- ������ ��� � �������� ��� ���� ������ ���������� ���
function changeDescriptionForSelectedRaceHeroIcons(redRaceId, blueRaceId)
  print "changeDescriptionForSelectedRaceHeroIcons"
  -- ������ ��������� ���
  local selectedRaceIdList = { redRaceId, blueRaceId };

  -- �������� �������� � �������� ��������� ���� ������ �� �����
  for raceIndex, raceId in selectedRaceIdList do
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

-- ���� �� ������ �����
function cherkSingleHeroes(redRaceId, blueRaceId)
  print "cherkSingleHeroes"
  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);

  removeHeroMovePoints(Djovanni);
  addHeroMovePoints(Biara)

  deleteRace();
  removeRaceRegionTriggers();
  
  -- ������ �������� ��������� ���� ������ ��������� ���
  changeDescriptionForSelectedRaceHeroIcons(redRaceId, blueRaceId);

  -- ���������� ������ ��������� ������ ��� ����� �������
  generateRandomHeroListByPlayerIdAndRaceId(PLAYER_1, redRaceId);
  generateRandomHeroListByPlayerIdAndRaceId(PLAYER_2, blueRaceId);
  
  -- ����������� ��������������� ������ ��� ������
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

-- ��������� ������, �������� ����������� ��������� �����
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

-- ���������� ������� ������ ��� ������
function handleTouchHero(triggerPlayerHero, triggeredHeroIconName)
  print "handleTouchHero"

  -- �����, �������� ����������� ���� �����
  local player, heroName = getRelatedPlayerAndHeroNameByHeroIconName(triggeredHeroIconName);

  local triggerPlayer = GetPlayerFilter(GetObjectOwner(triggerPlayerHero));
  local action = getCurrentTurnAction();
  local question = action == TURN_ACTIONS.CHOOSING and "question_add_hero.txt" or "question_delete_hero.txt";

  QuestionBoxForPlayers(triggerPlayer, PATH_TO_DAY1_MESSAGES..question, "handlerAddOrDeleteHero('"..player.."', '"..heroName.."')", 'noop');
end;

-- ���������� �������� ��� ���������� �����
function handlerAddOrDeleteHero(playerId, heroName)
  print "handlerAddOrDeleteHero"

  -- �������������� ������ � �����
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

-- ������������ ����� �������� ����������
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

-- �������� ����� �� ������
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

-- �������� �� �������� ��������� ������ �� ������ �������
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
    
    -- ���� ���������� 3 �����, ��������� ���� ���������� ������ � �����
    if countDeletedHero > 2 then
      for heroIndex = 1, length(heroList) do
        local heroData = heroList[heroIndex];
        
        if (not heroData.deleted and not heroData.selected) then
          addHeroForPlayer(playerId, heroData.name)
        end;
      end;
    end;

    -- ���� ��������� 3 �����, ������� ���� ���������� ������ � �����
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

-- ������� ��������� �� ���� �� ������ ��� ���: 0 - �� ���������, 1 - ���������
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

-- ��������� ������ �������� ����
function getHeroTurn()
  print "getHeroTurn"

  local count = 0;
  
  -- ������� ���� ������, ������� ���� ��������� ��� ������� ��������
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


-- �������, ��� ���� ������: ����� ��� ��������: 0 - ������� ���������, 1 - ������� �������
RANDOM_CHOOSE_FIRST_FLAG = random(2);

-- ������������ ����� ���� ��� ����� ������: 0 - �����������, 1 - ���������
TURN_ACTIONS = {
  CHOOSING = 1,
  DELETING = 0,
};

-- ��������� ���� �������� �������� ����:
function getCurrentTurnAction()
  print "getCurrentTurnAction"
  -- ����������� ���� ����� � ���� �������� ��� �����
  local mapFlagToTurnAction = {
    [0] = { TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING },
    [1] = { TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.DELETING, TURN_ACTIONS.DELETING, TURN_ACTIONS.CHOOSING, TURN_ACTIONS.CHOOSING },
  };
  local turn = getHeroTurn();
  
  return mapFlagToTurnAction[RANDOM_CHOOSE_FIRST_FLAG][turn + 1];
end;

-- ���������� ���������
function changePlayersTurnForChoosingHero()
  print "changePlayersTurnForChoosingHero"

  -- ����� �������� ���� ����� ������
  local turn = getHeroTurn();
  local turnAction = getCurrentTurnAction();
  local countSideFullfied = getCountSideFullfied();
  local message = turnAction == TURN_ACTIONS.CHOOSING and "include_single_hero.txt" or "exclude_single_hero.txt";
  
  -- ���� 2 ������ ��������� - ����������� ����
  if countSideFullfied == 2 then
    setResultHeroes();
    return '';
  end;
  
  -- ������ ���� �������� �������, �������� - �����
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

-- �������� ������ ������ ��� ����
RESULT_HERO_LIST = {
  [PLAYER_1] = { raceId = nil, heroes = {} },
  [PLAYER_2] = { raceId = nil, heroes = {} },
};

-- ����� ��������� 2 ������ �� ����������� ������ � 1 ���������
function setRandomHeroFromHeroList(playerId, raceId, heroList)
  print "setRandomHeroFromHeroList"

  RESULT_HERO_LIST[playerId].raceId = raceId;

  local resultHeroes = RESULT_HERO_LIST[playerId].heroes;

  for resultHeroIndex = 1, 2 do
    local randomSelectedHero;
    local countEqualHeroNames = 0;

    -- ���������, ���� �� ����������� ������ �����, �������� �� �������
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
  
  -- ��������� ������ ��� ����� ��������� ������ ���� ����
  local allHeroesByRace = HEROES_BY_RACE[raceId];
  local randomHero;
  local countEqualHeroNames = 0;

  -- ���������, ���� �� ���������� �� ���������� �����
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

-- ��������� ��������� ������ ������ ��� ����� �������
function setResultHeroes()
  print "setResultHeroes"

  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId]
    -- ������ ��������� ������ ��� ���������� ������
    local selectedHero = {};

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      if heroData.selected then
        local pushedIndex = length(selectedHero) + 1;

        selectedHero[pushedIndex] = heroData.name;
      end;
    end;

    -- ��������� �������� ������ 2 ���������� ���������� ������� � 1 ���������
    setRandomHeroFromHeroList(playerId, heroList[1].raceId, selectedHero);
  end;
end;

-- ������� ��� ���� ������������ � ����������� ����� �� 0
function removeHeroMovePoints(hero)
  print "removeHeroMovePoints"
  local currentHeroMovePoints = GetHeroStat(hero, STAT_MOVE_POINTS);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints);
end;

-- ��������� ���� ������������ � ����������� �����
function addHeroMovePoints(hero)
  print "addHeroMovePoints"
  local ADD_MOVE_POINTS = 50000;
  local currentHeroMovePoints = GetHeroStat(hero, STAT_MOVE_POINTS);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints+ADD_MOVE_POINTS);
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

-- ���������� �������������� ������� � ����������
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

-- ����� ����� � ������
main();