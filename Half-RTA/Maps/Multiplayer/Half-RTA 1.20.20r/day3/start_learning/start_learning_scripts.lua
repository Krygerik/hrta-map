
PATH_TO_START_LEARNING_MODULE = PATH_TO_DAY3_SCRIPTS.."start_learning/";
PATH_TO_START_LEARNING_MESSAGES = PATH_TO_START_LEARNING_MODULE.."messages/";

doFile(PATH_TO_START_LEARNING_MODULE..'start_learning_constants.lua');
sleep(1);

-- ������� ��� ������ ��������
QUESTION_BY_RACE = {
  [RACES.HAVEN] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_haven.txt",
  [RACES.INFERNO] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_inferno.txt",
  [RACES.NECROPOLIS] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_necropolis.txt",
  [RACES.SYLVAN] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_sylvan.txt",
  [RACES.ACADEMY] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_academy.txt",
  [RACES.DUNGEON] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_dungeon.txt",
  [RACES.FORTRESS] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_fortress.txt",
  [RACES.STRONGHOLD] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_stronghold.txt",
};

-- ���� ������������ � �������� ��������
LEARNING_OBJECTS_NAME_AND_DESCRIPTION_MAP = {
  [PLAYER_LEARNING_OBJECTS_NAMES[PLAYER_1]] = {
    name = PATH_TO_START_LEARNING_MESSAGES..'arena_name.txt',
    description = PATH_TO_START_LEARNING_MESSAGES..'arena_description.txt',
  },
  [PLAYER_LEARNING_OBJECTS_NAMES[PLAYER_2]] = {
    name = PATH_TO_START_LEARNING_MESSAGES..'arena_name.txt',
    description = PATH_TO_START_LEARNING_MESSAGES..'arena_description.txt',
  },
}

-- ������� ��� ��������� �������� �����
function start_learning_script()
  print "start_learning_script"
  
  setLearningTriggers();
  setMentorTriggers();
  setBuySkillTriggers();
end;

-- ��������� ��������� �� ������� ����
function setBuySkillTriggers()
  print "setBuySkillTriggers"
  
  for _, playerId in PLAYER_ID_TABLE do
    SetObjectEnabled(BUY_SKILL_OBJECTS_NAME[playerId], nil);
    OverrideObjectTooltipNameAndDescription(
      BUY_SKILL_OBJECTS_NAME[playerId],
      PATH_TO_START_LEARNING_MESSAGES..'buy_skill_name.txt',
      PATH_TO_START_LEARNING_MESSAGES..'buy_skill_description.txt'
    );
    Trigger(OBJECT_TOUCH_TRIGGER, BUY_SKILL_OBJECTS_NAME[playerId], 'handleTouchBuySkill');
  end;
end;

-- ��������� ������� ��������� ������� ������
function getPriceBuySkill(playerId)
  print "getPriceBuySkill"

  local playerMainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  -- �� ������ ��������
  if playerMainHeroName == nil then
    return 8000;
  end;
  
  -- ���� ����� ��� ��������
  return 5000;
end;

-- ���������� ������, ��� ����� ��� ����� �������� �������
function getIsHeroHasMaximumCountSkills(heroName)
  print "getIsHeroHasMaximumCountSkills"
  
  local countSkills = 0;
  
  for _, skillId in ALL_NOT_RACES_SKILL_LIST do
    if GetHeroSkillMastery(heroName, skillId) > 0 then
      countSkills = countSkills + 1;
    end;
  end;
  
  return countSkills == 6;
end;

-- ���������� �������������� � ������� ��� ������� ����
function handleTouchBuySkill(triggerHero)
  print "handleTouchBuySkill"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local priceBuySkill = getPriceBuySkill(playerId);
  
  if getIsHeroHasMaximumCountSkills(triggerHero) then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."has_maximum_skills.txt");

    return nil;
  end;
  
  if GetPlayerResource(playerId, GOLD) < priceBuySkill then
    MessageBoxForPlayers(
      playerId,
      {PATH_TO_START_LEARNING_MESSAGES.."not_enough_n_gold.txt"; eq=priceBuySkill}
    );

    return nil;
  end;
  
  questionBuySkill(triggerHero, priceBuySkill, 1);
end;

-- ������ �� ������� ������
function questionBuySkill(heroName, priceStr, skillIndexStr)
  print "questionBuySkill"
  
  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  
  -- ���������� ���������� ������ � �����
  local price = priceStr + 0;
  local skillIndex = skillIndexStr + 0;
  
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;
  
  -- ���� ���������� ��� ��� ��������
  if skillIndex > length(ALLOW_BUY_SKILL_LIST_BY_RACE[playerRaceId]) then
    return nil;
  end;
  
  local offerSkillId = ALLOW_BUY_SKILL_LIST_BY_RACE[playerRaceId][skillIndex];

  -- ���� ����� ��� ����� ������ ���� - ���������� ���������
  if GetHeroSkillMastery(heroName, offerSkillId) > 0 then
    questionBuySkill(heroName, price, skillIndex + 1);

    return nil;
  end;

  QuestionBoxForPlayers(
    playerId,
    { PATH_TO_START_LEARNING_MESSAGES..BUY_SKILL_QUESTIONS[offerSkillId]; eq = price },
    'addHeroOfferSkill("'..heroName..'", "'..offerSkillId..'", "'..price..'")',
    'questionBuySkill("'..heroName..'", "'..price..'", "'..(skillIndex + 1)..'")'
  );
end;

-- ��������� ����� ��������� �����
function addHeroOfferSkill(heroName, skillIdStr, priceStr)
  print "addHeroOfferSkill"

  local skillId = skillIdStr + 0;
  local price = priceStr + 0;
  
  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  GiveHeroSkill(heroName, skillIdStr);
  Trigger(OBJECT_TOUCH_TRIGGER, BUY_SKILL_OBJECTS_NAME[playerId], 'noop');
  SetPlayerResource(playerId, GOLD, (GetPlayerResource (playerId, GOLD) - price));
end;

-- ��������� ��������� ��� �������� �����
function setMentorTriggers()
  print "setMentorTriggers"

  for _, playerId in PLAYER_ID_TABLE do
    local heroes = RESULT_HERO_LIST[playerId].heroes;
    
    for _, heroName in heroes do
      Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'handleHeroRemoveSkill');
    end;
  end;
end;

-- ��������� ��������� ��� �������� �����
function setLearningTriggers()
  print "setLearningTriggers"
  
  for _, playerId in PLAYER_ID_TABLE do
    SetObjectEnabled(PLAYER_LEARNING_OBJECTS_NAMES[playerId], nil);
    OverrideObjectTooltipNameAndDescription(
      PLAYER_LEARNING_OBJECTS_NAMES[playerId],
      LEARNING_OBJECTS_NAME_AND_DESCRIPTION_MAP[PLAYER_LEARNING_OBJECTS_NAMES[playerId]].name,
      LEARNING_OBJECTS_NAME_AND_DESCRIPTION_MAP[PLAYER_LEARNING_OBJECTS_NAMES[playerId]].description
    );
    Trigger(
      OBJECT_TOUCH_TRIGGER,
      PLAYER_LEARNING_OBJECTS_NAMES[playerId],
      'questionLearning'
    );
  end;
end;

-- ������ ������������ � ������ ��������
function questionLearning(triggerHero)
  print "questionLearning"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;
  local question = QUESTION_BY_RACE[playerRaceId];
  
  local playerMainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  -- ����������� ������ ���������� ��������
  if playerMainHeroName == nil then
    QuestionBoxForPlayers(
      playerId,
      question,
      'learning("'..playerId..'", "'..triggerHero..'", "'..'1'..'")',
      'noop'
    );
    
    return nil;
  end;

  local playerMainHeroLvl = GetHeroLevel(playerMainHeroName);

  -- ����������� ���������� ���������� ��������
  if playerMainHeroLvl == HALF_FREE_LEARNING_LEVEL then
    QuestionBoxForPlayers(
      playerId,
      PATH_TO_START_LEARNING_MESSAGES..'question_continue_learning.txt',
      'learning("'..playerId..'", "'..triggerHero..'", "'..'2'..'")',
      'noop'
    );
    
    return nil;
  end;
  
  -- ���� ��������� �������� � ��������
  if playerMainHeroLvl >= MAXIMUM_AVAILABLE_LEVEL then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES..'hero_already_has_the_maximum_level.txt');

    return nil;
  end;
  
  local needGold = MAP_LEVEL_BY_PRICE[playerMainHeroLvl + 1];
  local currentPlayerGold = GetPlayerResource(playerId, GOLD);

  -- ���� ������������ ����� ��� ������� ������
  if needGold > currentPlayerGold then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES..'not_enough_money.txt');

    return nil;
  end;
  
  -- ����������� ������ �������������� ������
  if playerMainHeroLvl >= FREE_LEARNING_LEVEL then
    QuestionBoxForPlayers(
      playerId,
      {
        PATH_TO_START_LEARNING_MESSAGES..'question_buy_level.txt';
        eq = MAP_LEVEL_BY_PRICE[playerMainHeroLvl + 1]
      },
      'learning("'..playerId..'", "'..triggerHero..'", "'..'3'..'")',
      'noop'
    );
    
    return nil;
  end;
end;

-- ��������� ������� ����������� �����
function learning(strPlayerId, heroName, stage)
  print "learning"

  local playerId = strPlayerId + 0;

  -- ������ ���������� ��������
  if stage == '1' then
     PLAYERS_MAIN_HERO_PROPS[playerId].name = heroName;
     setControlStatsTriggerOnHero(playerId);
     
     ChangeHeroStat(heroName, STAT_EXPERIENCE, TOTAL_EXPERIENCE_BY_LEVEL[HALF_FREE_LEARNING_LEVEL]);
  end;
  
  -- ����������� ���������� ��������
  if stage == '2' then
    local playerMainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    local needExperience = TOTAL_EXPERIENCE_BY_LEVEL[FREE_LEARNING_LEVEL] - TOTAL_EXPERIENCE_BY_LEVEL[HALF_FREE_LEARNING_LEVEL];
    
    ChangeHeroStat(playerMainHeroName, STAT_EXPERIENCE, needExperience);
  end;
  
  -- ������� �������������� �������
  if stage == '3' then
    local playerMainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    local playerMainHeroLevel = GetHeroLevel(playerMainHeroName);
    local needExperience = TOTAL_EXPERIENCE_BY_LEVEL[playerMainHeroLevel + 1] - TOTAL_EXPERIENCE_BY_LEVEL[playerMainHeroLevel];
    
    ChangeHeroStat(playerMainHeroName, STAT_EXPERIENCE, needExperience);
    
    local needGold = MAP_LEVEL_BY_PRICE[playerMainHeroLevel + 1];
    local currentPlayerGold = GetPlayerResource(playerId, GOLD);

    SetPlayerResource(playerId, GOLD, currentPlayerGold - needGold);
  end;
end;

-- ��������� ��������� �� �������� ��������� ������
function setControlStatsTriggerOnHero(playerId)
  print "setControlStatsTriggerOnHero"
  
  local heroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  for _, statId in ALL_MAIN_STATS_LIST do
    PLAYERS_MAIN_HERO_PROPS[playerId].stats[statId] = GetHeroStat(heroName, statId);
  end;

  Trigger(HERO_LEVELUP_TRIGGER, heroName, 'handleHeroLevelUp("'..heroName..'")');
  Trigger(HERO_ADD_SKILL_TRIGGER, heroName, 'handleHeroAddSkill');
  Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'handleHeroRemoveSkill');
end;

-- ���������� ������ ������ ������ ������
function handleHeroRemoveSkill(triggerHero, skill)
  print "handleHeroRemoveSkill"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  
  mentorCashback(playerId);

  -- ���� �� ������ ������� �����, �� ���������� ������� ���������� ��������
  if PLAYERS_MAIN_HERO_PROPS[playerId].name == nil then
    return nil;
  end;

  local change = MAP_SKILLS_TO_CHANGING_STATS[skill];
  
  -- ���� ������� �����, ������ �����
  if change ~= nil then
    increasePlayerMainHeroStat(playerId, change.stat, -change.count);
  end;

  -- ���� �����������
  if skill == SKILL_LEARNING or skill == HERO_SKILL_BARBARIAN_LEARNING then
    removePlayerMainHeroLearningStats(playerId);
  end;
end;

-- ������� �������� ������� ��� ������� �������
function mentorCashback(playerId)
  print "mentorCashback"
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local currentCountFirstLeveDiscount = PLAYERS_FIRST_LEVEL_DISCOUNT_ON_REMOVE_SKILLS[playerId];
  
  -- ���� � ������ �� ������ �� ���� �����, ���� ��� 2 ������� �� 500 �����
  if mainHeroName == nil then
    -- ������� �� ��������� ����� 500
    if currentCountFirstLeveDiscount > 0 then

      PLAYERS_FIRST_LEVEL_DISCOUNT_ON_REMOVE_SKILLS[playerId] = currentCountFirstLeveDiscount - 1;

      return nil;
    end;
    
    -- ����� ��������� ������� �������, ������������� ������� ����
    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) -  2000));
    
    return nil;
  end;
  
  local mainHeroLevel = GetHeroLevel(mainHeroName);
  
  -- ���� ����� ���������� �������� - �������� �������, ����� �������� ���������� 2500
  if mainHeroLevel == HALF_FREE_LEARNING_LEVEL then
    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) -  1000));
    
    return nil;
  end;
end;

-- ���������� ��������� ������ ������ ������
function handleHeroAddSkill(triggerHero, skill)
  print "handleHeroAddSkill"
  
  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  
  -- ���� �� ������ ������� �����, �� ���������� ������� ���������� ��������
  if PLAYERS_MAIN_HERO_PROPS[playerId].name == nil then
    return nil;
  end;

  local change = MAP_SKILLS_TO_CHANGING_STATS[skill];

  -- ���� ������� �����, ������ �����
  if change ~= nil then
    increasePlayerMainHeroStat(playerId, change.stat, change.count);
  end;
  
  -- ���� ����� �����������
  if skill == SKILL_LEARNING or skill == HERO_SKILL_BARBARIAN_LEARNING then
    addPlayerMainHeroLearningStats(playerId);
  end;
end;

-- ��������� �������� ����� ������ ������ �����������
function removePlayerMainHeroLearningStats(playerId)
  print "removePlayerMainHeroLearningStats("

  local learning = PLAYERS_MAIN_HERO_PROPS[playerId].learning;
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  local currentLearningLevel = PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level;

  -- ������� ����� ����������� � �����
  for _, statId in ALL_MAIN_STATS_LIST do
    if learning[currentLearningLevel][statId] ~= nil then
      increasePlayerMainHeroStat(playerId, statId, -learning[currentLearningLevel][statId]);
    end;
  end;

  PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level = currentLearningLevel - 1;
end;

-- ��������� �������� ����� ������ ������ �����������
function addPlayerMainHeroLearningStats(playerId)
  print "addPlayerMainHeroLearningStats"
  
  local learning = PLAYERS_MAIN_HERO_PROPS[playerId].learning;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  
  local nextLerningLevel = PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level + 1;
  
  if learning[nextLerningLevel] == nil then
    learning[nextLerningLevel] = {};
    
    -- ���������� 3 ��������� ����� ��� ����� ������ �������
    for indexStat = 1, 3 do
      local randomGenerateStatId = getRandomStatByRace(raceId);

      local generateStatPrevValue = 0;

      -- ���� ���� �������������� �����
      if learning[nextLerningLevel][randomGenerateStatId] ~= nil then
        generateStatPrevValue = learning[nextLerningLevel][randomGenerateStatId];
      end;

      learning[nextLerningLevel][randomGenerateStatId] = generateStatPrevValue + 1;
    end;
  end;
  
  -- ��������� ����� ����������� �����
  for _, statId in ALL_MAIN_STATS_LIST do
    if learning[nextLerningLevel][statId] ~= nil then
      increasePlayerMainHeroStat(playerId, statId, learning[nextLerningLevel][statId]);
    end;
  end;
  
  PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level = nextLerningLevel;
end;

-- ���������� ��������� ������ ������ ������
function handleHeroLevelUp(triggerHero)
  print "handleHeroLevelUp"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;
  
  -- �� �������� ���������������� �����
  local randomGenerateStatId = getRandomStatByRace(playerRaceId);
  
  increasePlayerMainHeroStat(playerId, randomGenerateStatId);
end;

-- ��������� ��������� ���������� ����� � ������������ � ������� ��������������
function getRandomStatByRace(raceId)
  print "getRandomStatByRace"
  
  local raceDropStatPercent = DROP_STAT_PERCENT_BY_RACE[raceId];

  -- ������� ��������� �������
  local randomPercent = random(100);

  local maxAttackLimit = raceDropStatPercent.attack;

  -- ���� ���� � �����
  if randomPercent < maxAttackLimit then
    return STAT_ATTACK;
  end;

  local maxDefenceLimit = maxAttackLimit + raceDropStatPercent.defence;

  -- ���� ���� � ������
  if randomPercent < maxDefenceLimit then
    return STAT_DEFENCE;
  end;

  local maxSpellpowerLimit = maxDefenceLimit + raceDropStatPercent.spellpower;

  -- ���� ���� � ����������
  if randomPercent < maxSpellpowerLimit then
    return STAT_SPELL_POWER;
  end;

  local maxKnowledgeLimit = maxSpellpowerLimit + raceDropStatPercent.knowledge;

  -- ���� ���� � ������
  if randomPercent < maxKnowledgeLimit then
    return STAT_KNOWLEDGE;
  end;
end;

-- ���������� �������� ����������� ����� � �������� ����� ������
function increasePlayerMainHeroStat(playerId, statId, count)
  print "increaseHeroStat"
  
  if count == nil then
    count = 1;
  end;
  
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId];
  
  -- ������ ���������� ��������� ������� ��������� �����
  playerMainHero.stats[statId] = playerMainHero.stats[statId] + count;
  
  -- ������ ����� �� �� ������ ���������� ������
  local currentHeroStat = GetHeroStat(playerMainHero.name, statId);
  
  for _, statId in ALL_MAIN_STATS_LIST do
    ChangeHeroStat(playerMainHero.name, statId, playerMainHero.stats[statId] - GetHeroStat(playerMainHero.name, statId));
  end;
end;

start_learning_script();
