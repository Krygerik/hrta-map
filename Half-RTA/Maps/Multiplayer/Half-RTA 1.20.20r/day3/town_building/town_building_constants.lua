
-- ������ ��������������� ����� � ������� �������
-- ������ ����� ����� ��� ������
RESULT_ARMY_INTO_TOWN = {
  [PLAYER_1] = {},
  [PLAYER_2] = {},
};

-- ������ ����������� �� ������,
-- �� ������� ����� ������������� �� ���������� � �������
-- ��������� ������, �� �� �� ��� ��������������� �����������
SUCCESS_UNITS_ID = {
  [RACES.HAVEN] = {
    1, 3, 5, 7, 9, 11, 13,
  },
  [RACES.INFERNO] = {
    15, 17, 19, 21, 23, 25, 27,
  },
  [RACES.NECROPOLIS] = {
    29, 31, 34, 35, 37, 39, 41,
  },
  [RACES.SYLVAN] = {
    43, 45, 47, 49, 51, 53, 55,
  },
  [RACES.ACADEMY] = {
    57, 59, 61, 63, 65, 67, 69,
  },
  [RACES.DUNGEON] = {
    92, 73, 75, 77, 79, 81, 83,
  },
  [RACES.FORTRESS] = {
    71, 94, 96, 98, 100, 102, 105,
  },
  [RACES.STRONGHOLD] = {
    117, 119, 121, 123, 125, 127, 129,
  },
};

-- ������ ������, ��� ��������� � ������
UNITS = {
  [RACES.NEUTRAL] = {
    { kol = 80, id =113, price1 =  150, power =  355, lvl = 1 },
    { kol = 50, id = 85, price1 =  400, power =  829, lvl = 4 },
    { kol = 50, id = 86, price1 =  400, power =  795, lvl = 4 },
    { kol = 50, id = 88, price1 =  400, power =  813, lvl = 4 },
    { kol = 50, id = 87, price1 =  400, power =  856, lvl = 4 },
    { kol = 30, id =116, price1 =  400, power = 1542, lvl = 5 },
    { kol = 18, id = 89, price1 = 1700, power = 2560, lvl = 6 },
    { kol = 18, id =115, price1 = 1700, power = 2523, lvl = 6 },
    { kol =  5, id = 91, price1 = 6000, power = 8576, lvl = 7 }
  },
  [RACES.HAVEN] = {
    { kol =338, id =  1, price1 =   30, power =   72, lvl = 1 },
    { kol =144, id =  3, price1 =  100, power =  199, lvl = 2 },
    { kol =100, id =  5, price1 =  140, power =  287, lvl = 3 },
    { kol = 45, id =  7, price1 =  400, power =  716, lvl = 4 },
    { kol = 24, id =  9, price1 =  750, power = 1487, lvl = 5 },
    { kol = 14, id = 11, price1 = 1400, power = 2520, lvl = 6 },
    { kol =  6, id = 13, price1 = 3500, power = 6003, lvl = 7 },
    { kol =338, id =  2, price1 =   30, power =   72, lvl = 1 },
    { kol =144, id =  4, price1 =  100, power =  199, lvl = 2 },
    { kol =100, id =  6, price1 =  140, power =  287, lvl = 3 },
    { kol = 45, id =  8, price1 =  400, power =  716, lvl = 4 },
    { kol = 24, id = 10, price1 =  750, power = 1487, lvl = 5 },
    { kol = 14, id = 12, price1 = 1400, power = 2520, lvl = 6 },
    { kol =  6, id = 14, price1 = 3500, power = 6003, lvl = 7 },
    { kol =338, id =106, price1 =   30, power =   72, lvl = 1 },
    { kol =144, id =107, price1 =  100, power =  199, lvl = 2 },
    { kol =100, id =108, price1 =  140, power =  287, lvl = 3 },
    { kol = 45, id =109, price1 =  400, power =  716, lvl = 4 },
    { kol = 24, id =110, price1 =  750, power = 1487, lvl = 5 },
    { kol = 14, id =111, price1 = 1400, power = 2520, lvl = 6 },
    { kol =  6, id =112, price1 = 3500, power = 6003, lvl = 7 }
  },
  [RACES.INFERNO] = {
    { kol =224, id = 15, price1 =   80, power =  124, lvl = 1 },
    { kol =192, id = 17, price1 =   85, power =  149, lvl = 2 },
    { kol = 80, id = 19, price1 =  170, power =  338, lvl = 3 },
    { kol = 45, id = 21, price1 =  400, power =  680, lvl = 4 },
    { kol = 27, id = 23, price1 =  800, power = 1415, lvl = 5 },
    { kol = 14, id = 25, price1 = 1500, power = 2360, lvl = 6 },
    { kol =  6, id = 27, price1 = 3100, power = 5850, lvl = 7 },
    { kol =224, id = 16, price1 =   80, power =  124, lvl = 1 },
    { kol =192, id = 18, price1 =   85, power =  149, lvl = 2 },
    { kol = 80, id = 20, price1 =  170, power =  338, lvl = 3 },
    { kol = 45, id = 22, price1 =  400, power =  680, lvl = 4 },
    { kol = 27, id = 24, price1 =  800, power = 1415, lvl = 5 },
    { kol = 14, id = 26, price1 = 1500, power = 2360, lvl = 6 },
    { kol =  6, id = 28, price1 = 3100, power = 5850, lvl = 7 },
    { kol =224, id =131, price1 =   80, power =  124, lvl = 1 },
    { kol =192, id =132, price1 =   85, power =  149, lvl = 2 },
    { kol = 80, id =133, price1 =  170, power =  338, lvl = 3 },
    { kol = 45, id =134, price1 =  400, power =  680, lvl = 4 },
    { kol = 27, id =135, price1 =  800, power = 1415, lvl = 5 },
    { kol = 14, id =136, price1 = 1500, power = 2360, lvl = 6 },
    { kol =  6, id =137, price1 = 3100, power = 5850, lvl = 7 }
  },
  [RACES.NECROPOLIS] = {
    { kol =316, id = 29, price1 =   50, power =   84, lvl = 1 },
    { kol =180, id = 31, price1 =   80, power =  145, lvl = 2 },
    { kol = 90, id = 33, price1 =  180, power =  327, lvl = 3 },
    { kol = 45, id = 35, price1 =  450, power =  739, lvl = 4 },
    { kol = 24, id = 37, price1 =  750, power = 1539, lvl = 5 },
    { kol = 14, id = 39, price1 = 1400, power = 2449, lvl = 6 },
    { kol =  8, id = 41, price1 = 1900, power = 3872, lvl = 7 },
    { kol =316, id = 30, price1 =   50, power =   84, lvl = 1 },
    { kol =180, id = 32, price1 =   80, power =  145, lvl = 2 },
    { kol = 90, id = 34, price1 =  180, power =  327, lvl = 3 },
    { kol = 45, id = 36, price1 =  450, power =  739, lvl = 4 },
    { kol = 24, id = 38, price1 =  750, power = 1539, lvl = 5 },
    { kol = 14, id = 40, price1 = 1400, power = 2449, lvl = 6 },
    { kol =  8, id = 42, price1 = 1900, power = 3872, lvl = 7 },
    { kol =316, id =152, price1 =   50, power =   84, lvl = 1 },
    { kol =180, id =153, price1 =   80, power =  145, lvl = 2 },
    { kol = 90, id =154, price1 =  180, power =  327, lvl = 3 },
    { kol = 45, id =155, price1 =  450, power =  739, lvl = 4 },
    { kol = 24, id =156, price1 =  750, power = 1539, lvl = 5 },
    { kol = 14, id =157, price1 = 1400, power = 2449, lvl = 6 },
    { kol =  8, id =158, price1 = 1900, power = 3872, lvl = 7 }
  },
  [RACES.SYLVAN] = {
    { kol =164, id = 43, price1 =   70, power =  169, lvl = 1 },
    { kol =108, id = 45, price1 =  140, power =  308, lvl = 2 },
    { kol = 70, id = 47, price1 =  250, power =  433, lvl = 3 },
    { kol = 36, id = 49, price1 =  380, power =  846, lvl = 4 },
    { kol = 24, id = 51, price1 =  950, power = 1441, lvl = 5 },
    { kol = 16, id = 53, price1 = 1150, power = 1993, lvl = 6 },
    { kol =  6, id = 55, price1 = 3600, power = 5905, lvl = 7 },
    { kol =164, id = 44, price1 =   70, power =  169, lvl = 1 },
    { kol =108, id = 46, price1 =  140, power =  308, lvl = 2 },
    { kol = 70, id = 48, price1 =  250, power =  433, lvl = 3 },
    { kol = 36, id = 50, price1 =  380, power =  846, lvl = 4 },
    { kol = 24, id = 52, price1 =  950, power = 1441, lvl = 5 },
    { kol = 16, id = 54, price1 = 1150, power = 1993, lvl = 6 },
    { kol =  6, id = 56, price1 = 3600, power = 5905, lvl = 7 },
    { kol =164, id =145, price1 =   70, power =  169, lvl = 1 },
    { kol =108, id =146, price1 =  140, power =  308, lvl = 2 },
    { kol = 70, id =147, price1 =  250, power =  433, lvl = 3 },
    { kol = 36, id =148, price1 =  380, power =  846, lvl = 4 },
    { kol = 24, id =149, price1 =  950, power = 1441, lvl = 5 },
    { kol = 16, id =150, price1 = 1150, power = 1993, lvl = 6 },
    { kol =  6, id =151, price1 = 3600, power = 5905, lvl = 7 }
  },
  [RACES.ACADEMY] = {
    { kol =280, id = 57, price1 =   55, power =  105, lvl = 1 },
    { kol =168, id = 59, price1 =  100, power =  172, lvl = 2 },
    { kol = 90, id = 61, price1 =  150, power =  355, lvl = 3 },
    { kol = 45, id = 63, price1 =  380, power =  642, lvl = 4 },
    { kol = 30, id = 65, price1 =  500, power = 1096, lvl = 5 },
    { kol = 14, id = 67, price1 = 1500, power = 2535, lvl = 6 },
    { kol =  6, id = 69, price1 = 3500, power = 6095, lvl = 7 },
    { kol =280, id = 58, price1 =   55, power =  105, lvl = 1 },
    { kol =168, id = 60, price1 =  100, power =  172, lvl = 2 },
    { kol = 90, id = 62, price1 =  150, power =  355, lvl = 3 },
    { kol = 45, id = 64, price1 =  380, power =  642, lvl = 4 },
    { kol = 30, id = 66, price1 =  500, power = 1096, lvl = 5 },
    { kol = 14, id = 68, price1 = 1500, power = 2535, lvl = 5 },
    { kol =  6, id = 70, price1 = 3500, power = 6095, lvl = 5 },
    { kol =280, id =159, price1 =   55, power =  105, lvl = 1 },
    { kol =168, id =160, price1 =  100, power =  172, lvl = 2 },
    { kol = 90, id =161, price1 =  150, power =  355, lvl = 3 },
    { kol = 45, id =162, price1 =  380, power =  642, lvl = 4 },
    { kol = 30, id =163, price1 =  500, power = 1096, lvl = 5 },
    { kol = 14, id =164, price1 = 1500, power = 2535, lvl = 6 },
    { kol =  6, id =165, price1 = 3500, power = 6095, lvl = 7 }
  },
  [RACES.DUNGEON] = {
    { kol = 98, id = 71, price1 =  110, power =  290, lvl = 1 },
    { kol = 78, id = 73, price1 =  190, power =  477, lvl = 2 },
    { kol = 66, id = 75, price1 =  200, power =  474, lvl = 3 },
    { kol = 36, id = 77, price1 =  450, power =  812, lvl = 4 },
    { kol = 24, id = 79, price1 =  850, power = 1324, lvl = 5 },
    { kol = 14, id = 81, price1 = 1200, power = 2537, lvl = 6 },
    { kol =  6, id = 83, price1 = 3800, power = 6389, lvl = 7 },
    { kol = 98, id = 72, price1 =  110, power =  290, lvl = 1 },
    { kol = 78, id = 74, price1 =  190, power =  477, lvl = 2 },
    { kol = 66, id = 76, price1 =  200, power =  474, lvl = 3 },
    { kol = 36, id = 78, price1 =  450, power =  812, lvl = 4 },
    { kol = 24, id = 80, price1 =  850, power = 1324, lvl = 5 },
    { kol = 14, id = 82, price1 = 1200, power = 2537, lvl = 6 },
    { kol =  6, id = 84, price1 = 3800, power = 6389, lvl = 7 },
    { kol = 98, id =138, price1 =  110, power =  290, lvl = 1 },
    { kol = 78, id =139, price1 =  190, power =  477, lvl = 2 },
    { kol = 66, id =140, price1 =  200, power =  474, lvl = 3 },
    { kol = 36, id =141, price1 =  450, power =  812, lvl = 4 },
    { kol = 24, id =142, price1 =  850, power = 1324, lvl = 5 },
    { kol = 14, id =143, price1 = 1200, power = 2537, lvl = 6 },
    { kol =  6, id =144, price1 = 3800, power = 6389, lvl = 7 }
  },
  [RACES.FORTRESS] = {
    { kol =252, id = 92, price1 =   65, power =  115, lvl = 1 },
    { kol =168, id = 94, price1 =   90, power =  171, lvl = 2 },
    { kol = 70, id = 96, price1 =  250, power =  419, lvl = 3 },
    { kol = 66, id = 98, price1 =  230, power =  434, lvl = 4 },
    { kol = 27, id =100, price1 =  650, power = 1308, lvl = 5 },
    { kol = 14, id =102, price1 = 1600, power = 2437, lvl = 6 },
    { kol =  6, id =104, price1 = 3400, power = 6070, lvl = 7 },
    { kol =252, id = 93, price1 =   65, power =  115, lvl = 1 },
    { kol =168, id = 95, price1 =   90, power =  171, lvl = 2 },
    { kol = 70, id = 97, price1 =  250, power =  419, lvl = 3 },
    { kol = 66, id = 99, price1 =  230, power =  434, lvl = 4 },
    { kol = 27, id =101, price1 =  650, power = 1308, lvl = 5 },
    { kol = 14, id =103, price1 = 1600, power = 2437, lvl = 6 },
    { kol =  6, id =105, price1 = 3400, power = 6070, lvl = 7 },
    { kol =252, id =166, price1 =   65, power =  115, lvl = 1 },
    { kol =168, id =167, price1 =   90, power =  171, lvl = 2 },
    { kol = 70, id =168, price1 =  250, power =  419, lvl = 3 },
    { kol = 66, id =169, price1 =  230, power =  434, lvl = 4 },
    { kol = 27, id =170, price1 =  650, power = 1308, lvl = 5 },
    { kol = 14, id =171, price1 = 1600, power = 2437, lvl = 6 },
    { kol =  6, id =172, price1 = 3400, power = 6070, lvl = 7 }
  },
  [RACES.STRONGHOLD] = {
    { kol =386, id =117, price1 =   35, power =   66, lvl = 1 },
    { kol =168, id =119, price1 =  110, power =  174, lvl = 2 },
    { kol =110, id =121, price1 =  140, power =  254, lvl = 3 },
    { kol = 45, id =123, price1 =  420, power =  680, lvl = 4 },
    { kol = 40, id =125, price1 =  550, power =  895, lvl = 5 },
    { kol = 14, id =127, price1 = 1200, power = 2571, lvl = 6 },
    { kol =  6, id =129, price1 = 3600, power = 5937, lvl = 7 },
    { kol =386, id =118, price1 =   35, power =   66, lvl = 1 },
    { kol =168, id =120, price1 =  110, power =  174, lvl = 2 },
    { kol =110, id =122, price1 =  140, power =  254, lvl = 3 },
    { kol = 45, id =124, price1 =  420, power =  680, lvl = 4 },
    { kol = 40, id =126, price1 =  550, power =  895, lvl = 5 },
    { kol = 14, id =128, price1 = 1200, power = 2571, lvl = 6 },
    { kol =  6, id =130, price1 = 3600, power = 5937, lvl = 7 },
    { kol =386, id =173, price1 =   35, power =   66, lvl = 1 },
    { kol =168, id =174, price1 =  110, power =  174, lvl = 2 },
    { kol =110, id =175, price1 =  140, power =  254, lvl = 3 },
    { kol = 45, id =176, price1 =  420, power =  680, lvl = 4 },
    { kol = 40, id =177, price1 =  550, power =  895, lvl = 5 },
    { kol = 14, id =178, price1 = 1200, power = 2571, lvl = 6 },
    { kol =  6, id =179, price1 = 3600, power = 5937, lvl = 7 }
  }
};
