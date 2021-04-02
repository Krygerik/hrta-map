PATH_TO_DAY3_SCRIPTS = GetMapDataPath().."day3/";

doFile(PATH_TO_DAY3_SCRIPTS.."day3_constants.lua");
doFile(PATH_TO_DAY3_SCRIPTS.."day3_common.lua");
sleep(1);

-- Точка входа в модуль
function day3()
  print "day3"

  addHeroesToPlayers();
  setHeroesInitialProperties();
  changePlayersArea();
end;

-- Добавление героев игрокам
function addHeroesToPlayers()
  print "addHeroesToPlayers"
  
  local INITIAL_HERO_COORDINATES = {
    [PLAYER_1] = {
      { x = 41, y = 78 },
      { x = 44, y = 78 },
      { x = 40, y = 82 },
    },
    [PLAYER_2] = {
      { x = 43, y = 15 },
      { x = 41, y = 15 },
      { x = 53, y = 18 },
    },
  };

  for _, playerId in PLAYER_ID_TABLE do
    local playerData = RESULT_HERO_LIST[playerId];

    for indexHero, heroName in playerData.heroes do
      local coords = INITIAL_HERO_COORDINATES[playerId][indexHero];
      
      -- берем зарезервированных героев для игроков
      local reservedHeroName = getReservedHeroName(playerId, heroName);

      DeployReserveHero(reservedHeroName, coords.x, coords.y, GROUND);
    end;
  end;
end;

-- Установка героям начальных свойств
function setHeroesInitialProperties()
  print "setHeroesInitialProperties"

  for _, playerId in PLAYER_ID_TABLE do
    local playerData = RESULT_HERO_LIST[playerId];

    for indexHero, heroName in playerData.heroes do
      -- берем зарезервированных героев для игроков
      local reservedHeroName = getReservedHeroName(playerId, heroName);
      local heroMana = GetHeroStat(reservedHeroName, STAT_MANA_POINTS);
      
      ChangeHeroStat(reservedHeroName, STAT_MANA_POINTS, 0 - heroMana);
      LockMinHeroSkillsAndAttributes(reservedHeroName);
      
      -- Отнимаем очки передвижения у героя из таверны
      if indexHero == 3 then
        removeHeroMovePoints(reservedHeroName);
      end;
      
      for _, skill in INITIAL_HERO_SKILLS[heroName] do
        GiveHeroSkill(reservedHeroName, skill);
      end;
    end;
  end;
  
  SetObjectPosition(Biara, 35, 85);
  SetObjectPosition(Djovanni, 42, 24);
  GiveHeroSkill(Biara, PERK_DEMONIC_FIRE);
  GiveHeroSkill(Biara, HERO_SKILL_SNATCH);
  GiveHeroSkill(Djovanni, HERO_SKILL_SNATCH);
  
  doFile(PATH_TO_DAY3_SCRIPTS.."spells_generate/spells_generate_scripts.lua");
  -- doFile(PATH_TO_DAY3_SCRIPTS.."start_bonus/start_bonus_scripts.lua");
end;

-- Изменение игровых зон обоих игроков
function changePlayersArea()
  print "changePlayersArea"

  local PLAYERS_DATA = {
    [PLAYER_1] = { townName = 'RANDOMTOWN1' },
    [PLAYER_2] = { townName = 'RANDOMTOWN2' },
  }
  
  OpenCircleFog(57, 80, GROUND, 14, PLAYER_1);
  OpenCircleFog(31, 14, GROUND, 17, PLAYER_2);
  OpenCircleFog(54, 12, GROUND, 14, PLAYER_2);
  
  for playerId = 1, length(RESULT_HERO_LIST) do
    local playerData = RESULT_HERO_LIST[playerId];
    local townName = PLAYERS_DATA[playerId].townName
    
    -- Превращает города в города выбранных рас
    transformPlayersTown(townName, playerData.raceId);
    SetObjectOwner(townName, playerId);
    setTownMaximumLevel(townName, playerData.raceId);
  end;
  
  SetRegionBlocked('block1', 1);
  SetRegionBlocked('block2', 1);
  SetRegionBlocked('block3', 1);
  SetRegionBlocked('block4', 1);
  SetRegionBlocked('reg_shop3', 1);
  SetRegionBlocked('reg_shop4', 1);
  SetRegionBlocked('reg_shop5', 1);
  SetRegionBlocked('reg_shop6', 1);
  SetRegionBlocked ('block1', true);
  SetRegionBlocked ('block2', true);
  SetRegionBlocked ('block3', true);
  SetRegionBlocked ('block4', true);
end;

-- Изменение переданного города на город переданной расы
function transformPlayersTown(townName, raceId)
  print "transformPlayersTown"
  
  -- Соотношение расы к ее городу
  local MAP_RACE_TO_TOWN = {
    [RACES.HAVEN] = TOWN_HEAVEN,
    [RACES.INFERNO] = TOWN_INFERNO,
    [RACES.NECROPOLIS] = TOWN_NECROMANCY,
    [RACES.SYLVAN] = TOWN_PRESERVE,
    [RACES.ACADEMY] = TOWN_ACADEMY,
    [RACES.DUNGEON] = TOWN_DUNGEON,
    [RACES.FORTRESS] = TOWN_FORTRESS,
    [RACES.STRONGHOLD] = TOWN_STRONGHOLD,
  };

  TransformTown(townName, MAP_RACE_TO_TOWN[raceId]);
end;

-- Отстройка максимального lvl для города
function setTownMaximumLevel(townName, raceId)
  print "setTownMaximumLevel"

  local allTownCreatureList = {
    TOWN_BUILDING_DWELLING_1,
    TOWN_BUILDING_DWELLING_2,
    TOWN_BUILDING_DWELLING_3,
    TOWN_BUILDING_DWELLING_4,
    TOWN_BUILDING_DWELLING_5,
    TOWN_BUILDING_DWELLING_6,
    TOWN_BUILDING_DWELLING_7
  };
  
  for _, dwelling in allTownCreatureList do
    UpgradeTownBuilding(townName, dwelling);
    SetTownBuildingLimitLevel(townName, dwelling, 2);
    UpgradeTownBuilding(townName, dwelling);
  end;

  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_TOWN_HALL, 1);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_FORT, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_MARKETPLACE, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_SHIPYARD, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_TAVERN, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_BLACKSMITH, 0);
  SetTownBuildingLimitLevel(townName, TOWN_BUILDING_MAGIC_GUILD, 0);
  
  if raceId == RACES.HAVEN then
    UpgradeTownBuilding(townName, TOWN_BUILDING_HAVEN_TRAINING_GROUNDS);
    SetTownBuildingLimitLevel(townName, TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 0);
    UpgradeTownBuilding(townName, TOWN_BUILDING_HAVEN_FARMS);
  end;
  if raceId == RACES.ACADEMY then
    UpgradeTownBuilding(townName, TOWN_BUILDING_ACADEMY_ARTIFACT_MERCHANT);
  end;
  if raceId == RACES.DUNGEON then
    UpgradeTownBuilding(townName, TOWN_BUILDING_DUNGEON_TRADE_GUILD);
    SetTownBuildingLimitLevel(townName, TOWN_BUILDING_DUNGEON_HALL_OF_INTRIGUE, 0);
    SetTownBuildingLimitLevel(townName, TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS, 0);
  end;
end;

-- Точка входа
day3();

function mock()
  kol_u1_pl1, kol_u2_pl1, kol_u3_pl1, kol_u4_pl1, kol_u5_pl1, kol_u6_pl1, kol_u7_pl1 = rnd_army(hero1race);
  kol_u1_pl2, kol_u2_pl2, kol_u3_pl2, kol_u4_pl2, kol_u5_pl2, kol_u6_pl2, kol_u7_pl2 = rnd_army(hero2race);

  if option[NumberBattle] == 3 then kol_u1_pl1, kol_u2_pl1, kol_u3_pl1, kol_u4_pl1, kol_u5_pl1, kol_u6_pl1, kol_u7_pl1 = BonusForSiege(1, hero1race, hero2race, kol_u1_pl1, kol_u2_pl1, kol_u3_pl1, kol_u4_pl1, kol_u5_pl1, kol_u6_pl1, kol_u7_pl1); end;
  if option[NumberBattle] == 2 then kol_u1_pl2, kol_u2_pl2, kol_u3_pl2, kol_u4_pl2, kol_u5_pl2, kol_u6_pl2, kol_u7_pl2 = BonusForSiege(2, hero2race, hero1race, kol_u1_pl2, kol_u2_pl2, kol_u3_pl2, kol_u4_pl2, kol_u5_pl2, kol_u6_pl2, kol_u7_pl2); end;

  -- бонусы в неравных парах
  if option[NumberBattle] == 10 then K = 1.5; else K = 1; end;
  SetArmyTown(hero1race, 1, intg(K * kol_u1_pl1), intg(K * kol_u2_pl1), intg(K * kol_u3_pl1), intg(K * kol_u4_pl1), intg(K * kol_u5_pl1), intg(K * kol_u6_pl1), intg(K * kol_u7_pl1));
  SetArmyTown(hero2race, 2, intg(K * kol_u1_pl2), intg(K * kol_u2_pl2), intg(K * kol_u3_pl2), intg(K * kol_u4_pl2), intg(K * kol_u5_pl2), intg(K * kol_u6_pl2), intg(K * kol_u7_pl2));
  kolUnit1 = {intg(K * kol_u1_pl1), intg(K * kol_u2_pl1), intg(K * kol_u3_pl1), intg(K * kol_u4_pl1), intg(K * kol_u5_pl1), intg(K * kol_u6_pl1), intg(K * kol_u7_pl1)};
  kolUnit2 = {intg(K * kol_u1_pl2), intg(K * kol_u2_pl2), intg(K * kol_u3_pl2), intg(K * kol_u4_pl2), intg(K * kol_u5_pl2), intg(K * kol_u6_pl2), intg(K * kol_u7_pl2)};
  set_player_resources(PLAYER_1, hero1race, kol_u1_pl1, kol_u2_pl1, kol_u3_pl1, kol_u4_pl1, kol_u5_pl1, kol_u6_pl1, kol_u7_pl1);
  set_player_resources(PLAYER_2, hero2race, kol_u1_pl2, kol_u2_pl2, kol_u3_pl2, kol_u4_pl2, kol_u5_pl2, kol_u6_pl2, kol_u7_pl2);
  if bonus1 == 'gold' then BonusStartGold(1); end;
  if bonus2 == 'gold' then BonusStartGold(2); end;
  if hero1race == 1 then ShowFlyingSign(GetMapDataPath().."HumanBonus.txt", HeroMax1, 1, 7.0); end;
  if hero2race == 1 then ShowFlyingSign(GetMapDataPath().."HumanBonus.txt", HeroMax2, 2, 7.0); end;

  startThread (peredvigenie);
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax1, 'MentorAddSkill1');
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroMin1, 'MentorAddSkill1');
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroDop1, 'MentorAddSkill1');
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax2, 'MentorAddSkill2');
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroMin2, 'MentorAddSkill2');
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroDop2, 'MentorAddSkill2');
  Trigger( PLAYER_ADD_HERO_TRIGGER, PLAYER_1, 'HeroAdd1');
  Trigger( PLAYER_ADD_HERO_TRIGGER, PLAYER_2, 'HeroAdd2');

  startThread (RemoveStartUnit1);
  startThread (RemoveStartUnit2);

  -- Обрати внимание на функции
  -- add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
  -- unreserve();
end;
