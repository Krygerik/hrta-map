-- � ���� ����� ������� ������� ��� ������ � ������������

PATH_TO_SPELL_GENERATE_MODULE = GetMapDataPath().."day3/spells_generate/";
PATH_TO_SPELLS_NAMES = PATH_TO_SPELL_GENERATE_MODULE.."spells_names/";
PATH_TO_SPELLS_GENERATE_MESSAGES = PATH_TO_SPELL_GENERATE_MODULE.."messages/";

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
    [RACES.STRONGHOLD]       = { TYPE_MAGICS.WARCRIES },
  };
  
  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    
    -- ��������� ���������� - ��������� �������
    generateStartedBonusSpells(playerId, MAPPPING_RACE_TO_MAGIC[raceId]);
    
    -- ��������� ������ ���������� ��� ������
    generateSpellByMagicType(playerId, raceId, MAPPPING_RACE_TO_MAGIC[raceId]);
    
    -- ���������� ������������� ������ ����������
    addResetSpellsObject(playerId);
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
function getCountIdentityGeneratedSpells(playerId, spellSet, spellId)
  print "getCountIdentityGeneratedSpells"
  
  local playerAllSpells = PLAYERS_GENERATED_SPELLS[playerId];
  local countIdentitySpell = 0;
  
  -- �������� � �������� ��������������� �����������
  for _, spell in spellSet do
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
function getRandomUniqueSpellByMagicType(playerId, spellSet, magicType, spellLevel)
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

    countIdentityGeneratedSpells = getCountIdentityGeneratedSpells(playerId, spellSet, randomSpellCurrentLevel.id);
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
function generateAcademyAdditionalSpells(playerId, spellSet, magicTypeList)
  print "generateAcademyAdditionalSpells"
  
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
      local count = getCountIdentityGeneratedSpells(playerId, spellSet, randomSpell.id);
      
      if count > 0 then
        blocked = 1;
      end;
    until blocked == 0;
    
    -- ���������� ���������� � ������ ���������� �����
    spellSet[length(spellSet) + 1] = randomSpell;
  end;
end;

-- ��������� �������������� ������� ���������� ��� ���� �����
function generateDungeonAdditionalSpells(playerId, spellSet)
  print "generateDungeonAdditionalSpells"

  -- 2 ���� ���������� ���������� 4 � 5 ������ ��������� ����
  for i = 1, 2 do
    for levelSpell = 4, 5 do
      local randomSpellCurrentLevel, countIdentityGeneratedSpell;

      repeat
        local randomMagicType = random(4);

        randomSpellCurrentLevel = getRandomSpell(randomMagicType, levelSpell);
        countIdentityGeneratedSpell = getCountIdentityGeneratedSpells(playerId, spellSet, randomSpellCurrentLevel.id);
      until countIdentityGeneratedSpell == 0;

      -- ���������� ���������� � ������ ���������� �����
      spellSet[length(spellSet) + 1] = randomSpellCurrentLevel;
    end;
  end;
  
  -- ��������� ��� ������ ���������� 4-5 ������ ��������� �����
  local randomSpell, countIdentityGeneratedSpell;

  repeat
    local randomMagicType = random(4);
    local spellLevel = random(2) + 4;

    randomSpell = getRandomSpell(randomMagicType, spellLevel);
    countIdentityGeneratedSpell = getCountIdentityGeneratedSpells(playerId, spellSet, randomSpell.id);
  until countIdentityGeneratedSpell == 0;

  spellSet[length(spellSet) + 1] = randomSpell;
end;

-- ��������� ��� ��� ������
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

-- ��������� �������� ���������� ����������, ���� ��������� ����� - ����
function generateStartedBonusSpells(playerId, magicTypeList)
  print "generateStartedBonusSpells"
  
  local startedBonus = getCalculatedStartedBonus(playerId);
  
  if startedBonus == STARTED_BONUSES.SPELL then
    local bonus_spells = PLAYERS_GENERATED_SPELLS[playerId].bonus_spells;

    -- ��������� ��������������� ���������� ������ �������� �����
    for _, magicType in magicTypeList do
      local test = getStartedBonusSpell(playerId, magicType);
    
      bonus_spells[length(bonus_spells) + 1] = test;
    end;
    
    -- ������ ��������� ������ ������
    setHeroesStartedBonusSpells(playerId)
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
  
  -- ���������� 2 ������ ����������
  for indexSpellSet = 1, length(spells) do
    local spellSet = spells[indexSpellSet];

    -- ��������� ���������� �������� ����
    for _, magicType in magicTypeList do
      -- ��������� �������� ������� ����������
      for spellLevel = 1, 5 do
        if raceId == RACES.STRONGHOLD and spellLevel > 3 then
          break;
        end;

        spellSet[length(spellSet) + 1] = getRandomUniqueSpellByMagicType(playerId, spellSet, magicType, spellLevel);
      end;
    end;
    
    -- ��������� ��� ������ ��� ���������� ������ �����
    if raceId ~= RACES.STRONGHOLD then
      -- ��������� �������������� ���������� � 1 �� 3 ������� �� �������� ���� �����
      for spellLevel = 1, 3 do
        local randomNotBasicMagicType = getRandomNotBasicMagicType(magicTypeList);

        spellSet[length(spellSet) + 1] = getRandomUniqueSpellByMagicType(playerId, spellSet, randomNotBasicMagicType, spellLevel);
      end;

      -- ��������� ��������������� ���������� 3 ������, �� ������������ � �������� ��������
      local randomAdditionalSpellIdIndex = random(length(ONLY_ADDITIONAL_SPELL_ID_LIST)) + 1;
      local randomAddSpellData = getSpellDataBySpellId(ONLY_ADDITIONAL_SPELL_ID_LIST[randomAdditionalSpellIdIndex]);

      spellSet[length(spellSet) + 1] = randomAddSpellData;
    end;
    
    -- ��������� �������������� ������� ��������� ���������� ��� �������� ����������
    if raceId == RACES.ACADEMY then
      generateAcademyAdditionalSpells(playerId, spellSet, magicTypeList);
    end;
    
    -- ��������� �������������� ������� ��������� ���������� ��� ���� �����
    if raceId == RACES.DUNGEON then
      generateDungeonAdditionalSpells(playerId, spellSet);
    end;
  end;
  
  -- ��������� ��� ��� ������
  if raceId == RACES.FORTRESS then
    generateFortressRunes(playerId);
  end;
  
  -- ����������� ��������������� ���������� �� �����
  showPlayerAllSpellsOnMap(playerId, raceId);
end;

-- ����������� ���������� ���������� �� �����
function showSpellListIconsOnMap(playerId, spells, placeSpells)
  print "showSpellListIconsOnMap"
  
  for spellIndex = 1, length(spells) do
    local spellData = spells[spellIndex];
    local spellName = MAPPING_SPELLS_ON_ICONS[spellData.id].text;
    local spellIcon = MAPPING_SPELLS_ON_ICONS[spellData.id].icons[playerId];
    local spellPlace = placeSpells[spellIndex];

    SetObjectPosition(spellIcon, spellPlace.x, spellPlace.y, GROUND);

    -- ��������� ����������� �������������� � ���������
    SetObjectEnabled(spellIcon, nil);

    -- ������ �������� ��������� ����������
    OverrideObjectTooltipNameAndDescription(spellIcon, PATH_TO_SPELLS_NAMES..spellName, GetMapDataPath().."notext.txt");
  end;
end;

-- ����������� ������ ������ ����������/������ � ������
function showPlayerSpellList(playerId, raceId)
  print "showPlayerSpellList"

  local spells = getCurrentPlayerSpellSet(playerId);
  local placeSpells = raceId == RACES.STRONGHOLD and PLACE_GENERATED_SPELLS[playerId].WARCRIES or PLACE_GENERATED_SPELLS[playerId].SPELLS;

  showSpellListIconsOnMap(playerId, spells, placeSpells);
end;

-- ����������� ������ ������ ��� � ������
function showPlayerRunesList(playerId)
  print "showPlayerRunesList"

  local runes = getCurrentPlayerRuneSet(playerId);
  local placeRunes = PLACE_GENERATED_SPELLS[playerId].RUNES;

  showSpellListIconsOnMap(playerId, runes, placeRunes);
end;

-- ����������� ��������������� ���������� �� �����
function showPlayerAllSpellsOnMap(playerId, raceId)
  print "showPlayerAllSpellsOnMap"

  -- ���������� ����� ������/������
  showPlayerSpellList(playerId, raceId);
  
  -- ����� ���������� ����
  if raceId == RACES.FORTRESS then
    showPlayerRunesList(playerId);
  end;
end;

-- ��������� �������� ������ ���������� ������
function getCurrentPlayerSpellSet(playerId)
  print "getCurrentPlayerSpellSet"
  
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
  -- ���� ���������� ������� ������� ������ ������ - ����� ������, ����� ������
  local indexSpellSet = mod(countResetSpells, 2) == 0 and 1 or 2;
  
  return PLAYERS_GENERATED_SPELLS[playerId].spells[indexSpellSet];
end;

-- ��������� �������� ������ ��� ������
function getCurrentPlayerRuneSet(playerId)
  print "getCurrentPlayerRuneSet"

  local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  -- ���� ���������� ������� ������� ������ ������ - ����� ������, ����� ������
  local indexRuneSet = mod(countResetRunes, 2) == 0 and 1 or 2;

  return PLAYERS_GENERATED_SPELLS[playerId].runes[indexRuneSet];
end;

-- ���������� �������� ������� ��� ������������� ������ ����������
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

-- ������ ������ �� ����� ������ ����������
function questionSpellReset(triggerHero)
  print "questionSpellReset"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  local spellResetCost = raceId == RACES.STRONGHOLD and SPELLS_RESET_COSTS.WARCRIES or SPELLS_RESET_COSTS.DEFAULT;
  local callbackNo = raceId == RACES.FORTRESS and 'questionRunesReset("'..triggerHero..'")' or 'noop';
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;
  local question = countResetSpells == 0 and "question_change_spells.txt" or "question_get_prev_spells.txt";
  
  QuestionBoxForPlayers(
    playerId,
    {PATH_TO_SPELLS_GENERATE_MESSAGES..question; eq = spellResetCost},
    'changeSpellsForPlayer("'..playerId..'")',
    callbackNo
  );
end;

-- ������ �� ����� ������ ���
function questionRunesReset(triggerHero)
  print "questionRunesReset"

  local playerId = GetPlayerFilter(GetObjectOwner(triggerHero));
  local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  local question = countResetRunes == 0 and "question_change_runes.txt" or "question_get_prev_runes.txt";
  
  QuestionBoxForPlayers(
    playerId,
    {PATH_TO_SPELLS_GENERATE_MESSAGES..question; eq = SPELLS_RESET_COSTS.RUNES},
    'changeRunesForPlayer("'..playerId..'")',
    'noop'
  );
end;

-- ��������� ������ ��� ��� ������
function changeRunesForPlayer(strPlayerId)
  print "changeRunesForPlayer"

  -- �������� �� ������ � ������
  local playerId = strPlayerId + 0;
  
  local countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes;
  local playerGold = GetPlayerResource(playerId, GOLD);

  -- �������������� ����� ���������� ������ ���� ���
  if countResetRunes == 0 then
    if SPELLS_RESET_COSTS.RUNES > playerGold then
      MessageBoxForPlayers(playerId, {PATH_TO_SPELLS_GENERATE_MESSAGES.."no_money.txt"; eq = SPELLS_RESET_COSTS.RUNES});
      
      return nil;
    else
      SetPlayerResource(playerId, GOLD, (playerGold - SPELLS_RESET_COSTS.RUNES));
    end;
  end;

  -- �������� ������� ����� ���
  local runeSet = getCurrentPlayerRuneSet(playerId);
  hideCurrentSpellOrRunesSet(playerId, runeSet);

  PLAYERS_GENERATED_SPELLS[playerId].countResetRunes = PLAYERS_GENERATED_SPELLS[playerId].countResetRunes + 1;

  -- ���������� ����� ����� ���
  showPlayerRunesList(playerId);
end;

-- ������� �� ���� �������� ������ ���������� ��� ���
function hideCurrentSpellOrRunesSet(playerId, spellSet)
  print "hideCurrentSpellOrRunesSet"
  
  for indexSpell = 1, length(spellSet) do
    local spell = spellSet[indexSpell];
    local spellIcon = MAPPING_SPELLS_ON_ICONS[spell.id].icons[playerId];
    
    -- �� ����� ���������� ��� �������� � 1,1
    SetObjectPosition(spellIcon, 1, 1, UNDERGROUND);
  end;
end;

-- ��������� ������ ���������� ��� ������
function changeSpellsForPlayer(strPlayerId)
  print "changeSpellsForPlayer"
  
  -- �������� �� ������ � ������
  local playerId = strPlayerId + 0;
  
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local spellResetCost = raceId == RACES.STRONGHOLD and SPELLS_RESET_COSTS.WARCRIES or SPELLS_RESET_COSTS.DEFAULT;
  local playerGold = GetPlayerResource(playerId, GOLD);
  local countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells;

  -- �������������� ����� ���������� ������ ���� ���
  if countResetSpells == 0 then
    if spellResetCost > playerGold then
      MessageBoxForPlayers(playerId, {PATH_TO_SPELLS_GENERATE_MESSAGES.."no_money.txt"; eq = spellResetCost});
    
      return nil;
    else
      SetPlayerResource(playerId, GOLD, (playerGold - spellResetCost));
    end;
  end;

  -- �������� ������� ����� ����������
  local spellSet = getCurrentPlayerSpellSet(playerId);
  hideCurrentSpellOrRunesSet(playerId, spellSet);

  PLAYERS_GENERATED_SPELLS[playerId].countResetSpells = PLAYERS_GENERATED_SPELLS[playerId].countResetSpells + 1;
  
  -- ���������� ����� �����
  showPlayerSpellList(playerId, raceId);
end;


-- ����� �����
generateRandomSpellSet();
