
PATH_TO_CHOISE_OF_HEROES = PATH_TO_DAY1_MODULE.."choice_of_heroes/";

doFile(PATH_TO_CHOISE_OF_HEROES.."common.lua");
sleep(1);

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

-- ���� �� ������ �����
function cherkSingleHeroes()
  print "cherkSingleHeroes"
  
--  SetObjectEnabled('red1', nil); SetDisabledObjectMode('red17', DISABLED_BLOCKED);
--  SetObjectEnabled('red2', nil); SetDisabledObjectMode('red18', DISABLED_BLOCKED);
--  SetObjectEnabled('blue1', nil); SetDisabledObjectMode('blue17', DISABLED_BLOCKED);
--  SetObjectEnabled('blue2', nil); SetDisabledObjectMode('blue18', DISABLED_BLOCKED);
  
--  SetObjectPosition('red1', 31, 86);
--  SetObjectPosition('red2', 39, 86);
--  SetObjectPosition('blue1', 31, 88);
--  SetObjectPosition('blue2', 39, 88);

    SetObjectPosition('blue10', 1, 1);

    SetObjectPosition('red1', 42, 26);
    SetObjectPosition('blue1', 42, 18);
    
    SetObjectPosition('blue2', 35, 91);
  
--  SetObjectPosition('red19', 44, 24);
--  SetObjectPosition('red20', 44, 24);
--  SetObjectPosition('blue19', 44, 24);
--  SetObjectPosition('blue20', 44, 24);
  

  
--  SetObjectEnabled('red19', nil); SetDisabledObjectMode('red19', DISABLED_BLOCKED);
--  SetObjectEnabled('red20', nil); SetDisabledObjectMode('red20', DISABLED_BLOCKED);
--  SetObjectEnabled('blue19', nil); SetDisabledObjectMode('blue19', DISABLED_BLOCKED);
--  SetObjectEnabled('blue20', nil); SetDisabledObjectMode('blue20', DISABLED_BLOCKED);
  
  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);

  removeHeroMovePoints(Djovanni);
  addHeroMovePoints(Biara)

  removeRaceRegionTriggers();

  -- ������ �������� ��������� ���� ������ ��������� ���
  changeDescriptionForSelectedRaceHeroIcons();

  -- ���������� ������ ��������� ������ ��� ����� �������
  generateRandomHeroListByPlayerIdAndRaceId(PLAYER_1, SELECTED_RACE_ID_TABLE[1]);
  generateRandomHeroListByPlayerIdAndRaceId(PLAYER_2, SELECTED_RACE_ID_TABLE[2]);

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

--������� �����������
function deleteFlagsCrystal()

    SetObjectPosition('blue10', 42, 26);
    SetObjectPosition('red1', 1, 1);
    SetObjectPosition('blue1', 1, 1);
    SetObjectPosition('blue2', 1, 1);

end;

-- ������ ��� � �������� ��� ���� ������ ���������� ���
function changeDescriptionForSelectedRaceHeroIcons()
  print "changeDescriptionForSelectedRaceHeroIcons"

  -- �������� �������� � �������� ��������� ���� ������ ��������� ��� �� �����
  for raceIndex, raceId in SELECTED_RACE_ID_TABLE do
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

-- �������, ��� ���� ������: ����� ��� ��������: 0 - ������� ���������, 1 - ������� �������
RANDOM_CHOOSE_FIRST_FLAG = 1;--random(2);

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

-- ���������� �������� ��� ���������� �����
function handlerAddOrDeleteHero(playerId, heroName)
  print "handlerAddOrDeleteHero"

  -- �������������� ������ � �����
  local playerId = playerId + 0;

  local action = getCurrentTurnAction();
  if action == TURN_ACTIONS.CHOOSING then
    addHeroForPlayer(playerId, heroName, true);
  else
    hideHeroToUnderground(playerId, heroName, true);
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

-- ������� ������ ����� � ����������
function hideHeroToUnderground(playerId, heroName, manual)
  print "hideHeroToUnderground"

  for heroIndex = 1, length(randomHeroList[playerId]) do
    local heroData = randomHeroList[playerId][heroIndex];

    if (heroData.name == heroName) then
      heroData.deleted = true;
      heroData.manual_change = manual;

      SetObjectPosition(heroData.red_icon, 1, 1, UNDERGROUND);
      SetObjectPosition(heroData.blue_icon, 1, 1, UNDERGROUND);
    end;
  end;
  -- TODO
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
          hideHeroToUnderground(playerId, heroData.name);
        end;
      end;
    end;
  end;
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
  else
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

-- �������� ���������� ����� ������
function deleteResultHeroIcons()
  print "deleteResultHeroIcons"

  -- ����������� ��������������� ������ ��� ������
  for playerId = 1, length(randomHeroList) do
    local heroList = randomHeroList[playerId];

    for heroIndex = 1, length(heroList) do
      local heroData = heroList[heroIndex];

      hideHeroToUnderground(playerId, heroData.name);
      hideHeroToUnderground(playerId, heroData.name);
    end;
  end;
end;

-- ��������� ��������� ������ ������ ��� ����� �������
function setResultHeroes()
  print "setResultHeroes"

  sleep(1);

  deleteResultHeroIcons();

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

    -- ���������� ������ ������, ������� ����� ���������� ���������
    RESULT_HERO_LIST[playerId].choised_heroes = selectedHero;
    -- ���������� ���� ������
    RESULT_HERO_LIST[playerId].raceId = heroList[1].raceId;
  end;

  -- ��������� �������� ������ 2 ���������� ���������� ������� � 1 ���������
  setRandomHeroFromHeroList();
  
  deleteFlagsCrystal()
  
end;




cherkSingleHeroes();