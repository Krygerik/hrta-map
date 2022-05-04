
-- Имена объектов, которые позволяют прокачиваться
PLAYER_LEARNING_OBJECTS_NAMES = {
  [PLAYER_1] = 'arena',
  [PLAYER_2] = 'magiya',
};

-- Вопросы при начале прокачке
QUESTION_BY_RACE = {
  [RACES.HAVEN] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_haven.txt",
  [RACES.INFERNO] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_inferno.txt",
  [RACES.NECROPOLIS] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_necropolis.txt",
  [RACES.SYLVAN] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_sylvan.txt",
  [RACES.ACADEMY] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_academy.txt",
  [RACES.DUNGEON] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_dungeon.txt",
  [RACES.FORTRESS] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_fortress.txt",
  [RACES.STRONGHOLD] = PATH_TO_START_LEARNING_MESSAGES.."question_start_learning_stronghold.txt",
};

-- Мапа наименования и описания объектов
LEARNING_OBJECTS_NAME_AND_DESCRIPTION_MAP = {
  [PLAYER_LEARNING_OBJECTS_NAMES[PLAYER_1]] = {
    name = PATH_TO_START_LEARNING_MESSAGES..'arena_name.txt',
    description = PATH_TO_START_LEARNING_MESSAGES..'arena_description.txt',
  },
  [PLAYER_LEARNING_OBJECTS_NAMES[PLAYER_2]] = {
    name = PATH_TO_START_LEARNING_MESSAGES..'arena_name.txt',
    description = PATH_TO_START_LEARNING_MESSAGES..'arena_description.txt',
  },
}

-- Количество опыта, необходимое для достижения необходимого уровня от первого
-- Значения из мануала
TOTAL_EXPERIENCE_BY_LEVEL = {
  0,                      -- 1
  1000,                   -- 2
  2000,                   -- 3
  3200,                   -- 4
  4600,                   -- 5
  6200,                   -- 6
  8000,                   -- 7
  10000,                  -- 8
  12200,                  -- 9
  14700,                  -- 10
  17500,                  -- 11
  20600,                  -- 12
  24320,                  -- 13
  28784,                  -- 14
  34140,                  -- 15
  40567,                  -- 16
  48279,                  -- 17
  57533,                  -- 18
  68637,                  -- 19
  81961,                  -- 20
  97949,                  -- 21
  117134,                 -- 22
  140156,                 -- 23
  167782,                 -- 24
  200933,                 -- 25
  244029,                 -- 26
  304363,                 -- 27
  394864,                 -- 28
  539665,                 -- 29
  785826,                 -- 30
  1228915,                -- 31
  2070784,                -- 32
  3754522,                -- 33
  7290371,                -- 34
  15069240,               -- 35
  32960630,               -- 36
  75899970,               -- 37
  183258314,              -- 38
  462353978,              -- 39
  1215939194              -- 40
};

-- Соотношение уровней к цене, за которую они покупаются
MAP_LEVEL_BY_PRICE = {
  [19] = 8500,
  [20] = 9000,
  [21] = 9500,
  [22] = 10000,
  [23] = 10500,
  [24] = 11000,
};

-- Максимальный левел, доступный для прокачки
MAXIMUM_AVAILABLE_LEVEL = 24;

-- Количества уровней, предоставляемых игроку для обучения бесплатно
FREE_LEARNING_LEVEL = 18;

-- Половина количества уровней, предоставляемых игроку для обучения бесплатно
HALF_FREE_LEARNING_LEVEL = 9;

-- Шанс выпадения статов для каждой фракции
DROP_STAT_PERCENT_BY_RACE = {
  [RACES.HAVEN] = {
    attack = 30,
    defence = 45,
    spellpower = 10,
    knowledge = 15,
  },
  [RACES.INFERNO] = {
    attack = 45,
    defence = 10,
    spellpower = 15,
    knowledge = 30,
  },
  [RACES.NECROPOLIS] = {
    attack = 10,
    defence = 30,
    spellpower = 45,
    knowledge = 15,
  },
  [RACES.SYLVAN] = {
    attack = 15,
    defence = 45,
    spellpower = 10,
    knowledge = 30,
  },
  [RACES.ACADEMY] = {
    attack = 10,
    defence = 15,
    spellpower = 30,
    knowledge = 45,
  },
  [RACES.DUNGEON] = {
    attack = 30,
    defence = 10,
    spellpower = 45,
    knowledge = 15,
  },
  [RACES.FORTRESS] = {
    attack = 20,
    defence = 30,
    spellpower = 30,
    knowledge = 20,
  },
  [RACES.STRONGHOLD] = {
    attack = 50,
    defence = 35,
    spellpower = 5,
    knowledge = 10,
  },
};

-- мапинг навыка на стат, которые он меняет
MAP_SKILLS_TO_CHANGING_STATS = {
  [RANGER_FEAT_FOREST_GUARD_EMBLEM] = {
    stat = STAT_ATTACK,
    count = 2,
  },
  [HERO_SKILL_BODYBUILDING] = {
    stat = STAT_DEFENCE,
    count = 2,
  },
  [HERO_SKILL_DEFEND_US_ALL] = {
    stat = STAT_DEFENCE,
    count = 2,
  },
  [WIZARD_FEAT_SEAL_OF_PROTECTION] = {
    stat = STAT_DEFENCE,
    count = 2,
  },
  [DEMON_FEAT_MASTER_OF_SECRETS] = {
    stat = STAT_SPELL_POWER,
    count = 2,
  },
  [KNIGHT_FEAT_CASTER_CERTIFICATE] = {
    stat = STAT_SPELL_POWER,
    count = 2,
  },
  [WIZARD_FEAT_ACADEMY_AWARD] = {
    stat = STAT_SPELL_POWER,
    count = 2,
  },
  [RANGER_FEAT_INSIGHTS] = {
    stat = STAT_SPELL_POWER,
    count = 2,
  },
  [WARLOCK_FEAT_SECRETS_OF_DESTRUCTION] = {
    stat = STAT_KNOWLEDGE,
    count = 2,
  },
  [KNIGHT_FEAT_STUDENT_AWARD] = {
    stat = STAT_KNOWLEDGE,
    count = 2,
  },
  [NECROMANCER_FEAT_LORD_OF_UNDEAD] = {
    stat = STAT_KNOWLEDGE,
    count = 1,
  },
};

-- Список всех основных статистик
ALL_MAIN_STATS_LIST = { STAT_ATTACK, STAT_DEFENCE, STAT_SPELL_POWER, STAT_KNOWLEDGE };

-- Количество дешевых скидок для обоих игроков на 1 уровне
PLAYERS_FIRST_LEVEL_DISCOUNT_ON_REMOVE_SKILLS = {
  [PLAYER_1] = 2,
  [PLAYER_2] = 2,
};

-- Список объектов, в которых можно купить базы
BUY_SKILL_OBJECTS_NAME = {
  [PLAYER_1] = 'skill1',
  [PLAYER_2] = 'skill2',
};

-- Список всех возможных не расовых скиллов
ALL_NOT_RACES_SKILL_LIST = {
  SKILL_LOGISTICS,
  SKILL_WAR_MACHINES,
  SKILL_LEARNING,
  SKILL_LEADERSHIP,
  SKILL_LUCK,
  SKILL_OFFENCE,
  SKILL_DEFENCE,
  SKILL_SORCERY,
  SKILL_DESTRUCTIVE_MAGIC,
  SKILL_DARK_MAGIC,
  SKILL_LIGHT_MAGIC,
  SKILL_SUMMONING_MAGIC,
};

-- Сопоставление вопросов для покупки к навыкам
BUY_SKILL_QUESTIONS = {
  [SKILL_LOGISTICS] = "question_buy_logistic.txt",
  [SKILL_WAR_MACHINES] = "question_buy_war_machines.txt",
  [SKILL_LEARNING] = "question_buy_learning.txt",
  [SKILL_LEADERSHIP] = "question_buy_leadership.txt",
  [SKILL_LUCK] = "question_buy_luck.txt",
  [SKILL_OFFENCE] = "question_buy_offence.txt",
  [SKILL_DEFENCE] = "question_buy_deffence.txt",
  [SKILL_SORCERY] = "question_buy_sorcery.txt",
  [SKILL_DESTRUCTIVE_MAGIC] = "question_buy_destructive_magic.txt",
  [SKILL_DARK_MAGIC] = "question_buy_dark.txt",
  [SKILL_LIGHT_MAGIC] = "question_buy_light_magic.txt",
  [SKILL_SUMMONING_MAGIC] = "question_buy_summoning_magic.txt",
};

-- Список разрешенных для покупки навыков по расам
ALLOW_BUY_SKILL_LIST_BY_RACE = {
  [RACES.HAVEN] = {
    SKILL_LOGISTICS,
    SKILL_WAR_MACHINES,
    SKILL_LEADERSHIP,
    SKILL_LUCK,
    SKILL_OFFENCE,
    SKILL_DEFENCE,
    SKILL_DARK_MAGIC,
    SKILL_LIGHT_MAGIC,
  },
  [RACES.INFERNO] = {
    SKILL_LOGISTICS,
    SKILL_WAR_MACHINES,
    SKILL_LUCK,
    SKILL_OFFENCE,
    SKILL_DEFENCE,
    SKILL_SORCERY,
    SKILL_DARK_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
  },
  [RACES.NECROPOLIS] = {
    SKILL_LOGISTICS,
    SKILL_LEARNING,
    SKILL_OFFENCE,
    SKILL_DEFENCE,
    SKILL_SORCERY,
    SKILL_DARK_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
    SKILL_SUMMONING_MAGIC,
  },
  [RACES.SYLVAN] = {
    SKILL_LOGISTICS,
    SKILL_LEARNING,
    SKILL_LEADERSHIP,
    SKILL_DEFENCE,
    SKILL_LUCK,
    SKILL_LIGHT_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
  },
  [RACES.ACADEMY] = {
    SKILL_WAR_MACHINES,
    SKILL_LEARNING,
    SKILL_LUCK,
    SKILL_SORCERY,
    SKILL_LIGHT_MAGIC,
    SKILL_DARK_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
    SKILL_SUMMONING_MAGIC,
  },
  [RACES.DUNGEON] = {
    SKILL_LOGISTICS,
    SKILL_WAR_MACHINES,
    SKILL_LEARNING,
    SKILL_LUCK,
    SKILL_OFFENCE,
    SKILL_SORCERY,
    SKILL_DESTRUCTIVE_MAGIC,
    SKILL_SUMMONING_MAGIC,
  },
  [RACES.FORTRESS] = {
    SKILL_WAR_MACHINES,
    SKILL_LEARNING,
    SKILL_LEADERSHIP,
    SKILL_LUCK,
    SKILL_OFFENCE,
    SKILL_DEFENCE,
    SKILL_LIGHT_MAGIC,
    SKILL_DESTRUCTIVE_MAGIC,
  },
  [RACES.STRONGHOLD] = {
    SKILL_LOGISTICS,
    SKILL_WAR_MACHINES,
    SKILL_LEADERSHIP,
    SKILL_LUCK,
    SKILL_OFFENCE,
    SKILL_DEFENCE,
  },
};

BUY_STATS_OBJECTS_NAMES = {
  [PLAYER_1] = {
    [STAT_ATTACK] = {
      id = 'napadenie1',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_attack_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_attack_stat_desc.txt",
    },
    [STAT_DEFENCE] = {
      id = 'zashchita1',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_defence_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_defence_stat_desc.txt",
    },
    [STAT_SPELL_POWER] = {
      id = 'koldovstvo1',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_spell_power_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_spell_power_stat_desc.txt",
    },
    [STAT_KNOWLEDGE] = {
      id = 'znanie1',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_knowledge_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_knowledge_stat_desc.txt",
    },
  },
  [PLAYER_2] = {
    [STAT_ATTACK] = {
      id = 'napadenie2',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_attack_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_attack_stat_desc.txt",
    },
    [STAT_DEFENCE] = {
      id = 'zashchita2',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_defence_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_defence_stat_desc.txt",
    },
    [STAT_SPELL_POWER] = {
      id = 'koldovstvo2',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_spell_power_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_spell_power_stat_desc.txt",
    },
    [STAT_KNOWLEDGE] = {
      id = 'znanie2',
      name = PATH_TO_START_LEARNING_MESSAGES.."buy_knowledge_object_name.txt",
      desc = PATH_TO_START_LEARNING_MESSAGES.."buy_knowledge_stat_desc.txt",
    },
  },
};

MAP_BUY_STAT_ON_QUESTIONS = {
  [STAT_ATTACK] = PATH_TO_START_LEARNING_MESSAGES.."question_buy_attack_stat.txt",
  [STAT_DEFENCE] = PATH_TO_START_LEARNING_MESSAGES.."question_buy_defence_stat.txt",
  [STAT_SPELL_POWER] = PATH_TO_START_LEARNING_MESSAGES.."question_buy_spell_power_stat.txt",
  [STAT_KNOWLEDGE] = PATH_TO_START_LEARNING_MESSAGES.."question_buy_knowledge_stat.txt",
};

MAP_STAT_ON_ADDING_MESSAGE = {
  [STAT_ATTACK] = PATH_TO_START_LEARNING_MESSAGES.."getting_attack_stat.txt",
  [STAT_DEFENCE] = PATH_TO_START_LEARNING_MESSAGES.."getting_defence_stat.txt",
  [STAT_SPELL_POWER] = PATH_TO_START_LEARNING_MESSAGES.."getting_spell_power_stat.txt",
  [STAT_KNOWLEDGE] = PATH_TO_START_LEARNING_MESSAGES.."getting_knowledge_stat.txt",
};

-- Стоимость перегенерации заклинаний
COST_RE_GENERATION_STATS = 5000;

-- Ручное перечисление недель
CUSTOM_WEEKS = {
  ATTACK = 20,
  DEFENCE = 23,
  SPELL_POWER = 15,
  KNOWLEDGE = 3,
  EQUAL = 18,
};

-- Соотношение недели к статам, которые оно дает
MAP_WEEK_ON_ASTROLOGY_STATS = {
  [CUSTOM_WEEKS.ATTACK] = {
    [STAT_ATTACK] = 3,
    [STAT_DEFENCE] = 0,
    [STAT_SPELL_POWER] = 0,
    [STAT_KNOWLEDGE] = 0
  },
  [CUSTOM_WEEKS.DEFENCE] = {
    [STAT_ATTACK] = 0,
    [STAT_DEFENCE] = 3,
    [STAT_SPELL_POWER] = 0,
    [STAT_KNOWLEDGE] = 0
  },
  [CUSTOM_WEEKS.SPELL_POWER] = {
    [STAT_ATTACK] = 0,
    [STAT_DEFENCE] = 0,
    [STAT_SPELL_POWER] = 3,
    [STAT_KNOWLEDGE] = 0
  },
  [CUSTOM_WEEKS.KNOWLEDGE] = {
    [STAT_ATTACK] = 0,
    [STAT_DEFENCE] = 0,
    [STAT_SPELL_POWER] = 0,
    [STAT_KNOWLEDGE] = 3
  },
  [CUSTOM_WEEKS.EQUAL] = {
    [STAT_ATTACK] = 1,
    [STAT_DEFENCE] = 1,
    [STAT_SPELL_POWER] = 1,
    [STAT_KNOWLEDGE] = 1
  },
};

-- Соотношение навыка к специальной способности, добавляемой в книгу заклинаний
MAP_SKILL_ON_CUSTOM_ABILITY = {
  [PERK_SCOUTING] = CUSTOM_ABILITY_2,
  [RANGER_FEAT_DISGUISE_AND_RECKON] = CUSTOM_ABILITY_2,
  [PERK_FORTUNATE_ADVENTURER] = CUSTOM_ABILITY_4,
}

-- Статус использования игроками трофеев
PLAYER_USE_SPOILS_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- Статус использования игроками разведки
PLAYER_USE_SCOUTING_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
}

-- Статус ожидания игроками прокачки оппонента
PLAYER_SCOUTING_WAITING_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- Статусы применения игроками навыка "Бесшумный преследователь"
PLAYER_USE_DISGUISE_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- Соотношение лавок артефактов к игрокам
MAP_MERCHANT_ON_PLAYER = {
  [PLAYER_1] = 'lavka1',
  [PLAYER_2] = 'lavka2',
}

-- Статус использования трофеев у обоих игроков
PLAYERS_USE_SPOILS_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- Статус использования "Удачи в пути" игроками
PLAYERS_USE_FORTUNARE_ADVENTURE_STATUS = {
  [PLAYER_1] = nil,
  [PLAYER_2] = nil,
};

-- Скидка на покупку уровней для Винраэля
ELLESHAR_DISCOUNT = 2500;

-- Количество возвращаемого золота за покупку крестьян для Эллайны
ELLAINA_DISCOUNT = 20;

-- За сколько уровней ИНГА учит руну
LVL_FOR_TEACH_RUNE = 7;

-- Соотношение уровня владения рунами на разрешенные уровни рун
MAP_RUNELORE_TO_ALLOW_RUNE_LEVELS = {
  [1] = 3,
  [2] = 4,
  [3] = 5
}
