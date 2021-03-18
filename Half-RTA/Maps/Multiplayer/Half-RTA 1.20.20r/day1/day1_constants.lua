-- ���� �� ����� � �����������
PATH_TO_DAY1_MESSAGES = PATH_TO_DAY1_MODULE.."messages/";
-- ���� �� ����� � �������������� ������
PATH_TO_HERO_NAMES = PATH_TO_DAY1_MODULE.."hero_names/";
-- ���� �� ����� � �������������� ���
PATH_TO_RACE_NAMES = PATH_TO_DAY1_MODULE.."race_names/";

-- ������� �� ��������� ��� ���
-- ������ ��� ������������� ���������� ��� �������� ���������� ����� ������ ��� � ������
-- 1 �������� ������� ������ (��������), 2 - ������� (������)
SELECTED_RACE_ID_TABLE = {};

-- �������� ������ ���� � ������ ��� ����
-- ������ ��� �������� �������� ��� ������ ��������
RESULT_HERO_LIST = {
  [PLAYER_1] = { raceId = nil, heroes = {} },
  [PLAYER_2] = { raceId = nil, heroes = {} },
};

-- ������� �� ���� �� �� ������������
MAP_RACE_ID_TO_RACE_NAME = {
  [RACES.HAVEN] = PATH_TO_RACE_NAMES.."haven.txt",
  [RACES.INFERNO] = PATH_TO_RACE_NAMES.."inferno.txt",
  [RACES.NECROPOLIS] = PATH_TO_RACE_NAMES.."necropolis.txt",
  [RACES.SYLVAN] = PATH_TO_RACE_NAMES.."sylvan.txt",
  [RACES.ACADEMY] = PATH_TO_RACE_NAMES.."academy.txt",
  [RACES.DUNGEON] = PATH_TO_RACE_NAMES.."dungeon.txt",
  [RACES.FORTRESS] = PATH_TO_RACE_NAMES.."fortress.txt",
  [RACES.STRONGHOLD] = PATH_TO_RACE_NAMES.."stronghold.txt",
}
