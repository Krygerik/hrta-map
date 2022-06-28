
-- Соотношение игроков на Id гарнизонов для дипломатии
MAP_GARNISON_FOR_DIPLOMACY = {
  [PLAYER_1] = 'Garrison3',
  [PLAYER_2] = 'Garrison4',
};

-- Соотношение расы на регион родной земли с маленькими препятствиями
MAP_RACE_ON_NATIVE_REGIONS = {
  [RACES.HAVEN] = 'land_block_race1',
  [RACES.INFERNO] = 'land_block_race2',
  [RACES.NECROPOLIS] = 'land_block_race3',
  [RACES.SYLVAN] = 'land_block_race1',
  [RACES.ACADEMY] = 'land_block_race5',
  [RACES.DUNGEON] = 'land_block_race6',
  [RACES.FORTRESS] = 'land_block_race7',
  [RACES.STRONGHOLD] = 'land_block_race8',
};

-- Соотношение расы на регион родной земли с большими препятствиями
MAP_RACE_ON_ADDITIONAL_REGIONS = {
  [RACES.HAVEN] = 'land_block1',
  [RACES.INFERNO] = 'land_block2',
  [RACES.NECROPOLIS] = 'land_block3',
  [RACES.SYLVAN] = 'land_block1',
  --[RACES.ACADEMY] = '',
  [RACES.DUNGEON] = 'land_block6',
  [RACES.FORTRESS] = 'land_block7',
  --[RACES.STRONGHOLD] = '',
};

-- Место для телепортации героя на выбор зон
PLAYERS_TELEPORT_TO_BATTLE_POSITION = {
  [PLAYER_1] = { x = 35, y = 46 },
  [PLAYER_2] = { x = 60, y = 46 },
};

-- Элементы декора на выборе поля для боя
PLAYERS_BOAT = {
  [PLAYER_1] = 'boat1',
  [PLAYER_2] = 'boat2',
};

PLAYERS_TOWER = {
  [PLAYER_1] = 'tow1',
  [PLAYER_2] = 'tow2',
};
