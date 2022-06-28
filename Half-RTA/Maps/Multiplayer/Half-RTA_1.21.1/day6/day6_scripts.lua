
PATH_TO_DAY6_SCRIPTS = GetMapDataPath().."day6/";

doFile(PATH_TO_DAY6_SCRIPTS.."day6_constants.lua");
sleep(1);

-- Имеется ли заклинание в текущем наборе игрока
function getSpellHasInPlayerSet(playerId, spellId)
  print "getSpellHasInPlayerSet"

  -- Номер набора заклинаний
  local spellSetNumber = mod(PLAYERS_GENERATED_SPELLS[playerId].countResetSpells, 2) + 1;
  local spellSet = PLAYERS_GENERATED_SPELLS[playerId].spells[spellSetNumber];

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
  local runesSetNumber = mod(PLAYERS_GENERATED_SPELLS[playerId].countResetRunes, 2) + 1;
  local runesSet = PLAYERS_GENERATED_SPELLS[playerId].runes[runesSetNumber];

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

-- Замена определенного существа в герое на другое
function replaceUnitInHero(heroName, targetUnitId, replaceUnitId)
  print "replaceUnitInHero"

  local countGenie = GetHeroCreatures(heroName, targetUnitId);

  if countGenie > 0 then
    RemoveHeroCreatures(heroName, targetUnitId, countGenie);
    -- ID изменено на ID джинов с неосязаемостью >_<
    AddHeroCreatures(heroName, replaceUnitId, countGenie);
  end;
end;

-- Передача всего имеющегося у героя новому
-- В этой функции ваще влом избавляться от магических цифр
function replaceMainHero(playerId, newHeroName)
  print "replaceMainHero"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

  -- Навыки
  local stashSkills = {};

  for indexSkill, skillId in ALL_SKILLS_TABLE do
    stashSkills[indexSkill] = GetHeroSkillMastery(mainHeroName, skillId);
  end;

  -- Умения
  local mainHeroPerksTable = {};

  for _, perkId in ALL_PERKS_TABLE do
    if HasHeroSkill(mainHeroName, perkId) then
      mainHeroPerksTable[length(mainHeroPerksTable) + 1] = perkId;
    end;
  end;

  -- Артефакты
  local mainHeroArtsTable = {};

  for _, artData in ALL_ARTS_LIST do
    if HasArtefact(mainHeroName, artData.id) then
      mainHeroArtsTable[length(mainHeroArtsTable) - 1] = artData.id;
    end;
  end;

  -- Существа
  local stashUnits = {
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
    { id = 0, kol = 0},
  };

  stashUnits[1].id, stashUnits[2].id, stashUnits[3].id, stashUnits[4].id, stashUnits[5].id, stashUnits[6].id, stashUnits[7].id = GetHeroCreaturesTypes(mainHeroName);

  for _, unit in stashUnits do
    if unit.id > 0 then
      unit.kol = GetHeroCreatures(mainHeroName, unit.id);
    end;
  end;

  -- Машинки
  local warMachinesTable = {};

  for machineId = 1, 4 do
    if HasHeroWarMachine(mainHeroName, machineId) and machineId ~= 2 then
      warMachinesTable[length(warMachinesTable) + 1] = machineId;
    end;
  end;

  -- Показываем фокусы с заменой героя
  local x, y = GetObjectPosition(mainHeroName);
  local heroExp = GetHeroStat(mainHeroName, STAT_EXPERIENCE);

  RemoveObject(mainHeroName);
  DeployReserveHero(newHeroName, x, y, GROUND);
  Trigger(HERO_ADD_SKILL_TRIGGER, newHeroName, 'noop');
  WarpHeroExp(newHeroName, heroExp);

  -- Обучаем навыкам
  for skillId, skillMastery in stashSkills do
    if skillMastery > 0 then
      for i = 1, skillMastery do
        GiveHeroSkill(newHeroName, skillId);
      end;
    end;
  end;

  -- Обучаем умениям
  for _, perkId in mainHeroPerksTable do
    GiveHeroSkill(newHeroName, perkId);

    if perkId == RANGER_FEAT_FOREST_GUARD_EMBLEM and GetHeroCreatures(newHeroName, CREATURE_BLADE_SINGER) > 0 then
      RemoveHeroCreatures(newHeroName, CREATURE_BLADE_SINGER, 10);
    end;
    if perkId == HERO_SKILL_DEFEND_US_ALL and GetHeroCreatures(newHeroName, CREATURE_GOBLIN_DEFILER) > 0 then
      RemoveHeroCreatures(newHeroName, CREATURE_GOBLIN_DEFILER, 15);
    end;
  end;

  -- Передаем армию
  for index, unit in stashUnits do
    if unit.id > 0 then
      AddHeroCreatures(newHeroName, unit.id, unit.kol);

      local countAirElem = GetHeroCreatures(newHeroName, CREATURE_AIR_ELEMENTAL);

      if countAirElem > 0 then
        RemoveHeroCreatures(newHeroName, CREATURE_AIR_ELEMENTAL, countAirElem);
      end;
    end;
  end;

  -- Передаем арты
  for _, artId in mainHeroArtsTable do
    GiveArtefact(newHeroName, artId);
  end;

  -- Машинки
  for _, machineId in warMachinesTable do
    GiveHeroWarMachine(newHeroName, machineId);
  end;

  -- Производим подмену в свойствах
  PLAYERS_MAIN_HERO_PROPS[playerId].name = newHeroName;

  refreshMainHeroStats(playerId);
end;

-- Замена обычного героя на героя с рташными особенностями
function replaceHeroOnSpecial(playerId)
  print "replaceHeroOnSpecial"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  -- Аларон
  if dictHeroName == HEROES.ILDAR then
    local lightMagicLevel = GetHeroSkillMastery(mainHeroName, SKILL_LIGHT_MAGIC);

    if lightMagicLevel == 3 then
      local PLAYERS_SUPER_EXPERT_HERO = {
        [PLAYER_1] = "Ildar3",
        [PLAYER_2] = "Ildar4",
      };

      replaceMainHero(playerId, PLAYERS_SUPER_EXPERT_HERO[playerId]);
    end;

    if lightMagicLevel < 3 and lightMagicLevel > 0 then
      Trigger(HERO_ADD_SKILL_TRIGGER, mainHeroName, 'noop');
      GiveHeroSkill(mainHeroName, SKILL_LIGHT_MAGIC);
    end;
  end;

  -- Рутгер
  if dictHeroName == HEROES.BREM then
    local trainingLevel = GetHeroSkillMastery(mainHeroName, SKILL_TRAINING);

    if trainingLevel == 3 then
      local PLAYERS_SUPER_EXPERT_HERO = {
        [PLAYER_1] = "Brem3",
        [PLAYER_2] = "Brem4",
      };

      replaceMainHero(playerId, PLAYERS_SUPER_EXPERT_HERO[playerId]);
    end;

    if trainingLevel < 3 and trainingLevel > 0 then
      Trigger(HERO_ADD_SKILL_TRIGGER, mainHeroName, 'noop');
      GiveHeroSkill(mainHeroName, SKILL_TRAINING);
    end;
  end;

  -- Илайя
  if dictHeroName == HEROES.SHADWYN then
    local invocationLevel = GetHeroSkillMastery(mainHeroName, SKILL_INVOCATION);

    if invocationLevel == 3 then
      local PLAYERS_SUPER_EXPERT_HERO = {
        [PLAYER_1] = "Shadwyn3",
        [PLAYER_2] = "Shadwyn4",
      };

      replaceMainHero(playerId, PLAYERS_SUPER_EXPERT_HERO[playerId]);
    end;

    if invocationLevel < 3 and invocationLevel > 0 then
      Trigger(HERO_ADD_SKILL_TRIGGER, mainHeroName, 'noop');
      GiveHeroSkill(mainHeroName, SKILL_INVOCATION);
    end;
  end;
end;

-- Замена обычных существ на существ с рташными особенностями
-- Тут такие приколы с ID существ накручено, мое увожение >_<
function replaceCommonUnitOnSpecial(playerId)
  print "replaceCommonUnitOnSpecial"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  -- Джалиб
  if dictHeroName == HEROES.TAN then
    replaceUnitInHero(mainHeroName, CREATURE_GENIE, CREATURE_RAKSHASA_RUKH);
    replaceUnitInHero(mainHeroName, CREATURE_DJINN_VIZIER, CREATURE_TITAN);
  end;

  -- солдатская удача
  if HasHeroSkill(mainHeroName, PERK_LUCKY_STRIKE) then
    replaceUnitInHero(mainHeroName, CREATURE_GREMLIN, CREATURE_OBSIDIAN_GARGOYLE);
    replaceUnitInHero(mainHeroName, CREATURE_STORM_LORD, CREATURE_ARCH_MAGI);
  end;

  -- фикс бага с грифонами (Когда приземляется за поле боя)
  replaceUnitInHero(mainHeroName, CREATURE_GRIFFIN, CREATURE_ROYAL_GRIFFIN);
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

  local dictHeroName = getDictionaryHeroName(mainHeroName);

  -- TODO: Чет инга не изучает свои рунки
  -- Отдаем Инге ее рунки
  if dictHeroName == HEROES.UNA then
    local ingaRunes = PLAYERS_GENERATED_SPELLS[playerId].ingaRunes;

    for _, runeId in ingaRunes do
      TeachHeroSpell(mainHeroName, runeId);
    end;
  end;

  -- Заклы как стартовый бонус
  local bonusSpells = PLAYERS_GENERATED_SPELLS[playerId].bonus_spells;

  print "bonusSpells"
  print (bonusSpells)

  for _, spellData in bonusSpells do
    TeachHeroSpell(mainHeroName, spellData.id);
  end;
end;

-- Проверяем, не находится ли герой на запрещенке
function checkNeedAutoTransferHero()
  print "checkNeedAutoTransferHero"

  local activePlayerId = getSelectedBattlefieldPlayerId();
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[activePlayerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  if HasHeroSkill(mainHeroName, PERK_PATHFINDING) == nil and dictHeroName ~= HEROES.JAZAZ then
    -- Добавить передвижение героя на
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
    if raceId ~= RACES.NEUTRAL and raceId ~= player1RaceId and raceId ~= player2RaceId then
      resultRaceIdTable[length(resultRaceIdTable)] = raceId;
    end;
  end;

  local randomIndex = random(length(resultRaceIdTable)) + 1;

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

  -- С нахождением пути можно безобразничать как угодно
  if HasHeroSkill(choiseHeroName, PERK_PATHFINDING) then
    return nil;
  end;

  for raceId, raceRegion in MAP_RACE_ON_NATIVE_REGIONS do
    if IsObjectInRegion(choiseHeroName, raceRegion) and choisePlayerRaceId == raceId then
      local randomRaceId = getOtherRandomRaceId();
      local raceFieldPosition = RACE_ON_FRENDLY_FIELD_POSITION[randomRaceId];

      MoveHeroRealTime(choiseHeroName, raceFieldPosition.x, raceFieldPosition.y);

      return nil;
    end;
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

-- Ученый (Дает все заклинания 1-2 уровней, известные оппоненту)
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

  for _, customSkillId in MAGIC_SCHOOL_TABLE do
    local skillSpellSet = SPELLS[customSkillId];

    for _, spellData in skillSpellSet do
      if spellData.level < 3 and KnowHeroSpell(opponentHeroName, spellData.id) then
        TeachHeroSpell(mainHeroName, spellData.id);
      end
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

-- Запуск скриптовых умений героя
function checkAndRunHeroPerks(playerId)
  print "checkAndRunHeroPerks"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;

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

  -- Сумерки
  if HasHeroSkill(mainHeroName, NECROMANCER_FEAT_TWILIGHT) then
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, 5);
    ChangeHeroStat(mainHeroName, STAT_MANA_POINTS, 30);
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, -5);
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
    local opponentPlayerId = PLAYERS_OPPONENT[playerId];
    local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

    GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_SPEED, -1);
  end;

  -- родные земли
  if HasHeroSkill(mainHeroName, KNIGHT_FEAT_ROAD_HOME) then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_SPEED, 1);
  end;

  -- сила против магии
  if HasHeroSkill(mainHeroName, HERO_SKILL_MIGHT_OVER_MAGIC) then
    if frac(GetHeroStat(mainHeroName, STAT_SPELL_POWER) / 2) == 0.5 then
      ChangeHeroStat(mainHeroName, STAT_SPELL_POWER, 1);
    end;
  end;

  -- лесное коварство
  if HasHeroSkill(mainHeroName, RANGER_FEAT_CUNNING_OF_THE_WOODS) then
    local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

    UpgradeTownBuilding(townName, TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
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
  if raceId == RACES.NECROPOLIS and leadershipLevel > 0 then
    local opponentPlayerId = PLAYERS_OPPONENT[playerId];
    local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;
    local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

    local opponentLeadershipLevel = GetHeroSkillMastery(opponentHeroName, SKILL_LEADERSHIP);

    if opponentLeadershipLevel > 0 and leadershipLevel >= opponentLeadershipLevel then
      GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_MORALE, 0 - opponentLeadershipLevel);
    end;

    if opponentLeadershipLevel > 0 and leadershipLevel < opponentLeadershipLevel then
      GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_MORALE, 0 - leadershipLevel);
    end;
  end;

  -- управление машинами
  if GetHeroSkillMastery(mainHeroName, SKILL_WAR_MACHINES) > 0 then
    GiveHeroWarMachine(mainHeroName, WAR_MACHINE_BALLISTA);
    GiveHeroWarMachine(mainHeroName, WAR_MACHINE_FIRST_AID_TENT);
    GiveHeroWarMachine(mainHeroName, WAR_MACHINE_AMMO_CART);
  end;

  -- ангел-хранитель
  if HasHeroSkill(mainHeroName, KNIGHT_FEAT_GUARDIAN_ANGEL) then
    local ANGEL_MAP = {
      [CREATURE_ANGEL] = CREATURE_GOBLIN_TRAPPER,
      [CREATURE_SERAPH] = CREATURE_WAR_UNICORN,
    };

    for angelId, superAngelId in ANGEL_MAP do
      replaceUnitInHero(mainHeroName, angelId, superAngelId);
    end;
  end;

  -- солдатская удача
  if HasHeroSkill(mainHeroName, PERK_LUCKY_STRIKE) then
    local MAP_UNIT_ON_UNIT_WITH_LUCKY_STRIKE = {
      [CREATURE_SUCCUBUS_SEDUCER] = CREATURE_IMP,
      [CREATURE_DEVIL] = CREATURE_FRIGHTFUL_NIGHTMARE,
      [CREATURE_POLTERGEIST] = CREATURE_SKELETON_ARCHER,
      [CREATURE_DRYAD] = CREATURE_SPRITE,
      [CREATURE_STONE_DEFENDER] = CREATURE_STOUT_DEFENDER,
      [CREATURE_SHADOW_MISTRESS] = CREATURE_BLACK_DRAGON,
      [CREATURE_THANE] = CREATURE_WARLORD,
      [CREATURE_THUNDER_THANE] = CREATURE_AXE_THROWER,
      [CREATURE_ANGEL] = CREATURE_ARCHANGEL,
      [CREATURE_GOBLIN_TRAPPER] = CREATURE_MASTER_GENIE,
    };

    for unitId, unitWithLucky in MAP_UNIT_ON_UNIT_WITH_LUCKY_STRIKE do
      replaceUnitInHero(mainHeroName, unitId, unitWithLucky);
    end;
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

-- Спеца Орландо
function orlandoSpec(heroName)
  print "orlandoSpec"

  local ORLANDO_BONUS_BY_LEVEL = 0.1;
  local heroLevel = GetHeroLevel(heroName);

  if GetHeroCreatures(heroName, CREATURE_DEVIL) >= GetHeroCreatures(heroName, CREATURE_ARCH_DEMON) then
    AddHeroCreatures(heroName, CREATURE_DEVIL, 1 + floor(heroLevel * ORLANDO_BONUS_BY_LEVEL));
  else
    AddHeroCreatures(heroName, CREATURE_ARCH_DEMON, 1 + floor(heroLevel * ORLANDO_BONUS_BY_LEVEL));
  end;
end;

-- Запуск скриптовых специализаций героев
function runHeroSpecialization(playerId)
  print "runHeroSpecialization"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local dictHeroName = getDictionaryHeroName(mainHeroName);

  -- Киган
  if dictHeroName == HEROES.KIGAN then
    kiganSpec(mainHeroName);
  end;

  -- Орландо
  if dictHeroName == HEROES.ORLANDO then
    orlandoSpec(mainHeroName);
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

  -- Эрин
  if dictHeroName == HEROES.ERUINA then
    local MAP_REPLACE_UNIT = {
      [81] = 82,
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

  -- Грок
  if dictHeroName == HEROES.GROK then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_SPEED, 1);
  end;

  -- Марбас
  if dictHeroName == HEROES.MARDER then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_HITPOINTS, round(0.4 * GetHeroLevel(mainHeroName)));
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

  units[1], units[2], units[3], units[4], units[5], units[6], units[7] = GetHeroCreaturesTypes(heroName);

  for _, unitId in units do
    if unitId > 0 then
      AddHeroCreatures(heroName, unitId, CROWN_OF_LEADER_BONUS);
    end;
  end;
end;

-- Если у героя есть скриптованные арты - активируем их
function runScriptingArtifacts(playerId)
  print "runScriptingArtifacts"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local raceId = RESULT_HERO_LIST[playerId].raceId;

  -- Корона Лидерства
  if HasArtefact(mainHeroName, ARTIFACT_CROWN_OF_LEADER, 1) then
    crownOfLeader(mainHeroName);
  end;

  -- посох преисподней
  if HasArtefact(mainHeroName, 7, 1) then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_INITIATIVE, -1);
  end;

  -- воля ургаша
  if raceId == RACES.INFERNO and HasArtefact(mainHeroName, ARTIFACT_NIGHTMARISH_RING, 1) and HasArtefact(mainHeroName, ARTIFACT_HELM_OF_CHAOS, 1) then
    local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

    UpgradeTownBuilding(townName, TOWN_BUILDING_INFERNO_INFERNAL_LOOM);
  end;

  -- объятия смерти
  if HasArtefact(mainHeroName, 7, 1) and HasArtefact(mainHeroName, 33, 1) then
    local MAP_RACE_ON_PRIMARY_STAT = {
      [RACES.HAVEN] = STAT_ATTACK,
      [RACES.INFERNO] = STAT_ATTACK,
      [RACES.NECROPOLIS] = STAT_DEFENCE,
      [RACES.SYLVAN] = STAT_DEFENCE,
      [RACES.ACADEMY] = STAT_SPELL_POWER,
      [RACES.DUNGEON] = STAT_ATTACK,
      [RACES.FORTRESS] = STAT_DEFENCE,
      [RACES.STRONGHOLD] = STAT_ATTACK,
    };
    local MAP_RACE_ON_SECONDARY_STAT = {
      [RACES.HAVEN] = STAT_DEFENCE,
      [RACES.INFERNO] = STAT_KNOWLEDGE,
      [RACES.NECROPOLIS] = STAT_SPELL_POWER,
      [RACES.SYLVAN] = STAT_KNOWLEDGE,
      [RACES.ACADEMY] = STAT_KNOWLEDGE,
      [RACES.DUNGEON] = STAT_SPELL_POWER,
      [RACES.FORTRESS] = STAT_SPELL_POWER,
      [RACES.STRONGHOLD] = STAT_DEFENCE,
    };

    local opponentPlayerId = PLAYERS_OPPONENT[playerId];
    local opponentRaceId = RESULT_HERO_LIST[opponentPlayerId].raceId;
    local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

    ChangeHeroStat(opponentHeroName, MAP_RACE_ON_PRIMARY_STAT[opponentRaceId], -2);
    ChangeHeroStat(opponentHeroName, MAP_RACE_ON_SECONDARY_STAT[opponentRaceId], -2);
  end;

  -- свиток маны
  if HasArtefact(mainHeroName, 10, 1) then
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, 50);
    ChangeHeroStat(mainHeroName, STAT_MANA_POINTS, 25);
    ChangeHeroStat(mainHeroName, STAT_KNOWLEDGE, -50);
  end;

  -- кольцо грешников
  if HasArtefact(mainHeroName, 70, 1) then
    local opponentPlayerId = PLAYERS_OPPONENT[playerId];
    local opponentHeroName = PLAYERS_MAIN_HERO_PROPS[opponentPlayerId].name;

    local artCount = GetHeroArtifactsCount(mainHeroName, 70, 1);

    GiveHeroBattleBonus(opponentHeroName, HERO_BATTLE_BONUS_LUCK, -artCount);
  end;

  -- Сет гномов
  local countDwarfSet = GetArtifactSetItemsCount(mainHeroName, 5, 1);

  if countDwarfSet > 1 then
    GiveHeroBattleBonus(mainHeroName, HERO_BATTLE_BONUS_HITPOINTS, 5 * countDwarfSet);

    if raceId == RACES.FORTRESS then
      ChangeHeroStat(mainHeroName, STAT_SPELL_POWER, 4);
    end;
  end;
end;

-- Механическая подготовка и запуск битвы
function runBattle()
  print "runBattle"
  
  saveHeroesInfoInToBattle();
  generateSeed();

  consoleCmd("@SetGameVar('execution_thread', '1')");

  checkAndMoveHeroFromFrendlyField();

  local p1MainHeroName = PLAYERS_MAIN_HERO_PROPS[PLAYER_1].name;
  local p2MainHeroName = PLAYERS_MAIN_HERO_PROPS[PLAYER_2].name;

  local choisePlayerId = getSelectedBattlefieldPlayerId();

  while IsHeroAlive(p1MainHeroName) and IsHeroAlive(p2MainHeroName) do
    if choisePlayerId == PLAYER_2 then
      MakeHeroInteractWithObject(p1MainHeroName, p2MainHeroName);
    else
      MakeHeroInteractWithObject(p2MainHeroName, p1MainHeroName);
    end;

    sleep(10);
  end;
end;

-- Точка старта
function day6_scripts()
  print "day6_scripts"

  for _, playerId in PLAYER_ID_TABLE do
    replaceCommonUnitOnSpecial(playerId);
    
    replaceHeroOnSpecial(playerId);
    
    refreshPlayerMana(playerId);

    teachMainHeroSpells(playerId);
    
    checkAndRunHeroPerks(playerId);

    checkAndRunHeroSpec(playerId);

    runScriptingArtifacts(playerId);
  end;

  runBattle();
end;

day6_scripts();