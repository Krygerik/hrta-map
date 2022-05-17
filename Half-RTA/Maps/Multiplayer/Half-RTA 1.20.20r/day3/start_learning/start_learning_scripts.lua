
PATH_TO_START_LEARNING_MODULE = PATH_TO_DAY3_SCRIPTS.."start_learning/";
PATH_TO_START_LEARNING_MESSAGES = PATH_TO_START_LEARNING_MODULE.."messages/";

doFile(PATH_TO_START_LEARNING_MODULE..'start_learning_constants.lua');
sleep(1);

-- ������� ��� ��������� �������� �����
function start_learning_script()
  print "start_learning_script"
  
  setLearningTriggers();
  setMentorTriggers();
  setBuySkillTriggers();
  setBuyStatsTriggers();
  setReGenerationStatTriggers();
end;

-- ��������� ��������� �� ������� �������������� ������
function setReGenerationStatTriggers()
  print "setReGenerationStatTriggers"
  
  -- ������� �������� ��� ������������� ��������� �� �������
  local MAP_RE_GENERATION_OBJECT_NAME_ON_PLAYER = {
    [PLAYER_1] = 'stat1',
    [PLAYER_2] = 'stat2',
  };

  for _, playerId in PLAYER_ID_TABLE do
    SetObjectEnabled(MAP_RE_GENERATION_OBJECT_NAME_ON_PLAYER[playerId], nil);
    OverrideObjectTooltipNameAndDescription(
      MAP_RE_GENERATION_OBJECT_NAME_ON_PLAYER[playerId],
      PATH_TO_START_LEARNING_MESSAGES.."re_generation_stats_object_name.txt",
      PATH_TO_START_LEARNING_MESSAGES.."re_generation_stats_object_desc.txt"
    );
    Trigger(OBJECT_TOUCH_TRIGGER, MAP_RE_GENERATION_OBJECT_NAME_ON_PLAYER[playerId], 'handleTouchReGenerationStatObject' );
  end;
end;

-- ��������� ������� ������ ������� ��� ������������� ������
function handleTouchReGenerationStatObject(triggerHero)
  print "handleTouchReGenerationStatObject"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  if playerMainHeroProps.name == nil then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."need_main_hero.txt");

    return nil;
  end;

  if GetPlayerResource(playerId, GOLD) < COST_RE_GENERATION_STATS then
    MessageBoxForPlayers(GetPlayerFilter(playerId), {PATH_TO_START_LEARNING_MESSAGES.."not_enough_n_gold.txt"; eq=COST_RE_GENERATION_STATS});
    
    return nil;
  end;
  
  QuestionBoxForPlayers(
    playerId,
    {PATH_TO_START_LEARNING_MESSAGES.."question_re_generation_stats.txt"; eq = COST_RE_GENERATION_STATS},
    'reGenerationStats("'..playerId..'")',
    'noop'
  );
end;

-- ������������� ������ � �������� ����� ������
function reGenerationStats(strPlayerId)
  print "reGenerationStats"

  local playerId = strPlayerId + 0;
  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;

  -- ������� ���������� ���������, ���������� �� ������
  local countHeroMainStats = 0;
  
  for _, statId in ALL_MAIN_STATS_LIST do
    countHeroMainStats = countHeroMainStats + mainHeroProps.stats[statId];
  end;
  
  -- �������� ����� �� ������
  for _, statId in ALL_MAIN_STATS_LIST do
    mainHeroProps.stats[statId] = 0;
  end;
  
  -- ���������� �� ������ :)
  for indexStat = 1, countHeroMainStats do
    local randomGenerateStatId = getRandomStatByRace(playerRaceId);

    changeMainHeroMainStat(playerId, randomGenerateStatId);
  end;
  
  local mainHeroX, mainHeroY = GetObjectPosition(mainHeroProps.name);
  Play2DSoundForPlayers(playerId, "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", mainHeroX, mainHeroY, 0);

  -- ������� ����� �� ����������
  SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) - COST_RE_GENERATION_STATS));
end;

-- ��������� ��������� �� ������� �������������� ������
function setBuyStatsTriggers()
  print "setBuyStatsTriggers"

  for _, playerId in PLAYER_ID_TABLE do
    for _, statId in ALL_MAIN_STATS_LIST do
      local object = BUY_STATS_OBJECTS_NAMES[playerId][statId];

      SetObjectEnabled(object.id, nil);
      OverrideObjectTooltipNameAndDescription(object.id, object.name, object.desc);
      Trigger(OBJECT_TOUCH_TRIGGER, object.id, 'handleTouchBuyStatObject("'..playerId..'", "'..statId..'")');
    end;
  end;
end;

-- ���������� �������������� ����� � �������� ��� ������� �����
function handleTouchBuyStatObject(strPlayerId, strStatId)
  print "handleTouchBuyStatObject"

  local playerId = strPlayerId + 0;
  local statId = strStatId + 0;

  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  if playerMainHeroProps.name == nil then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."need_main_hero.txt");

    return nil;
  end;

  if playerMainHeroProps.count_buy_stats == 2 then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."has_maximum_buy_stats.txt");

    return nil;
  end;

  if GetPlayerResource(playerId, GOLD) < 2500 then
    MessageBoxForPlayers(playerId, {PATH_TO_START_LEARNING_MESSAGES.."not_enough_n_gold.txt"; eq=2500});

    return nil;
  end;

  QuestionBoxForPlayers(playerId, MAP_BUY_STAT_ON_QUESTIONS[statId], 'buyStat("'..playerId..'", "'..statId..'")', 'noop');
end;

-- ���������� ������� ��������� �������� ����� �� ������ ����������
function refreshMainHeroStats(playerId)
  print "refreshMainHeroStats"

  -- ������� � ����� ��� ������
  moveAllMainHeroArtsToStorage(playerId);
  
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId];

  for _, statId in ALL_MAIN_STATS_LIST do
    local changeStatValue = playerMainHero.stats[statId]
      + playerMainHero.start_stats[statId]
      + playerMainHero.stats_for_skills[statId]
      + playerMainHero.buy_stats[statId]
      - GetHeroStat(playerMainHero.name, statId);

    -- ���� ���� �������, ��������� ����� �� ��� ������ �������
    if playerMainHero.current_learning_level > 0 then
      for learningLevel = 1, playerMainHero.current_learning_level do
        changeStatValue = changeStatValue + playerMainHero.learning[learningLevel][statId]
      end;
    end;
    
    -- ��������� ��������� ����� � ������� ��� �������
    -- ����������� ����� � �� ���� ���� ���������� ��� ����������
    if HasHeroSkill(playerMainHero.name, NECROMANCER_FEAT_HAUNT_MINE) or HasHeroSkill(playerMainHero.name, WIZARD_FEAT_ABSOLUTE_WIZARDY) then
      changeStatValue = changeStatValue + MAP_WEEK_ON_ASTROLOGY_STATS[GetCurrentMoonWeek()][statId]
    end;

    ChangeHeroStat(playerMainHero.name, statId, changeStatValue);
  end;

  -- ������ ������ �������
  getAllMainHeroArtsFromStorage(playerId);
end;

-- ���������� �������� ����������� ����� � �������� ����� ������
function changeMainHeroMainStat(playerId, statId, count)
  print "changeMainHeroMainStat"

  if count == nil then
    count = 1;
  end;

  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- ������ ���������� ��������� ������� ��������� �����
  playerMainHero.stats[statId] = playerMainHero.stats[statId] + count;

  -- ��������� ����� ��
  refreshMainHeroStats(playerId);
end;

-- ��������� � �� ������, ���������� �� ������
function changeMainHeroStatsForSkills(playerId, statId, count)
  print "changeMainHeroStatsForSkills"

  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- ������ ���������� ��������� ������� ��������� �����
  playerMainHero.stats_for_skills[statId] = playerMainHero.stats_for_skills[statId] + count;

  -- ��������� ����� ��
  refreshMainHeroStats(playerId);
end;

-- ������� ����� �������
function buyStat(strPlayerId, strStatId)
  print "buyStat"

  local playerId = strPlayerId + 0;
  local statId = strStatId + 0;
  
  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  
  playerMainHeroProps.buy_stats[statId] = playerMainHeroProps.buy_stats[statId] + 1;
  playerMainHeroProps.count_buy_stats = playerMainHeroProps.count_buy_stats + 1;

  SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) - 2500));

  -- ��������� ����� ��
  refreshMainHeroStats(playerId);

  ShowFlyingSign(MAP_STAT_ON_ADDING_MESSAGE[statId], playerMainHeroProps.name, playerId, 5.0);
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


-- ��������� ���������� ������� 1 ������ �� ����� ����������� ������
function getFirstUnitCountInTown(playerId)
  print "getFirstUnitCountInTown"
  
  return GetObjectDwellingCreatures(MAP_PLAYER_TO_TOWNNAME[playerId], 1);
end;

-- ������������ ����� �������
function specEllainaTread(heroName)
  print "specEllainaTread"

  playerId = GetObjectOwner(heroName);
  
  countFirstUnitInTown = getFirstUnitCountInTown(playerId);
  
  while countFirstUnitInTown > 0 do
    currentFirstUnitCountInTown = getFirstUnitCountInTown(playerId);

    if countFirstUnitInTown > currentFirstUnitCountInTown then
      currentDiscount = ELLAINA_DISCOUNT * (countFirstUnitInTown - currentFirstUnitCountInTown);
    
      SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) + currentDiscount);
      ShowFlyingSign({ PATH_TO_START_LEARNING_MESSAGES.."n_goldback.txt"; eq = currentDiscount }, heroName, playerId, 5);

      countFirstUnitInTown = currentFirstUnitCountInTown;
    end;

    sleep(10);
  end;
end;

-- ������������ ����� ����
function specIngaTread(heroName)
  print "specIngaTread"

  local playerId = GetObjectOwner(heroName);

  while GetDate(DAY) < 6 do
    local ingaLevel = GetHeroLevel(heroName);
    local countFreeRune = ingaLevel / LVL_FOR_TEACH_RUNE - mod(ingaLevel, LVL_FOR_TEACH_RUNE);
    local countNeedTeachRune = countFreeRune - length(PLAYERS_GENERATED_SPELLS[playerId].ingaRunes);

    if countNeedTeachRune > 0 then
      local allowRuneLevel = MAP_RUNELORE_TO_ALLOW_RUNE_LEVELS[GetHeroSkillMastery(heroName, HERO_SKILL_RUNELORE)]
      local canTeachRunesTable = {};

      -- ��������� ������ ��������� ��� �������� ���
      for _, runeData in SPELLS[TYPE_MAGICS.RUNES] do
        if allowRuneLevel >= runeData.level then
          local heroKnowThisRune = nil;

          for _, heroRuneId in PLAYERS_GENERATED_SPELLS[playerId].ingaRunes do
            if heroRuneId == runeData.id then
              heroKnowThisRune = 1;
            end;
          end;

          for _, heroRuneId in PLAYERS_GENERATED_SPELLS[playerId].runes do
            if heroRuneId == runeData.id then
              heroKnowThisRune = 1;
            end;
          end;

          if not heroKnowThisRune then
            canTeachRunesTable[length(canTeachRunesTable) + 1] = runeData.id
          end;
        end
      end;

      -- ��������� �������� ������ ��� ��� ��������
      local teachRuneTable = {};

      for indexTeachRune = 1, countNeedTeachRune do
        local isAddedRune;
        local randomIndex;

        repeat
          isAddedRune = nil;
          randomIndex = random(length(canTeachRunesTable)) + 1;

          for _, addedRune in teachRuneTable do
            if addedRune == canTeachRunesTable[randomIndex] then
              isAddedRune = not nil;
            end;
          end;
        until not isAddedRune

        teachRuneTable[length(teachRuneTable) + 1] = canTeachRunesTable[randomIndex];
      end;

      -- ������� ����� ����� �����
      for _, newRuneId in teachRuneTable do
        local ingaRunes = PLAYERS_GENERATED_SPELLS[playerId].ingaRunes;

        ingaRunes[length(ingaRunes)] = newRuneId;
        TeachHeroSpell(heroName, newRuneId);
      end;
    end;

    sleep(10);
  end;
end;

-- ������ ������ ��������������� ����� � ��������������� ����������
function givePlayerSecondTown(playerId)
  print "givePlayerSecondTown"

  local dwellId = MAP_PLAYERS_ON_DWELL_NAME[playerId];
  local dwellPosition = MAP_PLAYERS_ON_DWELL_POSITION[playerId];
  
  if GetObjectOwner(dwellId) ~= playerId then
    SetObjectOwner(dwellId, playerId);
    SetObjectDwellingCreatures(dwellId, CREATURE_MUMMY, 0);
    SetObjectDwellingCreatures(dwellId, CREATURE_DEATH_KNIGHT, 0);
    MoveCameraForPlayers(playerId, dwellPosition.x, dwellPosition.y, GROUND, 40, 0, dwellPosition.rotate, 0, 0, 1);
  end;
end;

-- ������������ ����� ��������
function specNikolasTread(heroName)
  print "specNikolasTread"

  local playerId = GetObjectOwner(heroName);

  local countAllowMummy = 40;
  local dwellId = MAP_PLAYERS_ON_DWELL_NAME[playerId];
  
  givePlayerSecondTown(playerId);
  SetObjectDwellingCreatures(dwellId, CREATURE_MUMMY, countAllowMummy);

  -- ���� ������ ����� - �������� �� ����� ������
  local countBuyMummy = 0;

  while countBuyMummy < countAllowMummy and GetDate(DAY) == 3 do
    local currentCountBuyMummy = GetObjectCreatures(dwellId, CREATURE_MUMMY);
    
    if currentCountBuyMummy > 0 then
      AddObjectCreatures(heroName, CREATURE_MUMMY, currentCountBuyMummy);
      RemoveObjectCreatures(dwellId, CREATURE_MUMMY, currentCountBuyMummy);
      countBuyMummy = countBuyMummy + currentCountBuyMummy;
    end;

    sleep(10);
  end;
end;

-- ������������ ����� ����
function specVegeyrTread(heroName)
  print "specVegeyrTread"

  local isSpecUsed = nil;

  while not isSpecUsed do
    if GetDate(DAY) == 5 then
      if KnowHeroSpell(heroName, SPELL_LIGHTNING_BOLT) then
        TeachHeroSpell(heroName, SPELL_EMPOWERED_LIGHTNING_BOLT);
      end;
      if KnowHeroSpell(heroName, SPELL_CHAIN_LIGHTNING) then
        TeachHeroSpell(heroName, SPELL_EMPOWERED_CHAIN_LIGHTNING);
      end;
    
      isSpecUsed = not nil;
    end;
    
    sleep(10);
  end;
end;

-- ������������ ����� �������
function specValeriaTread(heroName)
  print "specValeriaTread"
  
  local isSpecUsed = nil;

  local MAP_SPELLS_ON_MASS_SPELLS = {
    [SPELL_CURSE] = SPELL_MASS_CURSE,
    [SPELL_SLOW] = SPELL_MASS_SLOW,
    [SPELL_DISRUPTING_RAY] = SPELL_MASS_DISRUPTING_RAY,
    [SPELL_PLAGUE] = SPELL_MASS_PLAGUE,
    [SPELL_WEAKNESS] = SPELL_MASS_WEAKNESS,
    [SPELL_FORGETFULNESS] = SPELL_MASS_FORGETFULNESS,
  };

  while not isSpecUsed do
    if GetDate(DAY) == 5 then
      for spellId, massSpellId in MAP_SPELLS_ON_MASS_SPELLS do
        if KnowHeroSpell(heroName, spellId) then
          TeachHeroSpell(heroName, massSpellId);
        end;
      end;
      
      isSpecUsed = not nil;
    end;

    sleep(10);
  end;
end;

-- �������� ����� �� ������� ���������� ������������� � �� ������
function checkAndRunHeroSpec(heroName)
  print "checkAndRunHeroSpec"
  
  local dictHeroName = getDictionaryHeroName(heroName);

  -- ���� ���������� ����� - ��������� ��
  if dictHeroName == HEROES.NATHANIEL then
    startThread(specEllainaTread, heroName);
  end;

  if dictHeroName == HEROES.UNA then
    startThread(specIngaTread, heroName);
  end;

  if dictHeroName == HEROES.NIKOLAS then
    startThread(specNikolasTread, heroName);
  end;

  if dictHeroName == HEROES.VEGEYR then
    startThread(specVegeyrTread, heroName);
  end;

  if dictHeroName == HEROES.RED_HEAVEN_HERO then
    startThread(specValeriaTread, heroName);
  end;
  
  if dictHeroName == HEROES.ALMEGIR then
    startThread(darkRitualTread, heroName);
  end;
end;

-- ����������� ����� � ��������� ��������� ��� ���� ������������
function infitityMoveTread(heroName)
  print "infitityMoveTread"
  
  while not nil do
    if GetHeroStat(heroName, STAT_MOVE_POINTS) < 30000 then
      addHeroMovePoints(heroName);
    end;
    
    sleep(20);
  end;
end;

-- ����������� ����������� �� ��������� ������ ���������
function startLogisticCompensation(heroName)
  print "startLogisticCompensation"
  
  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  
  local newValue = GetPlayerResource(playerId, GOLD) + GetHeroSkillMastery(heroName, SKILL_LOGISTICS) * LOGISTIC_BONUS;
  
  SetPlayerResource(playerId, GOLD, newValue);
end;

-- ��������� ������� ����������� �����
function learning(strPlayerId, heroName, stage)
  print "learning"

  local playerId = strPlayerId + 0;

  -- ������ ���������� ��������
  if stage == '1' then
     PLAYERS_MAIN_HERO_PROPS[playerId].name = heroName;
     setControlStatsTriggerOnHero(playerId);
     
     -- ���� ��� ������ �������� - ������������ � ������ ��������
     local enemyPlayerId = PLAYERS_OPPONENT[playerId];
     
     if PLAYER_SCOUTING_WAITING_STATUS[enemyPlayerId] ~= nil then
       MessageBoxForPlayers(enemyPlayerId, PATH_TO_START_LEARNING_MESSAGES.."opponent_start_learning.txt" );
       
       scouting(enemyPlayerId);
     end;

     startThread(infitityMoveTread, heroName);
     
     checkAndRunHeroSpec(heroName);
     
     startLogisticCompensation(heroName);
     
     -- ���������
     if HasHeroSkill(heroName, PERK_NAVIGATION) then
       setNavigationTriggers(heroName);
     end;

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

    SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) - needGold);
    
    -- �� �������� ��������� ��� ������
    if playerMainHeroName == HEROES.ELLESHAR then
      SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) + ELLESHAR_DISCOUNT);
    end;
  end;
end;

-- ����������� ���� ���������� �� �� ��������� ���������
function moveAllMainHeroArtsToStorage(playerId)
  print "moveAllMainHeroArtsToStorage"

  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  for _, art in ALL_ARTS_LIST do
    if HasArtefact(mainHeroProps.name, art.id) then
      mainHeroProps.removedHeroArtIdList[length(mainHeroProps.removedHeroArtIdList)] = art.id;
      RemoveArtefact(mainHeroProps.name, art.id);
    end;
  end;
end;

-- ��������� ���� ���������� �� �� ��������� ���������
function getAllMainHeroArtsFromStorage(playerId)
  print "getAllMainHeroArtsFromStorage"

  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- ������ ������ �������
  for _, removedArtId in mainHeroProps.removedHeroArtIdList do
    GiveArtifact(mainHeroProps.name, removedArtId);
  end;
  
  mainHeroProps.removedHeroArtIdList = {};
end;

-- ��������� ��������� �� �������� ��������� ������
function setControlStatsTriggerOnHero(playerId)
  print "setControlStatsTriggerOnHero"
  
  local heroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- ������� � ����� ��� ������
  moveAllMainHeroArtsToStorage(playerId);
  
  -- ��������� ��������� ����� ������ � ��������� ����������
  for _, statId in ALL_MAIN_STATS_LIST do
    PLAYERS_MAIN_HERO_PROPS[playerId].start_stats[statId] = GetHeroStat(heroName, statId);
  end;
  
  -- ������ ������ �������
  getAllMainHeroArtsFromStorage(playerId);
  
  -- ���� � ����� ���� �������, ������ ��� ���������� ����� �� ����
  if HasHeroSkill(heroName, SKILL_LEARNING) then
    local learningLevel = GetHeroSkillMastery(heroName, SKILL_LEARNING);
    
    for level = 1, learningLevel do
      addPlayerMainHeroLearningStats(playerId);
    end;
  end;
  
  -- ���� � ����� ���� ��������� ������, ������������� � ����� ����������
  for skillId, ability in MAP_SKILL_ON_CUSTOM_ABILITY do
    if HasHeroSkill(heroName, skillId) then
      ControlHeroCustomAbility(heroName, ability, CUSTOM_ABILITY_ENABLED);
      Trigger(CUSTOM_ABILITY_TRIGGER, "handleUseCustomAbility");
    end;
  end;

  Trigger(HERO_LEVELUP_TRIGGER, heroName, 'handleHeroLevelUp("'..heroName..'")');
  Trigger(HERO_ADD_SKILL_TRIGGER, heroName, 'handleHeroAddSkill');
  Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'handleHeroRemoveSkill');
end;

-- ������ ������, ������ �� �� �������� ��������� �� ���� ��
function questionDRTakeAttack(strPlayerId)
  local playerId = strPlayerId + 0;

  QuestionBoxForPlayers(
    playerId,
    PATH_TO_START_LEARNING_MESSAGES.."question_get_attack_dark_ritual.txt",
    'darkRitualUpStat("'..playerId..'", "'..STAT_ATTACK..'")',
    'questionDRTakeDefence("'..playerId..'")'
  );
end;

-- ������ ������, ������ �� �� �������� ������ �� ���� ��
function questionDRTakeDefence(strPlayerId)
  local playerId = strPlayerId + 0;

  QuestionBoxForPlayers(
    playerId,
    PATH_TO_START_LEARNING_MESSAGES.."question_get_defence_dark_ritual.txt",
    'darkRitualUpStat("'..playerId..'", "'..STAT_DEFENCE..'")',
    'questionDRTakeSpellPower("'..playerId..'")'
  );
end;

-- ������ ������, ������ �� �� �������� ���������� �� ���� ��
function questionDRTakeSpellPower(strPlayerId)
  local playerId = strPlayerId + 0;

  QuestionBoxForPlayers(
    playerId,
    PATH_TO_START_LEARNING_MESSAGES.."question_get_spell_power_dark_ritual.txt",
    'darkRitualUpStat("'..playerId..'", "'..STAT_SPELL_POWER..'")',
    'questionDRTakeKnowledge("'..playerId..'")'
  );
end;

-- ������ ������, ������ �� �� �������� ������ �� ���� ��
function questionDRTakeKnowledge(strPlayerId)
  local playerId = strPlayerId + 0;

  QuestionBoxForPlayers(
    playerId,
    PATH_TO_START_LEARNING_MESSAGES.."question_get_knowledge_dark_ritual.txt",
    'darkRitualUpStat("'..playerId..'", "'..STAT_KNOWLEDGE..'")',
    'noop'
  );
end;

-- ������������ ��������� ������� �������
function darkRitualTread(heroName)
  print "darkRitualTread"
  
  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  
  while not PLAYERS_USE_DARK_RITUAL_STATUS[playerId] and GetDate(DAY) == 3 do
    if GetHeroStat(heroName, STAT_MANA_POINTS) > 0 then
      questionDRTakeAttack(playerId);
    
      ChangeHeroStat(heroName, STAT_MOVE_POINTS, 30000);
      ChangeHeroStat(heroName, STAT_MANA_POINTS, 0 - GetHeroStat(heroName, STAT_MANA_POINTS));
    end;
    
    sleep(20);
  end;
end;

-- ���������� ��������� ��������� �������� ����� � ������
function safetyRemoveStat(playerId, statId, diff)
  print "safetyRemoveStat"

  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  
  local currentValue = mainHeroProps.start_stats[statId] + mainHeroProps.stats[statId];
  
  -- ���� ���� �������� ������ �����
  if currentValue - diff < MAP_STATS_ON_MINIMUM[statId] then
    return nil;
  end;
  
  -- ���� ������� ������ � ������� - ����� ��
  if mainHeroProps.stats[statId] >= diff then
    mainHeroProps.stats[statId] = mainHeroProps.stats[statId] - diff;
    
    return not nil;
  end;
  
  -- ���� �� ������� - ����� ��� � ���������
  local diffForStartStats = diff - mainHeroProps.stats[statId];
  local diffForStats = diff - diffForStartStats;
  
  if mainHeroProps.stats[statId] > 0 then
    mainHeroProps.stats[statId] = mainHeroProps.stats[statId] - diffForStats;
  end;
  
  if mainHeroProps.start_stats[statId] > 0 then
    mainHeroProps.start_stats[statId] = mainHeroProps.start_stats[statId] - diffForStartStats;
  end;
  
  return not nil;
end;

-- ��������� �������� ��������� ������� ���������
function getCountDarkRitualStat(playerId)
  print "getCountDarkRitualStat"
  
  local mainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  local dictHeroName = getDictionaryHeroName(mainHero);
  
  local defaultCount = 1;
  
  if dictHeroName == HEROES.ALMEGIR then
    return defaultCount * 2;
  end;
  
  return defaultCount;
end;

-- ��������� ���������� � ������� �������
function darkRitualUpStat(strPlayerId, strUpStatId)
  print "darkRitualUpStat"
  
  local playerId = strPlayerId + 0;
  local upStatId = strUpStatId + 0;
  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  local changeStatValue = getCountDarkRitualStat(playerId);

  local resultStatValue = changeStatValue;
  
  for _, statId in ALL_MAIN_STATS_LIST do
    if upStatId ~= statId then
      local success = safetyRemoveStat(playerId, statId, changeStatValue);
      
      if success then
        resultStatValue = resultStatValue + changeStatValue;
      end;
    end;
  end;
  
  mainHeroProps.stats[upStatId] = mainHeroProps.stats[upStatId] + resultStatValue;
  
  refreshMainHeroStats(playerId);
  
  PLAYERS_USE_DARK_RITUAL_STATUS[playerId] = not nil;
end;

-- �������� �����, ����������� � ������ "������ �����"
function removeForestGuardBonusStek(heroName)
  print "removeForestGuardBonusStek"
  
  local COUNT_FOREST_GUARD_BONUS = 10;
  
  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  
  if PLAYERS_GET_FOREST_GUARD_STATUS[playerId] == nil then
    PLAYERS_GET_FOREST_GUARD_STATUS[playerId] = not nil;
    
    if GetHeroCreatures(heroName, CREATURE_BLADE_SINGER) > 0 then
      RemoveHeroCreatures(heroName, CREATURE_BLADE_SINGER, COUNT_FOREST_GUARD_BONUS);
    elseif GetHeroCreatures(heroName, CREATURE_BLADE_JUGGLER) > 0 then
      RemoveHeroCreatures(heroName, CREATURE_BLADE_JUGGLER, COUNT_FOREST_GUARD_BONUS);
    end;
  end;
end;

-- ������ ������ ������ �� ������� ������
function customGiveForestGuardBonusTread(heroName)
  print "customGiveForestGuardBonusTread"

  local countBonus = 10;

  local bonusUsed = nil;

  while not bonusUsed do
    if GetDate(DAY) == 4 and HasHeroSkill(heroName, RANGER_FEAT_FOREST_GUARD_EMBLEM) then
      if (GetHeroCreatures(heroName,  CREATURE_BLADE_SINGER) > 0) then
        AddHeroCreatures(heroName,  CREATURE_BLADE_SINGER, countBonus);
      elseif (GetHeroCreatures(heroName, CREATURE_BLADE_JUGGLER) > 0) then
        AddHeroCreatures(heroName, CREATURE_BLADE_JUGGLER, countBonus);
      end;
      bonusUsed = not nil;
    end;
    
    sleep(20);
  end;
end;

-- ����� "������ �����"
function forestGuard(heroName)
  print "forestGuard"
  
  removeForestGuardBonusStek(heroName);
  startThread(customGiveForestGuardBonusTread, heroName);
end;

-- �������� �����, ����������� � ������ "������ ��� ����"
function removeDefendUsAllBonusStek(heroName)
  print "removeDefendUsAllBonusStek"

  local BONUS_VALUE = 15;

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  if PLAYERS_GET_DEFEND_US_ALL_STATUS[playerId] == nil then
    PLAYERS_GET_DEFEND_US_ALL_STATUS[playerId] = not nil;

    if GetHeroCreatures(heroName, CREATURE_GOBLIN_DEFILER) > 0 then
      RemoveHeroCreatures(heroName, CREATURE_GOBLIN_DEFILER, BONUS_VALUE);
    elseif GetHeroCreatures(heroName, CREATURE_GOBLIN) > 0 then
      RemoveHeroCreatures(heroName, CREATURE_GOBLIN, BONUS_VALUE);
    end;
  end;
end;

-- ������ ������ ������ �� "������ ��� ����"
function customGiveDefendUsAllBonusTread(heroName)
  print "customGiveDefendUsAllBonusTread"

  local BONUS_VALUE = 15;

  local bonusUsed = nil;

  while not bonusUsed do
    if GetDate(DAY) == 4 and HasHeroSkill(heroName, HERO_SKILL_DEFEND_US_ALL) then
      if (GetHeroCreatures(heroName,  CREATURE_GOBLIN_DEFILER) > 0) then
        AddHeroCreatures(heroName,  CREATURE_GOBLIN_DEFILER, BONUS_VALUE);
      elseif (GetHeroCreatures(heroName, CREATURE_GOBLIN) > 0) then
        AddHeroCreatures(heroName, CREATURE_GOBLIN, BONUS_VALUE);
      end;
      bonusUsed = not nil;
    end;

    sleep(20);
  end;
end;

-- ����� "������ ��� ����"
function defendUsAll(heroName)
  print "defendUsAll"

  removeDefendUsAllBonusStek(heroName);
  startThread(customGiveDefendUsAllBonusTread, heroName);
end;

-- ������������ ����������� �������� ��������� � ��������� �������� �����
function navigationTread(playerId)
  print "navigationTread"

  local hero = playerId == PLAYER_1 and Biara or Djovanni;
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  local used = nil;
  
  while not used do
    if HasHeroSkill(playerMainHero, PERK_NAVIGATION) and GetDate(DAY) == 4 then
      transferAllArts(hero, playerMainHero);
      
      used = not nil;
    end;
  
    sleep(20);
  end;
end;

-- ���������� ������ ��������� �������
function handleTouchNavigationArt(triggerHero)
  print "handleTouchNavigationArt"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local navigationArts = PLAYERS_ON_NAVIGATION_ARTS_TABLE[playerId];

  for _, artName in navigationArts do
    if IsObjectExists(artName) then
      RemoveObject(artName);
    end;
  end;
  
  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  if HasHeroSkill(playerMainHero, PERK_NAVIGATION) then
    transferAllArts(triggerHero, playerMainHero);
    PLAYERS_USE_NAVIGATION_STATUS[playerId] = not nil;
  else
    navigationTread(navigationTread, playerId);
  end;

  local position = PLAYERS_POSITION_AFTER_USE_NAVIGATION[playerId];
  
  SetObjectPosition(triggerHero, position.x, position.y);
end;

-- ���������� ������������� ����� ����� ������� (�.�. �� ���������� ��������� ��� ������ :D)
function handleTouchBoat(heroName)
  print "handleTouchBoat"

  MoveHeroRealTime(heroName, 9, 19);
end;

-- ����� "���������"
function setNavigationTriggers(heroName)
  print "setNavigationTriggers"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local hero = playerId == PLAYER_1 and Biara or Djovanni;
  local position = MAP_POSITION_FOR_NAVIGATION[playerId];
  local navigationArts = PLAYERS_ON_NAVIGATION_ARTS_TABLE[playerId];

  if IsObjectExists(PLAYERS_WALL_CELL_FOR_NAVIGATION[playerId]) then
    RemoveObject(PLAYERS_WALL_CELL_FOR_NAVIGATION[playerId]);
  end;

  Trigger(OBJECT_TOUCH_TRIGGER, 'boat4', 'handleTouchBoat("'..hero..'")');
  MoveHeroRealTime(hero, position.x, position.y);
  
  for _, artName in navigationArts do
    if IsObjectExists(artName) then
      Trigger(OBJECT_TOUCH_TRIGGER, artName, 'handleTouchNavigationArt');
    end;
  end;
end;

-- ������� ������, ������ ������� ������ �� �����
function heraldOfDeath(heroName)
  print "heraldOfDeath"
  
  local playerId = GetObjectOwner(heroName);

  local countAllowKnightOfDeath = 16;
  local dwellId = MAP_PLAYERS_ON_DWELL_NAME[playerId];
  
  givePlayerSecondTown(playerId);
  
  SetObjectDwellingCreatures(dwellId, CREATURE_DEATH_KNIGHT, countAllowKnightOfDeath);

  -- ���� ������ ������� - �������� �� ����� ������
  local countBuyKnight = 0;

  while countBuyKnight < countAllowKnightOfDeath and GetDate(DAY) == 3 do
    local currentCountBuyKnight = GetObjectCreatures(dwellId, CREATURE_DEATH_KNIGHT);

    if currentCountBuyKnight > 0 then
      AddObjectCreatures(heroName, CREATURE_DEATH_KNIGHT, currentCountBuyKnight);
      RemoveObjectCreatures(dwellId, CREATURE_DEATH_KNIGHT, currentCountBuyKnight);
      countBuyKnight = countBuyKnight + currentCountBuyKnight;
      PLAYERS_USE_HERALD_OF_DEATH_STATUS[playerId] = not nil;
    end;

    sleep(10);
  end;
end;

-- ��������� ���������� ������ ���� �����
function getCountMagicSchool(heroName)
  print "getCountMagicSchool"

  local magicSchoolTable = {
    SKILL_LIGHT_MAGIC,
    SKILL_DARK_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
    SKILL_SUMMONING_MAGIC,
  };
  
  local count = 0;
  
  for _, schoolId in magicSchoolTable do
    if GetHeroSkillMastery(heroName, schoolId) > 0 then
      count = count + 1;
    end;
  end;
  
  return count;
end;

-- ������������ ��������� ��������� � ������ "������ ������������"
function trackingChangeStatsForCasterCertificate(heroName)
  print "trackingChangeStatsForCasterCertificate"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local KOEF = 2;

  while GetDate(DAY) < 5 do
    -- ���� � ������ ������� �����
    if HasHeroSkill(heroName, KNIGHT_FEAT_CASTER_CERTIFICATE) then
      local currentCount = getCountMagicSchool(heroName);
      local currentCountForSkill = KOEF * currentCount;

      if currentCountForSkill ~= PLAYERS_COUNT_STATS_FROM_CASTER_CERTIFICATE[playerId] then
        local diff = currentCountForSkill - PLAYERS_COUNT_STATS_FROM_CASTER_CERTIFICATE[playerId];

        changeMainHeroStatsForSkills(playerId, STAT_KNOWLEDGE, diff);
        PLAYERS_COUNT_STATS_FROM_CASTER_CERTIFICATE[playerId] = currentCountForSkill;
      end
    end;
    
    sleep(20);
  end;
end;

-- ������ ������������
function casterCertificate(heroName)
  print "casterCertificate"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  
  ChangeHeroStat(heroName, STAT_MANA_POINTS, -GetHeroStat(heroName, STAT_MANA_POINTS));
  
  changeMainHeroStatsForSkills(playerId, STAT_KNOWLEDGE, PLAYERS_COUNT_STATS_FROM_CASTER_CERTIFICATE[playerId]);

  startThread(trackingChangeStatsForCasterCertificate, heroName);
end;

-- ������������ ��������� ��������� � ������ "��������� �������"
function trackingChangeStatsForMasterOfSecret(heroName)
  print "trackingChangeStatsForMasterOfSecret"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local KOEF = 2;

  while GetDate(DAY) < 5 do
    -- ���� � ������ ������� �����
    if HasHeroSkill(heroName, DEMON_FEAT_MASTER_OF_SECRETS) then
      local currentCount = getCountMagicSchool(heroName);
      local currentCountForSkill = KOEF * currentCount;

      if currentCountForSkill ~= PLAYERS_COUNT_STATS_FROM_MASTER_OF_SECRET[playerId] then
        local diff = currentCountForSkill - PLAYERS_COUNT_STATS_FROM_MASTER_OF_SECRET[playerId];

        changeMainHeroStatsForSkills(playerId, STAT_SPELL_POWER, diff);
        PLAYERS_COUNT_STATS_FROM_MASTER_OF_SECRET[playerId] = currentCountForSkill;
      end
    end;

    sleep(20);
  end;
end;

-- ��������� �������
function masterOfSecret(heroName)
  print "masterOfSecret"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  changeMainHeroStatsForSkills(playerId, STAT_SPELL_POWER, PLAYERS_COUNT_STATS_FROM_MASTER_OF_SECRET[playerId]);

  startThread(trackingChangeStatsForMasterOfSecret, heroName);
end;

-- ���������� ��������� ������ ������ ������
function handleHeroAddSkill(triggerHero, skillId)
  print "handleHeroAddSkill"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- ���� �� ������ ������� �����, �� ���������� ������� ���������� ��������
  if playerMainHero == nil then
    return nil;
  end;

  local removedSkillId = getRemovedUnremovableSkillId(playerId);

  -- ���������, �� ������ �� ����� ������������� �����
  if removedSkillId ~= nil then
    removeHeroSkill(playerMainHero, skillId);

    GiveHeroSkill(playerMainHero, removedSkillId);

    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) +  2500));

    ShowFlyingSign(PATH_TO_START_LEARNING_MESSAGES.."cannot_remove_skill.txt", playerMainHero, playerId, 5.0);

    return nil;
  end;

  local skillWithStats = MAP_SKILLS_TO_CHANGING_STATS[skillId];

  -- ���� �����, ������ �����
  if skillWithStats ~= nil then
    changeMainHeroStatsForSkills(playerId, skillWithStats.stat, skillWithStats.count);
  end;

  -- ���� ����� �����������
  if skillId == SKILL_LEARNING or skillId == HERO_SKILL_BARBARIAN_LEARNING then
    addPlayerMainHeroLearningStats(playerId);
  end;
  
  -- ���� ������
  if skillId == WIZARD_FEAT_SPOILS_OF_WAR then
    setSpoilsTrigger(playerId);
  end;

  local customAbility = MAP_SKILL_ON_CUSTOM_ABILITY[skillId];

  -- ���� ����� ����������� � ����� ����������
  if customAbility ~= nil then
    ControlHeroCustomAbility(playerMainHero, customAbility, CUSTOM_ABILITY_ENABLED);
    Trigger(CUSTOM_ABILITY_TRIGGER, "handleUseCustomAbility");
  end;
  
  -- ���������
  if skillId == KNIGHT_FEAT_STUDENT_AWARD then
    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) + STUDENT_AWARD_GOLD));
  end;
  
  -- ������ ������
  if skillId == PERK_DARK_RITUAL then
    startThread(darkRitualTread, playerMainHero);
  end;
  
  -- ������������
  if skillId == PERK_EXPERT_TRAINER then
    SetTownBuildingLimitLevel(MAP_PLAYER_TO_TOWNNAME[playerId], TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 1);
  end;
  
  -- ������ �����
  if skillId == RANGER_FEAT_FOREST_GUARD_EMBLEM then
    forestGuard(playerMainHero);
  end;
  
  -- ������ ��� ����
  if skillId == HERO_SKILL_DEFEND_US_ALL then
    defendUsAll(playerMainHero);
  end;
  
  -- ���������
  if skillId == SKILL_LOGISTICS then
    if PLAYERS_COUNT_LOGISTICS_LEVEL_RETURNED[playerId] > 0 then
      PLAYERS_COUNT_LOGISTICS_LEVEL_RETURNED[playerId] = PLAYERS_COUNT_LOGISTICS_LEVEL_RETURNED[playerId] - 1;
    else
      SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) + LOGISTIC_BONUS));
    end;
  end;
  
  -- ���������
  if skillId == PERK_NAVIGATION then
    setNavigationTriggers(playerMainHero);
  end;
  
  -- ������� ������
  if skillId == NECROMANCER_FEAT_HERALD_OF_DEATH then
    if PLAYERS_USE_HERALD_OF_DEATH_STATUS[playerId] == nil then
      startThread(heraldOfDeath, playerMainHero);
    end;
  end;

  -- ������ ������������
  if skillId == KNIGHT_FEAT_CASTER_CERTIFICATE then
    casterCertificate(playerMainHero);
  end;
  
  -- ��������� �������
  if skillId == DEMON_FEAT_MASTER_OF_SECRETS then
    masterOfSecret(playerMainHero);
  end;
end;

-- ���������� ������ ������ ������
function handleHeroRemoveSkill(triggerHero, skill)
  print "handleHeroRemoveSkill"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  mentorCashback(playerId);

  -- ���� �� ������ ������� �����, �� ���������� ������� ���������� ��������
  if mainHeroName == nil then
    return nil;
  end;

  local change = MAP_SKILLS_TO_CHANGING_STATS[skill];
  
  -- ���� ������� �����, ������ �����
  if change ~= nil then
    changeMainHeroStatsForSkills(playerId, change.stat, -change.count)
  end;

  -- ���� �����������
  if skill == SKILL_LEARNING or skill == HERO_SKILL_BARBARIAN_LEARNING then
    removePlayerMainHeroLearningStats(playerId);
  end;

  -- ���� ������
  if skill == WIZARD_FEAT_SPOILS_OF_WAR then
    Trigger(OBJECT_TOUCH_TRIGGER, MAP_MERCHANT_ON_PLAYER[playerId], 'noop');
  end;

  local customAbility = MAP_SKILL_ON_CUSTOM_ABILITY[skill];

  -- ���� ��� �����, ����������� � CUSTOM_ABILITY_2
  if (
    customAbility ~= nil
    and (
      skill == PERK_FORTUNATE_ADVENTURER
      or skill == PERK_ESTATES
      or (skill == PERK_SCOUTING and HasHeroSkill(mainHeroName, RANGER_FEAT_DISGUISE_AND_RECKON) == nil)
      or (skill == RANGER_FEAT_DISGUISE_AND_RECKON and HasHeroSkill(mainHeroName, PERK_SCOUTING) == nil)
    )
  )then
    ControlHeroCustomAbility(triggerHero, customAbility, CUSTOM_ABILITY_DISABLED);
  end;
  
  -- ���������
  if skill == KNIGHT_FEAT_STUDENT_AWARD then
    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) - STUDENT_AWARD_GOLD));
  end;
  
  -- ������������
  if skill == PERK_EXPERT_TRAINER and GetTownBuildingLevel(MAP_PLAYER_TO_TOWNNAME[playerId], TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) < 1 then
    SetTownBuildingLimitLevel(MAP_PLAYER_TO_TOWNNAME[playerId], TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 0);
  end;
  
  -- ���������
  if skill == SKILL_LOGISTICS then
    local resultGold = GetPlayerResource (playerId, GOLD) - LOGISTIC_BONUS;
    
    if resultGold < 0 then
      PLAYERS_LOGISTICS_DEBT[playerId] = PLAYERS_LOGISTICS_DEBT[playerId] + LOGISTIC_BONUS;
    end;
  
    if resultGold >= 0 then
      SetPlayerResource(playerId, GOLD, resultGold);
    end;
  end;
  
  -- ������� ������
  if skill == NECROMANCER_FEAT_HERALD_OF_DEATH then
    if PLAYERS_USE_HERALD_OF_DEATH_STATUS[playerId] == nil then
      local dwellId = MAP_PLAYERS_ON_DWELL_NAME[playerId];
    
      SetObjectDwellingCreatures(dwellId, CREATURE_DEATH_KNIGHT, 0);
    end;
  end;
  
  -- ������ ������������
  if skill == KNIGHT_FEAT_CASTER_CERTIFICATE then
    changeMainHeroStatsForSkills(playerId, STAT_KNOWLEDGE, -PLAYERS_COUNT_STATS_FROM_CASTER_CERTIFICATE[playerId]);
  end;
  
  -- ��������� �������
  if skill == DEMON_FEAT_MASTER_OF_SECRETS then
    changeMainHeroStatsForSkills(playerId, STAT_SPELL_POWER, -PLAYERS_COUNT_STATS_FROM_MASTER_OF_SECRET[playerId]);
  end;
end;

-- ��������� ��������� ��� ��������� �������
function setSpoilsTrigger(playerId)
  print "setSpoilsTrigger"

  Trigger(OBJECT_TOUCH_TRIGGER, MAP_MERCHANT_ON_PLAYER[playerId], 'handleTouchArtifactMerchant');
end;

-- ���������� ������� ����� � ������
function handleTouchArtifactMerchant(triggerHero)
  print "handleTouchArtifactMerchant"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));

  if PLAYERS_USE_SPOILS_STATUS[playerId] ~= nil then
    return nil;
  end;

  QuestionBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."question_use_spoils.txt", 'spoilsOfWar', 'noop');
end;

-- ��������� �������
function spoilsOfWar(strPlayerId)
  print "spoilsOfWar"

  local playerId = strPlayerId + 0;
  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- ��������� ������ ������, ������� ������ � ����� �������� ������
  -- ������ ������� ������
  local havingItemPositionList = {};

  for _, art in ALL_ARTS_LIST do
    if HasArtefact(playerMainHeroProps.name, art.id) then
      local slotIsNotAdded = not nil; -- ��� � �����, ������ �� ���������� true ��� �� ���������� :)

      for _, position in havingItemPositionList do
        if position == art.position then
          slotIsNotAdded = nil;
        end;
      end;

      if slotIsNotAdded then
        havingItemPositionList[length(havingItemPositionList)] = art.position;
      end;
    end;
  end;

  -- �� ������ ������ ������� ������ ��������� ������ ���������� �������� ����� � ��������� �����
  -- ������ ��������� ��� ������ ����������
  local allowedItemIdList = {};

  for _, art in ALL_ARTS_LIST do
    if art.level == ARTS_LEVELS.MAJOR then
      local isAllowedPosition = not nil;

      for _, position in havingItemPositionList do
        if art.position == position then
          isAllowedPosition = nil;
        end;
      end;

      if isAllowedPosition then
        allowedItemIdList[length(allowedItemIdList)] = art.id;
      end;
    end;
  end;

  -- ������ �������� �� ���� ���� ���������� ���
  local randomIndexArt = random(length(allowedItemIdList));

  GiveArtefact(playerMainHeroProps.name, allowedItemIdList[randomIndexArt]);

  -- � ��������� ������ ������ ������������ ������
  PLAYERS_USE_SPOILS_STATUS[playerId] = not nil;
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

-- �������� ������������� �����, ���� �� ��� �������
function getRemovedUnremovableSkillId(playerId)
  print "getRemovedUnremovableSkillId"

  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- ���� ������� ������
  if HasHeroSkill(playerMainHero, WIZARD_FEAT_SPOILS_OF_WAR) == nil and PLAYERS_USE_SPOILS_STATUS[playerId] ~= nil then
    return WIZARD_FEAT_SPOILS_OF_WAR;
  end;

  -- ���� ������� ��������
  if HasHeroSkill(playerMainHero, PERK_SCOUTING) == nil and PLAYER_USE_SCOUTING_STATUS[playerId] ~= nil then
    return PERK_SCOUTING;
  end;
  
  -- ���� ������� ���������� ��������������
  if HasHeroSkill(playerMainHero, RANGER_FEAT_DISGUISE_AND_RECKON) == nil and PLAYER_USE_DISGUISE_STATUS[playerId] ~= nil then
    return RANGER_FEAT_DISGUISE_AND_RECKON;
  end;
  
  -- ���� ������� ����� � ����
  if HasHeroSkill(playerMainHero, PERK_FORTUNATE_ADVENTURER) == nil and PLAYERS_USE_FORTUNARE_ADVENTURE_STATUS[playerId] ~= nil then
    return PERK_FORTUNATE_ADVENTURER;
  end;
  
  -- ���� �����
  if HasHeroSkill(playerMainHero, PERK_ESTATES) == nil and PLAYERS_USE_ESTATES_STATUS[playerId] ~= nil then
    return PERK_ESTATES;
  end;
  
  -- ������ ������
  if HasHeroSkill(playerMainHero, PERK_DARK_RITUAL) == nil and PLAYERS_USE_DARK_RITUAL_STATUS[playerId] ~= nil then
    return PERK_DARK_RITUAL;
  end;
  
  -- ������������
  if (GetTownRace(MAP_PLAYER_TO_TOWNNAME[playerId]) == RACES.HAVEN) then
    if (
      HasHeroSkill(playerMainHero, PERK_EXPERT_TRAINER) == nil
      and GetTownBuildingLevel(MAP_PLAYER_TO_TOWNNAME[playerId], TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) == 1
    ) then
      return PERK_EXPERT_TRAINER;
    end;
  end;
  
  -- ���������
  if PLAYERS_LOGISTICS_DEBT[playerId] > 0 then
    PLAYERS_LOGISTICS_DEBT[playerId] = PLAYERS_LOGISTICS_DEBT[playerId] - LOGISTIC_BONUS;
    PLAYERS_COUNT_LOGISTICS_LEVEL_RETURNED[playerId] = PLAYERS_COUNT_LOGISTICS_LEVEL_RETURNED[playerId] + 1;
  
    return SKILL_LOGISTICS;
  end;
  
  -- ���������
  if HasHeroSkill(playerMainHero, PERK_NAVIGATION) == nil and PLAYERS_USE_NAVIGATION_STATUS[playerId] ~= nil then
    return PERK_NAVIGATION;
  end;
  
  -- ������� ������
  if HasHeroSkill(playerMainHero, NECROMANCER_FEAT_HERALD_OF_DEATH) == nil and PLAYERS_USE_HERALD_OF_DEATH_STATUS[playerId] ~= nil then
    return NECROMANCER_FEAT_HERALD_OF_DEATH;
  end;

  return nil;
end;

-- �������� ������ � �����
-- �� ������������� ��������������, ������� ������� ���� ����� � ���������� � ����������
function removeHeroSkill(heroName, removeSkillId)
  print "removeHeroSkill"

  Trigger(HERO_ADD_SKILL_TRIGGER, heroName, 'noop');
  Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'noop');

  -- ������ ������� ������� ����� { skillId, skillLevel }[]
  local heroSkillIdList = {};

  -- ��� ����� ���� ������ ������ ���� ��������� ������, ������� � ������ �������� ��� ����� �� ����������� ��������� ��� ���������
  for checkSkillId = 1, 215 do
    if HasHeroSkill(heroName, checkSkillId) then
      heroSkillIdList[length(heroSkillIdList)] = {
        skillId = checkSkillId,
        skillLevel = GetHeroSkillMastery(heroName, checkSkillId),
      };
    end;
  end;

  -- ���������� �����, ��������� � �����
  local hasHeroExpirience = TOTAL_EXPERIENCE_BY_LEVEL[GetHeroLevel(heroName)];

  TakeAwayHeroExp(heroName, hasHeroExpirience);
  WarpHeroExp(heroName, hasHeroExpirience);

  -- ���������� 2 ���, ������ ��� ��-�� ��������� ������� �� ���������� �� 2 ������ ��� �������
  TakeAwayHeroExp(heroName, hasHeroExpirience);
  WarpHeroExp(heroName, hasHeroExpirience);

  -- ���������� ��� ������ � ����� ����� ����, ������� �������
  for _, savedSkill in heroSkillIdList do
    local maxSkillLevel = savedSkill.skillLevel;

    if removeSkillId == savedSkill.skillId then
      maxSkillLevel = maxSkillLevel - 1;
    end;

    if maxSkillLevel > 0 then
      for level = 1, savedSkill.skillLevel do
        GiveHeroSkill(heroName, savedSkill.skillId);
      end;
    end;
  end;

  -- ���������� ������� ��������� �������� � �����
  Trigger(HERO_ADD_SKILL_TRIGGER, heroName, 'handleHeroAddSkill');
  Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'handleHeroRemoveSkill');

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  refreshMainHeroStats(playerId);
end;

-- ������� ����� �������
function sellStat(strPlayerId, strStatId)
  print "sellStat"

  local playerId = strPlayerId + 0;
  local statId = strStatId + 0;

  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  
  playerMainHeroProps.stats[statId] = playerMainHeroProps.stats[statId] - 1;
  PLAYER_COUNT_ALLOW_SELL_STATS[playerId] = PLAYER_COUNT_ALLOW_SELL_STATS[playerId] - 1;

  SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) + SELL_STAT_PRICE));

  -- ��������� ����� ��
  refreshMainHeroStats(playerId);

  ShowFlyingSign({PATH_TO_START_LEARNING_MESSAGES.."n_goldback.txt"; eq = SELL_STAT_PRICE}, playerMainHeroProps.name, playerId, 2.0);
end;

-- ���������� �������������� ����� � �������� ��� ������� ����� �����
function handleTouchSellStatObject(strPlayerId, strStatId)
  print "handleTouchSellStatObject"

  local playerId = strPlayerId + 0;
  local statId = strStatId + 0;

  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- ���� ����� ����� ��������� ����� �� ������� ������
  if PLAYER_COUNT_ALLOW_SELL_STATS[playerId] == 0 then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."sell_maximum_stats.txt");

    return nil;
  end;

  -- ���� �������� ��������� ���������� �� ������ ��������
  if playerMainHeroProps.stats[statId] <= MAP_STATS_ON_MINIMUM[statId] then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."sell_maximum_stat.txt");

    return nil;
  end;

  QuestionBoxForPlayers(playerId, MAP_BUY_STAT_ON_QUESTIONS[statId], 'sellStat("'..playerId..'", "'..statId..'")', 'noop');
end;

-- ��������� ��������� �� ������� ������
function setSellStatsTriggers(playerId)
  print "setSellStatsTriggers"

  for _, statId in ALL_MAIN_STATS_LIST do
    local object = BUY_STATS_OBJECTS_NAMES[playerId][statId];

    Trigger(OBJECT_TOUCH_TRIGGER, object.id, 'handleTouchSellStatObject("'..playerId..'", "'..statId..'")');
  end;
end;

-- ������ ������� ������
function activeSellStats(heroName)
  print 'activeSellStats'

  local SELL_STATS_POSITIONS = {
    [PLAYER_1] = { x = 57, y = 75 },
    [PLAYER_2] = { x = 31, y = 7 },
  };
  
  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local position = SELL_STATS_POSITIONS[playerId];

  MoveHeroRealTime(heroName, position.x, position.y);
  ShowFlyingSign({PATH_TO_START_LEARNING_MESSAGES.."sell_stats_info.txt"; eq = PLAYER_COUNT_ALLOW_SELL_STATS[playerId]}, heroName, playerId, 5.0);
  
  setSellStatsTriggers(playerId);
  
  PLAYERS_USE_ESTATES_STATUS[playerId] = not nil;
  PLAYER_ACTIVE_SELL_STATS_STATUS[playerId] = not nil;
end;

-- ������� ��������� �� ������� ��� ������
function revertBuyStatsTriggers(heroName)
  print "revertBuyStatsTriggers"
  
  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  
  for _, statId in ALL_MAIN_STATS_LIST do
    local object = BUY_STATS_OBJECTS_NAMES[playerId][statId];

    Trigger(OBJECT_TOUCH_TRIGGER, object.id, 'handleTouchBuyStatObject("'..playerId..'", "'..statId..'")');
  end;
  
  ShowFlyingSign(PATH_TO_START_LEARNING_MESSAGES.."sell_stats_disable.txt", heroName, playerId, 5.0);
  
  PLAYER_ACTIVE_SELL_STATS_STATUS[playerId] = nil;
end;

-- ���������� ������������� ��������� �����������
function handleUseCustomAbility(triggerHero, ability)
  print "handleUseCustomAbility"
  
  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  
  -- ���� ������������ ������ �������� ��� ����������
  if ability == CUSTOM_ABILITY_2 then
    if HasHeroSkill(triggerHero, PERK_SCOUTING) and PLAYER_USE_SCOUTING_STATUS[playerId] == nil then
      handleUseScouting(playerId)
    end;
    
    if HasHeroSkill(triggerHero, RANGER_FEAT_DISGUISE_AND_RECKON) and PLAYER_USE_DISGUISE_STATUS[playerId] == nil then
      handleUseDisguise(playerId)
    end;
  end;
  
  -- �����
  if ability == CUSTOM_ABILITY_3 then
    if HasHeroSkill(triggerHero, PERK_ESTATES) then
      -- ���� ������ ���������
      if PLAYERS_USE_ESTATES_STATUS[playerId] == nil then
        activeSellStats(triggerHero);

        return nil;
      end;
      
      -- ���� ����� ����� ��������� �������
      if PLAYER_ACTIVE_SELL_STATS_STATUS[playerId] == not nil then
        revertBuyStatsTriggers(triggerHero);

        return nil;
      end;
      
      -- ���� ����� ����� ����� �������� �������
      if PLAYER_ACTIVE_SELL_STATS_STATUS[playerId] == nil then
        activeSellStats(triggerHero);

        return nil;
      end;
    end;
  end;
  
  -- ���� ������������ "����� � ����"
  if ability == CUSTOM_ABILITY_4 then
    handleUseFortunareAdventure(playerId);
  end;
end;

-- ��������� ������������� ����������� "��������� ��������������"
function handleUseDisguise(playerId)
  print "handleUseDisguise"

  QuestionBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."question_use_disguise.txt", 'disguise("'..playerId..'")', 'noop');
end;

-- ���������� "��������� ��������������"
function disguise(strPlayerId)
  print "disguise"

  local playerId = strPlayerId + 0;
  
  if playerId == PLAYER_1 then
    OpenCircleFog(41, 23, 0, 5, playerId);
    MoveCameraForPlayers(playerId, 41, 23, 0, 20, 0, 3.14, 0, 0, 1);
  else
    OpenCircleFog(36, 88, 0, 5, playerId);
    MoveCameraForPlayers(playerId, 36, 86, 0, 20, 0, 0, 0, 0, 1);
  end;
  
  PLAYER_USE_DISGUISE_STATUS[playerId] = not nil;
end;

-- ��������� ������������� ����������� ��������
function handleUseScouting(playerId)
  print "handleUseScouting"

  -- ���� �������� ��� ������������
  if PLAYER_SCOUTING_WAITING_STATUS[playerId] ~= nil then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."has_waiting_learning_opponent.txt" );
    
    return nil;
  end;

  QuestionBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."question_use_scouting.txt", 'scouting("'..playerId..'")', 'noop');
end;

-- ���������� ������ ������ �� ������ ���������
function moveCameraOnEnemyHero(playerId)
  print "moveCameraOnEnemyHero"

  -- ���� ���� ��� ������ ������������)
  -- �����, ��� ��� ����� ������� ����
  if playerId == PLAYER_1 then
    MoveCameraForPlayers(playerId, 31, 88, 0, 20, 0, 0, 0, 0, 1);
  else
    MoveCameraForPlayers(playerId, 44, 23, 0, 20, 0, 3.14, 0, 0, 1);
  end;
end;

-- ��������� ��������
function scouting(strPlayerId)
  print "scouting"
  
  local playerId = strPlayerId + 0;
  local enemyPlayerId = PLAYERS_OPPONENT[playerId];
  local enemyMainHero = PLAYERS_MAIN_HERO_PROPS[enemyPlayerId].name;
  local enemyHeroes = RESULT_HERO_LIST[enemyPlayerId].heroes;
  local enemyChoisedHeroes = RESULT_HERO_LIST[enemyPlayerId].choised_heroes;

  PLAYER_USE_SCOUTING_STATUS[playerId] = not nil;

  -- ���� �������� ��� �� ����� ��������
  if enemyMainHero == nil then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."opponent_has_not_main_hero.txt" );
    
    -- ���������� ��� ������, ������� ������ ���������
    for _, heroName in enemyChoisedHeroes do
      if heroName ~= enemyHeroes[1] and heroName ~= enemyHeroes[2] then
        local iconName = getHeroIconByHeroName(enemyPlayerId, heroName);

        SetObjectPosition(iconName, 1, 1, UNDERGROUND);
      end;
    end;
    
    moveCameraOnEnemyHero(playerId);
    
    PLAYER_SCOUTING_WAITING_STATUS[playerId] = not nil;
    return nil;
  end;
  
  -- ���� ����� �� �������
  if enemyMainHero == enemyHeroes[3] then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."opponent_buy_hero.txt");

    return nil;
  end;
  
  -- ���������� �� �����
  for _, heroName in enemyChoisedHeroes do
    if heroName ~= enemyMainHero then
      local iconName = getHeroIconByHeroName(enemyPlayerId, heroName);
    
      SetObjectPosition(iconName, 1, 1, UNDERGROUND);
    end;
  end;
  
  moveCameraOnEnemyHero(playerId);
end;


-- ���������� ������������� "����� � ����" � ����� ����������
function handleUseFortunareAdventure(playerId)
  print "handleUseFortunareAdventure"

  -- ���� ����� ��� �� ����������� ���� ����� - ������������� ��� � ������������
  if PLAYERS_USE_FORTUNARE_ADVENTURE_STATUS[playerId] == nil then
    QuestionBoxForPlayers(
      playerId,
      PATH_TO_START_LEARNING_MESSAGES.."question_use_fortunare_adventure.txt",
      'fortunareAdventure("'..playerId..'")',
      'noop'
    );

    return nil;
  end;

  fortunareAdventure(playerId);
end;

-- ��������� ����� � ����
function fortunareAdventure(strPlayerId)
  print "fortunareAdventure"

  local playerId = strPlayerId + 0;
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  -- ����������� �������������� ����� � �������
  local MAP_ADDITIONAL_MERCHANT_ON_PLAYERS = {
    [PLAYER_1] = 'FortunateAdventure1',
    [PLAYER_2] = 'FortunateAdventure2',
  };

  PLAYERS_USE_FORTUNARE_ADVENTURE_STATUS[playerId] = not nil;

  moveAllMainHeroArtsToStorage(playerId);

  MakeHeroInteractWithObject(playerMainHero, MAP_ADDITIONAL_MERCHANT_ON_PLAYERS[playerId]);

  -- ��� �������� ���������� ������ ����� ������ ����� ������
  MessageBoxForPlayers(
    playerId,
    PATH_TO_START_LEARNING_MESSAGES.."fortunare_adventure_have_discount.txt",
    'applyFortunareAdventureDiscount'
  );
end;

-- ���������� ������ ��� ���������� � ����� � ����
function applyFortunareAdventureDiscount(strPlayerId)
  print "applyFortunareAdventureDiscount"

  local playerId = strPlayerId + 0;
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  local discountCoefficient = 0.2;
  local discount = 0;

  for _, art in ALL_ARTS_LIST do
    if HasArtefact(playerMainHero, art.id) then
      discount = discount + (art.price * discountCoefficient);
    end;
  end;

  ShowFlyingSign({PATH_TO_START_LEARNING_MESSAGES.."n_goldback.txt"; eq = discount}, playerMainHero, playerId, 5);
  SetPlayerResource(playerId, GOLD, GetPlayerResource(playerId, GOLD) + discount);

  getAllMainHeroArtsFromStorage(playerId);
end;

-- ��������� �������� ����� ������ ������ �����������
function removePlayerMainHeroLearningStats(playerId)
  print "removePlayerMainHeroLearningStats"

  local learning = PLAYERS_MAIN_HERO_PROPS[playerId].learning;
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  local currentLearningLevel = PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level;

  PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level = currentLearningLevel - 1;

  refreshMainHeroStats(playerId);
end;

-- ��������� �������� ����� ������ ������ �����������
function addPlayerMainHeroLearningStats(playerId)
  print "addPlayerMainHeroLearningStats"

  local learning = PLAYERS_MAIN_HERO_PROPS[playerId].learning;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  
  local nextLerningLevel = PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level + 1;
  
  if learning[nextLerningLevel] == nil then
    learning[nextLerningLevel] = {};
    
    -- ��������� ���� ������� ������� �������� ����������, ����� �������� ������� � ����������� � �������
    for _, statId in ALL_MAIN_STATS_LIST do
      learning[nextLerningLevel][statId] = 0;
    end;
    
    -- ���������� 3 ��������� ����� ��� ����� ������ �������
    for indexStat = 1, 3 do
      local randomGenerateStatId = getRandomStatByRace(raceId);

      learning[nextLerningLevel][randomGenerateStatId] = learning[nextLerningLevel][randomGenerateStatId] + 1;
    end;
  end;
  
  PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level = nextLerningLevel;
  
  refreshMainHeroStats(playerId);
end;

-- ���������� ��������� ������ ������ ������
function handleHeroLevelUp(triggerHero)
  print "handleHeroLevelUp"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;
  
  -- �� �������� ���������������� �����
  local randomGenerateStatId = getRandomStatByRace(playerRaceId);
  
  changeMainHeroMainStat(playerId, randomGenerateStatId);
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

start_learning_script();
