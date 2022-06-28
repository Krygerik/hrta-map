
PATH_TO_DAY5_SCRIPTS = GetMapDataPath().."day5/";
PATH_TO_DAY5_MESSAGES = PATH_TO_DAY5_SCRIPTS.."messages/";

doFile(PATH_TO_DAY5_SCRIPTS.."day5_constants.lua");
sleep(1);

-- ������������ ��������� � ����� ��������� � �������� ���
function clearGarnisonOnChangeTread(garnisonName)
  print 'clearGarnisonOnChangeTread'

  local initArmy = {
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
  };

  -- �������� �����, ���� �������� ���, �� ������� �� = 0
  initArmy[1].id, initArmy[2].id, initArmy[3].id, initArmy[4].id, initArmy[5].id, initArmy[6].id, initArmy[7].id = GetObjectCreaturesTypes(garnisonName);

  -- �������, ������� ������� ���� �������
  for _, army in initArmy do
    if army.id ~= 0 then
      army.kol = GetObjectCreatures(garnisonName, army.id);
    end;
  end;

  -- ������, ����� ����� �� ���� ������
  local playerTakeArmy = nil;

  while not playerTakeArmy do
    for _, army in initArmy do
      if army.id ~= 0 then
        local currentCountUnits = GetObjectCreatures(garnisonName, army.id);

        if currentCountUnits < army.kol then
          playerTakeArmy = not nil;
        end;
      end;
    end;

    sleep(1);
  end;

  -- ������� ���, ��� �������� �� ���������
  for _, army in initArmy do
    if army.id ~= 0 then
      local currentCountUnits = GetObjectCreatures(garnisonName, army.id);

      if currentCountUnits > 0 then
        RemoveObjectCreatures(garnisonName, army.id, currentCountUnits);
      end;
    end;
  end;
end;

-- ���������� ���� ����������
function getDiplomacyKoef(heroName)
  print 'getDiplomacyKoef'

  local DIPLOMACY_DEFAULT_COEF = 0.4;

  local dictHeroName = getDictionaryHeroName(heroName);

  if dictHeroName == HEROES.ROLF then
    return 2 * DIPLOMACY_DEFAULT_COEF;
  end;

  return DIPLOMACY_DEFAULT_COEF;
end;

-- ��������� ������ "����������"
function runDiplomacy(heroName)
  print 'runDiplomacy'

  local playerId = GetObjectOwner(heroName);

  awaitMessageBoxForPlayers(playerId, PATH_TO_DAY5_MESSAGES.."diplomacy.txt");

  local stashArmy = {
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
  };

  stashArmy[1].id1, stashArmy[2].id1, stashArmy[3].id1, stashArmy[4].id1, stashArmy[5].id1, stashArmy[6].id1, stashArmy[7].id1 = GetHeroCreaturesTypes(heroName);

  -- ��������, ����� ������ ����� ����������
  for _, stashItem in stashArmy do
    if stashItem.id1 ~= nil then
      for gradeCreatureId, altGradeCreatureId in MAP_CREATURES_ON_GRADE do
        if stashItem.id1 == gradeCreatureId or stashItem.id1 == altGradeCreatureId then
          if GetHeroCreatures(heroName, gradeCreatureId) == 0 then
            stashItem.id2 = gradeCreatureId;
          elseif GetHeroCreatures(heroName, altGradeCreatureId) == 0 then
            stashItem.id2 = altGradeCreatureId;
          else
            -- ����� ������ �� ������������
            if stashItem.id1 == gradeCreatureId then
              if GetHeroCreatures(heroName, gradeCreatureId) >= GetHeroCreatures(heroName, altGradeCreatureId) then
                stashItem.id2 = altGradeCreatureId;
              else
                stashItem.id2 = gradeCreatureId;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  local diplomacyKoef = getDiplomacyKoef(heroName);

  -- ��������� � �������� �����, ��������� ��� ������������� ����� ����������
  DenyGarrisonCreaturesTakeAway(MAP_GARNISON_FOR_DIPLOMACY[playerId], not nil);

  for _, stashItem in stashArmy do
    for _, raceId in RACES do
      for _, unitData in UNITS[raceId] do
        if stashItem.id1 == unitData.id and stashItem.id2 ~= nil then
          stashItem.kol = diplomacyKoef * unitData.kol;
          AddObjectCreatures(MAP_GARNISON_FOR_DIPLOMACY[playerId], stashItem.id2, stashItem.kol);
        end;
      end;
    end;
  end;

  -- ������ �������� ������ � ������ �� ���������� ���������� ������� � ���
  SetObjectOwner(MAP_GARNISON_FOR_DIPLOMACY[playerId], playerId);
  MakeHeroInteractWithObject(heroName, MAP_GARNISON_FOR_DIPLOMACY[playerId]);

  startThread(clearGarnisonOnChangeTread, MAP_GARNISON_FOR_DIPLOMACY[playerId]);
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

  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

    -- ���������� ���� ���� ����������� ������
    if HasHeroSkill(mainHeroName, PERK_PATHFINDING) then
      return playerId;
    end;
  end;

  -- ���� ��� ���� ������ - �� ��������� �������� �����
  return PLAYER_2;
end;

-- ������ ������ ������ ������
function blockFriendlyBattlefield()
  print "blockFriendlyBattlefield"

  local choisePlayerId = getSelectedBattlefieldPlayerId();
  local choisePlayerRaceId = RESULT_HERO_LIST[choisePlayerId].raceId;
  local choiseHeroName = PLAYERS_MAIN_HERO_PROPS[choisePlayerId].name;
  local choiseDictHeroName = getDictionaryHeroName(choiseHeroName);

  -- ��������� ������ ������ � ���������� �������������
  for _, playerId in PLAYER_ID_TABLE do
    local playerRaceId = RESULT_HERO_LIST[playerId].raceId;

    -- �.�. ����� �� ���� ���� ���������, ����������� �� ���� :(
    if playerRaceId ~= RACES.STRONGHOLD and playerRaceId ~= RACES.ACADEMY then
      SetRegionBlocked(MAP_RACE_ON_NATIVE_REGIONS[playerRaceId], not nil);
    end;
  end;

  -- ��������-������� ��������� �������� ��� ������ ������
  if choiseDictHeroName == HEROES.JAZAZ then
    SetRegionBlocked(MAP_RACE_ON_NATIVE_REGIONS[RACES.INFERNO], nil);
  end;

  local opponentPlayerId = PLAYERS_OPPONENT[choisePlayerId];
  local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

  -- ��� ���������� "���������� ����" ��� ������� ��� � ����� �������, ������� ������ � �������� ������������� ����������
  if (
    HasHeroSkill(choiseHeroName, PERK_PATHFINDING) == nil
    or (HasHeroSkill(choiseHeroName, PERK_PATHFINDING) and HasHeroSkill(opponentHeroName, PERK_PATHFINDING))
  ) then
    for _, region in MAP_RACE_ON_ADDITIONAL_REGIONS do
      SetRegionBlocked(region, not nil);
    end;

    -- �������� ����
    SetRegionBlocked('land_block0', not nil);
  end;

  -- ���� � ������ ���� "���������� ����", ������ ������ �������� � �������� �������������
  -- ����� ��������� ������� ������ ����� � ���������� �������������
  if HasHeroSkill(choiseHeroName, PERK_PATHFINDING) and HasHeroSkill(opponentHeroName, PERK_PATHFINDING) == nil then
    SetRegionBlocked(MAP_RACE_ON_NATIVE_REGIONS[choisePlayerRaceId], nil);

    for _, playerId in PLAYER_ID_TABLE do
      local playerRaceId = RESULT_HERO_LIST[playerId].raceId;

      if playerRaceId ~= RACES.STRONGHOLD and playerRaceId ~= RACES.ACADEMY then
        SetRegionBlocked(MAP_RACE_ON_ADDITIONAL_REGIONS[playerRaceId], not nil);
      end;
    end;
  end;
end;

-- �������� ����� ��� ������ ���� ���
function teleportHeroToSelectBattlefield(triggerHero)
  print "teleportHeroToSelectBattlefield"

  local playerId = GetObjectOwner(triggerHero);
  local position = PLAYERS_TELEPORT_TO_BATTLE_POSITION[playerId];

  SetObjectPosition(triggerHero, position.x, position.y);
  SetObjectOwner(PLAYERS_BOAT[playerId], playerId);
  SetObjectOwner(PLAYERS_TOWER[playerId], playerId);

  OpenCircleFog(47, 46, GROUND, 16, playerId);

  local choisedFieldPlayerId = getSelectedBattlefieldPlayerId();

  if choisedFieldPlayerId == playerId then
    addHeroMovePoints(triggerHero);
    ShowFlyingSign(PATH_TO_DAY5_MESSAGES.."choise_battlefield.txt", triggerHero, playerId, 5.0);
  else
    removeHeroMovePoints(triggerHero);
    ShowFlyingSign(PATH_TO_DAY4_MESSAGES.."please_skip_turn.txt", triggerHero, playerId, 5.0);
  end;
end;

-- �������� ����� �� �����
function teleportPlayerInToBattle(playerId)
  print "teleportPlayerInToBattle"

  teleportMainHeroToNearTown(playerId);

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  teleportHeroToSelectBattlefield(mainHeroName);
end;

-- ���������� ����� ��� ������ ���� ���
function prepareSelectBattlefield()
  print "prepareSelectBattlefield"

  local choicePlayerId = getSelectedBattlefieldPlayerId();

  -- ���� ���� �������� ������� �����, �� �������� ��
  if choicePlayerId == PLAYER_1 then
    local opponentPlayerId = PLAYERS_OPPONENT[choicePlayerId];
    local playerPosition = PLAYERS_TELEPORT_TO_BATTLE_POSITION[choicePlayerId];
    local opponentPosition = PLAYERS_TELEPORT_TO_BATTLE_POSITION[opponentPlayerId];

    -- ������ �� ����� ��� ������������
    PLAYERS_TELEPORT_TO_BATTLE_POSITION[choicePlayerId] = opponentPosition;
    PLAYERS_TELEPORT_TO_BATTLE_POSITION[opponentPlayerId] = playerPosition;

    -- ������ �� �����
    PLAYERS_BOAT[choicePlayerId], PLAYERS_BOAT[opponentPlayerId] = PLAYERS_BOAT[opponentPlayerId], PLAYERS_BOAT[choicePlayerId];
    PLAYERS_TOWER[choicePlayerId], PLAYERS_TOWER[opponentPlayerId] = PLAYERS_TOWER[opponentPlayerId], PLAYERS_TOWER[choicePlayerId];
  end;

  blockFriendlyBattlefield();
end;

-- ����� ������
function day5_scripts()
  print "day5_scripts"

  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    
    -- ����������
    if HasHeroSkill(mainHeroName, PERK_DIPLOMACY) then
      startThread(runDiplomacy, mainHeroName);
    end;
  end;
  
  prepareSelectBattlefield();

  for _, playerId in PLAYER_ID_TABLE do
    teleportPlayerInToBattle(playerId);
  end;
end;

day5_scripts();