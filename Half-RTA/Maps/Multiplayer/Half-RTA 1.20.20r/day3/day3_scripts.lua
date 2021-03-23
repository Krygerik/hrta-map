-- Точка входа в модуль
function day3()
  print "day3"

  addHeroesToPlayers();
end;


INITIAL_HERO_COORDINATES = {
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
}

-- Добавление героев игрокам
function addHeroesToPlayers()
  for _, playerId in PLAYER_ID_TABLE do
    local playerData = RESULT_HERO_LIST[playerId];

    for indexHero, heroName in playerData.heroes do
      local coords = INITIAL_HERO_COORDINATES[playerId][indexHero];
      
      -- Для второго игрока берем его зарезервированных героев
      local reservedHeroName = playerId == PLAYER_1 and heroName or heroName.."2"

      DeployReserveHero(reservedHeroName, coords.x, coords.y, GROUND);
    end;
  end;
end;

-- Точка входа
day3();

function mock()
  -- Перемещаем камеру второго игрока
  MoveCameraForPlayers( GetPlayerFilter(PLAYER_2), 42, 24, GROUND, 40, 0, 3.14, 0, 0, 1);

  addHeroMovePoints(Biara)
  ChangeHeroStat(HeroDop1, STAT_MOVE_POINTS, 500);
  addHeroMovePoints(Djovanni);
  ChangeHeroStat(HeroDop2, STAT_MOVE_POINTS, 500);

  OpenCircleFog(57, 80, GROUND, 14, PLAYER_1);
  OpenCircleFog(31, 14, GROUND, 17, PLAYER_2);
  OpenCircleFog(54, 12, GROUND, 14, PLAYER_2);

  -- Превращает города в города выбранных рас
  TransformPlayersTown('RANDOMTOWN1', hero1race);
  TransformPlayersTown('RANDOMTOWN2', hero2race);

  SetObjectOwner('RANDOMTOWN1', PLAYER_1);
  SetObjectOwner('RANDOMTOWN2', PLAYER_2);

  TownBuilding('RANDOMTOWN1', hero1race);
  TownBuilding('RANDOMTOWN2', hero2race);

  if hero1race == 1 then OverrideObjectTooltipNameAndDescription ('oko1', GetMapDataPath().."TrainingNAME.txt", GetMapDataPath().."TrainingDSCRP.txt"); end;
  if hero1race == 4 then OverrideObjectTooltipNameAndDescription ('oko1', GetMapDataPath().."AvengerNAME.txt", GetMapDataPath().."AvengerDSCRP.txt"); end;
  if hero1race == 5 then OverrideObjectTooltipNameAndDescription ('oko1', GetMapDataPath().."MinikNAME.txt", GetMapDataPath().."MinikDSCRP.txt"); end;
  if hero2race == 1 then OverrideObjectTooltipNameAndDescription ('oko2', GetMapDataPath().."TrainingNAME.txt", GetMapDataPath().."TrainingDSCRP.txt"); end;
  if hero2race == 4 then OverrideObjectTooltipNameAndDescription ('oko2', GetMapDataPath().."AvengerNAME.txt", GetMapDataPath().."AvengerDSCRP.txt"); end;
  if hero2race == 5 then OverrideObjectTooltipNameAndDescription ('oko2', GetMapDataPath().."MinikNAME.txt", GetMapDataPath().."MinikDSCRP.txt"); end;

  SetRegionBlocked('block1', 1);
  SetRegionBlocked('block2', 1);
  SetRegionBlocked('block3', 1);
  SetRegionBlocked('block4', 1);
  SetRegionBlocked('reg_shop3', 1);
  SetRegionBlocked('reg_shop4', 1);
  SetRegionBlocked('reg_shop5', 1);
  SetRegionBlocked('reg_shop6', 1);

  ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax1, STAT_MANA_POINTS));
  ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax2, STAT_MANA_POINTS));
  ChangeHeroStat(HeroMin1, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMin1, STAT_MANA_POINTS));
  ChangeHeroStat(HeroMin2, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMin2, STAT_MANA_POINTS));

  if hero1race == 4 then AvengerGenerating1(); end;
  if hero2race == 4 then AvengerGenerating2(); end;

  startThread (RaskladkaPolya);
  transferArt (heroes1[0], HeroMax1);
  transferArt (heroes2[0], HeroMax2);
  GiveHeroSkill( heroes1[0],  59); GiveHeroSkill( heroes1[0], 168);
  GiveHeroSkill( heroes2[0], 168);
  if FM == 1 and NumberBattle == 7 then
      SpellMirror();
  else
    SetPosters();
    SpellNabor(hero1race, hero2race);
  end;

  if bonus1 == 'spell' then StartRandomSpell(1); end;
  if bonus2 == 'spell' then StartRandomSpell(2); end;

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

  -- Изменение переданного города на город переданной расы
  function TransformPlayersTown (town, race)
    -- Соотношение расы к ее городу
    local MAP_RACE_TO_TOWN = {
      -- Орден Порядка
      [RACE_HEAVEN] = TOWN_HEAVEN,
      -- Лесной союз
      [RACE_PRESERVE] = TOWN_PRESERVE,
      -- Академия Волшебства
      [RACE_ACADEMY] = TOWN_ACADEMY,
      -- Лига Теней
      [RACE_DUNGEON] = TOWN_DUNGEON,
      -- Некрополис
      [RACE_NECROMANCY] = TOWN_NECROMANCY,
      -- Инферно
      [RACE_INFERNO] = TOWN_INFERNO,
      -- Северные Кланы
      [RACE_DWARF] = TOWN_FORTRESS,
      -- Великая Орда
      [RACE_STRONGHOLD] = TOWN_STRONGHOLD,
    };

    TransformTown(town, MAP_RACE_TO_TOWN[race]);
  end;

  -- Обрати внимание на функции
  -- add_hero (hero2race, x21, x22, y21, y22, 2, hero1race);
  -- unreserve();
end;

----------------------------------------------

function add_hero (race, x1, x2, y1, y2, pl, race_opponent)
  looserHero = 0;
  num_heroes = length(array_heroes[race-1]);

  ------- BLOCK HERO -----------
--  if race == 3 and race_opponent == 3 then array_heroes[2][4].blocked = 1; end;
--  if race == 2 and race_opponent == 6 then array_heroes[1][3].blocked = 1; end;
--  if race == 2 and race_opponent == 3 then array_heroes[1][3].blocked = 1; end;


--  if (race == 6) then num_heroes=12; end;
--  if (race == 1) then num_heroes=13; end;

  for i = 0, 7 do
    for j = 1, length(array_heroes[i]) do
      array_heroes[i][j].block_temply = 1;
    end;
  end;

  if pl == 1 then
    l = length(arrayPossibleHeroes[HeroCollectionPlayer1])
    for i = 1, l do
      rnd = random(l) + 1;
      arrayPossibleHeroes[HeroCollectionPlayer1][i], arrayPossibleHeroes[HeroCollectionPlayer1][rnd] = arrayPossibleHeroes[HeroCollectionPlayer1][rnd], arrayPossibleHeroes[HeroCollectionPlayer1][i];
    end;
    DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][1]].name, x1, y1, 0);
    DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][2]].name, x2, y2, 0);
    HeroMax1 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][1]].name;
    HeroMin1 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][2]].name;
    stop(HeroMax1);
    stop(HeroMin1);
    array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][1]].blocked = 1;
    array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][2]].blocked = 1;
    HeroForScouting1_Player1 = arrayPossibleHeroes[HeroCollectionPlayer1][1];
    HeroForScouting2_Player1 = arrayPossibleHeroes[HeroCollectionPlayer1][2];
    LockMinHeroSkillsAndAttributes(HeroMax1);
    LockMinHeroSkillsAndAttributes(HeroMin1);
    StartArmy(HeroMax1, race);
    StartArmy(HeroMin1, race);
    GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer1][1]);
    GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer1][2]);
  end;
  if pl == 2 then
    num = 0;
    l = length(arrayPossibleHeroes[HeroCollectionPlayer2])
    for i = 1, l do
      rnd = random(l) + 1;
      arrayPossibleHeroes[HeroCollectionPlayer2][i], arrayPossibleHeroes[HeroCollectionPlayer2][rnd] = arrayPossibleHeroes[HeroCollectionPlayer2][rnd], arrayPossibleHeroes[HeroCollectionPlayer2][i];
    end;
    for i = 1, length(arrayPossibleHeroes[HeroCollectionPlayer2]) do
      if array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].blocked ~= 1 and num < 2 then
        if num == 0 then
          DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2, x1, y1, 0);
        else
          DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2, x2, y2, 0);
        end;
        if num == 0 then
          HeroMax2 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2;
          LockMinHeroSkillsAndAttributes(HeroMax2);
          GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer2][i]);
          array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].blocked = 1;
          HeroForScouting1_Player2 = arrayPossibleHeroes[HeroCollectionPlayer2][i];
          num = 1;
        else
          HeroMin2 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2;
          LockMinHeroSkillsAndAttributes(HeroMin2);
          GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer2][i]);
          array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].blocked = 1;
          HeroForScouting2_Player2 = arrayPossibleHeroes[HeroCollectionPlayer2][i];
          num = 2;
        end;
      end;
    end;
    stop(HeroMax2);
    stop(HeroMin2);
    StartArmy(HeroMax2, race);
    StartArmy(HeroMin2, race);
  end;
end;