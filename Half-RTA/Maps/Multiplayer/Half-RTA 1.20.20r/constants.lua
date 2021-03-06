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
  -- ������
  FORTRESS = 6,
  -- ����
  STRONGHOLD = 7,
}