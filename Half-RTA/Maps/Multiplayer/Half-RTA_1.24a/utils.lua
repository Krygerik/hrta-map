-- ����, ����������� ����� �������, �������������� �� ���� ����������

-- ������� ��� ���� ������������ � ����������� ����� �� 0
function removeHeroMovePoints(hero)
  local currentHeroMovePoints = GetHeroStat(hero, STAT_MOVE_POINTS);

  ChangeHeroStat(hero, STAT_MOVE_POINTS, -currentHeroMovePoints);
end;

-- ��������� ���� ������������ � ����������� �����
function addHeroMovePoints(hero)
  removeHeroMovePoints(hero);

  local ADD_MOVE_POINTS = 30000;

  ChangeHeroStat(hero, STAT_MOVE_POINTS, ADD_MOVE_POINTS);
end;

-- ��������� ���������� �������� ����� �� ��� ������������������ ��������
function getDictionaryHeroName(heroName)
  for indexHero = 1, length(MAPPING_HERO_NAME_TO_PLAYERS_HERO_NAME) do
    local heroReservedNamesTable = MAPPING_HERO_NAME_TO_PLAYERS_HERO_NAME[indexHero];
    
    for indexName = 1, length(heroReservedNamesTable.reservedNames) do
      local heroReverveName = heroReservedNamesTable.reservedNames[indexName];
      
      if heroReverveName == heroName then
        return heroReservedNamesTable.dictName;
      end;
    end;
  end;
end;

-- ��������� ������������������ �������� ����� �� ��� ����������
function getReservedHeroName(playerId, dictHeroName)
  for indexHero = 1, length(MAPPING_HERO_NAME_TO_PLAYERS_HERO_NAME) do
    local heroReservedNamesTable = MAPPING_HERO_NAME_TO_PLAYERS_HERO_NAME[indexHero];
    
    if heroReservedNamesTable.dictName == dictHeroName then
      return heroReservedNamesTable.reservedNames[playerId];
    end;
  end;
end;

-- ������������� ������� ���������� ����� �������
function transferAllArts(sourceHero, targetHero)
  print "transferAllArts"

  for _, artData in ALL_ARTS_LIST do
    if HasArtefact(sourceHero, artData.id) then
      GiveArtefact(targetHero, artData.id);
      RemoveArtefact(sourceHero, artData.id);
    end;
  end;
end;

-- ������ ��������� ����� ��������
PLAYERS_PAUSE_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- ��������� ��� ������, ���������� ���������� ���� �� ������ ������
function awaitMessageBoxForPlayers(playerId, pathToMessage)
  print "awaitMessageBoxForPlayers"
  
  PLAYERS_PAUSE_STATUS[playerId] = not nil;
  
  function disablePause(strPlayerId)
    local playerId = strPlayerId + 0;

    PLAYERS_PAUSE_STATUS[playerId] = nil;
  end;
  
  MessageBoxForPlayers(playerId, pathToMessage, 'disablePause("'..playerId..'")');
  
  while PLAYERS_PAUSE_STATUS[playerId] do
    sleep(1);
  end;
end;

-- ���������� ��������� - ����� �� �������� ����� ���� �� 1 ����
function needPostponeBattle()
  print "needPostponeBattle"

  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;

    if raceId == RACES.SYLVAN or raceId == RACES.ACADEMY or raceId == RACES.HAVEN then
      return not nil;
    end;
  end;

  return nil;
end;

-- ��������� �� ������, ����������� ���� ��� �����
function getSelectedBattlefieldPlayerId()
  print "getSelectedBattlefieldPlayerId"

  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    local dictHeroName = getDictionaryHeroName(mainHeroName);

    -- ������ ����� ��������� ��� ����
    if dictHeroName == HEROES.JAZAZ then
      return playerId;
    end;
  end;

  local countPlayersWithPathFinding = 0;

  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

    -- ���������� ���� ���� ����������� ������
    if HasHeroSkill(mainHeroName, PERK_PATHFINDING) then
      countPlayersWithPathFinding = countPlayersWithPathFinding + 1;
    end;
  end;

  -- ���� ��� ������ � ����������� ���� - ��� �����������������
  if countPlayersWithPathFinding == 2 then
    return PLAYER_2;
  end;

  if countPlayersWithPathFinding == 1 then
    for _, playerId in PLAYER_ID_TABLE do
      local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

      -- ���������� ���� ���� ����������� ������
      if HasHeroSkill(mainHeroName, PERK_PATHFINDING) then
        return playerId;
      end;
    end;
  end;

  -- ���� ��� ���� ������ - �� ��������� �������� �����
  return PLAYER_2;
end;
