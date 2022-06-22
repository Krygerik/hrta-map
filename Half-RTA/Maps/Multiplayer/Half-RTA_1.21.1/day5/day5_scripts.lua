
-- ���������, �� ��������� �� ����� �� ����������
function checkNeedAutoTransferHero()
  print "checkNeedAutoTransferHero"

  local activePlayerId = getSelectedBattlefieldPlayerId();
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[activePlayerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  if HasHeroSkill(mainHeroName, PERK_PATHFINDING) == nil and dictHeroName ~= HEROES.JAZAZ then
    -- �������� ������������ ����� ��
  end;
end;

-- ������� ���
function generateSeed()
  print "generateSeed"

  local t = {};
  
	for i=1,6 do
		t[i] = random(16777216)
	end;

	consoleCmd([[@SetGameVar('combat_prng_seed', 'return {]] .. concat(t, ',') .. [[}')]])
end;

-- ����������� ������ �� ������� � ������ �������
function saveHeroesInfoInToBattle()
  print "saveHeroesInfoInToBattle"
  
  local customConsoleCommand = {[[@SetGameVar('heroes_info', 'return {]]};
  
  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    
    append(customConsoleCommand, '["' .. mainHeroName .. '"]={');
    
    -- ������� --
		append(customConsoleCommand, 'level=' .. GetHeroLevel(mainHeroName) .. ',')

		-- ����� --
		append(customConsoleCommand, 'luck=' .. GetHeroStat(mainHeroName, STAT_LUCK) .. ',')

		-- ��������� --
		append(customConsoleCommand, 'ArtSet={')
    for artset = 0, 9 do
      local artsetlevel = GetArtifactSetItemsCount(mainHeroName, artset, 1)
      if artsetlevel > 0 then
        append(customConsoleCommand, '[' .. artset .. ']=' .. artsetlevel .. ',')
      end
    end
    append(customConsoleCommand, '},')

		-- ������ � ������ --
		append(customConsoleCommand, 'skills={')
		for skill = 1, 220 do
			local mastery = GetHeroSkillMastery(mainHeroName, skill)
			if mastery > 0 then
				append(customConsoleCommand, '[' .. skill .. ']=' .. mastery .. ',')
			end
		end
		append(customConsoleCommand, '},')

		append(customConsoleCommand, '},')
  end;
  
  append(customConsoleCommand, [[}')]])
	consoleCmd(concat(customConsoleCommand))
end;

-- ��������� �� ��������� �������, �� ����������� � ��������� �������
function getOtherRandomRaceId()
  print "getOtherRandomRaceId"

  local player1RaceId = RESULT_HERO_LIST[PLAYER_1].raceId;
  local player2RaceId = RESULT_HERO_LIST[PLAYER_2].raceId;
  
  local resultRaceIdTable = {};

  for _, raceId in RACES do
    if raceId ~= RACES.NEUTRAL and raceId ~= player1RaceId and raceId ~= player2RaceId then
      resultRaceIdTable[length(resultRaceIdTable)] = raceId;
    end;
  end;
  
  local randomIndex = random(length(resultRaceIdTable)) + 1;
  
  return resultRaceIdTable[randomIndex];
end;

-- �������� ������� ������ �� ������ ������ � ��������� ������������ �� �����������
function checkAndMoveHeroFromFrendlyField()
  print "checkAndMoveHeroFromFrendlyField"

  local RACE_ON_FRENDLY_FIELD_POSITION = {
    [RACES.HAVEN] = { x = 52, y = 51 },
    [RACES.INFERNO] = { x = 56, y = 51 },
    [RACES.NECROPOLIS] = { x = 48, y = 51 },
    [RACES.SYLVAN] = { x = 52, y = 51 },
    [RACES.ACADEMY] = { x = 48, y = 49 },
    [RACES.DUNGEON] = { x = 40, y = 51 },
    [RACES.FORTRESS] = { x = 44, y = 51 },
    [RACES.STRONGHOLD] = { x = 50, y = 45 },
  };
  
  local choisePlayerId = getSelectedBattlefieldPlayerId();
  local choiseHeroName = PLAYERS_MAIN_HERO_PROPS[choisePlayerId].name;
  local choisePlayerRaceId = RESULT_HERO_LIST[choisePlayerId].raceId;

  -- � ����������� ���� ����� �������������� ��� ������
  if HasHeroSkill(choiseHeroName, PERK_PATHFINDING) then
    return nil;
  end;

  for raceId, raceRegion in MAP_RACE_ON_NATIVE_REGIONS do
    if IsObjectInRegion(choiseHeroName, raceRegion) and choisePlayerRaceId == raceId then
      local randomRaceId = getOtherRandomRaceId();
      local raceFieldPosition = RACE_ON_FRENDLY_FIELD_POSITION[randomRaceId];
      
      MoveHeroRealTime(choiseHeroName, raceFieldPosition.x, raceFieldPosition.y);
      
      return nil;
    end;
  end;
end;

-- ����� ������
function day5_scripts()
  print "day5_scripts"

  saveHeroesInfoInToBattle();
  generateSeed();
  
  consoleCmd("@SetGameVar('execution_thread', '1')");
  
  checkAndMoveHeroFromFrendlyField();

  local p1MainHeroName = PLAYERS_MAIN_HERO_PROPS[PLAYER_1].name;
  local p2MainHeroName = PLAYERS_MAIN_HERO_PROPS[PLAYER_2].name;

  local choisePlayerId = getSelectedBattlefieldPlayerId();
  
  while IsHeroAlive(p1MainHeroName) and IsHeroAlive(p2MainHeroName) do
    if choisePlayerId == PLAYER_2 then
      MakeHeroInteractWithObject(p1MainHeroName, p2MainHeroName);
    else
      MakeHeroInteractWithObject(p2MainHeroName, p1MainHeroName);
    end;

    sleep(10);
  end;
end;

day5_scripts();