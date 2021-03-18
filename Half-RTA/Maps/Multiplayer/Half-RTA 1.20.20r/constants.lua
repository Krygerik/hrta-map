-- ���� ������������ ��� �������� ����������� ������������� ������: �������� ��� �����

-- �� ��������� ��������� ����
local DIFFICULTY = GetDifficulty();

-- NOTE: ������ �� ��������� ���������� ��� 0 ��� 1, �� ��� ���� ��� ����� ��������� �������� � �������
-- ������� ��������� ���� �� ����
GAME_MODE = {
  -- ������� ����� (REKRUT)
  SIMPLE_CHOOSE = DIFFICULTY == DIFFICULTY_EASY,
  -- ���� �������� (VOIN)
  MATCHUPS = DIFFICULTY == DIFFICULTY_NORMAL,
  -- �������� (VETERAN)
  HALF = DIFFICULTY == DIFFICULTY_HARD,
  -- ���� ���� (GEROI)
  MIX = DIFFICULTY == DIFFICULTY_HEROIC,
}

-- ��������� ������������ ���, �� ��������� ������ �� ���������
RACES = {
  -- ����� �������
  HAVEN = 0,
  -- �������
  INFERNO = 1,
  -- ����������
  NECROPOLIS = 2,
  -- ������ ����
  SYLVAN = 3,
  -- �������� ����������
  ACADEMY = 4,
  -- ���� �����
  DUNGEON = 5,
  -- �������� �����
  FORTRESS = 6,
  -- ������� ����
  STRONGHOLD = 7,
};

------------------ �����, �������������� � ����� ------------------------
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

-- ����� (����� ��������)
Biara = GetPlayerHeroes(PLAYER_1)[0]
-- �������� (����� ������)
Djovanni = GetPlayerHeroes(PLAYER_2)[0]
