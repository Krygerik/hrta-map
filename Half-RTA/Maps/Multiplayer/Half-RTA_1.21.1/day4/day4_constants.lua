
-- Соотношение игроков на Id гарнизонов для Некромантии
MAP_GARNISON_FOR_NECROMANCY = {
  [PLAYER_1] = 'Garrison1',
  [PLAYER_2] = 'Garrison2',
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
