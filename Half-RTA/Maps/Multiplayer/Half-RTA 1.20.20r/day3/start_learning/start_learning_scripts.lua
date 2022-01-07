
PATH_TO_START_LEARNING_MODULE = PATH_TO_DAY3_SCRIPTS.."start_learning/";
PATH_TO_START_LEARNING_MESSAGES = PATH_TO_START_LEARNING_MODULE.."messages/";

doFile(PATH_TO_START_LEARNING_MODULE..'start_learning_constants.lua');
sleep(1);

-- Скрипты для обработки прокачки героя
function start_learning_script()
  print "start_learning_script"
  
  setLearningTriggers();
  setMentorTriggers();
  setBuySkillTriggers();
  setBuyStatsTriggers();
  setReGenerationStatTriggers();
end;

-- Установка триггеров на покупку дополнительных статов
function setReGenerationStatTriggers()
  print "setReGenerationStatTriggers"
  
  -- Маппинг объектов для перегенерации статистик на игроков
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

-- Обработка касания героем объекта для перегенерации статов
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

-- Перегенерация статов у главного героя игрока
function reGenerationStats(strPlayerId)
  print "reGenerationStats"

  local playerId = strPlayerId + 0;
  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;

  -- Считаем количество статистик, полученных за уровни
  local countHeroMainStats = 0;
  
  for _, statId in ALL_MAIN_STATS_LIST do
    countHeroMainStats = countHeroMainStats + mainHeroProps.stats[statId];
  end;
  
  -- Зануляем статы за уровни
  for _, statId in ALL_MAIN_STATS_LIST do
    mainHeroProps.stats[statId] = 0;
  end;
  
  -- Генерируем их заново :)
  for indexStat = 1, countHeroMainStats do
    local randomGenerateStatId = getRandomStatByRace(playerRaceId);

    changeMainHeroMainStat(playerId, randomGenerateStatId);
  end;
  
  local mainHeroX, mainHeroY = GetObjectPosition(mainHeroProps.name);
  Play2DSoundForPlayers(playerId, "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", mainHeroX, mainHeroY, 0);

  -- Снимаем бабки за диджейство
  SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) - COST_RE_GENERATION_STATS));
end;

-- Установка триггеров на покупку дополнительных статов
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

-- Обработчик взаимодействия героя с объектом для покупки стата
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

-- Обновление игровых статистик главного героя на основе скриптовых
function refreshMainHeroStats(playerId)
  print "refreshMainHeroStats"

  -- Снимаем с героя все шмотки
  moveAllMainHeroArtsToStorage(playerId);
  
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId];

  for _, statId in ALL_MAIN_STATS_LIST do
    local changeStatValue = playerMainHero.stats[statId]
      + playerMainHero.start_stats[statId]
      + playerMainHero.stats_for_skills[statId]
      + playerMainHero.buy_stats[statId]
      - GetHeroStat(playerMainHero.name, statId);

    -- Если есть образло, считываем статы за все уровни образла
    if playerMainHero.current_learning_level > 0 then
      for learningLevel = 1, playerMainHero.current_learning_level do
        changeStatValue = changeStatValue + playerMainHero.learning[learningLevel][statId]
      end;
    end;
    
    -- Добавляем костыльно статы с образла при рефреше
    -- Заброшенные шахты и СА мага были переделаны под астрологию
    if HasHeroSkill(playerMainHero.name, NECROMANCER_FEAT_HAUNT_MINE) or HasHeroSkill(playerMainHero.name, WIZARD_FEAT_ABSOLUTE_WIZARDY) then
      changeStatValue = changeStatValue + MAP_WEEK_ON_ASTROLOGY_STATS[GetCurrentMoonWeek()][statId]
    end;

    ChangeHeroStat(playerMainHero.name, statId, changeStatValue);
  end;

  -- Отдаем шмотки обратно
  getAllMainHeroArtsFromStorage(playerId);
end;

-- Увеличение значение переданного стата у главного героя игрока
function changeMainHeroMainStat(playerId, statId, count)
  print "changeMainHeroMainStat"

  if count == nil then
    count = 1;
  end;

  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- Меняем скриптовое состояние главных статистик героя
  playerMainHero.stats[statId] = playerMainHero.stats[statId] + count;

  -- Обновляем статы ГГ
  refreshMainHeroStats(playerId);
end;

-- Изменение у ГГ статов, полученных за навыки
function changeMainHeroStatsForSkills(playerId, statId, count)
  print "changeMainHeroStatsForSkills"

  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- Меняем скриптовое состояние главных статистик героя
  playerMainHero.stats_for_skills[statId] = playerMainHero.stats_for_skills[statId] + count;

  -- Обновляем статы ГГ
  refreshMainHeroStats(playerId);
end;

-- Покупка стата игроком
function buyStat(strPlayerId, strStatId)
  print "buyStat"

  local playerId = strPlayerId + 0;
  local statId = strStatId + 0;
  
  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];
  
  playerMainHeroProps.buy_stats[statId] = playerMainHeroProps.buy_stats[statId] + 1;
  playerMainHeroProps.count_buy_stats = playerMainHeroProps.count_buy_stats + 1;

  SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) - 2500));

  -- Обновляем статы ГГ
  refreshMainHeroStats(playerId);

  ShowFlyingSign(MAP_STAT_ON_ADDING_MESSAGE[statId], playerMainHeroProps.name, playerId, 5.0);
end;

-- Установка триггеров на покупку базы
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

-- Получение текущей стоимости покупки навыка
function getPriceBuySkill(playerId)
  print "getPriceBuySkill"

  local playerMainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  -- на старте прокачки
  if playerMainHeroName == nil then
    return 8000;
  end;
  
  -- если герой уже прокачан
  return 5000;
end;

-- Возвращает статус, что герой уже имеет максимум навыков
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

-- Обработчик взаимодействия с алтарем для покупки базы
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

-- Вопрос на покупку уровня
function questionBuySkill(heroName, priceStr, skillIndexStr)
  print "questionBuySkill"
  
  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  
  -- Приведение приходящей строки к числу
  local price = priceStr + 0;
  local skillIndex = skillIndexStr + 0;
  
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;
  
  -- Если предложили уже все варианты
  if skillIndex > length(ALLOW_BUY_SKILL_LIST_BY_RACE[playerRaceId]) then
    return nil;
  end;
  
  local offerSkillId = ALLOW_BUY_SKILL_LIST_BY_RACE[playerRaceId][skillIndex];

  -- Если герой уже имеет данную базу - предлагаем следующую
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

-- Добавляем герою купленный навык
function addHeroOfferSkill(heroName, skillIdStr, priceStr)
  print "addHeroOfferSkill"

  local skillId = skillIdStr + 0;
  local price = priceStr + 0;
  
  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  GiveHeroSkill(heroName, skillIdStr);
  Trigger(OBJECT_TOUCH_TRIGGER, BUY_SKILL_OBJECTS_NAME[playerId], 'noop');
  SetPlayerResource(playerId, GOLD, (GetPlayerResource (playerId, GOLD) - price));
end;

-- Установка триггеров для обучения героя
function setMentorTriggers()
  print "setMentorTriggers"

  for _, playerId in PLAYER_ID_TABLE do
    local heroes = RESULT_HERO_LIST[playerId].heroes;
    
    for _, heroName in heroes do
      Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'handleHeroRemoveSkill');
    end;
  end;
end;

-- Установка триггеров для обучения героя
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

-- Вопрос пользователю о начале прокачки
function questionLearning(triggerHero)
  print "questionLearning"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;
  local question = QUESTION_BY_RACE[playerRaceId];
  
  local playerMainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  -- Предложение начать бесплатное обучение
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

  -- Предложение продолжить бесплатное обучение
  if playerMainHeroLvl == HALF_FREE_LEARNING_LEVEL then
    QuestionBoxForPlayers(
      playerId,
      PATH_TO_START_LEARNING_MESSAGES..'question_continue_learning.txt',
      'learning("'..playerId..'", "'..triggerHero..'", "'..'2'..'")',
      'noop'
    );
    
    return nil;
  end;
  
  -- Если достигнут максимум в прокачке
  if playerMainHeroLvl >= MAXIMUM_AVAILABLE_LEVEL then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES..'hero_already_has_the_maximum_level.txt');

    return nil;
  end;
  
  local needGold = MAP_LEVEL_BY_PRICE[playerMainHeroLvl + 1];
  local currentPlayerGold = GetPlayerResource(playerId, GOLD);

  -- Если недостаточно денег для покупки уровня
  if needGold > currentPlayerGold then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES..'not_enough_money.txt');

    return nil;
  end;
  
  -- Предложение купить дополнительные уровни
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

-- Повышение уровней переданного героя
function learning(strPlayerId, heroName, stage)
  print "learning"

  local playerId = strPlayerId + 0;

  -- Начало бесплатной прокачки
  if stage == '1' then
     PLAYERS_MAIN_HERO_PROPS[playerId].name = heroName;
     setControlStatsTriggerOnHero(playerId);
     
     -- Если опп заюзал разведку - отчитываемся о начале прокачки
     local enemyPlayerId = PLAYERS_OPPONENT[playerId];
     
     if PLAYER_SCOUTING_WAITING_STATUS[enemyPlayerId] ~= nil then
       MessageBoxForPlayers(enemyPlayerId, PATH_TO_START_LEARNING_MESSAGES.."opponent_start_learning.txt" );
       
       scouting(enemyPlayerId);
     end;
     
     ChangeHeroStat(heroName, STAT_EXPERIENCE, TOTAL_EXPERIENCE_BY_LEVEL[HALF_FREE_LEARNING_LEVEL]);
  end;
  
  -- Продолжение бесплатной прокачки
  if stage == '2' then
    local playerMainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    local needExperience = TOTAL_EXPERIENCE_BY_LEVEL[FREE_LEARNING_LEVEL] - TOTAL_EXPERIENCE_BY_LEVEL[HALF_FREE_LEARNING_LEVEL];
    
    ChangeHeroStat(playerMainHeroName, STAT_EXPERIENCE, needExperience);
  end;
  
  -- Покупка дополнительных уровней
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

-- Перемещение всех артефактов ГГ во временное хранилище
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

-- Получение всех артефактов ГГ из временное хранилище
function getAllMainHeroArtsFromStorage(playerId)
  print "getAllMainHeroArtsFromStorage"

  local mainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- Отдаем шмотки обратно
  for _, removedArtId in mainHeroProps.removedHeroArtIdList do
    GiveArtifact(mainHeroProps.name, removedArtId);
  end;
  
  mainHeroProps.removedHeroArtIdList = {};
end;

-- Установка триггеров на контроль статистик героев
function setControlStatsTriggerOnHero(playerId)
  print "setControlStatsTriggerOnHero"
  
  local heroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- Снимаем с героя все шмотки
  moveAllMainHeroArtsToStorage(playerId);
  
  -- Переводим стартовые статы героев в стартовые скриптовые
  for _, statId in ALL_MAIN_STATS_LIST do
    PLAYERS_MAIN_HERO_PROPS[playerId].start_stats[statId] = GetHeroStat(heroName, statId);
  end;
  
  -- Отдаем шмотки обратно
  getAllMainHeroArtsFromStorage(playerId);
  
  -- Если у героя есть образло, выдаем ему положенные статы за него
  if HasHeroSkill(heroName, SKILL_LEARNING) then
    local learningLevel = GetHeroSkillMastery(heroName, SKILL_LEARNING);
    
    for level = 1, learningLevel do
      addPlayerMainHeroLearningStats(playerId);
    end;
  end;

  Trigger(HERO_LEVELUP_TRIGGER, heroName, 'handleHeroLevelUp("'..heroName..'")');
  Trigger(HERO_ADD_SKILL_TRIGGER, heroName, 'handleHeroAddSkill');
  Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'handleHeroRemoveSkill');
end;

-- Обработчик получения героем нового навыка
function handleHeroAddSkill(triggerHero, skillId)
  print "handleHeroAddSkill"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- Если не выбран главный герой, не производим никаких внутренних расчетов
  if playerMainHero == nil then
    return nil;
  end;

  local removedSkillId = getRemovedUnremovableSkillId(playerId);

  -- Проверяем, не скинул ли игрок нескидываемый навык
  if removedSkillId ~= nil then
    removeHeroSkill(playerMainHero, skillId);

    GiveHeroSkill(playerMainHero, removedSkillId);

    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) +  2500));

    ShowFlyingSign(PATH_TO_START_LEARNING_MESSAGES.."cannot_remove_skill.txt", playerMainHero, playerId, 5.0);

    return nil;
  end;

  local skillWithStats = MAP_SKILLS_TO_CHANGING_STATS[skillId];

  -- Если навык, дающий статы
  if skillWithStats ~= nil then
    changeMainHeroStatsForSkills(playerId, skillWithStats.stat, skillWithStats.count);
  end;

  -- если взяли образование
  if skillId == SKILL_LEARNING or skillId == HERO_SKILL_BARBARIAN_LEARNING then
    addPlayerMainHeroLearningStats(playerId);
  end;
  
  -- Если трофеи
  if skillId == WIZARD_FEAT_SPOILS_OF_WAR then
    setSpoilsTrigger(playerId);
  end;

  local customAbility = MAP_SKILL_ON_CUSTOM_ABILITY[skillId];

  -- Если навык добавляется в книгу заклинаний
  if customAbility ~= nil then
    ControlHeroCustomAbility(playerMainHero, customAbility, CUSTOM_ABILITY_ENABLED);
    Trigger(CUSTOM_ABILITY_TRIGGER, "handleUseCustomAbility");
  end;
end;

-- Обработчик потери героем нового навыка
function handleHeroRemoveSkill(triggerHero, skill)
  print "handleHeroRemoveSkill"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  mentorCashback(playerId);

  -- Если не выбран главный герой, не производим никаких внутренних расчетов
  if mainHeroName == nil then
    return nil;
  end;

  local change = MAP_SKILLS_TO_CHANGING_STATS[skill];
  
  -- Если обычный навык, дающий статы
  if change ~= nil then
    changeMainHeroStatsForSkills(playerId, change.stat, -change.count)
  end;

  -- если образование
  if skill == SKILL_LEARNING or skill == HERO_SKILL_BARBARIAN_LEARNING then
    removePlayerMainHeroLearningStats(playerId);
  end;

  -- Если трофеи
  if skill == WIZARD_FEAT_SPOILS_OF_WAR then
    Trigger(OBJECT_TOUCH_TRIGGER, MAP_MERCHANT_ON_PLAYER[playerId], 'noop');
  end;

  local customAbility = MAP_SKILL_ON_CUSTOM_ABILITY[skill];

  -- Если это навык, привязанный к CUSTOM_ABILITY_2
  if (
    customAbility ~= nil
    and (
      (skill == PERK_SCOUTING and HasHeroSkill(mainHeroName, RANGER_FEAT_DISGUISE_AND_RECKON) == nil)
      or (skill == RANGER_FEAT_DISGUISE_AND_RECKON and HasHeroSkill(mainHeroName, PERK_SCOUTING) == nil)
    )
  )then
    ControlHeroCustomAbility(triggerHero, customAbility, CUSTOM_ABILITY_DISABLED);
  end;
end;

-- Установка триггеров для активации Трофеев
function setSpoilsTrigger(playerId)
  print "setSpoilsTrigger"

  Trigger(OBJECT_TOUCH_TRIGGER, MAP_MERCHANT_ON_PLAYER[playerId], 'handleTouchArtifactMerchant');
end;

-- Обработчик касания героя с лавкой
function handleTouchArtifactMerchant(triggerHero)
  print "handleTouchArtifactMerchant"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));

  if PLAYERS_USE_SPOILS_STATUS[playerId] ~= nil then
    return nil;
  end;

  QuestionBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."question_use_spoils.txt", 'spoilsOfWar', 'noop');
end;

-- Активация трофеев
function spoilsOfWar(strPlayerId)
  print "spoilsOfWar"

  local playerId = strPlayerId + 0;
  local playerMainHeroProps = PLAYERS_MAIN_HERO_PROPS[playerId];

  -- Формируем список слотов, которые заняты у героя текущими артами
  -- Список занятых слотов
  local havingItemPositionList = {};

  for _, art in ALL_ARTS_LIST do
    if HasArtefact(playerMainHeroProps.name, art.id) then
      local slotIsNotAdded = not nil; -- Ору с этого, почему то адекватный true тут не существует :)

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

  -- На основе списка занятых слотов формируем список артефактов мажорных артов в доступные слоты
  -- Список возможных для выдачи артефактов
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

  -- Теперь рандомим из этой кучи выдаваемый арт
  local randomIndexArt = random(length(allowedItemIdList));

  GiveArtefact(playerMainHeroProps.name, allowedItemIdList[randomIndexArt]);

  -- И запрещаем игроку больше использовать трофеи
  PLAYERS_USE_SPOILS_STATUS[playerId] = not nil;
end;

-- Возврат ментором средств при сброске навыков
function mentorCashback(playerId)
  print "mentorCashback"
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local currentCountFirstLeveDiscount = PLAYERS_FIRST_LEVEL_DISCOUNT_ON_REMOVE_SKILLS[playerId];
  
  -- Если у игрока не вкачан ни один герой, даем ему 2 сброски по 500 монет
  if mainHeroName == nil then
    -- сброски по умолчанию равны 500
    if currentCountFirstLeveDiscount > 0 then

      PLAYERS_FIRST_LEVEL_DISCOUNT_ON_REMOVE_SKILLS[playerId] = currentCountFirstLeveDiscount - 1;

      return nil;
    end;
    
    -- После окончания дешевых сбросок, устанавливаем обычную цену
    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) -  2000));
    
    return nil;
  end;
  
  local mainHeroLevel = GetHeroLevel(mainHeroName);
  
  -- Если герой наполовину прокачан - отнимаем столько, чтобы суммарно получалось 2500
  if mainHeroLevel == HALF_FREE_LEARNING_LEVEL then
    SetPlayerResource(playerId, GOLD, (GetPlayerResource(playerId, GOLD) -  1000));
    
    return nil;
  end;
end;

-- Получает нескидываемый навык, если он был сброшен
function getRemovedUnremovableSkillId(playerId)
  print "getRemovedUnremovableSkillId"

  local playerMainHero = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- Если сбросил Трофеи
  if HasHeroSkill(playerMainHero, WIZARD_FEAT_SPOILS_OF_WAR) == nil and PLAYERS_USE_SPOILS_STATUS[playerId] ~= nil then
    return WIZARD_FEAT_SPOILS_OF_WAR;
  end;

  -- Если сбросил Разведку
  if HasHeroSkill(playerMainHero, PERK_SCOUTING) == nil and PLAYER_USE_SCOUTING_STATUS[playerId] ~= nil then
    return PERK_SCOUTING;
  end;
  
  -- Если сбросил Бесшумного преследователя
  if HasHeroSkill(playerMainHero, RANGER_FEAT_DISGUISE_AND_RECKON) == nil and PLAYER_USE_DISGUISE_STATUS[playerId] ~= nil then
    return RANGER_FEAT_DISGUISE_AND_RECKON;
  end;

  return nil;
end;

-- Удаление навыка у героя
-- Не предоставлено разработчиками, поэтому херачим свой метод с блекджеком и изабелькой
function removeHeroSkill(heroName, removeSkillId)
  print "removeHeroSkill"

  Trigger(HERO_ADD_SKILL_TRIGGER, heroName, 'noop');
  Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'noop');

  -- Список текущих навыков героя { skillId, skillLevel }[]
  local heroSkillIdList = {};

  -- Мне очень влом делать список всех возможных скилов, поэтому я просто протыкаю все числа до максимально знакомого мне айдишника
  for checkSkillId = 1, 215 do
    if HasHeroSkill(heroName, checkSkillId) then
      heroSkillIdList[length(heroSkillIdList)] = {
        skillId = checkSkillId,
        skillLevel = GetHeroSkillMastery(heroName, checkSkillId),
      };
    end;
  end;

  -- Количество опыта, имеющееся у героя
  local hasHeroExpirience = TOTAL_EXPERIENCE_BY_LEVEL[GetHeroLevel(heroName)];

  TakeAwayHeroExp(heroName, hasHeroExpirience);
  WarpHeroExp(heroName, hasHeroExpirience);

  -- Сбрасываем 2 раз, потому что из-за стартовых навыков их количество на 2 больше чем уровень
  TakeAwayHeroExp(heroName, hasHeroExpirience);
  WarpHeroExp(heroName, hasHeroExpirience);

  -- Возвращаем все навыки и школы кроме того, который удаляем
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

  -- Возвращаем обратно кастомные триггеры и статы
  Trigger(HERO_ADD_SKILL_TRIGGER, heroName, 'handleHeroAddSkill');
  Trigger(HERO_REMOVE_SKILL_TRIGGER, heroName, 'handleHeroRemoveSkill');

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));

  refreshMainHeroStats(playerId);
end;

-- Обработчик использования кастомной способности
function handleUseCustomAbility(triggerHero, ability)
  print "handleUseCustomAbility"
  
  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  
  -- если использовали абилку разведки или бесшумного
  if ability == CUSTOM_ABILITY_2 then
    if HasHeroSkill(triggerHero, PERK_SCOUTING) and PLAYER_USE_SCOUTING_STATUS[playerId] == nil then
      handleUseScouting(playerId)
    end;
    
    if HasHeroSkill(triggerHero, RANGER_FEAT_DISGUISE_AND_RECKON) and PLAYER_USE_DISGUISE_STATUS[playerId] == nil then
      handleUseDisguise(playerId)
    end;
  end;
end;

-- Обработка использования способности "Бесшумный преследователь"
function handleUseDisguise(playerId)
  print "handleUseScouting"

  QuestionBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."question_use_disguise.txt", 'disguise("'..playerId..'")', 'noop');
end;

-- Применение "Бесшумный преследователь"
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

-- Обработка использования способности разведка
function handleUseScouting(playerId)
  print "handleUseScouting"

  -- Если разведка уже использована
  if PLAYER_SCOUTING_WAITING_STATUS[playerId] ~= nil then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."has_waiting_learning_opponent.txt" );
    
    return nil;
  end;

  QuestionBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."question_use_scouting.txt", 'scouting("'..playerId..'")', 'noop');
end;

-- Перемещаем камеру игрока на героев оппонента
function moveCameraOnEnemyHero(playerId)
  print "moveCameraOnEnemyHero"

  -- Ваще влом это делать универсально)
  -- Думаю, что все здесь понятно итак
  if playerId == PLAYER_1 then
    MoveCameraForPlayers(playerId, 31, 88, 0, 20, 0, 0, 0, 0, 1);
  else
    MoveCameraForPlayers(playerId, 44, 23, 0, 20, 0, 3.14, 0, 0, 1);
  end;
end;

-- Активация разведки
function scouting(strPlayerId)
  print "scouting"
  
  local playerId = strPlayerId + 0;
  local enemyPlayerId = PLAYERS_OPPONENT[playerId];
  local enemyMainHero = PLAYERS_MAIN_HERO_PROPS[enemyPlayerId].name;
  local enemyHeroes = RESULT_HERO_LIST[enemyPlayerId].heroes;
  local enemyChoisedHeroes = RESULT_HERO_LIST[enemyPlayerId].choised_heroes;

  PLAYER_USE_SCOUTING_STATUS[playerId] = not nil;

  -- Если оппонент еще не начал прокачку
  if enemyMainHero == nil then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."opponent_has_not_main_hero.txt" );
    
    -- Показываем тех героев, которые выпали оппоненту
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
  
  -- Если герой из таверны
  if enemyMainHero == enemyHeroes[3] then
    MessageBoxForPlayers(playerId, PATH_TO_START_LEARNING_MESSAGES.."opponent_buy_hero.txt");

    return nil;
  end;
  
  -- Показываем ГГ врага
  for _, heroName in enemyChoisedHeroes do
    if heroName ~= enemyMainHero then
      local iconName = getHeroIconByHeroName(enemyPlayerId, heroName);
    
      SetObjectPosition(iconName, 1, 1, UNDERGROUND);
    end;
  end;
  
  moveCameraOnEnemyHero(playerId);
end;

-- Генерация главному герою игрока статов образования
function removePlayerMainHeroLearningStats(playerId)
  print "removePlayerMainHeroLearningStats"

  local learning = PLAYERS_MAIN_HERO_PROPS[playerId].learning;
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  local currentLearningLevel = PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level;

  PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level = currentLearningLevel - 1;

  refreshMainHeroStats(playerId);
end;

-- Генерация главному герою игрока статов образования
function addPlayerMainHeroLearningStats(playerId)
  print "addPlayerMainHeroLearningStats"

  local learning = PLAYERS_MAIN_HERO_PROPS[playerId].learning;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  
  local nextLerningLevel = PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level + 1;
  
  if learning[nextLerningLevel] == nil then
    learning[nextLerningLevel] = {};
    
    -- Заполняем этот уровень образла нулевыми значениями, чтобы измежать проблем с математикой в будущем
    for _, statId in ALL_MAIN_STATS_LIST do
      learning[nextLerningLevel][statId] = 0;
    end;
    
    -- Генерируем 3 случайных стата для этого уровня образла
    for indexStat = 1, 3 do
      local randomGenerateStatId = getRandomStatByRace(raceId);

      learning[nextLerningLevel][randomGenerateStatId] = learning[nextLerningLevel][randomGenerateStatId] + 1;
    end;
  end;
  
  PLAYERS_MAIN_HERO_PROPS[playerId].current_learning_level = nextLerningLevel;
  
  refreshMainHeroStats(playerId);
end;

-- Обработчик получения героем нового уровня
function handleHeroLevelUp(triggerHero)
  print "handleHeroLevelUp"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local playerRaceId = RESULT_HERO_LIST[playerId].raceId;
  
  -- ИД случайно сгенерированного стата
  local randomGenerateStatId = getRandomStatByRace(playerRaceId);
  
  changeMainHeroMainStat(playerId, randomGenerateStatId);
end;

-- Получение случайной статистики героя в соответствии с расовым распределением
function getRandomStatByRace(raceId)
  print "getRandomStatByRace"
  
  local raceDropStatPercent = DROP_STAT_PERCENT_BY_RACE[raceId];

  -- Генерим рандомный процент
  local randomPercent = random(100);

  local maxAttackLimit = raceDropStatPercent.attack;

  -- Стат упал в атаку
  if randomPercent < maxAttackLimit then
    return STAT_ATTACK;
  end;

  local maxDefenceLimit = maxAttackLimit + raceDropStatPercent.defence;

  -- Стат упал в защиту
  if randomPercent < maxDefenceLimit then
    return STAT_DEFENCE;
  end;

  local maxSpellpowerLimit = maxDefenceLimit + raceDropStatPercent.spellpower;

  -- Стат упал в колдовство
  if randomPercent < maxSpellpowerLimit then
    return STAT_SPELL_POWER;
  end;

  local maxKnowledgeLimit = maxSpellpowerLimit + raceDropStatPercent.knowledge;

  -- Стат упал в знание
  if randomPercent < maxKnowledgeLimit then
    return STAT_KNOWLEDGE;
  end;
end;

start_learning_script();
