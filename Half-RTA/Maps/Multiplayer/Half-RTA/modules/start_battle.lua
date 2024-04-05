-- Модуль подготовки и инициализации битвы

-- Соотношение ручного перечисления школ магии на внутреигровой
MAP_CUSTOM_SKILL_TO_INNER = {
  [TYPE_MAGICS.LIGHT] = SKILL_LIGHT_MAGIC,
  [TYPE_MAGICS.DARK] = SKILL_DARK_MAGIC,
  [TYPE_MAGICS.DESTRUCTIVE] = SKILL_DESTRUCTIVE_MAGIC,
  [TYPE_MAGICS.SUMMON] = SKILL_SUMMONING_MAGIC,
  [TYPE_MAGICS.RUNES] = HERO_SKILL_RUNELORE,
  [TYPE_MAGICS.WARCRIES] = HERO_SKILL_DEMONIC_RAGE,
};

-- Имеется ли заклинание в текущем наборе игрока
function getSpellHasInPlayerSet(playerId, spellId)
  print "getSpellHasInPlayerSet"

  -- Номер набора заклинаний
  local spellSet = PLAYERS_GENERATED_SPELLS[playerId].spells[1];

  for _, spellData in spellSet do
    if spellData.id == spellId then
      return not nil;
    end;
  end;

  return nil;
end;

-- Имеется ли руна в текущем наборе игрока
function getRunesHasInPlayerSet(playerId, runeId)
  print "getRunesHasInPlayerSet"

  -- Номер набора рун
  local runesSet = PLAYERS_GENERATED_SPELLS[playerId].runes[1];

  for _, runeData in runesSet do
    if runeData.id == runeId then
      return not nil;
    end;
  end;

  return nil;
end;

-- ВОсполняем ману
function refreshPlayerMana(playerId)
  print "refreshPlayerMana"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  ChangeHeroStat(mainHeroName, STAT_MANA_POINTS, 1000);
end;

-- Обучение ГГ игрока всем доступным заклинаниям
function teachMainHeroSpells(playerId)
  print "teachMainHeroSpells"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  for skillId, skillSpellSet in SPELLS do
    for _, spellData in skillSpellSet do
      if skillId ~= TYPE_MAGICS.RUNES and skillId ~= TYPE_MAGICS.WARCRIES then
        local playerHasSpell = getSpellHasInPlayerSet(playerId, spellData.id);

        if playerHasSpell then
          local innerSkillId = MAP_CUSTOM_SKILL_TO_INNER[skillId];

          if spellData.level < 3 then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;

          if (
            spellData.level == 3
            and (HasHeroSkill(mainHeroName, PERK_WISDOM) or GetHeroSkillMastery(mainHeroName, innerSkillId) > 0)
          ) then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;

          if (
            spellData.level == 4
            and (
              (HasHeroSkill(mainHeroName, PERK_WISDOM) and HasArtefact(mainHeroName, ARTIFACT_NECROMANCER_PENDANT, 1))
              or GetHeroSkillMastery(mainHeroName, innerSkillId) > 1
            )
          ) then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;

          if spellData.level == 5 and GetHeroSkillMastery(mainHeroName, innerSkillId) > 2 then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;
        end;
      end;

      -- Руны
      if skillId == TYPE_MAGICS.RUNES then
        local playerHasRune = getRunesHasInPlayerSet(playerId, spellData.id);

        if playerHasRune then
          if spellData.level < 4 then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;

          if spellData.level < 5 and GetHeroSkillMastery(mainHeroName, HERO_SKILL_RUNELORE) > 1 then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;

          if spellData.level == 5 and GetHeroSkillMastery(mainHeroName, HERO_SKILL_RUNELORE) > 2 then
            TeachHeroSpell(mainHeroName, spellData.id);
          end;
        end;
      end;

      -- Кличи
      if skillId == TYPE_MAGICS.WARCRIES then
        local playerHasSpell = getSpellHasInPlayerSet(playerId, spellData.id);

        if playerHasSpell then
          TeachHeroSpell(mainHeroName, spellData.id);
        end;
      end;
    end;
  end;

  -- Заклы как стартовый бонус
  local bonusSpells = PLAYERS_GENERATED_SPELLS[playerId].bonus_spells;

  for _, spellData in bonusSpells do
    TeachHeroSpell(mainHeroName, spellData.id);
  end;
end;

-- Генерим сид
function generateSeed()
  print "generateSeed"

  local t = {};

	for i=1,6 do
		t[i] = random(16777216)
	end;

	consoleCmd([[@SetGameVar('combat_prng_seed', 'return {]] .. concat(t, ',') .. [[}')]])
end;

-- Прокидываем данные об игроках в боевые скрипты
function saveHeroesInfoInToBattle()
  print "saveHeroesInfoInToBattle"

  local customConsoleCommand = {[[@SetGameVar('heroes_info', 'return {]]};

  for _, playerId in PLAYER_ID_TABLE do
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

    append(customConsoleCommand, '["' .. mainHeroName .. '"]={');

    -- уровень --
		append(customConsoleCommand, 'level=' .. GetHeroLevel(mainHeroName) .. ',')

		-- удача --
		append(customConsoleCommand, 'luck=' .. GetHeroStat(mainHeroName, STAT_LUCK) .. ',')

		-- артефакты --
		append(customConsoleCommand, 'ArtSet={')
    for artset = 0, 9 do
      local artsetlevel = GetArtifactSetItemsCount(mainHeroName, artset, 1)
      if artsetlevel > 0 then
        append(customConsoleCommand, '[' .. artset .. ']=' .. artsetlevel .. ',')
      end
    end
    append(customConsoleCommand, '},')

		-- навыки и умения --
		append(customConsoleCommand, 'skills={')
		for skill = 1, 220 do
			local mastery = GetHeroSkillMastery(mainHeroName, skill)
			if mastery > 0 then
				append(customConsoleCommand, '[' .. skill .. ']=' .. mastery .. ',')
			end
		end
		append(customConsoleCommand, '},')

		append(customConsoleCommand, '},')
  end;

  append(customConsoleCommand, [[}')]])
	consoleCmd(concat(customConsoleCommand))
end;

-- Получение ИД случайной фракции, не совпадающей с фракциями игроков
function getOtherRandomRaceId()
  print "getOtherRandomRaceId"

  local player1RaceId = RESULT_HERO_LIST[PLAYER_1].raceId;
  local player2RaceId = RESULT_HERO_LIST[PLAYER_2].raceId;

  local resultRaceIdTable = {};

  for _, raceId in RACES do
    local isAllowRace = raceId ~= RACES.NEUTRAL
       and raceId ~= player1RaceId
       and raceId ~= player2RaceId;
  
    -- Убираем фраки с общими землями
    if (player1RaceId == RACES.HAVEN or player2RaceId == RACES.HAVEN or player1RaceId == RACES.SYLVAN or player2RaceId == RACES.SYLVAN) then
      if (raceId == RACES.SYLVAN or raceId == RACES.HAVEN) then
        isAllowRace = nil;
      end;
    end;
    
    if isAllowRace then
      resultRaceIdTable[length(resultRaceIdTable)] = raceId;
    end;
  end;

  local randomIndex = random(length(resultRaceIdTable));

  return resultRaceIdTable[randomIndex];
end;

-- Проверка наличия героев на родных землях и насильное передвижение на нейтральную
function checkAndMoveHeroFromFrendlyField()
  print "checkAndMoveHeroFromFrendlyField"

  local RACE_ON_FRENDLY_FIELD_POSITION = {
    [RACES.HAVEN] = { x = 52, y = 51 },
    [RACES.INFERNO] = { x = 56, y = 51 },
    [RACES.NECROPOLIS] = { x = 48, y = 51 },
    [RACES.SYLVAN] = { x = 52, y = 51 },
    [RACES.ACADEMY] = { x = 48, y = 49 },
    [RACES.DUNGEON] = { x = 40, y = 51 },
    [RACES.FORTRESS] = { x = 44, y = 51 },
    [RACES.STRONGHOLD] = { x = 50, y = 45 },
  };

  local choisePlayerId = getSelectedBattlefieldPlayerId();
  local choiseHeroName = PLAYERS_MAIN_HERO_PROPS[choisePlayerId].name;
  local choisePlayerRaceId = RESULT_HERO_LIST[choisePlayerId].raceId;
  local choiseDictHeroName = getDictionaryHeroName(choiseHeroName);

  local opponentPlayerId = PLAYERS_OPPONENT[choisePlayerId];
  local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;
  local opponentPlayerRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;
    
  -- Нибросу не запрещаем находиться на его родной поляне
  if choiseDictHeroName == HEROES.JAZAZ then
    return nil;
  end;

  -- С нахождением пути можно безобразничать как угодно
  if HasHeroSkill(choiseHeroName, PERK_PATHFINDING) and not HasHeroSkill(opponentHeroName, PERK_PATHFINDING) then
    return nil;
  end;

  for regionRaceId, raceRegion in MAP_RACE_ON_NATIVE_REGIONS do
    if IsObjectInRegion(choiseHeroName, raceRegion) and (regionRaceId == choisePlayerRaceId or regionRaceId == opponentPlayerRaceId) then
      local randomRaceId = getOtherRandomRaceId();
      local raceFieldPosition = RACE_ON_FRENDLY_FIELD_POSITION[randomRaceId];

      SetObjectPosition(choiseHeroName, raceFieldPosition.x, raceFieldPosition.y);
      while not IsObjectInRegion(choiseHeroName, MAP_RACE_ON_NATIVE_REGIONS[randomRaceId]) do
        sleep();
      end;
      return nil;
    end;
  end;
  
  for regionRaceId, raceRegion in MAP_RACE_ON_ADDITIONAL_REGIONS do
    if IsObjectInRegion(choiseHeroName, raceRegion) and (regionRaceId == choisePlayerRaceId or regionRaceId == opponentPlayerRaceId) then
      local randomRaceId = getOtherRandomRaceId();
      local raceFieldPosition = RACE_ON_FRENDLY_FIELD_POSITION[randomRaceId];

      SetObjectPosition(choiseHeroName, raceFieldPosition.x, raceFieldPosition.y);
      while not IsObjectInRegion(choiseHeroName, MAP_RACE_ON_NATIVE_REGIONS[randomRaceId]) do
        sleep();
      end;
      return nil;
    end;
  end;
  
  if IsObjectInRegion(choiseHeroName, REGION_COBBLESTONE_HALL) then
    local randomRaceId = getOtherRandomRaceId();
    local raceFieldPosition = RACE_ON_FRENDLY_FIELD_POSITION[randomRaceId];
      
    SetObjectPosition(choiseHeroName, raceFieldPosition.x, raceFieldPosition.y);
    while not IsObjectInRegion(choiseHeroName, MAP_RACE_ON_NATIVE_REGIONS[randomRaceId]) do
      sleep();
    end;
    return nil;
  end;
end;

-- Менторство
function skillMentoring(heroName)
  print "skillMentoring"

  local MENTORINT_ADDITIONAL_LEVEL = 8;

  local heroLevel = GetHeroLevel(heroName);
  local needExp = TOTAL_EXPERIENCE_BY_LEVEL[heroLevel + MENTORINT_ADDITIONAL_LEVEL] - TOTAL_EXPERIENCE_BY_LEVEL[heroLevel];

  WarpHeroExp(heroName, GetHeroStat(heroName, STAT_EXPERIENCE) + needExp);
end;

-- Ученый
function perkScholar(playerId)
  print "perkScholar"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

  local MAGIC_SCHOOL_TABLE = {
    TYPE_MAGICS.LIGHT,
    TYPE_MAGICS.DARK,
    TYPE_MAGICS.DESTRUCTIVE,
    TYPE_MAGICS.SUMMON,
  };

  -- Дает все заклинания 1-2 уровней, известные оппоненту
  for _, customSkillId in MAGIC_SCHOOL_TABLE do
    local skillSpellSet = SPELLS[customSkillId];

    for _, spellData in skillSpellSet do
      local opponentHasSpell = getSpellHasInPlayerSet(opponentPlayerId, spellData.id);
      
      if spellData.level < 3 and opponentHasSpell then
        TeachHeroSpell(mainHeroName, spellData.id);
      end
    end;
  end;
  
  -- Передаем все заклинания 1-2 уровней, известные выпавшим героям
  for _, customSkillId in MAGIC_SCHOOL_TABLE do
    local skillSpellSet = SPELLS[customSkillId];

    for _, spellData in skillSpellSet do
      local heroes = GetPlayerHeroes(playerId);
      
      for heroesIndex, heroesName in heroes do
        -- Кроме Биары и ГГ
        if heroesIndex ~= 0
          and heroesName ~= mainHeroName
          and KnowHeroSpell(heroesName, spellData.id)
          and spellData.level < 3
          and not KnowHeroSpell(mainHeroName, spellData.id)
        then
          TeachHeroSpell(mainHeroName, spellData.id);
        end;
      end;
    end;
  end;
end;

-- Сбор войск
function perkRecruitment(playerId)
  print "perkRecruitment"

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  -- Коэффициент добавления юнитов из города
  local RECRUIMENT_COEF = 0.1

  local stash = {};

  stash[1], stash[2], stash[3], stash[4], stash[5], stash[6], stash[7] = GetHeroCreaturesTypes(mainHeroName);
  
  for _, armyId in stash do
    for _, dictUnit in UNITS[raceId] do
      if armyId == dictUnit.id and dictUnit.lvl < 4 then
        local unitInTown = RESULT_ARMY_INTO_TOWN[playerId][dictUnit.lvl];

        AddHeroCreatures(mainHeroName, dictUnit.id, floor(unitInTown.count * RECRUIMENT_COEF));
      end;
    end;
  end;
end;

--Дипломатия
function perkDiplomacy(playerId)
  print "perkDiplomacy"
  
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  -- Коэффициент добавления юнитов из города
  local DIPLOMACY_COEF = 0.251

  local stash = {};
  
  local mapCreaturesToAlt = {
    [CREATURE_ZEALOT] = CREATURE_PRIEST,

    [CREATURE_LICH_MASTER] = CREATURE_LICH,

    [CREATURE_HIGH_DRUID] = CREATURE_DRUID,

    [CREATURE_COMBAT_MAGE] = CREATURE_MAGI,

    --специализация Нархиза
    [907] = 908,

    [CREATURE_SHADOW_MISTRESS] = CREATURE_MATRON,

    [CREATURE_RUNE_MAGE] = CREATURE_FLAME_KEEPER,

    [CREATURE_SHAMAN_HAG] = CREATURE_SHAMAN,
    
    [CREATURE_PIT_FIEND] = CREATURE_PIT_FIEND,

    }
  
  local dictUnitsWizard = {
    [CREATURE_ZEALOT] = 5,
    [CREATURE_PRIEST] = 5,
    
    [CREATURE_PIT_FIEND] = 6,
    
    [CREATURE_LICH_MASTER] = 5,
    [CREATURE_LICH] = 5,
    
    [CREATURE_HIGH_DRUID] = 4,
    [CREATURE_DRUID] = 4,

    [CREATURE_COMBAT_MAGE] = 4,
    [CREATURE_MAGI] = 4,
    
    [907] = 4,
    [908] = 4,


    [CREATURE_SHADOW_MISTRESS] = 6,
    [CREATURE_MATRON] = 6,

    [CREATURE_RUNE_MAGE] = 5,
    [CREATURE_FLAME_KEEPER] = 5,

    [CREATURE_SHAMAN_HAG] = 4,
    [CREATURE_SHAMAN] = 4,

    }
    
  local dictUnitsForRolf = {
 --  [CREATURE_BROWLER] = 4,
 --  [CREATURE_BATTLE_RAGER] = 4,
    [CREATURE_FLAME_KEEPER] = 5,
    [CREATURE_RUNE_MAGE] = 5,
    [CREATURE_THANE] = 6,
    [CREATURE_THUNDER_THANE] = 6,
    [CREATURE_MAGMA_DRAGON] = 7,
    [CREATURE_LAVA_DRAGON] = 7,
    }

  stash[1], stash[2], stash[3], stash[4], stash[5], stash[6], stash[7] = GetHeroCreaturesTypes(mainHeroName);
  
  local dictHeroName = getDictionaryHeroName(mainHeroName);
  if dictHeroName == 'oldRolf' then
    for currentLvl = 5, 7 do
      local giveCreature = nil;
      
      for highLvlCreatureId, highLvlCreatureLvl in dictUnitsForRolf do
        if highLvlCreatureLvl == currentLvl and not giveCreature then
          for _, armyId in stash do
            if armyId == highLvlCreatureId then
              local unitInTown = RESULT_ARMY_INTO_TOWN[playerId][highLvlCreatureLvl];
              
              AddHeroCreatures(mainHeroName, highLvlCreatureId, floor(unitInTown.count * DIPLOMACY_COEF));
              giveCreature = not nil
            end
          end
        end
      end
    end
    return nil
  end
  
  for wizardId, altWizardId in mapCreaturesToAlt do
    local isExist = nil
    local isExistAlt = nil

    for _, armyId in stash do
      if armyId == wizardId then
        isExist = not nil
      end;
    end;
    
    for _, armyId in stash do
      if armyId == altWizardId then
        isExistAlt = not nil
      end;
    end;
    local unitInTown = RESULT_ARMY_INTO_TOWN[playerId][dictUnitsWizard[wizardId]];
    local resultCount = rounding(unitInTown.count * DIPLOMACY_COEF);
    if (isExist and  isExistAlt) then

      if GetHeroCreatures(mainHeroName, wizardId) >= GetHeroCreatures(mainHeroName, altWizardId) then
        AddHeroCreatures(mainHeroName, wizardId, resultCount);
      else
        AddHeroCreatures(mainHeroName, altWizardId, resultCount);
      end;
      return nil
    end;
    
    if isExist then
      AddHeroCreatures(mainHeroName, wizardId, resultCount);
      return nil
    end;
    
    if isExistAlt then
      AddHeroCreatures(mainHeroName, altWizardId, resultCount);
      return nil
    end;
  end;

end;

-- Лесной лидер
function perkFeatForestGuardEmblem(heroName)
  print "perkFeatForestGuardEmblem"
  local BONUS_VALUE = 10;

  if (GetHeroCreatures(heroName,  CREATURE_BLADE_SINGER) > 0) then
    AddHeroCreatures(heroName,  CREATURE_BLADE_SINGER, BONUS_VALUE);
  elseif (GetHeroCreatures(heroName, CREATURE_BLADE_JUGGLER) > 0) then
    AddHeroCreatures(heroName, CREATURE_BLADE_JUGGLER, BONUS_VALUE);
  end;
end;

-- Защити всех нас
function perkDefendUsAll(heroName)
  print "perkDefendUsAll"
  local BONUS_VALUE = 30;

  if (GetHeroCreatures(heroName,  CREATURE_GOBLIN_DEFILER) > 0) then
    AddHeroCreatures(heroName,  CREATURE_GOBLIN_DEFILER, BONUS_VALUE);
  elseif (GetHeroCreatures(heroName, CREATURE_GOBLIN) > 0) then
    AddHeroCreatures(heroName, CREATURE_GOBLIN, BONUS_VALUE);
  end;
end;

-- Преданность машин
function perkFeatMarchOfTheMachines(heroName)
  print "perkFeatMarchOfTheMachines"
  local heroLevel = GetHeroLevel(heroName);
  local BONUS_VALUE = 10 + 10 * (floor(heroLevel/10));

  if (GetHeroCreatures(heroName,  CREATURE_OBSIDIAN_GOLEM) > 0) then
    AddHeroCreatures(heroName,  CREATURE_OBSIDIAN_GOLEM, BONUS_VALUE);
  elseif (GetHeroCreatures(heroName, CREATURE_IRON_GOLEM) > 0) then
    AddHeroCreatures(heroName, CREATURE_IRON_GOLEM, BONUS_VALUE);
  end;
end;


-- Власть над машинами
function perkFeatRemoveControl(heroName)
  print "perkFeatRemoveControl"

  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;
  local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

  local warMachinesTable = {};
  
  --проверка на наличия боевых машин
  for machineId = 1, 4 do
    if HasHeroWarMachine(opponentHeroName, machineId) and machineId ~= 2 then
      warMachinesTable[length(warMachinesTable) + 1] = machineId;
    end;
    
    --выдача балисты
    if length(warMachinesTable) == 0 then
      GiveHeroWarMachine(opponentHeroName, 1);
    end;
    
  end;

end;

-- Обитаемые шахты
function perkMineDeath(heroName)
  print "perkMineDeath"
  local BONUS_VALUE = 5;
  local ghostNum = GetHeroCreatures(heroName,  CREATURE_GHOST) + GetHeroCreatures(heroName, CREATURE_POLTERGEIST)

    ChangeHeroStat(heroName, STAT_KNOWLEDGE, 50);
    ChangeHeroStat(heroName, STAT_MANA_POINTS, (ghostNum/BONUS_VALUE));
    ChangeHeroStat(heroName, STAT_KNOWLEDGE, -50);

end;

-- Вечное рабство
function perkNoRestForTheWicked(heroName)
  print "perkNoRestForTheWicked"
  local BONUS_VALUE = 90;

  if GetHeroCreatures(heroName, CREATURE_SKELETON) >= GetHeroCreatures(heroName, CREATURE_SKELETON_WARRIOR) then
     AddHeroCreatures(heroName,  CREATURE_SKELETON, BONUS_VALUE);
  else
    AddHeroCreatures(heroName, CREATURE_SKELETON_WARRIOR, BONUS_VALUE);
  end;

end;


-- Запуск скриптовых умений героя
function checkAndRunHeroPerks(playerId)
  print "checkAndRunHeroPerks"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;
  
  
  -- Менторство
  if HasHeroSkill(mainHeroName, HERO_SKILL_MENTORING) then
    skillMentoring(mainHeroName);
  end;

  -- Ученый
  if HasHeroSkill(mainHeroName, PERK_SCHOLAR) then
    perkScholar(playerId);
  end;

  -- Сбор войск
  if HasHeroSkill(mainHeroName, PERK_RECRUITMENT) then
    perkRecruitment(playerId);
  end;
  
    -- Дипломатия
  if HasHeroSkill(mainHeroName, PERK_DIPLOMACY) then
    perkDiplomacy(playerId);
  end;
  
    -- Вечное рабство
  if HasHeroSkill(mainHeroName, PERK_NO_REST_FOR_THE_WICKED) then
    perkNoRestForTheWicked(mainHeroName);
  end;
  
  -- Преданность машин (выдача големов)
  if HasHeroSkill(mainHeroName, WIZARD_FEAT_ARTIFICIAL_GLORY) then
    perkFeatMarchOfTheMachines(mainHeroName);
  end;
  
  -- Власть над машинами
  if HasHeroSkill(mainHeroName, WIZARD_FEAT_REMOTE_CONTROL) then
    perkFeatRemoveControl(mainHeroName);
  end;
  
  -- Лесной лидер
  if HasHeroSkill(mainHeroName, RANGER_FEAT_FOREST_GUARD_EMBLEM) then
    perkFeatForestGuardEmblem(mainHeroName);
  end;
  
  -- Защити нас всех
  if HasHeroSkill(mainHeroName, HERO_SKILL_DEFEND_US_ALL) then
    perkDefendUsAll(mainHeroName);
  end;

  -- Сумерки
  if HasHeroSkill(mainHeroName, NECROMANCER_FEAT_TWILIGHT) then
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, 5);
    ChangeHeroStat(mainHeroName, STAT_MANA_POINTS, 30);
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, -5);
  end;
  
  -- Тайный ритуал
  if HasHeroSkill(mainHeroName, PERK_DARK_RITUAL) then

    local dictHeroName = getDictionaryHeroName(mainHeroName);

    local manaBonus = dictHeroName == HEROES.ALMEGIR and 80 or 40;
  
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, 8);
    ChangeHeroStat(mainHeroName, STAT_MANA_POINTS, manaBonus);
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, -8);
  end;

  -- сопротивление
  if HasHeroSkill(mainHeroName, WIZARD_FEAT_SEAL_OF_PROTECTION) then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_HITPOINTS, 10);
  end;

  -- выносливость
  if HasHeroSkill(mainHeroName, HERO_SKILL_BODYBUILDING) then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_HITPOINTS, 5);
  end;

  -- мародерство
  if HasHeroSkill(mainHeroName, HERO_SKILL_SNATCH) then

    GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_SPEED, -1);
  end;

  -- родные земли
  if HasHeroSkill(mainHeroName, KNIGHT_FEAT_ROAD_HOME) then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_SPEED, 1);
  end;

  -- сила против магии
  if HasHeroSkill(mainHeroName, HERO_SKILL_MIGHT_OVER_MAGIC) then
    ChangeHeroStat(mainHeroName, STAT_SPELL_POWER, 2);
    if frac(GetHeroStat(mainHeroName, STAT_SPELL_POWER) / 2) == 0.5 then
      ChangeHeroStat(mainHeroName, STAT_SPELL_POWER, 1);
    end;
  end;
  
    -- Обитаемые шахты
  if HasHeroSkill(mainHeroName, DEMON_FEAT_EXPLODING_CORPSES) then
    perkMineDeath(mainHeroName);
  end;

  -- чувство стихий
  if HasHeroSkill(mainHeroName, NECROMANCER_FEAT_ABSOLUTE_FEAR) then
    local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

    SetTownBuildingLimitLevel(townName, TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS, 1);
    UpgradeTownBuilding(townName, TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS);
  end;

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local leadershipLevel = GetHeroSkillMastery(mainHeroName, SKILL_LEADERSHIP);


  -- некролидерство
--  if raceId == RACES.NECROPOLIS and leadershipLevel > 0 then
--    local opponentPlayerId = PLAYERS_OPPONENT[playerId];
--    local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;
--    local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;
--
--    local opponentLeadershipLevel = GetHeroSkillMastery(opponentHeroName, SKILL_LEADERSHIP);
--
--    if opponentLeadershipLevel > 0 and leadershipLevel >= opponentLeadershipLevel then
--      GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_MORALE, 0 - opponentLeadershipLevel);
--    end;
--
--    if opponentLeadershipLevel > 0 and leadershipLevel < opponentLeadershipLevel then
--      GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_MORALE, 0 - leadershipLevel);
--    end;
--  end;
  

  -- управление машинами
  if GetHeroSkillMastery(mainHeroName, SKILL_WAR_MACHINES) > 0 then
    GiveHeroWarMachine(mainHeroName, WAR_MACHINE_BALLISTA);
    GiveHeroWarMachine(mainHeroName, WAR_MACHINE_FIRST_AID_TENT);
    GiveHeroWarMachine(mainHeroName, WAR_MACHINE_AMMO_CART);
    ChangeHeroStat(mainHeroName, STAT_LUCK, -1); ChangeHeroStat(mainHeroName, STAT_LUCK, 1);
  end;
  
  -- ангел-хранитель
--  if HasHeroSkill(mainHeroName, 99) then
--    local ANGEL_MAP = {
--      [CREATURE_ANGEL] = CREATURE_GOBLIN_TRAPPER,
--      [CREATURE_SERAPH] = CREATURE_WAR_UNICORN,
--    };

--    for angelId, superAngelId in ANGEL_MAP do
--      replaceUnitInHero(mainHeroName, angelId, superAngelId);
--    end;
--  end;

  -- солдатская удача
--  if HasHeroSkill(mainHeroName, PERK_LUCKY_STRIKE) then
--    local MAP_UNIT_ON_UNIT_WITH_LUCKY_STRIKE = {
--      [CREATURE_SUCCUBUS_SEDUCER] = CREATURE_IMP,
--      [CREATURE_DEVIL] = CREATURE_FRIGHTFUL_NIGHTMARE,
--      [CREATURE_POLTERGEIST] = CREATURE_SKELETON_ARCHER,
--      [CREATURE_DRYAD] = CREATURE_SPRITE,
--      [CREATURE_SHADOW_MISTRESS] = CREATURE_BLACK_DRAGON,
--      [CREATURE_THANE] = CREATURE_WARLORD,
--      [CREATURE_THUNDER_THANE] = CREATURE_AXE_THROWER,
--      [CREATURE_ANGEL] = CREATURE_ARCHANGEL,
--      [CREATURE_GOBLIN_TRAPPER] = CREATURE_MASTER_GENIE,
--      [CREATURE_STORM_LORD] = CREATURE_ARCH_MAGI,
--    };
--
--    for unitId, unitWithLucky in MAP_UNIT_ON_UNIT_WITH_LUCKY_STRIKE do
--      replaceUnitInHero(mainHeroName, unitId, unitWithLucky);
--    end;
--  end;
  
  -- Заклинания за "Бесшумный преследователь"
  if HasHeroSkill(mainHeroName, RANGER_FEAT_DISGUISE_AND_RECKON) then
    if raceId == RACES.STRONGHOLD then
      TeachHeroSpell(mainHeroName, SPELL_WARCRY_FEAR_MY_ROAR);
    end;

    if raceId == RACES.HAVEN or raceId == RACES.ACADEMY or raceId == RACES.FORTRESS or raceId == RACES.SYLVAN then
      TeachHeroSpell(mainHeroName, SPELL_DEFLECT_ARROWS);
    end;

    if raceId == RACES.DUNGEON or raceId == RACES.INFERNO or raceId == RACES.NECROPOLIS then
      TeachHeroSpell(mainHeroName, SPELL_FORGETFULNESS);
    end;
  end;

  
    --выдача Скорби, Регена, Фантома, Огненной стенки за навык Мудрость при наличии основы нужной школы
  if HasHeroSkill(mainHeroName, PERK_WISDOM) then

    if GetHeroSkillMastery(mainHeroName, SKILL_DARK_MAGIC) > 0 then
      TeachHeroSpell(mainHeroName,SPELL_SORROW);
    end;

    if GetHeroSkillMastery(mainHeroName, SKILL_LIGHT_MAGIC) > 0 then
      TeachHeroSpell(mainHeroName,SPELL_REGENERATION);
    end;

    if GetHeroSkillMastery(mainHeroName, SKILL_SUMMONING_MAGIC) > 0 then
      TeachHeroSpell(mainHeroName,SPELL_PHANTOM);
    end;

    if GetHeroSkillMastery(mainHeroName, SKILL_DESTRUCTIVE_MAGIC) > 0 then
      TeachHeroSpell(mainHeroName,SPELL_FIREWALL);
    end;
  end;
  
      -- Выдача случайного спела за тайны хаоса
  if HasHeroSkill(mainHeroName, WARLOCK_FEAT_SECRETS_OF_DESTRUCTION) then

    local dontKnowDestructiveSpell = {}
    
    for skillId, skillSpellSet in SPELLS do
      if skillId == TYPE_MAGICS.DESTRUCTIVE then
        for _, spellData in skillSpellSet do
          if spellData.level < 4 then
            if not KnowHeroSpell(mainHeroName, spellData.id) then
             dontKnowDestructiveSpell[length(dontKnowDestructiveSpell) + 1] = spellData.id

            end;
          end;
        end;
      end;
    end;
    
    if length(dontKnowDestructiveSpell) > 0 then
      local spellTeach = dontKnowDestructiveSpell[ random(length(dontKnowDestructiveSpell)) + 1 ]
      TeachHeroSpell(mainHeroName, spellTeach);
    end
    
  end;

     -- Выдача случайного т3 заклинания за Тайное откровение
  if HasHeroSkill(mainHeroName, RANGER_FEAT_INSIGHTS) then
    local dontKnowSpellTier3 = {}
    for skillId, skillSpellSet in SPELLS do
        for _, spellData in skillSpellSet do
          if spellData.level == 3 then
            if not KnowHeroSpell(mainHeroName, spellData.id) then
             dontKnowSpellTier3[length(dontKnowSpellTier3) + 1] = spellData.id
            end;
          end;
        end;
    end;
    if length(dontKnowSpellTier3) > 0 then
      local spellTeach = dontKnowSpellTier3[ random(length(dontKnowSpellTier3)) + 1 ]
      TeachHeroSpell(mainHeroName, spellTeach);
    end

  end;

end;

-- Спеца кигана
function kiganSpec(heroName)
  print "kiganSpec"

  local KIGAN_BY_LVL_COEF = 6;
  local heroLevel = GetHeroLevel(heroName);


  if GetHeroCreatures(heroName, CREATURE_GOBLIN) > 0 then
    AddHeroCreatures(heroName, CREATURE_GOBLIN, KIGAN_BY_LVL_COEF * heroLevel);
  else
    AddHeroCreatures(heroName, CREATURE_GOBLIN_DEFILER, KIGAN_BY_LVL_COEF * heroLevel);
  end;
end;

--Для определения Дьяволов с Солдатки у Орландо (удалено)
function getOrlandoCreature(heroName)
  local creatureDevilsList = {CREATURE_DEVIL, CREATURE_ARCH_DEMON, CREATURE_FRIGHTFUL_NIGHTMARE};
  local maxCountDevilId = nil;
  
  for _, devilId in creatureDevilsList do
    if maxCountDevilId == nil then
      if GetHeroCreatures(heroName, devilId) > 0 then
        maxCountDevilId = devilId
      end
    else
      if GetHeroCreatures(heroName, devilId) > GetHeroCreatures(heroName, maxCountDevilId) then
          maxCountDevilId = devilId
      end;
    end;
  end;

  return maxCountDevilId
end;

-- Спеца Орландо (выдача усиленных дэвилов, с доп хп)
function orlandoSpec(heroName)
  print "orlandoSpec"
  print"dddddddddddddddddddddddddddddddddddddddddddddddddddddd "

    local MAP_REPLACE_UNIT = {
      [27] = 220,
      [137] = 221,
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;

end;

-- Спеца Орландо (удалена)
function orlandoSpecOld(heroName)
  print "orlandoSpecOld"

  local ORLANDO_BONUS_LEVEL = 7;
  local heroLevel = GetHeroLevel(heroName);
  local devilId = getOrlandoCreature(heroName)
  if devilId ~= nil then
    AddHeroCreatures(heroName, devilId, floor(heroLevel)/ORLANDO_BONUS_LEVEL);
  end;
end;

-- Специализация Вайшана
function vaishanSpec(heroName)
  print "vaishanSpec"

  local VAISHAN_BONUS_BY_LEVEL = 2;
  local heroLevel = GetHeroLevel(heroName);

  if GetHeroCreatures(heroName, 92) >= GetHeroCreatures(heroName, 166) then
    AddHeroCreatures(heroName, 92, (10 + heroLevel * VAISHAN_BONUS_BY_LEVEL));
  else
    AddHeroCreatures(heroName, 166, (10 + heroLevel * VAISHAN_BONUS_BY_LEVEL));
  end;
end;

-- Старая Специализация Нархиза (удалена)
function narhizSpecOld(heroName)
  print "narhizSpec"

  local NARHIZ_BY_LVL_COEF = 0.34;
  local heroLevel = GetHeroLevel(heroName);

  if GetHeroCreatures(heroName, CREATURE_MAGI) >= GetHeroCreatures(heroName, CREATURE_COMBAT_MAGE) then
    AddHeroCreatures(heroName, CREATURE_MAGI, floor(heroLevel * NARHIZ_BY_LVL_COEF));
  else
    AddHeroCreatures(heroName, CREATURE_COMBAT_MAGE, floor(heroLevel * NARHIZ_BY_LVL_COEF));
  end;
end;

-- Специализация Эрин
function eruinaSpec(heroName)
  print "eruinaSpec"

  local ERUINA_BONUS_BY_LEVEL = 0.1;
  local heroLevel = GetHeroLevel(heroName);

  if GetHeroCreatures(heroName, 81) >= GetHeroCreatures(heroName, 143) then
    AddHeroCreatures(heroName, 81, floor(heroLevel * ERUINA_BONUS_BY_LEVEL) + 1);
  else
    AddHeroCreatures(heroName, 143, floor(heroLevel * ERUINA_BONUS_BY_LEVEL) + 1);
  end;
end;

-- Специализация Инги
function specInga(heroName)
  print "specInga"
  
  -- За сколько уровней ИНГА учит руну
  local ingaLevel = GetHeroLevel(heroName);

    -- Формируем итоговый список рун для изучения
    local teachRuneTableOneTwo = {250,249,252,251};
    local teachRuneTableThree = {250,249,253,256,252,251};
    local teachRuneTableFour = {250,249,253,256,252,251,254,258};

    -- Обучаем героя новым рунам
    for _, RuneId in teachRuneTableOneTwo do
      TeachHeroSpell(heroName, RuneId);
    end;
    
    
--    if ingaLevel > 19 then
--      for _, RuneId in teachRuneTableThree do
--        TeachHeroSpell(heroName, RuneId);
--      end;
--    end;
--    if ingaLevel > 29 then
--      for _, RuneId in teachRuneTableFour do
--        TeachHeroSpell(heroName, RuneId);
--      end;
--    end;


end;

-- Отслеживание спецы Валерия
function specValeriaTread(heroName)
  print "specValeriaTread"

  local MAP_SPELLS_ON_MASS_SPELLS = {
    [SPELL_CURSE] = SPELL_MASS_CURSE,
    [SPELL_SLOW] = SPELL_MASS_SLOW,
    [SPELL_DISRUPTING_RAY] = SPELL_MASS_DISRUPTING_RAY,
    [SPELL_PLAGUE] = SPELL_MASS_PLAGUE,
    [SPELL_WEAKNESS] = SPELL_MASS_WEAKNESS,
    [SPELL_FORGETFULNESS] = SPELL_MASS_FORGETFULNESS,
  };

  if GetHeroSkillMastery(heroName, SKILL_DARK_MAGIC) > 0 then
    for spellId, massSpellId in MAP_SPELLS_ON_MASS_SPELLS do
      if KnowHeroSpell(heroName, spellId) then
        TeachHeroSpell(heroName, massSpellId);
      end;
    end;
  end;
end;

-- Запуск скриптовых специализаций героев
function runHeroSpecialization(playerId)
  print "runHeroSpecialization"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);
--здесь проблема с переопределением героя после замены
  -- Инга
  if dictHeroName == HEROES.UNA then
    specInga(mainHeroName);
  end;
  
  -- Валерия
  if dictHeroName == HEROES.RED_HEAVEN_HERO then
    specValeriaTread(mainHeroName);
  end;

  -- Киган
  if dictHeroName == HEROES.KIGAN then
    kiganSpec(mainHeroName);
  end;

  print(dictHeroName)
  print(mainHeroName)
  -- Орландо
--  if dictHeroName == HEROES.ORLANDO then
--    orlandoSpec(mainHeroName);
--  end;
  
  -- Вайшан
  if dictHeroName == HEROES.VAYSHAN then
    vaishanSpec(mainHeroName);
  end;
  
  -- Эрин
  if dictHeroName == HEROES.ERUINA then
    eruinaSpec(mainHeroName);
  end;
  
  -- Таланар
  if dictHeroName == HEROES.NADAUR then
    local MAP_REPLACE_UNIT = {
      [45] = 46,
      [146] = 18,
      [47] = 48,
      [147] = 20,
      [49] = 50,
      [148] = 22,
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;
  end;

  -- Файдаэн
  if dictHeroName == HEROES.HEAM then
    local MAP_REPLACE_UNIT = {
      [47] = 62,
      [147] = 76,
      [49] = 72,
      [148] = 74,
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;
  end;
  
  -- Дункан
  if dictHeroName == HEROES.DUNCAN then
    local MAP_REPLACE_UNIT = {
      [3] = 4,
      [107] = 4,
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;
  end;


  -- Соргал
  if dictHeroName == HEROES.FERIGL then
    local MAP_REPLACE_UNIT = {
      [77] = 200 + ceil(0.5 * (GetHeroLevel(mainHeroName) - FREE_LEARNING_LEVEL)),
      [141] = 210 + ceil(0.5 * (GetHeroLevel(mainHeroName) - FREE_LEARNING_LEVEL)),
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;
  end;

  -- Вульфстен
  if dictHeroName == HEROES.WULFSTAN then
    local MAP_REPLACE_UNIT = {
      [98] = 99,
      [169] = 80,
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;
  end;
  
    -- Аларик
  if dictHeroName == HEROES.ALARIC then
    local MAP_REPLACE_UNIT = {
      [9] = CREATURE_OBSIDIAN_GARGOYLE,
      [110] = CREATURE_ARCH_MAGI,
    };

    for unitId, replaceUnitId in MAP_REPLACE_UNIT do
      replaceUnitInHero(mainHeroName, unitId, replaceUnitId);
    end;
  end;

  -- Грок
  if dictHeroName == HEROES.GROK then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_SPEED, 1);
  end;

  -- Марбас
  if dictHeroName == HEROES.MARDER then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_HITPOINTS, round(0.35 * GetHeroLevel(mainHeroName)));
  end;

  -- Куджин
  if dictHeroName == HEROES.KUJIN then
    local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

    UpgradeTownBuilding(townName, TOWN_BUILDING_STRONGHOLD_PILE_OF_OUR_FOES);
  end;
end;

-- Бонус с короны лидерства
function crownOfLeader(heroName)
  print "crownOfLeader"

  local CROWN_OF_LEADER_BONUS = 1;
  local units = {};
  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  units[1], units[2], units[3], units[4], units[5], units[6], units[7] = GetHeroCreaturesTypes(heroName);

  local SPECIAL_UNIT_LIST = {
    CREATURE_FRIGHTFUL_NIGHTMARE, -- Архдьявол с солдаткой
    CREATURE_ARCHANGEL, -- Арх с солдаткой
    CREATURE_GOBLIN_TRAPPER, -- Арх с Хранителя
    CREATURE_MASTER_GENIE, -- Арх с Хранителя с солдаткой
    CREATURE_ARCH_MAGI, -- Шторм с солдаткой
    CREATURE_WAR_UNICORN --Серафим с солдаткой
  };

  local unitsNotRepeat = {};

  for _, unitId in units do
    local countRepeat = 0;
    
    if unitId > 0 then
       for _, unitNotRepeatId in unitsNotRepeat do
         if unitNotRepeatId == unitId then
           countRepeat = countRepeat + 1;
         end;
       end;
       if countRepeat == 0 then
         unitsNotRepeat[length(unitsNotRepeat)+1] = unitId
       end;
    end;
  end;
  print(unitsNotRepeat)
  for _, unitId in unitsNotRepeat do
    if unitId > 0 then
      local countRepeatSpecial = 0;
      for _, unitData in UNITS[raceId] do
        if unitData.lvl == 7 and unitId == unitData.id then
          countRepeatSpecial = countRepeatSpecial + 1
          AddHeroCreatures(heroName, unitId, CROWN_OF_LEADER_BONUS);
        end;
      end;
       
      for _, specialUnitId in SPECIAL_UNIT_LIST do
        if unitId == specialUnitId and countRepeatSpecial == 0 then
          AddHeroCreatures(heroName, unitId, CROWN_OF_LEADER_BONUS);
        end;
      end;
    end;
  end;
end;

-- Получение существа героем перед боем
function giveCreatureTier(heroName, num, lvl)
  print "giveCreatureTier"

  local units = {};
  local playerId = GetPlayerFilter(GetObjectOwner(heroName));
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  units[1], units[2], units[3], units[4], units[5], units[6], units[7] = GetHeroCreaturesTypes(heroName);


  local unitsNotRepeat = {};

  for _, unitId in units do
    local countRepeat = 0;

    if unitId > 0 then
       for _, unitNotRepeatId in unitsNotRepeat do
         if unitNotRepeatId == unitId then
           countRepeat = countRepeat + 1;
         end;
       end;
       if countRepeat == 0 then
         unitsNotRepeat[length(unitsNotRepeat)+1] = unitId
       end;
    end;
  end;

  for _, unitId in unitsNotRepeat do
    if unitId > 0 then
       for _, unitData in UNITS[raceId] do
         if unitData.lvl == lvl and unitId == unitData.id then
             addUnitInArmy = AddHeroCreatures(heroName, unitId, num);
             return nil
         end;
       end;
    end;
  end;
end;

-- Если у героя есть скриптованные арты - активируем их
function runScriptingArtifacts(playerId)
  print "runScriptingArtifacts"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local raceId = RESULT_HERO_LIST[playerId].raceId;
  
  local opponentPlayerId = PLAYERS_OPPONENT[playerId];
  local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;
  local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

  -- Корона Лидерства
  if HasArtefact(mainHeroName, ARTIFACT_CROWN_OF_LEADER, 1) then
    crownOfLeader(mainHeroName);
  end;

  -- посох преисподней
  if HasArtefact(mainHeroName, 7, 1) then
    GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_INITIATIVE, -1);
  end;

  -- воля ургаша
  if raceId == RACES.INFERNO and HasArtefact(mainHeroName, ARTIFACT_NIGHTMARISH_RING, 1) and HasArtefact(mainHeroName, ARTIFACT_HELM_OF_CHAOS, 1) then
    local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

    UpgradeTownBuilding(townName, TOWN_BUILDING_INFERNO_INFERNAL_LOOM);
  end;

  -- сет объятия смерти
  if HasArtefact(mainHeroName, 7, 1) and HasArtefact(mainHeroName, 33, 1) then
    GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_SPEED, -1);
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_SPEED, -1);
  end;

  -- свиток маны
  if HasArtefact(mainHeroName, 10, 1) then
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, 50);
    ChangeHeroStat(mainHeroName, STAT_MANA_POINTS, 25);
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, -50);
  end;

  -- кольцо грешников
  if HasArtefact(mainHeroName, 70, 1) then
    local artCount = GetHeroArtifactsCount(mainHeroName, 70, 1);

    GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_LUCK, -(artCount*3));
  end;

  -- Сет гномов
  local countDwarfSet = GetArtifactSetItemsCount(mainHeroName, 5, 1);

  if countDwarfSet > 1 then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_HITPOINTS, 10 * (countDwarfSet-1));

  end;
  
  -- Сет дракона
  local countDragfSet = GetArtifactSetItemsCount(mainHeroName, ARTIFACT_SET_DRAGONISH, 1);

  if countDragfSet > 7 then
    giveCreatureTier(mainHeroName, 3, 7);

  end;
  
    -- Доспех мощи
  if HasArtefact(mainHeroName, 1, 1) and HasArtefact(mainHeroName, 14, 1) then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_HITPOINTS, 4);
  end;
  
end;


-- Механическая подготовка и запуск битвы
function runBattle()
  print "runBattle"
  
  local p1MainHeroName = PLAYERS_MAIN_HERO_PROPS[PLAYER_1].name;
  local p2MainHeroName = PLAYERS_MAIN_HERO_PROPS[PLAYER_2].name;
  
  local choisePlayerId = getSelectedBattlefieldPlayerId();

  -- Прогружаем боевые только у красного игрока скрипты
  StartCombat(PLAYERS_MAIN_HERO_PROPS[PLAYER_1].name, nil, 1, 1, 1, '/scripts/RTA_TestExecutionThread.(Script).xdb#xpointer(/Script)')

  sleep(5);

  saveHeroesInfoInToBattle();
  generateSeed();

  checkAndMoveHeroFromFrendlyField();

  sleep(5);
  
  -- ASHA
  local MapVersion = '1.29b';
  
  if CUSTOM_GAME_MODE_NO_MENTOR == 1 then
    MapVersion = MapVersion..'_no_mentor'
  end;
  
  local customData = {
    ["Hero1_StartBonus"] = PLAYER_STARTED_BONUSES[PLAYER_1],
    ["Hero2_StartBonus"] = PLAYER_STARTED_BONUSES[PLAYER_2],
    ["Hero1_Mentoring"] = MENTOR_USAGE_COUNTER.players_value[PLAYER_1],
    ["Hero2_Mentoring"] = MENTOR_USAGE_COUNTER.players_value[PLAYER_2],
    -- Скорее всего нужно добавить генерацию уникальных id с сайта для регистрации карт
    -- Во избежания использования библиотеки злоумышленниками для незарегистрированных карт
    ["MapType"] = 'HRTA',
    ["MapVersion"] = MapVersion,

  };

  composeHeroesDataBeforeFight(p1MainHeroName, p2MainHeroName);
  composeCustomData(customData);
  Trigger(COMBAT_RESULTS_TRIGGER, 'composeDataAfterBattle');
  -- ASHA

  while IsHeroAlive(p1MainHeroName) and IsHeroAlive(p2MainHeroName) do
    if choisePlayerId == PLAYER_2 then
      MakeHeroInteractWithObject(p1MainHeroName, p2MainHeroName);
    else
      MakeHeroInteractWithObject(p2MainHeroName, p1MainHeroName);
    end;

    sleep(10);
  end;
end;

-- Проверяем ход героя (хотсит) и убираем у него мувы
function removeMainHeroMovePoints(playerId)
  while HOTSEAT_STATUS and GetCurrentPlayer() ~= playerId do sleep() end;
  
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  
  removeHeroMovePoints(mainHeroName);
end;



function startBattle()
  print "startBattle"

  for _, playerId in PLAYER_ID_TABLE do
    startThread(removeMainHeroMovePoints, playerId);
  end;

  for _, playerId in PLAYER_ID_TABLE do
    refreshPlayerMana(playerId);

    teachMainHeroSpells(playerId);

    checkAndRunHeroPerks(playerId);

    runHeroSpecialization(playerId);

    runScriptingArtifacts(playerId);
  end;
  
  runBattle();
end;