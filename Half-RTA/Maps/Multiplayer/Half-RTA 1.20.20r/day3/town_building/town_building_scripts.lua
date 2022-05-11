doFile(GetMapDataPath().."day3/town_building/town_building_constants.lua");
sleep(1);

-- ������� ���������� �� ��������� ������� ������� � ����������� ��
function buildingTown()
  print "buildingTown"

  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
    
    -- ���������� ������ � ������ ��������� ���
    transformPlayersTown(townName, raceId);
    SetObjectOwner(townName, playerId);
    setTownMaximumLevel(townName, raceId);
    setArmyIntoTown(townName, raceId, playerId);
  end;
end;

-- ��������� ����������� ������ �� ����� ���������� ����
function transformPlayersTown(townName, raceId)
  print "transformPlayersTown"

  -- ����������� ���� � �� ������
  local MAP_RACE_TO_TOWN = {
    [RACES.HAVEN] = TOWN_HEAVEN,
    [RACES.INFERNO] = TOWN_INFERNO,
    [RACES.NECROPOLIS] = TOWN_NECROMANCY,
    [RACES.SYLVAN] = TOWN_PRESERVE,
    [RACES.ACADEMY] = TOWN_ACADEMY,
    [RACES.DUNGEON] = TOWN_DUNGEON,
    [RACES.FORTRESS] = TOWN_FORTRESS,
    [RACES.STRONGHOLD] = TOWN_STRONGHOLD,
  };

  TransformTown(townName, MAP_RACE_TO_TOWN[raceId]);
end;

-- ��������� ������������� lvl ��� ������
function setTownMaximumLevel(townName, raceId)
  print "setTownMaximumLevel"

  local allTownCreatureList = {
    TOWN_BUILDING_DWELLING_1,
    TOWN_BUILDING_DWELLING_2,
    TOWN_BUILDING_DWELLING_3,
    TOWN_BUILDING_DWELLING_4,
    TOWN_BUILDING_DWELLING_5,
    TOWN_BUILDING_DWELLING_6,
    TOWN_BUILDING_DWELLING_7
  };

  for _, dwelling in allTownCreatureList do
    UpgradeTownBuilding(townName, dwelling);
    SetTownBuildingLimitLevel(townName, dwelling, 2);
    UpgradeTownBuilding(townName, dwelling);
  end;

  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_TOWN_HALL, 1);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_FORT, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_MARKETPLACE, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_SHIPYARD, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_TAVERN, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_BLACKSMITH, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_MAGIC_GUILD, 0);

  if raceId == RACES.HAVEN then
    UpgradeTownBuilding(townName, TOWN_BUILDING_HAVEN_TRAINING_GROUNDS);
    SetTownBuildingLimitLevel(townName, TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 0);
    UpgradeTownBuilding(townName, TOWN_BUILDING_HAVEN_FARMS);
  end;
  if raceId == RACES.ACADEMY then
    UpgradeTownBuilding(townName, TOWN_BUILDING_ACADEMY_ARTIFACT_MERCHANT);
  end;
  if raceId == RACES.DUNGEON then
    UpgradeTownBuilding(townName, TOWN_BUILDING_DUNGEON_TRADE_GUILD);
    SetTownBuildingLimitLevel(townName, TOWN_BUILDING_DUNGEON_HALL_OF_INTRIGUE, 0);
    SetTownBuildingLimitLevel(townName, TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS, 0);
  end;
end;

-- ��������� ����� � ������ ������
function setArmyIntoTown(townName, raceId, playerId)
  print "setArmyIntoTown"

  -- ��������� �����
  generateArmy(playerId, raceId);
  
  -- ���������� ������ ��������
  pushArmyToTown(townName, playerId, raceId);
end;

-- ��������� ����� � �����
function pushArmyToTown(townName, playerId, raceId)
  print "pushArmyToTown"

  for unitLevel = 1, 7 do
    local unit = RESULT_ARMY_INTO_TOWN[playerId][unitLevel];
    
    SetObjectDwellingCreatures(townName, unit.id, unit.count);
  end;
end;

-- ��������� ���������� �������� -1 ��� 1
function getRandomPlusOrMinusOne()
  return random(2) == 0 and -1 or 1;
end;

-- ��������� ���������� ������
function getCountUnitByLevel(playerId, raceId, unitLevel)
  print "getCountUnitByLevel"

  local count = UNITS[raceId][unitLevel].kol;

  if unitLevel == 6 then
    count = random(3) + count - 1;
  end;

  if unitLevel < 6 and unitLevel > 1 then
    local plusOrMinusOne = getRandomPlusOrMinusOne();

    count = plusOrMinusOne * random(count * 0.1) + count;
  end;

  if unitLevel == 1 then
    local priceAllButFirst = getAllPriceButFirst(playerId, raceId);

    count = count - priceAllButFirst/UNITS[raceId][unitLevel].price1;
  end;

  return intg(count);
end;

-- ��������� ������� ����������� �����
function getPriceUnitByLevel(raceId, unitLevel, countUnits)
  print "getPriceUnitByLevel"

  local oneUnitPrice = UNITS[raceId][unitLevel].price1;
  local defaultUnitCount = UNITS[raceId][unitLevel].kol;

  print 'raceId'
  print (raceId)
  print 'unitLevel'
  print (unitLevel)
  print 'countUnits'
  print (countUnits)
  print 'oneUnitPrice'
  print (oneUnitPrice)
  print 'defaultUnitCount'
  print (defaultUnitCount)
  print 'oneUnitPrice'
  print (oneUnitPrice)
  
  if unitLevel == 1 then
    return oneUnitPrice * defaultUnitCount * 0.1;
  end;
  
  return countUnits * oneUnitPrice - defaultUnitCount * oneUnitPrice;
end;

-- ������������� ���������� �����
function adjustmentArmyCount(playerId, raceId)
  print "adjustmentArmyCount"

  local tenPercentFullPriceFirstLvlUnit = getPriceUnitByLevel(raceId, 1);
  local priceAllButFirst = getAllPriceButFirst(playerId, raceId);
  local unitLevel = 7;

  -- ���� ��������������� ������� ����� �����,
  -- ��������� �� ���������� �� ��������� ����� 10% �� ������� ����
  if priceAllButFirst > tenPercentFullPriceFirstLvlUnit then
    while unitLevel > 1 do
      local unit = RESULT_ARMY_INTO_TOWN[playerId][unitLevel];
      
      local priceCurrentLvl = getPriceUnitByLevel(raceId, unitLevel, unit.count);

      if priceCurrentLvl > 0 then
        unit.count = unit.count - 1;
      end;

      unitLevel = unitLevel - 1;

      -- ���� �� ��� ������ �����, ����
      if unitLevel == 1 then
        unitLevel = 6;
      end;

      priceAllButFirst = getAllPriceButFirst(playerId, raceId);

      -- ��������� ������������, ���� �������� �������
      if priceAllButFirst < tenPercentFullPriceFirstLvlUnit then
        unitLevel = 1;
      end;
    end;
  end;

  -- ���� ��������������� ������� ���� �����,
  -- ����������� �� ���������� �� ��������� ����� 10% �� ������� ����
  if priceAllButFirst < (-tenPercentFullPriceFirstLvlUnit) then
    while unitLevel > 1 do
      local unit = RESULT_ARMY_INTO_TOWN[playerId][unitLevel];
    
      local priceCurrentLvl = getPriceUnitByLevel(raceId, unitLevel, unit.count);

      if priceCurrentLvl < 0 then
        unit.count = unit.count + 1;
      end;

      unitLevel = unitLevel - 1;

      -- ���� �� ��� ������ �����, ����
      if unitLevel == 1 then
        unitLevel = 6;
      end;

      priceAllButFirst = getAllPriceButFirst(playerId, raceId);

      -- ��������� ������������, ���� �������� �������
      if priceAllButFirst < (-tenPercentFullPriceFirstLvlUnit) then
        unitLevel = 1;
      end;
    end;
  end;
end;

-- ��������� ����� ������������ ���� ������, ����� ������� ����
function getAllPriceButFirst(playerId, raceId)
  print "getAllPriceButFirst"

  local price = 0;

  for levelUnit = 7, 2, -1 do
    price = getPriceUnitByLevel(raceId, levelUnit, RESULT_ARMY_INTO_TOWN[playerId][levelUnit].count);
  end;

  return price;
end;

-- ��������� ��������� �����
function getResultUnit(playerId, raceId, unitLevel)
  print "getResultUnit"
  
  return {
    id = SUCCESS_UNITS_ID[raceId][unitLevel],
    count = getCountUnitByLevel(playerId, raceId, unitLevel),
  };
end;

-- ��������� ������������� ���������� ������� � �����
function generateArmy(playerId, raceId)
  print "generateArmy"

  for unitLevel = 7, 1, -1 do
    if unitLevel == 1 then
      -- ������������ ���������� �����
      adjustmentArmyCount(playerId, raceId);
    end;

    RESULT_ARMY_INTO_TOWN[playerId][unitLevel] = getResultUnit(playerId, raceId, unitLevel);
  end;
end;

-- ����� �����
buildingTown();
