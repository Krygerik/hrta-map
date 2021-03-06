-- ИД поверхности
local GROUND_UP_ID = 0;

-- Биара (герой красного)
local HeroDop1 = GetPlayerHeroes(PLAYER_1)[0]
-- Джованни (негой синего)
local HeroDop2 = GetPlayerHeroes(PLAYER_2)[0]

-- Перемещаем камеру второго игрока
MoveCameraForPlayers( GetPlayerFilter(PLAYER_2), 42, 24, GROUND_UP_ID, 40, 0, 3.14, 0, 0, 1);

stop(HeroDop1);
ChangeHeroStat(HeroDop1, STAT_MOVE_POINTS, 500);
stop(HeroDop2);
ChangeHeroStat(HeroDop2, STAT_MOVE_POINTS, 500);

OpenCircleFog(57, 80, GROUND_UP_ID, 14, PLAYER_1);
OpenCircleFog(31, 14, GROUND_UP_ID, 17, PLAYER_2);
OpenCircleFog(54, 12, GROUND_UP_ID, 14, PLAYER_2);

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

if option[NumberBattle] == 5 then SetArtNabor(); end;
if option[NumberBattle] == 6 then UnitShop(); end;

startThread (RemoveStartUnit1);
startThread (RemoveStartUnit2);

-- Снимает все очки передвижения у героя
function stop (hero)
  ChangeHeroStat (hero, STAT_MOVE_POINTS, -50000);
end;

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
