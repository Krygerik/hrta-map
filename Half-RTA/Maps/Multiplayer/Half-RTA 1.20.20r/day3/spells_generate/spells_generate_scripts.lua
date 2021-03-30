-- � ���� ����� ������� ������� ��� ������ � ������������

PATH_TO_SPELL_GENERATE_MODULE = GetMapDataPath().."day3/spells_generate/";
PATH_TO_SPELLS_NAMES = PATH_TO_SPELL_GENERATE_MODULE.."spells_names/";

doFile(PATH_TO_SPELL_GENERATE_MODULE.."spells_generate_constants.lua");
sleep(1);

-- ��������� ���������� ������ ���������� ��� ������
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
    
    -- ��������� ���������� - ��������� �������
    generateStartedBonusSpells(playerId, MAPPPING_RACE_TO_MAGIC[raceId]);
    
    -- ������ ��������� ������ ������
    setHeroesStartedBonusSpells(playerId)
    
    -- ��������� ������ ���������� ��� ������
    generateSpellByMagicType(playerId, raceId, MAPPPING_RACE_TO_MAGIC[raceId]);
    
    -- ����������� ��������������� ���������� �� �����
    showSpellIconsOnMap(playerId, raceId);
    
    -- ��������� ������� ��������������� ����������
    changeGenerateSpellsProperties(playerId);
  end;
end;

-- ��������� ���������� ���� ����� ����� ��� �������� ����������
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

-- ��������� ���������� ���������� ������������� ���� �����, ������������� ������
function getRandomSpell(magicType, spellLevel)
  print "getRandomSpell"
  
  -- ������ ���������� ����������� ������
  local spellsByLevel = {};
  
  -- ��������� ������ ������������
  for indexSpell = 1, length(SPELLS[magicType]) do
    local spellData = SPELLS[magicType][indexSpell];

    if spellData.level == spellLevel then
      spellsByLevel[length(spellsByLevel) + 1] = spellData;
    end;
  end;
  
  -- �������� ��������� ���������� �� ������
  local randomSpellIndex = random(length(spellsByLevel)) + 1;

  return spellsByLevel[randomSpellIndex];
end;

-- ��������� ������ � ���������� �� �� ����������
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

-- ��������� ���������� ���������� ���������� � ��������������� ������
function getCountIdentityGeneratedSpells(playerId, spellId)
  print "getCountIdentityGeneratedSpells"
  
  local playerAllSpells = PLAYERS_GENERATED_SPELLS[playerId];
  local countIdentitySpell = 0;
  
  -- �������� � �������� ��������������� �����������
  for _, spell in playerAllSpells.spells do
    if spell.id == spellId then
      countIdentitySpell = countIdentitySpell + 1;
    end;
  end;
  
  -- �������� � �������� ����������� (�������� ��������� �������)
  for _, bonusSpell in playerAllSpells.bonus_spells do
    if bonusSpell.id == spellId then
      countIdentitySpell = countIdentitySpell + 1;
    end;
  end;
  
  return countIdentitySpell;
end

-- ��������� ���������� ���������� � ��� ������������
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

-- ��������� ���������� ���������� ���� � ���������� ������
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

-- ��������� ���������� ���� ����� �����, �� ���������� ��������
function getRandomNotBasicMagicType(magicTypeList)
  print "getRandomNotBasicMagicType"

  local randomMagicType, countIdentityMagicType;

  repeat
    randomMagicType = random(4);
    countIdentityMagicType = getCountIdentityMagicType(magicTypeList, randomMagicType);
  until countIdentityMagicType == 0;
  
  return randomMagicType;
end;

-- ��������� ���������� ���������� �������� �������
function getRandomUniqueSpellByMagicType(playerId, magicType, spellLevel)
  print "getRandomUniqueSpellByMagicType"
  
  local countIdentityGeneratedSpells, randomSpellCurrentLevel;
  
  repeat
    randomSpellCurrentLevel = getRandomSpell(magicType, spellLevel);

    -- ��� ���������� 3 ������ ���������, ����� � �������� ������� �� ������ ��� �����
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

-- ��������� ����������, ��� ���������� ������
function getStartedBonusSpell(playerId, magicType)
  print "getStartedBonusSpell"
  
  local bonusSpellLevel = magicType == TYPE_MAGICS.WARCRIES and 1 or random(2) + 1;
  local randomSpell = getRandomSpell(magicType, bonusSpellLevel);

  return randomSpell;
end;

-- ��������� �������������� ������� ���������� ��� �������� ����������
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
      
      -- ���� ����� ���� ��� ������������
      randomSpell = getRandomSpell(randomMagicType, levelSpell);
      local count = getCountIdentityGeneratedSpells(playerId, randomSpell.id);
      
      if count > 0 then
        blocked = 1;
      end;
    until blocked == 0;
    
    -- ���������� ���������� � ������ ���������� �����
    spells[length(spells) + 1] = randomSpell;
  end;
end;

-- ��������� �������������� ������� ���������� ��� ���� �����
function generateDungeonAdditionalSpells(playerId)
  print "generateDungeonAdditionalSpells"
  
  local spells = PLAYERS_GENERATED_SPELLS[playerId].spells;

  -- 2 ���� ���������� ���������� 4 � 5 ������ ��������� ����
  for i = 1, 2 do
    for levelSpell = 4, 5 do
      local randomSpellCurrentLevel, countIdentityGeneratedSpell;

      repeat
        local randomMagicType = random(4);

        randomSpellCurrentLevel = getRandomSpell(randomMagicType, levelSpell);
        local countIdentityGeneratedSpell = getCountIdentityGeneratedSpells(playerId, randomSpellCurrentLevel.id);
      until countIdentityGeneratedSpell == 0;

      -- ���������� ���������� � ������ ���������� �����
      spells[length(spells) + 1] = countIdentityGeneratedSpell;
    end;
  end;
  
  -- ��������� ��� ������ ���������� 4-5 ������ ��������� �����
  local randomSpell, countIdentityGeneratedSpell;

  repeat
    local randomMagicType = random(4);
    local spellLevel = random (2) + 4;

    randomSpell = getRandomSpell(randomMagicType, spellLevel);
    countIdentityGeneratedSpell = getCountIdentityGeneratedSpells(playerId, randomSpell.id);
  until countIdentityGeneratedSpell == 0;

  spells[length(spells) + 1] = randomSpell;
end;

-- ��������� ��� ��� ������
function generateFortressRunes(playerId)
  print "generateFortressRunes"

  local spells = PLAYERS_GENERATED_SPELLS[playerId].spells;

  for runeLevel = 1, 5 do
    spells[length(spells) + 1] = getRandomSpell(TYPE_MAGICS.RUNES, runeLevel);
  end;
end;

-- ��������� �������� ���������� ����������, ���� ��������� ����� - ����
function generateStartedBonusSpells(playerId, magicTypeList)
  print "generateStartedBonusSpells"
  
  local bonus_spells = PLAYERS_GENERATED_SPELLS[playerId].bonus_spells;
  
  for _, magicType in magicTypeList do
    -- ��������� ��������������� ���������� ������ �������� �����
    local startedBonus = getCalculatedStartedBonus(playerId);

    if startedBonus == STARTED_BONUSES.SPELL then
      local test = getStartedBonusSpell(playerId, magicType);
    
      bonus_spells[length(bonus_spells) + 1] = test;
    end;
  end;
end;

-- ������ ������ ������ ��������� �������� ����������
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

-- ��������� ���������� �� ���� ����� �����
function generateSpellByMagicType(playerId, raceId, magicTypeList)
  print "generateSpellByMagicType"
  
  local spells = PLAYERS_GENERATED_SPELLS[playerId].spells;
  
  -- ��������� ���������� �������� ����
  for _, magicType in magicTypeList do
    -- ��������� �������� ������� ����������
    for spellLevel = 1, 5 do
      if raceId == RACES.STRONGHOLD and spellLevel > 3 then
        break;
      end;
    
      spells[length(spells) + 1] = getRandomUniqueSpellByMagicType(playerId, magicType, spellLevel);
    end;
  end;

  -- ��������� ��� ������ ��� ���������� ������ �����
  if raceId ~= RACES.STRONGHOLD then
    -- ��������� �������������� ���������� � 1 �� 3 ������� �� �������� ���� �����
    for spellLevel = 1, 3 do
      local randomNotBasicMagicType = getRandomNotBasicMagicType(magicTypeList);

      spells[length(spells) + 1] = getRandomUniqueSpellByMagicType(playerId, randomNotBasicMagicType, spellLevel);
    end;

    -- ��������� ��������������� ���������� 3 ������, �� ������������ � �������� ��������
    local randomAdditionalSpellIdIndex = random(length(ONLY_ADDITIONAL_SPELL_ID_LIST)) + 1;
    local randomAddSpellData = getSpellDataBySpellId(ONLY_ADDITIONAL_SPELL_ID_LIST[randomAdditionalSpellIdIndex]);

    spells[length(spells) + 1] = randomAddSpellData;
  end;

  -- ��������� �������������� ������� ��������� ���������� ��� �������� ����������
  if raceId == RACES.ACADEMY then
    generateAcademyAdditionalSpells(playerId, magicTypeList);
  end;
  
  -- ��������� �������������� ������� ��������� ���������� ��� ���� �����
  if raceId == RACES.DUNGEON then
    generateDungeonAdditionalSpells(playerId);
  end;
  
  -- ��������� ��� ��� ������
  if raceId == RACES.FORTRESS then
    generateFortressRunes(playerId);
  end;
end;

-- ����������� ��������������� ���������� �� �����
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

-- ��������� ������� ��������������� ���������� � ������
function changeGenerateSpellsProperties(playerId)
  print "changeGenerateSpellsProperties"

  local spells = PLAYERS_GENERATED_SPELLS[playerId].spells;

  for spellIndex = 1, length(spells) do
    local spellData = spells[spellIndex];
    local spellName = MAPPING_SPELLS_ON_ICONS[spellData.id].text;
    local spellIcon = MAPPING_SPELLS_ON_ICONS[spellData.id].icons[playerId];

    -- ��������� ����������� �������������� � ���������
    SetObjectEnabled(spellIcon, nil);

    -- ������ �������� ��������� ����������
    OverrideObjectTooltipNameAndDescription(spellIcon, PATH_TO_SPELLS_NAMES..spellName, GetMapDataPath().."notext.txt");
  end;
end;

-- ����� �����
generateRandomSpellSet();
