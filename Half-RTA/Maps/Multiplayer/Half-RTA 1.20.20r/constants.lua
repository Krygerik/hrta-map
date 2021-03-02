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
