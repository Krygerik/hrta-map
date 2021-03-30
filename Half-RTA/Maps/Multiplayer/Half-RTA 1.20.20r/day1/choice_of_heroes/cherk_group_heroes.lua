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
function cherkGroupHeroes()
  print "cherkGroupHeroes"

  SetObjectPosition(Biara, 35, 87);
  SetObjectPosition(Djovanni, 42, 22);

  -- ������� �������� �� �������
  removeRegionTriggersForHeroGroupSelect();
  -- ������ �������� ��������� ���� ������ ��������� ���
  changeDescriptionForSelectedRaceHeroIcons();
  -- ��������� ����� ��������� ������ ��������� ���
  generateRandomGroupHero(SELECTED_RACE_ID_TABLE[1], SELECTED_RACE_ID_TABLE[2]);
  -- ����� ��������������� ����� � ����������� ���������
  showAllRandomHeroGroups();

  -- �������� ���� ������� ������
  changeTurnSelectedHeroGroup(PLAYER_1);
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

-- �������������� ������ ��� ������ ������ ������
function QuestionDeleteHeroGroup(triggerHero, triggeredIconName)
  print "QuestionDeleteHeroGroup"
  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));

  QuestionBoxForPlayers(playerId, PATH_TO_DAY1_MESSAGES.."question_delete_group_hero.txt", "DeleteHeroGroupByIconName('"..triggeredIconName.."')", 'noop')
end;

-- �������� ������ ������
function DeleteHeroGroupByIconName(iconName)
  print "DeleteHeroGroupByIconName"

  -- ������� ��������� �����
  local playerId, deleteGroupIndex = getGroupDataByIconName(iconName);
  deleteGroupByIndex(playerId, deleteGroupIndex);

  -- ������� � ������� ������ ��������
  for groupIndex = 1, length(RANDOM_GROUPS_HERO_ICONS[playerId].heroGroups) do
    local group = RANDOM_GROUPS_HERO_ICONS[playerId].heroGroups[groupIndex];

    if groupIndex ~= deleteGroupIndex then
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
  else
    -- ���� 2 ����� ��� �� �����, �������� ��� ���
    changeTurnSelectedHeroGroup(PLAYER_2);
  end;
end;

-- �������� ������ ������ �� �� �������
function deleteGroupByIndex(playerId, deleteIndexGroup)
  print "deleteGroupByIndex"

  local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];

  for groupIndex = 1, length(playerData.heroGroups) do
    local group = playerData.heroGroups[groupIndex];

    if groupIndex == deleteIndexGroup then
      group.deleted = true;

      for heroIndex = 1, length(group.heroes) do
        local heroData = group.heroes[heroIndex];

        RemoveObject(heroData.red.icon);
        RemoveObject(heroData.blue.icon);
      end;
    end;
  end;
end;

-- �������� ���������� ����� ������
function deleteResultHeroGroups()
  print "deleteResultHeroGroups"

  for _, playerId in PLAYER_ID_TABLE do
     local playerData = RANDOM_GROUPS_HERO_ICONS[playerId];
     
     for groupIndex = 1, length(playerData.heroGroups) do
       local group = playerData.heroGroups[groupIndex];
       
       if not group.deleted then
         deleteGroupByIndex(playerId, groupIndex);
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

-- ��������� ����� ������ ������ � ���������� �������� ����� ������ ��� 2 �������
function finishGroupCherk()
  removeHeroMovePoints(Djovanni);
  removeHeroMovePoints(Biara);

  sleep(5);

  -- �������� ���������� ������ ������(���������)
  deleteResultHeroGroups();

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

cherkGroupHeroes();