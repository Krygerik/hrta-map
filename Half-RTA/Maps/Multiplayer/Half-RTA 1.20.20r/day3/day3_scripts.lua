PATH_TO_DAY3_SCRIPTS = GetMapDataPath().."day3/";

doFile(PATH_TO_DAY3_SCRIPTS.."day3_constants.lua");
doFile(PATH_TO_DAY3_SCRIPTS.."day3_common.lua");
sleep(1);

-- Точка входа в модуль
function day3()
  print "day3"

  addHeroesToPlayers();
  setHeroesInitialProperties();
  setEnemyHeroPosters();
  changePlayersArea();
  doFile(PATH_TO_DAY3_SCRIPTS.."spells_generate/spells_generate_scripts.lua");
  doFile(PATH_TO_DAY3_SCRIPTS.."start_bonus/start_bonus_scripts.lua");
  doFile(PATH_TO_DAY3_SCRIPTS.."town_building/town_building_scripts.lua");
  doFile(PATH_TO_DAY3_SCRIPTS.."set_initial_resources/set_initial_resources_scripts.lua");
  doFile(PATH_TO_DAY3_SCRIPTS.."start_learning/start_learning_scripts.lua");
  doFile(PATH_TO_DAY3_SCRIPTS.."artifact_merchant/artifact_merchant_scripts.lua");
  doFile(PATH_TO_DAY3_SCRIPTS.."buy_hero/buy_hero_scripts.lua");
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
  
  -- Непонятно, зачем выдавать им эти перки?)
  GiveHeroSkill(Biara, PERK_DEMONIC_FIRE);
  GiveHeroSkill(Biara, HERO_SKILL_SNATCH);
  GiveHeroSkill(Djovanni, HERO_SKILL_SNATCH);
end;

-- Изменение игровых зон обоих игроков
function changePlayersArea()
  print "changePlayersArea"
  
  OpenCircleFog(57, 80, GROUND, 14, PLAYER_1);
  OpenCircleFog(31, 14, GROUND, 17, PLAYER_2);
  OpenCircleFog(54, 12, GROUND, 14, PLAYER_2);
  
  SetRegionBlocked('block1', 1);
  SetRegionBlocked('block2', 1);
  SetRegionBlocked('block3', 1);
  SetRegionBlocked('block4', 1);
  SetRegionBlocked('reg_shop3', 1);
  SetRegionBlocked('reg_shop4', 1);
  SetRegionBlocked('reg_shop5', 1);
  SetRegionBlocked('reg_shop6', 1);
  SetRegionBlocked ('block1', 1);
  SetRegionBlocked ('block2', 1);
  SetRegionBlocked ('block3', 1);
  SetRegionBlocked ('block4', 1);
end;

-- Отображение иконок выбранного списка героев у оппонента
function setEnemyHeroPosters()
  print "setEnemyHeroPosters"

  local ENEMY_POSTERS_POSITION = {
    [PLAYER_1] = {
      { x = 31, y = 85 },
      { x = 31, y = 86 },
      { x = 31, y = 87 },
      { x = 31, y = 88 },
      { x = 31, y = 89 },
      { x = 31, y = 90 },
    },
    [PLAYER_2] = {
      { x = 46, y = 19 },
      { x = 46, y = 20 },
      { x = 46, y = 21 },
      { x = 46, y = 22 },
      { x = 46, y = 23 },
      { x = 46, y = 24 },
    },
  };
  
  for _, playerId in PLAYER_ID_TABLE do
    local enemyPlayerId = PLAYERS_OPPONENT[playerId];
    local enemyChoisedHeroes = RESULT_HERO_LIST[enemyPlayerId].choised_heroes;

    for indexHero, heroName in enemyChoisedHeroes do
      local iconName = getHeroIconByHeroName(enemyPlayerId, heroName);
      
      SetObjectPosition(iconName, ENEMY_POSTERS_POSITION[playerId][indexHero].x, ENEMY_POSTERS_POSITION[playerId][indexHero].y, GROUND);
    end;
  end;
end;

-- Точка входа
day3();
