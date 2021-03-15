-- Путь до папки с сообщениями
PATH_TO_DAY1_MESSAGES = PATH_TO_DAY1_MODULE.."messages/";
-- Путь до папки с сообщениями
PATH_TO_HERO_NAMES = PATH_TO_DAY1_MODULE.."hero_names/";

-- Биара (герой красного)
Biara = GetPlayerHeroes(PLAYER_1)[0]
-- Джованни (негой синего)
Djovanni = GetPlayerHeroes(PLAYER_2)[0]

-- Таблица ИД выбранных рас для
-- Служит для конкретизации переменной для передачи параметров между черком рас и героев
-- 1 значение первого игрока (красного), 2 - второго (синего)
SELECTED_RACE_ID_TABLE = {};

-- Итоговый список расы и героев для игры
-- Служит для передачи значения для начала прокачки
RESULT_HERO_LIST = {
  [PLAYER_1] = { raceId = nil, heroes = {} },
  [PLAYER_2] = { raceId = nil, heroes = {} },
};