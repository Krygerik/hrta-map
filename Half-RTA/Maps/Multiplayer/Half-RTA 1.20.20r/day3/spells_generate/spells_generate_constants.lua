-- Перечень типов школ магии
TYPE_MAGICS = {
  LIGHT = 0,
  DARK = 1,
  DESTRUCTIVE = 2,
  SUMMON = 3,
  RUNES = 4,
  WARCRIES = 5,
};

-- Соотношение заклинаний с их иконками на карте
MAPPING_SPELLS_ON_ICONS = {
    [SPELL_BLESS] =           { text = "bless.txt", icons = { [PLAYER_1] = "spell_1_1_1", [PLAYER_2] = "spell_1_1_2" }},
    [SPELL_DEFLECT_ARROWS] =  { text = "deflect_missile.txt", icons = { [PLAYER_1] = "spell_1_6_1", [PLAYER_2] = "spell_1_6_2" }},
    [SPELL_STONESKIN] =       { text = "stone_skin.txt", icons = { [PLAYER_1] = "spell_1_3_1", [PLAYER_2] = "spell_1_3_2" }},
    [SPELL_HASTE] =           { text = "haste.txt", icons = { [PLAYER_1] = "spell_1_2_1", [PLAYER_2] = "spell_1_2_2" }},
    [SPELL_BLOODLUST] =       { text = "bloodlust.txt", icons = { [PLAYER_1] = "spell_1_7_1", [PLAYER_2] = "spell_1_7_2" }},
    [SPELL_DISPEL] =          { text = "dispel.txt", icons = { [PLAYER_1] = "spell_1_5_1", [PLAYER_2] = "spell_1_5_2" }},
    [SPELL_REGENERATION] =    { text = "regeneration.txt", icons = { [PLAYER_1] = "spell_1_4_1", [PLAYER_2] = "spell_1_4_2" }},
    [SPELL_TELEPORT] =        { text = "teleport.txt", icons = { [PLAYER_1] = "spell_1_8_1", [PLAYER_2] = "spell_1_8_2" }},
    [SPELL_ANTI_MAGIC] =      { text = "anti_magic.txt", icons = { [PLAYER_1] = "spell_1_9_1", [PLAYER_2] = "spell_1_9_2" }},
    [SPELL_DIVINE_VENGEANCE] = { text = "divine_vengeance.txt", icons = { [PLAYER_1] = "spell_1_10_1", [PLAYER_2] = "spell_1_10_2" }},
    [SPELL_RESURRECT] =       { text = "resurrect.txt", icons = { [PLAYER_1] = "spell_1_11_1", [PLAYER_2] = "spell_1_11_2" }},
    [SPELL_HOLY_WORD] =       { text = "holy_word.txt", icons = { [PLAYER_1] = "spell_1_12_1", [PLAYER_2] = "spell_1_12_2" }},
    [SPELL_CURSE] =           { text = "curse.txt", icons = { [PLAYER_1] = "spell_2_2_1", [PLAYER_2] = "spell_2_2_2" }},
    [SPELL_SLOW] =            { text = "slow.txt", icons = { [PLAYER_1] = "spell_2_3_1", [PLAYER_2] = "spell_2_3_2" }},
    [SPELL_WEAKNESS] =        { text = "weakness.txt", icons = { [PLAYER_1] = "spell_2_7_1", [PLAYER_2] = "spell_2_7_2" }},
    [SPELL_DISRUPTING_RAY] =  { text = "disrupting_ray.txt", icons = { [PLAYER_1] = "spell_2_4_1", [PLAYER_2] = "spell_2_4_2" }},
    [SPELL_FORGETFULNESS] =   { text = "forgetfulness.txt", icons = { [PLAYER_1] = "spell_2_6_1", [PLAYER_2] = "spell_2_6_2" }},
    [SPELL_PLAGUE] =          { text = "plague.txt", icons = { [PLAYER_1] = "spell_2_5_1", [PLAYER_2] = "spell_2_5_2" }},
    [SPELL_SORROW] =          { text = "sorrow.txt", icons = { [PLAYER_1] = "spell_2_1_1", [PLAYER_2] = "spell_2_1_2" }},
    [SPELL_BLIND] =           { text = "blind.txt", icons = { [PLAYER_1] = "spell_2_8_1", [PLAYER_2] = "spell_2_8_2" }},
    [SPELL_VAMPIRISM] =       { text = "vampirism.txt", icons = { [PLAYER_1] = "spell_2_10_1", [PLAYER_2] = "spell_2_10_2" }},
    [SPELL_BERSERK] =         { text = "berserk.txt", icons = { [PLAYER_1] = "spell_2_9_1", [PLAYER_2] = "spell_2_9_2" }},
    [SPELL_HYPNOTIZE] =       { text = "hypnotize.txt", icons = { [PLAYER_1] = "spell_2_11_1", [PLAYER_2] = "spell_2_11_2" }},
    [SPELL_UNHOLY_WORD] =     { text = "unholy_word.txt", icons = { [PLAYER_1] = "spell_2_12_1", [PLAYER_2] = "spell_2_12_2" }},
    [SPELL_STONE_SPIKES] =    { text = "stone_spikes.txt", icons = { [PLAYER_1] = "spell_3_1_1", [PLAYER_2] = "spell_3_1_2" }},
    [SPELL_MAGIC_ARROW] =     { text = "magic_arrow.txt", icons = { [PLAYER_1] = "spell_3_2_1", [PLAYER_2] = "spell_3_2_2" }},
    [SPELL_ICE_BOLT] =        { text = "ice_bolt.txt", icons = { [PLAYER_1] = "spell_3_3_1", [PLAYER_2] = "spell_3_3_2" }},
    [SPELL_LIGHTNING_BOLT] =  { text = "lightning_bolt.txt", icons = { [PLAYER_1] = "spell_3_4_1", [PLAYER_2] = "spell_3_4_2" }},
    [SPELL_FROST_RING] =      { text = "frost_ring.txt", icons = { [PLAYER_1] = "spell_3_5_1", [PLAYER_2] = "spell_3_5_2" }},
    [SPELL_FIREBALL] =        { text = "fireball.txt", icons = { [PLAYER_1] = "spell_3_7_1", [PLAYER_2] = "spell_3_7_2" }},
    [SPELL_FIREWALL] =        { text = "firewall.txt", icons = { [PLAYER_1] = "spell_3_6_1", [PLAYER_2] = "spell_3_6_2" }},
    [SPELL_CHAIN_LIGHTNING] = { text = "chain_lightning.txt", icons = { [PLAYER_1] = "spell_3_8_1", [PLAYER_2] = "spell_3_8_2" }},
    [SPELL_METEOR_SHOWER] =   { text = "meteor_shower.txt", icons = { [PLAYER_1] = "spell_3_9_1", [PLAYER_2] = "spell_3_9_2" }},
    [SPELL_DEEP_FREEZE] =     { text = "deep_freeze.txt", icons = { [PLAYER_1] = "spell_3_10_1", [PLAYER_2] = "spell_3_10_2" }},
    [SPELL_IMPLOSION] =       { text = "implosion.txt", icons = { [PLAYER_1] = "spell_3_11_1", [PLAYER_2] = "spell_3_11_2" }},
    [SPELL_ARMAGEDDON] =      { text = "armageddon.txt", icons = { [PLAYER_1] = "spell_3_12_1", [PLAYER_2] = "spell_3_12_2" }},
    [SPELL_MAGIC_FIST] =      { text = "magic_fist.txt", icons = { [PLAYER_1] = "spell_4_1_1", [PLAYER_2] = "spell_4_1_2" }},
    [SPELL_LAND_MINE] =       { text = "land_mine.txt", icons = { [PLAYER_1] = "spell_4_2_1", [PLAYER_2] = "spell_4_2_2" }},
    [SPELL_WASP_SWARM] =      { text = "wasp_swarm.txt", icons = { [PLAYER_1] = "spell_4_3_1", [PLAYER_2] = "spell_4_3_2" }},
    [SPELL_ARCANE_CRYSTAL] =  { text = "arcane_crystall.txt", icons = { [PLAYER_1] = "spell_4_5_1", [PLAYER_2] = "spell_4_5_2" }},
    [SPELL_BLADE_BARRIER] =   { text = "blade_barrier.txt", icons = { [PLAYER_1] = "spell_4_7_1", [PLAYER_2] = "spell_4_7_2" }},
    [SPELL_ANIMATE_DEAD] =    { text = "animate_dead.txt", icons = { [PLAYER_1] = "spell_4_4_1", [PLAYER_2] = "spell_4_4_2" }},
    [SPELL_PHANTOM] =         { text = "phantom.txt", icons = { [PLAYER_1] = "spell_4_6_1", [PLAYER_2] = "spell_4_6_2" }},
    [SPELL_EARTHQUAKE] =      { text = "earthquake.txt", icons = { [PLAYER_1] = "spell_4_8_1", [PLAYER_2] = "spell_4_8_2" }},
    [SPELL_SUMMON_ELEMENTALS] = { text = "summon_elementals.txt", icons = { [PLAYER_1] = "spell_4_9_1", [PLAYER_2] = "spell_4_9_2" }},
    [SPELL_SUMMON_HIVE] =     { text = "summon_hive.txt", icons = { [PLAYER_1] = "spell_4_10_1", [PLAYER_2] = "spell_4_10_2" }},
    [SPELL_CONJURE_PHOENIX] = { text = "conjure_phoenix.txt", icons = { [PLAYER_1] = "spell_4_11_1", [PLAYER_2] = "spell_4_11_2" }},
    [SPELL_CELESTIAL_SHIELD] = { text = "celestial_shield.txt", icons = { [PLAYER_1] = "spell_4_12_1", [PLAYER_2] = "spell_4_12_2" }},
    -- Классные разрабы даже не запилили альясов для рун :)
    [249] =                   { text = "rune_energy.txt", icons = { [PLAYER_1] = "spell_5_1_1", [PLAYER_2] = "spell_5_1_2" }},
    [253] =                   { text = "rune_of_elemental_immunity.txt", icons = { [PLAYER_1] = "spell_5_5_1", [PLAYER_2] = "spell_5_5_2" }},
    [251] =                   { text = "rune_of_magic_control.txt", icons = { [PLAYER_1] = "spell_5_3_1", [PLAYER_2] = "spell_5_3_2" }},
    [252] =                   { text = "rune_of_exorcism.txt", icons = { [PLAYER_1] = "spell_5_4_1", [PLAYER_2] = "spell_5_4_2" }},
    [256] =                   { text = "rune_of_etherealness.txt", icons = { [PLAYER_1] = "spell_5_6_1", [PLAYER_2] = "spell_5_6_2" }},
    [254] =                   { text = "rune_of_thunderclap.txt", icons = { [PLAYER_1] = "spell_5_7_1", [PLAYER_2] = "spell_5_7_2" }},
    [250] =                   { text = "rune_of_berserking.txt", icons = { [PLAYER_1] = "spell_5_2_1", [PLAYER_2] = "spell_5_2_2" }},
    [257] =                   { text = "rune_of_resurrection.txt", icons = { [PLAYER_1] = "spell_5_8_1", [PLAYER_2] = "spell_5_8_2" }},
    [258] =                   { text = "rune_of_dragonform.txt", icons = { [PLAYER_1] = "spell_5_9_1", [PLAYER_2] = "spell_5_9_2" }},
    [255] =                   { text = "rune_of_battle_rage.txt", icons = { [PLAYER_1] = "spell_5_10_1", [PLAYER_2] = "spell_5_10_2" }},
    [SPELL_WARCRY_RALLING_CRY] =       { text = "warcry_ralling_cry.txt", icons = { [PLAYER_1] = "spell_6_1_1", [PLAYER_2] = "spell_6_1_2" }},
    [SPELL_WARCRY_CALL_OF_BLOOD] =     { text = "warcry_call_of_the_chied.txt", icons = { [PLAYER_1] = "spell_6_2_1", [PLAYER_2] = "spell_6_2_2" }},
    [SPELL_WARCRY_WORD_OF_THE_CHIEF] = { text = "warcry_word_of_the_chied.txt", icons = { [PLAYER_1] = "spell_6_3_1", [PLAYER_2] = "spell_6_3_2" }},
    [SPELL_WARCRY_FEAR_MY_ROAR] =      { text = "warcry_fear_my_roar.txt", icons = { [PLAYER_1] = "spell_6_4_1", [PLAYER_2] = "spell_6_4_2" }},
    [SPELL_WARCRY_BATTLECRY] =         { text = "warcry_battlecry.txt", icons = { [PLAYER_1] = "spell_6_5_1", [PLAYER_2] = "spell_6_5_2" }},
    [SPELL_WARCRY_SHOUT_OF_MANY] =     { text = "warcry_shout_of_many.txt", icons = { [PLAYER_1] = "spell_6_6_1", [PLAYER_2] = "spell_6_6_2" }},
};

-- Перечень всех заклинаний
SPELLS = {
  [TYPE_MAGICS.LIGHT] = {
    { level = 1, id = 23  }, -- божественная сила
    { level = 1, id = 29  }, -- уклонение
    { level = 2, id = 25  }, -- каменная кожа
    { level = 2, id = 24  }, -- ускорение
    { level = 3, id = 28  }, -- карающий удар
    { level = 3, id = 26  }, -- снятие чар
    { level = 3, id = 280 }, -- регенерация
    { level = 4, id = 32  }, -- телепорт
    { level = 4, id = 31  }, -- антимагия
    --{ level = 4, id = 281 }, -- божественная месть
    { level = 5, id = 48  }, -- воскрешение
    --{ level = 5, id = 35  }, -- святое слово
  },
  [TYPE_MAGICS.DARK] = {
    { level = 1, id = 11  }, -- ослабление
    { level = 1, id = 12  }, -- замедление
    { level = 2, id = 15  }, -- немощность
    { level = 2, id = 13  }, -- разрушающий луч
    { level = 3, id = 17  }, -- рассеяность
    { level = 3, id = 14  }, -- чума
    { level = 3, id = 277 }, -- скорбь
    { level = 4, id = 19  }, -- ослепление
    { level = 4, id = 278 }, -- вампиризм
    { level = 5, id = 18  }, -- берсерк
    { level = 5, id = 20  }, -- подчинение
    --{ level = 5, id = 21  }, -- нечестивое слово
  },
  [TYPE_MAGICS.DESTRUCTIVE] = {
    { level = 1, id = 237 }, -- каменные шипы
    { level = 1, id = 1   }, -- магическая стрела
    { level = 2, id = 4   }, -- ледяная глыба
    { level = 2, id = 3   }, -- молния
    { level = 3, id = 6   }, -- кольцо холода
    { level = 3, id = 5   }, -- огненный шар
    { level = 3, id = 236 }, -- стена огня
    { level = 4, id = 7   }, -- цепь молний
    { level = 4, id = 8   }, -- метеоритный дождь
    { level = 5, id = 279 }, -- останавливающий холод
    { level = 5, id = 9   }, -- шок земли
    { level = 5, id = 10  }, -- армагеддон
  },
  [TYPE_MAGICS.SUMMON] = {
    { level = 1, id = 2   }, -- волшебный кулак
    { level = 1, id = 38  }, -- огненная ловушка
    { level = 2, id = 39  }, -- призыв осиного роя
    { level = 2, id = 282 }, -- кристалл тайного
    { level = 3, id = 284 }, -- стена мечей
    { level = 3, id = 42  }, -- поднятие мертвых
    { level = 3, id = 40  }, -- создание фантома
    --{ level = 3, id = 41  }, -- землетрясение
    { level = 4, id = 43  }, -- призыв элементалей
    { level = 4, id = 283 }, -- призыв улья
    { level = 5, id = 235 }, -- призыв феникса
    { level = 5, id = 34  }, -- небесный щит
  },
  [TYPE_MAGICS.RUNES] = {
    { level = 1, id = 249 }, -- руна энергии
    { level = 1, id = 253 }, -- руна стихийной невосприимчивости
    { level = 2, id = 251 }, -- руна магического надзора
    { level = 2, id = 252 }, -- руна экзорзизма
    { level = 3, id = 256 }, -- руна неосязаемости
    { level = 3, id = 254 }, -- руна громового раската
    { level = 4, id = 250 }, -- руна берсеркерства
    { level = 4, id = 257 }, -- руна воскрешения
    { level = 5, id = 258 }, -- руна драконьего обличья
    { level = 5, id = 255 }, -- руна боевой ярости
  },
  [TYPE_MAGICS.WARCRIES] = {
    { level = 1, id = 290}, -- объединяющий клич
    { level = 1, id = 291}, -- зов крови
    { level = 2, id = 292}, -- слово вождя
    { level = 2, id = 293}, -- устрашающий рык
    { level = 3, id = 294}, -- боевой клич
    { level = 3, id = 295}, -- ярость орды
  }
};

-- Список заклинаний, не участвующих в основной линейке.
-- Используются как дополнительные
ONLY_ADDITIONAL_SPELL_ID_LIST = {
  SPELL_REGENERATION, -- регенерация
  SPELL_SORROW,       -- скорбь
  SPELL_FIREWALL      -- стена огня
};

-- Сгенерированный набор заклинаний для
-- 2 Набора основных заклинаний для возможности покупки второго набора
PLAYERS_GENERATED_SPELLS = {
  [PLAYER_1] = {
    countResetSpells = 0,
    countResetRunes = 0,
    bonus_spells = {},
    spells = {
      {},
      {},
    },
    runes = {
      {},
      {},
    },
  },
  [PLAYER_2] = {
    countResetSpells = 0,
    countResetRunes = 0,
    bonus_spells = {},
    spells = {
      {},
      {},
    },
    runes = {
      {},
      {},
    },
  },
};

-- Координаты сгенерированных заклинаний для обоих игроков
PLACE_GENERATED_SPELLS = {
  [PLAYER_1] = {
    SPELLS = {
      {x = 33, y = 87}, {x = 34, y = 87}, {x = 35, y = 87}, {x = 36, y = 87}, {x = 37, y = 87},
      {x = 33, y = 88}, {x = 34, y = 88}, {x = 35, y = 88}, {x = 36, y = 88}, {x = 37, y = 88},
      {x = 38, y = 87}, {x = 39, y = 87}, {x = 38, y = 88}, {x = 39, y = 88},
      {x = 33, y = 89}, {x = 34, y = 89}, {x = 35, y = 89}, {x = 36, y = 89}, {x = 37, y = 89},
      {x = 33, y = 90}, {x = 34, y = 90}, {x = 35, y = 90}, {x = 36, y = 90}, {x = 37, y = 90}
    },
    RUNES = {
      {x = 33, y = 89}, {x = 34, y = 89}, {x = 35, y = 89}, {x = 36, y = 89}, {x = 37, y = 89},
    },
    WARCRIES = {
      {x = 33, y = 87}, {x = 35, y = 87}, {x = 37, y = 87},
    }
  },
  [PLAYER_2] = {
    SPELLS = {
      {x = 44, y = 22}, {x = 43, y = 22}, {x = 42, y = 22}, {x = 41, y = 22}, {x = 40, y = 22},
      {x = 44, y = 21}, {x = 43, y = 21}, {x = 42, y = 21}, {x = 41, y = 21}, {x = 40, y = 21},
      {x = 39, y = 22}, {x = 38, y = 22}, {x = 39, y = 21}, {x = 38, y = 21},
      {x = 44, y = 20}, {x = 43, y = 20}, {x = 42, y = 20}, {x = 41, y = 20}, {x = 40, y = 20},
      {x = 44, y = 19}, {x = 43, y = 19}, {x = 42, y = 19}, {x = 41, y = 19}, {x = 40, y = 19},
    },
    RUNES = {
      {x = 44, y = 20}, {x = 43, y = 20}, {x = 42, y = 20}, {x = 41, y = 20}, {x = 40, y = 20},
    },
    WARCRIES = {
      {x = 44, y = 22}, {x = 42, y = 22}, {x = 40, y = 22},
    }
  },
};

-- Перечень цен на перегенерацию заклинаний
SPELLS_RESET_COSTS = {
  DEFAULT = 8500,
  WARCRIES = 7000,
  RUNES = 7000
}
