-- В этом файле описаны скрипты для работы с заклинаниями

PATH_TO_SPELL_GENERATE_MODULE = GetMapDataPath().."day3/spells_generate/";
PATH_TO_SPELLS_NAMES = PATH_TO_SPELL_GENERATE_MODULE.."spells_names/";
PATH_TO_SPELLS_GENERATE_MESSAGES = PATH_TO_SPELL_GENERATE_MODULE.."messages/";

doFile(PATH_TO_SPELL_GENERATE_MODULE.."spells_generate_constants.lua");
sleep(1);

ACADEMY_AVAILABLE_MAGICK_TYPES = { TYPE_MAGICS.LIGHT, TYPE_MAGICS.DARK, TYPE_MAGICS.DESTRUCTIVE };

-- Генерим случайную школу для Мага
function getRandomAcademyMagicType()
  local randomValue = random(3) + 1;

  return ACADEMY_AVAILABLE_MAGICK_TYPES[randomValue];
end;

-- Рандомные школы мага для обоих игроков
PLAYERS_MAGE_TYPES = {
  [PLAYER_1] = getRandomAcademyMagicType(),
  [PLAYER_2] = getRandomAcademyMagicType(),
};

MAPPPING_RACE_TO_MAGIC = {
  [RACES.HAVEN]            = { TYPE_MAGICS.LIGHT, TYPE_MAGICS.DARK },
  [RACES.INFERNO]          = { TYPE_MAGICS.DARK, TYPE_MAGICS.DESTRUCTIVE },
  [RACES.NECROPOLIS]       = { TYPE_MAGICS.DARK, TYPE_MAGICS.SUMMON },
  [RACES.SYLVAN]           = { TYPE_MAGICS.LIGHT, TYPE_MAGICS.DESTRUCTIVE },
  [RACES.ACADEMY]          = { TYPE_MAGICS.SUMMON },
  [RACES.DUNGEON]          = { TYPE_MAGICS.DESTRUCTIVE, TYPE_MAGICS.SUMMON },
  [RACES.FORTRESS]         = { TYPE_MAGICS.LIGHT, TYPE_MAGICS.DESTRUCTIVE },
  [RACES.STRONGHOLD]       = { TYPE_MAGICS.WARCRIES },
};

-- Генерация случайного набора заклинаний для игрока
function generateRandomSpellSet()
  print "generateRandomSpellSet"
  
  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    
    local playerMagickList = MAPPPING_RACE_TO_MAGIC[raceId];

    if raceId == RACES.ACADEMY then
      playerMagickList[2] = PLAYERS_MAGE_TYPES[playerId];
    end;
    
    -- Генерация заклинаний - стартовых бонусов
    generateStartedBonusSpells(playerId, playerMagickList);
    
    -- Генерация набора заклинаний для игрока
    generateSpellByMagicType(playerId, raceId, playerMagickList);
    
    -- Функционал перегенерации набора заклинаний
    addResetSpellsObject(playerId);
  end;
end;

-- Получение случайного заклинания определенного типа магии, определенного уровня
function getRandomSpell(magicType, spellLevel)
  print "getRandomSpell"
  
  -- Список заклинаний переданного уровня
  local spellsByLevel = {};
  
  -- Заполняем список заклинаниями
  for indexSpell = 1, length(SPELLS[magicType]) do
    local spellData = SPELLS[magicType][indexSpell];

    if spellData.level == spellLevel then
      spellsByLevel[length(spellsByLevel) + 1] = spellData;
    end;
  end;
  
  -- Выбираем случайное заклинание из списка
  local randomSpellIndex = random(length(spellsByLevel)) + 1;

  return spellsByLevel[randomSpellIndex];
end;

-- Получение данных о заклинании по ИД заклинания
function getSpellDataBySpellId(spellId)
  print "getSpellDataBySpellId"

  for magicTypeId = 0, length(SPELLS) - 1 do
    local magicTypeSpells = SPELLS[magicTypeId];
    
    for indexSpell = 1, length(magicTypeSpells) do
      local spellData = magicTypeSpells[indexSpell];
      
      if spellData.id == spellId then
        return spellData;
      end;
    end;
  end;
end;

-- Получение ИД школы магии по ИД заклинанию
function getMagicTypeIdBySpellId(spellId)
  print "getMagicTypeIdBySpellId"

  for magicTypeId = 0, length(SPELLS) - 1 do
    local magicTypeSpells = SPELLS[magicTypeId];

    for indexSpell = 1, length(magicTypeSpells) do
      local spellData = magicTypeSpells[indexSpell];

      if spellData.id == spellId then
        return magicTypeId;
      end;
    end;
  end;
end;

-- Получение количества одинаковых заклинаний в сгенерированном списке
function getCountIdentityGeneratedSpells(playerId, spellSet, spellId)
  print "getCountIdentityGeneratedSpells"
  
  local playerAllSpells = PLAYERS_GENERATED_SPELLS[playerId];
  local countIdentitySpell = 0;
  
  -- Проверка в основных сгенерированных заклинаниях
  for _, spell in spellSet do
    if spell.id == spellId then
      countIdentitySpell = countIdentitySpell + 1;
    end;
  end;
  
  -- Проверка в бонусных заклинаниях (выданных стартовым бонусом)
  for _, bonusSpell in playerAllSpells.bonus_spells do
    if bonusSpell.id == spellId then
      countIdentitySpell = countIdentitySpell + 1;
    end;
  end;
  
  return countIdentitySpell;
end

-- Получение количества совпадений с доп заклинаниями
function getCountIdentityAdditionalSpell(spellId)
  print "getCountIdentityAdditionalSpell"

  local countIdentity = 0;

  for _, additionalSpell in ONLY_ADDITIONAL_SPELL_ID_LIST do
    if additionalSpell == spellId then
      countIdentity = countIdentity + 1;
    end;
  end;
  
  return countIdentity;
end;

-- Получение количества одинаковых школ в переданном списке
function getCountIdentityMagicType(magicTypeList, inputMagicType)
  print "getCountIdentityMagicType"
  
  local count = 0;
  
  for _, magicType in magicTypeList do
    if magicType == inputMagicType then
      count = count + 1;
    end;
  end;
  
  return count;
end;

-- Получение случайного типа школы магии, не являющейся основной
function getRandomNotBasicMagicType(magicTypeList)
  print "getRandomNotBasicMagicType"

  local randomMagicType, countIdentityMagicType;

  repeat
    randomMagicType = random(4);
    countIdentityMagicType = getCountIdentityMagicType(magicTypeList, randomMagicType);
  until countIdentityMagicType == 0;
  
  return randomMagicType;
end;

-- Получение случайного заклинания основной линейки
function getRandomUniqueSpellByMagicType(playerId, spellSet, magicType, spellLevel)
  print "getRandomUniqueSpellByMagicType"
  
  local countIdentityGeneratedSpells, randomSpellCurrentLevel;
  
  repeat
    randomSpellCurrentLevel = getRandomSpell(magicType, spellLevel);

    -- Для заклинаний 3 уровня проверяем, чтобы в основную линейку не попали доп заклы
    if spellLevel == 3 then
      local countIdentity = getCountIdentityAdditionalSpell(randomSpellCurrentLevel.id);

      while countIdentity > 0 do
        randomSpellCurrentLevel = getRandomSpell(magicType, spellLevel);
        countIdentity = getCountIdentityAdditionalSpell(randomSpellCurrentLevel.id);
      end;
    end;

    countIdentityGeneratedSpells = getCountIdentityGeneratedSpells(playerId, spellSet, randomSpellCurrentLevel.id);
  until countIdentityGeneratedSpells == 0
  
  return randomSpellCurrentLevel;
end;

-- Получение случайного заклинания, не совпадающего со стартовым или уже имеющимся или nil
function getRandomAvailableSpellByMagicType(playerId, spellSet, magicType, spellLevel)
  print "getRandomAvailableSpellByMagicType"
  
  local availableSpells = {};
  
  for _, spellData in SPELLS[magicType] do
    if spellData.level == spellLevel then
      local hasSpell = nil;
      
      -- Проверка на наличие в стартовых
      for _, bonusSpellData in PLAYERS_GENERATED_SPELLS[playerId].bonus_spells do
        if bonusSpellData.id == spellData.id then
          hasSpell = not nil;
        end;
      end;
      
      -- Проверка на наличие в списке игрока
      for _, playerSpellData in PLAYERS_GENERATED_SPELLS[playerId].spells[1] do
        if playerSpellData.id == spellData.id then
          hasSpell = not nil;
        end;
      end;
      
      -- Проверка на совпадение с дополнительными заклинаниями
      for _, addSpellId in ONLY_ADDITIONAL_SPELL_ID_LIST do
        if addSpellId == spellData.id then
          hasSpell = not nil;
        end;
      end;
      
      if not hasSpell then
        availableSpells[length(availableSpells)] = spellData;
      end;
    end;
  end;
  
  if length(availableSpells) == 0 then
    return nil;
  end;

  return availableSpells[random(length(availableSpells))];
end;

-- Получение заклинания, как стартового бонуса
function getStartedBonusSpell(playerId, magicType)
  print "getStartedBonusSpell"
  
  local bonusSpellLevel = magicType == TYPE_MAGICS.WARCRIES and 1 or random(2) + 1;
  local randomSpell = getRandomSpell(magicType, bonusSpellLevel);

  return randomSpell;
end;

-- Генерация дополнительной линейки заклинаний для Академии Волшебства
function generateAcademyAdditionalSpells(playerId, spellSet, magicTypeList)
  print "generateAcademyAdditionalSpells"

  for levelSpell = 1, 5 do
    local randomNotBasicMagicType = getRandomNotBasicMagicType(magicTypeList);

    spellSet[length(spellSet) + 1] = getRandomUniqueSpellByMagicType(playerId, spellSet, randomNotBasicMagicType, levelSpell);

  end;
end;

-- Генерация дополнительной линейки заклинаний для Лиги Теней
function generateDungeonAdditionalSpells(playerId, spellSet)
  print "generateDungeonAdditionalSpells"

  -- 2 раза генерируем заклинания 4 и 5 уровня случайных школ
  for i = 1, 2 do
    for levelSpell = 4, 5 do
      local randomSpellCurrentLevel, countIdentityGeneratedSpell;

      repeat
        local randomMagicType = random(4);

        randomSpellCurrentLevel = getRandomSpell(randomMagicType, levelSpell);
        countIdentityGeneratedSpell = getCountIdentityGeneratedSpells(playerId, spellSet, randomSpellCurrentLevel.id);
      until countIdentityGeneratedSpell == 0;

      -- Добавление заклинания в список заклинаний героя
      spellSet[length(spellSet) + 1] = randomSpellCurrentLevel;
    end;
  end;
  
  -- Генерация еще одного заклинания 4-5 уровня случайной школы
  local randomSpell, countIdentityGeneratedSpell;

  repeat
    local randomMagicType = random(4);
    local spellLevel = random(2) + 4;

    randomSpell = getRandomSpell(randomMagicType, spellLevel);
    countIdentityGeneratedSpell = getCountIdentityGeneratedSpells(playerId, spellSet, randomSpell.id);
  until countIdentityGeneratedSpell == 0;

  spellSet[length(spellSet) + 1] = randomSpell;
end;

-- Генерация рун для гномов
function generateFortressRunes(playerId)
  print "generateFortressRunes"
  
  local runes = PLAYERS_GENERATED_SPELLS[playerId].runes;

  for indexRuneSet = 1, length(runes) do
    local runeSet = runes[indexRuneSet];
    
    for runeLevel = 1, 5 do
      runeSet[length(runeSet) + 1] = getRandomSpell(TYPE_MAGICS.RUNES, runeLevel);
    end;
  end;
end;

-- Генерация бонусных неизменных заклинаний, если стартовый бонус - закл
function generateStartedBonusSpells(playerId, magicTypeList)
  print "generateStartedBonusSpells"
  
  local startedBonus = getCalculatedStartedBonus(playerId);
  
  if startedBonus == STARTED_BONUSES.SPELL then
    local bonus_spells = PLAYERS_GENERATED_SPELLS[playerId].bonus_spells;

    -- Генерация дополнительного заклинания каждой основной школы
    for _, magicType in magicTypeList do
      local test = getStartedBonusSpell(playerId, magicType);
    
      bonus_spells[length(bonus_spells) + 1] = test;
    end;
    
    -- Выдача стартовых заклов героям
    setHeroesStartedBonusSpells(playerId)
  end;
end;

-- Выдача героям игрока стартовых бонусных заклинаний
function setHeroesStartedBonusSpells(playerId)
  print "setHeroesStartedBonusSpells"
  
  local heroes = RESULT_HERO_LIST[playerId].heroes;
  local bonus_spells = PLAYERS_GENERATED_SPELLS[playerId].bonus_spells;

  for _, heroName in heroes do
    local reservedHeroName = getReservedHeroName(playerId, heroName);
    
    for indexSpell = 1, length(bonus_spells) do
      local bonusSpell = bonus_spells[indexSpell];

      TeachHeroSpell(reservedHeroName, bonusSpell.id);
    end;
  end;
end;

-- Генерация заклинаний по типу школы магии
function generateSpellByMagicType(playerId, raceId, magicTypeList)
  print "generateSpellByMagicType"
  
  local spells = PLAYERS_GENERATED_SPELLS[playerId].spells;
  
  -- Генерируем 2 набора заклинаний
  for indexSpellSet = 1, length(spells) do
    local spellSet = spells[indexSpellSet];

    -- Генерация заклинаний основных школ
    for _, magicType in magicTypeList do
      -- Генерация основной линейки заклинаний
      for spellLevel = 1, 5 do
        if raceId == RACES.STRONGHOLD and spellLevel > 3 then
          break;
        end;

        spellSet[length(spellSet) + 1] = getRandomUniqueSpellByMagicType(playerId, spellSet, magicType, spellLevel);
      end;
    end;
    
    -- Генерация доп заклов для неосновных линеек магий
    if raceId ~= RACES.STRONGHOLD then
      -- Генерация дополнительных заклинаний с 1 по 3 уровней не основных школ магий
      for spellLevel = 1, 3 do
        local randomNotBasicMagicType = getRandomNotBasicMagicType(magicTypeList);

        spellSet[length(spellSet) + 1] = getRandomUniqueSpellByMagicType(playerId, spellSet, randomNotBasicMagicType, spellLevel);
      end;

    end;
    
    -- Генерация дополнительной линейки случайных заклинаний для Академии Волшебства
    if raceId == RACES.ACADEMY then
      generateAcademyAdditionalSpells(playerId, spellSet, magicTypeList);
    end;
    
    -- Генерация дополнительной линейки случайных заклинаний для Лиги Теней
    if raceId == RACES.DUNGEON then
--      generateDungeonAdditionalSpells(playerId, spellSet);
    end;
  end;
  
  -- Генерация рун для гномов
  if raceId == RACES.FORTRESS then
    generateFortressRunes(playerId);
  end;
  
  -- Отображение сгенерированных заклинаний на карте
  showPlayerAllSpellsOnMap(playerId, raceId);
end;

-- Отображение переданных заклинаний на карте
function showSpellListIconsOnMap(playerId, spells, placeSpells)
  print "showSpellListIconsOnMap"
  
  for spellIndex = 1, length(spells) do
    local spellData = spells[spellIndex];
    local spellName = MAPPING_SPELLS_ON_ICONS[spellData.id].text;
    local spellIcon = MAPPING_SPELLS_ON_ICONS[spellData.id].icons[playerId];
    local spellPlace = placeSpells[spellIndex];

    SetObjectPosition(spellIcon, spellPlace.x, spellPlace.y, GROUND);

    -- Отключаем стандартное взаимодействие с текстурой
    SetObjectEnabled(spellIcon, nil);

    -- Меняем название портретов заклинаний
    OverrideObjectTooltipNameAndDescription(spellIcon, PATH_TO_SPELLS_NAMES..spellName, GetMapDataPath().."notext.txt");
  end;
end;

-- Отображение только набора заклинаний/кличей у игрока
function showPlayerSpellList(playerId, raceId)
  print "showPlayerSpellList"

  local spells = getCurrentPlayerSpellSet(playerId);
  local placeSpells = raceId == RACES.STRONGHOLD and PLACE_GENERATED_SPELLS[playerId].WARCRIES or PLACE_GENERATED_SPELLS[playerId].SPELLS;

  showSpellListIconsOnMap(playerId, spells, placeSpells);
end;

-- Отображение только набора рун у игрока
function showPlayerRunesList(playerId)
  print "showPlayerRunesList"

  local runes = getCurrentPlayerRuneSet(playerId);
  local placeRunes = PLACE_GENERATED_SPELLS[playerId].RUNES;

  showSpellListIconsOnMap(playerId, runes, placeRunes);
end;

-- Отображение сгенерированных заклинаний на карте
function showPlayerAllSpellsOnMap(playerId, raceId)
  print "showPlayerAllSpellsOnMap"

  -- Показываем набор заклов/кличей
  showPlayerSpellList(playerId, raceId);
  
  -- также выставляем руны
  if raceId == RACES.FORTRESS then
    showPlayerRunesList(playerId);
  end;
end;

-- Получение текущего набора заклинаний игрока
function getCurrentPlayerSpellSet(playerId)
  print "getCurrentPlayerSpellSet"
  
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
  local tier_spells_reroll = PLAYERS_GENERATED_SPELLS[playerId].tier_spells_reroll;
  local resultSpellList = {};
  
  for indexSpell, spell in PLAYERS_GENERATED_SPELLS[playerId].spells[1] do
    if countResetSpells > 0 and tier_spells_reroll == indexSpell and indexSpell < 11 then

    else
      resultSpellList[indexSpell] = spell;
    end;
  end;
  
  return PLAYERS_GENERATED_SPELLS[playerId].spells[1];
end;

-- Получение текущего набора рун игрока
function getCurrentPlayerRuneSet(playerId)
  print "getCurrentPlayerRuneSet"

  return PLAYERS_GENERATED_SPELLS[playerId].runes[1];
end;

-- Добавление игроками объекта для перегенерации набора заклинаний
function addResetSpellsObject(playerId)
  print "addResetSpellsObject"
  
  local SPELL_RESET_OBJECTS = {
    [PLAYER_1] = { name = "spell_nabor1", x = 35, y = 86 },
    [PLAYER_2] = { name = "spell_nabor2", x = 42, y = 23 },
  }
  
  local object = SPELL_RESET_OBJECTS[playerId];

  SetObjectPosition(object.name, object.x, object.y, GROUND);
  SetObjectEnabled (object.name, nil);
  Trigger(OBJECT_TOUCH_TRIGGER, object.name, 'questionSpellReset');
  OverrideObjectTooltipNameAndDescription (
    object.name,
    PATH_TO_SPELLS_GENERATE_MESSAGES.."altar_of_spells.txt",
    PATH_TO_SPELLS_GENERATE_MESSAGES.."altar_of_spells_description.txt"
  );
end;

-- Вопрос игроку на смену набора заклинаний
function questionSpellReset(triggerHero)
  print "questionSpellReset"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local callbackNo = raceId == RACES.FORTRESS and 'questionRunesReset("'..triggerHero..'")' or 'noop';
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
  local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  
  if countResetSpells > 0 then
    if raceId == RACES.FORTRESS and countResetRunes == 0 then
      questionRunesReset(triggerHero);
      return nil;
    end;
    
    ShowFlyingSign(PATH_TO_SPELLS_GENERATE_MESSAGES..'end_rerrols.txt', triggerHero, playerId, 5);
    return nil;
  end;
  
  QuestionBoxForPlayers(
    playerId,
    PATH_TO_SPELLS_GENERATE_MESSAGES.."question_change_spells.txt",
    'questionSpellLevelReset("'..playerId..'", 1)',
    callbackNo
  );
end;
    
-- Вопрос на смену заклинания текущего уровня
function questionSpellLevelReset(strPlayerId, strSpellLevel)
  print "questionSpellLevelReset"

  local playerId = strPlayerId + 0;
  local spellLevel = strSpellLevel + 0;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local maxSpellLevel = raceId == RACES.STRONGHOLD and 3 or 5;
  local spellResetCost = raceId == RACES.STRONGHOLD and MAPPPING_PRICE_RESET_LEVEL_WARCRIES[spellLevel] or MAPPPING_PRICE_RESET_LEVEL[spellLevel];

  if spellLevel > maxSpellLevel then
    return nil;
  end
  
  local hasChaos = MAPPPING_RACE_TO_MAGIC[raceId][1] == TYPE_MAGICS.DESTRUCTIVE or MAPPPING_RACE_TO_MAGIC[raceId][2] == TYPE_MAGICS.DESTRUCTIVE

  QuestionBoxForPlayers(
    playerId,
    {PATH_TO_SPELLS_GENERATE_MESSAGES.."question_spell_regenerate.txt"; lvl = spellLevel, eq = spellResetCost},
    hasChaos and spellLevel == 5 and 'checkChaosMaxTierSpell("'..playerId..'")' or 'regenerateSpellLevel("'..playerId..'", "'..spellLevel..'")',
    'questionSpellLevelReset("'..playerId..'", "'..(spellLevel + 1)..'")'
  );
end;

--Вопрос на смену заклинаний хаоса 5 уровня
function questionSpellResetChaosMaxTierSpell(strPlayerId, notHasMaxTierChaosSpellList)
  print "questionSpellResetChaosMaxTierSpell"
  
  local playerId = strPlayerId + 0;

  chaosNameSpells = {
  [SPELL_ARMAGEDDON] = PATH_TO_SPELLS_GENERATE_MESSAGES.."ARMAGEDDON.txt",
  [SPELL_IMPLOSION] = PATH_TO_SPELLS_GENERATE_MESSAGES.."IMPLOSION.txt",
  [SPELL_DEEP_FREEZE] = PATH_TO_SPELLS_GENERATE_MESSAGES.."DEEP_FREEZE.txt",
 }
 
  QuestionBoxForPlayers(
    playerId,
    {PATH_TO_SPELLS_GENERATE_MESSAGES.."question_chaos_spell_regenerate.txt"; chaos0 = chaosNameSpells[notHasMaxTierChaosSpellList[0]], chaos1 = chaosNameSpells[notHasMaxTierChaosSpellList[1]]},
    'regenerateSpellLevel("'..playerId..'", "5", "'..notHasMaxTierChaosSpellList[0]..'")',
    'regenerateSpellLevel("'..playerId..'", "5", "'..notHasMaxTierChaosSpellList[1]..'")'
  );

end;

--Проверка тир 5 заклинаний хаоса - какие есть у игрока
function checkChaosMaxTierSpell(strPlayerId)
  print "checkChaosMaxTierSpell"
  local playerId = strPlayerId + 0;
  local maxTierChaosSpellList = {};
  for _,spellData in SPELLS[TYPE_MAGICS.DESTRUCTIVE] do
    if spellData.level == 5 then
      maxTierChaosSpellList[length(maxTierChaosSpellList)] = spellData.id
    end;
  end;
  
  local allPlayerSpells = PLAYERS_GENERATED_SPELLS[playerId].spells[1];
  local hasChaosSpellMaxTier = nil

  for _,spellData in allPlayerSpells do
    local magicTypeId = getMagicTypeIdBySpellId(spellData.id);
    if spellData.level == 5 and magicTypeId == TYPE_MAGICS.DESTRUCTIVE then
      hasChaosSpellMaxTier = spellData.id
    end;
  end;
  
  local notHasMaxTierChaosSpellList = {};
  for _,spellId in maxTierChaosSpellList do
    if spellId ~= hasChaosSpellMaxTier then
      notHasMaxTierChaosSpellList[length(notHasMaxTierChaosSpellList)] = spellId
    end;
  end;
  questionSpellResetChaosMaxTierSpell(playerId, notHasMaxTierChaosSpellList)
end;

--Перегенерация заклинания определенного уровня
function regenerateSpellLevel(strPlayerId, strSpellLevel, strSpellId)
  print "regenerateSpellLevel"

  local playerId = strPlayerId + 0;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local spellLevel = strSpellLevel + 0;
  local playerGold = GetPlayerResource(playerId, GOLD);
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
  local spellResetCost = raceId == RACES.STRONGHOLD and MAPPPING_PRICE_RESET_LEVEL_WARCRIES[spellLevel] or MAPPPING_PRICE_RESET_LEVEL[spellLevel];
  local spellId = strSpellId ~= nil and strSpellId + 0 or nil
  
  -- Дополнительный набор необходимо купить один раз
  if countResetSpells == 0 then
    if spellResetCost > playerGold then
      MessageBoxForPlayers(playerId, {PATH_TO_SPELLS_GENERATE_MESSAGES.."no_money.txt"; eq = spellResetCost - playerGold});
      return nil;
    else
      SetPlayerResource(playerId, GOLD, (playerGold - spellResetCost));
    end;
  end;

  -- Скрываем текущий набор заклинаний
  local spellSet = getCurrentPlayerSpellSet(playerId);
  hideCurrentSpellOrRunesSet(playerId, spellSet);

  PLAYERS_GENERATED_SPELLS[playerId].countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells + 1;
  changeGeneratedSpells(playerId, spellLevel, spellId)

  -- Отображаем новый набор
  showPlayerSpellList(playerId, raceId);
end;

-- Перезапись одного заклинания в данных набора игрока
function changeGeneratedSpells(playerId, spellLevel, spellId)
  print "changeGeneratedSpells"

  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
  for indexSpell, spell in PLAYERS_GENERATED_SPELLS[playerId].spells[1] do
    if countResetSpells > 0 and spell.level == spellLevel and indexSpell < 11 then
      local magicTypeId = getMagicTypeIdBySpellId(spell.id);
      if spellId ~= nil and TYPE_MAGICS.DESTRUCTIVE == magicTypeId and spell.level == 5 then
        PLAYERS_GENERATED_SPELLS[playerId].spells[1][indexSpell] = {level = 5, id = spellId}
      elseif not (TYPE_MAGICS.LIGHT == magicTypeId and spell.level == 5) then
        local newSpell = getRandomAvailableSpellByMagicType(playerId, PLAYERS_GENERATED_SPELLS[playerId].spells[1], magicTypeId, spellLevel);
        
        if newSpell then
          PLAYERS_GENERATED_SPELLS[playerId].spells[1][indexSpell] = newSpell;
        end;
      end;
    end;
  end;
end;


-- Вопрос на смену набора рун
function questionRunesReset(triggerHero)
  print "questionRunesReset"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;

  if countResetSpells > 0 and countResetRunes > 0 then
    ShowFlyingSign(PATH_TO_SPELLS_GENERATE_MESSAGES..'end_rerrols.txt', triggerHero, playerId, 5);
    return nil;
  end;
    
  if countResetRunes > 0 then
    return nil;
  end;

  QuestionBoxForPlayers(
    playerId,
    PATH_TO_SPELLS_GENERATE_MESSAGES.."question_change_runes.txt",
    'questionRuneLevelReset("'..playerId..'", 1)',
    'noop'
  );
end;

-- Вопрос на смену рун
function questionRuneLevelReset(strPlayerId, strSpellLevel)
  print "questionRuneLevelReset"

  local playerId = strPlayerId + 0;
  local spellLevel = strSpellLevel + 0;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local maxSpellLevel = 5;
  local spellResetCost = MAPPPING_PRICE_RESET_LEVEL_RUNES[spellLevel];

  if spellLevel > maxSpellLevel then
    return nil;
  end

  QuestionBoxForPlayers(
    playerId,
    {PATH_TO_SPELLS_GENERATE_MESSAGES.."question_rune_regenerate.txt"; lvl = spellLevel, eq = spellResetCost},
    'changeRunesForPlayer("'..playerId..'", "'..spellLevel..'")',
    'questionRuneLevelReset("'..playerId..'", "'..(spellLevel + 1)..'")'
  );
end;

-- Перезапись одного заклинания в данных набора игрока
function changeGeneratedRunes(playerId, spellLevel)
  print "changeGeneratedRunes"

 local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  for indexSpell, spell in PLAYERS_GENERATED_SPELLS[playerId].runes[1] do
    if countResetRunes > 0 and spell.level == spellLevel and indexSpell < 6 then
        PLAYERS_GENERATED_SPELLS[playerId].runes[1][indexSpell] = getRandomUniqueSpellByMagicType(playerId, PLAYERS_GENERATED_SPELLS[playerId].runes[1], TYPE_MAGICS.RUNES, spellLevel)
    end;
  end;

end;

--Перегенерация заклинания определенного уровня
function changeRunesForPlayer(strPlayerId, strSpellLevel)
  print "changeRunesForPlayer"

  local playerId = strPlayerId + 0;
  local spellLevel = strSpellLevel + 0;
  local playerGold = GetPlayerResource(playerId, GOLD);
  local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  local spellResetCost = MAPPPING_PRICE_RESET_LEVEL_RUNES[spellLevel];

  -- Дополнительный набор необходимо купить один раз
  if countResetRunes == 0 then
    if spellResetCost > playerGold then
      MessageBoxForPlayers(playerId, {PATH_TO_SPELLS_GENERATE_MESSAGES.."no_money.txt"; eq = spellResetCost - playerGold});
      return nil;
    else
      SetPlayerResource(playerId, GOLD, (playerGold - spellResetCost));
    end;
  end;

  -- Скрываем текущий набор рун
  local runeSet = getCurrentPlayerRuneSet(playerId);
  hideCurrentSpellOrRunesSet(playerId, runeSet);

  PLAYERS_GENERATED_SPELLS[playerId].countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes + 1;
  changeGeneratedRunes(playerId, spellLevel)

  -- Отображаем новый набор
  showPlayerRunesList(playerId);

end;

-- Скрытие из виду текущего набора заклинаний или рун
function hideCurrentSpellOrRunesSet(playerId, spellSet)
  print "hideCurrentSpellOrRunesSet"
  
  for indexSpell = 1, length(spellSet) do
    local spell = spellSet[indexSpell];
    local spellIcon = MAPPING_SPELLS_ON_ICONS[spell.id].icons[playerId];
    
    -- На пофиг перемещаем все ненужное в 1,1
    SetObjectPosition(spellIcon, 1, 1, UNDERGROUND);
  end;
end;




-- Точка входа
generateRandomSpellSet();
