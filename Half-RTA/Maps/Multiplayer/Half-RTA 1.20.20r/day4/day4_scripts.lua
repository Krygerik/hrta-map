-- Скрипты запускающиеся на 4 день

PATH_TO_DAY4_SCRIPTS = GetMapDataPath().."day4/";
PATH_TO_DAY4_MESSAGES = PATH_TO_DAY4_SCRIPTS.."messages/";

doFile(PATH_TO_DAY4_SCRIPTS.."day4_constants.lua");
sleep(1);

-- Вычисление кэфа дипломатии
function getDiplomacyKoef(heroName)
  print 'getDiplomacyKoef'

  local DIPLOMACY_DEFAULT_COEF = 0.4;

  local dictHeroName = getDictionaryHeroName(heroName);

  if dictHeroName == HEROES.ROLF then
    return 2 * DIPLOMACY_DEFAULT_COEF;
  end;

  return DIPLOMACY_DEFAULT_COEF;
end;

-- Отслеживание изменений в армии гарнизона и очищение его
function clearGarnisonOnChangeTread(garnisonName)
  print 'clearGarnisonOnChangeTread'
  
  local initArmy = {
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
    { kol = nil, id = nil },
  };
  
  -- Странная херня, если существа нет, то берется ИД = 0
  initArmy[1].id, initArmy[2].id, initArmy[3].id, initArmy[4].id, initArmy[5].id, initArmy[6].id, initArmy[7].id = GetObjectCreaturesTypes(garnisonName);

  -- Считаем, сколько существ есть вначале
  for _, army in initArmy do
    if army.id ~= 0 then
      army.kol = GetObjectCreatures(garnisonName, army.id);
    end;
  end;

  -- Следим, чтобы игрок не взял больше
  local playerTakeArmy = nil;

  while not playerTakeArmy do
    for _, army in initArmy do
      if army.id ~= 0 then
        local currentCountUnits = GetObjectCreatures(garnisonName, army.id);

        if currentCountUnits < army.kol then
          playerTakeArmy = not nil;
        end;
      end;
    end;

    sleep(1);
  end;

  -- Удаляем все, что осталось из гарнизона
  for _, army in initArmy do
    if army.id ~= 0 then
      local currentCountUnits = GetObjectCreatures(garnisonName, army.id);

      if currentCountUnits > 0 then
        RemoveObjectCreatures(garnisonName, army.id, currentCountUnits);
      end;
    end;
  end;
end;

-- Активация навыка "Дипломатия"
function runDiplomacy(heroName)
  print 'runDiplomacy'

  local playerId = GetObjectOwner(heroName);

  MessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."diplomacy.txt");

  local stashArmy = {
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
    { kol = nil, id1 = nil, id2 = nil },
  };

  stashArmy[1].id1, stashArmy[2].id1, stashArmy[3].id1, stashArmy[4].id1, stashArmy[5].id1, stashArmy[6].id1, stashArmy[7].id1 = GetHeroCreaturesTypes(heroName);

  -- Выясняем, какие грейды будем предлагать
  for _, stashItem in stashArmy do
    if stashItem.id1 ~= nil then
      for gradeCreatureId, altGradeCreatureId in MAP_CREATURES_ON_GRADE do
        if stashItem.id1 == gradeCreatureId and GetHeroCreatures(heroName, gradeCreatureId) < GetHeroCreatures(heroName, altGradeCreatureId) then
          stashItem.id2 = altGradeCreatureId;
        end;

        if stashItem.id1 == altGradeCreatureId then
          stashItem.id2 = gradeCreatureId;
        end;
      end;
    end;
  end;

  local diplomacyKoef = getDiplomacyKoef(heroName);

  -- Добавляем в гарнизон армию, возможную для присоединения через дипломатию
  DenyGarrisonCreaturesTakeAway(MAP_GARNISON_FOR_DIPLOMACY[playerId], not nil);

  for _, stashItem in stashArmy do
    for _, raceId in RACES do
      for _, unitData in UNITS[raceId] do
        if stashItem.id1 == unitData.id and stashItem.id2 ~= nil then
          stashItem.kol = diplomacyKoef * unitData.kol;
          AddObjectCreatures(MAP_GARNISON_FOR_DIPLOMACY[playerId], stashItem.id2, stashItem.kol);
        end;
      end;
    end;
  end;

  -- Отдаем гарнизон игроку и следим за изменением количества существ в нем
  SetObjectOwner(MAP_GARNISON_FOR_DIPLOMACY[playerId], playerId);
  MakeHeroInteractWithObject(heroName, MAP_GARNISON_FOR_DIPLOMACY[playerId]);

  startThread(clearGarnisonOnChangeTread, MAP_GARNISON_FOR_DIPLOMACY[playerId]);
end;

-- Телепорт героя на арену
function teleportPlayerInToBattle(playerId)
  print "teleportPlayerInToBattle"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];

  -- Если герой в городе, вытаскиваем его оттуда
  if IsHeroInTown(mainHeroName, townName, 0, 1) then
    local position = PLAYERS_TELEPORT_FROM_TOWN_POSITION[playerId];

    SetObjectPosition(mainHeroName, position.x, position.y);
  end;
  
  -- Телепортируем героя на выбор зоны
  local playerRace = GetTownRace(townName);
  
  if playerRace ~= RACES.SYLVAN and playerRace ~= RACES.ACADEMY then
    local position = PLAYERS_TELEPORT_TO_BATTLE_POSITION[playerId]
    
    SetObjectPosition(mainHeroName, position.x, position.y);
    OpenCircleFog(49, 45, GROUND, 15, playerId);
  end;
end;

-- Отключение всех кастомных способностей
function disableCustomAbilities(heroName)
  print "disableCustomAbilities"

  local allCustomAbilityTable = {
    CUSTOM_ABILITY_1,
    CUSTOM_ABILITY_2,
    CUSTOM_ABILITY_3,
    CUSTOM_ABILITY_4,
  };
  
  for _, ability in allCustomAbilityTable do
    ControlHeroCustomAbility(heroName, ability, CUSTOM_ABILITY_DISABLED);
  end;
end;

-- Уничтожаем в городе все постройки существ, исключая возможность менять их грейд
function downgradeTown(playerId)
  print "downgradeTown"

  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  
  local allTownDwellTable = {
    TOWN_BUILDING_DWELLING_1,
    TOWN_BUILDING_DWELLING_2,
    TOWN_BUILDING_DWELLING_3,
    TOWN_BUILDING_DWELLING_4,
    TOWN_BUILDING_DWELLING_5,
    TOWN_BUILDING_DWELLING_6,
    TOWN_BUILDING_DWELLING_7,
  };
  
  for _, dwellId in allTownDwellTable do
    DestroyTownBuildingToLevel(townName, dwellId, 0, 0);
  end;
end;

-- Блокировка всех прочих построек игрока
function disableAllOtherBuildings(playerId)
  print "disableAllOtherBuildings"

  local PLAYERS_MARKET = {
    [PLAYER_1] = 'market1',
    [PLAYER_2] = 'market2',
  };

  SetObjectEnabled(PLAYERS_MARKET[playerId], nil);
end;

-- Удаление всех очков передвижения у всех героев игрока
function removeAllHeroMovePoints(playerId)
  print "removeAllHeroMovePoints"

  local heroes = RESULT_HERO_LIST[playerId].heroes;
  
  for _, heroName in heroes do
    removeHeroMovePoints(heroName);
  end;
end;

-- Перенос всех артефактов от побочных героев главному
function transferAllArtsToMainHero(playerId)
  print "transferAllArtsToMainHero"

  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local heroes = RESULT_HERO_LIST[playerId].heroes;
  
  for _, heroName in heroes do
    if heroName ~= mainHeroName then
      transferAllArts(heroName, mainHeroName);
    end;
  end;
end;

-- Перенос всех фракционных войск, забытых в городе или прочих героях
function transferAllArmyToMain(playerId)
  print "transferAllArmyToMain"

  local raceId = RESULT_HERO_LIST[playerId].raceId;
  local townName = MAP_PLAYER_TO_TOWNNAME[playerId];
  local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
  local heroes = RESULT_HERO_LIST[playerId].heroes;

  -- Если есть существа в городе
  local takedUnitFromTown = nil;

  for _, unitData in UNITS[raceId] do
    if GetObjectCreatures(townName, unitData.id) > 0 and not takedUnitFromTown then
      awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."find_additional_army.txt");
    
      MakeHeroInteractWithObject(mainHeroName, townName);
    
      takedUnitFromTown = not nil;
    end;
  end;

  -- Если доступные существа в дополнительных героях
  for _, heroName in heroes do
    if heroName ~= mainHeroName then

      local takedUnitFromTownFromHero = nil;
      
      for _, unitData in UNITS[raceId] do
        if GetObjectCreatures(heroName, unitData.id) > 0 and not takedUnitFromTownFromHero then
          awaitMessageBoxForPlayers(playerId, PATH_TO_DAY4_MESSAGES.."find_additional_army.txt");
        
          MakeHeroInteractWithObject(mainHeroName, heroName);

          takedUnitFromTownFromHero = not nil;
        end;
      end;
    end;
  end;
end;

-- Точка входа
function day4_scripts()
  print "day4_scripts"

  -- Если у расы игроков есть действия на 4 день - вызываем их
  for _, playerId in PLAYER_ID_TABLE do
    local raceId = RESULT_HERO_LIST[playerId].raceId;
    local mainHeroName = PLAYERS_MAIN_HERO_PROPS[playerId].name;
    
    removeAllHeroMovePoints(playerId);

    disableAllOtherBuildings(playerId);
    
    SetPlayerResource(playerId, GOLD, 0);
    
    -- Дипломатия
    if HasHeroSkill(mainHeroName, PERK_DIPLOMACY) then
      runDiplomacy(mainHeroName);
    end;
    
    teleportPlayerInToBattle(playerId);
    
    disableCustomAbilities(mainHeroName);
    
    downgradeTown(playerId);
    
    disableAllOtherBuildings(playerId);
    
    transferAllArtsToMainHero(playerId);
    
    transferAllArmyToMain(playerId);
    
    -- Отправляем на выбор заклятых
    if raceId == RACES.SYLVAN then
      -- TODO
      --avengers();
    end;
  end;
end;

-- Точка входа
day4_scripts();

-- Заклятые враги для эльфа
function avengers()
  print "avengers"

  -- TODO
end;


-- Старый функционал по заклятым для эльфа
function oldAvengersFunctional()
  if hero1race == 4 then AvengerGenerating1(); end;
  if hero2race == 4 then AvengerGenerating2(); end;

  AvengerUse1 = 0;
  AvengerUse2 = 0;

  function Avenger1Question(hero)
    QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."AvengerQuestion.txt", 'Avenger1()', 'no');
  end;

  function Avenger2Question(hero)
    QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."AvengerQuestion.txt", 'Avenger2()', 'no');
  end;

  function AvengerGenerating1()
    race = hero2race;
    Enemy11 = random (7) + 1;
    Enemy12 = random (7) + 1;
    while Enemy12 == Enemy11 do
      Enemy12 = random (7) + 1;
    end;
    Enemy13 = random (7) + 1;
    while Enemy13 == Enemy11 or Enemy13 == Enemy12 do
      Enemy13 = random (7) + 1;
    end;
    Enemy14 = random (7) + 1;
    while Enemy14 == Enemy11 or Enemy14 == Enemy12 or Enemy14 == Enemy13 do
      Enemy14 = random (7) + 1;
    end;
    Enemy15 = random (7) + 1;
    while Enemy15 == Enemy11 or Enemy15 == Enemy12 or Enemy15 == Enemy13 or Enemy15 == Enemy14 do
      Enemy15 = random (7) + 1;
    end;
    Enemy16 = random (7) + 1;
    while Enemy16 == Enemy11 or Enemy16 == Enemy12 or Enemy16 == Enemy13 or Enemy16 == Enemy14 or Enemy16 == Enemy15 do
      Enemy16 = random (7) + 1;
    end;
    Enemy17 = 28 - Enemy11 - Enemy12 - Enemy13 - Enemy14 - Enemy15 - Enemy16;

  -- ЗАКЛЯТЫЕ - ТИР 1-6
    Enemy11 = 1;
    Enemy12 = 2;
    Enemy13 = 3;
    Enemy14 = 4;
    Enemy15 = 5;
    Enemy16 = 6;
    Enemy17 = 7;


  --  CreateMonster('Aaa', array_elf_enemy[race][Enemy11].id, array_elf_enemy[race][Enemy11].kol, 37, 78, 0, 1, 2,  0, 0); - ЗАКЛЯТЫЕ СЛУЧАЙНЫ
    CreateMonster('Aaa', array_elf_enemy[race][Enemy11].id, array_elf_enemy[race][Enemy11].kol, 10, 40, 0, 1, 2,  0, 0);
    AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy12].id, array_elf_enemy[race][Enemy12].kol);
    AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy13].id, array_elf_enemy[race][Enemy13].kol);
    AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy14].id, array_elf_enemy[race][Enemy14].kol);
    AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy15].id, array_elf_enemy[race][Enemy15].kol);
    AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy16].id, array_elf_enemy[race][Enemy16].kol);
    AddObjectCreatures('Aaa', array_elf_enemy[race][Enemy17].id, array_elf_enemy[race][Enemy17].kol);

    SetObjectEnabled('Aaa', nil);
    Trigger( OBJECT_TOUCH_TRIGGER, 'Aaa', 'Avenger1Question' );
  --  OpenCircleFog( 37, 78, 0, 3, 1);

  end;

  function AvengerGenerating2()
    race = hero1race;
    Enemy21 = random (7) + 1;
    Enemy22 = random (7) + 1;
    while Enemy22 == Enemy21 do
      Enemy22 = random (7) + 1;
    end;
    Enemy23 = random (7) + 1;
    while Enemy23 == Enemy21 or Enemy23 == Enemy22 do
      Enemy23 = random (7) + 1;
    end;
    Enemy24 = random (7) + 1;
    while Enemy24 == Enemy21 or Enemy24 == Enemy22 or Enemy24 == Enemy23 do
      Enemy24 = random (7) + 1;
    end;
    Enemy25 = random (7) + 1;
    while Enemy25 == Enemy21 or Enemy25 == Enemy22 or Enemy25 == Enemy23 or Enemy25 == Enemy24 do
      Enemy25 = random (7) + 1;
    end;
    Enemy26 = random (7) + 1;
    while Enemy26 == Enemy21 or Enemy26 == Enemy22 or Enemy26 == Enemy23 or Enemy26 == Enemy24 or Enemy26 == Enemy25 do
      Enemy26 = random (7) + 1;
    end;
    Enemy27 = 28 - Enemy21 - Enemy22 - Enemy23 - Enemy24 - Enemy25 - Enemy26;

  -- ЗАКЛЯТЫЕ - ТИР 1-6
    Enemy21 = 1;
    Enemy22 = 2;
    Enemy23 = 3;
    Enemy24 = 4;
    Enemy25 = 5;
    Enemy26 = 6;
    Enemy27 = 7;

  --  CreateMonster('Bbb', array_elf_enemy[race][Enemy21].id, array_elf_enemy[race][Enemy21].kol, 28, 13, 0, 1, 2, 90, 0); - ЗАКЛЯТЫЕ СЛУЧАЙНЫ
    CreateMonster('Bbb', array_elf_enemy[race][Enemy21].id, array_elf_enemy[race][Enemy21].kol, 12, 40, 0, 1, 2, 90, 0);
    AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy22].id, array_elf_enemy[race][Enemy22].kol);
    AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy23].id, array_elf_enemy[race][Enemy23].kol);
    AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy24].id, array_elf_enemy[race][Enemy24].kol);
    AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy25].id, array_elf_enemy[race][Enemy25].kol);
    AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy26].id, array_elf_enemy[race][Enemy26].kol);
    AddObjectCreatures('Bbb', array_elf_enemy[race][Enemy27].id, array_elf_enemy[race][Enemy27].kol);

    SetObjectEnabled('Bbb', nil);
    Trigger( OBJECT_TOUCH_TRIGGER, 'Bbb', 'Avenger2Question' );
  --  OpenCircleFog( 28, 13, 0, 3, 2);

  end;


  function Avenger1()
    pause1 = 0;
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Avenger.txt", 'pause1F');
    while pause1 == 0 do
      sleep(1);
    end;

    -- Аларон
    if (HeroMax1 == "Ildar" or HeroMax1 == "Ildar2") and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) == 3 then SubHero(HeroMax1, "Ildar3"); HeroMax1 = "Ildar3"; sleep(3); end;
    if (HeroMax1 == "Ildar" or HeroMax1 == "Ildar2") and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) < 3 and GetHeroSkillMastery(HeroMax1, SKILL_LIGHT_MAGIC) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax1, 'no'); GiveHeroSkill(HeroMax1, SKILL_LIGHT_MAGIC); end;

    -- холодная сталь
  --  if (HasHeroSkill(HeroMax1, 104) or HasHeroSkill(HeroMax1, 82)) and Name(HeroMax1) ~= "Ildar" and Name(HeroMax1) ~= "Ildar3" then
  --    DublikatHero1( HeroMax1);
  --    sleep(3);
  --  end;

    hero = HeroMax1;
    race = hero2race;

    if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 1 then
      CreateMonster('Enemy1', array_elf_enemy[hero2race][Enemy11].id, array_elf_enemy[hero2race][Enemy11].kol, 21, 57, GROUND, 1, 1, 0);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy12].id, array_elf_enemy[hero2race][Enemy12].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy13].id, array_elf_enemy[hero2race][Enemy13].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy14].id, array_elf_enemy[hero2race][Enemy14].kol);
    end;

    if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 2 then
      CreateMonster('Enemy1', array_elf_enemy[hero2race][Enemy11].id, array_elf_enemy[hero2race][Enemy11].kol, 21, 57, GROUND, 1, 1, 0);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy12].id, array_elf_enemy[hero2race][Enemy12].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy13].id, array_elf_enemy[hero2race][Enemy13].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy14].id, array_elf_enemy[hero2race][Enemy14].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy15].id, array_elf_enemy[hero2race][Enemy15].kol);
    end;

    if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 3 then
      CreateMonster('Enemy1', array_elf_enemy[hero2race][Enemy11].id, array_elf_enemy[hero2race][Enemy11].kol, 21, 57, GROUND, 1, 1, 0);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy12].id, array_elf_enemy[hero2race][Enemy12].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy13].id, array_elf_enemy[hero2race][Enemy13].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy14].id, array_elf_enemy[hero2race][Enemy14].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy15].id, array_elf_enemy[hero2race][Enemy15].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy16].id, array_elf_enemy[hero2race][Enemy16].kol);
  --    UpgradeTownBuilding('RANDOMTOWN1',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
    end;

    if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 4 then
      CreateMonster('Enemy1', array_elf_enemy[hero2race][Enemy11].id, array_elf_enemy[hero2race][Enemy11].kol, 21, 57, GROUND, 1, 1, 0);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy12].id, array_elf_enemy[hero2race][Enemy12].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy13].id, array_elf_enemy[hero2race][Enemy13].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy14].id, array_elf_enemy[hero2race][Enemy14].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy15].id, array_elf_enemy[hero2race][Enemy15].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy16].id, array_elf_enemy[hero2race][Enemy16].kol);
      AddObjectCreatures('Enemy1', array_elf_enemy[hero2race][Enemy17].id, array_elf_enemy[hero2race][Enemy17].kol);
  --    UpgradeTownBuilding('RANDOMTOWN1',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  --    SetObjectOwner('RANDOMTOWN1', 1);
  --    UpgradeTownBuilding('RANDOMTOWN1',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  --    UpgradeTownBuilding('RANDOMTOWN1',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
    end;

  --  if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 1 then GiveHeroSkill(HeroMax1, SKILL_AVENGER); GiveHeroSkill(HeroMax1, SKILL_AVENGER); end;
  --  if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 2 then GiveHeroSkill(HeroMax1, SKILL_AVENGER); end;

  --  if (HasHeroSkill(HeroMax1, 27) and (Name(HeroMax1) == "GhostFSLord") and GetHeroSkillMastery(HeroMax1, SKILL_SUMMONING_MAGIC) > 1) then TeachHeroSpell(HeroMax1, 43); TeachHeroSpell(HeroMax1, 283); TeachHeroSpell(HeroMax1, 34); end;
  --  if HasHeroSkill(HeroMax1, 27) then TeachHeroSpell(HeroMax1, 25); TeachHeroSpell(HeroMax1, 237); TeachHeroSpell(HeroMax1, 3); TeachHeroSpell(HeroMax1, 39); end;
  --  GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_INITIATIVE, 30);
    AvengerUse1 = 1;
  --  UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
    UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);

    Stek1[1].id, Stek1[2].id, Stek1[3].id, Stek1[4].id, Stek1[5].id, Stek1[6].id, Stek1[7].id = GetHeroCreaturesTypes(HeroMax1);
    for i = 1, 7 do
      if Stek1[i].id > 0 then
         Stek1[i].kol = GetHeroCreatures( HeroMax1, Stek1[i].id);
         RemoveHeroCreatures( HeroMax1, Stek1[i].id, Stek1[i].kol);
         sleep(1);
         if i == 1 then AddHeroCreatures( HeroMax1, 91, 10); end;
      end;
    end;

  --  sleep(10);

    StartCombat (HeroMax1, nil, 7, array_elf_enemy[hero2race][Enemy11].id, array_elf_enemy[hero2race][Enemy11].kol,
                               array_elf_enemy[hero2race][Enemy12].id, array_elf_enemy[hero2race][Enemy12].kol,
                               array_elf_enemy[hero2race][Enemy13].id, array_elf_enemy[hero2race][Enemy13].kol,
                               array_elf_enemy[hero2race][Enemy14].id, array_elf_enemy[hero2race][Enemy14].kol,
                               array_elf_enemy[hero2race][Enemy15].id, array_elf_enemy[hero2race][Enemy15].kol,
                               array_elf_enemy[hero2race][Enemy16].id, array_elf_enemy[hero2race][Enemy16].kol,
                               array_elf_enemy[hero2race][Enemy17].id, array_elf_enemy[hero2race][Enemy17].kol,
                               nil, 'ReturnElfArmy1', nil, true);

  --  MakeHeroInteractWithObject (HeroMax1, 'Enemy1');
    sleep(20);
  --  RemoveObject('Aaa');

  --  MakeHeroInteractWithObject (HeroMax1, 'RANDOMTOWN1');
  --  stop(HeroMax1);

    SetObjectPosition('port1', 39, 80, 0);
    Trigger( OBJECT_TOUCH_TRIGGER, 'port1', 'TeleportBattleZone1' );
    SetObjectEnabled('port1', nil);
    SetDisabledObjectMode('port1', 2);
    Trigger (OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN1', 'no');

  end;

  function Avenger2()
    pause2 = 0;
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Avenger.txt", 'pause2F');
    while pause2 == 0 do
      sleep(1);
    end;

    -- Аларон
    if (HeroMax2 == "Ildar" or HeroMax2 == "Ildar2") and GetHeroSkillMastery(HeroMax2, SKILL_LIGHT_MAGIC) == 3 then SubHero(HeroMax2, "Ildar4"); HeroMax2 = "Ildar4"; end;
    if (HeroMax2 == "Ildar" or HeroMax2 == "Ildar2") and GetHeroSkillMastery(HeroMax2, SKILL_LIGHT_MAGIC) < 3 and GetHeroSkillMastery(HeroMax2, SKILL_LIGHT_MAGIC) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax2, 'no'); GiveHeroSkill(HeroMax2, SKILL_LIGHT_MAGIC); end;

    -- холодная сталь
  --  if (HasHeroSkill(HeroMax2, 104) or HasHeroSkill(HeroMax2, 82)) and Name(HeroMax2) ~= "Ildar" and Name(HeroMax2) ~= "Ildar3" then
  --    DublikatHero2( HeroMax2);
  --  end;

  --  hero = HeroMax2;
    race = hero1race;

    if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 1 then
      CreateMonster('Enemy2', array_elf_enemy[hero1race][Enemy21].id, array_elf_enemy[hero1race][Enemy21].kol, 26, 57, GROUND, 1, 1, 0);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy22].id, array_elf_enemy[hero1race][Enemy22].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy23].id, array_elf_enemy[hero1race][Enemy23].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy24].id, array_elf_enemy[hero1race][Enemy24].kol);
    end;

    if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 2 then
      CreateMonster('Enemy2', array_elf_enemy[hero1race][Enemy21].id, array_elf_enemy[hero1race][Enemy21].kol, 26, 57, GROUND, 1, 1, 0);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy22].id, array_elf_enemy[hero1race][Enemy22].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy23].id, array_elf_enemy[hero1race][Enemy23].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy24].id, array_elf_enemy[hero1race][Enemy24].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy25].id, array_elf_enemy[hero1race][Enemy25].kol);
    end;

    if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 3 then
      CreateMonster('Enemy2', array_elf_enemy[hero1race][Enemy21].id, array_elf_enemy[hero1race][Enemy21].kol, 26, 57, GROUND, 1, 1, 0);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy22].id, array_elf_enemy[hero1race][Enemy22].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy23].id, array_elf_enemy[hero1race][Enemy23].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy24].id, array_elf_enemy[hero1race][Enemy24].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy25].id, array_elf_enemy[hero1race][Enemy25].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy26].id, array_elf_enemy[hero1race][Enemy26].kol);
  --    UpgradeTownBuilding('RANDOMTOWN2',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
    end;

    if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 4 then
      CreateMonster('Enemy2', array_elf_enemy[hero1race][Enemy21].id, array_elf_enemy[hero1race][Enemy21].kol, 26, 57, GROUND, 1, 1, 0);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy22].id, array_elf_enemy[hero1race][Enemy22].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy23].id, array_elf_enemy[hero1race][Enemy23].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy24].id, array_elf_enemy[hero1race][Enemy24].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy25].id, array_elf_enemy[hero1race][Enemy25].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy26].id, array_elf_enemy[hero1race][Enemy26].kol);
      AddObjectCreatures('Enemy2', array_elf_enemy[hero1race][Enemy27].id, array_elf_enemy[hero1race][Enemy27].kol);
  --    UpgradeTownBuilding('RANDOMTOWN2',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  --    SetObjectOwner('RANDOMTOWN2', 2);
  --    UpgradeTownBuilding('RANDOMTOWN2',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
  --    UpgradeTownBuilding('RANDOMTOWN2',  TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
    end;

  --  if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 1 then GiveHeroSkill(HeroMax2, SKILL_AVENGER); GiveHeroSkill(HeroMax2, SKILL_AVENGER); end;
  --  if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 2 then GiveHeroSkill(HeroMax2, SKILL_AVENGER); end;

  --  if (HasHeroSkill(HeroMax2, 27) and (Name(HeroMax2) == "GhostFSLord") and GetHeroSkillMastery(HeroMax2, SKILL_SUMMONING_MAGIC) > 1) then TeachHeroSpell(HeroMax2, 43); TeachHeroSpell(HeroMax2, 283); TeachHeroSpell(HeroMax2, 34); end;
  --  if HasHeroSkill(HeroMax2, 27) then TeachHeroSpell(HeroMax2, 25); TeachHeroSpell(HeroMax2, 237); TeachHeroSpell(HeroMax2, 3); TeachHeroSpell(HeroMax2, 39); end;
  --  GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_INITIATIVE, 30);
    AvengerUse2 = 1;
  --  UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);
    UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD);

    Stek2[1].id, Stek2[2].id, Stek2[3].id, Stek2[4].id, Stek2[5].id, Stek2[6].id, Stek2[7].id = GetHeroCreaturesTypes(HeroMax2);
    for i = 1, 7 do
      if Stek2[i].id > 0 then
         Stek2[i].kol = GetHeroCreatures( HeroMax2, Stek2[i].id);
         RemoveHeroCreatures( HeroMax2, Stek2[i].id, Stek2[i].kol);
         sleep(1);
         if i == 1 then AddHeroCreatures( HeroMax2, 91, 10); end;
      end;
    end;

  --  sleep(10);

    StartCombat (HeroMax2, nil, 7, array_elf_enemy[hero1race][Enemy21].id, array_elf_enemy[hero1race][Enemy21].kol,
                               array_elf_enemy[hero1race][Enemy22].id, array_elf_enemy[hero1race][Enemy22].kol,
                               array_elf_enemy[hero1race][Enemy23].id, array_elf_enemy[hero1race][Enemy23].kol,
                               array_elf_enemy[hero1race][Enemy24].id, array_elf_enemy[hero1race][Enemy24].kol,
                               array_elf_enemy[hero1race][Enemy25].id, array_elf_enemy[hero1race][Enemy25].kol,
                               array_elf_enemy[hero1race][Enemy26].id, array_elf_enemy[hero1race][Enemy26].kol,
                               array_elf_enemy[hero1race][Enemy27].id, array_elf_enemy[hero1race][Enemy27].kol,
                               nil, 'ReturnElfArmy2', nil, true);

    --MakeHeroInteractWithObject (HeroMax2, 'Enemy2');
    sleep(20);

    SetObjectPosition('port2', 47, 11, 0);
    Trigger( OBJECT_TOUCH_TRIGGER, 'port2', 'TeleportBattleZone2' );
    SetObjectEnabled('port2', nil);
    SetDisabledObjectMode('port2', 2);
    Trigger (OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN2', 'no');

  --  RemoveObject('Bbb');

  --MakeHeroInteractWithObject (hero, 'RANDOMTOWN2');
  --stop(HeroMax2);

  end;

  function ReturnElfArmy1(hero, res)
    for i = 1, 7 do
      if Stek1[i].id > 0 then
         AddHeroCreatures( hero, Stek1[i].id, Stek1[i].kol);
         sleep(1);
         if GetHeroCreatures(hero, 91) > 0 then kolCreatures = GetHeroCreatures(hero, 91); RemoveHeroCreatures(hero, 91, kolCreatures); end;
      end;
    end;
    if GetObjectCreatures('RANDOMTOWN1', 91) > 0 then kolCreatures = GetObjectCreatures('RANDOMTOWN1', 91); RemoveObjectCreatures('RANDOMTOWN1', 91, kolCreatures); end;
  --  if HasHeroSkill(hero, 141) then GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_SPEED, -1); GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, 1); end;
  end;

  function ReturnElfArmy2(hero, res)
    for i = 1, 7 do
      if Stek2[i].id > 0 then
         AddHeroCreatures( hero, Stek2[i].id, Stek2[i].kol);
         sleep(1);
         if GetHeroCreatures(hero, 91) > 0 then kolCreatures = GetHeroCreatures(hero, 91); RemoveHeroCreatures(hero, 91, kolCreatures); end;
      end;
    end;
    if GetObjectCreatures('RANDOMTOWN2', 91) > 0 then kolCreatures = GetObjectCreatures('RANDOMTOWN2', 91); RemoveObjectCreatures('RANDOMTOWN2', 91, kolCreatures); end;
  --  if HasHeroSkill(hero, 141) then GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_SPEED, -1); GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, 1); end;
  end;

  TeleportUse1 = 0;
  TeleportUse2 = 0;


  function TeleportBattleZone1()
    SetObjectPosition (HeroMax1, TELEPORT_BATTLE_ZONE_PLAYER_1_X, TELEPORT_BATTLE_ZONE_PLAYER_1_Y);
    OpenCircleFog( 48, 45, 0, 15, 1 );
    sleep(7);
    stop(HeroMax1);
    TeleportUse1 = 1;
    ShowFlyingSign(GetMapDataPath().."Wait.txt", HeroMax1, 1, 5.0);
  end;

  function TeleportBattleZone2()
    SetObjectPosition (HeroMax2, TELEPORT_BATTLE_ZONE_PLAYER_2_X, TELEPORT_BATTLE_ZONE_PLAYER_2_Y);
    OpenCircleFog( 48, 45, 0, 15, 2 );
    TeleportUse2 = 1;
  end;

  function AutoTeleportBattleZone1()
    while TeleportUse1 == 0 do
      if IsPlayerWaitingForTurn(PLAYER_1) then
        TeleportBattleZone1();
      end;
      sleep(20);
    end;
  end;

  function AutoTeleportBattleZone2()
    while TeleportUse2 == 0 do
      if IsPlayerWaitingForTurn(PLAYER_2) then
        TeleportBattleZone2();
      end;
      sleep(20);
    end;
  end;
end;
