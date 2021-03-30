-- В этом файле описаны скрипты для работы с заклинаниями

PATH_TO_SPELL_GENERATE_MODULE = GetMapDataPath().."day3/spells_generate/";
PATH_TO_SPELLS_NAMES = PATH_TO_SPELL_GENERATE_MODULE.."spells_names/";

doFile(PATH_TO_SPELL_GENERATE_MODULE.."spells_generate_constants.lua");
sleep(1);

-- Генерация случайного набора заклинаний для игрока
function generateRandomSpellSet()
  print "generateRandomSpellSet"

  local MAPPPING_RACE_TO_MAGIC = {
    [RACES.HAVEN]            = { TYPE_MAGICS.LIGHT, TYPE_MAGICS.DARK },
    [RACES.INFERNO]          = { TYPE_MAGICS.DARK, TYPE_MAGICS.DESTRUCTIVE },
    [RACES.NECROPOLIS]       = { TYPE_MAGICS.DARK, TYPE_MAGICS.SUMMON },
    [RACES.SYLVAN]           = { TYPE_MAGICS.LIGHT, TYPE_MAGICS.DESTRUCTIVE },
    [RACES.ACADEMY]          = { TYPE_MAGICS.SUMMON, getRandomAcademyMagicType() },
    [RACES.DUNGEON]          = { TYPE_MAGICS.DESTRUCTIVE, TYPE_MAGICS.SUMMON },
    [RACES.FORTRESS]         = { TYPE_MAGICS.LIGHT, TYPE_MAGICS.DESTRUCTIVE },
    [RACES.STRONGHOLD]       = { TYPE_MAGICS.WARCRIES, TYPE_MAGICS.LIGHT },
  };
  
  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    
    -- Генерация заклинаний - стартовых бонусов
    generateStartedBonusSpells(playerId, MAPPPING_RACE_TO_MAGIC[raceId]);
    
    -- Выдача стартовых заклов героям
    setHeroesStartedBonusSpells(playerId)
    
    -- Генерация набора заклинаний для игрока
    generateSpellByMagicType(playerId, raceId, MAPPPING_RACE_TO_MAGIC[raceId]);
    
    -- Отображение сгенерированных заклинаний на карте
    showSpellIconsOnMap(playerId, raceId);
    
    -- Изменение свойств сгенерированных заклинаний
    changeGenerateSpellsProperties(playerId);
  end;
end;

-- получение случайного типа школы магии для академии волшебства
function getRandomAcademyMagicType()
  print "getRandomAcademyMagicType"

  local rnd = random (100);
  local result = TYPE_MAGICS.LIGHT;

  if rnd < 75 and rnd >= 50 then
    result = TYPE_MAGICS.DESTRUCTIVE;
  end;
  if rnd > 74 then
    result = TYPE_MAGICS.DARK;
  end;

  return result;
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

-- Получение количества одинаковых заклинаний в сгенерированном списке
function getCountIdentityGeneratedSpells(playerId, spellId)
  print "getCountIdentityGeneratedSpells"
  
  local playerAllSpells = PLAYERS_GENERATED_SPELLS[playerId];
  local countIdentitySpell = 0;
  
  -- Проверка в основных сгенерированных заклинаниях
  for _, spell in playerAllSpells.spells do
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
function getRandomUniqueSpellByMagicType(playerId, magicType, spellLevel)
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

    countIdentityGeneratedSpells = getCountIdentityGeneratedSpells(playerId, randomSpellCurrentLevel.id);
  until countIdentityGeneratedSpells == 0
  
  return randomSpellCurrentLevel;
end;

-- Получение заклинания, как стартового бонуса
function getStartedBonusSpell(playerId, magicType)
  print "getStartedBonusSpell"
  
  local bonusSpellLevel = magicType == TYPE_MAGICS.WARCRIES and 1 or random(2) + 1;
  local randomSpell = getRandomSpell(magicType, bonusSpellLevel);

  return randomSpell;
end;

-- Генерация дополнительной линейки заклинаний для Академии Волшебства
function generateAcademyAdditionalSpells(playerId, magicTypeList)
  print "generateAcademyAdditionalSpells"
  
  local spells = PLAYERS_GENERATED_SPELLS[playerId].spells;
  local hasLightMagicSpell = 0;
  local hasDarkMagicSpell = 0;

  for levelSpell = 1, 5 do
    local playerHasLightMagicType = getCountIdentityMagicType(magicTypeList, TYPE_MAGICS.LIGHT) > 0;
    local playerHasDarkMagicType = getCountIdentityMagicType(magicTypeList, TYPE_MAGICS.DARK) > 0;
    local randomSpell, blocked;

    repeat
      blocked = 0;
      local randomMagicType = random(4);
      
      local isExistRandomMagicType = getCountIdentityMagicType(magicTypeList, randomMagicType) > 0;

      if randomMagicType == TYPE_MAGICS.LIGHT and hasLightMagicSpell == 1 and playerHasLightMagicType then
        blocked = 1;
      end;
      
      if randomMagicType == TYPE_MAGICS.DARK and hasDarkMagicSpell == 1 and playerHasDarkMagicType then
        blocked = 1;
      end;
      
      if levelSpell > 3 and isExistRandomMagicType then
        blocked = 1;
      end;
      
      -- Если такой закл уже сгенерирован
      randomSpell = getRandomSpell(randomMagicType, levelSpell);
      local count = getCountIdentityGeneratedSpells(playerId, randomSpell.id);
      
      if count > 0 then
        blocked = 1;
      end;
    until blocked == 0;
    
    -- Добавление заклинания в список заклинаний героя
    spells[length(spells) + 1] = randomSpell;
  end;
end;

-- Генерация дополнительной линейки заклинаний для Лиги Теней
function generateDungeonAdditionalSpells(playerId)
  print "generateDungeonAdditionalSpells"
  
  local spells = PLAYERS_GENERATED_SPELLS[playerId].spells;

  -- 2 раза генерируем заклинания 4 и 5 уровня случайных школ
  for i = 1, 2 do
    for levelSpell = 4, 5 do
      local randomSpellCurrentLevel, countIdentityGeneratedSpell;

      repeat
        local randomMagicType = random(4);

        randomSpellCurrentLevel = getRandomSpell(randomMagicType, levelSpell);
        local countIdentityGeneratedSpell = getCountIdentityGeneratedSpells(playerId, randomSpellCurrentLevel.id);
      until countIdentityGeneratedSpell == 0;

      -- Добавление заклинания в список заклинаний героя
      spells[length(spells) + 1] = countIdentityGeneratedSpell;
    end;
  end;
  
  -- Генерация еще одного заклинания 4-5 уровня случайной школы
  local randomSpell, countIdentityGeneratedSpell;

  repeat
    local randomMagicType = random(4);
    local spellLevel = random (2) + 4;

    randomSpell = getRandomSpell(randomMagicType, spellLevel);
    countIdentityGeneratedSpell = getCountIdentityGeneratedSpells(playerId, randomSpell.id);
  until countIdentityGeneratedSpell == 0;

  spells[length(spells) + 1] = randomSpell;
end;

-- Генерация рун для гномов
function generateFortressRunes(playerId)
  print "generateFortressRunes"

  local spells = PLAYERS_GENERATED_SPELLS[playerId].spells;

  for runeLevel = 1, 5 do
    spells[length(spells) + 1] = getRandomSpell(TYPE_MAGICS.RUNES, runeLevel);
  end;
end;

-- Генерация бонусных неизменных заклинаний, если стартовый бонус - закл
function generateStartedBonusSpells(playerId, magicTypeList)
  print "generateStartedBonusSpells"
  
  local bonus_spells = PLAYERS_GENERATED_SPELLS[playerId].bonus_spells;
  
  for _, magicType in magicTypeList do
    -- Генерация дополнительного заклинания каждой основной школы
    local startedBonus = getCalculatedStartedBonus(playerId);

    if startedBonus == STARTED_BONUSES.SPELL then
      local test = getStartedBonusSpell(playerId, magicType);
    
      bonus_spells[length(bonus_spells) + 1] = test;
    end;
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
  
  -- Генерация заклинаний основных школ
  for _, magicType in magicTypeList do
    -- Генерация основной линейки заклинаний
    for spellLevel = 1, 5 do
      if raceId == RACES.STRONGHOLD and spellLevel > 3 then
        break;
      end;
    
      spells[length(spells) + 1] = getRandomUniqueSpellByMagicType(playerId, magicType, spellLevel);
    end;
  end;

  -- Генерация доп заклов для неосновных линеек магий
  if raceId ~= RACES.STRONGHOLD then
    -- Генерация дополнительных заклинаний с 1 по 3 уровней не основных школ магий
    for spellLevel = 1, 3 do
      local randomNotBasicMagicType = getRandomNotBasicMagicType(magicTypeList);

      spells[length(spells) + 1] = getRandomUniqueSpellByMagicType(playerId, randomNotBasicMagicType, spellLevel);
    end;

    -- Генерация дополнительного заклинания 3 уровня, не участвующего в основных линейках
    local randomAdditionalSpellIdIndex = random(length(ONLY_ADDITIONAL_SPELL_ID_LIST)) + 1;
    local randomAddSpellData = getSpellDataBySpellId(ONLY_ADDITIONAL_SPELL_ID_LIST[randomAdditionalSpellIdIndex]);

    spells[length(spells) + 1] = randomAddSpellData;
  end;

  -- Генерация дополнительной линейки случайных заклинаний для Академии Волшебства
  if raceId == RACES.ACADEMY then
    generateAcademyAdditionalSpells(playerId, magicTypeList);
  end;
  
  -- Генерация дополнительной линейки случайных заклинаний для Лиги Теней
  if raceId == RACES.DUNGEON then
    generateDungeonAdditionalSpells(playerId);
  end;
  
  -- Генерация рун для гномов
  if raceId == RACES.FORTRESS then
    generateFortressRunes(playerId);
  end;
end;

-- Отображение сгенерированных заклинаний на карте
function showSpellIconsOnMap(playerId, raceId)
  print "showSpellIconsOnMap"

  local spells = PLAYERS_GENERATED_SPELLS[playerId].spells;
  local placeSpells = PLACE_GENERATED_SPELLS[playerId];

  for spellIndex = 1, length(spells) do
    local spellData = spells[spellIndex];
    local spellIcon = MAPPING_SPELLS_ON_ICONS[spellData.id].icons[playerId];

    local spellPlace = raceId == RACES.STRONGHOLD and placeSpells[spellIndex * 2 - 1] or placeSpells[spellIndex];

    SetObjectPosition(spellIcon, spellPlace.x, spellPlace.y, GROUND);
  end;
end;

-- Изменение свойств сгенерированных заклинаний у игрока
function changeGenerateSpellsProperties(playerId)
  print "changeGenerateSpellsProperties"

  local spells = PLAYERS_GENERATED_SPELLS[playerId].spells;

  for spellIndex = 1, length(spells) do
    local spellData = spells[spellIndex];
    local spellName = MAPPING_SPELLS_ON_ICONS[spellData.id].text;
    local spellIcon = MAPPING_SPELLS_ON_ICONS[spellData.id].icons[playerId];

    -- Отключаем стандартное взаимодействие с текстурой
    SetObjectEnabled(spellIcon, nil);

    -- Меняем название портретов заклинаний
    OverrideObjectTooltipNameAndDescription(spellIcon, PATH_TO_SPELLS_NAMES..spellName, GetMapDataPath().."notext.txt");
  end;
end;

-- Точка входа
generateRandomSpellSet();
