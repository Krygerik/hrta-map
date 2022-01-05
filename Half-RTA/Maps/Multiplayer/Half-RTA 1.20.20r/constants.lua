-- Файл предназначен для хранение общеигровых фиксированных данных: например тип черка

-- ИД выбранной сложности игры
local DIFFICULTY = GetDifficulty();

-- NOTE: Почему то результат вычислений это 0 или 1, но при этом все равно корректно работает в условия
-- Маппинг сложности игры на черк
GAME_MODE = {
  -- Простой выбор (REKRUT)
  SIMPLE_CHOOSE = DIFFICULTY == DIFFICULTY_EASY,
  -- Черк матчапов (VOIN)
  MATCHUPS = DIFFICULTY == DIFFICULTY_NORMAL,
  -- Получерк (VETERAN)
  HALF = DIFFICULTY == DIFFICULTY_HARD,
  -- Микс черк (GEROI)
  MIX = DIFFICULTY == DIFFICULTY_HEROIC,
}

-- Кастомное перечисление рас, за неимением такого по умолчанию
RACES = {
  -- Орден Порядка
  HAVEN = 0,
  -- Инферно
  INFERNO = 1,
  -- Некрополис
  NECROPOLIS = 2,
  -- Лесной Союз
  SYLVAN = 3,
  -- Акадения Волшебства
  ACADEMY = 4,
  -- Лига Теней
  DUNGEON = 5,
  -- Северные Кланы
  FORTRESS = 6,
  -- Великая Орда
  STRONGHOLD = 7,
  -- Нейстральные юниты
  NEUTRAL = 8,
};

------------------ ГЕРОИ, ИСПОЛЬЗУЮЩИЕСЯ В КАРТЕ ------------------------
HEROES_BY_RACE = {
  [RACES.HAVEN] = {
	  { name = "Orrin",           txt = "haven/heroDugal.txt",    dsc = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt",   [PLAYER_1] = {{ red_icon = "hero_1_1_1", blue_icon = "hero_1_1_2" },   { red_icon = "hero_1_1_5", blue_icon = "hero_1_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_1_1_3", blue_icon = "hero_1_1_4" },   { red_icon = "hero_1_1_7", blue_icon = "hero_1_1_8" }} },
	  { name = "Sarge",           txt = "haven/heroAksel.txt",    dsc = "/Text/Game/Heroes/Specializations/Haven/Jouster/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_2_1_1", blue_icon = "hero_2_1_2" },   { red_icon = "hero_2_1_5", blue_icon = "hero_2_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_2_1_3", blue_icon = "hero_2_1_4" },   { red_icon = "hero_2_1_7", blue_icon = "hero_2_1_8" }} },
	  { name = "Mardigo",         txt = "haven/heroLaslo.txt",    dsc = "/Text/Game/Heroes/Specializations/Haven/Infantry_Commander/Description.txt", [PLAYER_1] = {{ red_icon = "hero_3_1_1", blue_icon = "hero_3_1_2" },   { red_icon = "hero_3_1_5", blue_icon = "hero_3_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_3_1_3", blue_icon = "hero_3_1_4" },   { red_icon = "hero_3_1_7", blue_icon = "hero_3_1_8" }} },
	  { name = "Brem",            txt = "haven/heroRutger.txt",   dsc = "/Text/Game/Heroes/Specializations/Haven/Wanderer/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_4_1_1", blue_icon = "hero_4_1_2" },   { red_icon = "hero_4_1_5", blue_icon = "hero_4_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_4_1_3", blue_icon = "hero_4_1_4" },   { red_icon = "hero_4_1_7", blue_icon = "hero_4_1_8" }} },
	  { name = "Maeve",           txt = "haven/heroMiv.txt",      dsc = "/Text/Game/Heroes/Specializations/Haven/Expediter/Description.txt",          [PLAYER_1] = {{ red_icon = "hero_5_1_1", blue_icon = "hero_5_1_2" },   { red_icon = "hero_5_1_5", blue_icon = "hero_5_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_5_1_3", blue_icon = "hero_5_1_4" },   { red_icon = "hero_5_1_7", blue_icon = "hero_5_1_8" }} },
	  { name = "Ving",            txt = "haven/heroAiris.txt",    dsc = "/Text/Game/Heroes/Specializations/Haven/Griffon_Commander/Description.txt",  [PLAYER_1] = {{ red_icon = "hero_6_1_1", blue_icon = "hero_6_1_2" },   { red_icon = "hero_6_1_5", blue_icon = "hero_6_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_6_1_3", blue_icon = "hero_6_1_4" },   { red_icon = "hero_6_1_7", blue_icon = "hero_6_1_8" }} },
	  { name = "Nathaniel",       txt = "haven/heroEllaina.txt",  dsc = "/Text/Game/Heroes/Specializations/Haven/Squire/Description.txt",             [PLAYER_1] = {{ red_icon = "hero_7_1_1", blue_icon = "hero_7_1_2" },   { red_icon = "hero_7_1_5", blue_icon = "hero_7_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_7_1_3", blue_icon = "hero_7_1_4" },   { red_icon = "hero_7_1_7", blue_icon = "hero_7_1_8" }} },
	  { name = "Christian",       txt = "haven/heroVittorio.txt", dsc = "/Text/Game/Heroes/Specializations/Haven/Artilleryman/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_8_1_1", blue_icon = "hero_8_1_2" },   { red_icon = "hero_8_1_5", blue_icon = "hero_8_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_8_1_3", blue_icon = "hero_8_1_4" },   { red_icon = "hero_8_1_7", blue_icon = "hero_8_1_8" }} },
	  { name = "Godric",          txt = "haven/heroGodric.txt",   dsc = "/Text/Game/Heroes/Specializations/Haven/White_Knight/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_9_1_1", blue_icon = "hero_9_1_2" },   { red_icon = "hero_9_1_5", blue_icon = "hero_9_1_6" }},            [PLAYER_2] = {{ red_icon = "hero_9_1_3", blue_icon = "hero_9_1_4" },   { red_icon = "hero_9_1_7", blue_icon = "hero_9_1_8" }} },
    { name = "RedHeavenHero03", txt = "haven/heroValeria.txt",  dsc = "/Text/Game/Heroes/Specializations/Haven/SpecValeria/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_13_1_1", blue_icon = "hero_13_1_2" }, { red_icon = "hero_13_1_5", blue_icon = "hero_13_1_6" }},          [PLAYER_2] = {{ red_icon = "hero_13_1_3", blue_icon = "hero_13_1_4" }, { red_icon = "hero_13_1_7", blue_icon = "hero_13_1_8" }} },
--	  { name = "Isabell_A1",      txt = "haven/heroIsabel.txt",   p1 = "hero_11_1_1", p2 = "hero_11_1_2", p3 = "hero_11_1_3", p4 = "hero_11_1_4", dsc = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt"},
--	  { name = "Duncan",          txt = "haven/heroDuncan.txt",   p1 = "hero_12_1_1", p2 = "hero_12_1_2", p3 = "hero_12_1_3", p4 = "hero_12_1_4", dsc = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt"},
--    { name = "Nicolai",         txt = "haven/heroNicolai.txt",  p1 = "hero_10_1_1", p2 = "hero_10_1_2", p3 = "hero_10_1_3", p4 = "hero_10_1_4", dsc = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt"}
  },
  [RACES.INFERNO] = {
	  { name = "Grok",        txt = "inferno/heroGrok.txt",       dsc = "/Text/Game/Heroes/Specializations/Inferno/Beater/Description.txt",                [PLAYER_1] = {{ red_icon = "hero_1_2_1", blue_icon = "hero_1_2_2" },   { red_icon = "hero_1_2_5", blue_icon = "hero_1_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_1_2_3", blue_icon = "hero_1_2_4" },   { red_icon = "hero_1_2_7", blue_icon = "hero_1_2_8" }} },
	  { name = "Oddrema",     txt = "inferno/heroDgezebet.txt",   dsc = "/Text/Game/Heroes/Specializations/Inferno/Temptress/Description.txt",             [PLAYER_1] = {{ red_icon = "hero_2_2_1", blue_icon = "hero_2_2_2" },   { red_icon = "hero_2_2_5", blue_icon = "hero_2_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_2_2_3", blue_icon = "hero_2_2_4" },   { red_icon = "hero_2_2_7", blue_icon = "hero_2_2_8" }} },
    { name = "Marder",      txt = "inferno/heroMarbas.txt",     dsc = "/Text/Game/Heroes/Specializations/Inferno/Impregnable/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_3_2_1", blue_icon = "hero_3_2_2" },   { red_icon = "hero_3_2_5", blue_icon = "hero_3_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_3_2_3", blue_icon = "hero_3_2_4" },   { red_icon = "hero_3_2_7", blue_icon = "hero_3_2_8" }} },
	  { name = "Jazaz",       txt = "inferno/heroNibros.txt",     dsc = "/Text/Game/Heroes/Specializations/Inferno/Flagbearer_of_Darkness/Description.txt",[PLAYER_1] = {{ red_icon = "hero_4_2_1", blue_icon = "hero_4_2_2" },   { red_icon = "hero_4_2_5", blue_icon = "hero_4_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_4_2_3", blue_icon = "hero_4_2_4" },   { red_icon = "hero_4_2_7", blue_icon = "hero_4_2_8" }} },
	  { name = "Efion",       txt = "inferno/heroAlastor.txt",    dsc = "/Text/Game/Heroes/Specializations/Inferno/Hypnotist/Description.txt",             [PLAYER_1] = {{ red_icon = "hero_5_2_1", blue_icon = "hero_5_2_2" },   { red_icon = "hero_5_2_5", blue_icon = "hero_5_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_5_2_3", blue_icon = "hero_5_2_4" },   { red_icon = "hero_5_2_7", blue_icon = "hero_5_2_8" }} },
	  { name = "Deleb",       txt = "inferno/heroDeleb.txt",      dsc = "/Text/Game/Heroes/Specializations/Inferno/Bombardier/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_6_2_1", blue_icon = "hero_6_2_2" },   { red_icon = "hero_6_2_5", blue_icon = "hero_6_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_6_2_3", blue_icon = "hero_6_2_4" },   { red_icon = "hero_6_2_7", blue_icon = "hero_6_2_8" }} },
	  { name = "Calid",       txt = "inferno/heroGrol.txt",       dsc = "/Text/Game/Heroes/Specializations/Inferno/Breeder/Description.txt",               [PLAYER_1] = {{ red_icon = "hero_7_2_1", blue_icon = "hero_7_2_2" },   { red_icon = "hero_7_2_5", blue_icon = "hero_7_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_7_2_3", blue_icon = "hero_7_2_4" },   { red_icon = "hero_7_2_7", blue_icon = "hero_7_2_8" }} },
	  { name = "Nymus",       txt = "inferno/heroNimus.txt",      dsc = "/Text/Game/Heroes/Specializations/Inferno/Gate_Keeper/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_8_2_1", blue_icon = "hero_8_2_2" },   { red_icon = "hero_8_2_5", blue_icon = "hero_8_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_8_2_3", blue_icon = "hero_8_2_4" },   { red_icon = "hero_8_2_7", blue_icon = "hero_8_2_8" }} },
	  { name = "Orlando",     txt = "inferno/heroOrlando.txt",    dsc = "/Text/Game/Heroes/Specializations/Inferno/SpecOrlando/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_9_2_1", blue_icon = "hero_9_2_2" },   { red_icon = "hero_9_2_5", blue_icon = "hero_9_2_6" }},            [PLAYER_2] = {{ red_icon = "hero_9_2_3", blue_icon = "hero_9_2_4" },   { red_icon = "hero_9_2_7", blue_icon = "hero_9_2_8" }} },
	  { name = "Agrael",      txt = "inferno/heroAgrail.txt",     dsc = "/Text/Game/Heroes/Specializations/Inferno/SpecAgrael/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_10_2_1", blue_icon = "hero_10_2_2" }, { red_icon = "hero_10_2_5", blue_icon = "hero_10_2_6" }},          [PLAYER_2] = {{ red_icon = "hero_10_2_3", blue_icon = "hero_10_2_4" }, { red_icon = "hero_10_2_7", blue_icon = "hero_10_2_8" }} },
--	  { name = "Kha-Beleth",  txt = "inferno/heroVlastelin.txt",  dsc = "/Text/Game/Heroes/Specializations/Inferno/Beater/Description.txt",                [PLAYER_1] = { red_icon = "hero_11_2_1", blue_icon = "hero_11_2_2" }, [PLAYER_2] = { red_icon = "hero_11_2_3", blue_icon = "hero_11_2_4" } }
  },
  [RACES.NECROPOLIS] = {
	  { name = "Nemor",       txt = "necropolis/heroDeidra.txt",     dsc = "/Text/Game/Heroes/Specializations/Necropolis/Dark_Emissary/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_1_3_1", blue_icon = "hero_1_3_2" },   { red_icon = "hero_1_3_5", blue_icon = "hero_1_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_1_3_3", blue_icon = "hero_1_3_4" },   { red_icon = "hero_1_3_7", blue_icon = "hero_1_3_8" }} },
	  { name = "Tamika",      txt = "necropolis/heroLukrecia.txt",   dsc = "/Text/Game/Heroes/Specializations/Necropolis/Vamipre_Princess/Description.txt",  [PLAYER_1] = {{ red_icon = "hero_2_3_1", blue_icon = "hero_2_3_2" },   { red_icon = "hero_2_3_5", blue_icon = "hero_2_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_2_3_3", blue_icon = "hero_2_3_4" },   { red_icon = "hero_2_3_7", blue_icon = "hero_2_3_8" }} },
	  { name = "Muscip",      txt = "necropolis/heroNaadir.txt",     dsc = "/Text/Game/Heroes/Specializations/Necropolis/Soulhunter/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_3_3_1", blue_icon = "hero_3_3_2" },   { red_icon = "hero_3_3_5", blue_icon = "hero_3_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_3_3_3", blue_icon = "hero_3_3_4" },   { red_icon = "hero_3_3_7", blue_icon = "hero_3_3_8" }} },
	  { name = "Aberrar",     txt = "necropolis/heroZoltan.txt",     dsc = "/Text/Game/Heroes/Specializations/Necropolis/Mind_Cleaner/Description.txt",      [PLAYER_1] = {{ red_icon = "hero_4_3_1", blue_icon = "hero_4_3_2" },   { red_icon = "hero_4_3_5", blue_icon = "hero_4_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_4_3_3", blue_icon = "hero_4_3_4" },   { red_icon = "hero_4_3_7", blue_icon = "hero_4_3_8" }} },
	  { name = "Straker",     txt = "necropolis/heroOrson.txt",      dsc = "/Text/Game/Heroes/Specializations/Necropolis/Zombie_Leader/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_5_3_1", blue_icon = "hero_5_3_2" },   { red_icon = "hero_5_3_5", blue_icon = "hero_5_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_5_3_3", blue_icon = "hero_5_3_4" },   { red_icon = "hero_5_3_7", blue_icon = "hero_5_3_8" }} },
	  { name = "Effig",       txt = "necropolis/heroRavenna.txt",    dsc = "/Text/Game/Heroes/Specializations/Necropolis/Maledictor/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_6_3_1", blue_icon = "hero_6_3_2" },   { red_icon = "hero_6_3_5", blue_icon = "hero_6_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_6_3_3", blue_icon = "hero_6_3_4" },   { red_icon = "hero_6_3_7", blue_icon = "hero_6_3_8" }} },
	  { name = "Pelt",        txt = "necropolis/heroVlad.txt",       dsc = "/Text/Game/Heroes/Specializations/Necropolis/Reanimator/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_7_3_1", blue_icon = "hero_7_3_2" },   { red_icon = "hero_7_3_5", blue_icon = "hero_7_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_7_3_3", blue_icon = "hero_7_3_4" },   { red_icon = "hero_7_3_7", blue_icon = "hero_7_3_8" }} },
	  { name = "Gles",        txt = "necropolis/heroKaspar.txt",     dsc = "/Text/Game/Heroes/Specializations/Necropolis/Empiric/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_8_3_1", blue_icon = "hero_8_3_2" },   { red_icon = "hero_8_3_5", blue_icon = "hero_8_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_8_3_3", blue_icon = "hero_8_3_4" },   { red_icon = "hero_8_3_7", blue_icon = "hero_8_3_8" }} },
	  { name = "Arantir",     txt = "necropolis/heroArantir.txt",    dsc = "/Text/Game/Heroes/Specializations/Necropolis/AvatarOfDeath/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_9_3_1", blue_icon = "hero_9_3_2" },   { red_icon = "hero_9_3_5", blue_icon = "hero_9_3_6" }},   [PLAYER_2] = {{ red_icon = "hero_9_3_3", blue_icon = "hero_9_3_4" },   { red_icon = "hero_9_3_7", blue_icon = "hero_9_3_8" }} },
	  { name = "OrnellaNecro",txt = "necropolis/heroOrnella.txt",    dsc = "/Text/Game/Heroes/Specializations/Necropolis/SpecOrnella/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_10_3_1", blue_icon = "hero_10_3_2" }, { red_icon = "hero_10_3_5", blue_icon = "hero_10_3_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_3_3", blue_icon = "hero_10_3_4" }, { red_icon = "hero_10_3_7", blue_icon = "hero_10_3_8" }} },
    { name = "Berein",      txt = "necropolis/heroMarkel.txt",     dsc = "/Text/Game/Heroes/Specializations/Necropolis/Heir_of_Undeath/Berein.txt",        [PLAYER_1] = {{ red_icon = "hero_11_3_1", blue_icon = "hero_11_3_2" }, { red_icon = "hero_11_3_5", blue_icon = "hero_11_3_6" }}, [PLAYER_2] = {{ red_icon = "hero_11_3_3", blue_icon = "hero_11_3_4" }, { red_icon = "hero_11_3_7", blue_icon = "hero_11_3_8" }} },
    { name = "Nikolas",     txt = "necropolis/heroNikolas.txt",    dsc = "/Text/Game/Heroes/Specializations/Necropolis/SpecNikolas/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_12_3_1", blue_icon = "hero_12_3_2" }, { red_icon = "hero_12_3_5", blue_icon = "hero_12_3_6" }}, [PLAYER_2] = {{ red_icon = "hero_12_3_3", blue_icon = "hero_12_3_4" }, { red_icon = "hero_12_3_7", blue_icon = "hero_12_3_8" }} }
  },
  [RACES.SYLVAN] = {
	  { name = "Metlirn",     txt = "sylvan/heroAnven.txt",      dsc = "/Text/Game/Heroes/Specializations/Preserve/Forest_Guardian/Description.txt",  [PLAYER_1] = {{ red_icon = "hero_1_4_1", blue_icon = "hero_1_4_2" },   { red_icon = "hero_1_4_5", blue_icon = "hero_1_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_1_4_3", blue_icon = "hero_1_4_4" },   { red_icon = "hero_1_4_7", blue_icon = "hero_1_4_8" }} },
	  { name = "Gillion",     txt = "sylvan/heroGilraen.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Blade_Master/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_2_4_1", blue_icon = "hero_2_4_2" },   { red_icon = "hero_2_4_5", blue_icon = "hero_2_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_2_4_3", blue_icon = "hero_2_4_4" },   { red_icon = "hero_2_4_7", blue_icon = "hero_2_4_8" }}  },
	  { name = "Nadaur",      txt = "sylvan/heroTalanar.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Elven_Fury/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_3_4_1", blue_icon = "hero_3_4_2" },   { red_icon = "hero_3_4_5", blue_icon = "hero_3_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_3_4_3", blue_icon = "hero_3_4_4" },   { red_icon = "hero_3_4_7", blue_icon = "hero_3_4_8" }}  },
	  { name = "Diraya",      txt = "sylvan/heroDirael.txt",     dsc = "/Text/Game/Heroes/Specializations/Preserve/Call_of_the_Wasp/Description.txt", [PLAYER_1] = {{ red_icon = "hero_4_4_1", blue_icon = "hero_4_4_2" },   { red_icon = "hero_4_4_5", blue_icon = "hero_4_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_4_4_3", blue_icon = "hero_4_4_4" },   { red_icon = "hero_4_4_7", blue_icon = "hero_4_4_8" }}  },
	  { name = "Ossir",       txt = "sylvan/heroOssir.txt",      dsc = "/Text/Game/Heroes/Specializations/Preserve/Hunter/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_5_4_1", blue_icon = "hero_5_4_2" },   { red_icon = "hero_5_4_5", blue_icon = "hero_5_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_5_4_3", blue_icon = "hero_5_4_4" },   { red_icon = "hero_5_4_7", blue_icon = "hero_5_4_8" }}  },
	  { name = "Itil",        txt = "sylvan/heroIlfina.txt",     dsc = "/Text/Game/Heroes/Specializations/Preserve/Unicorn_Trainer/Description.txt",  [PLAYER_1] = {{ red_icon = "hero_6_4_1", blue_icon = "hero_6_4_2" },   { red_icon = "hero_6_4_5", blue_icon = "hero_6_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_6_4_3", blue_icon = "hero_6_4_4" },   { red_icon = "hero_6_4_7", blue_icon = "hero_6_4_8" }}  },
	  { name = "Elleshar",    txt = "sylvan/heroVinrael.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Talented_Warrior/Description.txt", [PLAYER_1] = {{ red_icon = "hero_7_4_1", blue_icon = "hero_7_4_2" },   { red_icon = "hero_7_4_5", blue_icon = "hero_7_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_7_4_3", blue_icon = "hero_7_4_4" },   { red_icon = "hero_7_4_7", blue_icon = "hero_7_4_8" }}  },
	  { name = "Linaas",      txt = "sylvan/heroVingael.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Waylayer/Description.txt",         [PLAYER_1] = {{ red_icon = "hero_8_4_1", blue_icon = "hero_8_4_2" },   { red_icon = "hero_8_4_5", blue_icon = "hero_8_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_8_4_3", blue_icon = "hero_8_4_4" },   { red_icon = "hero_8_4_7", blue_icon = "hero_8_4_8" }}  },
	  { name = "Heam",        txt = "sylvan/heroFaidaen.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Elven_Volley/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_9_4_1", blue_icon = "hero_9_4_2" },   { red_icon = "hero_9_4_5", blue_icon = "hero_9_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_9_4_3", blue_icon = "hero_9_4_4" },   { red_icon = "hero_9_4_7", blue_icon = "hero_9_4_8" }}  },
	  { name = "Ildar",       txt = "sylvan/heroAlaron.txt",     dsc = "/Text/Game/Heroes/Specializations/Preserve/SpecIldar/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_10_4_1", blue_icon = "hero_10_4_2" }, { red_icon = "hero_10_4_5", blue_icon = "hero_10_4_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_4_3", blue_icon = "hero_10_4_4" }, { red_icon = "hero_10_4_7", blue_icon = "hero_10_4_8" }}  },
--	  { name = "GhostFSLord", txt = "sylvan/heroPrizrak.txt",    dsc = "/Text/Game/Heroes/Specializations/Preserve/Forest_Guardian/Description.txt",  [PLAYER_1] = { red_icon = "hero_11_4_1", blue_icon = "hero_11_4_2" }, [PLAYER_2] = { red_icon = "hero_11_4_3", blue_icon = "hero_11_4_4" }  }
  },
  [RACES.ACADEMY] = {
	  { name = "Faiz",        txt = "academy/heroFaiz.txt",       dsc = "/Text/Game/Heroes/Specializations/Academy/Disrupter/Description.txt",          [PLAYER_1] = {{ red_icon = "hero_1_5_1", blue_icon = "hero_1_5_2" },   { red_icon = "hero_1_5_5", blue_icon = "hero_1_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_1_5_3", blue_icon = "hero_1_5_4" }, { red_icon = "hero_1_5_7", blue_icon = "hero_1_5_8" }} },
	  { name = "Havez",       txt = "academy/heroHafiz.txt",      dsc = "/Text/Game/Heroes/Specializations/Academy/Artisan/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_2_5_1", blue_icon = "hero_2_5_2" },   { red_icon = "hero_2_5_5", blue_icon = "hero_2_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_2_5_3", blue_icon = "hero_2_5_4" }, { red_icon = "hero_2_5_7", blue_icon = "hero_2_5_8" }} },
	  { name = "Nur",         txt = "academy/heroNazir.txt",      dsc = "/Text/Game/Heroes/Specializations/Academy/Weilder_of_Fire/Description.txt",    [PLAYER_1] = {{ red_icon = "hero_3_5_1", blue_icon = "hero_3_5_2" },   { red_icon = "hero_3_5_5", blue_icon = "hero_3_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_3_5_3", blue_icon = "hero_3_5_4" }, { red_icon = "hero_3_5_7", blue_icon = "hero_3_5_8" }} },
	  { name = "Astral",      txt = "academy/heroNura.txt",       dsc = "/Text/Game/Heroes/Specializations/Academy/Inexhaustible/Description.txt",      [PLAYER_1] = {{ red_icon = "hero_4_5_1", blue_icon = "hero_4_5_2" },   { red_icon = "hero_4_5_5", blue_icon = "hero_4_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_4_5_3", blue_icon = "hero_4_5_4" }, { red_icon = "hero_4_5_7", blue_icon = "hero_4_5_8" }} },
	  { name = "Sufi",        txt = "academy/heroOra.txt",        dsc = "/Text/Game/Heroes/Specializations/Academy/Feather_Mage/Description.txt",       [PLAYER_1] = {{ red_icon = "hero_5_5_1", blue_icon = "hero_5_5_2" },   { red_icon = "hero_5_5_5", blue_icon = "hero_5_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_5_5_3", blue_icon = "hero_5_5_4" }, { red_icon = "hero_5_5_7", blue_icon = "hero_5_5_8" }} },
	  { name = "Razzak",      txt = "academy/heroNarhiz.txt",     dsc = "/Text/Game/Heroes/Specializations/Academy/Mentor/Description.txt",             [PLAYER_1] = {{ red_icon = "hero_6_5_1", blue_icon = "hero_6_5_2" },   { red_icon = "hero_6_5_5", blue_icon = "hero_6_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_6_5_3", blue_icon = "hero_6_5_4" }, { red_icon = "hero_6_5_7", blue_icon = "hero_6_5_8" }} },
	  { name = "Tan",         txt = "academy/heroDgalib.txt",     dsc = "/Text/Game/Heroes/Specializations/Academy/Radiant/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_7_5_1", blue_icon = "hero_7_5_2" },   { red_icon = "hero_7_5_5", blue_icon = "hero_7_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_7_5_3", blue_icon = "hero_7_5_4" }, { red_icon = "hero_7_5_7", blue_icon = "hero_7_5_8" }} },
	  { name = "Isher",       txt = "academy/heroRazzak.txt",     dsc = "/Text/Game/Heroes/Specializations/Academy/Machinist/Description.txt",          [PLAYER_1] = {{ red_icon = "hero_8_5_1", blue_icon = "hero_8_5_2" },   { red_icon = "hero_8_5_5", blue_icon = "hero_8_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_8_5_3", blue_icon = "hero_8_5_4" }, { red_icon = "hero_8_5_7", blue_icon = "hero_8_5_8" }} },
	  { name = "Zehir",       txt = "academy/heroZehir.txt",      dsc = "/Text/Game/Heroes/Specializations/Academy/Master_of_Elements/Description.txt", [PLAYER_1] = {{ red_icon = "hero_9_5_1", blue_icon = "hero_9_5_2" },   { red_icon = "hero_9_5_5", blue_icon = "hero_9_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_9_5_3", blue_icon = "hero_9_5_4" }, { red_icon = "hero_9_5_7", blue_icon = "hero_9_5_8" }} },
	  { name = "Maahir",      txt = "academy/heroMaahir.txt",     dsc = "/Text/Game/Heroes/Specializations/Academy/SpecMaahir/Description.txt",         [PLAYER_1] = {{ red_icon = "hero_10_5_1", blue_icon = "hero_10_5_2" }, { red_icon = "hero_10_5_5", blue_icon = "hero_10_5_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_5_3", blue_icon = "hero_10_5_4" }, { red_icon = "hero_10_5_7", blue_icon = "hero_10_5_8" }} },
--	  { name = "Cyrus",       txt = "academy/heroSairus.txt",     dsc = "/Text/Game/Heroes/Specializations/Academy/SpecCyrus/Description.txt",          [PLAYER_1] = { red_icon = "hero_11_5_1", blue_icon = "hero_11_5_2" }, [PLAYER_2] = { red_icon = "hero_11_5_3", blue_icon = "hero_11_5_4" } }
  },
  [RACES.DUNGEON] = {
	  { name = "Eruina",      txt = "dungeon/heroErin.txt",       dsc = "/Text/Game/Heroes/Specializations/Dungeon/Matron_Salvo/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_1_6_1", blue_icon = "hero_1_6_2" }, { red_icon = "hero_1_6_5", blue_icon = "hero_1_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_1_6_3", blue_icon = "hero_1_6_4" }, { red_icon = "hero_1_6_7", blue_icon = "hero_1_6_8" }} },
	  { name = "Inagost",     txt = "dungeon/heroSinitar.txt",    dsc = "/Text/Game/Heroes/Specializations/Dungeon/Power_Bargain/Description.txt",          [PLAYER_1] = {{ red_icon = "hero_2_6_1", blue_icon = "hero_2_6_2" }, { red_icon = "hero_2_6_5", blue_icon = "hero_2_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_2_6_3", blue_icon = "hero_2_6_4" }, { red_icon = "hero_2_6_7", blue_icon = "hero_2_6_8" }} },
	  { name = "Urunir",      txt = "dungeon/heroIranna.txt",     dsc = "/Text/Game/Heroes/Specializations/Dungeon/Seducer/Description.txt",                [PLAYER_1] = {{ red_icon = "hero_3_6_1", blue_icon = "hero_3_6_2" }, { red_icon = "hero_3_6_5", blue_icon = "hero_3_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_3_6_3", blue_icon = "hero_3_6_4" }, { red_icon = "hero_3_6_7", blue_icon = "hero_3_6_8" }} },
	  { name = "Almegir",     txt = "dungeon/heroIrbet.txt",      dsc = "/Text/Game/Heroes/Specializations/Dungeon/Dark_Acolyte/Description.txt",           [PLAYER_1] = {{ red_icon = "hero_4_6_1", blue_icon = "hero_4_6_2" }, { red_icon = "hero_4_6_5", blue_icon = "hero_4_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_4_6_3", blue_icon = "hero_4_6_4" }, { red_icon = "hero_4_6_7", blue_icon = "hero_4_6_8" }} },
	  { name = "Menel",       txt = "dungeon/heroKifra.txt",      dsc = "/Text/Game/Heroes/Specializations/Dungeon/Slaveholder/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_5_6_1", blue_icon = "hero_5_6_2" }, { red_icon = "hero_5_6_5", blue_icon = "hero_5_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_5_6_3", blue_icon = "hero_5_6_4" }, { red_icon = "hero_5_6_7", blue_icon = "hero_5_6_8" }} },
	  { name = "Dalom",       txt = "dungeon/heroLetos.txt",      dsc = "/Text/Game/Heroes/Specializations/Dungeon/Poisoner/Description.txt",               [PLAYER_1] = {{ red_icon = "hero_6_6_1", blue_icon = "hero_6_6_2" }, { red_icon = "hero_6_6_5", blue_icon = "hero_6_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_6_6_3", blue_icon = "hero_6_6_4" }, { red_icon = "hero_6_6_7", blue_icon = "hero_6_6_8" }} },
	  { name = "Ferigl",      txt = "dungeon/heroSorgal.txt",     dsc = "/Text/Game/Heroes/Specializations/Dungeon/Lizard_Breeder/Description.txt",         [PLAYER_1] = {{ red_icon = "hero_7_6_1", blue_icon = "hero_7_6_2" }, { red_icon = "hero_7_6_5", blue_icon = "hero_7_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_7_6_3", blue_icon = "hero_7_6_4" }, { red_icon = "hero_7_6_7", blue_icon = "hero_7_6_8" }} },
	  { name = "Ohtarig",     txt = "dungeon/heroVaishan.txt",    dsc = "/Text/Game/Heroes/Specializations/Dungeon/Savage/Description.txt",                 [PLAYER_1] = {{ red_icon = "hero_8_6_1", blue_icon = "hero_8_6_2" }, { red_icon = "hero_8_6_5", blue_icon = "hero_8_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_8_6_3", blue_icon = "hero_8_6_4" }, { red_icon = "hero_8_6_7", blue_icon = "hero_8_6_8" }} },
--	  { name = "Raelag_A1",   txt = "dungeon/heroRailag.txt",     dsc = "/Text/Game/Heroes/Specializations/Dungeon/MasterOfInitiative/Description.txt",     [PLAYER_1] = { red_icon = "hero_9_6_1", blue_icon = "hero_9_6_2" }, [PLAYER_2] = { red_icon = "hero_9_6_3", blue_icon = "hero_9_6_4" } },
	  { name = "Kelodin",     txt = "dungeon/heroShadia.txt",     dsc = "/Text/Game/Heroes/Specializations/Dungeon/Evasive/Description.txt",                [PLAYER_1] = {{ red_icon = "hero_10_6_1", blue_icon = "hero_10_6_2" }, { red_icon = "hero_10_6_5", blue_icon = "hero_10_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_6_3", blue_icon = "hero_10_6_4" }, { red_icon = "hero_10_6_7", blue_icon = "hero_10_6_8" }} },
	  { name = "Shadwyn",     txt = "dungeon/heroIlaiya.txt",     dsc = "/Text/Game/Heroes/Specializations/Dungeon/SpecShadwyn/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_11_6_1", blue_icon = "hero_11_6_2" }, { red_icon = "hero_11_6_5", blue_icon = "hero_11_6_6" }}, [PLAYER_2] = {{ red_icon = "hero_11_6_3", blue_icon = "hero_11_6_4" }, { red_icon = "hero_11_6_7", blue_icon = "hero_11_6_8" }} },
--	  { name = "Thralsai",    txt = "dungeon/heroTralsai.txt",    dsc = "/Text/Game/Heroes/Specializations/Dungeon/SpecThralsai/Description.txt",           [PLAYER_1] = { red_icon = "hero_12_6_1", blue_icon = "hero_12_6_2" }, [PLAYER_2] = { red_icon = "hero_12_6_3", blue_icon = "hero_12_6_4" } }
  },
  [RACES.FORTRESS] = {
 	  { name = "Brand",       txt = "fortress/heroBrand.txt",      dsc = "/Text/Game/Heroes/Specializations/Fortress/Economist/Description.txt",    [PLAYER_1] = {{ red_icon = "hero_1_7_1", blue_icon = "hero_1_7_2" }, { red_icon = "hero_1_7_5", blue_icon = "hero_1_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_1_7_3", blue_icon = "hero_1_7_4" }, { red_icon = "hero_1_7_7", blue_icon = "hero_1_7_8" }} },
	  { name = "Bersy",       txt = "fortress/heroIbba.txt",       dsc = "/Text/Game/Heroes/Specializations/Fortress/Rider/Description.txt",        [PLAYER_1] = {{ red_icon = "hero_2_7_1", blue_icon = "hero_2_7_2" }, { red_icon = "hero_2_7_5", blue_icon = "hero_2_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_2_7_3", blue_icon = "hero_2_7_4" }, { red_icon = "hero_2_7_7", blue_icon = "hero_2_7_8" }} },
	  { name = "Egil",        txt = "fortress/heroErling.txt",     dsc = "/Text/Game/Heroes/Specializations/Fortress/Magister/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_3_7_1", blue_icon = "hero_3_7_2" }, { red_icon = "hero_3_7_5", blue_icon = "hero_3_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_3_7_3", blue_icon = "hero_3_7_4" }, { red_icon = "hero_3_7_7", blue_icon = "hero_3_7_8" }} },
	  { name = "Ottar",       txt = "fortress/heroHelmar.txt",     dsc = "/Text/Game/Heroes/Specializations/Fortress/Sacred_Hammer/Description.txt",[PLAYER_1] = {{ red_icon = "hero_4_7_1", blue_icon = "hero_4_7_2" }, { red_icon = "hero_4_7_5", blue_icon = "hero_4_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_4_7_3", blue_icon = "hero_4_7_4" }, { red_icon = "hero_4_7_7", blue_icon = "hero_4_7_8" }} },
	  { name = "Una",         txt = "fortress/heroInga.txt",       dsc = "/Text/Game/Heroes/Specializations/Fortress/Researcher/Description.txt",   [PLAYER_1] = {{ red_icon = "hero_5_7_1", blue_icon = "hero_5_7_2" }, { red_icon = "hero_5_7_5", blue_icon = "hero_5_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_5_7_3", blue_icon = "hero_5_7_4" }, { red_icon = "hero_5_7_7", blue_icon = "hero_5_7_8" }} },
	  { name = "Ingvar",      txt = "fortress/heroIngvar.txt",     dsc = "/Text/Game/Heroes/Specializations/Fortress/Defender/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_6_7_1", blue_icon = "hero_6_7_2" }, { red_icon = "hero_6_7_5", blue_icon = "hero_6_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_6_7_3", blue_icon = "hero_6_7_4" }, { red_icon = "hero_6_7_7", blue_icon = "hero_6_7_8" }} },
	  { name = "Vegeyr",      txt = "fortress/heroSveya.txt",      dsc = "/Text/Game/Heroes/Specializations/Fortress/Stormcaller/Description.txt",  [PLAYER_1] = {{ red_icon = "hero_7_7_1", blue_icon = "hero_7_7_2" }, { red_icon = "hero_7_7_5", blue_icon = "hero_7_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_7_7_3", blue_icon = "hero_7_7_4" }, { red_icon = "hero_7_7_7", blue_icon = "hero_7_7_8" }} },
	  { name = "Skeggy",      txt = "fortress/heroKarli.txt",      dsc = "/Text/Game/Heroes/Specializations/Fortress/Axe_Master/Description.txt",   [PLAYER_1] = {{ red_icon = "hero_8_7_1", blue_icon = "hero_8_7_2" }, { red_icon = "hero_8_7_5", blue_icon = "hero_8_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_8_7_3", blue_icon = "hero_8_7_4" }, { red_icon = "hero_8_7_7", blue_icon = "hero_8_7_8" }} },
--	  { name = "KingTolghar", txt = "fortress/heroTolgar.txt",     dsc = "/Text/Game/Heroes/Specializations/Fortress/Mountain_King/Description.txt",[PLAYER_1] = { red_icon = "hero_9_7_1", blue_icon = "hero_9_7_2" }, [PLAYER_2] = { red_icon = "hero_9_7_3", blue_icon = "hero_9_7_4" } },
	  { name = "Wulfstan",    txt = "fortress/heroVulfsten.txt",   dsc = "/Text/Game/Heroes/Specializations/Fortress/SpecWulfstan/Description.txt", [PLAYER_1] = {{ red_icon = "hero_10_7_1", blue_icon = "hero_10_7_2" }, { red_icon = "hero_10_7_5", blue_icon = "hero_10_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_7_3", blue_icon = "hero_10_7_4" }, { red_icon = "hero_10_7_7", blue_icon = "hero_10_7_8" }} },
	  { name = "Rolf",        txt = "fortress/heroRolf.txt",       dsc = "/Text/Game/Heroes/Specializations/Fortress/SpecRolf/Description.txt",     [PLAYER_1] = {{ red_icon = "hero_11_7_1", blue_icon = "hero_11_7_2" }, { red_icon = "hero_11_7_5", blue_icon = "hero_11_7_6" }}, [PLAYER_2] = {{ red_icon = "hero_11_7_3", blue_icon = "hero_11_7_4" }, { red_icon = "hero_11_7_7", blue_icon = "hero_11_7_8" }} }
  },
  [RACES.STRONGHOLD] = {
--	  { name = "Hero2",       txt = "stronghold/heroArgat.txt",      dsc = "/Text/Game/Heroes/Specializations/Stronghold/SpecArgat/Description.txt",                  [PLAYER_1] = { red_icon = "hero_1_8_1", blue_icon = "hero_1_8_2" }, [PLAYER_2] = { red_icon = "hero_1_8_3", blue_icon = "hero_1_8_4" } },
	  { name = "Hero3",       txt = "stronghold/heroGaruna.txt",     dsc = "/Text/Game/Heroes/Specializations/Stronghold/Blooddrinker/Description.txt",               [PLAYER_1] = {{ red_icon = "hero_2_8_1", blue_icon = "hero_2_8_2" }, { red_icon = "hero_2_8_5", blue_icon = "hero_2_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_2_8_3", blue_icon = "hero_2_8_4" }, { red_icon = "hero_2_8_7", blue_icon = "hero_2_8_8" }} },
	  { name = "Hero6",       txt = "stronghold/heroShakKarukat.txt",dsc = "/Text/Game/Heroes/Specializations/Stronghold/SpecShak/Description.txt",                   [PLAYER_1] = {{ red_icon = "hero_3_8_1", blue_icon = "hero_3_8_2" }, { red_icon = "hero_3_8_5", blue_icon = "hero_3_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_3_8_3", blue_icon = "hero_3_8_4" }, { red_icon = "hero_3_8_7", blue_icon = "hero_3_8_8" }} },
	  { name = "Hero8",       txt = "stronghold/heroTilsek.txt",     dsc = "/Text/Game/Heroes/Specializations/Stronghold/GrimFighter/Description.txt",                [PLAYER_1] = {{ red_icon = "hero_4_8_1", blue_icon = "hero_4_8_2" }, { red_icon = "hero_4_8_5", blue_icon = "hero_4_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_4_8_3", blue_icon = "hero_4_8_4" }, { red_icon = "hero_4_8_7", blue_icon = "hero_4_8_8" }} },
	  { name = "Hero7",       txt = "stronghold/heroHaggesh.txt",    dsc = "/Text/Game/Heroes/Specializations/Stronghold/CentaurMistress/Description.txt",            [PLAYER_1] = {{ red_icon = "hero_5_8_1", blue_icon = "hero_5_8_2" }, { red_icon = "hero_5_8_5", blue_icon = "hero_5_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_5_8_3", blue_icon = "hero_5_8_4" }, { red_icon = "hero_5_8_7", blue_icon = "hero_5_8_8" }} },
 	  { name = "Hero1",       txt = "stronghold/heroKrag.txt",       dsc = "/Text/Game/Heroes/Specializations/Stronghold/Offender/Description.txt",                   [PLAYER_1] = {{ red_icon = "hero_6_8_1", blue_icon = "hero_6_8_2" }, { red_icon = "hero_6_8_5", blue_icon = "hero_6_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_6_8_3", blue_icon = "hero_6_8_4" }, { red_icon = "hero_6_8_7", blue_icon = "hero_6_8_8" }} },
 	  { name = "Hero9",       txt = "stronghold/heroKigan.txt",      dsc = "/Text/Game/Heroes/Specializations/Stronghold/GoblinKing/Description.txt",                 [PLAYER_1] = {{ red_icon = "hero_7_8_1", blue_icon = "hero_7_8_2" }, { red_icon = "hero_7_8_5", blue_icon = "hero_7_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_7_8_3", blue_icon = "hero_7_8_4" }, { red_icon = "hero_7_8_7", blue_icon = "hero_7_8_8" }} },
	  { name = "Hero4",       txt = "stronghold/heroGoshak.txt",     dsc = "/Text/Game/Heroes/Specializations/Stronghold/OrcElder/Description.txt",                   [PLAYER_1] = {{ red_icon = "hero_8_8_1", blue_icon = "hero_8_8_2" }, { red_icon = "hero_8_8_5", blue_icon = "hero_8_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_8_8_3", blue_icon = "hero_8_8_4" }, { red_icon = "hero_8_8_7", blue_icon = "hero_8_8_8" }} },
	  { name = "Kujin",       txt = "stronghold/heroKudgin.txt",     dsc = "/Text/Game/Heroes/Specializations/Stronghold/SpecKujin/Description.txt",                  [PLAYER_1] = {{ red_icon = "hero_9_8_1", blue_icon = "hero_9_8_2" }, { red_icon = "hero_9_8_5", blue_icon = "hero_9_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_9_8_3", blue_icon = "hero_9_8_4" }, { red_icon = "hero_9_8_7", blue_icon = "hero_9_8_8" }} },
	  { name = "Gottai",      txt = "stronghold/heroGotai.txt",      dsc = "/Text/Game/Heroes/Specializations/Stronghold/WarLeader/Description.txt",                  [PLAYER_1] = {{ red_icon = "hero_10_8_1", blue_icon = "hero_10_8_2" }, { red_icon = "hero_10_8_5", blue_icon = "hero_10_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_10_8_3", blue_icon = "hero_10_8_4" }, { red_icon = "hero_10_8_7", blue_icon = "hero_10_8_8" }} },
	  { name = "Quroq",       txt = "stronghold/heroKurak.txt",      dsc = "/Text/Game/Heroes/Specializations/Stronghold/SpecQuroq/Description.txt",                  [PLAYER_1] = {{ red_icon = "hero_11_8_1", blue_icon = "hero_11_8_2" }, { red_icon = "hero_11_8_5", blue_icon = "hero_11_8_6" }}, [PLAYER_2] = {{ red_icon = "hero_11_8_3", blue_icon = "hero_11_8_4" }, { red_icon = "hero_11_8_7", blue_icon = "hero_11_8_8" }} }
  }
};

-- Биара (герой красного)
Biara = GetPlayerHeroes(PLAYER_1)[0]
-- Джованни (негой синего)
Djovanni = GetPlayerHeroes(PLAYER_2)[0]

-- Итоговый список расы и героев для игры
-- Служит для передачи значения для начала прокачки
RESULT_HERO_LIST = {
  [PLAYER_1] = { raceId = nil, heroes = {} },
  [PLAYER_2] = { raceId = nil, heroes = {} },
};

-- Все свойства главных героев игроков
-- Заполняется на этапе обучения героев
PLAYERS_MAIN_HERO_PROPS = {
  [PLAYER_1] = {
    name = nil,
    -- Список снимаемых артефактов на моменты изменения статов
    removedHeroArtIdList = {},
    -- Стартовые статы героя (до прокачки)
    start_stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Статы, полученные за уровни с рассовым распределением
    stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Статы, которые были получены за навыки
    stats_for_skills = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Дополнительные статы с образования разделенные на уровни
    -- разбил на уровни для удобства отката
    learning = {
      [1] = nil,
      [2] = nil,
      [3] = nil,
    },
    -- текущий уровень образования
    current_learning_level = 0,
    -- Покупаемые статы
    buy_stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Количество купленных статов
    count_buy_stats = 0,
  },
  [PLAYER_2] = {
    name = nil,
    -- Список снимаемых артефактов на моменты изменения статов
    removedHeroArtIdList = {},
    -- Стартовые статы героя (до прокачки)
    start_stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Статы, полученные за уровни с рассовым распределением
    stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Статы, которые были получены за навыки
    stats_for_skills = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Дополнительные статы с образования разделенные на уровни
    -- разбил на уровни для удобства отката
    learning = {
      [1] = nil,
      [2] = nil,
      [3] = nil,
    },
    -- текущий уровень образования
    current_learning_level = 0,
    -- Покупаемые статы
    buy_stats = {
      [STAT_ATTACK] = 0,
      [STAT_DEFENCE] = 0,
      [STAT_SPELL_POWER] = 0,
      [STAT_KNOWLEDGE] = 0
    },
    -- Количество купленных статов
    count_buy_stats = 0,
  },
};

-- Таблица ИД всех игроков
PLAYER_ID_TABLE = { PLAYER_1, PLAYER_2 };

-- Список начальных навыков и/или школ для каждого героя
INITIAL_HERO_SKILLS = {
  Orrin = { SKILL_OFFENCE, PERK_ARCHERY },
  Sarge = { SKILL_OFFENCE, PERK_HOLY_CHARGE },
  Mardigo = { SKILL_DEFENCE, PERK_TOUGHNESS },
  Brem = { SKILL_TRAINING, SKILL_TRAINING },
  Maeve = { SKILL_LIGHT_MAGIC, PERK_MASTER_OF_WRATH },
  Ving = { SKILL_LUCK, PERK_RESISTANCE },
  Nathaniel = { SKILL_LEADERSHIP, PERK_RECRUITMENT },
  Christian = { SKILL_WAR_MACHINES, PERK_BALLISTA },
  Godric = { SKILL_LIGHT_MAGIC, PERK_PRAYER },
  RedHeavenHero03 = { SKILL_SORCERY, SKILL_DARK_MAGIC },
  Isabell_A1 = { SKILL_LIGHT_MAGIC, SKILL_LIGHT_MAGIC },
  Duncan = { SKILL_OFFENCE, PERK_TACTICS },
  Nicolai = { SKILL_TRAINING, SKILL_TRAINING },
  Grok = { SKILL_LOGISTICS, PERK_PATHFINDING },
  Oddrema = { SKILL_SORCERY, PERK_WISDOM },
  Marder = { SKILL_DEFENCE, PERK_PROTECTION },
  Jazaz = { SKILL_OFFENCE, PERK_TACTICS },
  Efion = { SKILL_DARK_MAGIC, SKILL_DARK_MAGIC },
  Deleb = { SKILL_WAR_MACHINES, PERK_BALLISTA },
  Calid = { SKILL_DESTRUCTIVE_MAGIC, PERK_DEMONIC_FIRE },
  Nymus = { SKILL_LUCK, PERK_RESISTANCE },
  Orlando = { SKILL_LEADERSHIP, PERK_DEMONIC_STRIKE },
  Agrael = { SKILL_OFFENCE, PERK_FRENZY },
  ["Kha-Beleth"] = { SKILL_DARK_MAGIC, PERK_DEMONIC_FIRE },
  Nemor = { SKILL_OFFENCE, PERK_FRENZY },
  Tamika = { SKILL_OFFENCE, PERK_FRENZY },
  Muscip = { SKILL_SUMMONING_MAGIC, SKILL_DARK_MAGIC },
  Aberrar = { SKILL_LEARNING, PERK_INTELLIGENCE },
  Straker = { SKILL_DEFENCE, PERK_TOUGHNESS },
  Effig = { SKILL_DARK_MAGIC, PERK_MASTER_OF_CURSES },
  Pelt = { SKILL_SUMMONING_MAGIC, PERK_MASTER_OF_ANIMATION },
  Gles = { SKILL_WAR_MACHINES, PERK_FIRST_AID },
  Arantir = { SKILL_SUMMONING_MAGIC, NECROMANCER_FEAT_SPIRIT_LINK },
  OrnellaNecro = { SKILL_LEADERSHIP, PERK_NO_REST_FOR_THE_WICKED },
  Berein = { SKILL_NECROMANCY, SKILL_NECROMANCY },
  Nikolas = { SKILL_LEARNING, SKILL_LEARNING },
  Metlirn = { SKILL_AVENGER, SKILL_AVENGER },
  Gillion = { SKILL_DEFENCE, PERK_TOUGHNESS },
  Nadaur = { SKILL_LEADERSHIP, PERK_RECRUITMENT },
  Diraya = { SKILL_SUMMONING_MAGIC, PERK_MASTER_OF_CREATURES },
  Ossir = { SKILL_LUCK, PERK_RESISTANCE },
  Itil = { SKILL_LIGHT_MAGIC, PERK_MASTER_OF_BLESSING },
  Elleshar = { SKILL_LEARNING, PERK_INTELLIGENCE },
  Linaas = { SKILL_OFFENCE, PERK_TACTICS },
  Heam = { SKILL_OFFENCE, PERK_ARCHERY },
  Ildar = { SKILL_LIGHT_MAGIC, SKILL_LIGHT_MAGIC },
  GhostFSLord = { SKILL_LEARNING, SKILL_SUMMONING_MAGIC },
  Faiz = { SKILL_DARK_MAGIC, PERK_MASTER_OF_SICKNESS },
  Havez = { SKILL_WAR_MACHINES, PERK_MELT_ARTIFACT },
  Nur = { SKILL_DESTRUCTIVE_MAGIC, PERK_MASTER_OF_FIRE },
  Astral = { SKILL_SORCERY, PERK_MAGIC_BOND },
  Sufi = { SKILL_SORCERY, PERK_ARCANE_TRAINING },
  Razzak = { SKILL_LEARNING, PERK_INTELLIGENCE },
  Tan = { SKILL_LUCK, PERK_MAGIC_MIRROR },
  Isher = { SKILL_DEFENCE, PERK_TOUGHNESS },
  Zehir = { SKILL_SUMMONING_MAGIC, PERK_MASTER_OF_CREATURES },
  Maahir = { SKILL_ARTIFICIER, SKILL_ARTIFICIER },
  Cyrus = { SKILL_LIGHT_MAGIC, SKILL_LIGHT_MAGIC },
  Eruina = { SKILL_OFFENCE, SKILL_DESTRUCTIVE_MAGIC },
  Inagost = { SKILL_DESTRUCTIVE_MAGIC, PERK_EMPOWERED_SPELLS },
  Urunir = { SKILL_LEARNING, PERK_INTELLIGENCE },
  Almegir = { SKILL_SUMMONING_MAGIC, PERK_DARK_RITUAL },
  Menel = { SKILL_LEADERSHIP, PERK_ESTATES },
  Dalom = { SKILL_DARK_MAGIC, PERK_MASTER_OF_SICKNESS },
  Ferigl = { SKILL_OFFENCE, PERK_FRENZY },
  Ohtarig = { SKILL_LUCK, PERK_LUCKY_STRIKE },
  Raelag_A1 = { SKILL_LOGISTICS, SKILL_INVOCATION },
  Kelodin = { SKILL_DEFENCE, PERK_EVASION },
  Shadwyn = { SKILL_INVOCATION, NECROMANCER_FEAT_ABSOLUTE_FEAR },
  Thralsai = { SKILL_LEARNING,  SKILL_LEARNING },
  Brand = { HERO_SKILL_RUNELORE, HERO_SKILL_FINE_RUNE },
  Bersy = { SKILL_OFFENCE, PERK_TACTICS },
  Egil = { SKILL_SORCERY, SKILL_SORCERY },
  Ottar = { SKILL_LIGHT_MAGIC, SKILL_LIGHT_MAGIC },
  Una = { SKILL_LEARNING, PERK_SCHOLAR },
  Ingvar = { SKILL_DEFENCE, PERK_TOUGHNESS },
  Vegeyr = { SKILL_DESTRUCTIVE_MAGIC, PERK_MASTER_OF_LIGHTNINGS },
  Skeggy = { SKILL_LUCK, PERK_LUCKY_STRIKE },
  KingTolghar = { HERO_SKILL_RUNELORE, HERO_SKILL_RUNELORE },
  Wulfstan = { SKILL_LOGISTICS, PERK_PATHFINDING },
  Rolf = { SKILL_LEADERSHIP, PERK_DIPLOMACY },
  Hero2 = { SKILL_WAR_MACHINES, PERK_FIRST_AID },
  Hero3 = { SKILL_OFFENCE, PERK_FRENZY },
  Hero6 = { SKILL_DEFENCE, PERK_TOUGHNESS },
  Hero8 = { SKILL_WAR_MACHINES, HERO_SKILL_MIGHT_OVER_MAGIC },
  Hero7 = { SKILL_OFFENCE, PERK_ARCHERY },
  Hero1 = { SKILL_OFFENCE, HERO_SKILL_POWERFULL_BLOW },
  Hero9 = { SKILL_LEADERSHIP, PERK_RECRUITMENT },
  Hero4 = { HERO_SKILL_DEMONIC_RAGE, HERO_SKILL_POWERFULL_BLOW },
  Kujin = { HERO_SKILL_BARBARIAN_LEARNING, HERO_SKILL_MEMORY_OF_OUR_BLOOD },
  Gottai = { HERO_SKILL_DEMONIC_RAGE, HERO_SKILL_VOICE },
  Quroq = { HERO_SKILL_VOICE, HERO_SKILL_VOICE_OF_RAGE },
};

-- Соотношение словарного названия героя с названия героев, выданных игрокам
MAPPING_HERO_NAME_TO_PLAYERS_HERO_NAME = {
    { dictName = "Orrin", reservedNames = { "Orrin", "Orrin2" } },
    { dictName = "Sarge", reservedNames = { "Sarge", "Sarge2" } },
    { dictName = "Mardigo", reservedNames = { "Mardigo", "Mardigo2" } },
    { dictName = "Brem", reservedNames = { "Brem", "Brem2" } },
    { dictName = "Maeve", reservedNames = { "Maeve", "Maeve2" } },
    { dictName = "Ving", reservedNames = { "Ving", "Ving2" } },
    { dictName = "Nathaniel", reservedNames = { "Nathaniel", "Nathaniel2" } },
    { dictName = "Christian", reservedNames = { "Christian", "Christian2" } },
    { dictName = "Godric", reservedNames = { "Godric", "Godric2" } },
    { dictName = "RedHeavenHero03", reservedNames = { "RedHeavenHero03", "RedHeavenHero032" } },
    { dictName = "Isabell_A1", reservedNames = { "Isabell_A1", "Isabell_A12" } },
    { dictName = "Duncan", reservedNames = { "Duncan", "Duncan2" } },
    { dictName = "Nicolai", reservedNames = { "Nicolai", "Nicolai2" } },
    { dictName = "Grok", reservedNames = { "Grok", "Grok2" } },
    { dictName = "Oddrema", reservedNames = {"Oddrema", "Oddrema2" } },
    { dictName = "Marder", reservedNames = { "Marder", "Marder2" } },
    { dictName = "Jazaz", reservedNames = { "Jazaz", "Jazaz2" } },
    { dictName = "Efion", reservedNames = { "Efion", "Efion2" } },
    { dictName = "Deleb", reservedNames = { "Deleb", "Deleb2" } },
    { dictName = "Calid", reservedNames = { "Calid", "Calid2" } },
    { dictName = "Nymus", reservedNames = { "Nymus", "Nymus2" } },
    { dictName = "Orlando", reservedNames = { "Orlando", "Orlando2" } },
    { dictName = "Agrael", reservedNames = { "Agrael", "Agrael2" } },
    { dictName = "Kha-Beleth", reservedNames = { "Kha-Beleth", "Kha-Beleth2" } },
    { dictName = "Nemor", reservedNames = { "Nemor", "Nemor2" } },
    { dictName = "Tamika", reservedNames = { "Tamika", "Tamika2" } },
    { dictName = "Muscip", reservedNames = { "Muscip", "Muscip2" } },
    { dictName = "Aberrar", reservedNames = { "Aberrar", "Aberrar2" } },
    { dictName = "Straker", reservedNames = { "Straker", "Straker2" } },
    { dictName = "Effig", reservedNames = { "Effig", "Effig2" } },
    { dictName = "Pelt", reservedNames = { "Pelt", "Pelt2" } },
    { dictName = "Gles", reservedNames = { "Gles", "Gles2" } },
    { dictName = "Arantir", reservedNames = { "Arantir", "Arantir2" } },
    { dictName = "OrnellaNecro", reservedNames = { "OrnellaNecro", "OrnellaNecro2" } },
    { dictName = "Berein", reservedNames = { "Berein", "Berein2" } },
    { dictName = "Nikolas", reservedNames = { "Nikolas", "Nikolas2" } },
    { dictName = "Metlirn", reservedNames = { "Metlirn", "Metlirn2" } },
    { dictName = "Gillion", reservedNames = { "Gillion", "Gillion2" } },
    { dictName = "Nadaur", reservedNames = { "Nadaur", "Nadaur2" } },
    { dictName = "Diraya", reservedNames = { "Diraya", "Diraya2" } },
    { dictName = "Ossir", reservedNames = { "Ossir", "Ossir2" } },
    { dictName = "Itil", reservedNames = { "Itil", "Itil2" } },
    { dictName = "Elleshar", reservedNames = { "Elleshar", "Elleshar2" } },
    { dictName = "Linaas", reservedNames = { "Linaas", "Linaas2" } },
    { dictName = "Heam", reservedNames = { "Heam", "Heam2" } },
    { dictName = "Ildar", reservedNames = { "Ildar", "Ildar2" } },
    { dictName = "GhostFSLord", reservedNames = { "GhostFSLord", "GhostFSLord2" } },
    { dictName = "Faiz", reservedNames = { "Faiz", "Faiz2" } },
    { dictName = "Havez", reservedNames = { "Havez", "Havez2" } },
    { dictName = "Nur", reservedNames = { "Nur", "Nur2" } },
    { dictName = "Astral", reservedNames = { "Astral", "Astral2" } },
    { dictName = "Sufi", reservedNames = { "Sufi", "Sufi2" } },
    { dictName = "Razzak", reservedNames = { "Razzak", "Razzak2" } },
    { dictName = "Tan", reservedNames = { "Tan", "Tan2" } },
    { dictName = "Isher", reservedNames = { "Isher", "Isher2" } },
    { dictName = "Zehir", reservedNames = { "Zehir", "Zehir2" } },
    { dictName = "Maahir", reservedNames = { "Maahir", "Maahir2" } },
    { dictName = "Cyrus", reservedNames = { "Cyrus", "Cyrus2" } },
    { dictName = "Eruina", reservedNames = { "Eruina", "Eruina2" } },
    { dictName = "Inagost", reservedNames = { "Inagost", "Inagost2" } },
    { dictName = "Urunir", reservedNames = { "Urunir", "Urunir2" } },
    { dictName = "Almegir", reservedNames = { "Almegir", "Almegir2" } },
    { dictName = "Menel", reservedNames = { "Menel", "Menel2" } },
    { dictName = "Dalom", reservedNames = { "Dalom", "Dalom2" } },
    { dictName = "Ferigl", reservedNames = { "Ferigl", "Ferigl2" } },
    { dictName = "Ohtarig", reservedNames = { "Ohtarig", "Ohtarig2" } },
    { dictName = "Raelag_A1", reservedNames = { "Raelag_A1", "Raelag_A12" } },
    { dictName = "Kelodin", reservedNames = { "Kelodin", "Kelodin2" } },
    { dictName = "Shadwyn", reservedNames = { "Shadwyn", "Shadwyn2" } },
    { dictName = "Thralsai", reservedNames = { "Thralsai", "Thralsai2" } },
    { dictName = "Brand", reservedNames = { "Brand", "Brand2" } },
    { dictName = "Bersy", reservedNames = { "Bersy", "Bersy2" } },
    { dictName = "Egil", reservedNames = { "Egil", "Egil2" } },
    { dictName = "Ottar", reservedNames = { "Ottar", "Ottar2" } },
    { dictName = "Una", reservedNames = { "Una", "Una2" } },
    { dictName = "Ingvar", reservedNames = { "Ingvar", "Ingvar2" } },
    { dictName = "Vegeyr", reservedNames = { "Vegeyr", "Vegeyr2" } },
    { dictName = "Skeggy", reservedNames = { "Skeggy", "Skeggy2" } },
    { dictName = "KingTolghar", reservedNames = { "KingTolghar", "KingTolghar2" } },
    { dictName = "Wulfstan", reservedNames = { "Wulfstan", "Wulfstan2" } },
    { dictName = "Rolf", reservedNames = { "Rolf", "Rolf2" } },
    { dictName = "Hero2", reservedNames = { "Hero2", "Hero22" } },
    { dictName = "Hero3", reservedNames = { "Hero3", "Hero32" } },
    { dictName = "Hero6", reservedNames = { "Hero6", "Hero62" } },
    { dictName = "Hero8", reservedNames = { "Hero8", "Hero82" } },
    { dictName = "Hero7", reservedNames = { "Hero7", "Hero72" } },
    { dictName = "Hero1", reservedNames = { "Hero1", "Hero12" } },
    { dictName = "Hero9", reservedNames = { "Hero9", "Hero92" } },
    { dictName = "Hero4", reservedNames = { "Hero4", "Hero42" } },
    { dictName = "Kujin", reservedNames = { "Kujin", "Kujin2" } },
    { dictName = "Gottai", reservedNames = { "Gottai", "Gottai2" } },
    { dictName = "Quroq", reservedNames = { "Quroq", "Quroq2" } },
};

-- Уровни ценности артефактов (Потом, наверно, пригодится)
ARTS_LEVELS = {
  MINOR = 0,
  MAJOR = 1,
  RELIC = 2
};

-- Позиция артефакта в инвентаре
ART_POSITION = {
  RING = 1,
  HEAD = 2,
  NECK = 3,
  BODY = 4,
  SHILD = 5,
  BAG = 6,
  WEAPON = 7,
  BOOTS = 8,
  BACK = 9,
};

-- Список всех доступных артефактов
ALL_ARTS_LIST = {
  { id = 1,  level = ARTS_LEVELS.MINOR, position = ART_POSITION.WEAPON },  --меч мощи
  { id = 90, level = ARTS_LEVELS.MINOR, position = ART_POSITION.WEAPON }, -- на грани равновесия
  { id = 8,  level = ARTS_LEVELS.MINOR, position = ART_POSITION.BAG },  -- клевер
  { id = 87, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BAG }, -- колода таро
  { id = 27, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BOOTS }, -- сапоги магической защиты
  -- { id = 34, level = ARTS_LEVELS.MINOR, position = ART_POSITION.HEAD }, -- тюрбан просвещенности
  { id = 66, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BODY }, -- шлем хаоса
  { id = 64, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BODY }, -- туника из плоти
  { id = 14, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BODY }, -- нагрудник мощи
  { id = 80, level = ARTS_LEVELS.MINOR, position = ART_POSITION.WEAPON }, -- палочка новичка
  { id = 62, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BACK }, -- плащ силанны
  { id = 84, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BACK }, -- защитные покровы
  { id = 20, level = ARTS_LEVELS.MINOR, position = ART_POSITION.RING }, -- кольцо от молний
  { id = 60, level = ARTS_LEVELS.MINOR, position = ART_POSITION.RING }, -- пояс элементалей
  { id = 16, level = ARTS_LEVELS.MINOR, position = ART_POSITION.NECK }, -- ошейник льва
  { id = 55, level = ARTS_LEVELS.MINOR, position = ART_POSITION.HEAD }, -- шлем некроманта
  { id = 70, level = ARTS_LEVELS.MINOR, position = ART_POSITION.RING }, -- кольцо грешников
  { id = 10, level = ARTS_LEVELS.MINOR, position = ART_POSITION.SHILD }, -- свиток маны
  { id = 56, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BODY }, -- доспех бесстрашия
  -- { id = 86, level = ARTS_LEVELS.MINOR, position = ART_POSITION.BAG }, -- руна пламени
  -- { id = 61, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BOOTS }, -- изумрудные туфли
  -- { id = 32, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BACK }, -- накидка феникса
  { id = 65, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.RING }, -- кольцо предостережения
  -- { id = 93, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.RING }, -- кольцо изгнания
  { id = 74, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.WEAPON }, -- дубина орка
  { id = 85, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.WEAPON }, -- гномий молот
  { id = 81, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.WEAPON }, -- рунный топор
  { id = 2,  level = ARTS_LEVELS.MAJOR, position = ART_POSITION.WEAPON },  -- секира горного короля
  { id = 43, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.WEAPON }, -- меч дракона
  { id = 58, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.SHILD }, -- лунный клинок
  { id = 75, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.SHILD }, -- щит орка
  { id = 9,  level = ARTS_LEVELS.MAJOR, position = ART_POSITION.SHILD }, -- ледяной щит
  { id = 71, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.SHILD }, -- том силы (амулет некроманта)
  { id = 37, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.SHILD }, -- щит дракона
  { id = 25, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BAG }, -- золотая подкова
  { id = 38, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BOOTS }, -- поножи дракона
  { id = 41, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.HEAD }, -- шлем дракона
  { id = 82, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BODY }, -- рунная упряжь
  { id = 36, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BODY }, -- доспех дракона
  { id = 31, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BACK }, -- накидка льва
  { id = 95, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BACK }, -- колчан единорога
  { id = 39, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BACK }, -- мантия дракона
  { id = 23, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.RING }, -- кольцо сломленного духа
  { id = 63, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.RING },  --кольцо неудачи
  { id = 42, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.RING }, -- кольцо дракона
  { id = 19, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.NECK }, -- ожерелье победы
  { id = 40, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.NECK }, -- ожерелье дракона
  -- { id = 35, level = ARTS_LEVELS.MAJOR, position = ART_POSITION.BODY }, -- кольчуга просвещенности
  { id = 17, level = ARTS_LEVELS.RELIC, position = ART_POSITION.NECK }, -- ожерелье коготь
  { id = 59, level = ARTS_LEVELS.RELIC, position = ART_POSITION.RING }, -- кольцо стремительности
  { id = 57, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BOOTS }, -- сапоги скорости
  { id = 88, level = ARTS_LEVELS.RELIC, position = ART_POSITION.HEAD }, -- корона лидерства
  -- { id = 91, level = ARTS_LEVELS.RELIC, position = ART_POSITION.RING }, -- кольцо машин
  { id = 4,  level = ARTS_LEVELS.RELIC, position = ART_POSITION.WEAPON },  -- лук единорога
  { id = 45, level = ARTS_LEVELS.RELIC, position = ART_POSITION.WEAPON }, -- посох сар-иссы
  { id = 51, level = ARTS_LEVELS.RELIC, position = ART_POSITION.SHILD }, -- щит гномов
  { id = 79, level = ARTS_LEVELS.RELIC, position = ART_POSITION.SHILD }, -- том призыва
  { id = 77, level = ARTS_LEVELS.RELIC, position = ART_POSITION.SHILD }, -- том света
  { id = 78, level = ARTS_LEVELS.RELIC, position = ART_POSITION.SHILD }, -- том тьмы
  { id = 76, level = ARTS_LEVELS.RELIC, position = ART_POSITION.SHILD }, -- том хаоса
  { id = 83, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BAG }, -- череп маркела
  { id = 68, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BOOTS }, -- сандали святого
  { id = 49, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BOOTS }, -- поножи гномов
  { id = 11, level = ARTS_LEVELS.RELIC, position = ART_POSITION.HEAD }, -- корона льва
  { id = 50, level = ARTS_LEVELS.RELIC, position = ART_POSITION.HEAD }, -- шлем гномов
  { id = 44, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BODY }, -- халат сар-иссы
  { id = 48, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BODY }, -- кираса гномов
  { id = 13, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BODY }, -- доспех забытого
  { id = 33, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BACK }, -- плащ смерти
  { id = 47, level = ARTS_LEVELS.RELIC, position = ART_POSITION.RING }, -- кольцо сар-иссы
  { id = 67, level = ARTS_LEVELS.RELIC, position = ART_POSITION.NECK }, -- кулон поглощения
  { id = 5,  level = ARTS_LEVELS.RELIC, position = ART_POSITION.WEAPON },  -- трезубец титанов
  { id = 18, level = ARTS_LEVELS.RELIC, position = ART_POSITION.NECK }, -- ледяной кулон
  { id = 7,  level = ARTS_LEVELS.RELIC, position = ART_POSITION.WEAPON },  -- посох преисподней (кандалы неизбежности)
  -- { id = 15, level = ARTS_LEVELS.RELIC, position = ART_POSITION.NECK }, -- кулон мастерства
  -- { id = 6, level = ARTS_LEVELS.RELIC, position = ART_POSITION.WEAPON },  -- посох преисподней
  -- { id = 89, level = ARTS_LEVELS.RELIC, position = ART_POSITION.HEAD }, -- маска справедливости
  -- { id = 69, level = ARTS_LEVELS.RELIC, position = ART_POSITION.BACK }, -- плащ сандро
  -- { id = 22, level = ARTS_LEVELS.RELIC, position = ART_POSITION.RING }, -- кольцо скорости
};

array_arts[0] = {
   { ["name"] = "art1",  ["name2"] = "art1x2",  ["place"] = 7, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 1},   --меч мощи
   { ["name"] = "art2",  ["name2"] = "art2x2",  ["place"] = 7, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 90},  --на грани равновесия
   { ["name"] = "art4",  ["name2"] = "art4x2",  ["place"] = 6, ["price"] = 4000,  ["blocked"] = 0, ["id"] = 8},   --клевер
   { ["name"] = "art5",  ["name2"] = "art5x2",  ["place"] = 6, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 87},  --колода таро
   { ["name"] = "art6",  ["name2"] = "art6x2",  ["place"] = 8, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 27},  --сапоги магической защиты
--   { ["name"] = "art7",  ["name2"] = "art7x2",  ["place"] = 2, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 34},  --тюрбан просвещенности
   { ["name"] = "art8",  ["name2"] = "art8x2",  ["place"] = 2, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 66},  --шлем хаоса
   { ["name"] = "art9",  ["name2"] = "art9x2",  ["place"] = 4, ["price"] = 5500,  ["blocked"] = 0, ["id"] = 64},  --туника из плоти
   { ["name"] = "art10", ["name2"] = "art10x2", ["place"] = 4, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 14},  --нагрудник мощи
   { ["name"] = "art12", ["name2"] = "art12x2", ["place"] = 7, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 80},  --палочка новичка
   { ["name"] = "art13", ["name2"] = "art13x2", ["place"] = 9, ["price"] = 7000,  ["blocked"] = 0, ["id"] = 62},  --плащ силанны
   { ["name"] = "art14", ["name2"] = "art14x2", ["place"] = 9, ["price"] = 4500,  ["blocked"] = 0, ["id"] = 84},  --защитные покровы
   { ["name"] = "art15", ["name2"] = "art15x2", ["place"] = 1, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 20},  --кольцо от молний
   { ["name"] = "art16", ["name2"] = "art16x2", ["place"] = 1, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 60},  --пояс элементалей
   { ["name"] = "art17", ["name2"] = "art17x2", ["place"] = 3, ["price"] = 4500,  ["blocked"] = 0, ["id"] = 16},  --ошейник льва
   { ["name"] = "art19", ["name2"] = "art19x2", ["place"] = 2, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 55},  --шлем некроманта
   { ["name"] = "art20", ["name2"] = "art20x2", ["place"] = 1, ["price"] = 4500,  ["blocked"] = 0, ["id"] = 70},  --кольцо грешников
   { ["name"] = "art21", ["name2"] = "art21x2", ["place"] = 6, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 10},  --свиток маны
   { ["name"] = "art11", ["name2"] = "art11x2", ["place"] = 4, ["price"] = 7000,  ["blocked"] = 0, ["id"] = 56},  --доспех бесстрашия
--   { ["name"] = "art22", ["name2"] = "art22x2", ["place"] = 6, ["price"] = 6500,  ["blocked"] = 1, ["id"] = 86}   --руна пламени
};
array_arts[1] = {
--   { ["name"] = "art23", ["name2"] = "art23x2", ["place"] = 8, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 61},  --изумрудные туфли
--   { ["name"] = "art24", ["name2"] = "art24x2", ["place"] = 9, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 32},  --накидка феникса
   { ["name"] = "art26", ["name2"] = "art26x2", ["place"] = 1, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 65},  --кольцо предостережения
--   { ["name"] = "art27", ["name2"] = "art27x2", ["place"] = 1, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 93},  --кольцо изгнания
   { ["name"] = "art29", ["name2"] = "art29x2", ["place"] = 7, ["price"] = 7500,  ["blocked"] = 0, ["id"] = 74},  --дубина орка
   { ["name"] = "art30", ["name2"] = "art30x2", ["place"] = 7, ["price"] = 9500,  ["blocked"] = 0, ["id"] = 85},  --гномий молот
   { ["name"] = "art31", ["name2"] = "art31x2", ["place"] = 7, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 81},  --рунный топор
   { ["name"] = "art32", ["name2"] = "art32x2", ["place"] = 7, ["price"] = 10000, ["blocked"] = 0, ["id"] = 2},   --секира горного короля
   { ["name"] = "art33", ["name2"] = "art33x2", ["place"] = 7, ["price"] = 12500, ["blocked"] = 0, ["id"] = 43},  --меч дракона
   { ["name"] = "art34", ["name2"] = "art34x2", ["place"] = 5, ["price"] = 7500,  ["blocked"] = 0, ["id"] = 58},  --лунный клинок
   { ["name"] = "art35", ["name2"] = "art35x2", ["place"] = 5, ["price"] = 8500,  ["blocked"] = 0, ["id"] = 75},  --щит орка
   { ["name"] = "art36", ["name2"] = "art36x2", ["place"] = 5, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 9},   --ледяной щит
   { ["name"] = "art37", ["name2"] = "art37x2", ["place"] = 5, ["price"] = 10000, ["blocked"] = 0, ["id"] = 71},  --том силы (амулет некроманта)
   { ["name"] = "art38", ["name2"] = "art38x2", ["place"] = 5, ["price"] = 10000, ["blocked"] = 0, ["id"] = 37},  --щит дракона
   { ["name"] = "art39", ["name2"] = "art39x2", ["place"] = 6, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 25},  --золотая подкова
   { ["name"] = "art40", ["name2"] = "art40x2", ["place"] = 8, ["price"] = 10000, ["blocked"] = 0, ["id"] = 38},  --поножи дракона
   { ["name"] = "art41", ["name2"] = "art41x2", ["place"] = 2, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 41},  --шлем дракона
   { ["name"] = "art42", ["name2"] = "art42x2", ["place"] = 4, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 82},  --рунная упряжь
   { ["name"] = "art43", ["name2"] = "art43x2", ["place"] = 4, ["price"] = 11000, ["blocked"] = 0, ["id"] = 36},  --доспех дракона
   { ["name"] = "art44", ["name2"] = "art44x2", ["place"] = 9, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 31},  --накидка льва
   { ["name"] = "art45", ["name2"] = "art45x2", ["place"] = 9, ["price"] = 7500,  ["blocked"] = 0, ["id"] = 95},  --колчан единорога
   { ["name"] = "art46", ["name2"] = "art46x2", ["place"] = 9, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 39},  --мантия дракона
   { ["name"] = "art47", ["name2"] = "art47x2", ["place"] = 1, ["price"] = 10000, ["blocked"] = 0, ["id"] = 23},  --кольцо сломленного духа
   { ["name"] = "art48", ["name2"] = "art48x2", ["place"] = 1, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 63},  --кольцо неудачи
   { ["name"] = "art49", ["name2"] = "art49x2", ["place"] = 1, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 21},  --кольцо жизненной силы
   { ["name"] = "art51", ["name2"] = "art51x2", ["place"] = 1, ["price"] = 11000, ["blocked"] = 0, ["id"] = 42},  --кольцо дракона
   { ["name"] = "art53", ["name2"] = "art53x2", ["place"] = 3, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 19},  --ожерелье победы
   { ["name"] = "art54", ["name2"] = "art54x2", ["place"] = 3, ["price"] = 10000, ["blocked"] = 0, ["id"] = 40}   --ожерелье дракона
--   { ["name"] = "art55", ["name2"] = "art55x2", ["place"] = 4, ["price"] = 6500,  ["blocked"] = 0, ["id"] = 35}   --кольчуга просвещенности
};
array_arts[2] = {
   { ["name"] = "art52", ["name2"] = "art52x2", ["place"] = 3, ["price"] = 12000, ["blocked"] = 0, ["id"] = 17},  --ожерелье коготь
   { ["name"] = "art50", ["name2"] = "art50x2", ["place"] = 1, ["price"] = 12000, ["blocked"] = 0, ["id"] = 59},  --кольцо стремительности
   { ["name"] = "art28", ["name2"] = "art28x2", ["place"] = 8, ["price"] = 12000, ["blocked"] = 0, ["id"] = 57},  --сапоги скорости
   { ["name"] = "art25", ["name2"] = "art25x2", ["place"] = 2, ["price"] = 12000, ["blocked"] = 0, ["id"] = 88},  --корона лидерства
--   { ["name"] = "art56", ["name2"] = "art56x2", ["place"] = 1, ["price"] = 20000, ["blocked"] = 0, ["id"] = 91},  --кольцо машин
   { ["name"] = "art57", ["name2"] = "art57x2", ["place"] = 7, ["price"] = 15000, ["blocked"] = 0, ["id"] = 4},   --лук единорога
   { ["name"] = "art58", ["name2"] = "art58x2", ["place"] = 7, ["price"] = 12000, ["blocked"] = 0, ["id"] = 45},  --посох сар-иссы
   { ["name"] = "art59", ["name2"] = "art59x2", ["place"] = 5, ["price"] = 13000, ["blocked"] = 0, ["id"] = 51},  --щит гномов
   { ["name"] = "art60", ["name2"] = "art60x2", ["place"] = 5, ["price"] = 12000, ["blocked"] = 0, ["id"] = 79},  --том призыва
   { ["name"] = "art61", ["name2"] = "art61x2", ["place"] = 5, ["price"] = 13000, ["blocked"] = 0, ["id"] = 77},  --том света
   { ["name"] = "art62", ["name2"] = "art62x2", ["place"] = 5, ["price"] = 13000, ["blocked"] = 0, ["id"] = 78},  --том тьмы
   { ["name"] = "art63", ["name2"] = "art63x2", ["place"] = 5, ["price"] = 12000, ["blocked"] = 0, ["id"] = 76},  --том хаоса
   { ["name"] = "art64", ["name2"] = "art64x2", ["place"] = 6, ["price"] = 16000, ["blocked"] = 0, ["id"] = 83},  --череп маркела
   { ["name"] = "art65", ["name2"] = "art65x2", ["place"] = 8, ["price"] = 14500, ["blocked"] = 0, ["id"] = 68},  --сандали святого
   { ["name"] = "art66", ["name2"] = "art66x2", ["place"] = 8, ["price"] = 13000, ["blocked"] = 0, ["id"] = 49},  --поножи гномов
   { ["name"] = "art67", ["name2"] = "art67x2", ["place"] = 2, ["price"] = 16000, ["blocked"] = 0, ["id"] = 11},  --корона льва
   { ["name"] = "art68", ["name2"] = "art68x2", ["place"] = 2, ["price"] = 15000, ["blocked"] = 0, ["id"] = 46},  --корона сар-иссы
   { ["name"] = "art69", ["name2"] = "art69x2", ["place"] = 2, ["price"] = 13000, ["blocked"] = 0, ["id"] = 50},  --шлем гномов
   { ["name"] = "art70", ["name2"] = "art70x2", ["place"] = 4, ["price"] = 15000, ["blocked"] = 0, ["id"] = 44},  --халат сар-иссы
   { ["name"] = "art71", ["name2"] = "art71x2", ["place"] = 4, ["price"] = 13000, ["blocked"] = 0, ["id"] = 48},  --кираса гномов
   { ["name"] = "art72", ["name2"] = "art72x2", ["place"] = 4, ["price"] = 23000, ["blocked"] = 0, ["id"] = 13},  --доспех забытого
   { ["name"] = "art73", ["name2"] = "art73x2", ["place"] = 9, ["price"] = 18000, ["blocked"] = 0, ["id"] = 33},  --плащ смерти
   { ["name"] = "art74", ["name2"] = "art74x2", ["place"] = 1, ["price"] = 17000, ["blocked"] = 0, ["id"] = 47},  --кольцо сар-иссы
   { ["name"] = "art75", ["name2"] = "art75x2", ["place"] = 3, ["price"] = 12000, ["blocked"] = 0, ["id"] = 67},  --кулон поглощения
   { ["name"] = "art3",  ["name2"] = "art3x2",  ["place"] = 7, ["price"] = 14000, ["blocked"] = 0, ["id"] = 5},   --трезубец титанов
   { ["name"] = "art18", ["name2"] = "art18x2", ["place"] = 3, ["price"] = 14000, ["blocked"] = 0, ["id"] = 18},  --ледяной кулон
   { ["name"] = "art77", ["name2"] = "art77x2", ["place"] = 7, ["price"] = 13000, ["blocked"] = 0, ["id"] = 7}    --посох преисподней (кандалы неизбежности)
--   { ["name"] = "art76", ["name2"] = "art76x2", ["place"] = 3, ["price"] = 15000, ["blocked"] = 0, ["id"] = 15},  --кулон мастерства
--   { ["name"] = "art78", ["name2"] = "art78x2", ["place"] = 7, ["price"] = 35000, ["blocked"] = 1, ["id"] = 6},   --посох преисподней
--   { ["name"] = "art79", ["name2"] = "art79x2", ["place"] = 2, ["price"] = 26000, ["blocked"] = 1, ["id"] = 89},  --маска справедливости
--   { ["name"] = "art80", ["name2"] = "art80x2", ["place"] = 9, ["price"] = 16000, ["blocked"] = 1, ["id"] = 69},  --плащ сандро
--   { ["name"] = "art81", ["name2"] = "art81x2", ["place"] = 1, ["price"] = 30000, ["blocked"] = 1, ["id"] = 22}   --кольцо скорости
};
