-- ���� �� ����� � �����������
PATH_TO_DAY1_MESSAGES = PATH_TO_DAY1_MODULE.."messages/";
-- ���� �� ����� � �����������
PATH_TO_HERO_NAMES = PATH_TO_DAY1_MODULE.."hero_names/";

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