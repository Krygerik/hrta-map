-- ���� �� ����� � �����������
PATH_TO_DAY1_MESSAGES = PATH_TO_DAY1_MODULE.."messages/";
-- ���� �� ����� � �����������
PATH_TO_HERO_NAMES = PATH_TO_DAY1_MODULE.."hero_names/";

-- ����� (����� ��������)
Biara = GetPlayerHeroes(PLAYER_1)[0]
-- �������� (����� ������)
Djovanni = GetPlayerHeroes(PLAYER_2)[0]

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