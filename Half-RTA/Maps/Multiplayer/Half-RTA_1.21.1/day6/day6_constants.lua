
-- �������� ���� ��������� �������
ALL_SKILLS_TABLE = {
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
  SKILL_TRAINING,
  SKILL_GATING,
  SKILL_NECROMANCY,
  SKILL_AVENGER,
  SKILL_ARTIFICIER,
  SKILL_INVOCATION,
  HERO_SKILL_RUNELORE,
  HERO_SKILL_DEMONIC_RAGE,
  HERO_SKILL_BARBARIAN_LEARNING,
  HERO_SKILL_VOICE,
  HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC,
  HERO_SKILL_SHATTER_DARK_MAGIC,
  HERO_SKILL_SHATTER_LIGHT_MAGIC,
  HERO_SKILL_SHATTER_SUMMONING_MAGIC
};

-- �������� ���� ��������� ������
ALL_PERKS_TABLE = {
  PERK_PATHFINDING,
  PERK_SCOUTING,
  PERK_NAVIGATION,
  PERK_FIRST_AID,
  PERK_BALLISTA,
  PERK_CATAPULT,
  PERK_INTELLIGENCE,
  PERK_SCHOLAR,
  PERK_EAGLE_EYE,
  PERK_RECRUITMENT,
  PERK_ESTATES,
  PERK_DIPLOMACY,
  PERK_RESISTANCE,
  PERK_LUCKY_STRIKE,
  PERK_FORTUNATE_ADVENTURER,
  PERK_TACTICS,
  PERK_ARCHERY,
  PERK_FRENZY,
  PERK_PROTECTION,
  PERK_EVASION,
  PERK_TOUGHNESS,
  PERK_MYSTICISM,
  PERK_WISDOM,
  PERK_ARCANE_TRAINING,
  PERK_MASTER_OF_ICE,
  PERK_MASTER_OF_FIRE,
  PERK_MASTER_OF_LIGHTNINGS,
  PERK_MASTER_OF_CURSES,
  PERK_MASTER_OF_MIND,
  PERK_MASTER_OF_SICKNESS,
  PERK_MASTER_OF_BLESSING,
  PERK_MASTER_OF_ABJURATION,
  PERK_MASTER_OF_WRATH,
  PERK_MASTER_OF_QUAKES,
  PERK_MASTER_OF_CREATURES,
  PERK_MASTER_OF_ANIMATION,
  PERK_HOLY_CHARGE,
  PERK_PRAYER,
  PERK_EXPERT_TRAINER,
  PERK_CONSUME_CORPSE,
  PERK_DEMONIC_FIRE,
  PERK_DEMONIC_STRIKE,
  PERK_RAISE_ARCHERS,
  PERK_NO_REST_FOR_THE_WICKED,
  PERK_DEATH_SCREAM,
  PERK_MULTISHOT,
  PERK_SNIPE_DEAD,
  PERK_IMBUE_ARROW,
  PERK_MAGIC_BOND,
  PERK_MELT_ARTIFACT,
  PERK_MAGIC_MIRROR,
  PERK_EMPOWERED_SPELLS,
  PERK_DARK_RITUAL,
  PERK_ELEMENTAL_VISION,
  KNIGHT_FEAT_ROAD_HOME,
  KNIGHT_FEAT_TRIPLE_BALLISTA,
  KNIGHT_FEAT_ENCOURAGE,
  KNIGHT_FEAT_RETRIBUTION,
  KNIGHT_FEAT_HOLD_GROUND,
  KNIGHT_FEAT_GUARDIAN_ANGEL,
  KNIGHT_FEAT_STUDENT_AWARD,
  KNIGHT_FEAT_GRAIL_VISION,
  KNIGHT_FEAT_CASTER_CERTIFICATE,
  KNIGHT_FEAT_ANCIENT_SMITHY,
  KNIGHT_FEAT_PARIAH,
  KNIGHT_FEAT_ELEMENTAL_BALANCE,
  KNIGHT_FEAT_ABSOLUTE_CHARGE,
  DEMON_FEAT_QUICK_GATING,
  DEMON_FEAT_MASTER_OF_SECRETS,
  DEMON_FEAT_TRIPLE_CATAPULT,
  DEMON_FEAT_GATING_MASTERY,
  DEMON_FEAT_CRITICAL_GATING,
  DEMON_FEAT_CRITICAL_STRIKE,
  DEMON_FEAT_DEMONIC_RETALIATION,
  DEMON_FEAT_EXPLODING_CORPSES,
  DEMON_FEAT_DEMONIC_FLAME,
  DEMON_FEAT_WEAKENING_STRIKE,
  DEMON_FEAT_FIRE_PROTECTION,
  DEMON_FEAT_FIRE_AFFINITY,
  DEMON_FEAT_ABSOLUTE_GATING,
  NECROMANCER_FEAT_DEATH_TREAD,
  NECROMANCER_FEAT_LAST_AID,
  NECROMANCER_FEAT_LORD_OF_UNDEAD,
  NECROMANCER_FEAT_HERALD_OF_DEATH,
  NECROMANCER_FEAT_DEAD_LUCK,
  NECROMANCER_FEAT_CHILLING_STEEL,
  NECROMANCER_FEAT_CHILLING_BONES,
  NECROMANCER_FEAT_SPELLPROOF_BONES,
  NECROMANCER_FEAT_DEADLY_COLD,
  NECROMANCER_FEAT_SPIRIT_LINK,
  NECROMANCER_FEAT_TWILIGHT,
  NECROMANCER_FEAT_HAUNT_MINE,
  NECROMANCER_FEAT_ABSOLUTE_FEAR,
  RANGER_FEAT_DISGUISE_AND_RECKON,
  RANGER_FEAT_IMBUE_BALLISTA,
  RANGER_FEAT_CUNNING_OF_THE_WOODS,
  RANGER_FEAT_FOREST_GUARD_EMBLEM,
  RANGER_FEAT_ELVEN_LUCK,
  RANGER_FEAT_FOREST_RAGE,
  RANGER_FEAT_LAST_STAND,
  RANGER_FEAT_INSIGHTS,
  RANGER_FEAT_SUN_FIRE,
  RANGER_FEAT_SOIL_BURN,
  RANGER_FEAT_STORM_WIND,
  RANGER_FEAT_FOG_VEIL,
  RANGER_FEAT_ABSOLUTE_LUCK,
  WIZARD_FEAT_MARCH_OF_THE_MACHINES,
  WIZARD_FEAT_REMOTE_CONTROL,
  WIZARD_FEAT_ACADEMY_AWARD,
  WIZARD_FEAT_ARTIFICIAL_GLORY,
  WIZARD_FEAT_SPOILS_OF_WAR,
  WIZARD_FEAT_WILDFIRE,
  WIZARD_FEAT_SEAL_OF_PROTECTION,
  WIZARD_FEAT_COUNTERSPELL,
  WIZARD_FEAT_MAGIC_CUSHION,
  WIZARD_FEAT_SUPRESS_DARK,
  WIZARD_FEAT_SUPRESS_LIGHT,
  WIZARD_FEAT_UNSUMMON,
  WIZARD_FEAT_ABSOLUTE_WIZARDY,
  WARLOCK_FEAT_TELEPORT_ASSAULT,
  WARLOCK_FEAT_SHAKE_GROUND,
  WARLOCK_FEAT_DARK_REVELATION,
  WARLOCK_FEAT_FAST_AND_FURIOUS,
  WARLOCK_FEAT_LUCKY_SPELLS,
  WARLOCK_FEAT_POWER_OF_HASTE,
  WARLOCK_FEAT_POWER_OF_STONE,
  WARLOCK_FEAT_CHAOTIC_SPELLS,
  WARLOCK_FEAT_SECRETS_OF_DESTRUCTION,
  WARLOCK_FEAT_PAYBACK,
  WARLOCK_FEAT_ELITE_CASTERS,
  WARLOCK_FEAT_ELEMENTAL_OVERKILL,
  WARLOCK_FEAT_ABSOLUTE_CHAINS,
  HERO_SKILL_REFRESH_RUNE,
  HERO_SKILL_STRONG_RUNE,
  HERO_SKILL_FINE_RUNE,
  HERO_SKILL_QUICKNESS_OF_MIND,
  HERO_SKILL_RUNIC_MACHINES,
  HERO_SKILL_TAP_RUNES,
  HERO_SKILL_RUNIC_ATTUNEMENT,
  HERO_SKILL_DWARVEN_LUCK,
  HERO_SKILL_OFFENSIVE_FORMATION,
  HERO_SKILL_DEFENSIVE_FORMATION,
  HERO_SKILL_DISTRACT,
  HERO_SKILL_SET_AFIRE,
  HERO_SKILL_SHRUG_DARKNESS,
  HERO_SKILL_ETERNAL_LIGHT,
  HERO_SKILL_RUNIC_ARMOR,
  HERO_SKILL_ABSOLUTE_PROTECTION,
  HERO_SKILL_SNATCH,
  HERO_SKILL_MENTORING,
  HERO_SKILL_EMPATHY,
  HERO_SKILL_PREPARATION,
  HERO_SKILL_MIGHT_OVER_MAGIC,
  HERO_SKILL_MEMORY_OF_OUR_BLOOD,
  HERO_SKILL_POWERFULL_BLOW,
  HERO_SKILL_ABSOLUTE_RAGE,
  HERO_SKILL_PATH_OF_WAR,
  HERO_SKILL_BATTLE_ELATION,
  HERO_SKILL_LUCK_OF_THE_BARBARIAN,
  HERO_SKILL_STUNNING_BLOW,
  HERO_SKILL_DEFEND_US_ALL,
  HERO_SKILL_GOBLIN_SUPPORT,
  HERO_SKILL_POWER_OF_BLOOD,
  HERO_SKILL_WARCRY_LEARNING,
  HERO_SKILL_BODYBUILDING,
  HERO_SKILL_VOICE_TRAINING,
  HERO_SKILL_MIGHTY_VOICE,
  HERO_SKILL_VOICE_OF_RAGE,
  HERO_SKILL_CORRUPT_DESTRUCTIVE,
  HERO_SKILL_WEAKEN_DESTRUCTIVE,
  HERO_SKILL_DETAIN_DESTRUCTIVE,
  HERO_SKILL_CORRUPT_DARK,
  HERO_SKILL_WEAKEN_DARK,
  HERO_SKILL_DETAIN_DARK,
  HERO_SKILL_CORRUPT_LIGHT,
  HERO_SKILL_WEAKEN_LIGHT,
  HERO_SKILL_DETAIN_LIGHT,
  HERO_SKILL_CORRUPT_SUMMONING,
  HERO_SKILL_WEAKEN_SUMMONING,
  HERO_SKILL_DETAIN_SUMMONING,
  HERO_SKILL_DEATH_TO_NONEXISTENT,
  HERO_SKILL_BARBARIAN_ANCIENT_SMITHY,
  HERO_SKILL_BARBARIAN_WEAKENING_STRIKE,
  HERO_SKILL_BARBARIAN_SOIL_BURN,
  HERO_SKILL_BARBARIAN_FOG_VEIL,
  HERO_SKILL_BARBARIAN_INTELLIGENCE,
  HERO_SKILL_BARBARIAN_MYSTICISM,
  HERO_SKILL_BARBARIAN_ELITE_CASTERS,
  HERO_SKILL_BARBARIAN_STORM_WIND,
  216,
  217,
  218,
  219,
  220,
};

-- ����������� ������� ������������ ���� ����� �� �������������
MAP_CUSTOM_SKILL_TO_INNER = {
  [TYPE_MAGICS.LIGHT] = SKILL_LIGHT_MAGIC,
  [TYPE_MAGICS.DARK] = SKILL_DARK_MAGIC,
  [TYPE_MAGICS.DESTRUCTIVE] = SKILL_DESTRUCTIVE_MAGIC,
  [TYPE_MAGICS.SUMMON] = SKILL_SUMMONING_MAGIC,
  [TYPE_MAGICS.RUNES] = HERO_SKILL_RUNELORE,
  [TYPE_MAGICS.WARCRIES] = HERO_SKILL_DEMONIC_RAGE,
};