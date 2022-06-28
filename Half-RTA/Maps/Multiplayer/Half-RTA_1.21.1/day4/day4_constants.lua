
-- Соотношение игроков на Id гарнизонов для Некромантии
MAP_GARNISON_FOR_NECROMANCY = {
  [PLAYER_1] = 'Garrison1',
  [PLAYER_2] = 'Garrison2',
};

-- Соотношение существ к их грейдам
MAP_CREATURES_ON_GRADE = {
  [CREATURE_ROYAL_GRIFFIN] = CREATURE_BATTLE_GRIFFIN,
  [CREATURE_PRIEST] = CREATURE_ZEALOT,
  [CREATURE_CAVALIER] = CREATURE_CHAMPION,
  [CREATURE_ANGEL] = CREATURE_SERAPH,
  [CREATURE_SUCCUBUS] = CREATURE_SUCCUBUS_SEDUCER,
  [CREATURE_NIGHTMARE] = CREATURE_HELLMARE,
  [CREATURE_PIT_FIEND] = CREATURE_PIT_SPAWN,
  [CREATURE_DEVIL] = CREATURE_ARCH_DEMON,
  [CREATURE_VAMPIRE] = CREATURE_NOSFERATU,
  [CREATURE_LICH] = CREATURE_LICH_MASTER,
  [CREATURE_WIGHT] = CREATURE_BANSHEE,
  [CREATURE_BONE_DRAGON] = CREATURE_HORROR_DRAGON,
  [CREATURE_DRUID] = CREATURE_HIGH_DRUID,
  [CREATURE_UNICORN] = CREATURE_WHITE_UNICORN,
  [CREATURE_TREANT] = CREATURE_ANGER_TREANT,
  [CREATURE_GREEN_DRAGON] = CREATURE_RAINBOW_DRAGON,
  [CREATURE_MAGI] = CREATURE_COMBAT_MAGE,
  [CREATURE_GENIE] = CREATURE_DJINN_VIZIER,
  [CREATURE_RAKSHASA] = CREATURE_RAKSHASA_KSHATRI,
  [CREATURE_RAKSHASA_RUKH] = CREATURE_TITAN,
  [CREATURE_GIANT] = CREATURE_STORM_LORD,
  [CREATURE_RIDER] = CREATURE_BLACK_RIDER,
  [CREATURE_HYDRA] = CREATURE_ACIDIC_HYDRA,
  [CREATURE_MATRON] = CREATURE_SHADOW_MISTRESS,
  [CREATURE_DEEP_DRAGON] = CREATURE_RED_DRAGON,
  [CREATURE_BROWLER] = CREATURE_BATTLE_RAGER,
  [CREATURE_RUNE_MAGE] = CREATURE_FLAME_KEEPER,
  [CREATURE_THANE] = CREATURE_THUNDER_THANE,
  [CREATURE_MAGMA_DRAGON] = CREATURE_LAVA_DRAGON,
  [CREATURE_SHAMAN] = CREATURE_SHAMAN_HAG,
  [CREATURE_ORCCHIEF_BUTCHER] = CREATURE_ORCCHIEF_CHIEFTAIN,
  [CREATURE_WYVERN] = CREATURE_WYVERN_PAOKAI,
  [CREATURE_CYCLOP] = CREATURE_CYCLOP_BLOODEYED,
};

-- Гарнизоны для сражения с эльфом
ELF_ENEMY_GARNISONS = {
  [RACES.HAVEN] = {
    { kol = 44, id =  1 },
    { kol = 24, id =  3 },
    { kol = 20, id =  5 },
    { kol = 10, id =  7 },
    { kol =  6, id =  9 },
    { kol =  4, id = 11 },
    { kol =  2, id = 13 },
  },
  [RACES.INFERNO] = {
    { kol = 32, id = 15 },
    { kol = 30, id = 17 },
    { kol = 16, id = 19 },
    { kol = 10, id = 21 },
    { kol =  6, id = 23 },
    { kol =  4, id =136 },
    { kol =  2, id = 27 },
  },
  [RACES.NECROPOLIS] = {
    { kol = 40, id = 29 },
    { kol = 30, id = 31 },
    { kol = 18, id = 34 },
    { kol = 10, id = 35 },
    { kol =  6, id = 37 },
    { kol =  4, id = 39 },
    { kol =  2, id = 41 },
  },
  [RACES.SYLVAN] = {
    { kol = 30, id = 43 },
    { kol = 18, id = 45 },
    { kol = 14, id = 47 },
    { kol =  8, id = 49 },
    { kol =  6, id = 51 },
    { kol =  4, id = 53 },
    { kol =  2, id = 55 },
  },
  [RACES.ACADEMY] = {
    { kol = 40, id = 57 },
    { kol = 28, id = 59 },
    { kol = 18, id = 61 },
    { kol = 10, id = 63 },
    { kol =  6, id = 65 },
    { kol =  4, id = 67 },
    { kol =  2, id = 69 },
  },
  [RACES.DUNGEON] = {
    { kol = 14, id = 92 },
    { kol = 10, id = 73 },
    { kol = 12, id = 75 },
    { kol =  8, id = 77 },
    { kol =  6, id = 79 },
    { kol =  4, id = 81 },
    { kol =  2, id = 83 },
  },
  [RACES.FORTRESS] = {
    { kol = 36, id =  71 },
    { kol = 28, id =  94 },
    { kol = 14, id =  96 },
    { kol = 12, id =  98 },
    { kol =  6, id = 100 },
    { kol =  4, id = 102 },
    { kol =  2, id = 105 },
  },
  [RACES.STRONGHOLD] = {
    { kol = 50, id = 117 },
    { kol = 28, id = 119 },
    { kol = 22, id = 121 },
    { kol = 10, id = 123 },
    { kol = 10, id = 125 },
    { kol =  4, id = 127 },
    { kol =  2, id = 129 },
  },
};

PLAYERS_PORTAL_TO_BATTLE_NAME = {
  [PLAYER_1] = 'port1',
  [PLAYER_2] = 'port2',
};

PLAYERS_PORTAL_TO_BATTLE_POSITION = {
  [PLAYER_1] = { x = 39, y = 80 },
  [PLAYER_2] = { x = 47, y = 11 },
};

-- Соотношение уровня существ к базовому бонусу для некромантии
MAP_UNIT_LEVEL_ON_DEFAULT_UNIT_COUNT = {
  [1] = 110,
  [2] = 70,
  [3] = 30,
  [4] = 14,
  [5] = 7,
  [6] = 4,
  [7] = 3
};

-- Соотношение грейда существ некроманта на их альтернативный грейд
MAP_NECRO_UNIT_ON_GRADE_UNIT = {
  [CREATURE_SKELETON] = CREATURE_SKELETON_WARRIOR,
  [CREATURE_WALKING_DEAD] = CREATURE_DISEASE_ZOMBIE,
  [CREATURE_GHOST] = CREATURE_POLTERGEIST,
  [CREATURE_VAMPIRE] = CREATURE_NOSFERATU,
  [CREATURE_LICH] = CREATURE_LICH_MASTER,
  [CREATURE_WIGHT] = CREATURE_BANSHEE,
  [CREATURE_BONE_DRAGON] = CREATURE_HORROR_DRAGON,
};

-- Соотношение альтернативного грейда существ некроманта на их грейд
MAP_NECRO_GRADE_UNIT_ON_UNIT = {
  [CREATURE_SKELETON_WARRIOR] = CREATURE_SKELETON,
  [CREATURE_DISEASE_ZOMBIE] = CREATURE_WALKING_DEAD,
  [CREATURE_POLTERGEIST] = CREATURE_GHOST,
  [CREATURE_NOSFERATU] = CREATURE_VAMPIRE,
  [CREATURE_LICH_MASTER] = CREATURE_LICH,
  [CREATURE_BANSHEE] = CREATURE_WIGHT,
  [CREATURE_HORROR_DRAGON] = CREATURE_BONE_DRAGON,
};

-- Место для телепортации героя из города
PLAYERS_TELEPORT_NEAR_TOWN_POSITION = {
  [PLAYER_1] = { x = 46, y = 80 },
  [PLAYER_2] = { x = 43, y = 13 },
};
