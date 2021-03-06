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
  -- Дварфы
  FORTRESS = 6,
  -- Орда
  STRONGHOLD = 7,
}