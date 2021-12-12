-- �� ��������� �������, ���� � ���
consoleCmd('@nde = 1')

sleep(10)
if nde == 1 then
	return
end

-- ����������� ������ ����� ������ � �������
-- ��������� ������ � ����
consoleCmd('console_size 999')
consoleCmd('game_writelog 0')
sleep(1)

doFile(GetMapDataPath()..'common.lua');
doFile(GetMapDataPath()..'utils.lua');
doFile(GetMapDataPath()..'constants.lua');
sleep(1)

removeHeroMovePoints(Biara);
removeHeroMovePoints(Djovanni);

heroes1 = GetPlayerHeroes (PLAYER_1)
heroes2 = GetPlayerHeroes (PLAYER_2)

-- ���������� ����������� ������ ���
function handleNewDay()
  if GetDate(DAY) == 2 then
    doFile(GetMapDataPath().."day2/day2_scripts.lua");
  end;

  if GetDate(DAY) == 3 then
    doFile(GetMapDataPath().."day3/day3_scripts.lua");
  end;
end;

-- �������� ��������
Trigger (NEW_DAY_TRIGGER, 'handleNewDay');

doFile(GetMapDataPath().."day1/day1_scripts.lua");

-- ������������ ��� ������ ����
function mainMock()

function InitCombatExecThread(hero)
	StartCombat(hero, nil, 1, 1, 1, '/scripts/RTA_TestExecutionThread.(Script).xdb#xpointer(/Script)')
	local t = {}
	for i=1,6 do
		t[i] = random(16777216)
	end
	consoleCmd([[@SetGameVar('combat_prng_seed', 'return {]] .. concat(t, ',') .. [[}')]])
end

function SaveHeroesInfoBeforeCombat(heroes)
	local t = {[[@SetGameVar('heroes_info', 'return {]]}
	for i, hero in heroes do
		append(t, '["' .. hero .. '"]={')

		-- ������� --
		append(t, 'level=' .. GetHeroLevel(hero) .. ',')
		
		-- ����� --
		append(t, 'luck=' .. GetHeroStat(hero, STAT_LUCK) .. ',')
		
		-- ��������� --
		append(t, 'ArtSet={')
    for artset = 0, 9 do
      local artsetlevel = GetArtifactSetItemsCount(hero, artset, 1)
      if artsetlevel > 0 then
        append(t, '[' .. artset .. ']=' .. artsetlevel .. ',')
      end
    end
    append(t, '},')

		-- ������ � ������ --
		append(t, 'skills={')
		for skill = 1, 220 do
			local mastery = GetHeroSkillMastery(hero, skill)
			if mastery > 0 then
				append(t, '[' .. skill .. ']=' .. mastery .. ',')
			end
		end
		append(t, '},')
		


		append(t, '},')
	end
	append(t, [[}')]])
	consoleCmd(concat(t))
end

------------------ SPELLS --------------------------

array_spells={}
array_spells[0] = {
   { ["name"] = "spell_1_1_1",  ["name2"] = "spell_1_1_2",  ["name3"] = "spell_1_1_3",  ["name4"] = "spell_1_1_4", ["text"] = "spell_1_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 23  },                      -- ������������ ����

   { ["name"] = "spell_1_6_1",  ["name2"] = "spell_1_6_2",  ["name3"] = "spell_1_6_3",  ["name4"] = "spell_1_6_4", ["text"] = "spell_1_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 29  },                      -- ���������

   { ["name"] = "spell_1_3_1",  ["name2"] = "spell_1_3_2",  ["name3"] = "spell_1_3_3",  ["name4"] = "spell_1_3_4", ["text"] = "spell_1_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 25  },                      -- �������� ����

   { ["name"] = "spell_1_2_1",  ["name2"] = "spell_1_2_2",  ["name3"] = "spell_1_2_3",  ["name4"] = "spell_1_2_4", ["text"] = "spell_1_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 24  },                      -- ���������

   { ["name"] = "spell_1_7_1",  ["name2"] = "spell_1_7_2",  ["name3"] = "spell_1_7_3",  ["name4"] = "spell_1_7_4", ["text"] = "spell_1_7.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 28  },                      -- �������� ����

   { ["name"] = "spell_1_5_1",  ["name2"] = "spell_1_5_2",  ["name3"] = "spell_1_5_3",  ["name4"] = "spell_1_5_4", ["text"] = "spell_1_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 26  },                      -- ������ ���

   { ["name"] = "spell_1_4_1",  ["name2"] = "spell_1_4_2",  ["name3"] = "spell_1_4_3",  ["name4"] = "spell_1_4_4", ["text"] = "spell_1_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] =   0, ["id"] = 280 },                      -- �����������

   { ["name"] = "spell_1_8_1",  ["name2"] = "spell_1_8_2",  ["name3"] = "spell_1_8_3",  ["name4"] = "spell_1_8_4", ["text"] = "spell_1_8.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 32  },                      -- ��������

   { ["name"] = "spell_1_9_1",  ["name2"] = "spell_1_9_2",  ["name3"] = "spell_1_9_3",  ["name4"] = "spell_1_9_4", ["text"] = "spell_1_9.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 31  },                      -- ���������

   { ["name"] = "spell_1_10_1", ["name2"] = "spell_1_10_2", ["name3"] = "spell_1_10_3", ["name4"] = "spell_1_10_4", ["text"] = "spell_1_10.txt",
     ["blocked"] = 1, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 281 },                      -- ������������ �����

   { ["name"] = "spell_1_11_1", ["name2"] = "spell_1_11_2", ["name3"] = "spell_1_11_3", ["name4"] = "spell_1_11_4", ["text"] = "spell_1_11.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 48  },                      -- �����������

   { ["name"] = "spell_1_12_1", ["name2"] = "spell_1_12_2", ["name3"] = "spell_1_12_3", ["name4"] = "spell_1_12_4", ["text"] = "spell_1_12.txt",
     ["blocked"] = 1, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 35  }                       -- ������ �����
};

array_spells[1] = {
   { ["name"] = "spell_2_2_1",  ["name2"] = "spell_2_2_2",  ["name3"] = "spell_2_2_3",  ["name4"] = "spell_2_2_4", ["text"] = "spell_2_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 11  },                      -- ����������

   { ["name"] = "spell_2_3_1",  ["name2"] = "spell_2_3_2",  ["name3"] = "spell_2_3_3",  ["name4"] = "spell_2_3_4", ["text"] = "spell_2_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 12  },                      -- ����������

   { ["name"] = "spell_2_7_1",  ["name2"] = "spell_2_7_2",  ["name3"] = "spell_2_7_3",  ["name4"] = "spell_2_7_4", ["text"] = "spell_2_7.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 15  },                      -- ����������

   { ["name"] = "spell_2_4_1",  ["name2"] = "spell_2_4_2",  ["name3"] = "spell_2_4_3",  ["name4"] = "spell_2_4_4", ["text"] = "spell_2_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 13  },                      -- ����������� ���

   { ["name"] = "spell_2_6_1",  ["name2"] = "spell_2_6_2",  ["name3"] = "spell_2_6_3",  ["name4"] = "spell_2_6_4", ["text"] = "spell_2_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 17  },                      -- �����������

   { ["name"] = "spell_2_5_1",  ["name2"] = "spell_2_5_2",  ["name3"] = "spell_2_5_3",  ["name4"] = "spell_2_5_4", ["text"] = "spell_2_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 14  },                      -- ����

   { ["name"] = "spell_2_1_1",  ["name2"] = "spell_2_1_2",  ["name3"] = "spell_2_1_3",  ["name4"] = "spell_2_1_4", ["text"] = "spell_2_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] =   0, ["id"] = 277 },                      -- ������

   { ["name"] = "spell_2_8_1",  ["name2"] = "spell_2_8_2",  ["name3"] = "spell_2_8_3",  ["name4"] = "spell_2_8_4", ["text"] = "spell_2_8.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 19  },                      -- ����������

   { ["name"] = "spell_2_10_1", ["name2"] = "spell_2_10_2", ["name3"] = "spell_2_10_3", ["name4"] = "spell_2_10_4", ["text"] = "spell_2_10.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 278 },                      -- ���������

   { ["name"] = "spell_2_9_1",  ["name2"] = "spell_2_9_2",  ["name3"] = "spell_2_9_3",  ["name4"] = "spell_2_9_4", ["text"] = "spell_2_9.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 18  },                      -- �������

   { ["name"] = "spell_2_11_1", ["name2"] = "spell_2_11_2", ["name3"] = "spell_2_11_3", ["name4"] = "spell_2_11_4", ["text"] = "spell_2_11.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 20  },                      -- ����������

   { ["name"] = "spell_2_12_1", ["name2"] = "spell_2_12_2", ["name3"] = "spell_2_12_3", ["name4"] = "spell_2_12_4", ["text"] = "spell_2_12.txt",
     ["blocked"] = 1, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 21  }                       -- ���������� �����
};

array_spells[2] = {
   { ["name"] = "spell_3_1_1",  ["name2"] = "spell_3_1_2",  ["name3"] = "spell_3_1_3",  ["name4"] = "spell_3_1_4", ["text"] = "spell_3_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 237 },                      -- �������� ����

   { ["name"] = "spell_3_2_1",  ["name2"] = "spell_3_2_2",  ["name3"] = "spell_3_2_3",  ["name4"] = "spell_3_2_4", ["text"] = "spell_3_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 1   },                      -- ���������� ������

   { ["name"] = "spell_3_3_1",  ["name2"] = "spell_3_3_2",  ["name3"] = "spell_3_3_3",  ["name4"] = "spell_3_3_4", ["text"] = "spell_3_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 4   },                      -- ������� �����

   { ["name"] = "spell_3_4_1",  ["name2"] = "spell_3_4_2",  ["name3"] = "spell_3_4_3",  ["name4"] = "spell_3_4_4", ["text"] = "spell_3_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 3   },                      -- ������

   { ["name"] = "spell_3_5_1",  ["name2"] = "spell_3_5_2",  ["name3"] = "spell_3_5_3",  ["name4"] = "spell_3_5_4", ["text"] = "spell_3_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 6   },                      -- ������ ������

   { ["name"] = "spell_3_7_1",  ["name2"] = "spell_3_7_2",  ["name3"] = "spell_3_7_3",  ["name4"] = "spell_3_7_4", ["text"] = "spell_3_7.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 5   },                      -- �������� ���

   { ["name"] = "spell_3_6_1",  ["name2"] = "spell_3_6_2",  ["name3"] = "spell_3_6_3",  ["name4"] = "spell_3_6_4", ["text"] = "spell_3_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] =   0, ["id"] = 236 },                      -- ����� ����

   { ["name"] = "spell_3_8_1",  ["name2"] = "spell_3_8_2",  ["name3"] = "spell_3_8_3",  ["name4"] = "spell_3_8_4", ["text"] = "spell_3_8.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 7   },                      -- ���� ������

   { ["name"] = "spell_3_9_1",  ["name2"] = "spell_3_9_2",  ["name3"] = "spell_3_9_3",  ["name4"] = "spell_3_9_4", ["text"] = "spell_3_9.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 8   },                      -- ����������� �����

   { ["name"] = "spell_3_10_1", ["name2"] = "spell_3_10_2", ["name3"] = "spell_3_10_3", ["name4"] = "spell_3_10_4", ["text"] = "spell_3_10.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 279 },                      -- ��������������� �����

   { ["name"] = "spell_3_11_1", ["name2"] = "spell_3_11_2", ["name3"] = "spell_3_11_3", ["name4"] = "spell_3_11_4", ["text"] = "spell_3_11.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 9   },                      -- ��� �����

   { ["name"] = "spell_3_12_1", ["name2"] = "spell_3_12_2", ["name3"] = "spell_3_12_3", ["name4"] = "spell_3_12_4", ["text"] = "spell_3_12.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 10  }                       -- ����������
};

array_spells[3] = {
   { ["name"] = "spell_4_1_1",  ["name2"] = "spell_4_1_2",  ["name3"] = "spell_4_1_3",  ["name4"] = "spell_4_1_4", ["text"] = "spell_4_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 2   },                      -- ��������� �����

   { ["name"] = "spell_4_2_1",  ["name2"] = "spell_4_2_2",  ["name3"] = "spell_4_2_3",  ["name4"] = "spell_4_2_4", ["text"] = "spell_4_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 38  },                      -- �������� �������

   { ["name"] = "spell_4_3_1",  ["name2"] = "spell_4_3_2",  ["name3"] = "spell_4_3_3",  ["name4"] = "spell_4_3_4", ["text"] = "spell_4_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 39  },                      -- ������ ������� ���

   { ["name"] = "spell_4_5_1",  ["name2"] = "spell_4_5_2",  ["name3"] = "spell_4_5_3",  ["name4"] = "spell_4_5_4", ["text"] = "spell_4_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 282 },                      -- �������� �������

   { ["name"] = "spell_4_7_1",  ["name2"] = "spell_4_7_2",  ["name3"] = "spell_4_7_3",  ["name4"] = "spell_4_7_4", ["text"] = "spell_4_7.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 284 },                      -- ����� �����

   { ["name"] = "spell_4_4_1",  ["name2"] = "spell_4_4_2",  ["name3"] = "spell_4_4_3",  ["name4"] = "spell_4_4_4", ["text"] = "spell_4_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 42  },                      -- �������� �������

   { ["name"] = "spell_4_6_1",  ["name2"] = "spell_4_6_2",  ["name3"] = "spell_4_6_3",  ["name4"] = "spell_4_6_4", ["text"] = "spell_4_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] =   0, ["id"] = 40  },                      -- �������� �������

   { ["name"] = "spell_4_8_1",  ["name2"] = "spell_4_8_2",  ["name3"] = "spell_4_8_3",  ["name4"] = "spell_4_8_4", ["text"] = "spell_4_8.txt",
     ["blocked"] = 1, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 41  },                      -- �������������

   { ["name"] = "spell_4_9_1",  ["name2"] = "spell_4_9_2",  ["name3"] = "spell_4_9_3",  ["name4"] = "spell_4_9_4", ["text"] = "spell_4_9.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 43  },                      -- ������ �����������

   { ["name"] = "spell_4_10_1", ["name2"] = "spell_4_10_2", ["name3"] = "spell_4_10_3", ["name4"] = "spell_4_10_4", ["text"] = "spell_4_10.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 283 },                      -- ������ ����

   { ["name"] = "spell_4_11_1", ["name2"] = "spell_4_11_2", ["name3"] = "spell_4_11_3", ["name4"] = "spell_4_11_4", ["text"] = "spell_4_11.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 235 },                      -- ������ �������

   { ["name"] = "spell_4_12_1", ["name2"] = "spell_4_12_2", ["name3"] = "spell_4_12_3", ["name4"] = "spell_4_12_4", ["text"] = "spell_4_12.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 34  }                       -- �������� ���
};

array_spells[4] = {
   { ["name"] = "spell_5_1_1",  ["name2"] = "spell_5_1_2",  ["name3"] = "spell_5_1_3",  ["name4"] = "spell_5_1_4", ["text"] = "spell_5_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 249 },                      -- ���� �������

   { ["name"] = "spell_5_5_1",  ["name2"] = "spell_5_5_2",  ["name3"] = "spell_5_5_3",  ["name4"] = "spell_5_5_4", ["text"] = "spell_5_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 253 },                      -- ���� ��������� �����������������

   { ["name"] = "spell_5_3_1",  ["name2"] = "spell_5_3_2",  ["name3"] = "spell_5_3_3",  ["name4"] = "spell_5_3_4", ["text"] = "spell_5_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 251 },                      -- ���� ����������� �������

   { ["name"] = "spell_5_4_1",  ["name2"] = "spell_5_4_2",  ["name3"] = "spell_5_4_3",  ["name4"] = "spell_5_4_4", ["text"] = "spell_5_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 252 },                      -- ���� ����������

   { ["name"] = "spell_5_6_1",  ["name2"] = "spell_5_6_2",  ["name3"] = "spell_5_6_3",  ["name4"] = "spell_5_6_4", ["text"] = "spell_5_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 256 },                      -- ���� �������������

   { ["name"] = "spell_5_7_1",  ["name2"] = "spell_5_7_2",  ["name3"] = "spell_5_7_3",  ["name4"] = "spell_5_7_4", ["text"] = "spell_5_7.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 254 },                      -- ���� ��������� �������

   { ["name"] = "spell_5_2_1",  ["name2"] = "spell_5_2_2",  ["name3"] = "spell_5_2_3",  ["name4"] = "spell_5_2_4", ["text"] = "spell_5_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 250 },                      -- ���� �������������

   { ["name"] = "spell_5_8_1",  ["name2"] = "spell_5_8_2",  ["name3"] = "spell_5_8_3",  ["name4"] = "spell_5_8_4", ["text"] = "spell_5_8.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 4,  ["kv"] = 100, ["id"] = 257 },                      -- ���� �����������

   { ["name"] = "spell_5_9_1",  ["name2"] = "spell_5_9_2",  ["name3"] = "spell_5_9_3",  ["name4"] = "spell_5_9_4", ["text"] = "spell_5_9.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 258 },                      -- ���� ���������� �������

   { ["name"] = "spell_5_10_1", ["name2"] = "spell_5_10_2", ["name3"] = "spell_5_10_3", ["name4"] = "spell_5_10_4", ["text"] = "spell_5_10.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 5,  ["kv"] = 100, ["id"] = 255 },                      -- ���� ������ ������
};

array_spells[5] = {
   { ["name"] = "spell_6_1_1",  ["name2"] = "spell_6_1_2",  ["name3"] = "spell_6_1_3",  ["name4"] = "spell_6_1_4", ["text"] = "spell_6_1.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 290},                       -- ������������ ����

   { ["name"] = "spell_6_2_1",  ["name2"] = "spell_6_2_2",  ["name3"] = "spell_6_2_3",  ["name4"] = "spell_6_2_4", ["text"] = "spell_6_2.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 1,  ["kv"] = 100, ["id"] = 291},                       -- ��� �����

   { ["name"] = "spell_6_3_1",  ["name2"] = "spell_6_3_2",  ["name3"] = "spell_6_3_3",  ["name4"] = "spell_6_3_4", ["text"] = "spell_6_3.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 292},                       -- ����� �����

   { ["name"] = "spell_6_4_1",  ["name2"] = "spell_6_4_2",  ["name3"] = "spell_6_4_3",  ["name4"] = "spell_6_4_4", ["text"] = "spell_6_4.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 2,  ["kv"] = 100, ["id"] = 293},                       -- ����������� ���

   { ["name"] = "spell_6_5_1",  ["name2"] = "spell_6_5_2",  ["name3"] = "spell_6_5_3",  ["name4"] = "spell_6_5_4", ["text"] = "spell_6_5.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 294},                       -- ������ ����

   { ["name"] = "spell_6_6_1",  ["name2"] = "spell_6_6_2",  ["name3"] = "spell_6_6_3",  ["name4"] = "spell_6_6_4", ["text"] = "spell_6_6.txt",
     ["blocked"] = 0, ["block_temply"] = 0,  ["level"] = 3,  ["kv"] = 100, ["id"] = 295},                       -- ������ ����
};

for i = 0, 5 do
  for j = 1, length(array_spells[i]) do
    SetObjectEnabled(array_spells[i][j].name,  nil);
    SetObjectEnabled(array_spells[i][j].name2, nil);
    SetObjectEnabled(array_spells[i][j].name3, nil);
    SetObjectEnabled(array_spells[i][j].name4, nil);
  end;
end;


------------------ ARTS ----------------------------

array_arts[0] = {
   { ["name"] = "art1",  ["name2"] = "art1x2",  ["place"] = 7, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 1},   --��� ����
   { ["name"] = "art2",  ["name2"] = "art2x2",  ["place"] = 7, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 90},  --�� ����� ����������
   { ["name"] = "art4",  ["name2"] = "art4x2",  ["place"] = 6, ["price"] = 4000,  ["blocked"] = 0, ["id"] = 8},   --������
   { ["name"] = "art5",  ["name2"] = "art5x2",  ["place"] = 6, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 87},  --������ ����
   { ["name"] = "art6",  ["name2"] = "art6x2",  ["place"] = 8, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 27},  --������ ���������� ������
--   { ["name"] = "art7",  ["name2"] = "art7x2",  ["place"] = 2, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 34},  --������ ��������������
   { ["name"] = "art8",  ["name2"] = "art8x2",  ["place"] = 2, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 66},  --���� �����
   { ["name"] = "art9",  ["name2"] = "art9x2",  ["place"] = 4, ["price"] = 5500,  ["blocked"] = 0, ["id"] = 64},  --������ �� �����
   { ["name"] = "art10", ["name2"] = "art10x2", ["place"] = 4, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 14},  --��������� ����
   { ["name"] = "art12", ["name2"] = "art12x2", ["place"] = 7, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 80},  --������� �������
   { ["name"] = "art13", ["name2"] = "art13x2", ["place"] = 9, ["price"] = 7000,  ["blocked"] = 0, ["id"] = 62},  --���� �������
   { ["name"] = "art14", ["name2"] = "art14x2", ["place"] = 9, ["price"] = 4500,  ["blocked"] = 0, ["id"] = 84},  --�������� �������
   { ["name"] = "art15", ["name2"] = "art15x2", ["place"] = 1, ["price"] = 6000,  ["blocked"] = 0, ["id"] = 20},  --������ �� ������
   { ["name"] = "art16", ["name2"] = "art16x2", ["place"] = 1, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 60},  --���� �����������
   { ["name"] = "art17", ["name2"] = "art17x2", ["place"] = 3, ["price"] = 4500,  ["blocked"] = 0, ["id"] = 16},  --������� ����
   { ["name"] = "art19", ["name2"] = "art19x2", ["place"] = 2, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 55},  --���� ����������
   { ["name"] = "art20", ["name2"] = "art20x2", ["place"] = 1, ["price"] = 4500,  ["blocked"] = 0, ["id"] = 70},  --������ ���������
   { ["name"] = "art21", ["name2"] = "art21x2", ["place"] = 6, ["price"] = 5000,  ["blocked"] = 0, ["id"] = 10},  --������ ����
   { ["name"] = "art11", ["name2"] = "art11x2", ["place"] = 4, ["price"] = 7000,  ["blocked"] = 0, ["id"] = 56},  --������ ����������
--   { ["name"] = "art22", ["name2"] = "art22x2", ["place"] = 6, ["price"] = 6500,  ["blocked"] = 1, ["id"] = 86}   --���� �������
};
array_arts[1] = {
--   { ["name"] = "art23", ["name2"] = "art23x2", ["place"] = 8, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 61},  --���������� �����
--   { ["name"] = "art24", ["name2"] = "art24x2", ["place"] = 9, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 32},  --������� �������
   { ["name"] = "art26", ["name2"] = "art26x2", ["place"] = 1, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 65},  --������ ���������������
--   { ["name"] = "art27", ["name2"] = "art27x2", ["place"] = 1, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 93},  --������ ��������
   { ["name"] = "art29", ["name2"] = "art29x2", ["place"] = 7, ["price"] = 7500,  ["blocked"] = 0, ["id"] = 74},  --������ ����
   { ["name"] = "art30", ["name2"] = "art30x2", ["place"] = 7, ["price"] = 9500,  ["blocked"] = 0, ["id"] = 85},  --������ �����
   { ["name"] = "art31", ["name2"] = "art31x2", ["place"] = 7, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 81},  --������ �����
   { ["name"] = "art32", ["name2"] = "art32x2", ["place"] = 7, ["price"] = 10000, ["blocked"] = 0, ["id"] = 2},   --������ ������� ������
   { ["name"] = "art33", ["name2"] = "art33x2", ["place"] = 7, ["price"] = 12500, ["blocked"] = 0, ["id"] = 43},  --��� �������
   { ["name"] = "art34", ["name2"] = "art34x2", ["place"] = 5, ["price"] = 7500,  ["blocked"] = 0, ["id"] = 58},  --������ ������
   { ["name"] = "art35", ["name2"] = "art35x2", ["place"] = 5, ["price"] = 8500,  ["blocked"] = 0, ["id"] = 75},  --��� ����
   { ["name"] = "art36", ["name2"] = "art36x2", ["place"] = 5, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 9},   --������� ���
   { ["name"] = "art37", ["name2"] = "art37x2", ["place"] = 5, ["price"] = 10000, ["blocked"] = 0, ["id"] = 71},  --��� ���� (������ ����������)
   { ["name"] = "art38", ["name2"] = "art38x2", ["place"] = 5, ["price"] = 10000, ["blocked"] = 0, ["id"] = 37},  --��� �������
   { ["name"] = "art39", ["name2"] = "art39x2", ["place"] = 6, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 25},  --������� �������
   { ["name"] = "art40", ["name2"] = "art40x2", ["place"] = 8, ["price"] = 10000, ["blocked"] = 0, ["id"] = 38},  --������ �������
   { ["name"] = "art41", ["name2"] = "art41x2", ["place"] = 2, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 41},  --���� �������
   { ["name"] = "art42", ["name2"] = "art42x2", ["place"] = 4, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 82},  --������ ������
   { ["name"] = "art43", ["name2"] = "art43x2", ["place"] = 4, ["price"] = 11000, ["blocked"] = 0, ["id"] = 36},  --������ �������
   { ["name"] = "art44", ["name2"] = "art44x2", ["place"] = 9, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 31},  --������� ����
   { ["name"] = "art45", ["name2"] = "art45x2", ["place"] = 9, ["price"] = 7500,  ["blocked"] = 0, ["id"] = 95},  --������ ���������
   { ["name"] = "art46", ["name2"] = "art46x2", ["place"] = 9, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 39},  --������ �������
   { ["name"] = "art47", ["name2"] = "art47x2", ["place"] = 1, ["price"] = 10000, ["blocked"] = 0, ["id"] = 23},  --������ ����������� ����
   { ["name"] = "art48", ["name2"] = "art48x2", ["place"] = 1, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 63},  --������ �������
   { ["name"] = "art49", ["name2"] = "art49x2", ["place"] = 1, ["price"] = 8000,  ["blocked"] = 0, ["id"] = 21},  --������ ��������� ����
   { ["name"] = "art51", ["name2"] = "art51x2", ["place"] = 1, ["price"] = 11000, ["blocked"] = 0, ["id"] = 42},  --������ �������
   { ["name"] = "art53", ["name2"] = "art53x2", ["place"] = 3, ["price"] = 9000,  ["blocked"] = 0, ["id"] = 19},  --�������� ������
   { ["name"] = "art54", ["name2"] = "art54x2", ["place"] = 3, ["price"] = 10000, ["blocked"] = 0, ["id"] = 40}   --�������� �������
--   { ["name"] = "art55", ["name2"] = "art55x2", ["place"] = 4, ["price"] = 6500,  ["blocked"] = 0, ["id"] = 35}   --�������� ��������������
};
array_arts[2] = {
   { ["name"] = "art52", ["name2"] = "art52x2", ["place"] = 3, ["price"] = 12000, ["blocked"] = 0, ["id"] = 17},  --�������� ������
   { ["name"] = "art50", ["name2"] = "art50x2", ["place"] = 1, ["price"] = 12000, ["blocked"] = 0, ["id"] = 59},  --������ ���������������
   { ["name"] = "art28", ["name2"] = "art28x2", ["place"] = 8, ["price"] = 12000, ["blocked"] = 0, ["id"] = 57},  --������ ��������
   { ["name"] = "art25", ["name2"] = "art25x2", ["place"] = 2, ["price"] = 12000, ["blocked"] = 0, ["id"] = 88},  --������ ���������
--   { ["name"] = "art56", ["name2"] = "art56x2", ["place"] = 1, ["price"] = 20000, ["blocked"] = 0, ["id"] = 91},  --������ �����
   { ["name"] = "art57", ["name2"] = "art57x2", ["place"] = 7, ["price"] = 15000, ["blocked"] = 0, ["id"] = 4},   --��� ���������
   { ["name"] = "art58", ["name2"] = "art58x2", ["place"] = 7, ["price"] = 12000, ["blocked"] = 0, ["id"] = 45},  --����� ���-����
   { ["name"] = "art59", ["name2"] = "art59x2", ["place"] = 5, ["price"] = 13000, ["blocked"] = 0, ["id"] = 51},  --��� ������
   { ["name"] = "art60", ["name2"] = "art60x2", ["place"] = 5, ["price"] = 12000, ["blocked"] = 0, ["id"] = 79},  --��� �������
   { ["name"] = "art61", ["name2"] = "art61x2", ["place"] = 5, ["price"] = 13000, ["blocked"] = 0, ["id"] = 77},  --��� �����
   { ["name"] = "art62", ["name2"] = "art62x2", ["place"] = 5, ["price"] = 13000, ["blocked"] = 0, ["id"] = 78},  --��� ����
   { ["name"] = "art63", ["name2"] = "art63x2", ["place"] = 5, ["price"] = 12000, ["blocked"] = 0, ["id"] = 76},  --��� �����
   { ["name"] = "art64", ["name2"] = "art64x2", ["place"] = 6, ["price"] = 16000, ["blocked"] = 0, ["id"] = 83},  --����� �������
   { ["name"] = "art65", ["name2"] = "art65x2", ["place"] = 8, ["price"] = 14500, ["blocked"] = 0, ["id"] = 68},  --������� �������
   { ["name"] = "art66", ["name2"] = "art66x2", ["place"] = 8, ["price"] = 13000, ["blocked"] = 0, ["id"] = 49},  --������ ������
   { ["name"] = "art67", ["name2"] = "art67x2", ["place"] = 2, ["price"] = 16000, ["blocked"] = 0, ["id"] = 11},  --������ ����
   { ["name"] = "art68", ["name2"] = "art68x2", ["place"] = 2, ["price"] = 15000, ["blocked"] = 0, ["id"] = 46},  --������ ���-����
   { ["name"] = "art69", ["name2"] = "art69x2", ["place"] = 2, ["price"] = 13000, ["blocked"] = 0, ["id"] = 50},  --���� ������
   { ["name"] = "art70", ["name2"] = "art70x2", ["place"] = 4, ["price"] = 15000, ["blocked"] = 0, ["id"] = 44},  --����� ���-����
   { ["name"] = "art71", ["name2"] = "art71x2", ["place"] = 4, ["price"] = 13000, ["blocked"] = 0, ["id"] = 48},  --������ ������
   { ["name"] = "art72", ["name2"] = "art72x2", ["place"] = 4, ["price"] = 23000, ["blocked"] = 0, ["id"] = 13},  --������ ��������
   { ["name"] = "art73", ["name2"] = "art73x2", ["place"] = 9, ["price"] = 18000, ["blocked"] = 0, ["id"] = 33},  --���� ������
   { ["name"] = "art74", ["name2"] = "art74x2", ["place"] = 1, ["price"] = 17000, ["blocked"] = 0, ["id"] = 47},  --������ ���-����
   { ["name"] = "art75", ["name2"] = "art75x2", ["place"] = 3, ["price"] = 12000, ["blocked"] = 0, ["id"] = 67},  --����� ����������
   { ["name"] = "art3",  ["name2"] = "art3x2",  ["place"] = 7, ["price"] = 14000, ["blocked"] = 0, ["id"] = 5},   --�������� �������
   { ["name"] = "art18", ["name2"] = "art18x2", ["place"] = 3, ["price"] = 14000, ["blocked"] = 0, ["id"] = 18},  --������� �����
   { ["name"] = "art77", ["name2"] = "art77x2", ["place"] = 7, ["price"] = 13000, ["blocked"] = 0, ["id"] = 7}    --����� ����������� (������� ������������)
--   { ["name"] = "art76", ["name2"] = "art76x2", ["place"] = 3, ["price"] = 15000, ["blocked"] = 0, ["id"] = 15},  --����� ����������
--   { ["name"] = "art78", ["name2"] = "art78x2", ["place"] = 7, ["price"] = 35000, ["blocked"] = 1, ["id"] = 6},   --����� �����������
--   { ["name"] = "art79", ["name2"] = "art79x2", ["place"] = 2, ["price"] = 26000, ["blocked"] = 1, ["id"] = 89},  --����� ��������������
--   { ["name"] = "art80", ["name2"] = "art80x2", ["place"] = 9, ["price"] = 16000, ["blocked"] = 1, ["id"] = 69},  --���� ������
--   { ["name"] = "art81", ["name2"] = "art81x2", ["place"] = 1, ["price"] = 30000, ["blocked"] = 1, ["id"] = 22}   --������ ��������
};

array_artPlace={};
array_artPlace[0]={};
array_artPlace[1]={{20,60,70},{21,23,42,63,21,59,63,65,93},{22,47,91}};
array_artPlace[2]={{34,55,66},{41,88},{11,46,50,89}};
array_artPlace[3]={{16,18,71},{17,19,40},{15,67}};
array_artPlace[4]={{14,56,64},{35,36,82},{13,44,48}};
array_artPlace[5]={{},{9,37,58,75,71},{51,76,77,78,79}};
array_artPlace[6]={{8,86,87},{25},{83}};
array_artPlace[7]={{1,5,80,90},{2,43,74,81,85},{4,6,7,45}};
array_artPlace[8]={{27},{38,57},{49,68}};
array_artPlace[9]={{62,84},{31,39,95},{33,69}};

ArtMaliy = {};
ArtMaliy = { 1, 90, 5, 8, 87, 27, 66, 64, 14, 56, 80, 62, 84, 20, 65, 60, 16, 18, 55, 88};

ArtVelikiy = {};
ArtVelikiy = { 61, 57, 32, 93, 74, 85, 81, 2, 43, 58, 75, 9, 71, 37, 25, 38, 41, 82, 36, 31, 95, 39, 23, 63, 21, 59, 42, 17, 19, 40, 91}

ArtRelikviya = {};
ArtRelikviya = { 4, 45, 51, 79, 77, 78, 76, 83, 68, 49, 11, 46, 50, 44, 48, 13, 33, 69, 47, 67, 15};



------------------ UNITS -------------------------

array_units={}
array_units[0] = {
   { ["name"] = "unit91", ["kol"] = 80, ["id"] =113, ["blocked"] = 0, ["price"] = 12000, ["price1"] =  150, ["power"] =  355, ["lvl"] = 1},
   { ["name"] = "unit92", ["kol"] = 50, ["id"] = 85, ["blocked"] = 0, ["price"] = 20000, ["price1"] =  400, ["power"] =  829, ["lvl"] = 4},
   { ["name"] = "unit93", ["kol"] = 50, ["id"] = 86, ["blocked"] = 0, ["price"] = 20000, ["price1"] =  400, ["power"] =  795, ["lvl"] = 4},
   { ["name"] = "unit94", ["kol"] = 50, ["id"] = 88, ["blocked"] = 0, ["price"] = 20000, ["price1"] =  400, ["power"] =  813, ["lvl"] = 4},
   { ["name"] = "unit95", ["kol"] = 50, ["id"] = 87, ["blocked"] = 0, ["price"] = 20000, ["price1"] =  400, ["power"] =  856, ["lvl"] = 4},
   { ["name"] = "unit96", ["kol"] = 30, ["id"] =116, ["blocked"] = 0, ["price"] = 25500, ["price1"] =  400, ["power"] = 1542, ["lvl"] = 5},
   { ["name"] = "unit97", ["kol"] = 18, ["id"] = 89, ["blocked"] = 0, ["price"] = 30600, ["price1"] = 1700, ["power"] = 2560, ["lvl"] = 6},
   { ["name"] = "unit98", ["kol"] = 18, ["id"] =115, ["blocked"] = 0, ["price"] = 30600, ["price1"] = 1700, ["power"] = 2523, ["lvl"] = 6},
   { ["name"] = "unit99", ["kol"] =  5, ["id"] = 91, ["blocked"] = 0, ["price"] = 30000, ["price1"] = 6000, ["power"] = 8576, ["lvl"] = 7}
};

array_units[1] = {
   { ["name"] = "unit111", ["kol"] =338, ["id"] =  1, ["blocked"] = 0, ["price"] =  8750, ["price1"] =   30, ["power"] =   72, ["lvl"] = 1},
   { ["name"] = "unit121", ["kol"] =144, ["id"] =  3, ["blocked"] = 0, ["price"] = 11700, ["price1"] =  100, ["power"] =  199, ["lvl"] = 2},
   { ["name"] = "unit131", ["kol"] =100, ["id"] =  5, ["blocked"] = 0, ["price"] =  8500, ["price1"] =  140, ["power"] =  287, ["lvl"] = 3},
   { ["name"] = "unit141", ["kol"] = 45, ["id"] =  7, ["blocked"] = 0, ["price"] = 11000, ["price1"] =  400, ["power"] =  716, ["lvl"] = 4},
   { ["name"] = "unit151", ["kol"] = 24, ["id"] =  9, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  750, ["power"] = 1487, ["lvl"] = 5},
   { ["name"] = "unit161", ["kol"] = 14, ["id"] = 11, ["blocked"] = 0, ["price"] = 18000, ["price1"] = 1400, ["power"] = 2520, ["lvl"] = 6},
   { ["name"] = "unit171", ["kol"] =  6, ["id"] = 13, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6003, ["lvl"] = 7},
   { ["name"] = "unit112", ["kol"] =338, ["id"] =  2, ["blocked"] = 0, ["price"] =  8750, ["price1"] =   30, ["power"] =   72, ["lvl"] = 1},
   { ["name"] = "unit122", ["kol"] =144, ["id"] =  4, ["blocked"] = 0, ["price"] = 11700, ["price1"] =  100, ["power"] =  199, ["lvl"] = 2},
   { ["name"] = "unit132", ["kol"] =100, ["id"] =  6, ["blocked"] = 0, ["price"] =  8500, ["price1"] =  140, ["power"] =  287, ["lvl"] = 3},
   { ["name"] = "unit142", ["kol"] = 45, ["id"] =  8, ["blocked"] = 0, ["price"] = 11000, ["price1"] =  400, ["power"] =  716, ["lvl"] = 4},
   { ["name"] = "unit152", ["kol"] = 24, ["id"] = 10, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  750, ["power"] = 1487, ["lvl"] = 5},
   { ["name"] = "unit162", ["kol"] = 14, ["id"] = 12, ["blocked"] = 0, ["price"] = 18000, ["price1"] = 1400, ["power"] = 2520, ["lvl"] = 6},
   { ["name"] = "unit172", ["kol"] =  6, ["id"] = 14, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6003, ["lvl"] = 7},
   { ["name"] = "unit113", ["kol"] =338, ["id"] =106, ["blocked"] = 0, ["price"] =  8750, ["price1"] =   30, ["power"] =   72, ["lvl"] = 1},
   { ["name"] = "unit123", ["kol"] =144, ["id"] =107, ["blocked"] = 0, ["price"] = 11700, ["price1"] =  100, ["power"] =  199, ["lvl"] = 2},
   { ["name"] = "unit133", ["kol"] =100, ["id"] =108, ["blocked"] = 0, ["price"] =  8500, ["price1"] =  140, ["power"] =  287, ["lvl"] = 3},
   { ["name"] = "unit143", ["kol"] = 45, ["id"] =109, ["blocked"] = 0, ["price"] = 11000, ["price1"] =  400, ["power"] =  716, ["lvl"] = 4},
   { ["name"] = "unit153", ["kol"] = 24, ["id"] =110, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  750, ["power"] = 1487, ["lvl"] = 5},
   { ["name"] = "unit163", ["kol"] = 14, ["id"] =111, ["blocked"] = 0, ["price"] = 18000, ["price1"] = 1400, ["power"] = 2520, ["lvl"] = 6},
   { ["name"] = "unit173", ["kol"] =  6, ["id"] =112, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6003, ["lvl"] = 7}
};

array_units[2] = {
   { ["name"] = "unit211", ["kol"] =224, ["id"] = 15, ["blocked"] = 0, ["price"] = 10800, ["price1"] =   80, ["power"] =  124, ["lvl"] = 1},
   { ["name"] = "unit221", ["kol"] =192, ["id"] = 17, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   85, ["power"] =  149, ["lvl"] = 2},
   { ["name"] = "unit231", ["kol"] = 80, ["id"] = 19, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  170, ["power"] =  338, ["lvl"] = 3},
   { ["name"] = "unit241", ["kol"] = 45, ["id"] = 21, ["blocked"] = 0, ["price"] = 10600, ["price1"] =  400, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit251", ["kol"] = 27, ["id"] = 23, ["blocked"] = 0, ["price"] = 13050, ["price1"] =  800, ["power"] = 1415, ["lvl"] = 5},
   { ["name"] = "unit261", ["kol"] = 14, ["id"] = 25, ["blocked"] = 0, ["price"] = 21600, ["price1"] = 1500, ["power"] = 2360, ["lvl"] = 6},
   { ["name"] = "unit271", ["kol"] =  6, ["id"] = 27, ["blocked"] = 0, ["price"] = 13328, ["price1"] = 3100, ["power"] = 5850, ["lvl"] = 7},
   { ["name"] = "unit212", ["kol"] =224, ["id"] = 16, ["blocked"] = 0, ["price"] = 10800, ["price1"] =   80, ["power"] =  124, ["lvl"] = 1},
   { ["name"] = "unit222", ["kol"] =192, ["id"] = 18, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   85, ["power"] =  149, ["lvl"] = 2},
   { ["name"] = "unit232", ["kol"] = 80, ["id"] = 20, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  170, ["power"] =  338, ["lvl"] = 3},
   { ["name"] = "unit242", ["kol"] = 45, ["id"] = 22, ["blocked"] = 0, ["price"] = 10600, ["price1"] =  400, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit252", ["kol"] = 27, ["id"] = 24, ["blocked"] = 0, ["price"] = 13050, ["price1"] =  800, ["power"] = 1415, ["lvl"] = 5},
   { ["name"] = "unit262", ["kol"] = 14, ["id"] = 26, ["blocked"] = 0, ["price"] = 21600, ["price1"] = 1500, ["power"] = 2360, ["lvl"] = 6},
   { ["name"] = "unit272", ["kol"] =  6, ["id"] = 28, ["blocked"] = 0, ["price"] = 13328, ["price1"] = 3100, ["power"] = 5850, ["lvl"] = 7},
   { ["name"] = "unit213", ["kol"] =224, ["id"] =131, ["blocked"] = 0, ["price"] = 10800, ["price1"] =   80, ["power"] =  124, ["lvl"] = 1},
   { ["name"] = "unit223", ["kol"] =192, ["id"] =132, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   85, ["power"] =  149, ["lvl"] = 2},
   { ["name"] = "unit233", ["kol"] = 80, ["id"] =133, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  170, ["power"] =  338, ["lvl"] = 3},
   { ["name"] = "unit243", ["kol"] = 45, ["id"] =134, ["blocked"] = 0, ["price"] = 10600, ["price1"] =  400, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit253", ["kol"] = 27, ["id"] =135, ["blocked"] = 0, ["price"] = 13050, ["price1"] =  800, ["power"] = 1415, ["lvl"] = 5},
   { ["name"] = "unit263", ["kol"] = 14, ["id"] =136, ["blocked"] = 0, ["price"] = 21600, ["price1"] = 1500, ["power"] = 2360, ["lvl"] = 6},
   { ["name"] = "unit273", ["kol"] =  6, ["id"] =137, ["blocked"] = 0, ["price"] = 13328, ["price1"] = 3100, ["power"] = 5850, ["lvl"] = 7}
};

array_units[3] = {
   { ["name"] = "unit311", ["kol"] =316, ["id"] = 29, ["blocked"] = 0, ["price"] =  9720, ["price1"] =   50, ["power"] =   84, ["lvl"] = 1},
   { ["name"] = "unit321", ["kol"] =180, ["id"] = 31, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   80, ["power"] =  145, ["lvl"] = 2},
   { ["name"] = "unit331", ["kol"] = 90, ["id"] = 33, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  180, ["power"] =  327, ["lvl"] = 3},
   { ["name"] = "unit341", ["kol"] = 45, ["id"] = 35, ["blocked"] = 0, ["price"] = 10875, ["price1"] =  450, ["power"] =  739, ["lvl"] = 4},
   { ["name"] = "unit351", ["kol"] = 24, ["id"] = 37, ["blocked"] = 0, ["price"] = 13635, ["price1"] =  750, ["power"] = 1539, ["lvl"] = 5},
   { ["name"] = "unit361", ["kol"] = 14, ["id"] = 39, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1400, ["power"] = 2449, ["lvl"] = 6},
   { ["name"] = "unit371", ["kol"] =  8, ["id"] = 41, ["blocked"] = 0, ["price"] = 13000, ["price1"] = 1900, ["power"] = 3872, ["lvl"] = 7},
   { ["name"] = "unit312", ["kol"] =316, ["id"] = 30, ["blocked"] = 0, ["price"] =  9720, ["price1"] =   50, ["power"] =   84, ["lvl"] = 1},
   { ["name"] = "unit322", ["kol"] =180, ["id"] = 32, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   80, ["power"] =  145, ["lvl"] = 2},
   { ["name"] = "unit332", ["kol"] = 90, ["id"] = 34, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  180, ["power"] =  327, ["lvl"] = 3},
   { ["name"] = "unit342", ["kol"] = 45, ["id"] = 36, ["blocked"] = 0, ["price"] = 10875, ["price1"] =  450, ["power"] =  739, ["lvl"] = 4},
   { ["name"] = "unit352", ["kol"] = 24, ["id"] = 38, ["blocked"] = 0, ["price"] = 13635, ["price1"] =  750, ["power"] = 1539, ["lvl"] = 5},
   { ["name"] = "unit362", ["kol"] = 14, ["id"] = 40, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1400, ["power"] = 2449, ["lvl"] = 6},
   { ["name"] = "unit372", ["kol"] =  8, ["id"] = 42, ["blocked"] = 0, ["price"] = 13000, ["price1"] = 1900, ["power"] = 3872, ["lvl"] = 7},
   { ["name"] = "unit313", ["kol"] =316, ["id"] =152, ["blocked"] = 0, ["price"] =  9720, ["price1"] =   50, ["power"] =   84, ["lvl"] = 1},
   { ["name"] = "unit323", ["kol"] =180, ["id"] =153, ["blocked"] = 0, ["price"] = 11650, ["price1"] =   80, ["power"] =  145, ["lvl"] = 2},
   { ["name"] = "unit333", ["kol"] = 90, ["id"] =154, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  180, ["power"] =  327, ["lvl"] = 3},
   { ["name"] = "unit343", ["kol"] = 45, ["id"] =155, ["blocked"] = 0, ["price"] = 10875, ["price1"] =  450, ["power"] =  739, ["lvl"] = 4},
   { ["name"] = "unit353", ["kol"] = 24, ["id"] =156, ["blocked"] = 0, ["price"] = 13635, ["price1"] =  750, ["power"] = 1539, ["lvl"] = 5},
   { ["name"] = "unit363", ["kol"] = 14, ["id"] =157, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1400, ["power"] = 2449, ["lvl"] = 6},
   { ["name"] = "unit373", ["kol"] =  8, ["id"] =158, ["blocked"] = 0, ["price"] = 13000, ["price1"] = 1900, ["power"] = 3872, ["lvl"] = 7}
};

array_units[4] = {
   { ["name"] = "unit411", ["kol"] =164, ["id"] = 43, ["blocked"] = 0, ["price"] =  9130, ["price1"] =   70, ["power"] =  169, ["lvl"] = 1},
   { ["name"] = "unit421", ["kol"] =108, ["id"] = 45, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  140, ["power"] =  308, ["lvl"] = 2},
   { ["name"] = "unit431", ["kol"] = 70, ["id"] = 47, ["blocked"] = 0, ["price"] =  7200, ["price1"] =  250, ["power"] =  433, ["lvl"] = 3},
   { ["name"] = "unit441", ["kol"] = 36, ["id"] = 49, ["blocked"] = 0, ["price"] = 11600, ["price1"] =  380, ["power"] =  846, ["lvl"] = 4},
   { ["name"] = "unit451", ["kol"] = 24, ["id"] = 51, ["blocked"] = 0, ["price"] = 13365, ["price1"] =  950, ["power"] = 1441, ["lvl"] = 5},
   { ["name"] = "unit461", ["kol"] = 16, ["id"] = 53, ["blocked"] = 0, ["price"] = 17500, ["price1"] = 1150, ["power"] = 1993, ["lvl"] = 6},
   { ["name"] = "unit471", ["kol"] =  6, ["id"] = 55, ["blocked"] = 0, ["price"] = 11200, ["price1"] = 3600, ["power"] = 5905, ["lvl"] = 7},
   { ["name"] = "unit412", ["kol"] =164, ["id"] = 44, ["blocked"] = 0, ["price"] =  9130, ["price1"] =   70, ["power"] =  169, ["lvl"] = 1},
   { ["name"] = "unit422", ["kol"] =108, ["id"] = 46, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  140, ["power"] =  308, ["lvl"] = 2},
   { ["name"] = "unit432", ["kol"] = 70, ["id"] = 48, ["blocked"] = 0, ["price"] =  7200, ["price1"] =  250, ["power"] =  433, ["lvl"] = 3},
   { ["name"] = "unit442", ["kol"] = 36, ["id"] = 50, ["blocked"] = 0, ["price"] = 11600, ["price1"] =  380, ["power"] =  846, ["lvl"] = 4},
   { ["name"] = "unit452", ["kol"] = 24, ["id"] = 52, ["blocked"] = 0, ["price"] = 13365, ["price1"] =  950, ["power"] = 1441, ["lvl"] = 5},
   { ["name"] = "unit462", ["kol"] = 16, ["id"] = 54, ["blocked"] = 0, ["price"] = 17500, ["price1"] = 1150, ["power"] = 1993, ["lvl"] = 6},
   { ["name"] = "unit472", ["kol"] =  6, ["id"] = 56, ["blocked"] = 0, ["price"] = 11200, ["price1"] = 3600, ["power"] = 5905, ["lvl"] = 7},
   { ["name"] = "unit413", ["kol"] =164, ["id"] =145, ["blocked"] = 0, ["price"] =  9130, ["price1"] =   70, ["power"] =  169, ["lvl"] = 1},
   { ["name"] = "unit423", ["kol"] =108, ["id"] =146, ["blocked"] = 0, ["price"] = 12825, ["price1"] =  140, ["power"] =  308, ["lvl"] = 2},
   { ["name"] = "unit433", ["kol"] = 70, ["id"] =147, ["blocked"] = 0, ["price"] =  7200, ["price1"] =  250, ["power"] =  433, ["lvl"] = 3},
   { ["name"] = "unit443", ["kol"] = 36, ["id"] =148, ["blocked"] = 0, ["price"] = 11600, ["price1"] =  380, ["power"] =  846, ["lvl"] = 4},
   { ["name"] = "unit453", ["kol"] = 24, ["id"] =149, ["blocked"] = 0, ["price"] = 13365, ["price1"] =  950, ["power"] = 1441, ["lvl"] = 5},
   { ["name"] = "unit463", ["kol"] = 16, ["id"] =150, ["blocked"] = 0, ["price"] = 17500, ["price1"] = 1150, ["power"] = 1993, ["lvl"] = 6},
   { ["name"] = "unit473", ["kol"] =  6, ["id"] =151, ["blocked"] = 0, ["price"] = 11200, ["price1"] = 3600, ["power"] = 5905, ["lvl"] = 7}
};
array_units[5] = {
   { ["name"] = "unit511", ["kol"] =280, ["id"] = 57, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   55, ["power"] =  105, ["lvl"] = 1},
   { ["name"] = "unit521", ["kol"] =168, ["id"] = 59, ["blocked"] = 0, ["price"] = 12075, ["price1"] =  100, ["power"] =  172, ["lvl"] = 2},
   { ["name"] = "unit531", ["kol"] = 90, ["id"] = 61, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  150, ["power"] =  355, ["lvl"] = 3},
   { ["name"] = "unit541", ["kol"] = 45, ["id"] = 63, ["blocked"] = 0, ["price"] = 11375, ["price1"] =  380, ["power"] =  642, ["lvl"] = 4},
   { ["name"] = "unit551", ["kol"] = 30, ["id"] = 65, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  500, ["power"] = 1096, ["lvl"] = 5},
   { ["name"] = "unit561", ["kol"] = 14, ["id"] = 67, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1500, ["power"] = 2535, ["lvl"] = 6},
   { ["name"] = "unit571", ["kol"] =  6, ["id"] = 69, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6095, ["lvl"] = 7},
   { ["name"] = "unit512", ["kol"] =280, ["id"] = 58, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   55, ["power"] =  105, ["lvl"] = 1},
   { ["name"] = "unit522", ["kol"] =168, ["id"] = 60, ["blocked"] = 0, ["price"] = 12075, ["price1"] =  100, ["power"] =  172, ["lvl"] = 2},
   { ["name"] = "unit532", ["kol"] = 90, ["id"] = 62, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  150, ["power"] =  355, ["lvl"] = 3},
   { ["name"] = "unit542", ["kol"] = 45, ["id"] = 64, ["blocked"] = 0, ["price"] = 11375, ["price1"] =  380, ["power"] =  642, ["lvl"] = 4},
   { ["name"] = "unit552", ["kol"] = 30, ["id"] = 66, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  500, ["power"] = 1096, ["lvl"] = 5},
   { ["name"] = "unit562", ["kol"] = 14, ["id"] = 68, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1500, ["power"] = 2535, ["lvl"] = 5},
   { ["name"] = "unit572", ["kol"] =  6, ["id"] = 70, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6095, ["lvl"] = 5},
   { ["name"] = "unit513", ["kol"] =280, ["id"] =159, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   55, ["power"] =  105, ["lvl"] = 1},
   { ["name"] = "unit523", ["kol"] =168, ["id"] =160, ["blocked"] = 0, ["price"] = 12075, ["price1"] =  100, ["power"] =  172, ["lvl"] = 2},
   { ["name"] = "unit533", ["kol"] = 90, ["id"] =161, ["blocked"] = 0, ["price"] =  9000, ["price1"] =  150, ["power"] =  355, ["lvl"] = 3},
   { ["name"] = "unit543", ["kol"] = 45, ["id"] =162, ["blocked"] = 0, ["price"] = 11375, ["price1"] =  380, ["power"] =  642, ["lvl"] = 4},
   { ["name"] = "unit553", ["kol"] = 30, ["id"] =163, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  500, ["power"] = 1096, ["lvl"] = 5},
   { ["name"] = "unit563", ["kol"] = 14, ["id"] =164, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1500, ["power"] = 2535, ["lvl"] = 6},
   { ["name"] = "unit573", ["kol"] =  6, ["id"] =165, ["blocked"] = 0, ["price"] = 16800, ["price1"] = 3500, ["power"] = 6095, ["lvl"] = 7}
};

array_units[6] = {
   { ["name"] = "unit611", ["kol"] = 98, ["id"] = 71, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  110, ["power"] =  290, ["lvl"] = 1},
   { ["name"] = "unit621", ["kol"] = 78, ["id"] = 73, ["blocked"] = 0, ["price"] = 12750, ["price1"] =  190, ["power"] =  477, ["lvl"] = 2},
   { ["name"] = "unit631", ["kol"] = 66, ["id"] = 75, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  200, ["power"] =  474, ["lvl"] = 3},
   { ["name"] = "unit641", ["kol"] = 36, ["id"] = 77, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  450, ["power"] =  812, ["lvl"] = 4},
   { ["name"] = "unit651", ["kol"] = 24, ["id"] = 79, ["blocked"] = 0, ["price"] = 11475, ["price1"] =  850, ["power"] = 1324, ["lvl"] = 5},
   { ["name"] = "unit661", ["kol"] = 14, ["id"] = 81, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1200, ["power"] = 2537, ["lvl"] = 6},
   { ["name"] = "unit671", ["kol"] =  6, ["id"] = 83, ["blocked"] = 0, ["price"] = 18400, ["price1"] = 3800, ["power"] = 6389, ["lvl"] = 7},
   { ["name"] = "unit612", ["kol"] = 98, ["id"] = 72, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  110, ["power"] =  290, ["lvl"] = 1},
   { ["name"] = "unit622", ["kol"] = 78, ["id"] = 74, ["blocked"] = 0, ["price"] = 12750, ["price1"] =  190, ["power"] =  477, ["lvl"] = 2},
   { ["name"] = "unit632", ["kol"] = 66, ["id"] = 76, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  200, ["power"] =  474, ["lvl"] = 3},
   { ["name"] = "unit642", ["kol"] = 36, ["id"] = 78, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  450, ["power"] =  812, ["lvl"] = 4},
   { ["name"] = "unit652", ["kol"] = 24, ["id"] = 80, ["blocked"] = 0, ["price"] = 11475, ["price1"] =  850, ["power"] = 1324, ["lvl"] = 5},
   { ["name"] = "unit662", ["kol"] = 14, ["id"] = 82, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1200, ["power"] = 2537, ["lvl"] = 6},
   { ["name"] = "unit672", ["kol"] =  6, ["id"] = 84, ["blocked"] = 0, ["price"] = 18400, ["price1"] = 3800, ["power"] = 6389, ["lvl"] = 7},
   { ["name"] = "unit613", ["kol"] = 98, ["id"] =138, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  110, ["power"] =  290, ["lvl"] = 1},
   { ["name"] = "unit623", ["kol"] = 78, ["id"] =139, ["blocked"] = 0, ["price"] = 12750, ["price1"] =  190, ["power"] =  477, ["lvl"] = 2},
   { ["name"] = "unit633", ["kol"] = 66, ["id"] =140, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  200, ["power"] =  474, ["lvl"] = 3},
   { ["name"] = "unit643", ["kol"] = 36, ["id"] =141, ["blocked"] = 0, ["price"] = 10500, ["price1"] =  450, ["power"] =  812, ["lvl"] = 4},
   { ["name"] = "unit653", ["kol"] = 24, ["id"] =142, ["blocked"] = 0, ["price"] = 11475, ["price1"] =  850, ["power"] = 1324, ["lvl"] = 5},
   { ["name"] = "unit663", ["kol"] = 14, ["id"] =143, ["blocked"] = 0, ["price"] = 21150, ["price1"] = 1200, ["power"] = 2537, ["lvl"] = 6},
   { ["name"] = "unit673", ["kol"] =  6, ["id"] =144, ["blocked"] = 0, ["price"] = 18400, ["price1"] = 3800, ["power"] = 6389, ["lvl"] = 7}
};

array_units[7] = {
   { ["name"] = "unit711", ["kol"] =252, ["id"] = 92, ["blocked"] = 0, ["price"] =  9600, ["price1"] =   65, ["power"] =  115, ["lvl"] = 1},
   { ["name"] = "unit721", ["kol"] =168, ["id"] = 94, ["blocked"] = 0, ["price"] = 11000, ["price1"] =   90, ["power"] =  171, ["lvl"] = 2},
   { ["name"] = "unit731", ["kol"] = 70, ["id"] = 96, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  250, ["power"] =  419, ["lvl"] = 3},
   { ["name"] = "unit741", ["kol"] = 66, ["id"] = 98, ["blocked"] = 0, ["price"] = 10150, ["price1"] =  230, ["power"] =  434, ["lvl"] = 4},
   { ["name"] = "unit751", ["kol"] = 27, ["id"] =100, ["blocked"] = 0, ["price"] = 10650, ["price1"] =  650, ["power"] = 1308, ["lvl"] = 5},
   { ["name"] = "unit761", ["kol"] = 14, ["id"] =102, ["blocked"] = 0, ["price"] = 14000, ["price1"] = 1600, ["power"] = 2437, ["lvl"] = 6},
   { ["name"] = "unit771", ["kol"] =  6, ["id"] =104, ["blocked"] = 0, ["price"] = 12000, ["price1"] = 3400, ["power"] = 6070, ["lvl"] = 7},
   { ["name"] = "unit712", ["kol"] =252, ["id"] = 93, ["blocked"] = 0, ["price"] =  9600, ["price1"] =   65, ["power"] =  115, ["lvl"] = 1},
   { ["name"] = "unit722", ["kol"] =168, ["id"] = 95, ["blocked"] = 0, ["price"] = 11000, ["price1"] =   90, ["power"] =  171, ["lvl"] = 2},
   { ["name"] = "unit732", ["kol"] = 70, ["id"] = 97, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  250, ["power"] =  419, ["lvl"] = 3},
   { ["name"] = "unit742", ["kol"] = 66, ["id"] = 99, ["blocked"] = 0, ["price"] = 10150, ["price1"] =  230, ["power"] =  434, ["lvl"] = 4},
   { ["name"] = "unit752", ["kol"] = 27, ["id"] =101, ["blocked"] = 0, ["price"] = 10650, ["price1"] =  650, ["power"] = 1308, ["lvl"] = 5},
   { ["name"] = "unit762", ["kol"] = 14, ["id"] =103, ["blocked"] = 0, ["price"] = 14000, ["price1"] = 1600, ["power"] = 2437, ["lvl"] = 6},
   { ["name"] = "unit772", ["kol"] =  6, ["id"] =105, ["blocked"] = 0, ["price"] = 12000, ["price1"] = 3400, ["power"] = 6070, ["lvl"] = 7},
   { ["name"] = "unit713", ["kol"] =252, ["id"] =166, ["blocked"] = 0, ["price"] =  9600, ["price1"] =   65, ["power"] =  115, ["lvl"] = 1},
   { ["name"] = "unit723", ["kol"] =168, ["id"] =167, ["blocked"] = 0, ["price"] = 11000, ["price1"] =   90, ["power"] =  171, ["lvl"] = 2},
   { ["name"] = "unit733", ["kol"] = 70, ["id"] =168, ["blocked"] = 0, ["price"] =  9100, ["price1"] =  250, ["power"] =  419, ["lvl"] = 3},
   { ["name"] = "unit743", ["kol"] = 66, ["id"] =169, ["blocked"] = 0, ["price"] = 10150, ["price1"] =  230, ["power"] =  434, ["lvl"] = 4},
   { ["name"] = "unit753", ["kol"] = 27, ["id"] =170, ["blocked"] = 0, ["price"] = 10650, ["price1"] =  650, ["power"] = 1308, ["lvl"] = 5},
   { ["name"] = "unit763", ["kol"] = 14, ["id"] =171, ["blocked"] = 0, ["price"] = 14000, ["price1"] = 1600, ["power"] = 2437, ["lvl"] = 6},
   { ["name"] = "unit773", ["kol"] =  6, ["id"] =172, ["blocked"] = 0, ["price"] = 12000, ["price1"] = 3400, ["power"] = 6070, ["lvl"] = 7}
};

array_units[8] = {
   { ["name"] = "unit811", ["kol"] =386, ["id"] =117, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   35, ["power"] =   66, ["lvl"] = 1},
   { ["name"] = "unit821", ["kol"] =168, ["id"] =119, ["blocked"] = 0, ["price"] = 12000, ["price1"] =  110, ["power"] =  174, ["lvl"] = 2},
   { ["name"] = "unit831", ["kol"] =110, ["id"] =121, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  140, ["power"] =  254, ["lvl"] = 3},
   { ["name"] = "unit841", ["kol"] = 45, ["id"] =123, ["blocked"] = 0, ["price"] = 10575, ["price1"] =  420, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit851", ["kol"] = 40, ["id"] =125, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  550, ["power"] =  895, ["lvl"] = 5},
   { ["name"] = "unit861", ["kol"] = 14, ["id"] =127, ["blocked"] = 0, ["price"] = 17775, ["price1"] = 1200, ["power"] = 2571, ["lvl"] = 6},
   { ["name"] = "unit871", ["kol"] =  6, ["id"] =129, ["blocked"] = 0, ["price"] = 14100, ["price1"] = 3600, ["power"] = 5937, ["lvl"] = 7},
   { ["name"] = "unit812", ["kol"] =386, ["id"] =118, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   35, ["power"] =   66, ["lvl"] = 1},
   { ["name"] = "unit822", ["kol"] =168, ["id"] =120, ["blocked"] = 0, ["price"] = 12000, ["price1"] =  110, ["power"] =  174, ["lvl"] = 2},
   { ["name"] = "unit832", ["kol"] =110, ["id"] =122, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  140, ["power"] =  254, ["lvl"] = 3},
   { ["name"] = "unit842", ["kol"] = 45, ["id"] =124, ["blocked"] = 0, ["price"] = 10575, ["price1"] =  420, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit852", ["kol"] = 40, ["id"] =126, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  550, ["power"] =  895, ["lvl"] = 5},
   { ["name"] = "unit862", ["kol"] = 14, ["id"] =128, ["blocked"] = 0, ["price"] = 17775, ["price1"] = 1200, ["power"] = 2571, ["lvl"] = 6},
   { ["name"] = "unit872", ["kol"] =  6, ["id"] =130, ["blocked"] = 0, ["price"] = 14100, ["price1"] = 3600, ["power"] = 5937, ["lvl"] = 7},
   { ["name"] = "unit813", ["kol"] =386, ["id"] =173, ["blocked"] = 0, ["price"] = 10500, ["price1"] =   35, ["power"] =   66, ["lvl"] = 1},
   { ["name"] = "unit823", ["kol"] =168, ["id"] =174, ["blocked"] = 0, ["price"] = 12000, ["price1"] =  110, ["power"] =  174, ["lvl"] = 2},
   { ["name"] = "unit833", ["kol"] =110, ["id"] =175, ["blocked"] = 0, ["price"] =  8800, ["price1"] =  140, ["power"] =  254, ["lvl"] = 3},
   { ["name"] = "unit843", ["kol"] = 45, ["id"] =176, ["blocked"] = 0, ["price"] = 10575, ["price1"] =  420, ["power"] =  680, ["lvl"] = 4},
   { ["name"] = "unit853", ["kol"] = 40, ["id"] =177, ["blocked"] = 0, ["price"] = 12375, ["price1"] =  550, ["power"] =  895, ["lvl"] = 5},
   { ["name"] = "unit863", ["kol"] = 14, ["id"] =178, ["blocked"] = 0, ["price"] = 17775, ["price1"] = 1200, ["power"] = 2571, ["lvl"] = 6},
   { ["name"] = "unit873", ["kol"] =  6, ["id"] =179, ["blocked"] = 0, ["price"] = 14100, ["price1"] = 3600, ["power"] = 5937, ["lvl"] = 7}
};

------------------ HEROES ------------------------
array_heroes={};
array_heroes[0] = {
	 { ["name"] = "Orrin",       ["name2"] = "Orrin2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  35, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroDugal.txt",      ["p1"] = "hero_1_1_1", ["p2"] = "hero_1_1_2", ["p3"] = "hero_1_1_3", ["p4"] = "hero_1_1_4", ["p5"] = "hero_1_1_5", ["p6"] = "hero_1_1_6", ["p7"] = "hero_1_1_7", ["p8"] = "hero_1_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt" },
	 { ["name"] = "Sarge",       ["name2"] = "Sarge2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  55, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroAksel.txt",      ["p1"] = "hero_2_1_1", ["p2"] = "hero_2_1_2", ["p3"] = "hero_2_1_3", ["p4"] = "hero_2_1_4", ["p5"] = "hero_2_1_5", ["p6"] = "hero_2_1_6", ["p7"] = "hero_2_1_7", ["p8"] = "hero_2_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Jouster/Description.txt"},
	 { ["name"] = "Mardigo",     ["name2"] = "Mardigo2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroLaslo.txt",      ["p1"] = "hero_3_1_1", ["p2"] = "hero_3_1_2", ["p3"] = "hero_3_1_3", ["p4"] = "hero_3_1_4", ["p5"] = "hero_3_1_5", ["p6"] = "hero_3_1_6", ["p7"] = "hero_3_1_7", ["p8"] = "hero_3_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Infantry_Commander/Description.txt"},
	 { ["name"] = "Brem",        ["name2"] = "Brem2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  13, ["skill2"] =  13, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroRutger.txt",     ["p1"] = "hero_4_1_1", ["p2"] = "hero_4_1_2", ["p3"] = "hero_4_1_3", ["p4"] = "hero_4_1_4", ["p5"] = "hero_4_1_5", ["p6"] = "hero_4_1_6", ["p7"] = "hero_4_1_7", ["p8"] = "hero_4_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Wanderer/Description.txt"},
	 { ["name"] = "Maeve",       ["name2"] = "Maeve2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  51, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroMiv.txt",        ["p1"] = "hero_5_1_1", ["p2"] = "hero_5_1_2", ["p3"] = "hero_5_1_3", ["p4"] = "hero_5_1_4", ["p5"] = "hero_5_1_5", ["p6"] = "hero_5_1_6", ["p7"] = "hero_5_1_7", ["p8"] = "hero_5_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Expediter/Description.txt"},
	 { ["name"] = "Ving",        ["name2"] = "Ving2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  31, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroAiris.txt",      ["p1"] = "hero_6_1_1", ["p2"] = "hero_6_1_2", ["p3"] = "hero_6_1_3", ["p4"] = "hero_6_1_4", ["p5"] = "hero_6_1_5", ["p6"] = "hero_6_1_6", ["p7"] = "hero_6_1_7", ["p8"] = "hero_6_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Griffon_Commander/Description.txt"},
	 { ["name"] = "Nathaniel",   ["name2"] = "Nathaniel2",   ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  28, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroEllaina.txt",    ["p1"] = "hero_7_1_1", ["p2"] = "hero_7_1_2", ["p3"] = "hero_7_1_3", ["p4"] = "hero_7_1_4", ["p5"] = "hero_7_1_5", ["p6"] = "hero_7_1_6", ["p7"] = "hero_7_1_7", ["p8"] = "hero_7_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Squire/Description.txt"},
	 { ["name"] = "Christian",   ["name2"] = "Christian2",   ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] =  23, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroVittorio.txt",   ["p1"] = "hero_8_1_1", ["p2"] = "hero_8_1_2", ["p3"] = "hero_8_1_3", ["p4"] = "hero_8_1_4", ["p5"] = "hero_8_1_5", ["p6"] = "hero_8_1_6", ["p7"] = "hero_8_1_7", ["p8"] = "hero_8_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Artilleryman/Description.txt"},
	 { ["name"] = "Godric",      ["name2"] = "Godric2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  56, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGodric.txt",     ["p1"] = "hero_9_1_1", ["p2"] = "hero_9_1_2", ["p3"] = "hero_9_1_3", ["p4"] = "hero_9_1_4", ["p5"] = "hero_9_1_5", ["p6"] = "hero_9_1_6", ["p7"] = "hero_9_1_7", ["p8"] = "hero_9_1_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/White_Knight/Description.txt"},
   {["name"]="RedHeavenHero03",["name2"]="RedHeavenHero032",["blocked"] = 0,["taverna"] = 1, ["skill1"] =   8, ["skill2"] =  10, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroValeria.txt",    ["p1"] = "hero_13_1_1",["p2"] = "hero_13_1_2",["p3"] = "hero_13_1_3",["p4"] = "hero_13_1_4",["p5"] = "hero_13_1_5",["p6"] = "hero_13_1_6",["p7"] = "hero_13_1_7",["p8"] = "hero_13_1_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/SpecValeria/Description.txt"},
	 { ["name"] = "Isabell_A1",  ["name2"] = "Isabell_A12",  ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  11, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIsabel.txt",     ["p1"] = "hero_11_1_1",["p2"] = "hero_11_1_2",["p3"] = "hero_11_1_3",["p4"] = "hero_11_1_4",["p5"] = "hero_11_1_5",["p6"] = "hero_11_1_6",["p7"] = "hero_11_1_7",["p8"] = "hero_11_1_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt"},
	 { ["name"] = "Duncan",      ["name2"] = "Duncan2",      ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  34, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroDuncan.txt",     ["p1"] = "hero_12_1_1",["p2"] = "hero_12_1_2",["p3"] = "hero_12_1_3",["p4"] = "hero_12_1_4",["p5"] = "hero_12_1_5",["p6"] = "hero_12_1_6",["p7"] = "hero_12_1_7",["p8"] = "hero_12_1_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt"},
   { ["name"] = "Nicolai",     ["name2"] = "Nicolai2",     ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =  13, ["skill2"] =  13, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroNicolai.txt",    ["p1"] = "hero_10_1_1",["p2"] = "hero_10_1_2",["p3"] = "hero_10_1_3",["p4"] = "hero_10_1_4",["p5"] = "hero_10_1_5",["p6"] = "hero_10_1_6",["p7"] = "hero_10_1_7",["p8"] = "hero_10_1_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Haven/Archer_Commander/Description.txt"}
};

array_heroes[1] = {
	 { ["name"] = "Grok",        ["name2"] = "Grok2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   1, ["skill2"] =  19, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroGrok.txt",       ["p1"] = "hero_1_2_1", ["p2"] = "hero_1_2_2", ["p3"] = "hero_1_2_3", ["p4"] = "hero_1_2_4", ["p5"] = "hero_1_2_5", ["p6"] = "hero_1_2_6", ["p7"] = "hero_1_2_7", ["p8"] = "hero_1_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Beater/Description.txt" },
	 { ["name"] = "Oddrema",     ["name2"] = "Oddrema2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   8, ["skill2"] =  41, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroDgezebet.txt",   ["p1"] = "hero_2_2_1", ["p2"] = "hero_2_2_2", ["p3"] = "hero_2_2_3", ["p4"] = "hero_2_2_4", ["p5"] = "hero_2_2_5", ["p6"] = "hero_2_2_6", ["p7"] = "hero_2_2_7", ["p8"] = "hero_2_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Temptress/Description.txt" },
	 { ["name"] = "Marder",      ["name2"] = "Marder2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  37, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroMarbas.txt",     ["p1"] = "hero_3_2_1", ["p2"] = "hero_3_2_2", ["p3"] = "hero_3_2_3", ["p4"] = "hero_3_2_4", ["p5"] = "hero_3_2_5", ["p6"] = "hero_3_2_6", ["p7"] = "hero_3_2_7", ["p8"] = "hero_3_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Impregnable/Description.txt" },
	 { ["name"] = "Jazaz",       ["name2"] = "Jazaz2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  34, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNibros.txt",     ["p1"] = "hero_4_2_1", ["p2"] = "hero_4_2_2", ["p3"] = "hero_4_2_3", ["p4"] = "hero_4_2_4", ["p5"] = "hero_4_2_5", ["p6"] = "hero_4_2_6", ["p7"] = "hero_4_2_7", ["p8"] = "hero_4_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Flagbearer_of_Darkness/Description.txt" },
	 { ["name"] = "Efion",       ["name2"] = "Efion2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  10, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroAlastor.txt",    ["p1"] = "hero_5_2_1", ["p2"] = "hero_5_2_2", ["p3"] = "hero_5_2_3", ["p4"] = "hero_5_2_4", ["p5"] = "hero_5_2_5", ["p6"] = "hero_5_2_6", ["p7"] = "hero_5_2_7", ["p8"] = "hero_5_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Hypnotist/Description.txt" },
	 { ["name"] = "Deleb",       ["name2"] = "Deleb2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] =  23, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroDeleb.txt",      ["p1"] = "hero_6_2_1", ["p2"] = "hero_6_2_2", ["p3"] = "hero_6_2_3", ["p4"] = "hero_6_2_4", ["p5"] = "hero_6_2_5", ["p6"] = "hero_6_2_6", ["p7"] = "hero_6_2_7", ["p8"] = "hero_6_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Bombardier/Description.txt" },
	 { ["name"] = "Calid",       ["name2"] = "Calid2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   9, ["skill2"] =  59, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGrol.txt",       ["p1"] = "hero_7_2_1", ["p2"] = "hero_7_2_2", ["p3"] = "hero_7_2_3", ["p4"] = "hero_7_2_4", ["p5"] = "hero_7_2_5", ["p6"] = "hero_7_2_6", ["p7"] = "hero_7_2_7", ["p8"] = "hero_7_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Breeder/Description.txt" },
	 { ["name"] = "Nymus",       ["name2"] = "Nymus2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  31, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNimus.txt",      ["p1"] = "hero_8_2_1", ["p2"] = "hero_8_2_2", ["p3"] = "hero_8_2_3", ["p4"] = "hero_8_2_4", ["p5"] = "hero_8_2_5", ["p6"] = "hero_8_2_6", ["p7"] = "hero_8_2_7", ["p8"] = "hero_8_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Gate_Keeper/Description.txt" },
	 { ["name"] = "Orlando",     ["name2"] = "Orlando2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  60, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroOrlando.txt",    ["p1"] = "hero_9_2_1", ["p2"] = "hero_9_2_2", ["p3"] = "hero_9_2_3", ["p4"] = "hero_9_2_4", ["p5"] = "hero_9_2_5", ["p6"] = "hero_9_2_6", ["p7"] = "hero_9_2_7", ["p8"] = "hero_9_2_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/SpecOrlando/Description.txt" },
	 { ["name"] = "Agrael",      ["name2"] = "Agrael2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  36, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroAgrail.txt",     ["p1"] = "hero_10_2_1",["p2"] = "hero_10_2_2",["p3"] = "hero_10_2_3",["p4"] = "hero_10_2_4",["p5"] = "hero_10_2_5",["p6"] = "hero_10_2_6",["p7"] = "hero_10_2_7",["p8"] = "hero_10_2_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/SpecAgrael/Description.txt" },
	 { ["name"] = "Kha-Beleth",  ["name2"] = "Kha-Beleth2",  ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  59, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVlastelin.txt",  ["p1"] = "hero_11_2_1",["p2"] = "hero_11_2_2",["p3"] = "hero_11_2_3",["p4"] = "hero_11_2_4",["p5"] = "hero_11_2_5",["p6"] = "hero_11_2_6",["p7"] = "hero_11_2_7",["p8"] = "hero_11_2_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Inferno/Beater/Description.txt" }
};

array_heroes[2] = {
	 { ["name"] = "Nemor",       ["name2"] = "Nemor2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  63, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroDeidra.txt",     ["p1"] = "hero_1_3_1", ["p2"] = "hero_1_3_2", ["p3"] = "hero_1_3_3", ["p4"] = "hero_1_3_4", ["p5"] = "hero_1_3_5", ["p6"] = "hero_1_3_6", ["p7"] = "hero_1_3_7", ["p8"] = "hero_1_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Dark_Emissary/Description.txt" },
	 { ["name"] = "Tamika",      ["name2"] = "Tamika2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   8, ["skill2"] =  42, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroLukrecia.txt",   ["p1"] = "hero_2_3_1", ["p2"] = "hero_2_3_2", ["p3"] = "hero_2_3_3", ["p4"] = "hero_2_3_4", ["p5"] = "hero_2_3_5", ["p6"] = "hero_2_3_6", ["p7"] = "hero_2_3_7", ["p8"] = "hero_2_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Vamipre_Princess/Description.txt" },
	 { ["name"] = "Muscip",      ["name2"] = "Muscip2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] =  10, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNaadir.txt",     ["p1"] = "hero_3_3_1", ["p2"] = "hero_3_3_2", ["p3"] = "hero_3_3_3", ["p4"] = "hero_3_3_4", ["p5"] = "hero_3_3_5", ["p6"] = "hero_3_3_6", ["p7"] = "hero_3_3_7", ["p8"] = "hero_3_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Soulhunter/Description.txt" },
	 { ["name"] = "Aberrar",     ["name2"] = "Aberrar2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  25, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroZoltan.txt",     ["p1"] = "hero_4_3_1", ["p2"] = "hero_4_3_2", ["p3"] = "hero_4_3_3", ["p4"] = "hero_4_3_4", ["p5"] = "hero_4_3_5", ["p6"] = "hero_4_3_6", ["p7"] = "hero_4_3_7", ["p8"] = "hero_4_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Mind_Cleaner/Description.txt" },
	 { ["name"] = "Straker",     ["name2"] = "Straker2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroOrson.txt",      ["p1"] = "hero_5_3_1", ["p2"] = "hero_5_3_2", ["p3"] = "hero_5_3_3", ["p4"] = "hero_5_3_4", ["p5"] = "hero_5_3_5", ["p6"] = "hero_5_3_6", ["p7"] = "hero_5_3_7", ["p8"] = "hero_5_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Zombie_Leader/Description.txt" },
	 { ["name"] = "Effig",       ["name2"] = "Effig2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  46, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroRavenna.txt",    ["p1"] = "hero_6_3_1", ["p2"] = "hero_6_3_2", ["p3"] = "hero_6_3_3", ["p4"] = "hero_6_3_4", ["p5"] = "hero_6_3_5", ["p6"] = "hero_6_3_6", ["p7"] = "hero_6_3_7", ["p8"] = "hero_6_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Maledictor/Description.txt" },
	 { ["name"] = "Pelt",        ["name2"] = "Pelt2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] =  54, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVlad.txt",       ["p1"] = "hero_7_3_1", ["p2"] = "hero_7_3_2", ["p3"] = "hero_7_3_3", ["p4"] = "hero_7_3_4", ["p5"] = "hero_7_3_5", ["p6"] = "hero_7_3_6", ["p7"] = "hero_7_3_7", ["p8"] = "hero_7_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Reanimator/Description.txt" },
	 { ["name"] = "Gles",        ["name2"] = "Gles2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] =  22, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroKaspar.txt",     ["p1"] = "hero_8_3_1", ["p2"] = "hero_8_3_2", ["p3"] = "hero_8_3_3", ["p4"] = "hero_8_3_4", ["p5"] = "hero_8_3_5", ["p6"] = "hero_8_3_6", ["p7"] = "hero_8_3_7", ["p8"] = "hero_8_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Empiric/Description.txt" },
	 { ["name"] = "Arantir",     ["name2"] = "Arantir2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] = 108, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroArantir.txt",    ["p1"] = "hero_9_3_1", ["p2"] = "hero_9_3_2", ["p3"] = "hero_9_3_3", ["p4"] = "hero_9_3_4", ["p5"] = "hero_9_3_5", ["p6"] = "hero_9_3_6", ["p7"] = "hero_9_3_7", ["p8"] = "hero_9_3_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/AvatarOfDeath/Description.txt" },
	 { ["name"] = "OrnellaNecro",["name2"] = "OrnellaNecro2",["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  62, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroOrnella.txt",    ["p1"] = "hero_10_3_1",["p2"] = "hero_10_3_2",["p3"] = "hero_10_3_3",["p4"] = "hero_10_3_4",["p5"] = "hero_10_3_5",["p6"] = "hero_10_3_6",["p7"] = "hero_10_3_7",["p8"] = "hero_10_3_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/SpecOrnella/Description.txt" },
   { ["name"] = "Berein",      ["name2"] = "Berein2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  15, ["skill2"] =  15, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroMarkel.txt",     ["p1"] = "hero_11_3_1",["p2"] = "hero_11_3_2",["p3"] = "hero_11_3_3",["p4"] = "hero_11_3_4",["p5"] = "hero_11_3_5",["p6"] = "hero_11_3_6",["p7"] = "hero_11_3_7",["p8"] = "hero_11_3_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/Heir_of_Undeath/Berein.txt" },
   { ["name"] = "Nikolas",     ["name2"] = "Nikolas2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =   3, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNikolas.txt",    ["p1"] = "hero_12_3_1",["p2"] = "hero_12_3_2",["p3"] = "hero_12_3_3",["p4"] = "hero_12_3_4",["p5"] = "hero_12_3_5",["p6"] = "hero_12_3_6",["p7"] = "hero_12_3_7",["p8"] = "hero_12_3_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Necropolis/SpecNikolas/Description.txt" }
};

array_heroes[3] = {
	 { ["name"] = "Metlirn",     ["name2"] = "Metlirn2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  16, ["skill2"] =  16, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroAnven.txt",      ["p1"] = "hero_1_4_1", ["p2"] = "hero_1_4_2", ["p3"] = "hero_1_4_3", ["p4"] = "hero_1_4_4", ["p5"] = "hero_1_4_5", ["p6"] = "hero_1_4_6", ["p7"] = "hero_1_4_7", ["p8"] = "hero_1_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Forest_Guardian/Description.txt" },
	 { ["name"] = "Gillion",     ["name2"] = "Gillion2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGilraen.txt",    ["p1"] = "hero_2_4_1", ["p2"] = "hero_2_4_2", ["p3"] = "hero_2_4_3", ["p4"] = "hero_2_4_4", ["p5"] = "hero_2_4_5", ["p6"] = "hero_2_4_6", ["p7"] = "hero_2_4_7", ["p8"] = "hero_2_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Blade_Master/Description.txt" },
	 { ["name"] = "Nadaur",      ["name2"] = "Nadaur2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  28, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroTalanar.txt",    ["p1"] = "hero_3_4_1", ["p2"] = "hero_3_4_2", ["p3"] = "hero_3_4_3", ["p4"] = "hero_3_4_4", ["p5"] = "hero_3_4_5", ["p6"] = "hero_3_4_6", ["p7"] = "hero_3_4_7", ["p8"] = "hero_3_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Elven_Fury/Description.txt" },
	 { ["name"] = "Diraya",      ["name2"] = "Diraya2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] =  53, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroDirael.txt",     ["p1"] = "hero_4_4_1", ["p2"] = "hero_4_4_2", ["p3"] = "hero_4_4_3", ["p4"] = "hero_4_4_4", ["p5"] = "hero_4_4_5", ["p6"] = "hero_4_4_6", ["p7"] = "hero_4_4_7", ["p8"] = "hero_4_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Call_of_the_Wasp/Description.txt" },
	 { ["name"] = "Ossir",       ["name2"] = "Ossir2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  31, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroOssir.txt",      ["p1"] = "hero_5_4_1", ["p2"] = "hero_5_4_2", ["p3"] = "hero_5_4_3", ["p4"] = "hero_5_4_4", ["p5"] = "hero_5_4_5", ["p6"] = "hero_5_4_6", ["p7"] = "hero_5_4_7", ["p8"] = "hero_5_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Hunter/Description.txt" },
	 { ["name"] = "Itil",        ["name2"] = "Itil2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  49, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIlfina.txt",     ["p1"] = "hero_6_4_1", ["p2"] = "hero_6_4_2", ["p3"] = "hero_6_4_3", ["p4"] = "hero_6_4_4", ["p5"] = "hero_6_4_5", ["p6"] = "hero_6_4_6", ["p7"] = "hero_6_4_7", ["p8"] = "hero_6_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Unicorn_Trainer/Description.txt" },
	 { ["name"] = "Elleshar",    ["name2"] = "Elleshar2",    ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  25, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVinrael.txt",    ["p1"] = "hero_7_4_1", ["p2"] = "hero_7_4_2", ["p3"] = "hero_7_4_3", ["p4"] = "hero_7_4_4", ["p5"] = "hero_7_4_5", ["p6"] = "hero_7_4_6", ["p7"] = "hero_7_4_7", ["p8"] = "hero_7_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Talented_Warrior/Description.txt" },
	 { ["name"] = "Linaas",      ["name2"] = "Linaas2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  34, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVingael.txt",    ["p1"] = "hero_8_4_1", ["p2"] = "hero_8_4_2", ["p3"] = "hero_8_4_3", ["p4"] = "hero_8_4_4", ["p5"] = "hero_8_4_5", ["p6"] = "hero_8_4_6", ["p7"] = "hero_8_4_7", ["p8"] = "hero_8_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Waylayer/Description.txt" },
	 { ["name"] = "Heam",        ["name2"] = "Heam2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  35, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroFaidaen.txt",    ["p1"] = "hero_9_4_1", ["p2"] = "hero_9_4_2", ["p3"] = "hero_9_4_3", ["p4"] = "hero_9_4_4", ["p5"] = "hero_9_4_5", ["p6"] = "hero_9_4_6", ["p7"] = "hero_9_4_7", ["p8"] = "hero_9_4_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Elven_Volley/Description.txt" },
	 { ["name"] = "Ildar",       ["name2"] = "Ildar2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  11, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroAlaron.txt",     ["p1"] = "hero_10_4_1",["p2"] = "hero_10_4_2",["p3"] = "hero_10_4_3",["p4"] = "hero_10_4_4",["p5"] = "hero_10_4_5",["p6"] = "hero_10_4_6",["p7"] = "hero_10_4_7",["p8"] = "hero_10_4_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/SpecIldar/Description.txt" },
	 { ["name"] = "GhostFSLord", ["name2"] = "GhostFSLord2", ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  12, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroPrizrak.txt",    ["p1"] = "hero_11_4_1",["p2"] = "hero_11_4_2",["p3"] = "hero_11_4_3",["p4"] = "hero_11_4_4",["p5"] = "hero_11_4_5",["p6"] = "hero_11_4_6",["p7"] = "hero_11_4_7",["p8"] = "hero_11_4_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Preserve/Forest_Guardian/Description.txt" }
};

array_heroes[4] = {
	 { ["name"] = "Faiz",        ["name2"] = "Faiz2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  48, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroFaiz.txt",       ["p1"] = "hero_1_5_1", ["p2"] = "hero_1_5_2", ["p3"] = "hero_1_5_3", ["p4"] = "hero_1_5_4", ["p5"] = "hero_1_5_5", ["p6"] = "hero_1_5_6", ["p7"] = "hero_1_5_7", ["p8"] = "hero_1_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Disrupter/Description.txt" },
	 { ["name"] = "Havez",       ["name2"] = "Havez2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] =  68, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroHafiz.txt",      ["p1"] = "hero_2_5_1", ["p2"] = "hero_2_5_2", ["p3"] = "hero_2_5_3", ["p4"] = "hero_2_5_4", ["p5"] = "hero_2_5_5", ["p6"] = "hero_2_5_6", ["p7"] = "hero_2_5_7", ["p8"] = "hero_2_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Artisan/Description.txt" },
	 { ["name"] = "Nur",         ["name2"] = "Nur2",         ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   9, ["skill2"] =  44, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNazir.txt",      ["p1"] = "hero_3_5_1", ["p2"] = "hero_3_5_2", ["p3"] = "hero_3_5_3", ["p4"] = "hero_3_5_4", ["p5"] = "hero_3_5_5", ["p6"] = "hero_3_5_6", ["p7"] = "hero_3_5_7", ["p8"] = "hero_3_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Weilder_of_Fire/Description.txt" },
	 { ["name"] = "Astral",      ["name2"] = "Astral2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   8, ["skill2"] =  67, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroNura.txt",       ["p1"] = "hero_4_5_1", ["p2"] = "hero_4_5_2", ["p3"] = "hero_4_5_3", ["p4"] = "hero_4_5_4", ["p5"] = "hero_4_5_5", ["p6"] = "hero_4_5_6", ["p7"] = "hero_4_5_7", ["p8"] = "hero_4_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Inexhaustible/Description.txt" },
	 { ["name"] = "Sufi",        ["name2"] = "Sufi2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   8, ["skill2"] =  42, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroOra.txt",        ["p1"] = "hero_5_5_1", ["p2"] = "hero_5_5_2", ["p3"] = "hero_5_5_3", ["p4"] = "hero_5_5_4", ["p5"] = "hero_5_5_5", ["p6"] = "hero_5_5_6", ["p7"] = "hero_5_5_7", ["p8"] = "hero_5_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Feather_Mage/Description.txt" },
	 { ["name"] = "Razzak",      ["name2"] = "Razzak2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  25, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroNarhiz.txt",     ["p1"] = "hero_6_5_1", ["p2"] = "hero_6_5_2", ["p3"] = "hero_6_5_3", ["p4"] = "hero_6_5_4", ["p5"] = "hero_6_5_5", ["p6"] = "hero_6_5_6", ["p7"] = "hero_6_5_7", ["p8"] = "hero_6_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Mentor/Description.txt" },
	 { ["name"] = "Tan",         ["name2"] = "Tan2",         ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  69, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroDgalib.txt",     ["p1"] = "hero_7_5_1", ["p2"] = "hero_7_5_2", ["p3"] = "hero_7_5_3", ["p4"] = "hero_7_5_4", ["p5"] = "hero_7_5_5", ["p6"] = "hero_7_5_6", ["p7"] = "hero_7_5_7", ["p8"] = "hero_7_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Radiant/Description.txt" },
	 { ["name"] = "Isher",       ["name2"] = "Isher2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroRazzak.txt",     ["p1"] = "hero_8_5_1", ["p2"] = "hero_8_5_2", ["p3"] = "hero_8_5_3", ["p4"] = "hero_8_5_4", ["p5"] = "hero_8_5_5", ["p6"] = "hero_8_5_6", ["p7"] = "hero_8_5_7", ["p8"] = "hero_8_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Machinist/Description.txt" },
	 { ["name"] = "Zehir",       ["name2"] = "Zehir2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] =  53, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroZehir.txt",      ["p1"] = "hero_9_5_1", ["p2"] = "hero_9_5_2", ["p3"] = "hero_9_5_3", ["p4"] = "hero_9_5_4", ["p5"] = "hero_9_5_5", ["p6"] = "hero_9_5_6", ["p7"] = "hero_9_5_7", ["p8"] = "hero_9_5_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/Master_of_Elements/Description.txt" },
	 { ["name"] = "Maahir",      ["name2"] = "Maahir2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  17, ["skill2"] =  17, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroMaahir.txt",     ["p1"] = "hero_10_5_1",["p2"] = "hero_10_5_2",["p3"] = "hero_10_5_3",["p4"] = "hero_10_5_4",["p5"] = "hero_10_5_5",["p6"] = "hero_10_5_6",["p7"] = "hero_10_5_7",["p8"] = "hero_10_5_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/SpecMaahir/Description.txt" },
	 { ["name"] = "Cyrus",       ["name2"] = "Cyrus2",       ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  11, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroSairus.txt",     ["p1"] = "hero_11_5_1",["p2"] = "hero_11_5_2",["p3"] = "hero_11_5_3",["p4"] = "hero_11_5_4",["p5"] = "hero_11_5_5",["p6"] = "hero_11_5_6",["p7"] = "hero_11_5_7",["p8"] = "hero_11_5_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Academy/SpecCyrus/Description.txt" }
};

array_heroes[5] = {
	 { ["name"] = "Eruina",      ["name2"] = "Eruina2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =   9, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroErin.txt",       ["p1"] = "hero_1_6_1", ["p2"] = "hero_1_6_2", ["p3"] = "hero_1_6_3", ["p4"] = "hero_1_6_4", ["p5"] = "hero_1_6_5", ["p6"] = "hero_1_6_6", ["p7"] = "hero_1_6_7", ["p8"] = "hero_1_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Matron_Salvo/Description.txt" },
	 { ["name"] = "Inagost",     ["name2"] = "Inagost2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   9, ["skill2"] =  70, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroSinitar.txt",    ["p1"] = "hero_2_6_1", ["p2"] = "hero_2_6_2", ["p3"] = "hero_2_6_3", ["p4"] = "hero_2_6_4", ["p5"] = "hero_2_6_5", ["p6"] = "hero_2_6_6", ["p7"] = "hero_2_6_7", ["p8"] = "hero_2_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Power_Bargain/Description.txt" },
	 { ["name"] = "Urunir",      ["name2"] = "Urunir2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  25, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIranna.txt",     ["p1"] = "hero_3_6_1", ["p2"] = "hero_3_6_2", ["p3"] = "hero_3_6_3", ["p4"] = "hero_3_6_4", ["p5"] = "hero_3_6_5", ["p6"] = "hero_3_6_6", ["p7"] = "hero_3_6_7", ["p8"] = "hero_3_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Seducer/Description.txt" },
	 { ["name"] = "Almegir",     ["name2"] = "Almegir2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  12, ["skill2"] =  71, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroIrbet.txt",      ["p1"] = "hero_4_6_1", ["p2"] = "hero_4_6_2", ["p3"] = "hero_4_6_3", ["p4"] = "hero_4_6_4", ["p5"] = "hero_4_6_5", ["p6"] = "hero_4_6_6", ["p7"] = "hero_4_6_7", ["p8"] = "hero_4_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Dark_Acolyte/Description.txt" },
	 { ["name"] = "Menel",       ["name2"] = "Menel2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  29, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroKifra.txt",      ["p1"] = "hero_5_6_1", ["p2"] = "hero_5_6_2", ["p3"] = "hero_5_6_3", ["p4"] = "hero_5_6_4", ["p5"] = "hero_5_6_5", ["p6"] = "hero_5_6_6", ["p7"] = "hero_5_6_7", ["p8"] = "hero_5_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Slaveholder/Description.txt" },
	 { ["name"] = "Dalom",       ["name2"] = "Dalom2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  10, ["skill2"] =  48, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroLetos.txt",      ["p1"] = "hero_6_6_1", ["p2"] = "hero_6_6_2", ["p3"] = "hero_6_6_3", ["p4"] = "hero_6_6_4", ["p5"] = "hero_6_6_5", ["p6"] = "hero_6_6_6", ["p7"] = "hero_6_6_7", ["p8"] = "hero_6_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Poisoner/Description.txt" },
	 { ["name"] = "Ferigl",      ["name2"] = "Ferigl2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  36, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroSorgal.txt",     ["p1"] = "hero_7_6_1", ["p2"] = "hero_7_6_2", ["p3"] = "hero_7_6_3", ["p4"] = "hero_7_6_4", ["p5"] = "hero_7_6_5", ["p6"] = "hero_7_6_6", ["p7"] = "hero_7_6_7", ["p8"] = "hero_7_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Lizard_Breeder/Description.txt" },
	 { ["name"] = "Ohtarig",     ["name2"] = "Ohtarig2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  32, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVaishan.txt",    ["p1"] = "hero_8_6_1", ["p2"] = "hero_8_6_2", ["p3"] = "hero_8_6_3", ["p4"] = "hero_8_6_4", ["p5"] = "hero_8_6_5", ["p6"] = "hero_8_6_6", ["p7"] = "hero_8_6_7", ["p8"] = "hero_8_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Savage/Description.txt" },
	 { ["name"] = "Raelag_A1",   ["name2"] = "Raelag_A12",   ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =   1, ["skill2"] =  18, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroRailag.txt",     ["p1"] = "hero_9_6_1", ["p2"] = "hero_9_6_2", ["p3"] = "hero_9_6_3", ["p4"] = "hero_9_6_4", ["p5"] = "hero_9_6_5", ["p6"] = "hero_9_6_6", ["p7"] = "hero_9_6_7", ["p8"] = "hero_9_6_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/MasterOfInitiative/Description.txt" },
	 { ["name"] = "Kelodin",     ["name2"] = "Kelodin2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  38, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroShadia.txt",     ["p1"] = "hero_10_6_1",["p2"] = "hero_10_6_2",["p3"] = "hero_10_6_3",["p4"] = "hero_10_6_4",["p5"] = "hero_10_6_5",["p6"] = "hero_10_6_6",["p7"] = "hero_10_6_7",["p8"] = "hero_10_6_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/Evasive/Description.txt" },
	 { ["name"] = "Shadwyn",     ["name2"] = "Shadwyn2",     ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  18, ["skill2"] = 111, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIlaiya.txt",     ["p1"] = "hero_11_6_1",["p2"] = "hero_11_6_2",["p3"] = "hero_11_6_3",["p4"] = "hero_11_6_4",["p5"] = "hero_11_6_5",["p6"] = "hero_11_6_6",["p7"] = "hero_11_6_7",["p8"] = "hero_11_6_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/SpecShadwyn/Description.txt" },
	 { ["name"] = "Thralsai",    ["name2"] = "Thralsai2",    ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =   3, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroTralsai.txt",    ["p1"] = "hero_12_6_1",["p2"] = "hero_12_6_2",["p3"] = "hero_12_6_3",["p4"] = "hero_12_6_4",["p5"] = "hero_12_6_5",["p6"] = "hero_12_6_6",["p7"] = "hero_12_6_7",["p8"] = "hero_12_6_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Dungeon/SpecThralsai/Description.txt" }
};

array_heroes[6] = {
 	 { ["name"] = "Brand",       ["name2"] = "Brand2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] = 151, ["skill2"] = 154, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroBrand.txt",      ["p1"] = "hero_1_7_1", ["p2"] = "hero_1_7_2", ["p3"] = "hero_1_7_3", ["p4"] = "hero_1_7_4", ["p5"] = "hero_1_7_5", ["p6"] = "hero_1_7_6", ["p7"] = "hero_1_7_7", ["p8"] = "hero_1_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Economist/Description.txt" },
	 { ["name"] = "Bersy",       ["name2"] = "Bersy2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  34, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIbba.txt",       ["p1"] = "hero_2_7_1", ["p2"] = "hero_2_7_2", ["p3"] = "hero_2_7_3", ["p4"] = "hero_2_7_4", ["p5"] = "hero_2_7_5", ["p6"] = "hero_2_7_6", ["p7"] = "hero_2_7_7", ["p8"] = "hero_2_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Rider/Description.txt" },
	 { ["name"] = "Egil",        ["name2"] = "Egil2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   8, ["skill2"] =   8, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroErling.txt",     ["p1"] = "hero_3_7_1", ["p2"] = "hero_3_7_2", ["p3"] = "hero_3_7_3", ["p4"] = "hero_3_7_4", ["p5"] = "hero_3_7_5", ["p6"] = "hero_3_7_6", ["p7"] = "hero_3_7_7", ["p8"] = "hero_3_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Magister/Description.txt" },
	 { ["name"] = "Ottar",       ["name2"] = "Ottar2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =  11, ["skill2"] =  11, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroHelmar.txt",     ["p1"] = "hero_4_7_1", ["p2"] = "hero_4_7_2", ["p3"] = "hero_4_7_3", ["p4"] = "hero_4_7_4", ["p5"] = "hero_4_7_5", ["p6"] = "hero_4_7_6", ["p7"] = "hero_4_7_7", ["p8"] = "hero_4_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Sacred_Hammer/Description.txt" },
	 { ["name"] = "Una",         ["name2"] = "Una2",         ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   3, ["skill2"] =  26, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroInga.txt",       ["p1"] = "hero_5_7_1", ["p2"] = "hero_5_7_2", ["p3"] = "hero_5_7_3", ["p4"] = "hero_5_7_4", ["p5"] = "hero_5_7_5", ["p6"] = "hero_5_7_6", ["p7"] = "hero_5_7_7", ["p8"] = "hero_5_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Researcher/Description.txt" },
	 { ["name"] = "Ingvar",      ["name2"] = "Ingvar2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroIngvar.txt",     ["p1"] = "hero_6_7_1", ["p2"] = "hero_6_7_2", ["p3"] = "hero_6_7_3", ["p4"] = "hero_6_7_4", ["p5"] = "hero_6_7_5", ["p6"] = "hero_6_7_6", ["p7"] = "hero_6_7_7", ["p8"] = "hero_6_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Defender/Description.txt" },
	 { ["name"] = "Vegeyr",      ["name2"] = "Vegeyr2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   9, ["skill2"] =  45, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroSveya.txt",      ["p1"] = "hero_7_7_1", ["p2"] = "hero_7_7_2", ["p3"] = "hero_7_7_3", ["p4"] = "hero_7_7_4", ["p5"] = "hero_7_7_5", ["p6"] = "hero_7_7_6", ["p7"] = "hero_7_7_7", ["p8"] = "hero_7_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Stormcaller/Description.txt" },
	 { ["name"] = "Skeggy",      ["name2"] = "Skeggy2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   5, ["skill2"] =  32, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroKarli.txt",      ["p1"] = "hero_8_7_1", ["p2"] = "hero_8_7_2", ["p3"] = "hero_8_7_3", ["p4"] = "hero_8_7_4", ["p5"] = "hero_8_7_5", ["p6"] = "hero_8_7_6", ["p7"] = "hero_8_7_7", ["p8"] = "hero_8_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Axe_Master/Description.txt" },
	 { ["name"] = "KingTolghar", ["name2"] = "KingTolghar2", ["blocked"] = 1, ["taverna"] = 1, ["skill1"] = 151, ["skill2"] = 151, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroTolgar.txt",     ["p1"] = "hero_9_7_1", ["p2"] = "hero_9_7_2", ["p3"] = "hero_9_7_3", ["p4"] = "hero_9_7_4", ["p5"] = "hero_9_7_5", ["p6"] = "hero_9_7_6", ["p7"] = "hero_9_7_7", ["p8"] = "hero_9_7_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/Mountain_King/Description.txt" },
	 { ["name"] = "Wulfstan",    ["name2"] = "Wulfstan2",    ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   1, ["skill2"] =  19, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroVulfsten.txt",   ["p1"] = "hero_10_7_1",["p2"] = "hero_10_7_2",["p3"] = "hero_10_7_3",["p4"] = "hero_10_7_4",["p5"] = "hero_10_7_5",["p6"] = "hero_10_7_6",["p7"] = "hero_10_7_7",["p8"] = "hero_10_7_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/SpecWulfstan/Description.txt" },
	 { ["name"] = "Rolf",        ["name2"] = "Rolf2",        ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  30, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroRolf.txt",       ["p1"] = "hero_11_7_1",["p2"] = "hero_11_7_2",["p3"] = "hero_11_7_3",["p4"] = "hero_11_7_4",["p5"] = "hero_11_7_5",["p6"] = "hero_11_7_6",["p7"] = "hero_11_7_7",["p8"] = "hero_11_7_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Fortress/SpecRolf/Description.txt" }
};

array_heroes[7] = {
	 { ["name"] = "Hero2",       ["name2"] = "Hero22",       ["blocked"] = 1, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] =  22, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroArgat.txt",      ["p1"] = "hero_1_8_1", ["p2"] = "hero_1_8_2", ["p3"] = "hero_1_8_3", ["p4"] = "hero_1_8_4", ["p5"] = "hero_1_8_5", ["p6"] = "hero_1_8_6", ["p7"] = "hero_1_8_7", ["p8"] = "hero_1_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/SpecArgat/Description.txt" },
	 { ["name"] = "Hero3",       ["name2"] = "Hero32",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  36, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGaruna.txt",     ["p1"] = "hero_2_8_1", ["p2"] = "hero_2_8_2", ["p3"] = "hero_2_8_3", ["p4"] = "hero_2_8_4", ["p5"] = "hero_2_8_5", ["p6"] = "hero_2_8_6", ["p7"] = "hero_2_8_7", ["p8"] = "hero_2_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/Blooddrinker/Description.txt" },
	 { ["name"] = "Hero6",       ["name2"] = "Hero62",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   7, ["skill2"] =  39, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroShakKarukat.txt",["p1"] = "hero_3_8_1", ["p2"] = "hero_3_8_2", ["p3"] = "hero_3_8_3", ["p4"] = "hero_3_8_4", ["p5"] = "hero_3_8_5", ["p6"] = "hero_3_8_6", ["p7"] = "hero_3_8_7", ["p8"] = "hero_3_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/SpecShak/Description.txt" },
	 { ["name"] = "Hero8",       ["name2"] = "Hero82",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   2, ["skill2"] = 173, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroTilsek.txt",     ["p1"] = "hero_4_8_1", ["p2"] = "hero_4_8_2", ["p3"] = "hero_4_8_3", ["p4"] = "hero_4_8_4", ["p5"] = "hero_4_8_5", ["p6"] = "hero_4_8_6", ["p7"] = "hero_4_8_7", ["p8"] = "hero_4_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/GrimFighter/Description.txt" },
	 { ["name"] = "Hero7",       ["name2"] = "Hero72",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] =  35, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroHaggesh.txt",    ["p1"] = "hero_5_8_1", ["p2"] = "hero_5_8_2", ["p3"] = "hero_5_8_3", ["p4"] = "hero_5_8_4", ["p5"] = "hero_5_8_5", ["p6"] = "hero_5_8_6", ["p7"] = "hero_5_8_7", ["p8"] = "hero_5_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/CentaurMistress/Description.txt" },
 	 { ["name"] = "Hero1",       ["name2"] = "Hero12",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   6, ["skill2"] = 175, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroKrag.txt",       ["p1"] = "hero_6_8_1", ["p2"] = "hero_6_8_2", ["p3"] = "hero_6_8_3", ["p4"] = "hero_6_8_4", ["p5"] = "hero_6_8_5", ["p6"] = "hero_6_8_6", ["p7"] = "hero_6_8_7", ["p8"] = "hero_6_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/Offender/Description.txt" },
 	 { ["name"] = "Hero9",       ["name2"] = "Hero92",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] =   4, ["skill2"] =  28, ["looser"] = 1, ["ver"] = 100, ["txt"] = "heroKigan.txt",      ["p1"] = "hero_7_8_1", ["p2"] = "hero_7_8_2", ["p3"] = "hero_7_8_3", ["p4"] = "hero_7_8_4", ["p5"] = "hero_7_8_5", ["p6"] = "hero_7_8_6", ["p7"] = "hero_7_8_7", ["p8"] = "hero_7_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/GoblinKing/Description.txt" },
	 { ["name"] = "Hero4",       ["name2"] = "Hero42",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] = 172, ["skill2"] = 175, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGoshak.txt",     ["p1"] = "hero_8_8_1", ["p2"] = "hero_8_8_2", ["p3"] = "hero_8_8_3", ["p4"] = "hero_8_8_4", ["p5"] = "hero_8_8_5", ["p6"] = "hero_8_8_6", ["p7"] = "hero_8_8_7", ["p8"] = "hero_8_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/OrcElder/Description.txt" },
	 { ["name"] = "Kujin",       ["name2"] = "Kujin2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] = 183, ["skill2"] = 174, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroKudgin.txt",     ["p1"] = "hero_9_8_1", ["p2"] = "hero_9_8_2", ["p3"] = "hero_9_8_3", ["p4"] = "hero_9_8_4", ["p5"] = "hero_9_8_5", ["p6"] = "hero_9_8_6", ["p7"] = "hero_9_8_7", ["p8"] = "hero_9_8_8", ["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/SpecKujin/Description.txt" },
	 { ["name"] = "Gottai",      ["name2"] = "Gottai2",      ["blocked"] = 0, ["taverna"] = 1, ["skill1"] = 172, ["skill2"] = 187, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroGotai.txt",      ["p1"] = "hero_10_8_1",["p2"] = "hero_10_8_2",["p3"] = "hero_10_8_3",["p4"] = "hero_10_8_4",["p5"] = "hero_10_8_5",["p6"] = "hero_10_8_6",["p7"] = "hero_10_8_7",["p8"] = "hero_10_8_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/WarLeader/Description.txt" },
	 { ["name"] = "Quroq",       ["name2"] = "Quroq2",       ["blocked"] = 0, ["taverna"] = 1, ["skill1"] = 187, ["skill2"] = 190, ["looser"] = 0, ["ver"] = 100, ["txt"] = "heroKurak.txt",      ["p1"] = "hero_11_8_1",["p2"] = "hero_11_8_2",["p3"] = "hero_11_8_3",["p4"] = "hero_11_8_4",["p5"] = "hero_11_8_5",["p6"] = "hero_11_8_6",["p7"] = "hero_11_8_7",["p8"] = "hero_11_8_8",["block_temply"] = 0, ["dsc"] = "/Text/Game/Heroes/Specializations/Stronghold/SpecQuroq/Description.txt" }
};


dublikat_heroes = {}
dublikat_heroes[0] = {

	 { ["name"] = "Orrin",           ["name2"] = "Orrin2",          ["name3"] = "Orrin3",          ["name4"] = "Orrin4",          },
	 { ["name"] = "Sarge",           ["name2"] = "Sarge2",          ["name3"] = "Sarge3",          ["name4"] = "Sarge4",          },
	 { ["name"] = "Mardigo",         ["name2"] = "Mardigo2",        ["name3"] = "Mardigo3",        ["name4"] = "Mardigo4",        },
	 { ["name"] = "Brem",            ["name2"] = "Brem2",           ["name3"] = "Brem7",           ["name4"] = "Brem8",           },
	 { ["name"] = "Brem3",           ["name2"] = "Brem4",           ["name3"] = "Brem5",           ["name4"] = "Brem6",           },
	 { ["name"] = "Maeve",           ["name2"] = "Maeve2",          ["name3"] = "Maeve3",          ["name4"] = "Maeve4",          },
	 { ["name"] = "Ving",            ["name2"] = "Ving2",           ["name3"] = "Ving3",           ["name4"] = "Ving4",           },
	 { ["name"] = "Nathaniel",       ["name2"] = "Nathaniel2",      ["name3"] = "Nathaniel3",      ["name4"] = "Nathaniel4",      },
	 { ["name"] = "Christian",       ["name2"] = "Christian2",      ["name3"] = "Christian3",      ["name4"] = "Christian4",      },
	 { ["name"] = "Godric",          ["name2"] = "Godric2",         ["name3"] = "Godric3",         ["name4"] = "Godric4",         },
   { ["name"] = "RedHeavenHero03", ["name2"] = "RedHeavenHero032",["name3"] = "RedHeavenHero037",["name4"] = "RedHeavenHero038",},
   { ["name"] = "RedHeavenHero033",["name2"] = "RedHeavenHero034",["name3"] = "RedHeavenHero035",["name4"] = "RedHeavenHero036",},
	 { ["name"] = "Isabell_A1",      ["name2"] = "Isabell_A12",     ["name3"] = "Isabell_A17",     ["name4"] = "Isabell_A18",     },
	 { ["name"] = "Isabell_A13",     ["name2"] = "Isabell_A14",     ["name3"] = "Isabell_A15",     ["name4"] = "Isabell_A16",     },
	 { ["name"] = "Duncan",          ["name2"] = "Duncan2",         ["name3"] = "Duncan3",         ["name4"] = "Duncan4",         },
   { ["name"] = "Nicolai",         ["name2"] = "Nicolai2",        ["name3"] = "Nicolai3",        ["name4"] = "Nicolai4",        }
};

dublikat_heroes[1] = {
	 { ["name"] = "Grok",        ["name2"] = "Grok2",        ["name3"] = "Grok3",        ["name4"] = "Grok4",        },
	 { ["name"] = "Oddrema",     ["name2"] = "Oddrema2",     ["name3"] = "Oddrema3",     ["name4"] = "Oddrema4",     },
	 { ["name"] = "Marder",      ["name2"] = "Marder2",      ["name3"] = "Marder3",      ["name4"] = "Marder4",      },
	 { ["name"] = "Jazaz",       ["name2"] = "Jazaz2",       ["name3"] = "Jazaz3",       ["name4"] = "Jazaz4",       },
	 { ["name"] = "Efion",       ["name2"] = "Efion2",       ["name3"] = "Efion3",       ["name4"] = "Efion4",       },
	 { ["name"] = "Deleb",       ["name2"] = "Deleb2",       ["name3"] = "Deleb3",       ["name4"] = "Deleb4",       },
	 { ["name"] = "Calid",       ["name2"] = "Calid2",       ["name3"] = "Calid3",       ["name4"] = "Calid4",       },
	 { ["name"] = "Nymus",       ["name2"] = "Nymus2",       ["name3"] = "Nymus3",       ["name4"] = "Nymus4",       },
	 { ["name"] = "Orlando",     ["name2"] = "Orlando2",     ["name3"] = "Orlando3",     ["name4"] = "Orlando4",     },
	 { ["name"] = "Agrael",      ["name2"] = "Agrael2",      ["name3"] = "Agrael3",      ["name4"] = "Agrael4",      },
	 { ["name"] = "Kha-Beleth",  ["name2"] = "Kha-Beleth2",  ["name3"] = "Kha-Beleth3",  ["name4"] = "Kha-Beleth4",  }
};

dublikat_heroes[2] = {
	 { ["name"] = "Nemor",       ["name2"] = "Nemor2",       ["name3"] = "Nemor3",       ["name4"] = "Nemor4",       },
	 { ["name"] = "Tamika",      ["name2"] = "Tamika2",      ["name3"] = "Tamika3",      ["name4"] = "Tamika4",      },
	 { ["name"] = "Muscip",      ["name2"] = "Muscip2",      ["name3"] = "Muscip3",      ["name4"] = "Muscip4",      },
	 { ["name"] = "Aberrar",     ["name2"] = "Aberrar2",     ["name3"] = "Aberrar7",     ["name4"] = "Aberrar8",     },
	 { ["name"] = "Aberrar3",    ["name2"] = "Aberrar4",     ["name3"] = "Aberrar5",     ["name4"] = "Aberrar6",     },
	 { ["name"] = "Straker",     ["name2"] = "Straker2",     ["name3"] = "Straker3",     ["name4"] = "Straker4",     },
	 { ["name"] = "Effig",       ["name2"] = "Effig2",       ["name3"] = "Effig3",       ["name4"] = "Effig4",       },
	 { ["name"] = "Pelt",        ["name2"] = "Pelt2",        ["name3"] = "Pel3t",        ["name4"] = "Pelt4",        },
	 { ["name"] = "Gles",        ["name2"] = "Gles2",        ["name3"] = "Gles3",        ["name4"] = "Gles4",        },
	 { ["name"] = "Arantir",     ["name2"] = "Arantir2",     ["name3"] = "Arantir3",     ["name4"] = "Arantir4",     },
	 { ["name"] = "OrnellaNecro",["name2"] = "OrnellaNecro2",["name3"] = "OrnellaNecro5",["name4"] = "OrnellaNecro6",},
	 { ["name"] = "Berein",      ["name2"] = "Berein2",      ["name3"] = "Berein3",      ["name4"] = "Berein4",      },
	 { ["name"] = "Nikolas",     ["name2"] = "Nikolas2",     ["name3"] = "Nikolas3",     ["name4"] = "Nikolas4",     }
};

dublikat_heroes[3] = {
	 { ["name"] = "Metlirn",     ["name2"] = "Metlirn2",     ["name3"] = "Metlirn3",     ["name4"] = "Metlirn4",     },
	 { ["name"] = "Gillion",     ["name2"] = "Gillion2",     ["name3"] = "Gillion3",     ["name4"] = "Gillion4",     },
	 { ["name"] = "Nadaur",      ["name2"] = "Nadaur2",      ["name3"] = "Nadaur3",      ["name4"] = "Nadaur4",      },
	 { ["name"] = "Diraya",      ["name2"] = "Diraya2",      ["name3"] = "Diraya3",      ["name4"] = "Diraya4",      },
	 { ["name"] = "Ossir",       ["name2"] = "Ossir2",       ["name3"] = "Ossir3",       ["name4"] = "Ossir4",       },
	 { ["name"] = "Itil",        ["name2"] = "Itil2",        ["name3"] = "Itil3",        ["name4"] = "Itil4",        },
	 { ["name"] = "Elleshar",    ["name2"] = "Elleshar2",    ["name3"] = "Elleshar3",    ["name4"] = "Elleshar4",    },
	 { ["name"] = "Linaas",      ["name2"] = "Linaas2",      ["name3"] = "Linaas3",      ["name4"] = "Linaas4",      },
	 { ["name"] = "Heam",        ["name2"] = "Heam2",        ["name3"] = "Heam3",        ["name4"] = "Heam4",        },
	 { ["name"] = "Ildar",       ["name2"] = "Ildar2",       ["name3"] = "Ildar7",       ["name4"] = "Ildar8",       },
	 { ["name"] = "Ildar3",      ["name2"] = "Ildar4",       ["name3"] = "Ildar5",       ["name4"] = "Ildar6",       },
	 { ["name"] = "GhostFSLord", ["name2"] = "GhostFSLord2", ["name3"] = "GhostFSLord3", ["name4"] = "GhostFSLord4", }
};

dublikat_heroes[4] = {
	 { ["name"] = "Faiz",        ["name2"] = "Faiz2",        ["name3"] = "Faiz3",        ["name4"] = "Faiz4",        },
	 { ["name"] = "Havez",       ["name2"] = "Havez2",       ["name3"] = "Havez3",       ["name4"] = "Havez4",       },
	 { ["name"] = "Nur",         ["name2"] = "Nur2",         ["name3"] = "Nur3",         ["name4"] = "Nur4",         },
	 { ["name"] = "Astral",      ["name2"] = "Astral2",      ["name3"] = "Astral3",      ["name4"] = "Astral4",      },
	 { ["name"] = "Sufi",        ["name2"] = "Sufi2",        ["name3"] = "Sufi3",        ["name4"] = "Sufi4",        },
	 { ["name"] = "Razzak",      ["name2"] = "Razzak2",      ["name3"] = "Razzak3",      ["name4"] = "Razzak4",      },
	 { ["name"] = "Tan",         ["name2"] = "Tan2",         ["name3"] = "Tan3",         ["name4"] = "Tan4",         },
	 { ["name"] = "Isher",       ["name2"] = "Isher2",       ["name3"] = "Isher3",       ["name4"] = "Isher4",       },
	 { ["name"] = "Zehir",       ["name2"] = "Zehir2",       ["name3"] = "Zehir3",       ["name4"] = "Zehir4",       },
	 { ["name"] = "Maahir",      ["name2"] = "Maahir2",      ["name3"] = "Maahir3",      ["name4"] = "Maahir4",      },
	 { ["name"] = "Cyrus",       ["name2"] = "Cyrus2",       ["name3"] = "Cyrus3",       ["name4"] = "Cyrus4",       }
};

dublikat_heroes[5] = {
	 { ["name"] = "Eruina",      ["name2"] = "Eruina2",      ["name3"] = "Eruina3",      ["name4"] = "Eruina4",      },
	 { ["name"] = "Inagost",     ["name2"] = "Inagost2",     ["name3"] = "Inagost3",     ["name4"] = "Inagost4",     },
	 { ["name"] = "Urunir",      ["name2"] = "Urunir2",      ["name3"] = "Urunir3",      ["name4"] = "Urunir4",      },
	 { ["name"] = "Almegir",     ["name2"] = "Almegir2",     ["name3"] = "Almegir3",     ["name4"] = "Almegir4",     },
	 { ["name"] = "Menel",       ["name2"] = "Menel2",       ["name3"] = "Menel3",       ["name4"] = "Menel4",       },
	 { ["name"] = "Dalom",       ["name2"] = "Dalom2",       ["name3"] = "Dalom3",       ["name4"] = "Dalom4",       },
	 { ["name"] = "Ferigl",      ["name2"] = "Ferigl2",      ["name3"] = "Ferigl3",      ["name4"] = "Ferigl4",      },
	 { ["name"] = "Ohtarig",     ["name2"] = "Ohtarig2",     ["name3"] = "Ohtarig3",     ["name4"] = "Ohtarig4",     },
	 { ["name"] = "Raelag_A1",   ["name2"] = "Raelag_A12",   ["name3"] = "Raelag_A13",   ["name4"] = "Raelag_A14",   },
	 { ["name"] = "Kelodin",     ["name2"] = "Kelodin2",     ["name3"] = "Kelodin3",     ["name4"] = "Kelodin4",     },
	 { ["name"] = "Shadwyn",     ["name2"] = "Shadwyn2",     ["name3"] = "Shadwyn3",     ["name4"] = "Shadwyn4",     },
	 { ["name"] = "Thralsai",    ["name2"] = "Thralsai2",    ["name3"] = "Thralsai3",    ["name4"] = "Thralsai4",    }
};

dublikat_heroes[6] = {
 	 { ["name"] = "Brand",       ["name2"] = "Brand2",       ["name3"] = "Brand3",       ["name4"] = "Brand4",       },
	 { ["name"] = "Bersy",       ["name2"] = "Bersy2",       ["name3"] = "Bersy3",       ["name4"] = "Bersy4",       },
	 { ["name"] = "Egil",        ["name2"] = "Egil2",        ["name3"] = "Egil3",        ["name4"] = "Egil4",        },
	 { ["name"] = "Ottar",       ["name2"] = "Ottar2",       ["name3"] = "Ottar3",       ["name4"] = "Ottar4",       },
	 { ["name"] = "Una",         ["name2"] = "Una2",         ["name3"] = "Una3",         ["name4"] = "Una4",         },
	 { ["name"] = "Ingvar",      ["name2"] = "Ingvar2",      ["name3"] = "Ingvar3",      ["name4"] = "Ingvar4",      },
	 { ["name"] = "Vegeyr",      ["name2"] = "Vegeyr2",      ["name3"] = "Vegeyr3",      ["name4"] = "Vegeyr4",      },
	 { ["name"] = "Skeggy",      ["name2"] = "Skeggy2",      ["name3"] = "Skeggy3",      ["name4"] = "Skeggy4",      },
	 { ["name"] = "KingTolghar", ["name2"] = "KingTolghar2", ["name3"] = "KingTolghar3", ["name4"] = "KingTolghar4", },
	 { ["name"] = "Wulfstan",    ["name2"] = "Wulfstan2",    ["name3"] = "Wulfstan3",    ["name4"] = "Wulfstan4",    },
	 { ["name"] = "Rolf",        ["name2"] = "Rolf2",        ["name3"] = "Rolf3",        ["name4"] = "Rolf4",        }
};

dublikat_heroes[7] = {
	 { ["name"] = "Hero2",       ["name2"] = "Hero22",       ["name3"] = "Hero23",       ["name4"] = "Hero24",       },
	 { ["name"] = "Hero3",       ["name2"] = "Hero32",       ["name3"] = "Hero33",       ["name4"] = "Hero34",       },
	 { ["name"] = "Hero6",       ["name2"] = "Hero62",       ["name3"] = "Hero63",       ["name4"] = "Hero64",       },
	 { ["name"] = "Hero8",       ["name2"] = "Hero82",       ["name3"] = "Hero83",       ["name4"] = "Hero84",       },
	 { ["name"] = "Hero7",       ["name2"] = "Hero72",       ["name3"] = "Hero73",       ["name4"] = "Hero74",       },
 	 { ["name"] = "Hero1",       ["name2"] = "Hero12",       ["name3"] = "Hero13",       ["name4"] = "Hero14",       },
 	 { ["name"] = "Hero9",       ["name2"] = "Hero92",       ["name3"] = "Hero93",       ["name4"] = "Hero94",       },
	 { ["name"] = "Hero4",       ["name2"] = "Hero42",       ["name3"] = "Hero43",       ["name4"] = "Hero44",       },
	 { ["name"] = "Kujin",       ["name2"] = "Kujin2",       ["name3"] = "Kujin3",       ["name4"] = "Kujin4",       },
	 { ["name"] = "Gottai",      ["name2"] = "Gottai2",      ["name3"] = "Gottai3",      ["name4"] = "Gottai4",      },
	 { ["name"] = "Quroq",       ["name2"] = "Quroq2",       ["name3"] = "Quroq3",       ["name4"] = "Quroq4",       }
};



----------------- BATTLES ---------------------------------------

array_battles={}
array_battles[0] = {
    { ["text"] = GetMapDataPath().."Battle/Battle1.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle2.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle3.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle4.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle5.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle6.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle7.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle8.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle9.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle10.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle11.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle12.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle13.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle14.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle15.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle16.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle17.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle18.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle19.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle20.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle21.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle22.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle23.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle24.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle25.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle26.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle27.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle28.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle29.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle30.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle31.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle32.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle33.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle34.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle35.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle36.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle37.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle38.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle39.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle40.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle41.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle42.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle43.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle44.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle45.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle46.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle47.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle48.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle49.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle50.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle51.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle52.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle53.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle54.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle55.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle56.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle57.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle58.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle59.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle60.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle61.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle62.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle63.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle64.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle65.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle66.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle67.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle68.txt",   ["blocked"] = 0, ["kv"] = 100},
    { ["text"] = GetMapDataPath().."Battle/Battle69.txt",   ["blocked"] = 0, ["kv"] = 100},
};

arrayBonusForSiege = {};
--                        HAV  INF  NEC  ELF  MAG  LIG  RUN  ORC
arrayBonusForSiege[0] = {  20,  20,  25,  20,  20,  25,  20,  15}; -- HAVEN
arrayBonusForSiege[1] = {  15,  20,  20,  20,  20,  25,  20,  10}; -- INFERNO
arrayBonusForSiege[2] = {  10,  10,  15,  10,  20,  30,  10,   5}; -- NECROPOLIS
arrayBonusForSiege[3] = {  20,  20,  25,  15,  20,  25,  15,  15}; -- ELF
arrayBonusForSiege[4] = {  10,  15,  10,  15,  20,  15,   5,   0}; -- ACADEMY
arrayBonusForSiege[5] = {   0,   0,   0,   0,  10,  10,   5,   0}; -- WARLOCK
arrayBonusForSiege[6] = {  15,  20,  30,  15,  20,  25,  20,  20}; -- RUNEMAGE
arrayBonusForSiege[7] = {  20,  25,  30,  20,  25,  25,  20,  20}; -- STRONGHOLD
h1r = 3
h2r = 3

array_options={}
array_options[0] = {
    { ["text"] =  GetMapDataPath().."Battle/Option0.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  {GetMapDataPath().."Battle/Option1.txt"; eq = arrayBonusForSiege[h1r - 1][h2r]},    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  {GetMapDataPath().."Battle/Option2.txt"; eq = arrayBonusForSiege[h2r - 1][h1r]},    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option3.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option4.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option5.txt",    ["blocked"] = 1, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option6.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option7.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option8.txt",    ["blocked"] = 0, ["kv"] = 100},
    { ["text"] =  GetMapDataPath().."Battle/Option9.txt",    ["blocked"] = 1, ["kv"] = 100},
};


----------------- SKILLS ----------------------------------------

array_skills_id = {};
array_skills_id = {
	 { ["name"] = SKILL_LOGISTICS,                      ["ID"] = 1},
	 { ["name"] = SKILL_WAR_MACHINES,                   ["ID"] = 2},
	 { ["name"] = SKILL_LEARNING,                       ["ID"] = 3},
	 { ["name"] = SKILL_LEADERSHIP,                     ["ID"] = 4},
	 { ["name"] = SKILL_LUCK,                           ["ID"] = 5},
	 { ["name"] = SKILL_OFFENCE,                        ["ID"] = 6},
	 { ["name"] = SKILL_DEFENCE,                        ["ID"] = 7},
	 { ["name"] = SKILL_SORCERY,                        ["ID"] = 8},
	 { ["name"] = SKILL_DESTRUCTIVE_MAGIC,              ["ID"] = 9},
	 { ["name"] = SKILL_DARK_MAGIC,                     ["ID"] = 10},
	 { ["name"] = SKILL_LIGHT_MAGIC,                    ["ID"] = 11},
	 { ["name"] = SKILL_SUMMONING_MAGIC,                ["ID"] = 12},
	 { ["name"] = SKILL_TRAINING,                       ["ID"] = 13},
	 { ["name"] = SKILL_GATING,                         ["ID"] = 14},
	 { ["name"] = SKILL_NECROMANCY,                     ["ID"] = 15},
	 { ["name"] = SKILL_AVENGER,                        ["ID"] = 16},
	 { ["name"] = SKILL_ARTIFICIER,                     ["ID"] = 17},
	 { ["name"] = SKILL_INVOCATION,                     ["ID"] = 18},
	 { ["name"] = HERO_SKILL_RUNELORE,                  ["ID"] = 151},
	 { ["name"] = HERO_SKILL_DEMONIC_RAGE,              ["ID"] = 172},
	 { ["name"] = HERO_SKILL_BARBARIAN_LEARNING,        ["ID"] = 183},
	 { ["name"] = HERO_SKILL_VOICE,                     ["ID"] = 187},
	 { ["name"] = HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC, ["ID"] = 191},
	 { ["name"] = HERO_SKILL_SHATTER_DARK_MAGIC,        ["ID"] = 195},
	 { ["name"] = HERO_SKILL_SHATTER_LIGHT_MAGIC,       ["ID"] = 199},
	 { ["name"] = HERO_SKILL_SHATTER_SUMMONING_MAGIC,   ["ID"] = 203}
}

array_skills = {};
array_skills = {
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

array_perks = {};
array_perks = {
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
220
};

function int(number)
  int_num = 0;
  ost = frac(number);
  if ost >= 0.5 then
    int_num = floor(number + 1);
  else
    int_num = floor(number);
  end;
  return int_num;
end;


array_elf_enemy={}
array_elf_enemy[0] = {};

array_elf_enemy[1] = {
   { ["kol"] = 44, ["id"] =  1, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 24, ["id"] =  3, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 20, ["id"] =  5, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] =  7, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] =  9, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] = 11, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 13, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[2] = {
   { ["kol"] = 32, ["id"] = 15, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 30, ["id"] = 17, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 16, ["id"] = 19, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] = 21, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] = 23, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] =136, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 27, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[3] = {
   { ["kol"] = 40, ["id"] = 29, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 30, ["id"] = 31, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 18, ["id"] = 34, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] = 35, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] = 37, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] = 39, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 41, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[4] = {
   { ["kol"] = 30, ["id"] = 43, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 18, ["id"] = 45, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 14, ["id"] = 47, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  8, ["id"] = 49, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] = 51, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] = 53, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 55, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[5] = {
   { ["kol"] = 40, ["id"] = 57, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 28, ["id"] = 59, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 18, ["id"] = 61, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] = 63, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] = 65, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] = 67, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 69, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[6] = {
   { ["kol"] = 14, ["id"] = 92, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] = 73, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 12, ["id"] = 75, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  8, ["id"] = 77, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] = 79, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] = 81, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] = 83, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[7] = {
   { ["kol"] = 36, ["id"] = 71, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 28, ["id"] = 94, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 14, ["id"] = 96, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 12, ["id"] = 98, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  6, ["id"] =100, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] =102, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] =105, ["blocked1"] = 0, ["blocked2"] = 0},
};

array_elf_enemy[8] = {
   { ["kol"] = 50, ["id"] =117, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 28, ["id"] =119, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 22, ["id"] =121, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] =123, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] = 10, ["id"] =125, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  4, ["id"] =127, ["blocked1"] = 0, ["blocked2"] = 0},
   { ["kol"] =  2, ["id"] =129, ["blocked1"] = 0, ["blocked2"] = 0},
};


heroes1 = GetPlayerHeroes(PLAYER_1);
heroes2 = GetPlayerHeroes(PLAYER_2);
--HeroMax1 =heroes1[0];
--HeroMax2 =heroes2[0];
HeroDop1 = heroes1[0];
HeroDop2 = heroes2[0];

TELEPORT_BATTLE_ZONE_PLAYER_1_X = 43
TELEPORT_BATTLE_ZONE_PLAYER_1_Y = 45
TELEPORT_BATTLE_ZONE_PLAYER_2_X = 54
TELEPORT_BATTLE_ZONE_PLAYER_2_Y = 45


function no()
end;

lvl1 = 1;
lvl2 = 1;

LevelUp = {}
LevelUp = { 8500, 9000, 9500, 10000, 10500, 11000}

SkillCost = 12000;
SkillCostStart = 14000;
StatRegenCost = 5000;
TavernCost = 5000;

StartExperience = 54000;
HalfLevel = 9;
StartLevel = 18;

RecruitmentCoef = 0.1;
DiplomacyCoef = 0.4;
SaleArmyCoef = 0.25;
CrownOfLeaderBonus = 1.0;
LogisticsSum = 5000;

EllainaDiscount = 20;
MarkelCoef = 0.02;
IngaLevel = 7;
EllesharDiscount = 2500;
EllesharLevel = 0;

EstatesDiscountMentor =  500;
EstatesDiscountLevel  = 2500;

FortunateAdventureDiscount = 0.2;


HalfLeveling1 = 0;
HalfLeveling2 = 0;

DisableBagPlayer1 = 0;
DisableBagPlayer2 = 0;

function no1()
  DisableBagPlayer1 = 0;
  DisableBag = 0;
end;

function no2()
  DisableBagPlayer2 = 0;
  DisableBag = 0;
end;

function pause1F()
  pause1 = 1;
end;

function pause2F()
  pause2 = 1;
end;

function Confirm1F()
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Confirm.txt", 'pause1F');
end;

function Confirm2F()
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Confirm.txt", 'pause2F');
end;

function stop (hero)
  move = 0 - GetHeroStat (hero, STAT_MOVE_POINTS);
  ChangeHeroStat (hero, STAT_MOVE_POINTS, -50000);
end;

stop (heroes1[0]);
stop (heroes2[0]);

HeroTavern1 = 0;
HeroTavern2 = 0;

PerkSum1 = 1;
PerkSum2 = 1;

Ellaina1 = 0;
Ellaina2 = 0;

StLvlUp1 = 0;
StLvlUp2 = 0;

SetObjectEnabled ('tent1', nil);
SetObjectEnabled ('tent2', nil);
OverrideObjectTooltipNameAndDescription ('tent1', GetMapDataPath().."tentNAME.txt", GetMapDataPath().."tentDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('tent2', GetMapDataPath().."tentNAME.txt", GetMapDataPath().."tentDSCRP.txt");

DisguiseEnable1 = 0;
DisguiseEnable2 = 0;
DisguiseHero1 = 0;

function levelup12()
  if Name(hero1) == "Elleshar" then
    Discount1 = EllesharDiscount;
  else
    Discount1 = 0;
  end;
  
  if Name(hero1) == "Nathaniel" and Ellaina1 == 0 then
    Ellaina1 = 1;
    startThread(SpecEllaina1);
  end;
  if Name(hero1) == "Una" then
    Trigger(HERO_LEVELUP_TRIGGER, HeroMax1, 'SpecInga1');
  end;
  if HasHeroSkill(hero1, 1) and LogisticsEnable1 == 0 then
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + LogisticsSum * GetHeroSkillMastery(hero1, 1)));
  end;
  if HasHeroSkill(hero1, 33) then
    ControlHeroCustomAbility(hero1, CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED);
    Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F");
  end;
  Scouting1DopInfo();
  if hero1 == "Nikolas" or hero1 == "Nikolas2" then
    SetObjectOwner('Dwel1', PLAYER_1);
    startThread(HeraldFunction1);
    MoveCameraForPlayers( 1, 89, 82, 0, 40, 0, 0, 0, 0, 1);
    OpenCircleFog( 89, 82, 0, 12, 1 );
  end;
end;

function levelup22()
  if Name(hero2) == "Elleshar" then
    Discount2 = EllesharDiscount;
  else
    Discount2 = 0;
  end;
  if Name(hero2) == "Nathaniel" and Ellaina2 == 0 then
    Ellaina2 = 1;
    startThread(SpecEllaina2);
  end;
  if Name(hero2) == "Una" then
    Trigger(HERO_LEVELUP_TRIGGER, HeroMax2, 'SpecInga2');
  end;
  if HasHeroSkill(hero2, 1) and LogisticsEnable2 == 0 then
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + LogisticsSum * GetHeroSkillMastery(hero2, 1)));
  end;
  if HasHeroSkill(hero2, 33) then
    ControlHeroCustomAbility(hero2, CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED);
    Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F");
  end;
  Scouting2DopInfo();
  if hero2 == "Nikolas" or hero2 == "Nikolas2" then
    SetObjectOwner('Dwel2', PLAYER_2);
    startThread(HeraldFunction2);
    MoveCameraForPlayers( 2, 81, 7, 0, 40, 0, 3.14, 0, 0, 1);
    OpenCircleFog( 81, 7, 0, 12, 2 );
  end;
end;

Rolf1 = 0;
function B1R1()
  SetObjectEnabled ('Bonus1Rolf1', true);
  RemoveObject('Bonus2Rolf1');
  RemoveObject('Bonus3Rolf1');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus1Rolf1', nil );
  MakeHeroInteractWithObject ('Rolf', 'Bonus1Rolf1');
end;

function B2R1()
  SetObjectEnabled ('Bonus2Rolf1', true);
  RemoveObject('Bonus1Rolf1');
  RemoveObject('Bonus3Rolf1');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus2Rolf1', nil );
  MakeHeroInteractWithObject ('Rolf', 'Bonus2Rolf1');
end;

function B3R1()
  SetObjectEnabled ('Bonus3Rolf1', true);
  RemoveObject('Bonus1Rolf1');
  RemoveObject('Bonus2Rolf1');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus3Rolf1', nil );
  MakeHeroInteractWithObject ('Rolf', 'Bonus3Rolf1');
end;

Rolf2 = 0;
function B1R2()
  SetObjectEnabled ('Bonus1Rolf2', true);
  RemoveObject('Bonus2Rolf2');
  RemoveObject('Bonus3Rolf2');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus1Rolf2', nil );
  MakeHeroInteractWithObject ('Rolf2', 'Bonus1Rolf2');
end;

function B2R2()
  SetObjectEnabled ('Bonus2Rolf2', true);
  RemoveObject('Bonus1Rolf2');
  RemoveObject('Bonus3Rolf2');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus2Rolf2', nil );
  MakeHeroInteractWithObject ('Rolf2', 'Bonus2Rolf2');
end;

function B3R2()
  SetObjectEnabled ('Bonus3Rolf2', true);
  RemoveObject('Bonus1Rolf2');
  RemoveObject('Bonus2Rolf2');
  Trigger( OBJECT_TOUCH_TRIGGER, 'Bonus3Rolf2', nil );
  MakeHeroInteractWithObject ('Rolf2', 'Bonus3Rolf2');
end;

function StartArmy(hero, race)
  unitID = GetHeroCreaturesTypes(hero);
  AddHeroCreatures(hero, 87, 1, 6);
  RemoveHeroCreatures(hero, unitID, 1);
end;

function PerkSumF(hero)
  k = 0;
  for i = 1, 26 do
    k = k + GetHeroSkillMastery(hero, array_skills[i]);
  end;
  for i = 1, 189 do
    if HasHeroSkill(hero, array_perks[i]) then
      k = k + 1;
    end;
  end;
  return k;
end;

-- Movement

MovePoints = 25000;

function hodi(hero_name)
	ChangeHeroStat(hero_name, STAT_MOVE_POINTS, 20000);
	ChangeHeroStat(HeroMax1, STAT_MOVE_POINTS, 20000);
	ChangeHeroStat(HeroMax2, STAT_MOVE_POINTS, 20000);
end;

function hodi1(hero_name)
  MP1 = GetHeroStat(hero_name, STAT_MOVE_POINTS);
  if MP1 < MovePoints then
	  ChangeHeroStat(hero_name, STAT_MOVE_POINTS, MovePoints);
  end;
end;

function peredvigenie ()
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '0', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '1', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '2', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '3', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '4', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '5', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '6', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '7', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '8', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '9', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '10', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '11', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '12', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '13', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '14', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '15', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '16', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '17', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '18', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '19', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '20', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '21', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '22', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '23', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '24', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '25', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '26', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '27', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '28', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '29', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '30', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '31', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '32', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '33', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '34', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '35', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '36', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '37', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '38', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '39', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '40', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '41', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '42', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '43', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '44', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '45', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '46', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '47', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '48', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '49', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '50', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '51', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '52', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '53', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '54', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '55', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '56', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '57', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '58', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '59', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '60', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '61', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '62', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '63', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '64', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '65', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '66', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '67', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '68', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '69', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '70', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '71', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '72', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '73', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '74', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '75', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '76', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '77', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '78', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '79', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '80', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '81', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '82', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '83', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '84', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '85', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '86', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '87', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '88', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '89', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '90', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '91', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '92', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '93', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '94', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '95', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '96', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '97', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '98', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '99', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '100', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '101', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '102', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '103', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '104', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '105', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '106', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '107', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '108', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '109', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '110', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '111', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '112', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '113', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '114', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '115', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '116', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '117', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '118', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '119', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '120', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '121', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '122', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '123', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '124', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '125', 'hodi' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '126', 'hodi' );
end;

function peredvigenie_v_lesu ()
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '103', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '104', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '105', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '106', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '107', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '108', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '109', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '110', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '111', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '112', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '113', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '121', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '122', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '123', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '124', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '125', 'hodi1' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '126', 'hodi1' );
end;


function DayFour()
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '0', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '1', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '2', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '3', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '4', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '5', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '6', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '7', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '8', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '9', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '10', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '11', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '12', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '13', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '14', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '15', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '16', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '17', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '18', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '19', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '20', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '21', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '22', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '23', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '24', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '25', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '26', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '27', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '28', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '29', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '30', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '31', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '32', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '33', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '34', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '35', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '36', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '37', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '38', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '39', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '40', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '41', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '42', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '43', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '44', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '45', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '46', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '47', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '48', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '49', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '50', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '51', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '52', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '53', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '54', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '55', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '56', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '57', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '58', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '59', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '60', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '61', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '62', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '63', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '64', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '65', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '66', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '67', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '68', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '69', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '70', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '71', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '72', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '73', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '74', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '75', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '76', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '77', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '78', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '79', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '80', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '81', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '82', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '83', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '84', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '85', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '86', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '87', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '88', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '89', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '90', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '91', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '92', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '93', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '94', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '95', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '96', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '97', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '98', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '99', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '100', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '101', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '102', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '103', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '104', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '105', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '106', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '107', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '108', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '109', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '110', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '111', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '112', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '113', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '114', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '115', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '116', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '117', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '118', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '119', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '120', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '121', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '122', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '123', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '124', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '125', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '126', 'no' );

Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '103', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '104', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '105', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '106', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '107', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '108', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '109', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '110', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '111', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '112', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '113', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '121', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '122', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '123', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '124', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '125', 'no' );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, '126', 'no' );

end;


------------------- ANTISCANER -------------------

StartBonus = {}
StartBonus[1] = bonus1;
StartBonus[2] = bonus2;

NumberBattle = 2;

option = {};
option = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

------------------------------ MENTOR ------------------------------------------

RemoveSkillPlayer1 = 0;
RemoveSkillPlayer2 = 0;
price1 = 2500;
price2 = 2500;
resetExpHero1 = 0;
resetExpHero2 = 0;
RemSk1 = 0;
AddSk1 = 0;
RemSk2 = 0;
AddSk2 = 0;
RemSkSum1 = 0;
RemSkSum2 = 0;


artHero1 = {}
artHero1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
artHero2 = {}
artHero2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

	--------     HAVEN     INF    NECR     ELF    MAGE    LIGA    GNOM     ORC
	basicA   = {     1,      2,      0,      0,      0,      1,      0,      3};
	basicD   = {     2,      0,      1,      2,      0,      0,      1,      0};
	basicS   = {     1,      1,      3,      1,      2,      3,      2,      1};
	basicK   = {     1,      2,      1,      2,      3,      1,      2,      1};

function MentorAddSkill1(hero, skill)
  AddSkill1(hero, skill);
  AddSk1 = AddSk1 + 1;
  if AddSk1 == RemSk1 and ReturnSkillPlayer1 ~= 1 and HasHeroSkill(hero, 29) and EstatesDiscountUse1 == 1 then
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + RemSk1 * EstatesDiscountMentor));
    ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = RemSk1 * EstatesDiscountMentor}, HeroMax1, 1, 5.0);
  end;
  if AddSk1 == RemSk1 and ReturnSkillPlayer1 ~= 1 and HasHeroSkill(hero, 29) and EstatesDiscountUse1 == 0 then
    Estates1Q(hero);
  end;
  if AddSk1 == RemSk1 and ReturnSkillPlayer1 == 1 then
    ShowFlyingSign(GetMapDataPath().."NoForget.txt", HeroMax1, 1, 5.0);
    ReturnSkill1(hero);
  end;
end;

function MentorAddSkill2(hero, skill)
  AddSkill2(hero, skill);
  AddSk2 = AddSk2 + 1;
  if AddSk2 == RemSk2 and ReturnSkillPlayer2 ~= 1 and HasHeroSkill(hero, 29) and EstatesDiscountUse2 == 1 then
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + RemSk2 * EstatesDiscountMentor));
    ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = RemSk2 * EstatesDiscountMentor}, HeroMax2, 2, 5.0);
  end;
  if AddSk2 == RemSk2 and ReturnSkillPlayer2 ~= 1 and HasHeroSkill(hero, 29) and EstatesDiscountUse2 == 0 then
    Estates2Q(hero);
  end;
  if AddSk2 == RemSk2 and ReturnSkillPlayer2 == 1 then
    ShowFlyingSign(GetMapDataPath().."NoForget.txt", HeroMax2, 2, 5.0);
    ReturnSkill2(hero);
  end;
end;



ReturnSkillPlayer1 = 0;
ReturnSkillPlayer2 = 0;
EstatesUse1 = 0;
EstatesUse2 = 0;
SpoilsUse1 = 0;
SpoilsUse2 = 0;
Skill1_78 = 0;
Skill2_78 = 0;
SumSkill1 = 0;
SumSkill2 = 0;
RevUse1 = 0;
RevUse2 = 0;
upp=0;
StudentUse1 = 0;
StudentUse2 = 0;
AcademyUse1 = 0;
AcademyUse2 = 0;


EstatesEnable1 = 0;
EstatesEnable2 = 0;
EstatesDiscountUse1 = 0;
EstatesDiscountUse2 = 0;

Disconnect_SkillPlayer1 = 'AddSkillPlayer1: '
Disconnect_SkillPlayer2 = 'AddSkillPlayer2: '
Disconnect_GoldPlayer1 = 0
Disconnect_GoldPlayer2 = 0

function AddSkill1(hero, skill)
  Disconnect_SkillPlayer1 = Disconnect_SkillPlayer1 .. ' +' .. skill
  Disconnect_GoldPlayer1 = GetPlayerResource (PLAYER_1, GOLD)
  ControlStatHero(hero, skill, 1);
  if skill == 129 and GetDate (DAY) == 4 and SpoilsUse1 == 0 then Spoils1(hero) end;
  if skill ==  30 and GetDate (DAY) == 4 then diplomacy1(hero) end;
  if skill == 79 and StudentUse1 == 0 then SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + 1000)); StudentUse1 = 1; end;
  if skill == 33 and GetHeroStat(hero, STAT_EXPERIENCE) > 1000 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end; --FortunateAdventure1(hero) end;
  if (skill == 29 and RemSk1 == 0) or (skill == 29 and GetHeroLevel(hero) > StartLevel) then Estates1Q(hero); end; --ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
  if skill == 71 or (HasHeroSkill(hero, 71) and GetHeroLevel(hero) == 2) then startThread(DarkRitual) end;
  if skill == 182 then GoblinSupport1(hero) end;
  if skill == 57 then SetTownBuildingLimitLevel('RANDOMTOWN1', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 1); end;
  if skill == 115 then ForestGuard1(hero); end;
  if skill == 181 then DefendUsAll1(hero); end;
  if skill == 1 then Logistics1(hero); end;
  if skill == 21 or (HasHeroSkill(hero, 21) and GetHeroLevel(hero) == 2)then Navigation1(); end;
  if skill == 131 then ChangeHeroStat(hero, 2, -2); end;
  if skill == 186 then ChangeHeroStat(hero, 2, -1); end;
  if skill == 185 then ChangeHeroStat(hero, 4,  2); end;
  if skill == 110 or skill == 137 then GraalVision(hero, 1); end;
  if (skill == 140 or skill == 219) and (RevDel1 == 3) then Revelation1(); end;
  if skill == 20 or skill == 112 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
  if skill == 102 then startThread(HeraldFunction1); end;
  if skill == 81 then ChangeHeroStat(hero, STAT_MANA_POINTS, -100); end;
  if skill == 81 then ChangeHeroStat(hero, 3, -2); end;
  if skill == 87 then ChangeHeroStat(hero, 3, -2); end;
  if skill == 81 or (skill == 9 and HasHeroSkill(hero, 81)) or (skill == 10 and HasHeroSkill(hero, 81)) or (skill == 11 and HasHeroSkill(hero, 81)) or (skill == 12 and HasHeroSkill(hero, 81)) then SinergyKnowledge(hero); end;
  if skill == 87 or (skill == 9 and HasHeroSkill(hero, 87)) or (skill == 10 and HasHeroSkill(hero, 87)) or (skill == 11 and HasHeroSkill(hero, 87)) or (skill == 12 and HasHeroSkill(hero, 87)) then SinergySpellpower(hero); end;
  if (skill == 3 or skill == 183) and ReturnSkillPlayer1 == 0 then Learning1(hero) end;
  ArrayStatHero(hero);
end;

function AddSkill2(hero, skill)
  Disconnect_SkillPlayer2 = Disconnect_SkillPlayer2 .. ' +' .. skill
  Disconnect_GoldPlayer2 = GetPlayerResource (PLAYER_2, GOLD)
  ControlStatHero(hero, skill, 1);
  if skill == 129 and GetDate (DAY) == 4 and SpoilsUse2 == 0 then Spoils2(hero) end;
  if skill ==  30 and GetDate (DAY) == 4 then diplomacy2(hero) end;
  if skill == 79 and StudentUse2 == 0 then SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + 1000)); StudentUse2 = 1; end;
  if skill == 33 and GetHeroStat(hero, STAT_EXPERIENCE) > 1000 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end; --FortunateAdventure2(hero) end;
  if (skill == 29 and RemSk2 == 0) or (skill == 29 and GetHeroLevel(hero) > StartLevel) then Estates2Q(hero); end;
  if skill == 71 or (HasHeroSkill(hero, 71) and GetHeroLevel(hero) == 2) then startThread(DarkRitual) end;
  if skill == 182 then GoblinSupport2(hero) end;
  if skill == 57 then SetTownBuildingLimitLevel('RANDOMTOWN2', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 1); end;
  if skill == 115 then ForestGuard2(hero); end;
  if skill == 181 then DefendUsAll2(hero); end;
  if skill == 1 then Logistics2(hero) end;
  if skill == 21 or (HasHeroSkill(hero, 21) and GetHeroLevel(hero) == 2)then Navigation2(); end;
  if skill == 131 then ChangeHeroStat(hero, 2, -2); end;
  if skill == 186 then ChangeHeroStat(hero, 2, -1); end;
  if skill == 185 then ChangeHeroStat(hero, 4,  2); end;
  if skill == 110 or skill == 137 then GraalVision(hero, 1); end;
  if (skill == 140 or skill == 219) and (RevDel2 == 3) then Revelation2(); end;
  if skill == 20 or skill == 112 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F"); end;
  if skill == 102 then startThread(HeraldFunction2); end;
  if skill == 81 then ChangeHeroStat(hero, STAT_MANA_POINTS, -100); end;
  if skill == 81 then ChangeHeroStat(hero, 3, -2); end;
  if skill == 87 then ChangeHeroStat(hero, 3, -2); end;
  if skill == 81 or (skill == 9 and HasHeroSkill(hero, 81)) or (skill == 10 and HasHeroSkill(hero, 81)) or (skill == 11 and HasHeroSkill(hero, 81)) or (skill == 12 and HasHeroSkill(hero, 81)) then SinergyKnowledge(hero); end;
  if skill == 87 or (skill == 9 and HasHeroSkill(hero, 87)) or (skill == 10 and HasHeroSkill(hero, 87)) or (skill == 11 and HasHeroSkill(hero, 87)) or (skill == 12 and HasHeroSkill(hero, 87)) then SinergySpellpower(hero); end;
  if (skill == 3 or skill == 183) and ReturnSkillPlayer2 == 0 then Learning2(hero) end;
  ArrayStatHero(hero);
end;


function RemoveSkill1(hero, skill)
  sleep(1);
  Disconnect_SkillPlayer1 = Disconnect_SkillPlayer1 .. ' -' .. skill

  ControlStatHero(hero, skill, 0);
  sleep(1);
  if skill == 129 and SpoilsUse1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 16 and AvengerUse1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 17 and minikUse1 > 0 then ReturnSkillPlayer1 = 1; end;
  if skill == 29 and EstatesDiscountUse1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 29 and EstatesDiscountUse1 == 0 and ReturnSkillPlayer1 == 0 then EstatesEnable1 = 0; end;
  if skill == 33 and FortunateAdventureEnable1 ~= 0 then ReturnSkillPlayer1 = 1; end;
  if skill == 33 and FortunateAdventureEnable1 == 0 and ReturnSkillPlayer1 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED); end;
  if skill == 152 and RunesChangeUse1 > 0 then ReturnSkillPlayer1 = 1; end;
  if skill == 1 then DelLogistics1(hero); if LogisticsNoMoney1 == 1 then ReturnSkillPlayer1 = 1; end; end;
  if skill == 21 and NavUse1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 131 then ChangeHeroStat(hero, 2, 2); end;
  if skill == 186 then ChangeHeroStat(hero, 2, 1); end;
  if skill == 185 then ChangeHeroStat(hero, 4, -2); end;
  if skill == 57 and GetTownBuildingLevel('RANDOMTOWN1', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 57 and GetTownBuildingLevel('RANDOMTOWN1', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) <  1 then SetTownBuildingLimitLevel('RANDOMTOWN1', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 0); end;
  if skill == 110 or skill == 137 then GraalVision(hero, -1); end;
  if skill == 71 and ReturnSkillPlayer1 == 0 then RemoveDarkRitual1(hero); end;
  if skill == 140 or skill == 219 then RevelationDel1(hero); end;
  if skill == 20 and ScoutingEnable1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 20 and ScoutingEnable1 == 0 and HasHeroSkill(hero, 112)  == nil and ReturnSkillPlayer1 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED); end;
  if skill == 112 and DisguiseEnable1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 112 and DisguiseEnable1 == 0 and HasHeroSkill(hero, 20)  == nil and ReturnSkillPlayer1 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED); end;
  if skill == 102 and HeraldUse1 == 1 then ReturnSkillPlayer1 = 1; end;
  if skill == 102 and HeraldUse1 == 0 and ReturnSkillPlayer1 == 0 then HeraldUse1 = 2; end;
  if skill == 81 then ChangeHeroStat(hero, 3, 2); end;
  if skill == 87 then ChangeHeroStat(hero, 3, 2); end;
  if skill == 81 or (skill == 9 and HasHeroSkill(hero, 81)) or (skill == 10 and HasHeroSkill(hero, 81)) or (skill == 11 and HasHeroSkill(hero, 81)) or (skill == 12 and HasHeroSkill(hero, 81)) then SinergyKnowledge(hero); end;
  if skill == 87 or (skill == 9 and HasHeroSkill(hero, 87)) or (skill == 10 and HasHeroSkill(hero, 87)) or (skill == 11 and HasHeroSkill(hero, 87)) or (skill == 12 and HasHeroSkill(hero, 87)) then SinergySpellpower(hero); end;
  if (skill == 3 or skill == 183) and ReturnSkillPlayer1 == 0 then Learning1(hero) end;
  if ReturnSkillPlayer1 == 0 then ArrayStatHero(hero); end;
end;

function RemoveSkill2(hero, skill)
  sleep(1);
  Disconnect_SkillPlayer2 = Disconnect_SkillPlayer2 .. ' -' .. skill

  ControlStatHero(hero, skill, 0);
  sleep(1);
  if skill == 129 and SpoilsUse2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 16 and AvengerUse2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 17 and minikUse2 > 0 then ReturnSkillPlayer2 = 1; end;
  if skill == 29 and EstatesDiscountUse2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 29 and EstatesDiscountUse2 == 0 and ReturnSkillPlayer2 == 0 then EstatesEnable2 = 0; end;
  if skill == 33 and FortunateAdventureEnable2 ~= 0 then ReturnSkillPlayer2 = 1; end;
  if skill == 33 and FortunateAdventureEnable2 == 0 and ReturnSkillPlayer2 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED); end;
  if skill == 152 and RunesChangeUse2 > 0 then ReturnSkillPlayer2 = 1; end;
  if skill == 1 then DelLogistics2(hero); if LogisticsNoMoney2 == 1 then ReturnSkillPlayer2 = 1; end; end;
  if skill == 21 and NavUse2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 131 then ChangeHeroStat(hero, 2, 2); end;
  if skill == 186 then ChangeHeroStat(hero, 2, 1); end;
  if skill == 185 then ChangeHeroStat(hero, 4, -2); end;
  if skill == 57 and GetTownBuildingLevel('RANDOMTOWN2', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 57 and GetTownBuildingLevel('RANDOMTOWN2', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) <  1 then SetTownBuildingLimitLevel('RANDOMTOWN2', TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES, 0); end;
  if skill == 110 or skill == 137 then GraalVision(hero, -1); end;
  if skill == 71 and ReturnSkillPlayer2 == 0 then RemoveDarkRitual2(hero); end;
  if skill == 140 or skill == 219 then RevelationDel2(hero); end;
  if skill == 20 and ScoutingEnable2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 20 and ScoutingEnable2 == 0 and HasHeroSkill(hero, 112)  == nil and ReturnSkillPlayer2 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED); end;
  if skill == 112 and DisguiseEnable2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 112 and DisguiseEnable2 == 0 and HasHeroSkill(hero, 20)  == nil and ReturnSkillPlayer2 == 0 then ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED); end;
  if skill == 102 and HeraldUse2 == 1 then ReturnSkillPlayer2 = 1; end;
  if skill == 102 and HeraldUse2 == 0 and ReturnSkillPlayer2 == 0 then HeraldUse2 = 2; end;
  if skill == 81 then ChangeHeroStat(hero, 3, 2); end;
  if skill == 87 then ChangeHeroStat(hero, 3, 2); end;
  if skill == 81 or (skill == 9 and HasHeroSkill(hero, 81)) or (skill == 10 and HasHeroSkill(hero, 81)) or (skill == 11 and HasHeroSkill(hero, 81)) or (skill == 12 and HasHeroSkill(hero, 81)) then SinergyKnowledge(hero); end;
  if skill == 87 or (skill == 9 and HasHeroSkill(hero, 87)) or (skill == 10 and HasHeroSkill(hero, 87)) or (skill == 11 and HasHeroSkill(hero, 87)) or (skill == 12 and HasHeroSkill(hero, 87)) then SinergySpellpower(hero); end;
  if (skill == 3 or skill == 183) and ReturnSkillPlayer2 == 0 then Learning2(hero) end;
  if ReturnSkillPlayer2 == 0 then ArrayStatHero(hero); end;
end;

arrayStatHero = {}
arrayStatHero[1] = { 0, 0, 0, 0, 0}
arrayStatHero[2] = { 0, 0, 0, 0, 0}

arrayUpStat = {}
arrayUpStat = { 0, 0, 0, 0, 0}

function ArrayStatHero(hero)
  if GetObjectOwner(hero) == 1 then
    arrayStatHero[1] = { GetHeroStat(hero, 1), GetHeroStat(hero, 2), GetHeroStat(hero, 3), GetHeroStat(hero, 4), GetHeroLevel(hero)}
  end;
  if GetObjectOwner(hero) == 2 then
    arrayStatHero[2] = { GetHeroStat(hero, 1), GetHeroStat(hero, 2), GetHeroStat(hero, 3), GetHeroStat(hero, 4), GetHeroLevel(hero)}
  end;
end;

probel= " ";

function ControlStatHero(hero, skill, add)
  if GetObjectOwner(hero) == 1 and add == 1 then
    if skill == 115 then arrayStatHero[1][1] = arrayStatHero[1][1] + 2; end;
    if skill == 186 or skill == 181 or skill == 131 then arrayStatHero[1][2] = arrayStatHero[1][2] + 2; end;
    if skill == 87 or skill == 81 or skill == 127 or skill == 119 then arrayStatHero[1][3] = arrayStatHero[1][3] + 2; end;
    if skill == 146 or skill == 79 then arrayStatHero[1][4] = arrayStatHero[1][4] + 2; end;
    if skill == 101 then arrayStatHero[1][4] = arrayStatHero[1][4] + 1; end;
    sumPrev = arrayStatHero[1][1] + arrayStatHero[1][2] + arrayStatHero[1][3] + arrayStatHero[1][4];
    sumNow  = (GetHeroStat(hero, 1) + GetHeroStat(hero, 2) + GetHeroStat(hero, 3) + GetHeroStat(hero, 4))
    if (sumNow > (sumPrev + 1)) and (GetHeroLevel(hero) > arrayStatHero[1][5]) then
      arrayUpStat = { 0, 0, 0, 0, 0};
      for i = 1, 4 do
        if GetHeroStat(hero, i) > arrayStatHero[1][i] then
          arrayUpStat[i] = arrayStatHero[1][i] - GetHeroStat(hero, i);
        end;
      end;
      ChangeHeroStat(hero, 1, arrayStatHero[1][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[1][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[1][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[1][4] - GetHeroStat(hero, 4));
      rnd = random(4) + 1;
      while arrayUpStat[rnd] == 0 do
        rnd = random(4) + 1;
      end;
      ChangeHeroStat(hero, rnd, 1);
    end;

    if (sumNow > sumPrev) and (GetHeroLevel(hero) == arrayStatHero[1][5]) then
      ChangeHeroStat(hero, 1, arrayStatHero[1][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[1][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[1][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[1][4] - GetHeroStat(hero, 4));
    end;
  end;
  if GetObjectOwner(hero) == 2 and add == 1 then
    if skill == 115 then arrayStatHero[2][1] = arrayStatHero[2][1] + 2; end;
    if skill == 186 or skill == 181 or skill == 131 then arrayStatHero[2][2] = arrayStatHero[2][2] + 2; end;
    if skill == 87 or skill == 81 or skill == 127 or skill == 119 then arrayStatHero[2][3] = arrayStatHero[2][3] + 2; end;
    if skill == 146 or skill == 79 then arrayStatHero[2][4] = arrayStatHero[2][4] + 2; end;
    if skill == 101 then arrayStatHero[2][4] = arrayStatHero[2][4] + 1; end;
    sumPrev = arrayStatHero[2][1] + arrayStatHero[2][2] + arrayStatHero[2][3] + arrayStatHero[2][4];
    sumNow  = (GetHeroStat(hero, 1) + GetHeroStat(hero, 2) + GetHeroStat(hero, 3) + GetHeroStat(hero, 4));

    if (sumNow > (sumPrev + 1)) and (GetHeroLevel(hero) > arrayStatHero[2][5]) then
      arrayUpStat = { 0, 0, 0, 0, 0};
      for i = 1, 4 do
        if GetHeroStat(hero, i) > arrayStatHero[2][i] then
          arrayUpStat[i] = arrayStatHero[2][i] - GetHeroStat(hero, i);
        end;
      end;
      ChangeHeroStat(hero, 1, arrayStatHero[2][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[2][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[2][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[2][4] - GetHeroStat(hero, 4));
      rnd = random(4) + 1;
      while arrayUpStat[rnd] == 0 do
        rnd = random(4) + 1;
      end;
      ChangeHeroStat(hero, rnd, 1);
    end;

    if (sumNow > sumPrev) and (GetHeroLevel(hero) == arrayStatHero[2][5]) then
      ChangeHeroStat(hero, 1, arrayStatHero[2][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[2][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[2][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[2][4] - GetHeroStat(hero, 4));
    end;
  end;

  if GetObjectOwner(hero) == 1 and add == 0 then
    if skill == 115 then arrayStatHero[1][1] = arrayStatHero[1][1] - 2; end;
    if skill == 186 or skill == 181 or skill == 131 then arrayStatHero[1][2] = arrayStatHero[1][2] - 2; end;
    if skill == 87 or skill == 81 or skill == 127 or skill == 119 then arrayStatHero[1][3] = arrayStatHero[1][3] - 2; end;
    if skill == 146 or skill == 79 then arrayStatHero[1][4] = arrayStatHero[1][4] - 2; end;
    if skill == 101 then arrayStatHero[1][4] = arrayStatHero[1][4] - 1; end;
    sumPrev = arrayStatHero[1][1] + arrayStatHero[1][2] + arrayStatHero[1][3] + arrayStatHero[1][4];
    sumNow  = (GetHeroStat(hero, 1) + GetHeroStat(hero, 2) + GetHeroStat(hero, 3) + GetHeroStat(hero, 4))
    if sumNow < sumPrev then
      ChangeHeroStat(hero, 1, arrayStatHero[1][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[1][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[1][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[1][4] - GetHeroStat(hero, 4));
    end;
  end;

  if GetObjectOwner(hero) == 2 and add == 0 then
    if skill == 115 then arrayStatHero[2][1] = arrayStatHero[2][1] - 2; end;
    if skill == 186 or skill == 181 or skill == 131 then arrayStatHero[2][2] = arrayStatHero[2][2] - 2; end;
    if skill == 87 or skill == 81 or skill == 127 or skill == 119 then arrayStatHero[2][3] = arrayStatHero[2][3] - 2; end;
    if skill == 146 or skill == 79 then arrayStatHero[2][4] = arrayStatHero[2][4] - 2; end;
    if skill == 101 then arrayStatHero[2][4] = arrayStatHero[2][4] - 1; end;
    sumPrev = arrayStatHero[2][1] + arrayStatHero[2][2] + arrayStatHero[2][3] + arrayStatHero[2][4];
    sumNow  = (GetHeroStat(hero, 1) + GetHeroStat(hero, 2) + GetHeroStat(hero, 3) + GetHeroStat(hero, 4))
    if sumNow < sumPrev then
      ChangeHeroStat(hero, 1, arrayStatHero[2][1] - GetHeroStat(hero, 1));
      ChangeHeroStat(hero, 2, arrayStatHero[2][2] - GetHeroStat(hero, 2));
      ChangeHeroStat(hero, 3, arrayStatHero[2][3] - GetHeroStat(hero, 3));
      ChangeHeroStat(hero, 4, arrayStatHero[2][4] - GetHeroStat(hero, 4));
    end;
  end;
end;


array_skills_H1 = {}
array_skills_H1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_perks_H1 = {}
array_perks_H1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}


array_skills_H2 = {}
array_skills_H2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_perks_H2 = {}
array_perks_H2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}


function ArraySkill1()
  j = 1;
  array_skills_H1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  array_perks_H1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  for i = 1, 26 do
    if i == 3 and getrace(HeroMax1) == 8 then i = 4; end;
    array_skills_H1[i] = GetHeroSkillMastery(HeroMax1, array_skills[i]);
  end;
  for i = 1, 194 do
    if HasHeroSkill( HeroMax1, array_perks[i]) then
      array_perks_H1[j] = array_perks[i];
      j = j + 1;
      kol_perks_H1 = j;
    end;
  end;
  expH1 = GetHeroStat(HeroMax1, STAT_EXPERIENCE);
  GoldPlayer1 = GetPlayerResource (PLAYER_1, GOLD);
end;

function ArraySkill2()
  j = 1;
  array_skills_H2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  array_perks_H2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  for i = 1, 26 do
    if i == 3 and getrace(HeroMax2) == 8 then i = 4; end;
    array_skills_H2[i] = GetHeroSkillMastery(HeroMax2, array_skills[i]);
  end;
  for i = 1, 194 do
    if HasHeroSkill( HeroMax2, array_perks[i]) then
      array_perks_H2[j] = array_perks[i];
      j = j + 1;
      kol_perks_H2 = j;
    end;
  end;
  expH2 = GetHeroStat(HeroMax2, STAT_EXPERIENCE);
  GoldPlayer2 = GetPlayerResource (PLAYER_2, GOLD);
end;


function ReturnSkill1(heroX)
  SetPlayerResource (PLAYER_1, GOLD, GoldPlayer1);
  Trigger( HERO_ADD_SKILL_TRIGGER, heroX, 'no');
  Trigger( HERO_REMOVE_SKILL_TRIGGER, heroX, 'no');

  attH1 = GetHeroStat(heroX, STAT_ATTACK);
  defH1 = GetHeroStat(heroX, STAT_DEFENCE);
  spH1  = GetHeroStat(heroX, STAT_SPELL_POWER);
  knH1  = GetHeroStat(heroX, STAT_KNOWLEDGE);
  k = 1;
  for i = 0, 2 do
    for j = 1, length (array_arts[i]) do
      if HasArtefact(heroX, array_arts[i][j].id, 0) then
        array_arts_Hero1[k].ID = array_arts[i][j].id;
        k = k + 1;
      end;
      if HasArtefact(heroX, array_arts[i][j].id, 1) then
        array_arts_Hero1[k - 1].Eq = 1;
        RemoveArtefact(heroX, array_arts[i][j].id);
      end;
    end;
  end;
  sleep(1);
  DELTAattH1 = attH1 - GetHeroStat(heroX, STAT_ATTACK);
  DELTAdefH1 = defH1 - GetHeroStat(heroX, STAT_DEFENCE);
  DELTAspH1  = spH1 - GetHeroStat(heroX, STAT_SPELL_POWER);
  DELTAknH1  = knH1 - GetHeroStat(heroX, STAT_KNOWLEDGE);

  TakeAwayHeroExp(heroX, expH1 - 1);
  WarpHeroExp(heroX, expH1);
  TakeAwayHeroExp(heroX, expH1 - 1);
  WarpHeroExp(heroX, expH1);
  for i = 1, 26 do
    for j = 1, array_skills_H1[i] do
      if array_skills_H1[i] >= j then
        if GetHeroSkillMastery(heroX, array_skills[i]) < array_skills_H1[i] then
          GiveHeroSkill(heroX, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_H1 do
    GiveHeroSkill(heroX, array_perks_H1[i]);
  end;
    for i = 1, 5 do
      if HasHeroSkill( heroX, array_perks_H1[i]) == nil then
        GiveHeroSkill(heroX, array_perks_H1[i]);
--        k = k + 1;
      end;
    end;
--  end;
  ChangeHeroStat(heroX, STAT_ATTACK, 5);
  ChangeHeroStat(heroX, STAT_DEFENCE, 5);
  ChangeHeroStat(heroX, STAT_SPELL_POWER, 5);
  ChangeHeroStat(heroX, STAT_KNOWLEDGE, 5);

  ChangeHeroStat(heroX, STAT_ATTACK, STARTattH1 - GetHeroStat(heroX, STAT_ATTACK) - DELTAattH1);
  ChangeHeroStat(heroX, STAT_DEFENCE, STARTdefH1 - GetHeroStat(heroX, STAT_DEFENCE) - DELTAdefH1);
  ChangeHeroStat(heroX, STAT_SPELL_POWER, STARTspH1 - GetHeroStat(heroX, STAT_SPELL_POWER) - DELTAspH1);
  ChangeHeroStat(heroX, STAT_KNOWLEDGE, STARTknH1 - GetHeroStat(heroX, STAT_KNOWLEDGE) - DELTAknH1);
  
  for i = 1, length(array_arts_Hero1) do
    if array_arts_Hero1[i].ID ~= 0 and array_arts_Hero1[i].Eq == 1 then
      GiveArtefact(heroX, array_arts_Hero1[i].ID);
    end;
  end;

  array_arts_Hero1 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}

  ReturnSkillPlayer1 = 0;
  sleep(1);
  LearningLvl1 = GetHeroSkillMastery(heroX, 3);
  ArrayStatHero(heroX);
  Trigger( HERO_ADD_SKILL_TRIGGER, heroX, 'MentorAddSkill1');
end;

function ReturnSkill2(heroXX)
  SetPlayerResource (PLAYER_2, GOLD, GoldPlayer2);
  Trigger( HERO_ADD_SKILL_TRIGGER, heroXX, 'no');
  Trigger( HERO_REMOVE_SKILL_TRIGGER, heroXX, 'no');

  attH2 = GetHeroStat(heroXX, STAT_ATTACK);
  defH2 = GetHeroStat(heroXX, STAT_DEFENCE);
  spH2  = GetHeroStat(heroXX, STAT_SPELL_POWER);
  knH2  = GetHeroStat(heroXX, STAT_KNOWLEDGE);
  k = 1;
  for i = 0, 2 do
    for j = 1, length (array_arts[i]) do
      if HasArtefact(heroXX, array_arts[i][j].id, 0) then
        array_arts_Hero2[k].ID = array_arts[i][j].id;
        k = k + 1;
      end;
      if HasArtefact(heroXX, array_arts[i][j].id, 1) then
        array_arts_Hero2[k - 1].Eq = 1;
        RemoveArtefact(heroXX, array_arts[i][j].id);
      end;
    end;
  end;
  sleep(1);
  DELTAattH2 = attH2 - GetHeroStat(HeroMax2, STAT_ATTACK);
  DELTAdefH2 = defH2 - GetHeroStat(HeroMax2, STAT_DEFENCE);
  DELTAspH2  = spH2  - GetHeroStat(HeroMax2, STAT_SPELL_POWER);
  DELTAknH2  = knH2  - GetHeroStat(HeroMax2, STAT_KNOWLEDGE);

  TakeAwayHeroExp(heroXX, expH2 - 1);
  WarpHeroExp(heroXX, expH2);
  TakeAwayHeroExp(heroXX, expH2 - 1);
  WarpHeroExp(heroXX, expH2);
  for i = 1, 26 do
    for j = 1, array_skills_H2[i] do
      if array_skills_H2[i] >= j then
        if GetHeroSkillMastery(heroXX, array_skills[i]) < array_skills_H2[i] then
          GiveHeroSkill(heroXX, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_H2 do
    GiveHeroSkill(heroXX, array_perks_H2[i]);
  end;
    for i = 1, 5 do
      if HasHeroSkill( heroXX, array_perks_H2[i]) == nil then
        GiveHeroSkill(heroXX, array_perks_H2[i]);
      end;
    end;
  ChangeHeroStat(heroXX, STAT_ATTACK, 5);
  ChangeHeroStat(heroXX, STAT_DEFENCE, 5);
  ChangeHeroStat(heroXX, STAT_SPELL_POWER, 5);
  ChangeHeroStat(heroXX, STAT_KNOWLEDGE, 5);

  ChangeHeroStat(heroXX, STAT_ATTACK, STARTattH2 - GetHeroStat(heroXX, STAT_ATTACK) - DELTAattH2);
  ChangeHeroStat(heroXX, STAT_DEFENCE, STARTdefH2 - GetHeroStat(heroXX, STAT_DEFENCE) - DELTAdefH2);
  ChangeHeroStat(heroXX, STAT_SPELL_POWER, STARTspH2 - GetHeroStat(heroXX, STAT_SPELL_POWER) - DELTAspH2);
  ChangeHeroStat(heroXX, STAT_KNOWLEDGE, STARTknH2 - GetHeroStat(heroXX, STAT_KNOWLEDGE) - DELTAknH2);

  for i = 1, length(array_arts_Hero2) do
    if array_arts_Hero2[i].ID ~= 0 and array_arts_Hero2[i].Eq == 1 then
      GiveArtefact(heroXX, array_arts_Hero2[i].ID);
    end;
  end;

  array_arts_Hero2 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}

  ReturnSkillPlayer2 = 0;
  sleep(1);
  LearningLvl2 = GetHeroSkillMastery(heroXX, 3);
  ArrayStatHero(heroXX);
  Trigger( HERO_ADD_SKILL_TRIGGER, heroXX, 'MentorAddSkill2');
end;

function ResetExp1()

  if FortunateAdventureEnable1 == 0 and EstatesUse1 == 0 and SpoilsUse1 == 0 and ScoutingEnable1 == 0 and DisguiseEnable1 == 0 and SnatchUse1 == 0 and HeraldUse1 == 0 and RunesChangeUse1 == 0 then
  if (GetPlayerResource( PLAYER_1, 6) >= ResetExpPrice1) then
    Trigger( HERO_REMOVE_SKILL_TRIGGER, heroReset1, 'RemoveSkill1');
    Trigger( HERO_ADD_SKILL_TRIGGER,    heroReset1, 'MentorAddSkill1');

    j = 1;
    for i = 1, length(array_arts[0]) do
      if HasArtefact   (heroReset1, array_arts[0][i].id) then
        RemoveArtefact (heroReset1, array_arts[0][i].id);
        artHero1[j] = array_arts[0][i].id;
        j = j + 1;
      end;
    end;
    for i = 1, length(array_arts[1]) do
      if HasArtefact   (heroReset1, array_arts[1][i].id) then
        RemoveArtefact (heroReset1, array_arts[1][i].id);
        artHero1[j] = array_arts[1][i].id;
        j = j + 1;
      end;
    end;
    for i = 1, length(array_arts[2]) do
      if HasArtefact   (heroReset1, array_arts[2][i].id) then
        RemoveArtefact (heroReset1, array_arts[2][i].id);
        artHero1[j] = array_arts[2][i].id;
        j = j + 1;
      end;
    end;
    ExpHero = GetHeroStat(heroReset1, STAT_EXPERIENCE);
    TakeAwayHeroExp(heroReset1, ExpHero);
    sleep(1);
    for i = 1, 5 do                 -- � ���
      ChangeHeroStat (heroReset1, STAT_ATTACK,      basicA[hero1race] - GetHeroStat(heroReset1, STAT_ATTACK));
      ChangeHeroStat (heroReset1, STAT_DEFENCE,     basicD[hero1race] - GetHeroStat(heroReset1, STAT_DEFENCE));
      ChangeHeroStat (heroReset1, STAT_SPELL_POWER, basicS[hero1race] - GetHeroStat(heroReset1, STAT_SPELL_POWER));
      ChangeHeroStat (heroReset1, STAT_KNOWLEDGE,   basicK[hero1race] - GetHeroStat(heroReset1, STAT_KNOWLEDGE));
    end;
    sleep(1);
    ArrayStatHero(heroReset1);
    ChangeHeroStat (heroReset1, STAT_EXPERIENCE, ExpHero);
    resetExpHero1 = 1;
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - ResetExpPrice1));
    for i = 1, 7 do
      GiveArtefact   (heroReset1, artHero1[i]);
    end;
  else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NOmoney.txt" );
  end;
  else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NoForgetSkills.txt" );
  end;
end;

function ResetExp2()

  if FortunateAdventureEnable2 == 0 and EstatesUse2 == 0 and SpoilsUse2 == 0 and ScoutingEnable2 == 0 and DisguiseEnable2 == 0 and SnatchUse2 == 0 and HeraldUse2 == 0 and RunesResetUse2 == 0 then
  if (GetPlayerResource( PLAYER_2, 6) >= ResetExpPrice2) then
    Trigger( HERO_REMOVE_SKILL_TRIGGER, heroReset2, 'RemoveSkill2');
    Trigger( HERO_ADD_SKILL_TRIGGER,    heroReset2, 'MentorAddSkill2');

    j = 1;
    for i = 1, length(array_arts[0]) do
      if HasArtefact   (heroReset2, array_arts[0][i].id) then
        RemoveArtefact (heroReset2, array_arts[0][i].id);
        artHero2[j] = array_arts[0][i].id;
        j = j + 1;
      end;
    end;
    for i = 1, length(array_arts[1]) do
      if HasArtefact   (heroReset2, array_arts[1][i].id) then
        RemoveArtefact (heroReset2, array_arts[1][i].id);
        artHero2[j] = array_arts[1][i].id;
        j = j + 1;
      end;
    end;
    for i = 1, length(array_arts[2]) do
      if HasArtefact   (heroReset2, array_arts[2][i].id) then
        RemoveArtefact (heroReset2, array_arts[2][i].id);
        artHero2[j] = array_arts[2][i].id;
        j = j + 1;
      end;
    end;
    ExpHero = GetHeroStat(heroReset2, STAT_EXPERIENCE);
    TakeAwayHeroExp(heroReset2, ExpHero);
    ChangeHeroStat (heroReset2, STAT_ATTACK,      basicA[hero2race] - GetHeroStat(heroReset2, STAT_ATTACK));
    ChangeHeroStat (heroReset2, STAT_DEFENCE,     basicD[hero2race] - GetHeroStat(heroReset2, STAT_DEFENCE));
    ChangeHeroStat (heroReset2, STAT_SPELL_POWER, basicS[hero2race] - GetHeroStat(heroReset2, STAT_SPELL_POWER));
    ChangeHeroStat (heroReset2, STAT_KNOWLEDGE,   basicK[hero2race] - GetHeroStat(heroReset2, STAT_KNOWLEDGE));
    ArrayStatHero(heroReset2);
    ChangeHeroStat (heroReset2, STAT_EXPERIENCE, ExpHero);
    resetExpHero2 = 1;
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - ResetExpPrice2));
    for i = 1, 7 do
      GiveArtefact   (heroReset2, artHero2[i]);
    end;
  else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NOmoney.txt" );
  end;
  else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NoForgetSkills.txt" );
  end;
end;


function ReturnGold1(hero, skill)
  AddSkill1(hero, skill);
  SetPlayerResource( 1, GOLD, GoldPl1);
  ShowFlyingSign({GetMapDataPath().."MentorBalance.txt"; eq = price1}, HeroMax1, 1, 5.0);
end;

function ReturnGold2(hero, skill)
  AddSkill2(hero, skill);
  SetPlayerResource( 2, GOLD, GoldPl2);
  ShowFlyingSign({GetMapDataPath().."MentorBalance.txt"; eq = price2}, HeroMax2, 2, 5.0);
end;


--------------------------------- SPELL NABOR ----------------------------------

runes = {};
runes[0] = {{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
runes[1] = {{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
runes[2] = {{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
runes[3] = {{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};

spells = {};
spells[0]={{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
spells[1]={{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
spells[2]={{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};
spells[3]={{["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0},
           {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}, {["m"] = 0, ["sp"] = 0}};

BonusSpells = {}
BonusSpells[0] = {["m1"] = 0, ["sp1"] = 0, ["m2"] = 0, ["sp2"] = 0};
BonusSpells[1] = {["m1"] = 0, ["sp1"] = 0, ["m2"] = 0, ["sp2"] = 0};

for i = 0, 5 do
  k = 12;
  if i == 4 then k = 10; end;
  if i == 5 then k =  6; end;
  for j = 1, k do
    OverrideObjectTooltipNameAndDescription (array_spells[i][j].name,  GetMapDataPath()..array_spells[i][j].text, GetMapDataPath().."notext.txt");
    OverrideObjectTooltipNameAndDescription (array_spells[i][j].name2, GetMapDataPath()..array_spells[i][j].text, GetMapDataPath().."notext.txt");
    OverrideObjectTooltipNameAndDescription (array_spells[i][j].name3, GetMapDataPath()..array_spells[i][j].text, GetMapDataPath().."notext.txt");
    OverrideObjectTooltipNameAndDescription (array_spells[i][j].name4, GetMapDataPath()..array_spells[i][j].text, GetMapDataPath().."notext.txt");
  end;
end;


place_spell = {};
place_spell[0] = {
                  {["x"] = 33, ["y"] = 87}, {["x"] = 34, ["y"] = 87}, {["x"] = 35, ["y"] = 87}, {["x"] = 36, ["y"] = 87}, {["x"] = 37, ["y"] = 87},
                  {["x"] = 33, ["y"] = 88}, {["x"] = 34, ["y"] = 88}, {["x"] = 35, ["y"] = 88}, {["x"] = 36, ["y"] = 88}, {["x"] = 37, ["y"] = 88},
                  {["x"] = 38, ["y"] = 87}, {["x"] = 39, ["y"] = 87}, {["x"] = 38, ["y"] = 88}, {["x"] = 39, ["y"] = 88},
                  {["x"] = 33, ["y"] = 89}, {["x"] = 34, ["y"] = 89}, {["x"] = 35, ["y"] = 89}, {["x"] = 36, ["y"] = 89}, {["x"] = 37, ["y"] = 89},
                  {["x"] = 33, ["y"] = 90}, {["x"] = 34, ["y"] = 90}, {["x"] = 35, ["y"] = 90}, {["x"] = 36, ["y"] = 90}, {["x"] = 37, ["y"] = 90}
                 };
place_spell[1] = {
                  {["x"] = 44, ["y"] = 22}, {["x"] = 43, ["y"] = 22}, {["x"] = 42, ["y"] = 22}, {["x"] = 41, ["y"] = 22}, {["x"] = 40, ["y"] = 22},
                  {["x"] = 44, ["y"] = 21}, {["x"] = 43, ["y"] = 21}, {["x"] = 42, ["y"] = 21}, {["x"] = 41, ["y"] = 21}, {["x"] = 40, ["y"] = 21},
                  {["x"] = 39, ["y"] = 22}, {["x"] = 38, ["y"] = 22}, {["x"] = 39, ["y"] = 21}, {["x"] = 38, ["y"] = 21},
                  {["x"] = 44, ["y"] = 20}, {["x"] = 43, ["y"] = 20}, {["x"] = 42, ["y"] = 20}, {["x"] = 41, ["y"] = 20}, {["x"] = 40, ["y"] = 20},
                  {["x"] = 44, ["y"] = 19}, {["x"] = 43, ["y"] = 19}, {["x"] = 42, ["y"] = 19}, {["x"] = 41, ["y"] = 19}, {["x"] = 40, ["y"] = 19},
                 };

HeroHasSpellShield1 = 0;
HeroHasSpellShield2 = 0;

function TeachSpell (hero, nabor)
  if nabor == 0 then
    if SpellResetUse1 == 2 then
      nabor = 2;
    end;
  end;
  if nabor == 1 then
    if SpellResetUse2 == 2 then
      nabor = 3;
    end;
  end;

  for i = 1, 24 do
    if spells[nabor][i].m < 4 and spells[nabor][i].sp ~= 0 then
      if array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 1 or array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 2 then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
        if (nabor == 0 or nabor == 2) and HasHeroSkill(HeroMax2, PERK_SCHOLAR) and GetHeroSkillMastery(HeroMax2, HERO_SKILL_DEMONIC_RAGE) == 0 then TeachHeroSpell(HeroMax2, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id); end;
        if (nabor == 1 or nabor == 3) and HasHeroSkill(HeroMax1, PERK_SCHOLAR) and GetHeroSkillMastery(HeroMax1, HERO_SKILL_DEMONIC_RAGE) == 0 then TeachHeroSpell(HeroMax1, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id); end;
      end;
      if array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 3 and HasHeroSkill(hero, PERK_WISDOM) then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
      end;
      if array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 4 and HasHeroSkill(hero, PERK_WISDOM) and HasArtefact( hero, 71, 1) then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
      end;

      if spells[nabor][i].m == 0 then magic = SKILL_LIGHT_MAGIC; end;
      if spells[nabor][i].m == 1 then magic = SKILL_DARK_MAGIC; end;
      if spells[nabor][i].m == 2 then magic = SKILL_DESTRUCTIVE_MAGIC; end;
      if spells[nabor][i].m == 3 then magic = SKILL_SUMMONING_MAGIC; end;
      if GetHeroSkillMastery( hero, magic) >= 1 and array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 3 then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
      end;
      if GetHeroSkillMastery( hero, magic) >= 2 and array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 4 then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
      end;
      if GetHeroSkillMastery( hero, magic) >= 3 and array_spells[spells[nabor][i].m][spells[nabor][i].sp].level == 5 then
        TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
--        if array_spells[spells[nabor][i].m][spells[nabor][i].sp].id == 34 and hero == HeroMax1 then HeroHasSpellShield1 = 1; end;
--        if array_spells[spells[nabor][i].m][spells[nabor][i].sp].id == 34 and hero == HeroMax2 then HeroHasSpellShield2 = 1; end;
      end;
    end;
    if spells[nabor][i].m == 4 and spells[nabor][i].sp ~= 0 then
      NaborRun = nabor;
      if nabor == 2 then NaborRun = 0; end;
      if nabor == 3 then NaborRun = 1; end;
      if (GetHeroSkillMastery( hero, HERO_SKILL_RUNELORE) == 1 and array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].level < 4) then
        TeachHeroSpell(hero, array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].id);
      end;
      if (GetHeroSkillMastery( hero, HERO_SKILL_RUNELORE) == 2 and array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].level < 5) then
        TeachHeroSpell(hero, array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].id);
      end;
      if (GetHeroSkillMastery( hero, HERO_SKILL_RUNELORE) > 2 and array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].level < 6) then
        TeachHeroSpell(hero, array_spells[spells[NaborRun][i].m][spells[NaborRun][i].sp].id);
      end;
    end;
    if spells[nabor][i].m == 5 and spells[nabor][i].sp ~= 0 and GetHeroSkillMastery( hero, HERO_SKILL_DEMONIC_RAGE) > 0 then
      TeachHeroSpell(hero, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id);
--      if nabor == 0 and HasHeroSkill(HeroMax2, PERK_SCHOLAR) and GetHeroSkillMastery(HeroMax2, HERO_SKILL_DEMONIC_RAGE) > 0 then TeachHeroSpell(HeroMax2, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id); end;
--      if nabor == 1 and HasHeroSkill(HeroMax1, PERK_SCHOLAR) and GetHeroSkillMastery(HeroMax1, HERO_SKILL_DEMONIC_RAGE) > 0 then TeachHeroSpell(HeroMax1, array_spells[spells[nabor][i].m][spells[nabor][i].sp].id); end;
    end;
  end;
end;
  
function Scholar(hero, nabor)
  for i = 0, 3 do
    for j = 1, 12 do
      if hero == HeroMax1 and HasHeroSkill(hero, PERK_SCHOLAR) and array_spells[i][j].level < 3 and KnowHeroSpell(HeroMax2, array_spells[i][j].id) then
        TeachHeroSpell(hero, array_spells[i][j].id);
      end;
      if hero == HeroMax2 and HasHeroSkill(hero, PERK_SCHOLAR) and array_spells[i][j].level < 3 and KnowHeroSpell(HeroMax1, array_spells[i][j].id) then
        TeachHeroSpell(hero, array_spells[i][j].id);
      end;
      if i == 0 then magic = SKILL_LIGHT_MAGIC; end;
      if i == 1 then magic = SKILL_DARK_MAGIC; end;
      if i == 2 then magic = SKILL_DESTRUCTIVE_MAGIC; end;
      if i == 3 then magic = SKILL_SUMMONING_MAGIC; end;
      if (nabor == 0 or nabor == 2) and HasHeroSkill(HeroMax1, PERK_SCHOLAR) and array_spells[i][j].level == 3 and KnowHeroSpell(HeroMax2, array_spells[i][j].id) and (HasHeroSkill(HeroMax1, PERK_WISDOM) or GetHeroSkillMastery( HeroMax1, magic) >= 1) then
        TeachHeroSpell(HeroMax1, array_spells[i][j].id);
      end;
      if (nabor == 1 or nabor == 3) and HasHeroSkill(HeroMax2, PERK_SCHOLAR) and array_spells[i][j].level == 3 and KnowHeroSpell(HeroMax1, array_spells[i][j].id) and (HasHeroSkill(HeroMax2, PERK_WISDOM) or GetHeroSkillMastery( HeroMax2, magic) >= 1) then
        TeachHeroSpell(HeroMax2, array_spells[i][j].id);
      end;
    end;
  end;
end;

---- ****

arrayPossibleHeroes = {}
arrayPossibleHeroes[0] = {}
arrayPossibleHeroes[1] = {}
arrayPossibleHeroes[2] = {}
arrayPossibleHeroes[3] = {}

HeroFromTavernActivity1 = 0;
HeroFromTavernActivity2 = 0;

function HeroAdd1(hero)
--  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  3000));
--  StartArmy(hero, hero1race);
  HeroDop1 = hero;
  heroes1[3] = HeroDop1;
  if StartBonus[1] == 'spell' then
    TeachHeroSpell(HeroDop1, array_spells[BonusSpells[0].m1][BonusSpells[0].sp1].id );
    TeachHeroSpell(HeroDop1, array_spells[BonusSpells[0].m2][BonusSpells[0].sp2].id );
  end;
--  UpHeroStat(hero);
--  if getrace(hero) == 1 and hero1race == 1 and hero2race == 2 then ChangeHeroStat(hero, 4, 4); end;
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroDop1, 'MentorAddSkill1');
  ControlHeroCustomAbility(HeroDop1, CUSTOM_ABILITY_1, CUSTOM_ABILITY_ENABLED);
  Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F");
  HeroMage13 = HeroDop1;
  HeroFromTavernActivity1 = 1;
  LockMinHeroSkillsAndAttributes(HeroDop1);
end;

function HeroAdd2(hero)
--  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  3000));
--  StartArmy(hero, hero2race);
  HeroDop2 = hero;
  heroes2[3] = HeroDop2;
  if StartBonus[2] == 'spell' then
    TeachHeroSpell(HeroDop2, array_spells[BonusSpells[1].m1][BonusSpells[1].sp1].id );
    TeachHeroSpell(HeroDop2, array_spells[BonusSpells[1].m2][BonusSpells[1].sp2].id );
  end;
--  UpHeroStat(hero);
--  if getrace(hero) == 1 and hero2race == 1 and hero1race == 2 then ChangeHeroStat(hero, 4, 4); end;
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroDop2, 'MentorAddSkill2');
  ControlHeroCustomAbility(HeroDop2, CUSTOM_ABILITY_1, CUSTOM_ABILITY_ENABLED);
  Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F");
  HeroMage23 = HeroDop2;
  HeroFromTavernActivity2 = 1;
  LockMinHeroSkillsAndAttributes(HeroDop2);
end;

RemStUn1 = 0;
RemStUn2 = 0;

array_StartUnit = {}
array_StartUnit = {{["grade1"] =   1, ["grade2"] = 106},
                   {["grade1"] =  15, ["grade2"] = 131},
                   {["grade1"] =  29, ["grade2"] = 152},
                   {["grade1"] =  43, ["grade2"] = 145},
                   {["grade1"] =  57, ["grade2"] = 159},
                   {["grade1"] =  71, ["grade2"] = 138},
                   {["grade1"] =  92, ["grade2"] = 166},
                   {["grade1"] = 117, ["grade2"] = 173}}


function RemoveStartUnit1()
  while RemStUn1 == 0 do
    Un11, Un12 = GetHeroCreaturesTypes(HeroMax1);
    Un13, Un14 = GetHeroCreaturesTypes(HeroMin1);
    if Un12 > 0 then
      if GetHeroCreatures(HeroMax1, 87) > 0 then
        RemoveHeroCreatures(HeroMax1, 87, GetHeroCreatures(HeroMax1, 87));
        RemStUn1 = 1;
      end;
    end;
    if Un14 > 0 then
      if GetHeroCreatures(HeroMin1, 87) > 0 then
        RemoveHeroCreatures(HeroMin1, 87, GetHeroCreatures(HeroMin1, 87));
        RemStUn1 = 1;
      end;
    end;
    sleep(5);
  end;
end;

function RemoveStartUnit2()
  while RemStUn2 == 0 do
    Un21, Un22 = GetHeroCreaturesTypes(HeroMax2);
    Un23, Un24 = GetHeroCreaturesTypes(HeroMin2);
    if Un22 > 0 then
      if GetHeroCreatures(HeroMax2, 87) > 0 then
        RemoveHeroCreatures(HeroMax2, 87, GetHeroCreatures(HeroMax2, 87));
        RemStUn2 = 1;
      end;
    end;
    if Un24 > 0 then
      if GetHeroCreatures(HeroMin2, 87) > 0 then
        RemoveHeroCreatures(HeroMin2, 87, GetHeroCreatures(HeroMin2, 87));
        RemStUn2 = 1;
      end;
    end;
    sleep(5);
  end;
end;


--------     HAVEN     INF    NECR     ELF    MAGE    LIGA    GNOM     ORC
PercentA = {    30,     45,     10,     15,     10,     30,     20,     50};
PercentD = {    45,     10,     30,     45,     15,     10,     30,     35};
PercentS = {    10,     15,     45,     10,     30,     45,     30,      5};
PercentK = {    15,     30,     15,     30,     45,     15,     20,     10};


SetObjectEnabled('stat1', nil);
SetObjectEnabled('stat2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'stat1', 'RegenStatQuestion1' );
Trigger( OBJECT_TOUCH_TRIGGER, 'stat2', 'RegenStatQuestion2' );

arrayStatRegenHero1 = {}
arrayStatRegenHero1 = { 0, 0, 0, 0}
arrayStatRegenHero2 = {}
arrayStatRegenHero2 = { 0, 0, 0, 0}

function RegenStatQuestion1(hero)
  heroRS1 = hero;
  if GetPlayerResource(PLAYER_1, GOLD) >= StatRegenCost then
    QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_1), {GetMapDataPath().."ResetStat.txt"; eq = StatRegenCost}, 'RegenStat1', 'no');
  else
    MessageBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."no_money.txt"; eq = StatRegenCost});
  end;
end;

function RegenStatQuestion2(hero)
  heroRS2 = hero;
  if GetPlayerResource(PLAYER_2, GOLD) >= StatRegenCost then
    QuestionBoxForPlayers ( GetPlayerFilter(PLAYER_2), {GetMapDataPath().."ResetStat.txt"; eq = StatRegenCost}, 'RegenStat2', 'no');
  else
    MessageBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."no_money.txt"; eq = StatRegenCost});
  end;
end;

function RegenStat1()
  j = 1;
  for k = 0, 2 do
    for i = 1, length(array_arts[k]) do
      if HasArtefact   (heroRS1, array_arts[k][i].id) then
        RemoveArtefact (heroRS1, array_arts[k][i].id);
        artHero1[j] = array_arts[k][i].id;
        j = j + 1;
      end;
    end;
  end;
  sleep(1);
  arrayStatRegenHero1 = { GetHeroStat(heroRS1, 1), GetHeroStat(heroRS1, 2), GetHeroStat(heroRS1, 3), GetHeroStat(heroRS1, 4)};
  if HasHeroSkill(heroRS1, 115) then arrayStatRegenHero1[1] = arrayStatRegenHero1[1] - 2; end;
  if HasHeroSkill(heroRS1, 186) then arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - 1; end;
  if HasHeroSkill(heroRS1, 181) then arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - 2; end;
  if HasHeroSkill(heroRS1,  87) then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 2 * SinergyLevel1; end;
  if HasHeroSkill(heroRS1,  81) then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 2 * SinergyLevel1; end;
--    if SinergyLevel1 == 0 or SinergyLevel1 == 1 then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 2;
--    elseif SinergyLevel1 == 2 then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 3;
--    elseif SinergyLevel1 == 3 then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 5;
--    elseif SinergyLevel1 == 4 then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 8;
--    end;
--  if HasHeroSkill(heroRS1,  87) then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 3; end;
  if HasHeroSkill(heroRS1, 119) then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 2; end;
  if HasHeroSkill(heroRS1, 127) then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 2; end;
  if HasHeroSkill(heroRS1,  79) then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 2; end;
  if HasHeroSkill(heroRS1, 146) then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 2; end;
  if HasHeroSkill(heroRS1, 185) then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 2; end;
  if HasHeroSkill(heroRS1, 101) then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 1; end;
  if (HasHeroSkill(heroRS1, 110) or HasHeroSkill(heroRS1, 137)) and GetCurrentMoonWeek() == 20 then arrayStatRegenHero1[1] = arrayStatRegenHero1[1] - 3; end;
  if (HasHeroSkill(heroRS1, 110) or HasHeroSkill(heroRS1, 137)) and GetCurrentMoonWeek() == 23 then arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - 3; end;
  if (HasHeroSkill(heroRS1, 110) or HasHeroSkill(heroRS1, 137)) and GetCurrentMoonWeek() == 15 then arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 3; end;
  if (HasHeroSkill(heroRS1, 110) or HasHeroSkill(heroRS1, 137)) and GetCurrentMoonWeek() == 3  then arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 3; end;
  if (HasHeroSkill(heroRS1, 110) or HasHeroSkill(heroRS1, 137)) and GetCurrentMoonWeek() == 18 then arrayStatRegenHero1[1] = arrayStatRegenHero1[1] - 1; arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - 1; arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - 1; arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - 1; end;
  arrayStatRegenHero1[1] = arrayStatRegenHero1[1] - basicA[getrace(heroRS1)] - statA1;
  arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - basicD[getrace(heroRS1)] - statD1;
  arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - basicS[getrace(heroRS1)] - statS1;
  arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - basicK[getrace(heroRS1)] - statK1;
  ChangeHeroStat( heroRS1, 1, 0 - arrayStatRegenHero1[1]);
  ChangeHeroStat( heroRS1, 2, 0 - arrayStatRegenHero1[2]);
  ChangeHeroStat( heroRS1, 3, 0 - arrayStatRegenHero1[3]);
  ChangeHeroStat( heroRS1, 4, 0 - arrayStatRegenHero1[4]);

  arrayStatRegenHero1[1] = arrayStatRegenHero1[1] - arrayStatForLearning1[GetHeroSkillMastery(heroRS1, 3)][1]; --print(arrayStatRegenHero1[1]);
  arrayStatRegenHero1[2] = arrayStatRegenHero1[2] - arrayStatForLearning1[GetHeroSkillMastery(heroRS1, 3)][2];-- print(arrayStatRegenHero1[2]);
  arrayStatRegenHero1[3] = arrayStatRegenHero1[3] - arrayStatForLearning1[GetHeroSkillMastery(heroRS1, 3)][3]; --print(arrayStatRegenHero1[3]);
  arrayStatRegenHero1[4] = arrayStatRegenHero1[4] - arrayStatForLearning1[GetHeroSkillMastery(heroRS1, 3)][4]; --print(arrayStatRegenHero1[4]);
  StatRegenSum1 = arrayStatRegenHero1[1] + arrayStatRegenHero1[2] + arrayStatRegenHero1[3] + arrayStatRegenHero1[4]; --print(StatRegenSum1);
  for i = 1, StatRegenSum1 do
    UpHeroStat(heroRS1);
  end;
  GenerateStatLearning1(heroRS1);
  LearningLvl1 = 0;
  Learning1(heroRS1);
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - StatRegenCost));
  x, y = GetObjectPosition(heroRS1);
  Play2DSoundForPlayers ( 1, "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", x, y, 0);
  for i = 1, 15 do
    GiveArtefact (heroRS1, artHero1[i]);
  end;
  sleep(1);
  ArrayStatHero(heroRS1);
end;


function RegenStat2()
  j = 1;
  for k = 0, 2 do
    for i = 1, length(array_arts[k]) do
      if HasArtefact   (heroRS2, array_arts[k][i].id) then
        RemoveArtefact (heroRS2, array_arts[k][i].id);
        artHero2[j] = array_arts[k][i].id;
        j = j + 1;
      end;
    end;
  end;
  sleep(1);
  arrayStatRegenHero2 = { GetHeroStat(heroRS2, 1), GetHeroStat(heroRS2, 2), GetHeroStat(heroRS2, 3), GetHeroStat(heroRS2, 4)};
  if HasHeroSkill(heroRS2, 115) then arrayStatRegenHero2[1] = arrayStatRegenHero2[1] - 2; end;
  if HasHeroSkill(heroRS2, 186) then arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - 1; end;
  if HasHeroSkill(heroRS2, 181) then arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - 2; end;
  if HasHeroSkill(heroRS2,  87) then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 2 * SinergyLevel2; end;
  if HasHeroSkill(heroRS2,  81) then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 2 * SinergyLevel2; end;
--    if SinergyLevel2 == 0 or SinergyLevel2 == 1 then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 2;
--    elseif SinergyLevel2 == 2 then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 3;
--    elseif SinergyLevel2 == 3 then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 5;
--    elseif SinergyLevel2 == 4 then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 8;
--    end;
--  if HasHeroSkill(heroRS2,  87) then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 3; end;
  if HasHeroSkill(heroRS2, 119) then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 2; end;
  if HasHeroSkill(heroRS2, 127) then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 2; end;
  if HasHeroSkill(heroRS2,  79) then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 2; end;
  if HasHeroSkill(heroRS2, 146) then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 2; end;
  if HasHeroSkill(heroRS2, 185) then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 2; end;
  if HasHeroSkill(heroRS2, 101) then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 1; end;
  if (HasHeroSkill(heroRS2, 110) or HasHeroSkill(heroRS2, 137)) and GetCurrentMoonWeek() == 20 then arrayStatRegenHero2[1] = arrayStatRegenHero2[1] - 3; end;
  if (HasHeroSkill(heroRS2, 110) or HasHeroSkill(heroRS2, 137)) and GetCurrentMoonWeek() == 23 then arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - 3; end;
  if (HasHeroSkill(heroRS2, 110) or HasHeroSkill(heroRS2, 137)) and GetCurrentMoonWeek() == 15 then arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 3; end;
  if (HasHeroSkill(heroRS2, 110) or HasHeroSkill(heroRS2, 137)) and GetCurrentMoonWeek() == 3  then arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 3; end;
  if (HasHeroSkill(heroRS2, 110) or HasHeroSkill(heroRS2, 137)) and GetCurrentMoonWeek() == 18 then arrayStatRegenHero2[1] = arrayStatRegenHero2[1] - 1; arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - 1; arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - 1; arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - 1; end;
  arrayStatRegenHero2[1] = arrayStatRegenHero2[1] - basicA[getrace(heroRS2)] - statA2;
  arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - basicD[getrace(heroRS2)] - statD2;
  arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - basicS[getrace(heroRS2)] - statS2;
  arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - basicK[getrace(heroRS2)] - statK2;
  ChangeHeroStat( heroRS2, 1, 0 - arrayStatRegenHero2[1]);
  ChangeHeroStat( heroRS2, 2, 0 - arrayStatRegenHero2[2]);
  ChangeHeroStat( heroRS2, 3, 0 - arrayStatRegenHero2[3]);
  ChangeHeroStat( heroRS2, 4, 0 - arrayStatRegenHero2[4]);

  arrayStatRegenHero2[1] = arrayStatRegenHero2[1] - arrayStatForLearning2[GetHeroSkillMastery(heroRS2, 3)][1];
  arrayStatRegenHero2[2] = arrayStatRegenHero2[2] - arrayStatForLearning2[GetHeroSkillMastery(heroRS2, 3)][2];
  arrayStatRegenHero2[3] = arrayStatRegenHero2[3] - arrayStatForLearning2[GetHeroSkillMastery(heroRS2, 3)][3];
  arrayStatRegenHero2[4] = arrayStatRegenHero2[4] - arrayStatForLearning2[GetHeroSkillMastery(heroRS2, 3)][4];
  StatRegenSum2 = arrayStatRegenHero2[1] + arrayStatRegenHero2[2] + arrayStatRegenHero2[3] + arrayStatRegenHero2[4];
  for i = 1, StatRegenSum2 do
    UpHeroStat(heroRS2);
  end;
  GenerateStatLearning2(heroRS2);
  LearningLvl2 = 0;
  Learning2(heroRS2);
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - StatRegenCost));
  x, y = GetObjectPosition(heroRS2);
  Play2DSoundForPlayers ( 2, "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", x, y, 0);
  for i = 1, 15 do
    GiveArtefact (heroRS2, artHero2[i]);
  end;
  sleep(1);
  ArrayStatHero(heroRS2);
end;



arrayStatForLearning1 = {}
arrayStatForLearning1[0] = { 0, 0, 0, 0}
arrayStatForLearning1[1] = { 0, 0, 0, 0}
arrayStatForLearning1[2] = { 0, 0, 0, 0}
arrayStatForLearning1[3] = { 0, 0, 0, 0}

arrayStatForLearning2 = {}
arrayStatForLearning2[0] = { 0, 0, 0, 0}
arrayStatForLearning2[1] = { 0, 0, 0, 0}
arrayStatForLearning2[2] = { 0, 0, 0, 0}
arrayStatForLearning2[3] = { 0, 0, 0, 0}

LearningLvl1 = 0;
LearningLvl2 = 0;
GenerateLearningEnable1 = 0;
GenerateLearningEnable2 = 0;



function GenerateStatLearning1(hero)
  race = getrace(hero);
  for i = 1, 3 do
    for j = 1, 4 do
      arrayStatForLearning1[i][j] = arrayStatForLearning1[i - 1][j];
    end;
    for j = 1, 3 do
      rnd = random(100);
      if rnd < PercentA[race] then
        arrayStatForLearning1[i][1] = arrayStatForLearning1[i][1] + 1;
      end;
      if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
        arrayStatForLearning1[i][2] = arrayStatForLearning1[i][2] + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
        arrayStatForLearning1[i][3] = arrayStatForLearning1[i][3] + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
        arrayStatForLearning1[i][4] = arrayStatForLearning1[i][4] + 1;
      end;
    end;
  end;
--  print(arrayStatForLearning1[0][1], arrayStatForLearning1[0][2], arrayStatForLearning1[0][3], arrayStatForLearning1[0][4])
--  print(arrayStatForLearning1[1][1], arrayStatForLearning1[1][2], arrayStatForLearning1[1][3], arrayStatForLearning1[1][4])
--  print(arrayStatForLearning1[2][1], arrayStatForLearning1[2][2], arrayStatForLearning1[2][3], arrayStatForLearning1[2][4])
--  print(arrayStatForLearning1[3][1], arrayStatForLearning1[3][2], arrayStatForLearning1[3][3], arrayStatForLearning1[3][4])
  GenerateLearningEnable1 = 1;
end;

function GenerateStatLearning2(hero)
  race = getrace(hero);
  for i = 1, 3 do
    for j = 1, 4 do
      arrayStatForLearning2[i][j] = arrayStatForLearning2[i - 1][j];
    end;
    for j = 1, 3 do
      rnd = random(100);
      if rnd < PercentA[race] then
        arrayStatForLearning2[i][1] = arrayStatForLearning2[i][1] + 1;
      end;
      if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
        arrayStatForLearning2[i][2] = arrayStatForLearning2[i][2] + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
        arrayStatForLearning2[i][3] = arrayStatForLearning2[i][3] + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
        arrayStatForLearning2[i][4] = arrayStatForLearning2[i][4] + 1;
      end;
    end;
  end;
--  print(arrayStatForLearning2[0][1], arrayStatForLearning2[0][2], arrayStatForLearning2[0][3], arrayStatForLearning2[0][4])
--  print(arrayStatForLearning2[1][1], arrayStatForLearning2[1][2], arrayStatForLearning2[1][3], arrayStatForLearning2[1][4])
--  print(arrayStatForLearning2[2][1], arrayStatForLearning2[2][2], arrayStatForLearning2[2][3], arrayStatForLearning2[2][4])
--  print(arrayStatForLearning2[3][1], arrayStatForLearning2[3][2], arrayStatForLearning2[3][3], arrayStatForLearning2[3][4])
  GenerateLearningEnable2 = 1;
end;

function Learning1(hero)
  if GetHeroSkillMastery(hero, 3) > LearningLvl1 then
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][1] - arrayStatForLearning1[LearningLvl1][1];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_ATTACK, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusAtt.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][2] - arrayStatForLearning1[LearningLvl1][2];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_DEFENCE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusDef.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][3] - arrayStatForLearning1[LearningLvl1][3];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_SPELL_POWER, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusSpp.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][4] - arrayStatForLearning1[LearningLvl1][4];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusKnw.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    LearningLvl1 = GetHeroSkillMastery(hero, 3);
  end;
  if GetHeroSkillMastery(hero, 3) < LearningLvl1 then
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][1] - arrayStatForLearning1[LearningLvl1][1];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_ATTACK, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusAtt.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][2] - arrayStatForLearning1[LearningLvl1][2];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_DEFENCE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusDef.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][3] - arrayStatForLearning1[LearningLvl1][3];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_SPELL_POWER, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusSpp.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning1[GetHeroSkillMastery(hero, 3)][4] - arrayStatForLearning1[LearningLvl1][4];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusKnw.txt", hero, 1, (2 + random(3)));
--      end;
    end;
    LearningLvl1 = GetHeroSkillMastery(hero, 3);
  end;
end;

function Learning2(hero)
  if GetHeroSkillMastery(hero, 3) > LearningLvl2 then
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][1] - arrayStatForLearning2[LearningLvl2][1];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_ATTACK, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusAtt.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][2] - arrayStatForLearning2[LearningLvl2][2];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_DEFENCE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusDef.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][3] - arrayStatForLearning2[LearningLvl2][3];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_SPELL_POWER, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusSpp.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][4] - arrayStatForLearning2[LearningLvl2][4];
    if plus > 0 then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."PlusKnw.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    LearningLvl2 = GetHeroSkillMastery(hero, 3);
  end;
  if GetHeroSkillMastery(hero, 3) < LearningLvl2 then
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][1] - arrayStatForLearning2[LearningLvl2][1];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_ATTACK, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusAtt.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][2] - arrayStatForLearning2[LearningLvl2][2];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_DEFENCE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusDef.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][3] - arrayStatForLearning2[LearningLvl2][3];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_SPELL_POWER, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusSpp.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    plus = arrayStatForLearning2[GetHeroSkillMastery(hero, 3)][4] - arrayStatForLearning2[LearningLvl2][4];
    if plus < 0 then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, plus);
--      for i = 1, plus do
--        ShowFlyingSign(GetMapDataPath().."MinusKnw.txt", hero, 2, (2 + random(3)));
--      end;
    end;
    LearningLvl2 = GetHeroSkillMastery(hero, 3);
  end;
end;


function UpHeroStat1(hero)
  race = getrace(hero);
  for i = 1, 3 do
    rnd = random(100);
    if rnd < PercentA[race] then
      ChangeHeroStat(hero, STAT_ATTACK, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] + 1;
    end;
    if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
      ChangeHeroStat(hero, STAT_DEFENCE, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] + 1;
    end;
  end;
end;

function UpHeroStat2(hero)
  race = getrace(hero);
  for i = 1, 3 do
    rnd = random(100);
    if rnd < PercentA[race] then
      ChangeHeroStat(hero, STAT_ATTACK, 1);
      arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] = arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] + 1;
    end;
    if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
      ChangeHeroStat(hero, STAT_DEFENCE, 1);
      arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] = arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
      arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] = arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
      arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] = arrayStatForLearning2[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] + 1;
    end;
  end;
end;


function UpHeroStat(hero)
  race = getrace(hero);
  rnd = random(100);
  if rnd < PercentA[race] then
    ChangeHeroStat(hero, STAT_ATTACK, 1);
  end;
  if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
    ChangeHeroStat(hero, STAT_DEFENCE, 1);
  end;
  if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
    ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
  end;
  if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
  end;
end;



function DownHeroStat1(hero)
  race = getrace(hero);
  for i = 1, 3 do
    rnd = random(100);
    if rnd < PercentA[race] then
      ChangeHeroStat(hero, STAT_ATTACK, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][1] + 1;
    end;
    if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) then
      ChangeHeroStat(hero, STAT_DEFENCE, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][2] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][3] + 1;
    end;
    if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
      arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] = arrayStatForLearning1[GetHeroSkillMastery(hero, SKILL_LEARNING)][4] + 1;
    end;
  end;
end;


function add_hero (race, x1, x2, y1, y2, pl, race_opponent)
  looserHero = 0;
  num_heroes = length(array_heroes[race-1]);

  ------- BLOCK HERO -----------
--  if race == 3 and race_opponent == 3 then array_heroes[2][4].blocked = 1; end;
--  if race == 2 and race_opponent == 6 then array_heroes[1][3].blocked = 1; end;
--  if race == 2 and race_opponent == 3 then array_heroes[1][3].blocked = 1; end;


--  if (race == 6) then num_heroes=12; end;
--  if (race == 1) then num_heroes=13; end;

  for i = 0, 7 do
    for j = 1, length(array_heroes[i]) do
      array_heroes[i][j].block_temply = 1;
    end;
  end;

  if pl == 1 then
    l = length(arrayPossibleHeroes[HeroCollectionPlayer1])
    for i = 1, l do
      rnd = random(l) + 1;
      arrayPossibleHeroes[HeroCollectionPlayer1][i], arrayPossibleHeroes[HeroCollectionPlayer1][rnd] = arrayPossibleHeroes[HeroCollectionPlayer1][rnd], arrayPossibleHeroes[HeroCollectionPlayer1][i];
    end;
    DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][1]].name, x1, y1, 0);
    DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][2]].name, x2, y2, 0);
    HeroMax1 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][1]].name;
    HeroMin1 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][2]].name;
    stop(HeroMax1);
    stop(HeroMin1);
    array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][1]].blocked = 1;
    array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer1][2]].blocked = 1;
    HeroForScouting1_Player1 = arrayPossibleHeroes[HeroCollectionPlayer1][1];
    HeroForScouting2_Player1 = arrayPossibleHeroes[HeroCollectionPlayer1][2];
    LockMinHeroSkillsAndAttributes(HeroMax1);
    LockMinHeroSkillsAndAttributes(HeroMin1);
    StartArmy(HeroMax1, race);
    StartArmy(HeroMin1, race);
    GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer1][1]);
    GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer1][2]);
  end;
  if pl == 2 then
    num = 0;
    l = length(arrayPossibleHeroes[HeroCollectionPlayer2])
    for i = 1, l do
      rnd = random(l) + 1;
      arrayPossibleHeroes[HeroCollectionPlayer2][i], arrayPossibleHeroes[HeroCollectionPlayer2][rnd] = arrayPossibleHeroes[HeroCollectionPlayer2][rnd], arrayPossibleHeroes[HeroCollectionPlayer2][i];
    end;
    for i = 1, length(arrayPossibleHeroes[HeroCollectionPlayer2]) do
      if array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].blocked ~= 1 and num < 2 then
        if num == 0 then
          DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2, x1, y1, 0);
        else
          DeployReserveHero(array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2, x2, y2, 0);
        end;
        if num == 0 then
          HeroMax2 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2;
          LockMinHeroSkillsAndAttributes(HeroMax2);
          GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer2][i]);
          array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].blocked = 1;
          HeroForScouting1_Player2 = arrayPossibleHeroes[HeroCollectionPlayer2][i];
          num = 1;
        else
          HeroMin2 = array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name2;
          LockMinHeroSkillsAndAttributes(HeroMin2);
          GiveStartSkill( pl, race-1, arrayPossibleHeroes[HeroCollectionPlayer2][i]);
          array_heroes[race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].blocked = 1;
          HeroForScouting2_Player2 = arrayPossibleHeroes[HeroCollectionPlayer2][i];
          num = 2;
        end;
      end;
    end;
    stop(HeroMax2);
    stop(HeroMin2);
    StartArmy(HeroMax2, race);
    StartArmy(HeroMin2, race);
  end;
end;

function unreserve ()
  SetObjectEnabled('taverna1',  nil);
  Trigger (OBJECT_TOUCH_TRIGGER, 'taverna1', 'TavernaQ');
  SetRegionBlocked ('tavern1', true);

  rnd1 = hero1race-1;
  rnd2 = random(length(array_heroes[hero1race-1]))+1;
  while array_heroes[rnd1][rnd2].blocked == 1 do
    rnd2 = random(length(array_heroes[hero1race-1])) + 1;
  end;

  DeployReserveHero(array_heroes[rnd1][rnd2].name, 40, 82, 0);
  stop(array_heroes[rnd1][rnd2].name);
  array_heroes[rnd1][rnd2].blocked = 1;
  HeroDop1 = array_heroes[rnd1][rnd2].name;
  LockMinHeroSkillsAndAttributes(HeroDop1);
  GiveStartSkill( 1, rnd1, rnd2);
  StartArmy(HeroDop1, hero1race);
  HeroForScouting3Race_Player1 = rnd1;
  HeroForScouting3Hero_Player1 = rnd2;

  SetObjectEnabled('taverna2',  nil);
  Trigger (OBJECT_TOUCH_TRIGGER, 'taverna2', 'TavernaQ');
  SetRegionBlocked ('tavern2', true);

  rnd1 = hero2race-1;
  rnd2 = random(length(array_heroes[hero2race-1]))+1;
  while array_heroes[rnd1][rnd2].blocked == 1 do
    rnd2 = random(length(array_heroes[hero2race-1])) + 1;
  end;

  DeployReserveHero(array_heroes[rnd1][rnd2].name2, 53, 18, 0);
  stop(array_heroes[rnd1][rnd2].name2);
  array_heroes[rnd1][rnd2].blocked = 1;
  HeroDop2 = array_heroes[rnd1][rnd2].name2;
  LockMinHeroSkillsAndAttributes(HeroDop2);
  GiveStartSkill( 2, rnd1, rnd2);
  StartArmy(HeroDop2, hero1race);
  HeroForScouting3Race_Player2 = rnd1;
  HeroForScouting3Hero_Player2 = rnd2;
  
  for i = 0, 7 do
    for j = 1, length(array_heroes[i]) do
      array_heroes[i][j].block_temply = 0;
    end;
  end;
end;

function GiveStartSkill(player, a, b)
  if player == 1 then
    GiveHeroSkill(array_heroes[a][b].name, array_heroes[a][b].skill1);
    GiveHeroSkill(array_heroes[a][b].name, array_heroes[a][b].skill2);
  end;
  if player == 2 then
    GiveHeroSkill(array_heroes[a][b].name2, array_heroes[a][b].skill1);
    GiveHeroSkill(array_heroes[a][b].name2, array_heroes[a][b].skill2);
  end;
end;

function TavernaQ(hero)
  if GetObjectOwner(hero) == 1 and GetPlayerResource(1, 6) >= TavernCost then
    if DisableBagPlayer1 == 0 then
      DisableBagPlayer1 = 1;
      QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), {GetMapDataPath().."Taverna.txt"; eq = TavernCost}, 'Taverna', 'no1');
    end;
  end;
  if GetObjectOwner(hero) == 2 and GetPlayerResource(2, 6) >= TavernCost then
    if DisableBagPlayer2 == 0 then
      DisableBagPlayer2 = 1;
      QuestionBoxForPlayers (GetPlayerFilter( GetObjectOwner(hero) ), {GetMapDataPath().."Taverna.txt"; eq = TavernCost}, 'Taverna', 'no2');
    end;
  end;
end;

function Taverna(player)
  if player == 1 then
    SetRegionBlocked ('tavern1', false);
    hodi1(HeroDop1);
    Trigger (OBJECT_TOUCH_TRIGGER, 'taverna1', 'no');
    SetPlayerResource(PLAYER_1, 6, GetPlayerResource(1, 6) - TavernCost);
    DisableBagPlayer1 = 0;
  end;
  if player == 2 then
    SetRegionBlocked ('tavern2', false);
    hodi1(HeroDop2);
    Trigger (OBJECT_TOUCH_TRIGGER, 'taverna2', 'no');
    SetPlayerResource(PLAYER_2, 6, GetPlayerResource(2, 6) - TavernCost);
    DisableBagPlayer2 = 0;
  end;
end;




------ RESOURCES ---------------------------------------------------------------

function getrace(hero)
	if GetHeroSkillMastery(hero,          SKILL_TRAINING) > 0 then return 1; end;
	if GetHeroSkillMastery(hero,            SKILL_GATING) > 0 then return 2; end;
	if GetHeroSkillMastery(hero,        SKILL_NECROMANCY) > 0 then return 3; end;
	if GetHeroSkillMastery(hero,           SKILL_AVENGER) > 0 then return 4; end;
	if GetHeroSkillMastery(hero,        SKILL_ARTIFICIER) > 0 then return 5; end;
	if GetHeroSkillMastery(hero,        SKILL_INVOCATION) > 0 then return 6; end;
	if GetHeroSkillMastery(hero,     HERO_SKILL_RUNELORE) > 0 then return 7; end;
	if GetHeroSkillMastery(hero, HERO_SKILL_DEMONIC_RAGE) > 0 then return 8; end;
	return 0;
end;

SetObjectOwner('RANDOMTOWN1',  PLAYER_NONE);
SetObjectOwner('RANDOMTOWN2',  PLAYER_NONE);

function TransformPlTown (town, race)
  if race == 1 then TransformTown(town, 0); end;
  if race == 2 then TransformTown(town, 5); end;
  if race == 3 then TransformTown(town, 4); end;
  if race == 4 then TransformTown(town, 1); end;
  if race == 5 then TransformTown(town, 2); end;
  if race == 6 then TransformTown(town, 3); end;
  if race == 7 then TransformTown(town, 6); end;
  if race == 8 then TransformTown(town, 7); end;
end;

function DeleteRace()
  RemoveObject('human1vrag');
  RemoveObject('demon1vrag');
  RemoveObject('nekr1vrag');
  RemoveObject('elf1vrag');
  RemoveObject('mag1vrag');
  RemoveObject('liga1vrag');
  RemoveObject('gnom1vrag');
  RemoveObject('ork1vrag');
  RemoveObject('human2vrag');
  RemoveObject('demon2vrag');
  RemoveObject('nekr2vrag');
  RemoveObject('elf2vrag');
  RemoveObject('mag2vrag');
  RemoveObject('liga2vrag');
  RemoveObject('gnom2vrag');
  RemoveObject('ork2vrag');
  RemoveObject('human1');
  RemoveObject('demon1');
  RemoveObject('nekr1');
  RemoveObject('elf1');
  RemoveObject('mag1');
  RemoveObject('liga1');
  RemoveObject('gnom1');
  RemoveObject('ork1');
  RemoveObject('human2');
  RemoveObject('demon2');
  RemoveObject('nekr2');
  RemoveObject('elf2');
  RemoveObject('mag2');
  RemoveObject('liga2');
  RemoveObject('gnom2');
  RemoveObject('ork2');
end;


arrayGrade1 = {};
arrayGrade2 = {};
arrayGrade1 = {  1,   3,   5,   7,   9,  11,  13,  15,  17,  19,  21,  23,  25,  27,  29,  31,  34,  35,  37,  39,  41,  43,  45,  47,  49,  51,  53,  55,  57,  59,  61,  63,  65,  67,  69,  71,  73,  75,  77,  79,  81,  83,  92,  94,  96,  98, 100, 102, 105, 117, 119, 121, 123, 125, 127, 129}
arrayGrade2 = {106, 107, 108, 109, 110, 111, 112, 131, 132, 133, 134, 135, 136, 137, 152, 153, 154, 155, 156, 157, 158, 145, 146, 147, 148, 149, 150, 151, 159, 160, 161, 162, 163, 164, 165, 138, 139, 140, 141, 142, 143, 144, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179}

function Regrade_CUSTOM_F(hero, CUSTOM_ABILITY)

  if (CUSTOM_ABILITY == CUSTOM_ABILITY_1) and (GetObjectOwner(hero) == 1) then
    HeroR1 = hero;
    x1, y1 = GetObjectPosition(HeroR1);
    DenyGarrisonCreaturesTakeAway('regrade1', 0);
    MakeHeroInteractWithObject (hero, 'regrade1');
    startThread (RegradeUnit1);
  end;

  if (CUSTOM_ABILITY == CUSTOM_ABILITY_1) and (GetObjectOwner(hero) == 2) then
    HeroR2 = hero;
    x2, y2 = GetObjectPosition(HeroR2);
    DenyGarrisonCreaturesTakeAway('regrade2', 0);
    MakeHeroInteractWithObject (hero, 'regrade2');
    startThread (RegradeUnit2);
  end;

end;

function RegradeUnit1()
  x11, y11 = GetObjectPosition(HeroR1);
  while (x11 == x1 and y11 == y1) do
    RegradeUse1 = 0;
    for a = 1, length(arrayGrade1) do
      if GetObjectCreatures('regrade1', arrayGrade1[a]) > 0 then
        AddHeroCreatures(HeroR1, arrayGrade2[a], GetObjectCreatures('regrade1', arrayGrade1[a]));
        --Play3DSoundForPlayers ( 1, "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", x1, y1, 0);
        RegradeUse1 = 1;
        delCreat1 = GetObjectCreatures('regrade1', arrayGrade1[a]);
        RemoveObjectCreatures('regrade1', arrayGrade1[a], delCreat1);
        a = length(arrayGrade1);
      end;
    end;
    if RegradeUse1 == 0 then
      for a = 1, length(arrayGrade2) do
        if GetObjectCreatures('regrade1', arrayGrade2[a]) > 0 then
          AddHeroCreatures(HeroR1, arrayGrade1[a], GetObjectCreatures('regrade1', arrayGrade2[a]));
          --Play3DSoundForPlayers ( 1, "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", x1, y1, 0);
          RegradeUse1 = 1;
          delCreat1 = GetObjectCreatures('regrade1', arrayGrade2[a]);
          RemoveObjectCreatures('regrade1', arrayGrade2[a], delCreat1);
          a = length(arrayGrade2);
        end;
      end;
    end;
    sleep(1);
    x11, y11 = GetObjectPosition(HeroR1);
  end;
end;

function RegradeUnit2()
  x22, y22 = GetObjectPosition(HeroR2);
  while (x22 == x2 and y22 == y2) do
    RegradeUse2 = 0;
    for b = 1, length(arrayGrade1) do
      if GetObjectCreatures('regrade2', arrayGrade1[b]) > 0 then
        AddHeroCreatures(HeroR2, arrayGrade2[b], GetObjectCreatures('regrade2', arrayGrade1[b]));
        RegradeUse2 = 1;
        delCreat2 = GetObjectCreatures('regrade2', arrayGrade1[b]);
        RemoveObjectCreatures('regrade2', arrayGrade1[b], delCreat2);
        b = length(arrayGrade1);
      end;
    end;
    if RegradeUse2 == 0 then
      for b = 1, length(arrayGrade2) do
        if GetObjectCreatures('regrade2', arrayGrade2[b]) > 0 then
          AddHeroCreatures(HeroR2, arrayGrade1[b], GetObjectCreatures('regrade2', arrayGrade2[b]));
          RegradeUse2 = 1;
          delCreat2 = GetObjectCreatures('regrade2', arrayGrade2[b]);
          RemoveObjectCreatures('regrade2', arrayGrade2[b], delCreat2);
          b = length(arrayGrade2);
        end;
      end;
    end;
    sleep(1);
    x22, y22 = GetObjectPosition(HeroR2);
  end;
end;

------ ELF ARMIES ---------------------------------------------------------------

function elf_arm ()
if hero1race == 4 then
	if hero2race == 1 then SetObjectPosition('havenarmy1', 37, 78); end;
	if hero2race == 2 then SetObjectPosition('infarmy1', 37, 78); end;
	if hero2race == 3 then SetObjectPosition('necroarmy1', 37, 78); end;
	if hero2race == 4 then SetObjectPosition('elfarmy1', 37, 78); end;
	if hero2race == 5 then SetObjectPosition('magearmy1', 37, 78); end;
	if hero2race == 6 then SetObjectPosition('ligaarmy1', 37, 78); end;
	if hero2race == 7 then SetObjectPosition('gnomarmy1', 37, 78); end;
	if hero2race == 8 then SetObjectPosition('orcarmy1', 37, 78); end;
end;

if hero2race == 4 then
	if hero1race == 1 then SetObjectPosition('havenarmy2', 25, 11); end;
	if hero1race == 2 then SetObjectPosition('infarmy2', 25, 11); end;
	if hero1race == 3 then SetObjectPosition('necroarmy2', 25, 11); end;
	if hero1race == 4 then SetObjectPosition('elfarmy2', 25, 11); end;
	if hero1race == 5 then SetObjectPosition('magearmy2', 25, 11); end;
	if hero1race == 6 then SetObjectPosition('ligaarmy2', 25, 11); end;
	if hero1race == 7 then SetObjectPosition('gnomarmy2', 25, 11); end;
	if hero1race == 8 then SetObjectPosition('orcarmy2', 25, 11); end;
end;
end;

---------------------- MINIARTS ----------------------------------------------------

minikUse1 = 0;
minikUse2 = 0;

function MiniArts1()
  if minikUse1 == 0 then
    UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_ACADEMY_ARCANE_FORGE);
    pause1 = 0;
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."CreateMinik.txt", 'pause1F');
    while pause1 == 0 do
      sleep(1);
    end;
    
    if Name(HeroMax1) == "Maahir" then DeltaRes = 15; else DeltaRes = 0; end;
    
    -- ������
    if Name(HeroMax1) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax1,  65); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  65, kolCreatures); AddHeroCreatures(HeroMax1, 68, kolCreatures); end; end;
    if Name(HeroMax1) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax1, 163); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 163, kolCreatures); AddHeroCreatures(HeroMax1, 70, kolCreatures); end; end;

    -- ���������� �����
    if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1,  57); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  57, kolCreatures); AddHeroCreatures(HeroMax1, 60, kolCreatures); end; end;
    if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 165); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 165, kolCreatures); AddHeroCreatures(HeroMax1, 64, kolCreatures); end; end;

    if GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) == 1 then
      SetPlayerResource(1,    WOOD, 10 + DeltaRes);
    	SetPlayerResource(1,     ORE, 10 + DeltaRes);
    	SetPlayerResource(1, MERCURY, 10 + DeltaRes);
    	SetPlayerResource(1, CRYSTAL, 10 + DeltaRes);
    	SetPlayerResource(1,  SULFUR, 10 + DeltaRes);
    	SetPlayerResource(1,     GEM, 10 + DeltaRes);
    end;
    if GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) == 2 then
      SetPlayerResource(1,    WOOD, 20 + DeltaRes);
    	SetPlayerResource(1,     ORE, 20 + DeltaRes);
    	SetPlayerResource(1, MERCURY, 20 + DeltaRes);
    	SetPlayerResource(1, CRYSTAL, 20 + DeltaRes);
    	SetPlayerResource(1,  SULFUR, 20 + DeltaRes);
    	SetPlayerResource(1,     GEM, 20 + DeltaRes);
    end;
    if GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) >= 3 then
      SetPlayerResource(1,    WOOD, 30 + DeltaRes);
    	SetPlayerResource(1,     ORE, 30 + DeltaRes);
    	SetPlayerResource(1, MERCURY, 30 + DeltaRes);
    	SetPlayerResource(1, CRYSTAL, 30 + DeltaRes);
    	SetPlayerResource(1,  SULFUR, 30 + DeltaRes);
    	SetPlayerResource(1,     GEM, 30 + DeltaRes);
    end;
    minikUse1 = 1;
    SetObjectPosition('port1', 39, 80, 0);
    Trigger( OBJECT_TOUCH_TRIGGER, 'port1', 'TeleportBattleZone1' );
    SetObjectEnabled('port1', nil);
    SetDisabledObjectMode('port1', 2);
  end;
end;

function MiniArts2()
  if minikUse2 == 0 then
    UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_ACADEMY_ARCANE_FORGE);
    pause2 = 0;
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."CreateMinik.txt", 'pause2F');
    while pause2 == 0 do
      sleep(1);
    end;
    -- �������� �����
--    if (HasHeroSkill(HeroMax2, 104) or HasHeroSkill(HeroMax2, 82)) then
--      DublikatHero2( HeroMax2);
--    end;
    
    if Name(HeroMax2) == "Maahir" then DeltaRes = 15; else DeltaRes = 0; end;

    -- ������
    if Name(HeroMax2) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax2,  65); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  65, kolCreatures); AddHeroCreatures(HeroMax2, 68, kolCreatures); end; end;
    if Name(HeroMax2) == "Tan" then kolCreatures = GetHeroCreatures(HeroMax2, 163); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 163, kolCreatures); AddHeroCreatures(HeroMax2, 70, kolCreatures); end; end;

    -- ���������� �����
    if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2,  57); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  57, kolCreatures); AddHeroCreatures(HeroMax2, 60, kolCreatures); end; end;
    if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 165); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 165, kolCreatures); AddHeroCreatures(HeroMax2, 64, kolCreatures); end; end;

    if GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) == 1 then
      SetPlayerResource(2,    WOOD, 10 + DeltaRes);
    	SetPlayerResource(2,     ORE, 10 + DeltaRes);
    	SetPlayerResource(2, MERCURY, 10 + DeltaRes);
    	SetPlayerResource(2, CRYSTAL, 10 + DeltaRes);
    	SetPlayerResource(2,  SULFUR, 10 + DeltaRes);
    	SetPlayerResource(2,     GEM, 10 + DeltaRes);
    end;
    if GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) == 2 then
      SetPlayerResource(2,    WOOD, 20 + DeltaRes);
    	SetPlayerResource(2,     ORE, 20 + DeltaRes);
    	SetPlayerResource(2, MERCURY, 20 + DeltaRes);
    	SetPlayerResource(2, CRYSTAL, 20 + DeltaRes);
    	SetPlayerResource(2,  SULFUR, 20 + DeltaRes);
    	SetPlayerResource(2,     GEM, 20 + DeltaRes);
    end;
    if GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) >= 3 then
      SetPlayerResource(2,    WOOD, 30 + DeltaRes);
    	SetPlayerResource(2,     ORE, 30 + DeltaRes);
    	SetPlayerResource(2, MERCURY, 30 + DeltaRes);
    	SetPlayerResource(2, CRYSTAL, 30 + DeltaRes);
    	SetPlayerResource(2,  SULFUR, 30 + DeltaRes);
    	SetPlayerResource(2,     GEM, 30 + DeltaRes);
    end;
    minikUse2 = 1;
    SetObjectPosition('port2', 47, 11, 0);
    Trigger( OBJECT_TOUCH_TRIGGER, 'port2', 'TeleportBattleZone2' );
    SetObjectEnabled('port2', nil);
    SetDisabledObjectMode('port2', 2);
  end;
end;

function UpgradeMiniArts1()
  heroes1 = GetPlayerHeroes(PLAYER_1);
  for i = 1, (length(heroes1) - 1) do
    if IsHeroInTown(heroes1[i], 'RANDOMTOWN1', 1, 0) then
      x, y = GetObjectPosition(heroes1[i]);
      MoveHeroRealTime(heroes1[i], x, y - 2);
    end;
  end;
  sleep(2);
  HeroKnowledge1 = GetHeroStat(HeroMax1, 4);
  if HeroMax1 == "Maahir" or HeroMax1 == "Maahir2" then DeltaKnow1 = int(0.25 * GetHeroLevel(HeroMax1)); else DeltaKnow1 = 0; end;
--  DeltaKnow1 = GetHeroSkillMastery(HeroMax1, SKILL_ARTIFICIER) * 5 - 5 - GetHeroStat(HeroMax1, 1) - GetHeroStat(HeroMax1, 2);
--  if (HeroKnowledge1 + DeltaKnow1) < 2 then DeltaKnow1 = 1 - HeroKnowledge1; end;
  ChangeHeroStat(HeroMax1, 4, DeltaKnow1);
  UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_ACADEMY_ARCANE_FORGE);
  DisableAutoEnterTown('RANDOMTOWN1', true);
  MakeHeroInteractWithObject (HeroMax1, 'RANDOMTOWN1');
  ChangeHeroStat(HeroMax1, 4, 0 - DeltaKnow1);
  x, y = GetObjectPosition(HeroMax1);

  if x ~= 43 then
    MoveHeroRealTime(HeroMax1, x-1, y);
    MoveHeroRealTime(HeroMax1, x, y);
  else
    MoveHeroRealTime(HeroMax1, x+1, y);
    MoveHeroRealTime(HeroMax1, x, y);
  end;

end;

function UpgradeMiniArts2()
  heroes2 = GetPlayerHeroes(PLAYER_2);
  for i = 1, (length(heroes2) - 1) do
    if IsHeroInTown(heroes2[i], 'RANDOMTOWN2', 1, 0) then
      x, y = GetObjectPosition(heroes2[i]);
      MoveHeroRealTime(heroes2[i], x, y + 2);
    end;
  end;
  sleep(2);
  HeroKnowledge2 = GetHeroStat(HeroMax2, 4);
  if HeroMax1 == "Maahir" or HeroMax1 == "Maahir2" then DeltaKnow2 = int(0.25 * GetHeroLevel(HeroMax1)); else DeltaKnow2 = 0; end;
--  DeltaKnow2 = GetHeroSkillMastery(HeroMax2, SKILL_ARTIFICIER) * 5 - 5 - GetHeroStat(HeroMax2, 1) - GetHeroStat(HeroMax2, 2);
--  if (HeroKnowledge2 + DeltaKnow2) < 2 then DeltaKnow2 = 1 - HeroKnowledge2; end;
  ChangeHeroStat(HeroMax2, 4, DeltaKnow2);
  UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_ACADEMY_ARCANE_FORGE);
  DisableAutoEnterTown('RANDOMTOWN2', true);
  MakeHeroInteractWithObject (HeroMax2, 'RANDOMTOWN2');
  ChangeHeroStat(HeroMax2, 4, 0 - DeltaKnow2);
  x, y = GetObjectPosition(HeroMax2);
  if x ~= 43 then
    MoveHeroRealTime(HeroMax2, x-1, y);
    MoveHeroRealTime(HeroMax2, x, y);
  else
    MoveHeroRealTime(HeroMax2, x+1, y);
    MoveHeroRealTime(HeroMax2, x, y);
  end;
end;

------- BONUS -----------------------------------------------------------------------

kol_u = {};
price = {};

PlayerInTown = 0;
PlayerInBoat = 0;

function TownAndBoat()
  ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED);
  ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED);
  ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED);
  ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED);
  for i = 1, 305 do
    if GetHeroStat(HeroMax1, STAT_EXPERIENCE) > 1000 or GetHeroStat(HeroMax2, STAT_EXPERIENCE) > 1000
    or GetHeroStat(HeroMin1, STAT_EXPERIENCE) > 1000 or GetHeroStat(HeroMin2, STAT_EXPERIENCE) > 1000
    or GetHeroStat(HeroDop1, STAT_EXPERIENCE) > 1000 or GetHeroStat(HeroDop2, STAT_EXPERIENCE) > 1000 or i == 305 then
      ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
      ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
      ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
      ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
    end;
    sleep (3);
--    print (i);
  end;
end;


function TownAndBoat_CUSTOM_F(hero, CUSTOM_ABILITY)

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == heroes1[0]) then
    if (GetPlayerResource(PLAYER_1, GOLD) >= 35000) then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."TownVopros.txt", 'TownYES1', 'no');
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == heroes1[0]) then
    if (GetPlayerResource(PLAYER_1, GOLD) >= 15000) then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."BoatVopros.txt", 'BoatYES1', 'no');
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == heroes2[0]) then
    if (GetPlayerResource(PLAYER_2, GOLD) >= 35000) then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."TownVopros.txt", 'TownYES2', 'no');
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == heroes2[0]) then
    if (GetPlayerResource(PLAYER_2, GOLD) >= 15000) then
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."BoatVopros.txt", 'BoatYES2', 'no');
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NOmoney.txt" );
    end;
  end;

end;

function TownYES1()
  if  GetHeroStat(HeroMax1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMax2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroMin1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMin2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroDop1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroDop2, STAT_EXPERIENCE) <= 1000 then
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - 35000));
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + 35000));
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."TownInfo.txt" );
    PlayerInTown = 1;
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
  end;
end;

function TownYES2()
  if  GetHeroStat(HeroMax1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMax2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroMin1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMin2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroDop1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroDop2, STAT_EXPERIENCE) <= 1000 then
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - 35000));
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + 35000));
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."TownInfo.txt" );
    PlayerInTown = 2;
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
  end;
end;

function BoatYES1()
  if  GetHeroStat(HeroMax1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMax2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroMin1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMin2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroDop1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroDop2, STAT_EXPERIENCE) <= 1000 then
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - 15000));
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + 15000));
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."BoatInfo.txt" );
    PlayerInBoat = 1;
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
  end;
end;

function BoatYES2()
  if  GetHeroStat(HeroMax1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMax2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroMin1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroMin2, STAT_EXPERIENCE) <= 1000
  and GetHeroStat(HeroDop1, STAT_EXPERIENCE) <= 1000 and GetHeroStat(HeroDop2, STAT_EXPERIENCE) <= 1000 then
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - 15000));
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + 15000));
    MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."BoatInfo.txt" );
    PlayerInBoat = 2;
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
    ControlHeroCustomAbility(heroes2[0], CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
  end;
end;

function BattleInTown1()
  DisableAutoEnterTown('RANDOMTOWN1', true);
  MakeHeroInteractWithObject (HeroMax1, 'RANDOMTOWN1'  );
  MakeHeroInteractWithObject (HeroMax2, HeroMax1);
end;

function BattleInTown2()
  DisableAutoEnterTown('RANDOMTOWN2', true);
  MakeHeroInteractWithObject (HeroMax2, 'RANDOMTOWN2'  );
  MakeHeroInteractWithObject (HeroMax1, HeroMax2);
end;

array_Archer_ID = {}
array_Archer_ID = { 3, 9, 21, 29, 37, 47, 49, 57, 63, 69, 71, 81, 85, 94, 100, 107, 110, 119, 134, 147, 148, 156, 159, 162, 165, 167, 170, 174}

array_HeroSpecCreatures = {}
array_HeroSpecCreatures = {
   { ["name"] = "Orrin",           ["name2"] = "Orrin2",           ["id1"] =   3, ["id2"] = 107 },
   { ["name"] = "Sarge",           ["name2"] = "Sarge2",           ["id1"] =  11, ["id2"] = 111 },
   { ["name"] = "Mardigo",         ["name2"] = "Mardigo2",         ["id1"] =   5, ["id2"] = 108 },
   { ["name"] = "Ving",            ["name2"] = "Ving2",            ["id1"] =   8, ["id2"] = 109 },
   { ["name"] = "Nathaniel",       ["name2"] = "Nathaniel2",       ["id1"] =   1, ["id2"] = 106 },
--   { ["name"] = "RedHeavenHero03", ["name2"] = "RedHeavenHero032", ["id1"] =   9, ["id2"] = 110 },
   { ["name"] = "Oddrema",         ["name2"] = "Oddrema2",         ["id1"] =  21, ["id2"] = 134 },
   { ["name"] = "Calid",           ["name2"] = "Calid2",           ["id1"] =  19, ["id2"] = 133 },
   { ["name"] = "Agrael",          ["name2"] = "Agrael2",          ["id1"] =  27, ["id2"] = 137 },
--   { ["name"] = "Kha-Beleth",      ["name2"] = "Kha-Beleth2",      ["id1"] =  27, ["id2"] = 137 },
--   { ["name"] = "OrnellaNecro",    ["name2"] = "OrnellaNecro2",    ["id1"] =  29, ["id2"] = 152 },
   { ["name"] = "Gles",            ["name2"] = "Gles2",            ["id1"] = 116, ["id2"] =   0 },
   { ["name"] = "Tamika",          ["name2"] = "Tamika2",          ["id1"] =  35, ["id2"] = 155 },
   { ["name"] = "Straker",         ["name2"] = "Straker2",         ["id1"] =  31, ["id2"] = 153 },
   { ["name"] = "Gillion",         ["name2"] = "Gillion2",         ["id1"] =  45, ["id2"] = 146 },
   { ["name"] = "Ossir",           ["name2"] = "Ossir2",           ["id1"] =  47, ["id2"] = 147 },
   { ["name"] = "Itil",            ["name2"] = "Itil2",            ["id1"] =  51, ["id2"] = 149 },
--   { ["name"] = "Ildar",           ["name2"] = "Ildar2",           ["id1"] =  55, ["id2"] = 151 },
--   { ["name"] = "GhostFSLord",     ["name2"] = "GhostFSLord2",     ["id1"] =  49, ["id2"] = 148 },
   { ["name"] = "Havez",           ["name2"] = "Havez2",           ["id1"] =  57, ["id2"] = 159 },
   { ["name"] = "Razzak",          ["name2"] = "Razzak2",          ["id1"] =  63, ["id2"] = 162 },
   { ["name"] = "Tan",             ["name2"] = "Tan2",             ["id1"] =  68, ["id2"] =  70 },
   { ["name"] = "Isher",           ["name2"] = "Isher2",           ["id1"] =  61, ["id2"] = 161 },
   { ["name"] = "Eruina",          ["name2"] = "Eruina2",          ["id1"] =  81, ["id2"] =  82 },
   { ["name"] = "Urunir",          ["name2"] = "Urunir2",          ["id1"] =  73, ["id2"] = 139 },
   { ["name"] = "Menel",           ["name2"] = "Menel2",           ["id1"] =  75, ["id2"] = 140 },
   { ["name"] = "Ferigl",          ["name2"] = "Ferigl2",          ["id1"] =  77, ["id2"] = 141 },
   { ["name"] = "Ohtarig",         ["name2"] = "Ohtarig2",         ["id1"] =  71, ["id2"] = 138 },
   { ["name"] = "Bersy",           ["name2"] = "Bersy2",           ["id1"] =  96, ["id2"] = 168 },
   { ["name"] = "Egil",            ["name2"] = "Egil2",            ["id1"] = 100, ["id2"] = 170 },
   { ["name"] = "Ingvar",          ["name2"] = "Ingvar2",          ["id1"] =  92, ["id2"] = 166 },
   { ["name"] = "Skeggy",          ["name2"] = "Skeggy2",          ["id1"] =  94, ["id2"] = 167 },
   { ["name"] = "Wulfstan",        ["name2"] = "Wulfstan2",        ["id1"] =  98, ["id2"] = 169 },
   { ["name"] = "Hero6",           ["name2"] = "Hero62",           ["id1"] = 127, ["id2"] = 178 },
   { ["name"] = "Hero8",           ["name2"] = "Hero82",           ["id1"] = 121, ["id2"] = 175 },
   { ["name"] = "Hero7",           ["name2"] = "Hero72",           ["id1"] = 119, ["id2"] = 174 },
   { ["name"] = "Hero9",           ["name2"] = "Hero92",           ["id1"] = 117, ["id2"] = 173 },
   { ["name"] = "Hero4",           ["name2"] = "Hero42",           ["id1"] = 125, ["id2"] = 177 }}
--   { ["name"] = "Quroq",           ["name2"] = "Quroq2",           ["id1"] = 123, ["id2"] = 176 }}

array_ArtDragon_ID = {}
array_ArtDragon_ID = {
  { ["id"] = 36, ["place"] = 4 },
  { ["id"] = 37, ["place"] = 5 },
  { ["id"] = 38, ["place"] = 8 },
  { ["id"] = 39, ["place"] = 9 },
  { ["id"] = 40, ["place"] = 3 },
  { ["id"] = 41, ["place"] = 2 },
  { ["id"] = 42, ["place"] = 1 },
  { ["id"] = 43, ["place"] = 7 }}
  
array_ArtPlace = {}
array_ArtPlace = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_RaceArt_ID = {}
array_RaceArt_ID[0] = { 11, 16, 31}
array_RaceArt_ID[1] = { 23, 66}
array_RaceArt_ID[2] = {  7, 33}
array_RaceArt_ID[3] = {  4, 95}
array_RaceArt_ID[4] = { 44, 45, 46, 47}
array_RaceArt_ID[5] = { 81, 82}
array_RaceArt_ID[6] = { 48, 49, 50, 51}
array_RaceArt_ID[7] = { 74, 75}

array_MassSpell_ID = {}
array_MassSpell_ID = {
   { ["mass"] = 210, ["single"] = 11 },
   { ["mass"] = 211, ["single"] = 13 },
   { ["mass"] = 212, ["single"] = 12 },
   { ["mass"] = 213, ["single"] = 17 },
   { ["mass"] = 214, ["single"] = 14 },
   { ["mass"] = 215, ["single"] = 15 },
   { ["mass"] = 216, ["single"] = 23 },
   { ["mass"] = 217, ["single"] = 26 },
   { ["mass"] = 218, ["single"] = 25 },
   { ["mass"] = 219, ["single"] = 29 },
   { ["mass"] = 220, ["single"] = 28 },
   { ["mass"] = 221, ["single"] = 24 }}

array_Tier7_ID = {}
array_Tier7_ID = { 13, 27, 41, 55, 69, 83, 105, 112, 129, 137, 144, 151, 158, 165, 172, 179}

array_Fly_ID = {}
array_Fly_ID = { 7, 8, 13, 27, 34, 35, 41, 43, 55, 59, 65, 83, 88, 91, 102, 109, 112, 115, 127, 137, 144, 145, 151, 154, 155, 158, 160, 163, 171, 178}


function GraalVision(hero, stat)
--  print('1');
  if GetCurrentMoonWeek() == 20 then       --'WEEK_OF_ANTILOPE' ������ �����
    ChangeHeroStat(hero, 1, 3 * stat);
  end;
--  print('2');
  if GetCurrentMoonWeek() == 23 then         --'WEEK_OF_BADGER' ������ ������
    ChangeHeroStat(hero, 2, 3 * stat);
  end;
--  print('3');
  if GetCurrentMoonWeek() == 15 then            --'WEEK_OF_BEE' ������ ����������
    ChangeHeroStat(hero, 3, 3 * stat);
  end;
--  print('4');
  if GetCurrentMoonWeek() == 3 then         --'WEEK_OF_BEETLE' ������ ������
    ChangeHeroStat(hero, 4, 3 * stat);
  end;
--  print('5');
  if GetCurrentMoonWeek() == 18 then      --'WEEK_OF_BUTTERFLY' ������ ����������
    ChangeHeroStat(hero, 1, stat);
    ChangeHeroStat(hero, 2, stat);
    ChangeHeroStat(hero, 3, stat);
    ChangeHeroStat(hero, 4, stat);
  end;
end;


function GraalVisionOld(hero, race)
--  print('1');
  if GetCurrentMoonWeek() == 20 then       --'WEEK_OF_ANTILOPE' ������ �����
    ChangeHeroStat(hero, 1, 3);
  end;
--  print('2');
  if GetCurrentMoonWeek() == 23 then         --'WEEK_OF_BADGER' ������ ������
    ChangeHeroStat(hero, 2, 3);
  end;
--  print('3');
  if GetCurrentMoonWeek() == 15 then            --'WEEK_OF_BEE' ������ ����������
    ChangeHeroStat(hero, 3, 3);
  end;
--  print('4');
  if GetCurrentMoonWeek() == 3 then         --'WEEK_OF_BEETLE' ������ ������
    ChangeHeroStat(hero, 4, 3);
  end;
--  print('5');
  if GetCurrentMoonWeek() == 18 then      --'WEEK_OF_BUTTERFLY' ������ ����������
    ChangeHeroStat(hero, 1, 1);
    ChangeHeroStat(hero, 2, 1);
    ChangeHeroStat(hero, 3, 1);
    ChangeHeroStat(hero, 4, 1);
  end;
--  print('6');
  if GetCurrentMoonWeek() == 10 then     --'WEEK_OF_CATERPILLAR' ������ ����
    if GetHeroStat(hero, 1) >= GetHeroStat(hero, 2) and GetHeroStat(hero, 1) >= GetHeroStat(hero, 3) and GetHeroStat(hero, 1) >= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 1, 3);
    end;
    if GetHeroStat(hero, 2) >= GetHeroStat(hero, 1) and GetHeroStat(hero, 2) >= GetHeroStat(hero, 3) and GetHeroStat(hero, 2) >= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 2, 3);
    end;
    if GetHeroStat(hero, 3) >= GetHeroStat(hero, 1) and GetHeroStat(hero, 3) >= GetHeroStat(hero, 2) and GetHeroStat(hero, 3) >= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 3, 3);
    end;
    if GetHeroStat(hero, 4) >= GetHeroStat(hero, 1) and GetHeroStat(hero, 4) >= GetHeroStat(hero, 2) and GetHeroStat(hero, 4) >= GetHeroStat(hero, 3) then
      ChangeHeroStat(hero, 4, 3);
    end;
  end;
--  print('7');
  if GetCurrentMoonWeek() == 38 then            --'WEEK_OF_DEER' ������ ����������
    if GetHeroStat(hero, 1) <= GetHeroStat(hero, 2) and GetHeroStat(hero, 1) <= GetHeroStat(hero, 3) and GetHeroStat(hero, 1) <= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 1, 5);
    end;
    if GetHeroStat(hero, 2) <= GetHeroStat(hero, 1) and GetHeroStat(hero, 2) <= GetHeroStat(hero, 3) and GetHeroStat(hero, 2) <= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 2, 5);
    end;
    if GetHeroStat(hero, 3) <= GetHeroStat(hero, 1) and GetHeroStat(hero, 3) <= GetHeroStat(hero, 2) and GetHeroStat(hero, 3) <= GetHeroStat(hero, 4) then
      ChangeHeroStat(hero, 3, 5);
    end;
    if GetHeroStat(hero, 4) <= GetHeroStat(hero, 1) and GetHeroStat(hero, 4) <= GetHeroStat(hero, 2) and GetHeroStat(hero, 4) <= GetHeroStat(hero, 3) then
      ChangeHeroStat(hero, 4, 5);
    end;
  end;
--  print('8');
  if GetCurrentMoonWeek() == 5 then       --'WEEK_OF_DRAGONFLY' ������ �������
    for i = 1, length(array_Tier7_ID) do
      if GetHeroCreatures(hero, array_Tier7_ID[i]) > 0 then
        AddHeroCreatures(hero, array_Tier7_ID[i], 2);
        i = length(array_Tier7_ID);
      end;
    end;
  end;
--  print('9');
  if GetCurrentMoonWeek() == 14 then           --'WEEK_OF_EAGLE' ������ ������ ����
    for i = 1, length(array_Fly_ID) do
      if GetHeroCreatures(hero, array_Fly_ID[i]) > 0 then
        AddHeroCreatures(hero, array_Fly_ID[i], int(0.2 * GetHeroCreatures(hero, array_Fly_ID[i])));
      end;
    end;
  end;
--  print('10');
  if GetCurrentMoonWeek() == 28 then          --'WEEK_OF_FALCON' ������ ����
    ChangeHeroStat(hero, 1, 2);
    ChangeHeroStat(hero, 2, 2);
  end;
--  print('11');
  if GetCurrentMoonWeek() == 24 then        --'WEEK_OF_FLAMINGO' ������ �����
    ChangeHeroStat(hero, 3, 3);
    ChangeHeroStat(hero, 4, 3);
  end;
--  print('12');
  if GetCurrentMoonWeek() == 6 then             --'WEEK_OF_FOX' ������ �����������
    AddHeroCreatures(hero, 85 + random(4), int(20 + GetHeroStat(hero, 3) + GetHeroStat(hero, 4)));
  end;
--  print('13');
  if GetCurrentMoonWeek() == 11 then         --'WEEK_OF_HAMSTER' ������ �������
    AddHeroCreatures(hero, 91, int(2 + (GetHeroStat(hero, 3) + GetHeroStat(hero, 4)) / 10));
  end;
--  print('14');
  if GetCurrentMoonWeek() == 29 then        --'WEEK_OF_HEDGEHOG' ������ �������
    ChangeHeroStat(hero, 5, 1); --GetHeroStat(hero, 5));
    ChangeHeroStat(hero, 6, 1); --GetHeroStat(hero, 6));
  end;
--  print('15');
  if GetCurrentMoonWeek() == 32 then            --'WEEK_OF_LION' ������ ����������
    AddHeroCreatures(hero, 113, int(2 * (GetHeroStat(hero, 3) + GetHeroStat(hero, 4))));
  end;
end;


function DeletePerk(hero, perk)
  j = 1;
  for i = 1, 26 do
    array_skills_Hero[i] = GetHeroSkillMastery(HeroMax1, array_skills[i]);
  end;
  for i = 1, 189 do
    if HasHeroSkill( HeroMax1, array_perks[i]) then
      array_perks_Hero[j] = array_perks[i];
      j = j + 1;
      kol_perks_Hero = j;
    end;
  end;
  expHero = GetHeroStat(HeroMax1, STAT_EXPERIENCE);
  attHero = GetHeroStat(HeroMax1, STAT_ATTACK);
  defHero = GetHeroStat(HeroMax1, STAT_DEFENCE);
  spHero  = GetHeroStat(HeroMax1, STAT_SPELL_POWER);
  knHero  = GetHeroStat(HeroMax1, STAT_KNOWLEDGE);
  Trigger( HERO_ADD_SKILL_TRIGGER, hero, 'no');
  Trigger( HERO_REMOVE_SKILL_TRIGGER, hero, 'no');
  TakeAwayHeroExp(hero, expHero - 1);
  WarpHeroExp(hero, expHero);
  TakeAwayHeroExp(hero, expHero - 1);
  WarpHeroExp(hero, expHero);
  for i = 1, 26 do
    for j = 1, array_skills_Hero[i] do
      if array_skills_Hero[i] >= j then
        if GetHeroSkillMastery(hero, array_skills[i]) < array_skills_Hero[i] then
          GiveHeroSkill(hero, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_Hero do
    if array_perks_Hero[i] ~= perk then
      GiveHeroSkill(hero, array_perks_Hero[i]);
    end;
  end;
  ChangeHeroStat(hero, STAT_ATTACK, attHero - GetHeroStat(HeroMax1, STAT_ATTACK));
  ChangeHeroStat(hero, STAT_DEFENCE, defHero - GetHeroStat(HeroMax1, STAT_DEFENCE));
  ChangeHeroStat(hero, STAT_SPELL_POWER, spHero - GetHeroStat(HeroMax1, STAT_SPELL_POWER));
  ChangeHeroStat(hero, STAT_KNOWLEDGE, knHero - GetHeroStat(HeroMax1, STAT_KNOWLEDGE));
  sleep(2);
end;

SetObjectEnabled('skill1', nil);
SetObjectEnabled('skill2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'skill1', 'PreBuySkill1' );
Trigger( OBJECT_TOUCH_TRIGGER, 'skill2', 'PreBuySkill2' );

array_SkillForBuy = {};
array_SkillForBuy[0] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  4,  ["text"] = "BuyLeadership.txt"  },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    },
    { ["ID"] = 10,  ["text"] = "BuyDark.txt"        },
    { ["ID"] = 11,  ["text"] = "BuyLight.txt"       } }
array_SkillForBuy[1] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    },
    { ["ID"] =  8,  ["text"] = "BuySorcery.txt"     },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 10,  ["text"] = "BuyDark.txt"        } }
array_SkillForBuy[2] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  3,  ["text"] = "BuyLearning.txt"    },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    },
    { ["ID"] =  8,  ["text"] = "BuySorcery.txt"     },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 10,  ["text"] = "BuyDark.txt"        },
    { ["ID"] = 12,  ["text"] = "BuySummoning.txt"   } }
array_SkillForBuy[3] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  3,  ["text"] = "BuyLearning.txt"    },
    { ["ID"] =  4,  ["text"] = "BuyLeadership.txt"  },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 11,  ["text"] = "BuyLight.txt"       } }
array_SkillForBuy[4] = {
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  3,  ["text"] = "BuyLearning.txt"    },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  8,  ["text"] = "BuySorcery.txt"     },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 10,  ["text"] = "BuyDark.txt"        },
    { ["ID"] = 11,  ["text"] = "BuyLight.txt"       },
    { ["ID"] = 12,  ["text"] = "BuySummoning.txt"   } }
array_SkillForBuy[5] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  3,  ["text"] = "BuyLearning.txt"    },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  8,  ["text"] = "BuySorcery.txt"     },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 12,  ["text"] = "BuySummoning.txt"   } }
array_SkillForBuy[6] = {
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  3,  ["text"] = "BuyLearning.txt"    },
    { ["ID"] =  4,  ["text"] = "BuyLeadership.txt"  },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    },
    { ["ID"] =  9,  ["text"] = "BuyDestructive.txt" },
    { ["ID"] = 11,  ["text"] = "BuyLight.txt"       } }
array_SkillForBuy[7] = {
    { ["ID"] =  1,  ["text"] = "BuyLogistics.txt"   },
    { ["ID"] =  2,  ["text"] = "BuyMachines.txt"    },
    { ["ID"] =  4,  ["text"] = "BuyLeadership.txt"  },
    { ["ID"] =  5,  ["text"] = "BuyLuck.txt"        },
    { ["ID"] =  6,  ["text"] = "BuyOffence.txt"     },
    { ["ID"] =  7,  ["text"] = "BuyDeffence.txt"    } }


scorer1 = 0;
scorer2 = 0;

function PreBuySkill1(hero)
  heroBS1 = hero;
  ArrayStatHero(heroBS1);
  scorerSkill1 = 0;
  if GetHeroStat(hero, STAT_EXPERIENCE) < 2000 then SkillCostCurrent1 = SkillCostStart else SkillCostCurrent1 = SkillCost end;
  for i = 1, 12 do
    if GetHeroSkillMastery (hero, i) > 0 then
      scorerSkill1 = scorerSkill1 + 1;
    end;
  end;
  if GetPlayerResource(PLAYER_1, GOLD) >= SkillCostCurrent1 and scorerSkill1 < 5 then
    BuySkill1();
  else
    if scorerSkill1 < 5 then
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath().."no_money.txt"; eq = SkillCostCurrent1});
    else
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_1), GetMapDataPath().."MaxSkill.txt");
    end;
  end;
end;

function BuySkill1()
  race = getrace(heroBS1);
  scorer1 = scorer1 + 1;
  if scorer1 <= length(array_SkillForBuy[race - 1]) then
    if GetHeroSkillMastery (heroBS1, array_SkillForBuy[race - 1][scorer1].ID) < 1 then
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_1), {GetMapDataPath()..array_SkillForBuy[race - 1][scorer1].text; eq = SkillCostCurrent1}, 'BuySkillReady1', 'BuySkill1');
    else
      BuySkill1();
    end;
  else
    scorer1 = 0;
  end;
end;

function BuySkillReady1()
  if GenerateLearningEnable1 == 0 then GenerateStatLearning1(heroBS1); end;
  GiveHeroSkill(heroBS1, array_SkillForBuy[getrace(heroBS1) - 1][scorer1].ID);
  Trigger( OBJECT_TOUCH_TRIGGER, 'skill1', 'no' );
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - SkillCostCurrent1));
  ChangeLevel(heroBS1, 1);
  sleep(1);
  if array_SkillForBuy[getrace(heroBS1) - 1][scorer1].ID ~= 3 then UpHeroStat(heroBS1); end;
  PerkSum1 = PerkSum1 + 1;
end;

function PreBuySkill2(hero)
  heroBS2 = hero;
  ArrayStatHero(heroBS2);
  scorerSkill2 = 0;
  if GetHeroStat(hero, STAT_EXPERIENCE) < 2000 then SkillCostCurrent2 = SkillCostStart else SkillCostCurrent2 = SkillCost end;
  for i = 1, 12 do
    if GetHeroSkillMastery (hero, i) > 0 then
      scorerSkill2 = scorerSkill2 + 1;
    end;
  end;
  if GetPlayerResource(PLAYER_2, GOLD) >= SkillCostCurrent2 and scorerSkill2 < 5 then
    BuySkill2();
  else
    if scorerSkill2 < 5 then
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath().."no_money.txt"; eq = SkillCostCurrent2});
    else
      MessageBoxForPlayers (GetPlayerFilter (PLAYER_2), GetMapDataPath().."MaxSkill.txt");
    end;
  end;
end;

function BuySkill2()
  race = getrace(heroBS2);
  scorer2 = scorer2 + 1;
  if scorer2 <= length(array_SkillForBuy[race - 1]) then
    if GetHeroSkillMastery (heroBS2, array_SkillForBuy[race - 1][scorer2].ID) < 1 then
      QuestionBoxForPlayers (GetPlayerFilter (PLAYER_2), {GetMapDataPath()..array_SkillForBuy[race - 1][scorer2].text; eq = SkillCostCurrent2}, 'BuySkillReady2', 'BuySkill2');
    else
      BuySkill2();
    end;
  else
    scorer2 = 0;
  end;
end;

function BuySkillReady2()
  if GenerateLearningEnable2 == 0 then GenerateStatLearning2(heroBS2); end;
  GiveHeroSkill(heroBS2, array_SkillForBuy[getrace(heroBS2) - 1][scorer2].ID);
  Trigger( OBJECT_TOUCH_TRIGGER, 'skill2', 'no' );
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - SkillCostCurrent2));
  ChangeLevel(heroBS2, 1);
  sleep(1);
  if array_SkillForBuy[getrace(heroBS2) - 1][scorer2].ID ~= 3 then UpHeroStat(heroBS2); end;
  PerkSum2 = PerkSum2 + 1;
end;


function transferAllArts (heroMain, hero1, hero2)
  for i = 0, 2 do
    for j = 1, length(array_arts[i]) do
      if HasArtefact (hero1, array_arts[i][j].id) then
        GiveArtefact (heroMain, array_arts[i][j].id);
        RemoveArtefact (hero1, array_arts[i][j].id);
      end;
      if HasArtefact (hero2, array_arts[i][j].id) then
        GiveArtefact (heroMain, array_arts[i][j].id);
        RemoveArtefact (hero2, array_arts[i][j].id);
      end;
    end;
  end;
end;

function transferArmy (town, heroMin, heroMax)
  kol = 0;
  for i = 1, 179 do
    if GetObjectCreatures(town, i) > 0 and i ~= 87 then
      AddHeroCreatures(heroMin, i, GetObjectCreatures(town, i));
      RemoveObjectCreatures(town, i, GetObjectCreatures(town, i));
    end;
  end;
  for i = 1, 179 do
    if GetHeroCreatures (heroMin, i) == 1 then
      kol = kol + 1;
    end;
    if GetHeroCreatures (heroMin, i) > 2 then
      kol = 2;
    end;
    if kol == 2 then
      i = 179;
      MakeHeroInteractWithObject (heroMin, heroMax);
      sleep(1);
      if GetObjectOwner(heroMin) == 1 then
        pause1 = 0;
        MessageBoxForPlayers(GetPlayerFilter( GetObjectOwner(heroMin) ), GetMapDataPath().."transferArmy.txt", 'pause1F' );
        while pause1 == 0 do
          sleep(1);
        end;
--        print('wait2');
      end;
      if GetObjectOwner(heroMin) == 2 then
        pause2 = 0;
        MessageBoxForPlayers(GetPlayerFilter( GetObjectOwner(heroMin) ), GetMapDataPath().."transferArmy.txt", 'pause2F' );
        while pause2 == 0 do
          sleep(1);
        end;
--        print('wait2');
      end;
    end;
  end;
  for i = 1, 179 do
    if GetObjectCreatures(heroMin, i) > 1 and i ~= 87 then
      RemoveHeroCreatures(heroMin, i, (GetObjectCreatures(heroMin, i) - 1));
    end;
  end;
end;

function DestroyBuilding (town)
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_1, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_2, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_3, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_4, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_5, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_6, 1, 0);
  DestroyTownBuildingToLevel(town, TOWN_BUILDING_DWELLING_7, 1, 0);
end;

function BlockBattleZone(race1, race2)
  if race1 == 1 or race2 == 1 or race1 == 4 or race2 == 4 then SetRegionBlocked ('land_block_race1', true); end;
  if race1 == 2 or race2 == 2 then SetRegionBlocked ('land_block_race2', true); end;
  if race1 == 3 or race2 == 3 then SetRegionBlocked ('land_block_race3', true); end;
  if race1 == 5 or race2 == 5 then SetRegionBlocked ('land_block_race5', true); end;
  if race1 == 6 or race2 == 6 then SetRegionBlocked ('land_block_race6', true); end;
  if race1 == 7 or race7 == 2 then SetRegionBlocked ('land_block_race7', true); end;
  if race1 == 8 or race2 == 8 then SetRegionBlocked ('land_block_race8', true); end;
end



ControlHeroCustomAbility(heroes1[0], CUSTOM_ABILITY_1, CUSTOM_ABILITY_ENABLED); Trigger(CUSTOM_ABILITY_TRIGGER, "Function_CUSTOM_F");

kolUnit1 = {}
kolUnit1 = { 0, 0, 0, 0, 0, 0, 0}
kolUnit2 = {}
kolUnit2 = { 0, 0, 0, 0, 0, 0, 0}


-- ���������� ����������� ������ ���
function newday ()
  if GetDate (DAY) == 2 then
    doFile(GetMapDataPath().."day2/day2_scripts.lua");
  end;

  if GetDate (DAY) == 3 then
    doFile(GetMapDataPath().."day3/day3_scripts.lua");
  end;

  if GetDate (DAY) == 4 then

     if not IsHeroAlive(HeroMax1) then print(Disconnect_SkillPlayer1); print('GoldPlayer1 = ', Disconnect_GoldPlayer1); print('RegenSpell = ', SpellResetUse1); end;
     if not IsHeroAlive(HeroMax2) then print(Disconnect_SkillPlayer2); print('GoldPlayer2 = ', Disconnect_GoldPlayer2); print('RegenSpell = ', SpellResetUse2); end;

     sleep(2)

     startThread (DayFour);
     
     if ((HasHeroSkill(HeroMax1, 19) and HasHeroSkill(HeroMax2, 19) == nil) and Name(HeroMax2) ~= "Jazaz") or Name(HeroMax1) == "Jazaz" then
       TELEPORT_BATTLE_ZONE_PLAYER_1_X, TELEPORT_BATTLE_ZONE_PLAYER_2_X = TELEPORT_BATTLE_ZONE_PLAYER_2_X, TELEPORT_BATTLE_ZONE_PLAYER_1_X
       TELEPORT_BATTLE_ZONE_PLAYER_1_Y, TELEPORT_BATTLE_ZONE_PLAYER_2_Y = TELEPORT_BATTLE_ZONE_PLAYER_2_Y, TELEPORT_BATTLE_ZONE_PLAYER_1_Y
     end
     
     BlockBattleZone(hero1race, hero2race)
     
     if HasHeroSkill(HeroMax1, 19) or HasHeroSkill(HeroMax2, 19) or Name(HeroMax1) == "Jazaz" or Name(HeroMax2) == "Jazaz" then
       SetRegionBlocked ('land_block_race1', false);
       SetRegionBlocked ('land_block_race2', false);
       SetRegionBlocked ('land_block_race3', false);
       SetRegionBlocked ('land_block_race5', false);
       SetRegionBlocked ('land_block_race6', false);
       SetRegionBlocked ('land_block_race7', false);
       SetRegionBlocked ('land_block_race8', false);
     end;
     
     
     sleep(5);

     startThread (DayFour2);
     startThread (DayFour1);
  end;

  if GetDate (DAY) == 5 then
     -- ����������
     if (HasHeroSkill(HeroMax1, 169)) then ChangeLevel(HeroMax1, 8); if Name(HeroMax1) == "Una" then SpecInga1(); end; end;
     if (HasHeroSkill(HeroMax2, 169)) then ChangeLevel(HeroMax2, 8); if Name(HeroMax2) == "Una" then SpecInga2(); end; end;

     sleep(2);

     stop(HeroMax1); stop(HeroMax2); stop(HeroMin1); stop(HeroMin2);

     -- ���� ���� � ���������
     if GetHeroCreatures(HeroMax1, 7) > 0 then kolCreatures = GetHeroCreatures(HeroMax1, 7); RemoveHeroCreatures(HeroMax1, 7, kolCreatures); AddHeroCreatures(HeroMax1, 8, kolCreatures); end;
     if GetHeroCreatures(HeroMax2, 7) > 0 then kolCreatures = GetHeroCreatures(HeroMax2, 7); RemoveHeroCreatures(HeroMax2, 7, kolCreatures); AddHeroCreatures(HeroMax2, 8, kolCreatures); end;


     ------------- ��������� ---------------

     -- ������ ��������������
     if HasArtefact(HeroMax1, 34, 1) then ChangeLevel(HeroMax1, 6); end;
     if HasArtefact(HeroMax2, 34, 1) then ChangeLevel(HeroMax2, 6); end;
     
     -- ������ ���������
     if HasArtefact(HeroMax1, 88, 1) then CrownLeader(HeroMax1); end;
     if HasArtefact(HeroMax2, 88, 1) then CrownLeader(HeroMax2); end;

     ------------- ����� ---------------

     -- ������
     if (HeroMax1 == "Brem" or HeroMax1 == "Brem2") and GetHeroSkillMastery(HeroMax1, SKILL_TRAINING) == 3 then SubHero(HeroMax1, "Brem3"); HeroMax1 = "Brem3"; sleep(3); end;
     if (HeroMax1 == "Brem" or HeroMax1 == "Brem2") and GetHeroSkillMastery(HeroMax1, SKILL_TRAINING) < 3 and GetHeroSkillMastery(HeroMax1, SKILL_TRAINING) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax1, 'no'); GiveHeroSkill(HeroMax1, SKILL_TRAINING); end;

     if (HeroMax2 == "Brem" or HeroMax2 == "Brem2") and GetHeroSkillMastery(HeroMax2, SKILL_TRAINING) == 3 then SubHero(HeroMax2, "Brem4"); HeroMax2 = "Brem4"; sleep(3); end;
     if (HeroMax2 == "Brem" or HeroMax2 == "Brem2") and GetHeroSkillMastery(HeroMax2, SKILL_TRAINING) < 3 and GetHeroSkillMastery(HeroMax2, SKILL_TRAINING) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax2, 'no'); GiveHeroSkill(HeroMax2, SKILL_TRAINING); end;

     -- �����
     if (HeroMax1 == "Shadwyn" or HeroMax1 == "Shadwyn2") and GetHeroSkillMastery(HeroMax1, SKILL_INVOCATION) == 3 then SubHero(HeroMax1, "Shadwyn3"); HeroMax1 = "Shadwyn3"; sleep(3); end;
     if (HeroMax1 == "Shadwyn" or HeroMax1 == "Shadwyn2") and GetHeroSkillMastery(HeroMax1, SKILL_INVOCATION) < 3 and GetHeroSkillMastery(HeroMax1, SKILL_INVOCATION) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax1, 'no'); GiveHeroSkill(HeroMax1, SKILL_INVOCATION); end;

     if (HeroMax2 == "Shadwyn" or HeroMax2 == "Shadwyn2") and GetHeroSkillMastery(HeroMax2, SKILL_INVOCATION) == 3 then SubHero(HeroMax2, "Shadwyn4"); HeroMax2 = "Shadwyn4"; sleep(3); end;
     if (HeroMax2 == "Shadwyn" or HeroMax2 == "Shadwyn2") and GetHeroSkillMastery(HeroMax2, SKILL_INVOCATION) < 3 and GetHeroSkillMastery(HeroMax2, SKILL_INVOCATION) > 0 then Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax2, 'no'); GiveHeroSkill(HeroMax2, SKILL_INVOCATION); end;

     -- �����
     if Name(HeroMax1) == "Hero9" then
     if GetHeroCreatures(HeroMax1, 117) > 0 then AddHeroCreatures(HeroMax1, 117, 6 * GetHeroLevel(HeroMax1)); else AddHeroCreatures(HeroMax1, 173, 6 * GetHeroLevel(HeroMax1)); end; end;
     if Name(HeroMax2) == "Hero9" then
     if GetHeroCreatures(HeroMax2, 117) > 0 then AddHeroCreatures(HeroMax2, 117, 6 * GetHeroLevel(HeroMax2)); else AddHeroCreatures(HeroMax2, 173, 6 * GetHeroLevel(HeroMax2)); end; end;

     -- �������
     if Name(HeroMax1) == "Orlando" then
     if GetHeroCreatures(HeroMax1, 27) >= GetHeroCreatures(HeroMax1, 137) then AddHeroCreatures(HeroMax1, 27, 1 + floor(GetHeroLevel(HeroMax1)/10)); else AddHeroCreatures(HeroMax1, 137, 1 + floor(GetHeroLevel(HeroMax1)/10)); end; end;
     if Name(HeroMax2) == "Orlando" then
     if GetHeroCreatures(HeroMax2, 27) >= GetHeroCreatures(HeroMax2, 137) then AddHeroCreatures(HeroMax2, 27, 1 + floor(GetHeroLevel(HeroMax2)/10)); else AddHeroCreatures(HeroMax2, 137, 1 + floor(GetHeroLevel(HeroMax2)/10)); end; end;


     TeachSpell (HeroMax1, 0);
     TeachSpell (HeroMax2, 1);
     Scholar (HeroMax1, 0);
     Scholar (HeroMax2, 1);

     sleep(5);

     if hero1race == 7 then
       if GetHeroSkillMastery(HeroMax1, HERO_SKILL_RUNELORE) >  0 then SetPlayerResource(1, WOOD, 7); SetPlayerResource(1, ORE, 7); SetPlayerResource(1, MERCURY,  5); SetPlayerResource(1, CRYSTAL,  5); SetPlayerResource(1, SULFUR,  5); SetPlayerResource(1, GEM,  5); end;
       if GetHeroSkillMastery(HeroMax1, HERO_SKILL_RUNELORE) == 4 then SetPlayerResource(1, WOOD, 15); SetPlayerResource(1, ORE, 15); SetPlayerResource(1, MERCURY, 10); SetPlayerResource(1, CRYSTAL, 10); SetPlayerResource(1, SULFUR, 10); SetPlayerResource(1, GEM, 10); end;
     end;

     if hero2race == 7 then
       if GetHeroSkillMastery(HeroMax2, HERO_SKILL_RUNELORE) >  0 then SetPlayerResource(2, WOOD, 7); SetPlayerResource(2, ORE, 7); SetPlayerResource(2, MERCURY,  5); SetPlayerResource(2, CRYSTAL,  5); SetPlayerResource(2, SULFUR,  5); SetPlayerResource(2, GEM,  5); end;
       if GetHeroSkillMastery(HeroMax2, HERO_SKILL_RUNELORE) == 4 then SetPlayerResource(2, WOOD, 15); SetPlayerResource(2, ORE, 15); SetPlayerResource(2, MERCURY, 10); SetPlayerResource(2, CRYSTAL, 10); SetPlayerResource(2, SULFUR, 10); SetPlayerResource(2, GEM, 10); end;
     end;

     ------------- ������ ---------------

     -- ���� �����
     if (HasHeroSkill(HeroMax1, 28)) then recruitment1(HeroMax1); end;
     if (HasHeroSkill(HeroMax2, 28)) then recruitment2(HeroMax2); end;
     
     -- ������ ��� ����
     if (HasHeroSkill(HeroMax1, 181)) and (GetHeroCreatures(HeroMax1, 117) > 0) then AddHeroCreatures(HeroMax1, 117, 30); else
     if (HasHeroSkill(HeroMax1, 181)) and (GetHeroCreatures(HeroMax1, 173) > 0) then AddHeroCreatures(HeroMax1, 173, 30); end; end;
     if (HasHeroSkill(HeroMax2, 181)) and (GetHeroCreatures(HeroMax2, 117) > 0) then AddHeroCreatures(HeroMax2, 117, 30); else
     if (HasHeroSkill(HeroMax2, 181)) and (GetHeroCreatures(HeroMax2, 173) > 0) then AddHeroCreatures(HeroMax2, 173, 30); end; end;
     
     -- ������ �����
     if (HasHeroSkill(HeroMax1, 115)) and (GetHeroCreatures(HeroMax1,  45) > 0) then AddHeroCreatures(HeroMax1,  45, 10); else
     if (HasHeroSkill(HeroMax1, 115)) and (GetHeroCreatures(HeroMax1, 146) > 0) then AddHeroCreatures(HeroMax1, 146, 10); end; end;
     if (HasHeroSkill(HeroMax2, 115)) and (GetHeroCreatures(HeroMax2,  45) > 0) then AddHeroCreatures(HeroMax2,  45, 10); else
     if (HasHeroSkill(HeroMax2, 115)) and (GetHeroCreatures(HeroMax2, 146) > 0) then AddHeroCreatures(HeroMax2, 146, 10); end; end;

     -- ��������������� ����
--     if (HasHeroSkill(HeroMax1, 80)) then GraalVision(HeroMax1, hero1race); end;
--     if (HasHeroSkill(HeroMax2, 80)) then GraalVision(HeroMax2, hero2race); end;
     
     ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 1000);
     ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 1000);
     

     -- ���� ���������������
--     if (HasHeroSkill(HeroMax1, 21)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_INITIATIVE, 1); end;
--     if (HasHeroSkill(HeroMax2, 21)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_INITIATIVE, 1); end;

     -- ������ ������������
--     if (HasHeroSkill(HeroMax1, 81)) then ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, SinergyLevel1 + 1); ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 10 * (SinergyLevel1 + 1)); ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, 0 - (SinergyLevel1 + 1)); end;
--     if (HasHeroSkill(HeroMax2, 81)) then ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, SinergyLevel2 + 1); ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 10 * (SinergyLevel2 + 1)); ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, 0 - (SinergyLevel2 + 1)); end;

     sleep(2);

     -- ���������� ����
     --if HasHeroSkill(HeroMax1, 145) then mana = 10 + random(21); ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, 5); ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, mana); ShowFlyingSign({GetMapDataPath().."RandomMana.txt"; eq = mana}, HeroMax1, 1, 5.0); ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, -5); end;
     --if HasHeroSkill(HeroMax2, 145) then mana = 10 + random(21); ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, 5); ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, mana); ShowFlyingSign({GetMapDataPath().."RandomMana.txt"; eq = mana}, HeroMax2, 2, 5.0); ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, -5); end;
     --sleep(2);
     
     -- �������
     if HasHeroSkill(HeroMax1, 109) then ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, 5); ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 30); ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, -5); end;
     if HasHeroSkill(HeroMax2, 109) then ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, 5); ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 30); ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, -5); end;
     sleep(2);

     -- �������������
     if (HasHeroSkill(HeroMax1, 131)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, 10); end;
     if (HasHeroSkill(HeroMax2, 131)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, 10); end;
     
     -- ����������� �������
     --if (HasHeroSkill(HeroMax1, 103)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_LUCK, -1); end;
     --if (HasHeroSkill(HeroMax2, 103)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_LUCK, -1); end;

     -- ������������
     if (HasHeroSkill(HeroMax1, 186)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, 5); end;
     if (HasHeroSkill(HeroMax2, 186)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, 5); end;

     -- ������ ���������� (��������� �������)
--     if (HasHeroSkill(HeroMax1, 87)) then Insights(HeroMax1); end;
--     if (HasHeroSkill(HeroMax2, 87)) then Insights(HeroMax2); end;

     -- ���� �����
--     if (HasHeroSkill(HeroMax1, 177) and HasHeroSkill(HeroMax2, 19) == nil and HasHeroSkill(HeroMax2, 21) == nil and Name(HeroMax2) ~= "Jazaz") then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_ATTACK, 2); GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_DEFENCE, 2); end;
--     if (HasHeroSkill(HeroMax2, 177) and HasHeroSkill(HeroMax1, 19) == nil and HasHeroSkill(HeroMax1, 21) == nil and Name(HeroMax1) ~= "Jazaz") then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_ATTACK, 2); GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_DEFENCE, 2); end;

     -- �����������
     if (HasHeroSkill(HeroMax1, 168)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_SPEED, -1); end;
     if (HasHeroSkill(HeroMax2, 168)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_SPEED, -1); end;
     
     -- ������ �����
     if (HasHeroSkill(HeroMax1, 73)) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_SPEED, 1); end;
     if (HasHeroSkill(HeroMax2, 73)) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_SPEED, 1); end;

     -- ����� �� ������� (������ ����������� ����)
--     if (HasHeroSkill(HeroMax1, 213)) then DestroyTownBuildingToLevel('RANDOMTOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM, 0); end;
--     if (HasHeroSkill(HeroMax2, 213)) then DestroyTownBuildingToLevel('RANDOMTOWN1', TOWN_BUILDING_INFERNO_INFERNAL_LOOM, 0); end;

     -- ������ ������� (����������)
--     if (HasHeroSkill(HeroMax1, 24)) and (HasHeroSkill(HeroMax2, 126)) then DeletePerk(HeroMax2, WIZARD_FEAT_REMOTE_CONTROL); end;
--     if (HasHeroSkill(HeroMax1, 24)) and (HasHeroSkill(HeroMax2, 107)) then DeletePerk(HeroMax2, NECROMANCER_FEAT_DEADLY_COLD); end;
--     if (HasHeroSkill(HeroMax2, 24)) and (HasHeroSkill(HeroMax1, 126)) then DeletePerk(HeroMax1, WIZARD_FEAT_REMOTE_CONTROL); end;
--     if (HasHeroSkill(HeroMax2, 24)) and (HasHeroSkill(HeroMax1, 107)) then DeletePerk(HeroMax1, NECROMANCER_FEAT_DEADLY_COLD); end;

     -- �������� ���
--     if (HasHeroSkill(HeroMax1,  40)) and HeroHasSpellShield1 == 1 then DeletePerk(HeroMax1,         PERK_MYSTICISM); GiveHeroSkill(HeroMax1, 166); end;
--     if (HasHeroSkill(HeroMax1, 166)) and HeroHasSpellShield1 == 0 then DeletePerk(HeroMax1, HERO_SKILL_RUNIC_ARMOR); GiveHeroSkill(HeroMax1,  40); end;
--     if (HasHeroSkill(HeroMax2,  40)) and HeroHasSpellShield2 == 1 then DeletePerk(HeroMax2,         PERK_MYSTICISM); GiveHeroSkill(HeroMax2, 166); end;
--     if (HasHeroSkill(HeroMax2, 166)) and HeroHasSpellShield2 == 0 then DeletePerk(HeroMax2, HERO_SKILL_RUNIC_ARMOR); GiveHeroSkill(HeroMax2,  40); end;

     -- ������ ��������
     --if (HasHeroSkill(HeroMax1, 182)) and (GetHeroCreatures(HeroMax1, 117) > 0) then kolCreatures = GetHeroCreatures(HeroMax1, 117); RemoveHeroCreatures(HeroMax1, 117, kolCreatures); AddHeroCreatures(HeroMax1, 118, kolCreatures); end;
     --if (HasHeroSkill(HeroMax1, 182)) and (GetHeroCreatures(HeroMax1, 173) > 0) then kolCreatures = GetHeroCreatures(HeroMax1, 173); RemoveHeroCreatures(HeroMax1, 173, kolCreatures); AddHeroCreatures(HeroMax1,  30, kolCreatures); end;
     --if (HasHeroSkill(HeroMax2, 182)) and (GetHeroCreatures(HeroMax2, 117) > 0) then kolCreatures = GetHeroCreatures(HeroMax2, 117); RemoveHeroCreatures(HeroMax2, 117, kolCreatures); AddHeroCreatures(HeroMax2, 118, kolCreatures); end;
     --if (HasHeroSkill(HeroMax2, 182)) and (GetHeroCreatures(HeroMax2, 173) > 0) then kolCreatures = GetHeroCreatures(HeroMax2, 173); RemoveHeroCreatures(HeroMax2, 173, kolCreatures); AddHeroCreatures(HeroMax2,  30, kolCreatures); end;

     -- ������ ������
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1,  51) > 0) then kolCreatures = GetHeroCreatures(HeroMax1,  51); RemoveHeroCreatures(HeroMax1,  51, kolCreatures); AddHeroCreatures(HeroMax1,  52, kolCreatures); end;
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1, 149) > 0) then kolCreatures = GetHeroCreatures(HeroMax1, 149); RemoveHeroCreatures(HeroMax1, 149, kolCreatures); AddHeroCreatures(HeroMax1,  66, kolCreatures); end;
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1,  53) > 0) then kolCreatures = GetHeroCreatures(HeroMax1,  53); RemoveHeroCreatures(HeroMax1,  53, kolCreatures); AddHeroCreatures(HeroMax1,  54, kolCreatures); end;
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1, 150) > 0) then kolCreatures = GetHeroCreatures(HeroMax1, 150); RemoveHeroCreatures(HeroMax1, 150, kolCreatures); AddHeroCreatures(HeroMax1,  44, kolCreatures); end;
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1,  55) > 0) then kolCreatures = GetHeroCreatures(HeroMax1,  55); RemoveHeroCreatures(HeroMax1,  55, kolCreatures); AddHeroCreatures(HeroMax1,  56, kolCreatures); end;
     if (HasHeroSkill(HeroMax1, 117)) and (GetHeroCreatures(HeroMax1, 151) > 0) then kolCreatures = GetHeroCreatures(HeroMax1, 151); RemoveHeroCreatures(HeroMax1, 151, kolCreatures); AddHeroCreatures(HeroMax1,  84, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2,  51) > 0) then kolCreatures = GetHeroCreatures(HeroMax2,  51); RemoveHeroCreatures(HeroMax2,  51, kolCreatures); AddHeroCreatures(HeroMax2,  52, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2, 149) > 0) then kolCreatures = GetHeroCreatures(HeroMax2, 149); RemoveHeroCreatures(HeroMax2, 149, kolCreatures); AddHeroCreatures(HeroMax2,  66, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2,  53) > 0) then kolCreatures = GetHeroCreatures(HeroMax2,  53); RemoveHeroCreatures(HeroMax2,  53, kolCreatures); AddHeroCreatures(HeroMax2,  54, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2, 150) > 0) then kolCreatures = GetHeroCreatures(HeroMax2, 150); RemoveHeroCreatures(HeroMax2, 150, kolCreatures); AddHeroCreatures(HeroMax2,  44, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2,  55) > 0) then kolCreatures = GetHeroCreatures(HeroMax2,  55); RemoveHeroCreatures(HeroMax2,  55, kolCreatures); AddHeroCreatures(HeroMax2,  56, kolCreatures); end;
     if (HasHeroSkill(HeroMax2, 117)) and (GetHeroCreatures(HeroMax2, 151) > 0) then kolCreatures = GetHeroCreatures(HeroMax2, 151); RemoveHeroCreatures(HeroMax2, 151, kolCreatures); AddHeroCreatures(HeroMax2,  84, kolCreatures); end;



     -- ������ �������
--     if (HasHeroSkill(HeroMax1, 62)) and (GetHeroCreatures(HeroMax1,  29) > 0) and HeroMax1 ~= "OrnellaNecro" and HeroMax1 ~= "OrnellaNecro2" then kolCreatures = GetHeroCreatures(HeroMax1,  29); RemoveHeroCreatures(HeroMax1,  29, kolCreatures); AddHeroCreatures(HeroMax1,  95, kolCreatures); end;
--     if (HasHeroSkill(HeroMax1, 62)) and (GetHeroCreatures(HeroMax1, 152) > 0) and HeroMax1 ~= "OrnellaNecro" and HeroMax1 ~= "OrnellaNecro2" then kolCreatures = GetHeroCreatures(HeroMax1, 152); RemoveHeroCreatures(HeroMax1, 152, kolCreatures); AddHeroCreatures(HeroMax1,  97, kolCreatures); end;
--     if (HasHeroSkill(HeroMax2, 62)) and (GetHeroCreatures(HeroMax2,  29) > 0) and HeroMax2 ~= "OrnellaNecro" and HeroMax2 ~= "OrnellaNecro2" then kolCreatures = GetHeroCreatures(HeroMax2,  29); RemoveHeroCreatures(HeroMax2,  29, kolCreatures); AddHeroCreatures(HeroMax2,  95, kolCreatures); end;
--     if (HasHeroSkill(HeroMax2, 62)) and (GetHeroCreatures(HeroMax2, 152) > 0) and HeroMax2 ~= "OrnellaNecro" and HeroMax2 ~= "OrnellaNecro2" then kolCreatures = GetHeroCreatures(HeroMax2, 152); RemoveHeroCreatures(HeroMax2, 152, kolCreatures); AddHeroCreatures(HeroMax2,  97, kolCreatures); end;

     -- ���� ������ �����
     if (HasHeroSkill(HeroMax1, 173) and frac(GetHeroStat(HeroMax1, STAT_SPELL_POWER) / 2) == 0.5 ) then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, 1); end;
     if (HasHeroSkill(HeroMax2, 173) and frac(GetHeroStat(HeroMax2, STAT_SPELL_POWER) / 2) == 0.5 ) then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, 1); end;

     -- ����������� ������
     --if HasHeroSkill(HeroMax1, 176) then GiveArtefact(HeroMax1, 29); GiveArtefact(HeroMax1, 12); GiveArtefact(HeroMax1, 26); GiveArtefact(HeroMax1, 28); end;
     --if HasHeroSkill(HeroMax2, 176) then GiveArtefact(HeroMax2, 29); GiveArtefact(HeroMax2, 12); GiveArtefact(HeroMax2, 26); GiveArtefact(HeroMax2, 28); end;

     -- ������ ���������
     if HasHeroSkill(HeroMax1, 114) then UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); end;
     if HasHeroSkill(HeroMax2, 114) then UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); end;

     -- ������� ������
     if HasHeroSkill(HeroMax1, 111) then SetTownBuildingLimitLevel('RANDOMTOWN1', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS, 1); UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); end;
     if HasHeroSkill(HeroMax2, 111) then SetTownBuildingLimitLevel('RANDOMTOWN2', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS, 1); UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); end;

     -- ��������������
     if GetHeroSkillMastery(HeroMax1, SKILL_NECROMANCY) > 0 and hero1race == 3 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) >= GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_MORALE, 0 - GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) ); end;
     if GetHeroSkillMastery(HeroMax1, SKILL_NECROMANCY) > 0 and hero1race == 3 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) <  GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_MORALE, 0 - GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) ); end;
     if GetHeroSkillMastery(HeroMax2, SKILL_NECROMANCY) > 0 and hero2race == 3 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) >= GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_MORALE, 0 - GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) ); end;
     if GetHeroSkillMastery(HeroMax2, SKILL_NECROMANCY) > 0 and hero2race == 3 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) > 0 and GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) <  GetHeroSkillMastery(HeroMax1, SKILL_LEADERSHIP) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_MORALE, 0 - GetHeroSkillMastery(HeroMax2, SKILL_LEADERSHIP) ); end;

     -- �������� ���� (+5% ���� �� �����)
     --if GetHeroSkillMastery(HeroMax1, 14) > 0 and Name(HeroMax1) ~= "Nymus" then UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;--TransformPlTown('TOWN2', hero1race); SetObjectOwner('TOWN2', PLAYER_1); UpgradeTownBuilding('TOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;
     --if GetHeroSkillMastery(HeroMax2, 14) > 0 and Name(HeroMax2) ~= "Nymus" then UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;--TransformPlTown('TOWN4', hero2race); SetObjectOwner('TOWN4', PLAYER_2); UpgradeTownBuilding('TOWN4', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;


     -- ������ ����������
--     if hero1race == 5 then UpgradeMiniArts1(); end;
--     if hero2race == 5 then UpgradeMiniArts2(); end;

     -- ��������
     if GetHeroSkillMastery(HeroMax1, SKILL_AVENGER) == 4 then TransformPlTown('TOWN1', 4); SetObjectOwner('TOWN1', PLAYER_1); UpgradeTownBuilding('TOWN1', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); TransformPlTown('TOWN2', 4); SetObjectOwner('TOWN2', PLAYER_1); UpgradeTownBuilding('TOWN2', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); end;
     if GetHeroSkillMastery(HeroMax2, SKILL_AVENGER) == 4 then TransformPlTown('TOWN5', 4); SetObjectOwner('TOWN5', PLAYER_2); UpgradeTownBuilding('TOWN5', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); TransformPlTown('TOWN6', 4); SetObjectOwner('TOWN6', PLAYER_2); UpgradeTownBuilding('TOWN6', TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD); end;

     -- ���������� ��������
     if GetHeroSkillMastery(HeroMax1, SKILL_WAR_MACHINES) > 0 then GiveHeroWarMachine(HeroMax1, 1); GiveHeroWarMachine(HeroMax1, 3); GiveHeroWarMachine(HeroMax1, 4); ChangeHeroStat(HeroMax1, STAT_LUCK, -1); ChangeHeroStat(HeroMax1, STAT_LUCK, 1); end;
     if GetHeroSkillMastery(HeroMax2, SKILL_WAR_MACHINES) > 0 then GiveHeroWarMachine(HeroMax2, 1); GiveHeroWarMachine(HeroMax2, 3); GiveHeroWarMachine(HeroMax2, 4); ChangeHeroStat(HeroMax2, STAT_LUCK, -1); ChangeHeroStat(HeroMax2, STAT_LUCK, 1);  end;

     -- ���������� �����
     if HasHeroSkill(HeroMax1, 32) and HasHeroSkill(HeroMax1, 78) == nil then kolCreatures = GetHeroCreatures(HeroMax1,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  13, kolCreatures); AddHeroCreatures(HeroMax1,  14, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 134); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 134, kolCreatures); AddHeroCreatures(HeroMax1,  16, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1,  27); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  27, kolCreatures); AddHeroCreatures(HeroMax1,  24, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 154); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 154, kolCreatures); AddHeroCreatures(HeroMax1,  30, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 145); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 145, kolCreatures); AddHeroCreatures(HeroMax1,  44, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 166); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 166, kolCreatures); AddHeroCreatures(HeroMax1,  93, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 143); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 143, kolCreatures); AddHeroCreatures(HeroMax1,  84, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 102); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 102, kolCreatures); AddHeroCreatures(HeroMax1, 103, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1, 171); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 171, kolCreatures); AddHeroCreatures(HeroMax1,  95, kolCreatures); end; end;

     if HasHeroSkill(HeroMax2, 32) and HasHeroSkill(HeroMax2, 78) == nil then kolCreatures = GetHeroCreatures(HeroMax2,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  13, kolCreatures); AddHeroCreatures(HeroMax2,  14, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 134); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 134, kolCreatures); AddHeroCreatures(HeroMax2,  16, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2,  27); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  27, kolCreatures); AddHeroCreatures(HeroMax2,  24, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 154); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 154, kolCreatures); AddHeroCreatures(HeroMax2,  30, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 145); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 145, kolCreatures); AddHeroCreatures(HeroMax2,  44, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 166); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 166, kolCreatures); AddHeroCreatures(HeroMax2,  93, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 143); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 143, kolCreatures); AddHeroCreatures(HeroMax2,  84, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 102); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 102, kolCreatures); AddHeroCreatures(HeroMax2, 103, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2, 171); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 171, kolCreatures); AddHeroCreatures(HeroMax2,  95, kolCreatures); end; end;

     -- �����-���������
     if HasHeroSkill(HeroMax1, 78) and HasHeroSkill(HeroMax1, 32) == nil then kolCreatures = GetHeroCreatures(HeroMax1,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  13, kolCreatures); AddHeroCreatures(HeroMax1, 118, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 78) then kolCreatures = GetHeroCreatures(HeroMax1, 112); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 112, kolCreatures); AddHeroCreatures(HeroMax1,  52, kolCreatures); end; end;
     if HasHeroSkill(HeroMax1, 78) and HasHeroSkill(HeroMax1, 32) then kolCreatures = GetHeroCreatures(HeroMax1,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  13, kolCreatures); AddHeroCreatures(HeroMax1,  66, kolCreatures); end; end;

     if HasHeroSkill(HeroMax2, 78) and HasHeroSkill(HeroMax2, 32) == nil then kolCreatures = GetHeroCreatures(HeroMax2,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  13, kolCreatures); AddHeroCreatures(HeroMax2, 118, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 78) then kolCreatures = GetHeroCreatures(HeroMax2, 112); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 112, kolCreatures); AddHeroCreatures(HeroMax2,  52, kolCreatures); end; end;
     if HasHeroSkill(HeroMax2, 78) and HasHeroSkill(HeroMax2, 32) then kolCreatures = GetHeroCreatures(HeroMax2,  13); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  13, kolCreatures); AddHeroCreatures(HeroMax2,  66, kolCreatures); end; end;



     ------------- ��������� ---------------

     -- ����� �����������
     if HasArtefact(HeroMax1, 7, 1) then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_INITIATIVE, -1); end;
     if HasArtefact(HeroMax2, 7, 1) then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_INITIATIVE, -1); end;

     -- ���� ������ (������)
--     if (HasArtefact(HeroMax1, 5, 1)) and (HasArtefact(HeroMax1, 18, 1)) and (HasArtefact(HeroMax1, 32, 1)) and (HasArtefact(HeroMax1, 61, 1)) then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, int(1.3 * (GetHeroStat (HeroMax1, STAT_SPELL_POWER))));
--     else if (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 18, 1) and HasArtefact(HeroMax1, 32, 1)) or (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 18, 1) and HasArtefact(HeroMax1, 61, 1)) or (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 32, 1) and HasArtefact(HeroMax1, 61, 1)) or (HasArtefact(HeroMax1, 18, 1) and HasArtefact(HeroMax1, 32, 1) and HasArtefact(HeroMax1, 61, 1))   then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, 0);
--     else if (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 18, 1)) or (HasArtefact(HeroMax1, 32, 1) and HasArtefact(HeroMax1, 61, 1)) or (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 32, 1)) or (HasArtefact(HeroMax1, 18, 1) and HasArtefact(HeroMax1, 61, 1)) or (HasArtefact(HeroMax1, 5, 1) and HasArtefact(HeroMax1, 61, 1)) or (HasArtefact(HeroMax1, 18, 1) and HasArtefact(HeroMax1, 32, 1)) then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, 0 - int(0.1 * (GetHeroStat (HeroMax1, STAT_SPELL_POWER))));
--     else if  (HasArtefact(HeroMax1, 5, 1)) or (HasArtefact(HeroMax1, 18, 1)) or (HasArtefact(HeroMax1, 32, 1)) or (HasArtefact(HeroMax1, 61, 1)) then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, 0 - int(0.2 * (GetHeroStat (HeroMax1, STAT_SPELL_POWER)))); end; end; end; end;

--     if (HasArtefact(HeroMax2, 5, 1)) and (HasArtefact(HeroMax2, 18, 1)) and (HasArtefact(HeroMax2, 32, 1)) and (HasArtefact(HeroMax2, 61, 1)) then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, int(1.3 * (GetHeroStat (HeroMax2, STAT_SPELL_POWER))));
--     else if (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 18, 1) and HasArtefact(HeroMax2, 32, 1)) or (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 18, 1) and HasArtefact(HeroMax2, 61, 1)) or (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 32, 1) and HasArtefact(HeroMax2, 61, 1)) or (HasArtefact(HeroMax2, 18, 1) and HasArtefact(HeroMax2, 32, 1) and HasArtefact(HeroMax2, 61, 1))   then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, 0);
--     else if (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 18, 1)) or (HasArtefact(HeroMax2, 32, 1) and HasArtefact(HeroMax2, 61, 1)) or (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 32, 1)) or (HasArtefact(HeroMax2, 18, 1) and HasArtefact(HeroMax2, 61, 1)) or (HasArtefact(HeroMax2, 5, 1) and HasArtefact(HeroMax2, 61, 1)) or (HasArtefact(HeroMax2, 18, 1) and HasArtefact(HeroMax2, 32, 1)) then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, 0 - int(0.1 * (GetHeroStat (HeroMax2, STAT_SPELL_POWER))));
--     else if  (HasArtefact(HeroMax2, 5, 1)) or (HasArtefact(HeroMax2, 18, 1)) or (HasArtefact(HeroMax2, 32, 1)) or (HasArtefact(HeroMax2, 61, 1)) then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, 0 - int(0.2 * (GetHeroStat (HeroMax2, STAT_SPELL_POWER)))); end; end; end; end;

     -- ���� ������
--     if  (HasArtefact(HeroMax1, 5, 1)) or (HasArtefact(HeroMax1, 18, 1)) or (HasArtefact(HeroMax1, 32, 1)) or (HasArtefact(HeroMax1, 61, 1)) then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, 0 - int(0.2 * (GetHeroStat (HeroMax1, STAT_SPELL_POWER)))); end;
--     if  (HasArtefact(HeroMax2, 5, 1)) or (HasArtefact(HeroMax2, 18, 1)) or (HasArtefact(HeroMax2, 32, 1)) or (HasArtefact(HeroMax2, 61, 1)) then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, 0 - int(0.2 * (GetHeroStat (HeroMax2, STAT_SPELL_POWER)))); end;

     -- ���� ������
     if GetHeroSkillMastery(HeroMax1, 14) > 0 and HasArtefact(HeroMax1, 23, 1) and HasArtefact(HeroMax1, 66, 1) then UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;--TransformPlTown('TOWN2', hero1race); SetObjectOwner('TOWN2', PLAYER_1); UpgradeTownBuilding('TOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;
     if GetHeroSkillMastery(HeroMax2, 14) > 0 and HasArtefact(HeroMax2, 23, 1) and HasArtefact(HeroMax2, 66, 1) then UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;--TransformPlTown('TOWN4', hero2race); SetObjectOwner('TOWN4', PLAYER_2); UpgradeTownBuilding('TOWN4', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;
     --if GetHeroSkillMastery(HeroMax1, 14) > 0 and HasArtefact(HeroMax1, 23, 1) and HasArtefact(HeroMax1, 66, 1) then TransformPlTown('TOWN1', 2); SetObjectOwner('TOWN1', PLAYER_1); UpgradeTownBuilding('TOWN1', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); TransformPlTown('TOWN2', 2); SetObjectOwner('TOWN2', PLAYER_1); UpgradeTownBuilding('TOWN2', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;
     --if GetHeroSkillMastery(HeroMax2, 14) > 0 and HasArtefact(HeroMax2, 23, 1) and HasArtefact(HeroMax2, 66, 1) then TransformPlTown('TOWN5', 2); SetObjectOwner('TOWN5', PLAYER_2); UpgradeTownBuilding('TOWN5', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); TransformPlTown('TOWN6', 2); SetObjectOwner('TOWN6', PLAYER_2); UpgradeTownBuilding('TOWN6', TOWN_BUILDING_INFERNO_INFERNAL_LOOM); end;



     -- ������� ������
     if HasArtefact(HeroMax1, 7, 1) and HasArtefact(HeroMax1, 33, 1) then NecroArtSet(HeroMax2); end;
     if HasArtefact(HeroMax2, 7, 1) and HasArtefact(HeroMax2, 33, 1) then NecroArtSet(HeroMax1); end;
     
     -- ������ ����
     if HasArtefact(HeroMax1, 10, 1) then ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, 50); ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 25); ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, -50); end;
     if HasArtefact(HeroMax2, 10, 1) then ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, 50); ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 25); ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, -50); end;

     -- ������ ���������
     if HasArtefact(HeroMax1, 70, 1) then
       if GetHeroArtifactsCount(HeroMax1, 70, 1) == 1 then
         GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_LUCK, -1);
       else
         GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_LUCK, -2);
       end;
     end;
     if HasArtefact(HeroMax2, 70, 1) then
       if GetHeroArtifactsCount(HeroMax2, 70, 1) == 1 then
         GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_LUCK, -1);
       else
         GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_LUCK, -2);
       end;
     end;
     
     -- ������ ������� �������
     if GetArtifactSetItemsCount(HeroMax1, 5, 1) == 2 then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, 10); end;
     if GetArtifactSetItemsCount(HeroMax1, 5, 1) == 3 then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, 15); end;
     if GetArtifactSetItemsCount(HeroMax1, 5, 1) == 4 then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, 20); end;
     if (GetArtifactSetItemsCount(HeroMax1, 5, 1) == 2 or GetArtifactSetItemsCount(HeroMax1, 5, 1) == 3 or GetArtifactSetItemsCount(HeroMax1, 5, 1) == 4) and GetHeroSkillMastery(HeroMax1, HERO_SKILL_RUNELORE) >  0 then ChangeHeroStat(HeroMax1, 3, 4); end;
     if GetArtifactSetItemsCount(HeroMax2, 5, 1) == 2 then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, 10); end;
     if GetArtifactSetItemsCount(HeroMax2, 5, 1) == 3 then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, 15); end;
     if GetArtifactSetItemsCount(HeroMax2, 5, 1) == 4 then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, 20); end;
     if (GetArtifactSetItemsCount(HeroMax2, 5, 1) == 2 or GetArtifactSetItemsCount(HeroMax2, 5, 1) == 3 or GetArtifactSetItemsCount(HeroMax2, 5, 1) == 4) and GetHeroSkillMastery(HeroMax2, HERO_SKILL_RUNELORE) >  0 then ChangeHeroStat(HeroMax2, 3, 4); end;


     --------------- ����� -----------------

     -- �������
--     if Name(HeroMax1) == "RedHeavenHero03" then kolCreatures = GetHeroCreatures(HeroMax1,   9); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,   9, kolCreatures); AddHeroCreatures(HeroMax1, 52, kolCreatures); end; end;
--     if Name(HeroMax1) == "RedHeavenHero03" then kolCreatures = GetHeroCreatures(HeroMax1, 110); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 110, kolCreatures); AddHeroCreatures(HeroMax1, 66, kolCreatures); end; end;
--     if Name(HeroMax2) == "RedHeavenHero03" then kolCreatures = GetHeroCreatures(HeroMax2,   9); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,   9, kolCreatures); AddHeroCreatures(HeroMax2, 52, kolCreatures); end; end;
--     if Name(HeroMax2) == "RedHeavenHero03" then kolCreatures = GetHeroCreatures(HeroMax2, 110); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 110, kolCreatures); AddHeroCreatures(HeroMax2, 66, kolCreatures); end; end;

     -- ������
--     if Name(HeroMax1) == "Agrael" then kolCreatures = GetHeroCreatures(HeroMax1,  15); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  15, kolCreatures); AddHeroCreatures(HeroMax1, 16, kolCreatures); end; end;
--     if Name(HeroMax1) == "Agrael" then kolCreatures = GetHeroCreatures(HeroMax1, 131); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 131, kolCreatures); AddHeroCreatures(HeroMax1, 44, kolCreatures); end; end;
--     if Name(HeroMax2) == "Agrael" then kolCreatures = GetHeroCreatures(HeroMax2,  15); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  15, kolCreatures); AddHeroCreatures(HeroMax2, 16, kolCreatures); end; end;
--     if Name(HeroMax2) == "Agrael" then kolCreatures = GetHeroCreatures(HeroMax2, 131); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 131, kolCreatures); AddHeroCreatures(HeroMax2, 44, kolCreatures); end; end;

     -- �������
     if (HeroMax1 == "RedHeavenHero03" or HeroMax1 == "RedHeavenHero032") then SpecValeria(HeroMax1); end;
     if (HeroMax2 == "RedHeavenHero03" or HeroMax2 == "RedHeavenHero032") then SpecValeria(HeroMax2); end;

     -- �������
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1,  45); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  45, kolCreatures); AddHeroCreatures(HeroMax1, 46, kolCreatures); end; end;
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1, 146); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 146, kolCreatures); AddHeroCreatures(HeroMax1, 18, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2,  45); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  45, kolCreatures); AddHeroCreatures(HeroMax2, 46, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2, 146); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 146, kolCreatures); AddHeroCreatures(HeroMax2, 18, kolCreatures); end; end;
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1,  47); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  47, kolCreatures); AddHeroCreatures(HeroMax1, 48, kolCreatures); end; end;
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1, 147); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 147, kolCreatures); AddHeroCreatures(HeroMax1, 20, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2,  47); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  47, kolCreatures); AddHeroCreatures(HeroMax2, 48, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2, 147); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 147, kolCreatures); AddHeroCreatures(HeroMax2, 20, kolCreatures); end; end;
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  49, kolCreatures); AddHeroCreatures(HeroMax1, 50, kolCreatures); end; end;
     if Name(HeroMax1) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax1, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 148, kolCreatures); AddHeroCreatures(HeroMax1, 22, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  49, kolCreatures); AddHeroCreatures(HeroMax2, 50, kolCreatures); end; end;
     if Name(HeroMax2) == "Nadaur" then kolCreatures = GetHeroCreatures(HeroMax2, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 148, kolCreatures); AddHeroCreatures(HeroMax2, 22, kolCreatures); end; end;

     -- �������
     if Name(HeroMax1) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax1,  47); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  47, kolCreatures); AddHeroCreatures(HeroMax1, 62, kolCreatures); end; end;
     if Name(HeroMax1) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax1, 147); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 147, kolCreatures); AddHeroCreatures(HeroMax1, 76, kolCreatures); end; end;
     if Name(HeroMax2) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax2,  47); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  47, kolCreatures); AddHeroCreatures(HeroMax2, 62, kolCreatures); end; end;
     if Name(HeroMax2) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax2, 147); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 147, kolCreatures); AddHeroCreatures(HeroMax2, 76, kolCreatures); end; end;
     if Name(HeroMax1) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax1,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  49, kolCreatures); AddHeroCreatures(HeroMax1, 72, kolCreatures); end; end;
     if Name(HeroMax1) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax1, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 148, kolCreatures); AddHeroCreatures(HeroMax1, 74, kolCreatures); end; end;
     if Name(HeroMax2) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax2,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  49, kolCreatures); AddHeroCreatures(HeroMax2, 72, kolCreatures); end; end;
     if Name(HeroMax2) == "Heam" then kolCreatures = GetHeroCreatures(HeroMax2, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 148, kolCreatures); AddHeroCreatures(HeroMax2, 74, kolCreatures); end; end;

     -- ������
--     if Name(HeroMax1) == "Ildar" then kolCreatures = GetHeroCreatures(HeroMax1,  55); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  55, kolCreatures); AddHeroCreatures(HeroMax1, 56, kolCreatures); end; end;
--     if Name(HeroMax1) == "Ildar" then kolCreatures = GetHeroCreatures(HeroMax1, 151); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 151, kolCreatures); AddHeroCreatures(HeroMax1, 84, kolCreatures); end; end;
--     if Name(HeroMax2) == "Ildar" then kolCreatures = GetHeroCreatures(HeroMax2,  55); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  55, kolCreatures); AddHeroCreatures(HeroMax2, 56, kolCreatures); end; end;
--     if Name(HeroMax2) == "Ildar" then kolCreatures = GetHeroCreatures(HeroMax2, 151); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 151, kolCreatures); AddHeroCreatures(HeroMax2, 84, kolCreatures); end; end;

     -- �����
--     if Name(HeroMax1) == "GhostFSLord" then kolCreatures = GetHeroCreatures(HeroMax1,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  49, kolCreatures); AddHeroCreatures(HeroMax1, 64, kolCreatures); end; end;
--     if Name(HeroMax1) == "GhostFSLord" then kolCreatures = GetHeroCreatures(HeroMax1, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 148, kolCreatures); AddHeroCreatures(HeroMax1, 60, kolCreatures); end; end;
--     if Name(HeroMax2) == "GhostFSLord" then kolCreatures = GetHeroCreatures(HeroMax2,  49); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  49, kolCreatures); AddHeroCreatures(HeroMax2, 64, kolCreatures); end; end;
--     if Name(HeroMax2) == "GhostFSLord" then kolCreatures = GetHeroCreatures(HeroMax2, 148); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 148, kolCreatures); AddHeroCreatures(HeroMax2, 60, kolCreatures); end; end;

     -- ����
     if Name(HeroMax1) == "Eruina" then kolCreatures = GetHeroCreatures(HeroMax1,  81); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  81, kolCreatures); AddHeroCreatures(HeroMax1, 82, kolCreatures); end; end;
--     if Name(HeroMax1) == "Eruina" then kolCreatures = GetHeroCreatures(HeroMax1, 143); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 143, kolCreatures); AddHeroCreatures(HeroMax1, 82, kolCreatures); end; end;
     if Name(HeroMax2) == "Eruina" then kolCreatures = GetHeroCreatures(HeroMax2,  81); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  81, kolCreatures); AddHeroCreatures(HeroMax2, 82, kolCreatures); end; end;
--     if Name(HeroMax2) == "Eruina" then kolCreatures = GetHeroCreatures(HeroMax2, 143); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 143, kolCreatures); AddHeroCreatures(HeroMax2, 82, kolCreatures); end; end;

     -- ������
     if Name(HeroMax1) == "Ferigl" then kolCreatures = GetHeroCreatures(HeroMax1,  77); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  77, kolCreatures); AddHeroCreatures(HeroMax1, 200 + ceil(0.5 * (GetHeroLevel(HeroMax1) - StartLevel)), kolCreatures); end; end;
     if Name(HeroMax1) == "Ferigl" then kolCreatures = GetHeroCreatures(HeroMax1, 141); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 141, kolCreatures); AddHeroCreatures(HeroMax1, 210 + ceil(0.5 * (GetHeroLevel(HeroMax1) - StartLevel)), kolCreatures); end; end;
     if Name(HeroMax2) == "Ferigl" then kolCreatures = GetHeroCreatures(HeroMax2,  77); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  77, kolCreatures); AddHeroCreatures(HeroMax2, 200 + ceil(0.5 * (GetHeroLevel(HeroMax1) - StartLevel)), kolCreatures); end; end;
     if Name(HeroMax2) == "Ferigl" then kolCreatures = GetHeroCreatures(HeroMax2, 141); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 141, kolCreatures); AddHeroCreatures(HeroMax2, 210 + ceil(0.5 * (GetHeroLevel(HeroMax1) - StartLevel)), kolCreatures); end; end;

     -- ���������
     if Name(HeroMax1) == "Wulfstan" then kolCreatures = GetHeroCreatures(HeroMax1,  98); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  98, kolCreatures); AddHeroCreatures(HeroMax1, 99, kolCreatures); end; end;
     if Name(HeroMax1) == "Wulfstan" then kolCreatures = GetHeroCreatures(HeroMax1, 169); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 169, kolCreatures); AddHeroCreatures(HeroMax1, 80, kolCreatures); end; end;
     if Name(HeroMax2) == "Wulfstan" then kolCreatures = GetHeroCreatures(HeroMax2,  98); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  98, kolCreatures); AddHeroCreatures(HeroMax2, 99, kolCreatures); end; end;
     if Name(HeroMax2) == "Wulfstan" then kolCreatures = GetHeroCreatures(HeroMax2, 169); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 169, kolCreatures); AddHeroCreatures(HeroMax2, 80, kolCreatures); end; end;

     -- ���'�������
--     if Name(HeroMax1) == "Hero6" then kolCreatures = GetHeroCreatures(HeroMax1,  28); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  28, kolCreatures); AddHeroCreatures(HeroMax1, 128, kolCreatures); end; end;
--     if Name(HeroMax1) == "Hero6" then kolCreatures = GetHeroCreatures(HeroMax1, 137); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 137, kolCreatures); AddHeroCreatures(HeroMax1, 130, kolCreatures); end; end;
--     if Name(HeroMax2) == "Hero6" then kolCreatures = GetHeroCreatures(HeroMax2,  28); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  28, kolCreatures); AddHeroCreatures(HeroMax2, 128, kolCreatures); end; end;
--     if Name(HeroMax2) == "Hero6" then kolCreatures = GetHeroCreatures(HeroMax2, 137); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 137, kolCreatures); AddHeroCreatures(HeroMax2, 130, kolCreatures); end; end;

     -- ������
--     if Name(HeroMax1) == "Ohtarig" then kolCreatures = GetHeroCreatures(HeroMax1,  71); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1,  71, kolCreatures); AddHeroCreatures(HeroMax1,  93, kolCreatures); end; end;
--     if Name(HeroMax1) == "Ohtarig" then kolCreatures = GetHeroCreatures(HeroMax1, 138); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 138, kolCreatures); AddHeroCreatures(HeroMax1, 101, kolCreatures); end; end;
--     if Name(HeroMax2) == "Ohtarig" then kolCreatures = GetHeroCreatures(HeroMax2,  71); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2,  71, kolCreatures); AddHeroCreatures(HeroMax2,  93, kolCreatures); end; end;
--     if Name(HeroMax2) == "Ohtarig" then kolCreatures = GetHeroCreatures(HeroMax2, 138); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 138, kolCreatures); AddHeroCreatures(HeroMax2, 101, kolCreatures); end; end;


     -- �����
--     if Name(HeroMax1) == "Quroq" then kolCreatures = GetHeroCreatures(HeroMax1, 123); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 123, kolCreatures); AddHeroCreatures(HeroMax1, 124, kolCreatures); end; end;
--     if Name(HeroMax1) == "Quroq" then kolCreatures = GetHeroCreatures(HeroMax1, 176); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax1, 176, kolCreatures); AddHeroCreatures(HeroMax1, 126, kolCreatures); end; end;
--     if Name(HeroMax2) == "Quroq" then kolCreatures = GetHeroCreatures(HeroMax2, 123); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 123, kolCreatures); AddHeroCreatures(HeroMax2, 124, kolCreatures); end; end;
--     if Name(HeroMax2) == "Quroq" then kolCreatures = GetHeroCreatures(HeroMax2, 176); if kolCreatures > 0 then RemoveHeroCreatures(HeroMax2, 176, kolCreatures); AddHeroCreatures(HeroMax2, 126, kolCreatures); end; end;

     -- ����
     if Name(HeroMax1) == "Grok" then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_SPEED, 1); end;
     if Name(HeroMax2) == "Grok" then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_SPEED, 1); end;
     
     -- ������
     if Name(HeroMax1) == "Marder" then GiveHeroBattleBonus(HeroMax1, HERO_BATTLE_BONUS_HITPOINTS, round(0.4 * GetHeroLevel(HeroMax1) ) ); end;
     if Name(HeroMax2) == "Marder" then GiveHeroBattleBonus(HeroMax2, HERO_BATTLE_BONUS_HITPOINTS, round(0.4 * GetHeroLevel(HeroMax2) ) ); end;

     -- ������
--     if Name(HeroMax1) == "Gles" then SpecGles(HeroMax1, HeroMax2); end;
--     if Name(HeroMax2) == "Gles" then SpecGles(HeroMax2, HeroMax1); end;

     -- �����
     --if Name(HeroMax1) == "Shadwyn" then SetObjectOwner('Dwel1', PLAYER_1); TransformTown('Dwel1', 3); UpgradeTownBuilding('Dwel1', TOWN_BUILDING_MAGIC_GUILD); UpgradeTownBuilding('Dwel1', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); UpgradeTownBuilding('Dwel1', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); TeachHeroSpell(HeroMax1, 1); TeachHeroSpell(HeroMax1, 3); TeachHeroSpell(HeroMax1, 4); TeachHeroSpell(HeroMax1, 237); end;
     --if Name(HeroMax2) == "Shadwyn" then SetObjectOwner('Dwel2', PLAYER_2); TransformTown('Dwel2', 3); UpgradeTownBuilding('Dwel2', TOWN_BUILDING_MAGIC_GUILD); UpgradeTownBuilding('Dwel2', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); UpgradeTownBuilding('Dwel2', TOWN_BUILDING_DUNGEON_ALTAR_OF_ELEMENTS); TeachHeroSpell(HeroMax2, 1); TeachHeroSpell(HeroMax2, 3); TeachHeroSpell(HeroMax2, 4); TeachHeroSpell(HeroMax2, 237); end;

     -- ����
     if Name(HeroMax1) == "Vegeyr" then SpecVegeyr(HeroMax1); end;
     if Name(HeroMax2) == "Vegeyr" then SpecVegeyr(HeroMax2); end;
     
     -- �����
     if Name(HeroMax1) == "Brand" then res = floor(GetHeroLevel(HeroMax1)/6); SetPlayerResource(1, WOOD, GetPlayerResource( 1, WOOD) + res); SetPlayerResource(1, ORE, GetPlayerResource( 1, ORE) + res); SetPlayerResource(1, MERCURY, GetPlayerResource( 1, MERCURY) + res); SetPlayerResource(1, CRYSTAL, GetPlayerResource( 1, CRYSTAL) + res); SetPlayerResource(1, SULFUR, GetPlayerResource( 1, SULFUR) + res); SetPlayerResource(1, GEM, GetPlayerResource( 1, GEM) + res); end;
     if Name(HeroMax2) == "Brand" then res = floor(GetHeroLevel(HeroMax2)/6); SetPlayerResource(2, WOOD, GetPlayerResource( 2, WOOD) + res); SetPlayerResource(2, ORE, GetPlayerResource( 2, ORE) + res); SetPlayerResource(2, MERCURY, GetPlayerResource( 2, MERCURY) + res); SetPlayerResource(2, CRYSTAL, GetPlayerResource( 2, CRYSTAL) + res); SetPlayerResource(2, SULFUR, GetPlayerResource( 2, SULFUR) + res); SetPlayerResource(2, GEM, GetPlayerResource( 2, GEM) + res); end;

     -- ������
     if Name(HeroMax1) == "Kujin" then UpgradeTownBuilding('RANDOMTOWN1', TOWN_BUILDING_STRONGHOLD_PILE_OF_OUR_FOES); end;
     if Name(HeroMax2) == "Kujin" then UpgradeTownBuilding('RANDOMTOWN2', TOWN_BUILDING_STRONGHOLD_PILE_OF_OUR_FOES); end;
     
     if TeleportUse1 == 0 and (hero1race == 4 or hero1race == 5) then TeleportBattleZone1(); BattleNextDay1 = 1; else BattleNextDay1 = 0; end;
     if TeleportUse2 == 0 and (hero2race == 4 or hero2race == 5) then TeleportBattleZone2(); BattleNextDay2 = 1; else BattleNextDay2 = 0; end;


     sleep(5);

--     if (HasHeroSkill(HeroMax1, 21) and HasHeroSkill(HeroMax2, 19) == nil) or (HasHeroSkill(HeroMax2, 21) and HasHeroSkill(HeroMax1, 19) == nil) then
--       MakeHeroInteractWithObject (HeroMax1, 'boat1');
--       MakeHeroInteractWithObject (HeroMax2, 'boat2');
--       MakeHeroInteractWithObject (HeroMax2, HeroMax1);
--     end;

     if option[NumberBattle] == 2 then BattleInTown1(); end;
     if option[NumberBattle] == 3 then BattleInTown2(); end;

     sleep(5);
     
     Trigger(COMBAT_RESULTS_TRIGGER, 'CombatResult');

     CombatID = 'CombatID:' .. hero1race .. HeroID(hero1race, HeroMax1) .. GetHeroStat(HeroMax1, 1) .. GetHeroStat(HeroMax1, 2) .. GetHeroStat(HeroMax1, 3) .. GetHeroStat(HeroMax1, 4) .. hero2race .. HeroID(hero2race, HeroMax2) .. GetHeroStat(HeroMax2, 1) .. GetHeroStat(HeroMax2, 2) .. GetHeroStat(HeroMax2, 3) .. GetHeroStat(HeroMax2, 4) .. random(100)

     consoleCmd('game_writelog 1');
     sleep(2);
     print('StartReport')
     print(CombatID);
     consoleCmd('profile_name')
     InfoPlayer(HeroMax1, 1, hero1race, RemSkSum1);
     InfoPlayer(HeroMax2, 2, hero2race, RemSkSum2);

     sleep(1);
     consoleCmd('game_writelog 0');
     

     if ((HasHeroSkill(HeroMax1, 19) and HasHeroSkill(HeroMax2, 19) == nil) and Name(HeroMax2) ~= "Jazaz") or Name(HeroMax1) == "Jazaz" then
       PathFinding(HeroMax1, HeroMax2, hero1race);
     else
       if ((HasHeroSkill(HeroMax2, 19) and HasHeroSkill(HeroMax1, 19) == nil) and Name(HeroMax1) ~= "Jazaz") or Name(HeroMax2) == "Jazaz" then
         PathFinding(HeroMax2, HeroMax1, hero2race);
       else
         if BattleNextDay1 == 0 and BattleNextDay2 == 0 then
           sleep(5);
           InitCombatExecThread(HeroMax1)
           sleep(5)
           SaveHeroesInfoBeforeCombat{HeroMax1, HeroMax2}
           sleep(5)
           MakeHeroInteractWithObject (HeroMax1, HeroMax2);
           while IsHeroAlive(HeroMax1) and IsHeroAlive(HeroMax2) do
		         MakeHeroInteractWithObject(HeroMax1, HeroMax2);
		         sleep(10);
	         end;
         else
           hodi1(HeroMax2);
           ShowFlyingSign(GetMapDataPath().."propusk.txt", HeroMax1, 1, 5.0);
           ShowFlyingSign(GetMapDataPath().."arena.txt", HeroMax2, 2, 5.0);
         end;
       end;
     end;
     
     
  end;
  
  if GetDate (DAY) == 6 then
     sleep(5);
     InitCombatExecThread(HeroMax1)
     sleep(5)
     SaveHeroesInfoBeforeCombat{HeroMax1, HeroMax2}
     sleep(5)
     MakeHeroInteractWithObject (HeroMax1, HeroMax2);
  end;

end;

function DayFour1()

  if IsHeroInTown(HeroMax1, 'RANDOMTOWN1', 0, 1) then SetObjectPosition( HeroMax1, 44, 81); end;
  if IsHeroInTown(HeroMin1, 'RANDOMTOWN1', 0, 1) then SetObjectPosition( HeroMin1, 44, 81); end;
  sleep(2);
  
  DestroyBuilding ('RANDOMTOWN1');

  ControlHeroCustomAbility(HeroMax1, CUSTOM_ABILITY_1, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax1, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax1, CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax1, CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);

  -- ������ ������
  if DT_use1 == 0 and HasHeroSkill(HeroMax1, 71) then DT_use1 = 1; nap1Plus3Q(HeroMax1); end;

  if hero1race ~= 4 and hero1race ~= 5 then SetObjectPosition (HeroMax1, TELEPORT_BATTLE_ZONE_PLAYER_1_X, TELEPORT_BATTLE_ZONE_PLAYER_1_Y); stop(HeroMax1); end;
  if hero1race ~= 4 and hero1race ~= 5 then OpenCircleFog( 49, 45, 0, 15, 1 ); end;

  SetPlayerResource (PLAYER_1, GOLD, 0);
  SetObjectEnabled('market1', nil);

--  print(PerkSum1);
--  print(PerkSumF(HeroMax1));

--  if (PerkSum1) ~= (PerkSumF(HeroMax1)) and HasHeroSkill(HeroMax1, 104) then
--    pause1 = 0;
--    while (PerkSum1) ~= (PerkSumF(HeroMax1)) do
--      sleep(3);
--    end;
--    MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."PerkSum.txt", 'pause1F');
--    while pause1 == 0 do
--      sleep(1);
--    end;
--    print('wait1');
--  end;

  if SpoilsUse1 == 0 and HasHeroSkill(HeroMax1, 129) then Spoils1(); end;
  
  sleep(5);
  stop(HeroMin1);
  stop(HeroDop1);
  
  --TRANSFER ALL TO MAIN
   transferAllArts (HeroMax1, HeroMin1, HeroDop1);
   transferArmy ('RANDOMTOWN1', HeroMin1, HeroMax1);
   transferArmy ('RANDOMTOWN1', HeroDop1, HeroMax1);
  
  -- ������� ��������
  if RemStUn1 == 2 then
    if GetHeroCreatures(HeroMax1, array_StartUnit[hero1race].grade1) > 0 then AddHeroCreatures(HeroMax1, array_StartUnit[hero1race].grade1, 1); else
    if GetHeroCreatures(HeroMax1, array_StartUnit[hero1race].grade2) > 0 then AddHeroCreatures(HeroMax1, array_StartUnit[hero1race].grade2, 1); end; end;
  end;

-- �������� ����� � �������� ������
--  if (HasHeroSkill(HeroMax1, 30) == nil and GetHeroSkillMastery(HeroMax1, SKILL_NECROMANCY) == 0 and (HasHeroSkill(HeroMax1, 104) or HasHeroSkill(HeroMax1, 82)) and (hero1race ~= 4 and hero1race ~= 5)) then
--    DublikatHero1( HeroMax1);
--  end;
--  print('sss1')
  -- ��������
  if hero1race == 4 then Avenger1(); startThread (AutoTeleportBattleZone1); end;
  -- ������ ����������
  if hero1race == 5 then MiniArts1(); startThread (AutoTeleportBattleZone1); end;
  -- ����������
  if (HasHeroSkill(HeroMax1, 30)) then diplomacy1(HeroMax1); end;
  -- �����������
  if hero1race == 3 and (HasHeroSkill(HeroMax1, 30)) == nil then NecroBonus1(HeroMax1); end;
  
  -- ����
  if hero2race == 4 and hero1race ~= 3 and hero1race ~= 4 and hero1race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitAvenger.txt", HeroMax1, 1, 5.0); end;
  if hero2race == 5 and hero1race ~= 3 and hero1race ~= 4 and hero1race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitMinik.txt", HeroMax1, 1, 5.0); end;


--  if hero1race ~= 3 and hero1race ~= 4 and hero1race ~= 5 then ShowFlyingSign(GetMapDataPath().."Wait.txt", HeroMax1, 1, 5.0); end;
end;

function DayFour2()

  if IsHeroInTown(HeroMax2, 'RANDOMTOWN2', 0, 1) then SetObjectPosition( HeroMax2, 44, 12); end;
  if IsHeroInTown(HeroMin2, 'RANDOMTOWN2', 0, 1) then SetObjectPosition( HeroMin2, 44, 12); end;
  sleep(2);
  
  DestroyBuilding ('RANDOMTOWN2');

  ControlHeroCustomAbility(HeroMax2, CUSTOM_ABILITY_1, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax2, CUSTOM_ABILITY_2, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax2, CUSTOM_ABILITY_3, CUSTOM_ABILITY_DISABLED);
  ControlHeroCustomAbility(HeroMax2, CUSTOM_ABILITY_4, CUSTOM_ABILITY_DISABLED);
  
  -- ������ ������
  if DT_use2 == 0 and HasHeroSkill(HeroMax2, 71) then DT_use2 = 1; nap2Plus3Q(HeroMax2); end;

  if hero2race ~= 4 and hero2race ~= 5 then SetObjectPosition (HeroMax2, TELEPORT_BATTLE_ZONE_PLAYER_2_X, TELEPORT_BATTLE_ZONE_PLAYER_2_Y); end;
  if hero2race ~= 4 and hero2race ~= 5 then OpenCircleFog( 49, 45, 0, 15, 2 ); end;
  
  SetPlayerResource (PLAYER_2, GOLD, 0);
  SetObjectEnabled('market2', nil);
  
--  if (PerkSum2) ~= (PerkSumF(HeroMax2)) and HasHeroSkill(HeroMax2, 104) then
--    pause2 = 0;
--    while (PerkSum2) ~= (PerkSumF(HeroMax2)) do
--      sleep(3);
--    end;
--    MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."PerkSum.txt", 'pause2F');
--    while pause2 == 0 do
--      sleep(1);
--    end;
--    print('wait1');
--  end;
  
  if SpoilsUse2 == 0 and HasHeroSkill(HeroMax2, 129) then Spoils2(); end;
  
  sleep(5);
  stop(HeroMin2);
  stop(HeroDop2);

  --TRANSFER ALL TO MAIN
  transferAllArts (HeroMax2, HeroMin2, HeroDop2);
  transferArmy ('RANDOMTOWN2', HeroMin2, HeroMax2);
  transferArmy ('RANDOMTOWN2', HeroDop2, HeroMax2);
  
  -- ������� ��������
  if RemStUn2 == 2 then
    if GetHeroCreatures(HeroMax2, array_StartUnit[hero2race].grade1) > 0 then AddHeroCreatures(HeroMax2, array_StartUnit[hero2race].grade1, 1); else
    if GetHeroCreatures(HeroMax2, array_StartUnit[hero2race].grade2) > 0 then AddHeroCreatures(HeroMax2, array_StartUnit[hero2race].grade2, 1); end; end;
  end;

-- �������� ����� � �������� ������
--  if (HasHeroSkill(HeroMax2, 30) == nil and GetHeroSkillMastery(HeroMax2, SKILL_NECROMANCY) == 0 and (HasHeroSkill(HeroMax2, 104) or HasHeroSkill(HeroMax2, 82)) and (hero2race ~= 4 and hero2race ~= 5)) then
--    DublikatHero2( HeroMax2);
--  end;
  
--  print('sss2')
  -- ��������
  if hero2race == 4 then Avenger2(); startThread (AutoTeleportBattleZone2); end;
  -- ������ ����������
  if hero2race == 5 then MiniArts2(); startThread (AutoTeleportBattleZone2); end;
  -- ����������
  if (HasHeroSkill(HeroMax2, 30)) then diplomacy2(HeroMax2); end;
  -- �����������
  if hero2race == 3 and (HasHeroSkill(HeroMax2, 30)) == nil then NecroBonus2(HeroMax2); end;
  
  -- ����
  if hero1race == 4 and hero2race ~= 3 and hero2race ~= 4 and hero2race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitAvenger.txt", HeroMax2, 2, 5.0); end;
  if hero1race == 5 and hero2race ~= 3 and hero2race ~= 4 and hero2race ~= 5 then ShowFlyingSign(GetMapDataPath().."WaitMinik.txt", HeroMax2, 2, 5.0); end;

--  if hero1race ~= 3 and hero1race ~= 4 and hero1race ~= 5 then ShowFlyingSign(GetMapDataPath().."Wait.txt", HeroMax1, 1, 5.0); end;
end;


function CombatResult(id)
  local n_stacks, creature, count, died, looserName;
  --consoleCmd('game_writelog 1')
  looserName = GetSavedCombatArmyHero(id, 0)
  if looserName == HeroMax1 then Loose(1); end;
  if looserName == HeroMax2 then Loose(2); end;

  -- ������ ���������� �������
  n_stacks = GetSavedCombatArmyCreaturesCount(id, 1);
  Info_Hero_ArmyRemainder = 'ArmyRemainder: '
  for i = 0,(n_stacks-1) do
    creature, count, died = GetSavedCombatArmyCreatureInfo(id, 1, i);
    Info_Hero_ArmyRemainder = Info_Hero_ArmyRemainder .. 'ID' .. creature .. ' = ' .. (count - died) .. ', '
  end

  -- ������ ����������� �������
  --n_stacks = GetSavedCombatArmyCreaturesCount(id, 0);
  --for i = 0,(n_stacks-1) do
  --  creature, count, died = GetSavedCombatArmyCreatureInfo(id, 0, i);
  --  Info_Hero_ArmyRemainder = Info_Hero_ArmyRemainder .. 'ID' .. creature .. ' = ' .. (count - died) .. ', '
  --end
  
  
  
  --print(Info_Hero_ArmyRemainder)

  if IsHeroAlive(HeroMax1) then
    --Loose(2)
    TalkBoxForPlayers( 1, "/Textures/Icons/Heroes/Inferno/Inferno_Biara_128x128.(Texture).xdb#xpointer(/Texture)", GetMapDataPath().."ReportDSCRP.txt", nil, nil, 'SendReport', 0, GetMapDataPath().."ReportNAME.txt", GetMapDataPath().."ReportQ.txt", nil, GetMapDataPath().."Tournament1.txt", GetMapDataPath().."Tournament2.txt", GetMapDataPath().."Tournament3.txt", GetMapDataPath().."Tournament4.txt", GetMapDataPath().."Tournament5.txt");
    --QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."ReportQ.txt", 'SendReport', 'DeleteReport');
--    print('Winner: Player1');

--    Loose(2);
--    sleep(3);
--    consoleCmd('profile_name');
  end;
  if IsHeroAlive(HeroMax2) then
    --Loose(1)
    TalkBoxForPlayers( 2, "/UI/H5A1/Icons/Heroes/Portrets128x128/Giovanni.(Texture).xdb#xpointer(/Texture)", GetMapDataPath().."ReportDSCRP.txt", nil, nil, 'SendReport', 0, GetMapDataPath().."ReportNAME.txt", GetMapDataPath().."ReportQ.txt", nil, GetMapDataPath().."Tournament1.txt", GetMapDataPath().."Tournament2.txt", GetMapDataPath().."Tournament3.txt", GetMapDataPath().."Tournament4.txt", GetMapDataPath().."Tournament5.txt");
    --QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."ReportQ.txt", 'SendReport', 'DeleteReport');
  
--    print('Winner: Player2')
--    Loose(1);
--    sleep(3);
--    consoleCmd('profile_name');
   end;
end;

function SendReport(player, tournament)
  consoleCmd('game_writelog 1')
  sleep(1)
--  if player == 1 then Loose(2) else Loose(1) end
--  sleep(3);
  if tournament ~= 5 then
    print('Winner: Player', player)
    consoleCmd('profile_name');
    sleep(1);
    print(CombatID)
    print('Tournament: ', tournament)
    print(array_info[1].Name)
    print(array_info[1].Race)
    print(array_info[1].Level)
    print(array_info[1].Attack)
    print(array_info[1].Defence)
    print(array_info[1].Spellpower)
    print(array_info[1].Knowledge)
    print(array_info[1].Luck)
    print(array_info[1].Morale)
    print(array_info[1].Mana)
    print(array_info[1].StartBonus)
    print(array_info[1].Mentoring)
    print(array_info[1].Army)
    print(array_info[1].Arts)
    print(array_info[1].Spells)
    print(array_info[1].Skills)
    print(array_info[1].Perks)
  
    print(array_info[2].Name)
    print(array_info[2].Race)
    print(array_info[2].Level)
    print(array_info[2].Attack)
    print(array_info[2].Defence)
    print(array_info[2].Spellpower)
    print(array_info[2].Knowledge)
    print(array_info[2].Luck)
    print(array_info[2].Morale)
    print(array_info[2].Mana)
    print(array_info[2].StartBonus)
    print(array_info[2].Mentoring)
    print(array_info[2].Army)
    print(array_info[2].Arts)
    print(array_info[2].Spells)
    print(array_info[2].Skills)
    print(array_info[2].Perks)
  
    print(Info_Hero_ArmyRemainder)
    print('Finish')
    consoleCmd('game_writelog 0')
  else
    print('Disconnect');
    consoleCmd('game_writelog 0')
  end;
  --print('hero1_mana=')
  --h1b=parse(GetGameVar('hero1_mana'))()
  --print('hero1_mana=',h1b)
  --if player == 1 then print('Hero1_Mana_R: ', GetHeroStat(HeroMax1, 8)); else print('Hero2_Mana_R: ', GetHeroStat(HeroMax2, 8)); end

  --HERO1_MANA = GetGameVar('hero1_mana')
  --print(HERO1_MANA)
  
end

function DeleteReport(player)
  consoleCmd('game_writelog 1')
  sleep(1)
  print('DeleteReport')
end

function HeroID(race, hero)
  local id = 0;
  for i = 1, length(dublikat_heroes[race - 1]) do
    if dublikat_heroes[race - 1].name == hero or dublikat_heroes[race - 1].name2 == hero or dublikat_heroes[race - 1].name3 == hero or dublikat_heroes[race - 1].name4 == hero then
      id = i;
    end;
  end;
  return id;
end;

array_info = {}

function InfoPlayer(hero, player, race, mentoring)
  Info_Hero_Name       = 'Hero' .. player.. '_Name: ' .. Name(hero);
  Info_Hero_Race       = 'Hero' .. player.. '_Race: ' .. race;
  Info_Hero_Attack     = 'Hero' .. player.. '_Attack: ' .. GetHeroStat(hero, 1);
  Info_Hero_Defence    = 'Hero' .. player.. '_Defence: ' .. GetHeroStat(hero, 2);
  Info_Hero_Spellpower = 'Hero' .. player.. '_Spellpower: ' .. GetHeroStat(hero, 3);
  Info_Hero_Knowledge  = 'Hero' .. player.. '_Knowledge: ' .. GetHeroStat(hero, 4);
  Info_Hero_Luck       = 'Hero' .. player.. '_Luck: ' .. GetHeroStat(hero, 5);
  Info_Hero_Morale     = 'Hero' .. player.. '_Morale: ' .. GetHeroStat(hero, 6);
  Info_Hero_Mana       = 'Hero' .. player.. '_Mana: ' .. GetHeroStat(hero, 8);
  Info_Hero_Level      = 'Hero' .. player.. '_Level: ' .. GetHeroLevel(hero);
  Info_Hero_StartBonus = 'Hero' .. player.. '_StartBonus: ' .. StartBonus[player];
  Info_Hero_Mentoring  = 'Hero' .. player.. '_Mentoring: ' .. mentoring;
  Info_Hero_Army = 'Hero' .. player.. '_Army: '
  for i = 1, 999 do
    if GetHeroCreatures(hero, i) > 0 then
      Info_Hero_Army = Info_Hero_Army .. 'ID' .. i .. ' = ' .. GetHeroCreatures(hero, i) .. ', '
    end;
  end;
  Info_Hero_Arts = 'Hero' .. player.. '_Arts: '
  for i = 1, 96 do
    if HasArtefact(hero, i, 1) then
      Info_Hero_Arts = Info_Hero_Arts .. 'ID' .. i .. ', '
    end;
  end;
  Info_Hero_Spells = 'Hero' .. player.. '_Spells: '
  for i = 0, 5 do
    for j = 1, length(array_spells[i]) do
      if KnowHeroSpell(hero, array_spells[i][j].id) then
        Info_Hero_Spells = Info_Hero_Spells .. 'ID' .. array_spells[i][j].id .. ', '
      end;
    end;
  end;
  Info_Hero_Skills = 'Hero' .. player.. '_Skills: '
  for i = 1, length(array_skills_id) do
    if GetHeroSkillMastery(hero, array_skills_id[i].name) > 0 then
      Info_Hero_Skills = Info_Hero_Skills .. 'ID' .. array_skills_id[i].ID .. ' = ' .. GetHeroSkillMastery(hero, array_skills_id[i].name) .. ', '
    end;
  end;
  Info_Hero_Perks = 'Hero' .. player.. '_Perks: '
  for i = 19, 220 do
    if GetHeroSkillMastery(hero, i) > 0 and i ~= 61 and i ~= 65 and i ~= 72 and i ~= 85 and i ~= 92 and i ~= 151 and i ~= 172 and i ~= 183 and i ~= 187
    and i ~= 191 and i ~= 195 and i ~= 199 and i ~= 203 then
      Info_Hero_Perks = Info_Hero_Perks .. 'ID' .. i .. ', '
    end;
  end;
  
  array_info[player] = {
     ["Name"] = Info_Hero_Name, ["Race"] = Info_Hero_Race, ["Attack"] = Info_Hero_Attack, ["Defence"] = Info_Hero_Defence, ["Spellpower"] = Info_Hero_Spellpower,
     ["Knowledge"] = Info_Hero_Knowledge, ["Luck"] = Info_Hero_Luck, ["Morale"] = Info_Hero_Morale, ["Mana"] = Info_Hero_Mana, ["Level"] = Info_Hero_Level,
     ["StartBonus"] = Info_Hero_StartBonus, ["Mentoring"] = Info_Hero_Mentoring, ["Army"] = Info_Hero_Army, ["Arts"] = Info_Hero_Arts, ["Spells"] = Info_Hero_Spells,
     ["Skills"] = Info_Hero_Skills, ["Perks"] = Info_Hero_Perks }

--  print(Info_Hero_Name);
--  print(Info_Hero_Level);
--  print(Info_Hero_Attack);
--  print(Info_Hero_Defence);
--  print(Info_Hero_Spellpower);
--  print(Info_Hero_Knowledge);
--  print(Info_Hero_Luck);
--  print(Info_Hero_Morale);
--  print(Info_Hero_StartBonus);
--  print(Info_Hero_Army);
--  print(Info_Hero_Arts);
--  print(Info_Hero_Spells);
--  print(Info_Hero_Skills);
--  print(Info_Hero_Perks);
end;


----------------------- HERO SPEC -------------------------

array_Gles = {};
array_Gles = {0, 0, 0, 0, 0, 0, 0};

array_GlesOpp = {};
array_GlesOpp = {0, 0, 0, 0, 0, 0, 0};

function SpecGles (hero1, hero2)
  CreaturesGles = 0;
  CreaturesGlesOpp = 0;
  array_Gles[0], array_Gles[1], array_Gles[2], array_Gles[3], array_Gles[4], array_Gles[5], array_Gles[6] = GetHeroCreaturesTypes(hero1);
  array_GlesOpp[0], array_GlesOpp[1], array_GlesOpp[2], array_GlesOpp[3], array_GlesOpp[4], array_GlesOpp[5], array_GlesOpp[6] = GetHeroCreaturesTypes(hero2);
  for i = 0, 6 do
    if array_Gles[i] > 0 and array_Gles[i] < 180 then
      CreaturesGles = CreaturesGles + 1;
    end;
    if array_GlesOpp[i] > 0 and array_GlesOpp[i] < 180 then
      CreaturesGlesOpp = CreaturesGlesOpp + 1;
    end;
  end;
  GiveHeroBattleBonus(hero1, HERO_BATTLE_BONUS_DEFENCE, ((CreaturesGlesOpp - CreaturesGles) * 2 + int((GetHeroLevel(hero1) - GetHeroLevel(hero2)) / 2)));
end;

function SpecVegeyr (hero)
  if KnowHeroSpell (hero, SPELL_LIGHTNING_BOLT) then
    TeachHeroSpell (hero, SPELL_EMPOWERED_LIGHTNING_BOLT);
  end;
  if KnowHeroSpell (hero, SPELL_CHAIN_LIGHTNING) then
    TeachHeroSpell (hero, SPELL_EMPOWERED_CHAIN_LIGHTNING);
  end;
end;

function SpecOrnella(hero)
  MessageBoxForPlayers(GetPlayerFilter( GetObjectOwner(hero) ), GetMapDataPath().."OrnellaInfo.txt" );
  if HasHeroSkill(hero, 62) then
    if GetHeroCreatures(hero,  29) > GetHeroCreatures(hero, 152) then
      kolCreatures = GetHeroCreatures(hero,  29) + GetHeroCreatures(hero, 152);
      AddHeroCreatures(hero, 152, GetHeroCreatures(hero,  29));
      RemoveHeroCreatures(hero,  29, GetHeroCreatures(hero,  29));
      AddHeroCreatures(hero,  95, kolCreatures);
    else
      kolCreatures = GetHeroCreatures(hero,  29) + GetHeroCreatures(hero, 152);
      if GetHeroCreatures(hero, 152) > 0 then
        AddHeroCreatures(hero, 29, GetHeroCreatures(hero, 152));
        RemoveHeroCreatures(hero, 152, GetHeroCreatures(hero, 152));
        AddHeroCreatures(hero, 97, kolCreatures);
      end;
    end;
  else
    if GetHeroCreatures(hero,  29) > 0 then
      AddHeroCreatures(hero, 152, GetHeroCreatures(hero,  29));
    end;
    if (GetHeroCreatures(hero, 152) - GetHeroCreatures(hero, 29)) > 0 then
      AddHeroCreatures(hero,  29, GetHeroCreatures(hero, 152) - GetHeroCreatures(hero, 29));
    end;
  end;
end;

function SpecEllaina1()
  Tier1UnitInTown1 = GetObjectDwellingCreatures('RANDOMTOWN1', 1);
  while GetObjectDwellingCreatures('RANDOMTOWN1', 1) > 0 or Ellaina1 == 1 do
    if Tier1UnitInTown1 > GetObjectDwellingCreatures('RANDOMTOWN1', 1) then
      SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + EllainaDiscount * (Tier1UnitInTown1 - GetObjectDwellingCreatures('RANDOMTOWN1', 1))));
      ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = int(EllainaDiscount * (Tier1UnitInTown1 - GetObjectDwellingCreatures('RANDOMTOWN1', 1)))}, HeroMax1, 1, random(6) + 3);
      Tier1UnitInTown1 = GetObjectDwellingCreatures('RANDOMTOWN1', 1);
      if GetObjectDwellingCreatures('RANDOMTOWN1', 1) == 0 then Ellaina1 = 2; end;
    end;
    sleep(10);
  end;
end;

function SpecEllaina2()
  Tier1UnitInTown2 = GetObjectDwellingCreatures('RANDOMTOWN2', 1);
  while GetObjectDwellingCreatures('RANDOMTOWN2', 1) > 0 or Ellaina2 == 1 do
    if Tier1UnitInTown2 > GetObjectDwellingCreatures('RANDOMTOWN2', 1) then
      SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + EllainaDiscount * (Tier1UnitInTown2 - GetObjectDwellingCreatures('RANDOMTOWN2', 1))));
      ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = int(EllainaDiscount * (Tier1UnitInTown2 - GetObjectDwellingCreatures('RANDOMTOWN2', 1)))}, HeroMax2, 2, random(6) + 3);
      Tier1UnitInTown2 = GetObjectDwellingCreatures('RANDOMTOWN2', 1);
      if GetObjectDwellingCreatures('RANDOMTOWN2', 1) == 0 then Ellaina2 = 2; end;
    end;
    sleep(10);
  end;
end;

function SpecValeria(hero)
  if KnowHeroSpell( hero, 11) then TeachHeroSpell( hero, 210); end;
  if KnowHeroSpell( hero, 12) then TeachHeroSpell( hero, 212); end;
  if KnowHeroSpell( hero, 13) then TeachHeroSpell( hero, 211); end;
  if KnowHeroSpell( hero, 14) then TeachHeroSpell( hero, 214); end;
  if KnowHeroSpell( hero, 15) then TeachHeroSpell( hero, 215); end;
  if KnowHeroSpell( hero, 17) then TeachHeroSpell( hero, 213); end;
end;

array_FreeRunes = {}
array_FreeRunes = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}

function SpecInga1()
  if GetHeroLevel(HeroMax1) == IngaLevel then
    kolRunes = 0;
  end;
  if frac(GetHeroLevel(HeroMax1) / IngaLevel) == 0 and (GetDate (DAY) == 3 or GetDate (DAY) == 4) then
    for i = 1, 10 do
      if array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 1; end;
      for j = 15, 19 do
        if i == spells[0][j].sp and array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 0; end;
      end;
--      print(array_FreeRunes[i]);
    end;
    RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax1, HERO_SKILL_RUNELORE)) + 1;
    while array_FreeRunes[RuneForInga] == 0 or array_FreeRunes[RuneForInga] == 2 do
      RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax1, HERO_SKILL_RUNELORE)) + 1;
    end;
    TeachHeroSpell(HeroMax1, array_spells[4][RuneForInga].id);
    array_FreeRunes[RuneForInga] = 2;
    kolRunes = kolRunes + 1;
  end;
  if GetDate (DAY) == 5 then
    if GetHeroLevel(HeroMax1) < 4 * IngaLevel then
      k = 3 - kolRunes;
    else
      if GetHeroSkillMastery( HeroMax1, HERO_SKILL_RUNELORE) > 1 then
        k = 4 - kolRunes;
      else
        k = 3 - kolRunes;
      end;
    end;
    if k > 0 then
      for i = 1, 10 do
        if array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 1; end;
        for j = 15, 19 do
          if i == spells[0][j].sp and array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 0; end;
        end;
--        print(array_FreeRunes[i]);
      end;
      for i = 1, k do
        RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax1, HERO_SKILL_RUNELORE)) + 1;
        while array_FreeRunes[RuneForInga] == 0 or array_FreeRunes[RuneForInga] == 2 do
          RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax1, HERO_SKILL_RUNELORE)) + 1;
        end;
        TeachHeroSpell(HeroMax1, array_spells[4][RuneForInga].id);
        array_FreeRunes[RuneForInga] = 2;
      end;
    end;
  end;
end;

function SpecInga2()
  if GetHeroLevel(HeroMax2) == IngaLevel then
    kolRunes = 0;
  end;
  if frac(GetHeroLevel(HeroMax2) / IngaLevel) == 0 and (GetDate (DAY) == 3 or GetDate (DAY) == 4) then
    for i = 1, 10 do
      if array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 1; end;
      for j = 15, 19 do
        if i == spells[1][j].sp and array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 0; end;
      end;
--      print(array_FreeRunes[i]);
    end;
    RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax2, HERO_SKILL_RUNELORE)) + 1;
    while array_FreeRunes[RuneForInga] == 0 or array_FreeRunes[RuneForInga] == 2 do
      RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax2, HERO_SKILL_RUNELORE)) + 1;
    end;
    TeachHeroSpell(HeroMax2, array_spells[4][RuneForInga].id);
    array_FreeRunes[RuneForInga] = 2;
    kolRunes = kolRunes + 1;
  end;
  if GetDate (DAY) == 5 then
    if GetHeroLevel(HeroMax2) < 4 * IngaLevel then
      k = 3 - kolRunes;
    else
      if GetHeroSkillMastery( HeroMax2, HERO_SKILL_RUNELORE) > 1 then
        k = 4 - kolRunes;
      else
        k = 3 - kolRunes;
      end;
    end;
    if k > 0 then
      for i = 1, 10 do
        if array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 1; end;
        for j = 15, 19 do
          if i == spells[1][j].sp and array_FreeRunes[i] ~= 2 then array_FreeRunes[i] = 0; end;
        end;
--        print(array_FreeRunes[i]);
      end;
      for i = 1, k do
        RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax2, HERO_SKILL_RUNELORE)) + 1;
        while array_FreeRunes[RuneForInga] == 0 or array_FreeRunes[RuneForInga] == 2 do
          RuneForInga = random(4 + 2 * GetHeroSkillMastery( HeroMax2, HERO_SKILL_RUNELORE)) + 1;
        end;
        TeachHeroSpell(HeroMax2, array_spells[4][RuneForInga].id);
        array_FreeRunes[RuneForInga] = 2;
      end;
    end;
  end;
end;

function CrownLeader(hero)
  kol_u[1]=0;kol_u[2]=0;kol_u[3]=0;kol_u[4]=0;kol_u[5]=0;kol_u[6]=0;kol_u[7]=0;
  kol_u[1], kol_u[2], kol_u[3], kol_u[4], kol_u[5], kol_u[6], kol_u[7] = GetHeroCreaturesTypes(hero);
  for i = 1, 7 do
    if kol_u[i] > 0 then
      AddHeroCreatures(hero, kol_u[i], 1);
    end;
  end;
end;


----------------------------- GLOBAL MODE --------------------------------------


SinergyLevelPrevSpellpower1 = 0;
SinergyLevelPrevKnowledge1  = 0;
SinergyLevelPrevSpellpower2 = 0;
SinergyLevelPrevKnowledge2  = 0;


function SinergySpellpower(hero)
  if GetObjectOwner(hero) == PLAYER_1 then
    SinergyLevel1 = 0;
    if GetHeroSkillMastery(hero, SKILL_DESTRUCTIVE_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,        SKILL_DARK_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,       SKILL_LIGHT_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,   SKILL_SUMMONING_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if HasHeroSkill(hero, 87) then SinergyLevel1 = SinergyLevel1; else SinergyLevel1 = 0; end;

    if SinergyLevel1 > SinergyLevelPrevSpellpower1 then
      ChangeHeroStat(hero, 3, 2 * (SinergyLevel1 - SinergyLevelPrevSpellpower1));
      SinergyLevelPrevSpellpower1 = SinergyLevel1;
    end;

    if SinergyLevel1 < SinergyLevelPrevSpellpower1 then
      ChangeHeroStat(hero, 3, 2 * (SinergyLevel1 - SinergyLevelPrevSpellpower1));
      SinergyLevelPrevSpellpower1 = SinergyLevel1;
    end;
  end;

  if GetObjectOwner(hero) == PLAYER_2 then
    SinergyLevel2 = 0;
    if GetHeroSkillMastery(hero, SKILL_DESTRUCTIVE_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,        SKILL_DARK_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,       SKILL_LIGHT_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,   SKILL_SUMMONING_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if HasHeroSkill(hero, 87) then SinergyLevel2 = SinergyLevel2; else SinergyLevel2 = 0; end;

    if SinergyLevel2 > SinergyLevelPrevSpellpower2 then
      ChangeHeroStat(hero, 3, 2 * (SinergyLevel2 - SinergyLevelPrevSpellpower2));
      SinergyLevelPrevSpellpower2 = SinergyLevel2;
    end;

    if SinergyLevel2 < SinergyLevelPrevSpellpower2 then
      ChangeHeroStat(hero, 3, 2 * (SinergyLevel2 - SinergyLevelPrevSpellpower2));
      SinergyLevelPrevSpellpower2 = SinergyLevel2;
    end;
  end;
end;


function SinergyKnowledge(hero)
  if GetObjectOwner(hero) == PLAYER_1 then
    SinergyLevel1 = 0;
    if GetHeroSkillMastery(hero, SKILL_DESTRUCTIVE_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,        SKILL_DARK_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,       SKILL_LIGHT_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if GetHeroSkillMastery(hero,   SKILL_SUMMONING_MAGIC) > 0 then SinergyLevel1 = SinergyLevel1 + 1; end;
    if HasHeroSkill(hero, 81) then SinergyLevel1 = SinergyLevel1; else SinergyLevel1 = 0; end;

    if SinergyLevel1 > SinergyLevelPrevKnowledge1 then
      ChangeHeroStat(hero, 4, 2 * (SinergyLevel1 - SinergyLevelPrevKnowledge1));
      SinergyLevelPrevKnowledge1 = SinergyLevel1;
    end;

    if SinergyLevel1 < SinergyLevelPrevKnowledge1 then
      ChangeHeroStat(hero, 4, 2 * (SinergyLevel1 - SinergyLevelPrevKnowledge1));
      SinergyLevelPrevKnowledge1 = SinergyLevel1;
    end;
  end;

  if GetObjectOwner(hero) == PLAYER_2 then
    SinergyLevel2 = 0;
    if GetHeroSkillMastery(hero, SKILL_DESTRUCTIVE_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,        SKILL_DARK_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,       SKILL_LIGHT_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if GetHeroSkillMastery(hero,   SKILL_SUMMONING_MAGIC) > 0 then SinergyLevel2 = SinergyLevel2 + 1; end;
    if HasHeroSkill(hero, 81) then SinergyLevel2 = SinergyLevel2; else SinergyLevel2 = 0; end;

    if SinergyLevel2 > SinergyLevelPrevKnowledge2 then
      ChangeHeroStat(hero, 4, 2 * (SinergyLevel2 - SinergyLevelPrevKnowledge2));
      SinergyLevelPrevKnowledge2 = SinergyLevel2;
    end;

    if SinergyLevel2 < SinergyLevelPrevKnowledge2 then
      ChangeHeroStat(hero, 4, 2 * (SinergyLevel2 - SinergyLevelPrevKnowledge2));
      SinergyLevelPrevKnowledge2 = SinergyLevel2;
    end;
  end;
end;


array_level = {};
array_level = {       0,         -- 0    1
                   1000,         -- 1    2
                   2000,         -- 2    3
                   3200,         -- 3    4
                   4600,         -- 4    5
                   6200,         -- 5    6
                   8000,         -- 6    7
                  10000,         -- 7    8
                  12200,         -- 8    9
                  14700,         -- 9    10
                  17500,         --10    11
                  20600,         --11    12
                  24320,         --12    13
                  28784,         --13    14
                  34140,         --14    15
                  40567,         --15    16
                  48279,         --16    17
                  57533,         --17    18
                  68637,         --18    19
                  81961,         --19    20
                  97949,         --20    21
                 117134,         --21    22
                 140156,         --22    23
                 167782,         --23    24
                 200933,         --24    25
                 244029,         --25    26
                 304363,         --26    27
                 394864,         --27    28
                 539665,         --28    29
                 785826,         --29    30
                1228915,         --30    31
                2070784,         --31    32
                3754522,         --32    33
                7290371,         --33    34
               15069240,         --34    35
               32960630,         --35    36
               75899970,         --36    37
              183258314,         --37    38
              462353978,         --38    39
             1215939194};        --39    40

function ChangeLevel(hero, delta)
  heroExp = GetHeroStat(hero, STAT_EXPERIENCE);
  heroLevel = GetHeroLevel(hero);
  deltaExp = array_level[heroLevel + delta + 1] - array_level[heroLevel + 1];
--  print("deltaExp")
--  print( deltaExp )
  WarpHeroExp (hero, heroExp + deltaExp);
--  print(GetHeroStat(hero, STAT_EXPERIENCE));
end;


RevDel1 = 0;
RevDel2 = 0;

DT_use1 = 0;
DT_use2 = 0;
DT_use1prev = 0;
DT_use2prev = 0;

array_DR = {}
array_DR[1] = {0, 0, 0, 0}
array_DR[2] = {0, 0, 0, 0}

function DarkRitual()
  varDT = 0;
  while varDT < 1 and GetDate (DAY) == 3 do
    sleep (10);
    if GetHeroStat(HeroMax1, STAT_MOVE_POINTS) == 0 and GetHeroStat(HeroMax1, STAT_MANA_POINTS) > 0 and DT_use1 == 0 and GetDate (DAY) == 3 then
      DT_use1 = 1;
      nap1Plus3Q(HeroMax1);
    elseif GetHeroStat(HeroMax1, STAT_MANA_POINTS) > 0 and DT_use1 == 0 and GetDate (DAY) == 3 then
      ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax1, STAT_MANA_POINTS));
    end;
    --nap1Plus3Q(HeroMax1); end; /UI/H5A1/Icons/Heroes/Portrets128x128/Giovanni.(Texture).xdb#xpointer(/Texture)
    if GetHeroStat(HeroMax2, STAT_MOVE_POINTS) == 0 and GetHeroStat(HeroMax2, STAT_MANA_POINTS) > 0 and DT_use2 == 0 and GetDate (DAY) == 3 then
      DT_use2 = 1;
      nap2Plus3Q(HeroMax2);
    elseif GetHeroStat(HeroMax2, STAT_MANA_POINTS) > 0 and DT_use2 == 0 and GetDate (DAY) == 3 then
      ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax2, STAT_MANA_POINTS));
    end;
  end;
end;

function Talk1(g1,g2)
  k = 1;
  DT_use1 = g2;
  if HeroMax1 == "Almegir" or HeroMax1 == "Almegir2" then k = 2; end;
  if g2 > 0 and GetDate (DAY) == 3 then
    for i = 1, k do
      for j = 1, 4 do
        if j < 3 then
          if j ~= g2 and GetHeroStat(HeroMax1, j) > 0 then
            ChangeHeroStat(HeroMax1,  j, -1);
            ChangeHeroStat(HeroMax1, g2,  1);
          end;
        else
          if j ~= g2 and GetHeroStat(HeroMax1, j) > 1 then
            ChangeHeroStat(HeroMax1,  j, -1);
            ChangeHeroStat(HeroMax1, g2,  1);
          end;
        end;
      end;
      ChangeHeroStat(HeroMax1, g2,  1);
    end;
  end;
  ChangeHeroStat(HeroMax1, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax1, STAT_MANA_POINTS));
  if g2 == 0 then DT_use1 = 0; end;
end;

function Talk2(g1,g2)
  k = 1;
  DT_use2 = g2;
  if HeroMax2 == "Almegir" or HeroMax2 == "Almegir2" then k = 2; end;
  if g2 > 0 and GetDate (DAY) == 3 then
    for i = 1, k do
      for j = 1, 4 do
        if j < 3 then
          if j ~= g2 and GetHeroStat(HeroMax2, j) > 0 then
            ChangeHeroStat(HeroMax2,  j, -1);
            ChangeHeroStat(HeroMax2, g2,  1);
          end;
        else
          if j ~= g2 and GetHeroStat(HeroMax2, j) > 1 then
            ChangeHeroStat(HeroMax2,  j, -1);
            ChangeHeroStat(HeroMax2, g2,  1);
          end;
        end;
      end;
      ChangeHeroStat(HeroMax2, g2,  1);
    end;
  end;
  ChangeHeroStat(HeroMax2, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax2, STAT_MANA_POINTS));
  if g2 == 0 then DT_use2 = 0; end;
end;

function nap1Plus3Q(hero)
  hero1 = hero;
  DT_use1 = 5;
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."napPlus3.txt", 'nap1Plus3', 'zaw1Plus3Q');
end;

function zaw1Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."zawPlus3.txt", 'zaw1Plus3', 'kol1Plus3Q');
end;

function kol1Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."kolPlus3.txt", 'kol1Plus3', 'zna1Plus3Q');
end;

function zna1Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."znaPlus3.txt", 'zna1Plus3', 'noDR');
end;

function nap2Plus3Q(hero)
  hero2 = hero;
  DT_use2 = 5;
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."napPlus3.txt", 'nap2Plus3', 'zaw2Plus3Q');
end;

function zaw2Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."zawPlus3.txt", 'zaw2Plus3', 'kol2Plus3Q');
end;

function kol2Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."kolPlus3.txt", 'kol2Plus3', 'zna2Plus3Q');
end;

function zna2Plus3Q()
  QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."znaPlus3.txt", 'zna2Plus3', 'noDR');
end;

function noDR(player)
  if player == PLAYER_1 then
    ChangeHeroStat(HeroMax1, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(HeroMax1, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax1, STAT_MANA_POINTS));
    DT_use1 = 0;
  end;
  if player == PLAYER_2 then
    ChangeHeroStat(HeroMax2, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(HeroMax2, STAT_MANA_POINTS, 0 - GetHeroStat(HeroMax2, STAT_MANA_POINTS));
    DT_use2 = 0;
  end;
end;

function nap1Plus3()
  k = 1;
  if hero1 == "Almegir" or hero1 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero1, 2) > 0 then
      ChangeHeroStat(hero1, 1,  1);
      ChangeHeroStat(hero1, 2, -1);
      array_DR[1][2] = array_DR[1][2] - 1;
    end;
    if GetHeroStat(hero1, 3) > 1 then
      ChangeHeroStat(hero1, 1,  1);
      ChangeHeroStat(hero1, 3, -1);
      array_DR[1][3] = array_DR[1][3] - 1;
    end;
    if GetHeroStat(hero1, 4) > 1 then
      ChangeHeroStat(hero1, 1,  1);
      ChangeHeroStat(hero1, 4, -1);
      array_DR[1][4] = array_DR[1][4] - 1;
    end;
    ChangeHeroStat(hero1, 1,  1);
    array_DR[1][1] = array_DR[1][1] + 1;
  end;
  if GetDate (DAY) == 3 then
    ChangeHeroStat(hero1, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(hero1, STAT_MANA_POINTS, 0 - GetHeroStat(hero1, STAT_MANA_POINTS));
  end;
  DT_use1 = 1;
end;

function zaw1Plus3()
  k = 1;
  if hero1 == "Almegir" or hero1 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero1, 1) > 0 then
      ChangeHeroStat(hero1, 2,  1);
      ChangeHeroStat(hero1, 1, -1);
      array_DR[1][1] = array_DR[1][1] - 1;
    end;
    if GetHeroStat(hero1, 3) > 1 then
      ChangeHeroStat(hero1, 2,  1);
      ChangeHeroStat(hero1, 3, -1);
      array_DR[1][3] = array_DR[1][3] - 1;
    end;
    if GetHeroStat(hero1, 4) > 1 then
      ChangeHeroStat(hero1, 2,  1);
      ChangeHeroStat(hero1, 4, -1);
      array_DR[1][4] = array_DR[1][4] - 1;
    end;
    ChangeHeroStat(hero1, 2,  1);
    array_DR[1][2] = array_DR[1][2] + 1;
  end;
  if GetDate (DAY) == 3 then
    ChangeHeroStat(hero1, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(hero1, STAT_MANA_POINTS, 0 - GetHeroStat(hero1, STAT_MANA_POINTS));
  end;
  DT_use1 = 2;
end;

function kol1Plus3()
  k = 1;
  if hero1 == "Almegir" or hero1 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero1, 1) > 0 then
      ChangeHeroStat(hero1, 3,  1);
      ChangeHeroStat(hero1, 1, -1);
      array_DR[1][1] = array_DR[1][1] - 1;
    end;
    if GetHeroStat(hero1, 2) > 0 then
      ChangeHeroStat(hero1, 3,  1);
      ChangeHeroStat(hero1, 2, -1);
      array_DR[1][2] = array_DR[1][2] - 1;
    end;
    if GetHeroStat(hero1, 4) > 1 then
      ChangeHeroStat(hero1, 3,  1);
      ChangeHeroStat(hero1, 4, -1);
      array_DR[1][4] = array_DR[1][4] - 1;
    end;
    ChangeHeroStat(hero1, 3,  1);
    array_DR[1][3] = array_DR[1][3] + 1;
  end;
  if GetDate (DAY) == 3 then
    ChangeHeroStat(hero1, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(hero1, STAT_MANA_POINTS, 0 - GetHeroStat(hero1, STAT_MANA_POINTS));
  end;
  DT_use1 = 3;
end;

function zna1Plus3()
  k = 1;
  if hero1 == "Almegir" or hero1 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero1, 1) > 0 then
      ChangeHeroStat(hero1, 4,  1);
      ChangeHeroStat(hero1, 1, -1);
      array_DR[1][1] = array_DR[1][1] - 1;
    end;
    if GetHeroStat(hero1, 2) > 0 then
      ChangeHeroStat(hero1, 4,  1);
      ChangeHeroStat(hero1, 2, -1);
      array_DR[1][2] = array_DR[1][2] - 1;
    end;
    if GetHeroStat(hero1, 3) > 1 then
      ChangeHeroStat(hero1, 4,  1);
      ChangeHeroStat(hero1, 3, -1);
      array_DR[1][3] = array_DR[1][3] - 1;
    end;
    ChangeHeroStat(hero1, 4,  1);
    array_DR[1][4] = array_DR[1][4] + 1;
  end;
  if GetDate (DAY) == 3 then
    ChangeHeroStat(hero1, STAT_MOVE_POINTS, 20000);
    ChangeHeroStat(hero1, STAT_MANA_POINTS, 0 - GetHeroStat(hero1, STAT_MANA_POINTS));
  end;
  DT_use1 = 4;
end;

function nap2Plus3()
  k = 1;
  if hero2 == "Almegir" or hero2 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero2, 2) > 0 then
      ChangeHeroStat(hero2, 1,  1);
      ChangeHeroStat(hero2, 2, -1);
      array_DR[2][2] = array_DR[2][2] - 1;
    end;
    if GetHeroStat(hero2, 3) > 1 then
      ChangeHeroStat(hero2, 1,  1);
      ChangeHeroStat(hero2, 3, -1);
      array_DR[2][3] = array_DR[2][3] - 1;
    end;
    if GetHeroStat(hero2, 4) > 1 then
      ChangeHeroStat(hero2, 1,  1);
      ChangeHeroStat(hero2, 4, -1);
      array_DR[2][4] = array_DR[2][4] - 1;
    end;
    ChangeHeroStat(hero2, 1,  1);
    array_DR[2][1] = array_DR[2][1] + 1;
  end;
  ChangeHeroStat(hero2, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(hero2, STAT_MANA_POINTS, 0 - GetHeroStat(hero2, STAT_MANA_POINTS));
  DT_use2 = 1;
end;

function zaw2Plus3()
  k = 1;
  if hero2 == "Almegir" or hero2 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero2, 1) > 0 then
      ChangeHeroStat(hero2, 2,  1);
      ChangeHeroStat(hero2, 1, -1);
      array_DR[2][1] = array_DR[2][1] - 1;
    end;
    if GetHeroStat(hero2, 3) > 1 then
      ChangeHeroStat(hero2, 2,  1);
      ChangeHeroStat(hero2, 3, -1);
      array_DR[2][3] = array_DR[2][3] - 1;
    end;
    if GetHeroStat(hero2, 4) > 1 then
      ChangeHeroStat(hero2, 2,  1);
      ChangeHeroStat(hero2, 4, -1);
      array_DR[2][4] = array_DR[2][4] - 1;
    end;
    ChangeHeroStat(hero2, 2,  1);
    array_DR[2][2] = array_DR[2][2] + 1;
  end;
  ChangeHeroStat(hero2, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(hero2, STAT_MANA_POINTS, 0 - GetHeroStat(hero2, STAT_MANA_POINTS));
  DT_use2 = 2;
end;

function kol2Plus3()
  k = 1;
  if hero2 == "Almegir" or hero2 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero2, 1) > 0 then
      ChangeHeroStat(hero2, 3,  1);
      ChangeHeroStat(hero2, 1, -1);
      array_DR[2][1] = array_DR[2][1] - 1;
    end;
    if GetHeroStat(hero2, 2) > 0 then
      ChangeHeroStat(hero2, 3,  1);
      ChangeHeroStat(hero2, 2, -1);
      array_DR[2][2] = array_DR[2][2] - 1;
    end;
    if GetHeroStat(hero2, 4) > 1 then
      ChangeHeroStat(hero2, 3,  1);
      ChangeHeroStat(hero2, 4, -1);
      array_DR[2][4] = array_DR[2][4] - 1;
    end;
    ChangeHeroStat(hero2, 3,  1);
    array_DR[2][3] = array_DR[2][3] + 1;
  end;
  ChangeHeroStat(hero2, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(hero2, STAT_MANA_POINTS, 0 - GetHeroStat(hero2, STAT_MANA_POINTS));
  DT_use2 = 3;
end;

function zna2Plus3()
  k = 1;
  if hero2 == "Almegir" or hero2 == "Almegir2" then k = 2; end;
  for i = 1, k do
    if GetHeroStat(hero2, 1) > 0 then
      ChangeHeroStat(hero2, 4,  1);
      ChangeHeroStat(hero2, 1, -1);
      array_DR[2][1] = array_DR[2][1] - 1;
    end;
    if GetHeroStat(hero2, 2) > 0 then
      ChangeHeroStat(hero2, 4,  1);
      ChangeHeroStat(hero2, 2, -1);
      array_DR[2][2] = array_DR[2][2] - 1;
    end;
    if GetHeroStat(hero2, 3) > 1 then
      ChangeHeroStat(hero2, 4,  1);
      ChangeHeroStat(hero2, 3, -1);
      array_DR[2][3] = array_DR[2][3] - 1;
    end;
    ChangeHeroStat(hero2, 4,  1);
    array_DR[2][4] = array_DR[2][4] + 1;
  end;
  ChangeHeroStat(hero2, STAT_MOVE_POINTS, 20000);
  ChangeHeroStat(hero2, STAT_MANA_POINTS, 0 - GetHeroStat(hero2, STAT_MANA_POINTS));
  DT_use2 = 4;
end;

function RemoveDarkRitual1(hero)
  ChangeHeroStat(hero, 1, 0 - array_DR[1][1]);
  ChangeHeroStat(hero, 2, 0 - array_DR[1][2]);
  ChangeHeroStat(hero, 3, 0 - array_DR[1][3]);
  ChangeHeroStat(hero, 4, 0 - array_DR[1][4]);
  DT_use1prev = DT_use1;
  DT_use1 = 0;
end;

function RemoveDarkRitual2(hero)
  ChangeHeroStat(hero, 1, 0 - array_DR[2][1]);
  ChangeHeroStat(hero, 2, 0 - array_DR[2][2]);
  ChangeHeroStat(hero, 3, 0 - array_DR[2][3]);
  ChangeHeroStat(hero, 4, 0 - array_DR[2][4]);
  DT_use2prev = DT_use2;
  DT_use2 = 0;
end;

function Revelation1()
  if RevDel1 == 1 then
    RevDel1 = 2;
    heroLevel = GetHeroLevel(HeroMax1);
    Exp = array_level[heroLevel - 2];
    WarpHeroExp(HeroMax1, Exp);
    i = 0;
    while i < 3 do
      race = getrace(HeroMax1);
      rnd = random(100);
      if rnd < PercentA[race] and GetHeroStat(HeroMax1, STAT_ATTACK) > 0  then
        ChangeHeroStat(HeroMax1, STAT_ATTACK, -1); i = i + 1;
      end;
      if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) and GetHeroStat(HeroMax1, STAT_DEFENCE) > 0 then
        ChangeHeroStat(HeroMax1, STAT_DEFENCE, -1); i = i + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax1, STAT_SPELL_POWER) > 1 then
        ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, -1); i = i + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax1, STAT_KNOWLEDGE) > 1 then
        ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, -1); i = i + 1;
      end;
    end;
  end;
  if RevDel1 == 0 then
    RevDel1 = 1;
  end;
  if RevDel1 == 3 then
    if RevUse1 == 3 then
      LevelUpHero(HeroMax1);
      RevDel1 = 4;
--      print(Exp);
    end;
    if RevUse1 == 1 then
      RevUse1 = 3;
      heroLevel = GetHeroLevel(HeroMax1);
      Exp = array_level[heroLevel - 2];
      WarpHeroExp(HeroMax1, Exp);
      i = 0;
      while i < 3 do
        race = getrace(HeroMax1);
        rnd = random(100);
        if rnd < PercentA[race] and GetHeroStat(HeroMax1, STAT_ATTACK) > 0  then
          ChangeHeroStat(HeroMax1, STAT_ATTACK, -1); i = i + 1;
        end;
        if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) and GetHeroStat(HeroMax1, STAT_DEFENCE) > 0 then
          ChangeHeroStat(HeroMax1, STAT_DEFENCE, -1); i = i + 1;
        end;
        if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax1, STAT_SPELL_POWER) > 1 then
          ChangeHeroStat(HeroMax1, STAT_SPELL_POWER, -1); i = i + 1;
        end;
        if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax1, STAT_KNOWLEDGE) > 1 then
          ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE, -1); i = i + 1;
        end;
      end;
      LevelUpHero(HeroMax1);
      RevUse1 = 4;
    end;
  end;
end;

function Revelation2()
  if RevDel2 == 1 then
    RevDel2 = 2;
    heroLevel = GetHeroLevel(HeroMax2);
    Exp = array_level[heroLevel - 2];
    WarpHeroExp(HeroMax2, Exp);
    i = 0;
    while i < 3 do
      race = getrace(HeroMax2);
      rnd = random(100);
      if rnd < PercentA[race] and GetHeroStat(HeroMax2, STAT_ATTACK) > 0  then
        ChangeHeroStat(HeroMax2, STAT_ATTACK, -1); i = i + 1;
      end;
      if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) and GetHeroStat(HeroMax2, STAT_DEFENCE) > 0 then
        ChangeHeroStat(HeroMax2, STAT_DEFENCE, -1); i = i + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax2, STAT_SPELL_POWER) > 1 then
        ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, -1); i = i + 1;
      end;
      if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax2, STAT_KNOWLEDGE) > 1 then
        ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, -1); i = i + 1;
      end;
    end;
  end;
  if RevDel2 == 0 then
    RevDel2 = 1;
  end;
  if RevDel2 == 3 then
    if RevUse2 == 3 then
      LevelUpHero(HeroMax2);
      RevDel2 = 4;
--      print(Exp);
    end;
    if RevUse2 == 1 then
      RevUse2 = 3;
      heroLevel = GetHeroLevel(HeroMax2);
      Exp = array_level[heroLevel - 2];
      WarpHeroExp(HeroMax2, Exp);
      i = 0;
      while i < 3 do
        race = getrace(HeroMax2);
        rnd = random(100);
        if rnd < PercentA[race] and GetHeroStat(HeroMax2, STAT_ATTACK) > 0  then
          ChangeHeroStat(HeroMax2, STAT_ATTACK, -1); i = i + 1;
        end;
        if rnd >= PercentA[race] and rnd < (PercentA[race] + PercentD[race]) and GetHeroStat(HeroMax2, STAT_DEFENCE) > 0 then
          ChangeHeroStat(HeroMax2, STAT_DEFENCE, -1); i = i + 1;
        end;
        if rnd >= (PercentA[race] + PercentD[race]) and rnd < (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax2, STAT_SPELL_POWER) > 1 then
          ChangeHeroStat(HeroMax2, STAT_SPELL_POWER, -1); i = i + 1;
        end;
        if rnd >= (PercentA[race] + PercentD[race] + PercentS[race]) and GetHeroStat(HeroMax2, STAT_KNOWLEDGE) > 1 then
          ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE, -1); i = i + 1;
        end;
      end;
      LevelUpHero(HeroMax2);
      RevUse2 = 4;
    end;
  end;
end;

function RevelationDel1(hero)
  if RevDel1 == 2 then
    heroLevel = GetHeroLevel(hero);
    deltaExp = array_level[heroLevel] - array_level[heroLevel - 2];
    HeroAt  = GetHeroStat(hero, 1);
    HeroDef = GetHeroStat(hero, 2);
    HeroSp  = GetHeroStat(hero, 3);
    HeroKn  = GetHeroStat(hero, 4);
    TakeAwayHeroExp(hero, deltaExp);
    RevDel1 = 3;
    WarpHeroExp(hero, array_level[heroLevel]);
    ChangeHeroStat(hero, 1, HeroAt  - GetHeroStat(hero, 1));
    ChangeHeroStat(hero, 2, HeroDef - GetHeroStat(hero, 2));
    ChangeHeroStat(hero, 3, HeroSp  - GetHeroStat(hero, 3));
    ChangeHeroStat(hero, 4, HeroKn  - GetHeroStat(hero, 4));
  end;
  if RevDel1 == 4 then
    heroLevel = GetHeroLevel(hero);
    deltaExp = array_level[heroLevel] - array_level[heroLevel - 2];
    HeroAt  = GetHeroStat(hero, 1);
    HeroDef = GetHeroStat(hero, 2);
    HeroSp  = GetHeroStat(hero, 3);
    HeroKn  = GetHeroStat(hero, 4);
    TakeAwayHeroExp(hero, deltaExp);
    RevDel1 = 3;
    RevUse1 = 1;
    WarpHeroExp(hero, array_level[heroLevel]);
    ChangeHeroStat(hero, 1, HeroAt  - GetHeroStat(hero, 1));
    ChangeHeroStat(hero, 2, HeroDef - GetHeroStat(hero, 2));
    ChangeHeroStat(hero, 3, HeroSp  - GetHeroStat(hero, 3));
    ChangeHeroStat(hero, 4, HeroKn  - GetHeroStat(hero, 4));
  end;
end;

function RevelationDel2(hero)
  if RevDel2 == 2 then
    heroLevel = GetHeroLevel(hero);
    deltaExp = array_level[heroLevel] - array_level[heroLevel - 2];
    HeroAt  = GetHeroStat(hero, 1);
    HeroDef = GetHeroStat(hero, 2);
    HeroSp  = GetHeroStat(hero, 3);
    HeroKn  = GetHeroStat(hero, 4);
    TakeAwayHeroExp(hero, deltaExp);
    RevDel2 = 3;
    WarpHeroExp(hero, array_level[heroLevel]);
    ChangeHeroStat(hero, 1, HeroAt  - GetHeroStat(hero, 1));
    ChangeHeroStat(hero, 2, HeroDef - GetHeroStat(hero, 2));
    ChangeHeroStat(hero, 3, HeroSp  - GetHeroStat(hero, 3));
    ChangeHeroStat(hero, 4, HeroKn  - GetHeroStat(hero, 4));
  end;
  if RevDel2 == 4 then
    heroLevel = GetHeroLevel(hero);
    deltaExp = array_level[heroLevel] - array_level[heroLevel - 2];
    HeroAt  = GetHeroStat(hero, 1);
    HeroDef = GetHeroStat(hero, 2);
    HeroSp  = GetHeroStat(hero, 3);
    HeroKn  = GetHeroStat(hero, 4);
    TakeAwayHeroExp(hero, deltaExp);
    RevDel2 = 3;
    RevUse2 = 1;
    WarpHeroExp(hero, array_level[heroLevel]);
    ChangeHeroStat(hero, 1, HeroAt  - GetHeroStat(hero, 1));
    ChangeHeroStat(hero, 2, HeroDef - GetHeroStat(hero, 2));
    ChangeHeroStat(hero, 3, HeroSp  - GetHeroStat(hero, 3));
    ChangeHeroStat(hero, 4, HeroKn  - GetHeroStat(hero, 4));
  end;
end;



Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'town', 'ChangeRandomTown' );

function ChangeRandomTown(hero)
  SetObjectOwner('TOWN', GetObjectOwner(hero));
  if GetObjectOwner(hero) == 1 then race = hero1race; end;
  if GetObjectOwner(hero) == 2 then race = hero2race; end;
  if race == 1 then TransformTown('TOWN', 0); end;
  if race == 2 then TransformTown('TOWN', 5); end;
  if race == 3 then TransformTown('TOWN', 4); end;
  if race == 4 then TransformTown('TOWN', 1); end;
  if race == 5 then TransformTown('TOWN', 2); end;
  if race == 6 then TransformTown('TOWN', 3); end;
  if race == 7 then TransformTown('TOWN', 6); end;
  if race == 8 then TransformTown('TOWN', 7); end;
  Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'town', 'no' );
  UpgradeTownBuilding('TOWN', 1);
  UpgradeTownBuilding('TOWN', 1);
end;

FortunateAdventureEnable1 = 0
FortunateAdventureEnable2 = 0

array_HasArtsSlot1 = {}
array_HasArtsSlot1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_HasArtsSlot2 = {}
array_HasArtsSlot2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

function Spoils1()
    for i = 0, 2 do
      for j = 1, length(array_arts[i]) do
        if HasArtefact(HeroMax1, array_arts[i][j].id) then
          if array_arts[i][j].place == 1 and array_HasArtsSlot1[1] == 2 then array_HasArtsSlot1[1] = 1; end;
          if array_arts[i][j].place == 1 and array_HasArtsSlot1[1] == 0 then array_HasArtsSlot1[1] = 2; end;
          if array_arts[i][j].place ~= 1 then
            array_HasArtsSlot1[array_arts[i][j].place] = 1;
          end;
        end;
      end;
    end;
    ArtNumber1 = random (length(array_arts[1])) + 1;
    while array_arts[1][ArtNumber1].blocked == 1 or HasArtefact(HeroMax1, array_arts[1][ArtNumber1].id, 0) or array_HasArtsSlot1[array_arts[1][ArtNumber1].place] == 1 do
      ArtNumber1 = random (length(array_arts[1])) + 1;
    end;
    GiveArtefact(HeroMax1, array_arts[1][ArtNumber1].id, 1);
    SpoilsUse1 = 1;
end;

function Spoils2()
    for i = 0, 2 do
      for j = 1, length(array_arts[i]) do
        if HasArtefact(HeroMax2, array_arts[i][j].id) then
          if array_arts[i][j].place == 1 and array_HasArtsSlot2[1] == 2 then array_HasArtsSlot2[1] = 1; end;
          if array_arts[i][j].place == 1 and array_HasArtsSlot2[1] == 0 then array_HasArtsSlot2[1] = 2; end;
          if array_arts[i][j].place ~= 1 then
            array_HasArtsSlot2[array_arts[i][j].place] = 1;
          end;
        end;
      end;
    end;
    ArtNumber2 = random (length(array_arts[1])) + 1;
    while array_arts[1][ArtNumber2].blocked == 1 or HasArtefact(HeroMax2, array_arts[1][ArtNumber2].id, 0) or array_HasArtsSlot2[array_arts[1][ArtNumber2].place] == 1 do
      ArtNumber2 = random (length(array_arts[1])) + 1;
    end;
    GiveArtefact(HeroMax2, array_arts[1][ArtNumber2].id, 1);
    SpoilsUse2 = 1;
end;

arrayArtsForFortunateAdventure1 = {}
arrayArtsForFortunateAdventure2 = {}

Trigger( OBJECT_TOUCH_TRIGGER, 'lavka1', 'ArtifactMerchant1' );
Trigger( OBJECT_TOUCH_TRIGGER, 'lavka2', 'ArtifactMerchant2' );

function ArtifactMerchant1(hero)
  if FortunateAdventureEnable1 == 1 then FortunateAdventureEnable1 = 2; end;
  if SpoilsUse1 == 0 and HasHeroSkill(hero, 129) then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Spoils.txt", 'Spoils1', 'no');
  end;
end;

function ArtifactMerchant2(hero)
  if FortunateAdventureEnable2 == 1 then FortunateAdventureEnable2 = 2; end;
  if SpoilsUse2 == 0 and HasHeroSkill(hero, 129) then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Spoils.txt", 'Spoils2', 'no');
  end;
end;

function FortunateAdventureBlockInTower1()
  if FortunateAdventureEnable1 == 1 then FortunateAdventureEnable1 = 2; end;
end;

function FortunateAdventureBlockInTower2()
  if FortunateAdventureEnable2 == 1 then FortunateAdventureEnable2 = 2; end;
end;

function FortunateAdventure1()
  if (hero1race == 5 or hero1race == 6) and IsHeroInTown(HeroMax1, 'RANDOMTOWN1', 1, 0) then
    MoveHeroRealTime(HeroMax1, 55, 80);
    Trigger( OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN1', 'FortunateAdventureBlockInTower1');
  end;
  arrayArtsForFortunateAdventure1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  kol_arts_hero1 = 0
  MakeHeroInteractWithObject (HeroMax1, 'FortunateAdventure1');
  FortunateAdventureEnable1 = 1;
  NewArt1 = 0;
  for lev_art1 = 0, 2 do
    for num_art1 = 1, length(array_arts[lev_art1]) do
      if HasArtefact(HeroMax1, array_arts[lev_art1][num_art1].id) then
        arrayArtsForFortunateAdventure1[kol_arts_hero1] = array_arts[lev_art1][num_art1].id;
        kol_arts_hero1 = kol_arts_hero1 + 1;
      end;
    end;
  end;
  while FortunateAdventureEnable1 == 1 do
    Gold1 = GetPlayerResource(PLAYER_1, GOLD);
    sleep(2);
    for lev_art1 = 0, 2 do
      for num_art1 = 1, length(array_arts[lev_art1]) do
        if HasArtefact(HeroMax1, array_arts[lev_art1][num_art1].id) then
          HasArt1 = 0;
          for i = 0, kol_arts_hero1 do
            if arrayArtsForFortunateAdventure1[i] == array_arts[lev_art1][num_art1].id then
              HasArt1 = 1;
            end;
          end;
        end;
        if HasArtefact(HeroMax1, array_arts[lev_art1][num_art1].id) and HasArt1 == 0 then
          arrayArtsForFortunateAdventure1[kol_arts_hero1] = array_arts[lev_art1][num_art1].id;
          kol_arts_hero1 = kol_arts_hero1 + 1;
          NewArt1 = 1;
        end;
        if NewArt1 == 1 and (Gold1 - GetPlayerResource(PLAYER_1, GOLD)) <= 1.05 * array_arts[lev_art1][num_art1].price and (Gold1 - GetPlayerResource(PLAYER_1, GOLD)) >= 0.95 * array_arts[lev_art1][num_art1].price and FortunateAdventureEnable1 == 1 then
          ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = int(FortunateAdventureDiscount * array_arts[lev_art1][num_art1].price)}, HeroMax1, 1, random(6) + 3);
          SetPlayerResource (PLAYER_1, GOLD, int(GetPlayerResource (PLAYER_1, GOLD) + FortunateAdventureDiscount * array_arts[lev_art1][num_art1].price));
          NewArt1 = 0;
        end;
      end;
    end;
    if FortunateAdventureEnable1 == 2 then break; end;
  end;
end;

function FortunateAdventure2()
  if (hero2race == 5 or hero2race == 6) and IsHeroInTown(HeroMax2, 'RANDOMTOWN2', 1, 0) then
    MoveHeroRealTime(HeroMax2, 33, 14);
    Trigger( OBJECT_TOUCH_TRIGGER, 'RANDOMTOWN2', 'FortunateAdventureBlockInTower2');
  end;
  arrayArtsForFortunateAdventure2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  kol_arts_hero2 = 0
  MakeHeroInteractWithObject (HeroMax2, 'FortunateAdventure2');
  FortunateAdventureEnable2 = 1;
  NewArt2 = 0;
  for lev_art2 = 0, 2 do
    for num_art2 = 1, length(array_arts[lev_art2]) do
      if HasArtefact(HeroMax2, array_arts[lev_art2][num_art2].id) then
        arrayArtsForFortunateAdventure2[kol_arts_hero2] = array_arts[lev_art2][num_art2].id;
        kol_arts_hero2 = kol_arts_hero2 + 1;
      end;
    end;
  end;
  while FortunateAdventureEnable2 == 1 do
    Gold2 = GetPlayerResource(PLAYER_2, GOLD);
    sleep(2);
    for lev_art2 = 0, 2 do
      for num_art2 = 1, length(array_arts[lev_art2]) do
        if HasArtefact(HeroMax2, array_arts[lev_art2][num_art2].id) then
          HasArt2 = 0;
          for i = 0, kol_arts_hero2 do
            if arrayArtsForFortunateAdventure2[i] == array_arts[lev_art2][num_art2].id then
              HasArt2 = 1;
            end;
          end;
        end;
        if HasArtefact(HeroMax2, array_arts[lev_art2][num_art2].id) and HasArt2 == 0 then
          arrayArtsForFortunateAdventure2[kol_arts_hero2] = array_arts[lev_art2][num_art2].id;
          kol_arts_hero2 = kol_arts_hero2 + 1;
          NewArt2 = 1;
        end;
        if NewArt2 == 1 and (Gold2 - GetPlayerResource(PLAYER_2, GOLD)) <= 1.05 * array_arts[lev_art2][num_art2].price and (Gold2 - GetPlayerResource(PLAYER_2, GOLD)) >= 0.95 * array_arts[lev_art2][num_art2].price and FortunateAdventureEnable2 == 1 then
          ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = int(FortunateAdventureDiscount * array_arts[lev_art2][num_art2].price)}, HeroMax2, 2, random(6) + 3);
          SetPlayerResource (PLAYER_2, GOLD, int(GetPlayerResource (PLAYER_2, GOLD) + FortunateAdventureDiscount * array_arts[lev_art2][num_art2].price));
          NewArt2 = 0;
        end;
      end;
    end;
    if FortunateAdventureEnable2 == 2 then break; end;
  end;
end;


ScoutingEnable1 = 0;
ScoutingEnable2 = 0;

function Scouting1Q()
  if ScoutingEnable1 == 0 then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Scouting.txt", 'Scouting1', 'no');
  end;
end;

function Scouting2Q()
  if ScoutingEnable2 == 0 then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Scouting.txt", 'Scouting2', 'no');
  end;
end;

function Scouting1()
  if ScoutingEnable1 == 0 then
--    for i = 1, 5 do
--      print(array_heroes[hero2race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].name);
--    end;
--    print('x');

    for i = 1, length(array_heroes[hero2race-1]) do
      array_heroes[hero2race-1][i].block_temply = 0;
    end;
--    SetObjectPosition(array_heroes[hero2race-1][arrayPossibleHeroes[2][1]].p5, 31, 90, GROUND);
    if CherkPossibleHeroesEnable == 1 then k = 4; else k = 5; end;
    for i = 1, k do
      if arrayPossibleHeroes[HeroCollectionPlayer2][i] ~= HeroForScouting1_Player2 and arrayPossibleHeroes[HeroCollectionPlayer2][i] ~= HeroForScouting2_Player2 and arrayPossibleHeroes[HeroCollectionPlayer2][i] > 0 then
        if HeroCollectionPlayer2 == 2 then
          RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].p5);
        end;
        if HeroCollectionPlayer2 == 3 then
          RemoveObject(array_heroes[hero2race-1][arrayPossibleHeroes[HeroCollectionPlayer2][i]].p7);
        end;
      end;
    end;

    if HalfLeveling2 == 1 then
      if HeroTavern2 == 0 then
        for i = 1, length(array_heroes[hero2race-1]) do
          if HeroMin2 == array_heroes[hero2race-1][i].name2 then
            if HeroCollectionPlayer2 == 2 then
              RemoveObject(array_heroes[hero2race-1][i].p5);
            end;
            if HeroCollectionPlayer2 == 3 then
              RemoveObject(array_heroes[hero2race-1][i].p7);
            end;
            array_heroes[hero2race-1][i].block_temply = 1;
            i = length(array_heroes[hero2race-1]);
          end;
        end;
      else
        MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."HeroTavern.txt" );
      end;
    end;
  end;
  ScoutingEnable1 = 1;
  MoveCameraForPlayers( 1, 31, 88, 0, 20, 0, 0, 0, 0, 1);
end;

function Scouting2()
  if ScoutingEnable2 == 0 then
--    for i = 1, 5 do
--      print(array_heroes[hero1race-1][arrayPossibleHeroes[HeroCollectionPlayer1][i]].name);
--    end;
--    print('y');

    for i = 1, length(array_heroes[hero1race-1]) do
      array_heroes[hero1race-1][i].block_temply = 0;
    end;
    if CherkPossibleHeroesEnable == 1 then k = 4; else k = 5; end;
    for i = 1, k do
      if arrayPossibleHeroes[HeroCollectionPlayer1][i] ~= HeroForScouting1_Player1 and arrayPossibleHeroes[HeroCollectionPlayer1][i] ~= HeroForScouting2_Player1 and arrayPossibleHeroes[HeroCollectionPlayer1][i] > 0 then
        if HeroCollectionPlayer1 == 0 then
          RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[HeroCollectionPlayer1][i]].p2);
        end;
        if HeroCollectionPlayer1 == 1 then
          RemoveObject(array_heroes[hero1race-1][arrayPossibleHeroes[HeroCollectionPlayer1][i]].p4);
        end;
      end;
    end;

    if HalfLeveling1 == 1 then
      if HeroTavern1 == 0 then
        for i = 1, length(array_heroes[hero1race-1]) do
          if HeroMin1 == array_heroes[hero1race-1][i].name then
            if HeroCollectionPlayer1 == 0 then
              RemoveObject(array_heroes[hero1race-1][i].p2);
            end;
            if HeroCollectionPlayer1 == 1 then
              RemoveObject(array_heroes[hero1race-1][i].p4);
            end;
            array_heroes[hero1race-1][i].block_temply = 1;
            i = length(array_heroes[hero1race-1]);
          end;
        end;
      else
        MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."HeroTavern.txt" );
      end;
    end;
  end;
  ScoutingEnable2 = 1;
  MoveCameraForPlayers( 2, 44, 23, 0, 20, 0, 3.14, 0, 0, 1);
end;

function Scouting1DopInfo()
  if HasHeroSkill(HeroMax2, 20) and ScoutingEnable2 == 1 then
    if HeroTavern1 == 0 then
      for i = 1, length(array_heroes[hero1race-1]) do
        if HeroMin1 == array_heroes[hero1race-1][i].name then
          if HeroCollectionPlayer1 == 0 then
            RemoveObject(array_heroes[hero1race-1][i].p2);
            print('hero1 del ', array_heroes[hero1race-1][i].name)
          end;
          if HeroCollectionPlayer1 == 1 then
            RemoveObject(array_heroes[hero1race-1][i].p4);
            print('hero1 del ', array_heroes[hero1race-1][i].name)
          end;
          array_heroes[hero1race-1][i].block_temply = 1;
          i = length(array_heroes[hero1race-1]);
        end;
      end;
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."HeroTop.txt" );
      MoveCameraForPlayers( 2, 44, 23, 0, 20, 0, 3.14, 0, 0, 1);
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."HeroTavern.txt" );
    end;
  end;
end;

function Scouting2DopInfo()
  if HasHeroSkill(HeroMax1, 20) and ScoutingEnable1 == 1 then
    if HeroTavern2 == 0 then
      print('length(array_heroes[hero2race-1] ', length(array_heroes[hero2race-1]))
      for i = 1, length(array_heroes[hero2race-1]) do
        if HeroMin2 == array_heroes[hero2race-1][i].name2 then
          if HeroCollectionPlayer2 == 2 then
            RemoveObject(array_heroes[hero2race-1][i].p5);
            print('hero2 del ', array_heroes[hero2race-1][i].name2)
          end;
          if HeroCollectionPlayer2 == 3 then
            RemoveObject(array_heroes[hero2race-1][i].p7);
            print('hero2 del ', array_heroes[hero2race-1][i].name2)
          end;
          array_heroes[hero2race-1][i].block_temply = 1;
          i = length(array_heroes[hero2race-1]);
        end;
      end;
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."HeroTop.txt" );
      MoveCameraForPlayers( 1, 33, 88, 0, 20, 0, 0, 0, 0, 1);
    else
      MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."HeroTavern.txt" );
    end;
  end;
end;

DisguiseEnable1 = 0;
DisguiseEnable2 = 0;
DisguiseHero1 = 0;
DisguiseHero2 = 0;

function Disguise1Q()
  if DisguiseEnable1 == 0 then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Disguise.txt", 'Disguise1', 'no');
  end;
end;

function Disguise2Q()
  if DisguiseEnable2 == 0 then
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Disguise.txt", 'Disguise2', 'no');
  end;
end;

function Disguise1()
  OpenCircleFog( 41, 23, 0, 5, 1 );
  MoveCameraForPlayers( 1, 41, 23, 0, 20, 0, 3.14, 0, 0, 1);
  DisguiseEnable1 = 1;
end;

function Disguise2()
  OpenCircleFog( 36, 88, 0, 5, 2 );
  MoveCameraForPlayers( 2, 36, 86, 0, 20, 0, 0, 0, 0, 1);
  DisguiseEnable2 = 1;
end;



EstatesQ1 = 0;
EstatesQ2 = 0;

function Estates1Q(hero)
  EstatesEnable1 = 1;
  if EstatesDiscountUse1 == 0 and GetHeroLevel(hero) >= HalfLevel and (RemSkSum1 > 0 or GetHeroLevel(hero) > StartLevel) then
    if GetHeroLevel(hero) < StartLevel then
      discount1 = RemSkSum1 * EstatesDiscountMentor;
    else
      discount1 = EstatesDiscountLevel * (GetHeroLevel(hero) - StartLevel) + RemSkSum1 * EstatesDiscountMentor;
    end;
    if EstatesQ1 == 0 then
      EstatesQ1 = 1;
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."EstatesQ.txt"; eq = discount1}, 'Estates1', 'EstatesNo1');
    end;
  end;
end;

function Estates1()
  if EstatesDiscountUse1 == 0 then
    SetPlayerResource(PLAYER_1, 6, GetPlayerResource(1, 6) + discount1);
    EstatesDiscountUse1 = 1;
  end;
end;

function EstatesNo1()
  EstatesQ1 = 0;
end;

function Estates2Q(hero)
  EstatesEnable2 = 1;
  if EstatesDiscountUse2 == 0 and GetHeroLevel(hero) >= HalfLevel and (RemSkSum2 > 0 or GetHeroLevel(hero) > StartLevel) then
    if GetHeroLevel(hero) < StartLevel then
      discount2 = RemSkSum2 * EstatesDiscountMentor;
    else
      discount2 = EstatesDiscountLevel * (GetHeroLevel(hero) - StartLevel) + RemSkSum2 * EstatesDiscountMentor;
    end;
    if EstatesQ2 == 0 then
      EstatesQ2 = 1;
      QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."EstatesQ.txt"; eq = discount2}, 'Estates2', 'EstatesNo2');
    end;
  end;
end;

function Estates2()
  if EstatesDiscountUse2 == 0 then
    SetPlayerResource(PLAYER_2, 6, GetPlayerResource(2, 6) + discount2);
    EstatesDiscountUse2 = 1;
  end;
end;

function EstatesNo2()
  EstatesQ2 = 0;
end;


array_units_for_recruitment = {};
array_units_for_recruitment = { 1, 2, 3, 4, 5, 6, 15, 16, 17, 18, 19, 20, 29, 30, 31, 32, 33, 34, 43, 44, 45, 46, 47, 48, 57, 58, 59, 60, 61, 62, 71, 71, 73, 74, 75, 76, 92, 93, 94, 95, 96, 97, 106, 107, 108, 117, 118, 119, 120, 121, 122, 131, 132, 133, 138, 139, 140, 145, 146, 147, 152, 153, 154, 159, 160, 161, 166, 167, 168, 173, 174, 175};

kolUnit1 = {intg(K * kol_u1_pl1), intg(K * kol_u2_pl1), intg(K * kol_u3_pl1), intg(K * kol_u4_pl1), intg(K * kol_u5_pl1), intg(K * kol_u6_pl1), intg(K * kol_u7_pl1)};
Unit2 = {intg(K * kol_u1_pl2), intg(K * kol_u2_pl2), intg(K * kol_u3_pl2), intg(K * kol_u4_pl2), intg(K * kol_u5_pl2), intg(K * kol_u6_pl2), intg(K * kol_u7_pl2)}

function recruitment1(hero)
  Stek1[1].id, Stek1[2].id, Stek1[3].id, Stek1[4].id, Stek1[5].id, Stek1[6].id, Stek1[7].id = GetHeroCreaturesTypes(hero);
  if HasArtefact( hero, 88, 1) then k1 = CrownOfLeaderBonus; else k1 = 1; end;
  for i = 1, 7 do
    if Stek1[i].id > 0 then
      for j = 1, 8 do
        for k = 1, 21 do
          if Stek1[i].id == array_units[j][k].id and array_units[j][k].lvl < 4 then
            Stek1[i].kol = int(k1 * RecruitmentCoef * kolUnit1[array_units[j][k].lvl]);
            AddHeroCreatures(hero, Stek1[i].id, Stek1[i].kol );
            k = 21;
            j = 8;
          end;
        end;
      end;
    end;
  end;
end;

function recruitment2(hero)
  Stek2[1].id, Stek2[2].id, Stek2[3].id, Stek2[4].id, Stek2[5].id, Stek2[6].id, Stek2[7].id = GetHeroCreaturesTypes(hero);
  if HasArtefact( hero, 88, 1) then k2 = CrownOfLeaderBonus; else k2 = 1; end;
  for i = 1, 7 do
    if Stek2[i].id > 0 then
      for j = 1, 8 do
        for k = 1, 21 do
          if Stek2[i].id == array_units[j][k].id and array_units[j][k].lvl < 4 then
            Stek2[i].kol = int(k2 * RecruitmentCoef * kolUnit2[array_units[j][k].lvl]);
            AddHeroCreatures(hero, Stek2[i].id, Stek2[i].kol );
            k = 21;
            j = 8;
          end;
        end;
      end;
    end;
  end;
end;



DiplomacyEnable1 = 0;
DiplomacyEnable2 = 0;
--DiplomacyTrue1 = 0;
--DiplomacyTrue2 = 0;

array_mage = {}
array_mage = {
   { ["kol"] = 3, ["id"] =  10},
   { ["kol"] = 3, ["id"] = 110},
   { ["kol"] = 2, ["id"] =  26},
   { ["kol"] = 5, ["id"] = 134},
   { ["kol"] = 3, ["id"] =  38},
   { ["kol"] = 3, ["id"] = 156},
   { ["kol"] = 4, ["id"] =  50},
   { ["kol"] = 4, ["id"] = 148},
   { ["kol"] = 5, ["id"] =  64},
   { ["kol"] = 5, ["id"] = 162},
   { ["kol"] = 2, ["id"] =  82},
   { ["kol"] = 2, ["id"] = 143},
   { ["kol"] = 3, ["id"] = 101},
   { ["kol"] = 3, ["id"] = 170},
   { ["kol"] = 4, ["id"] = 124},
   { ["kol"] = 4, ["id"] = 176}
};

Stek1 = {};
Stek1 = { {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}};

Stek2 = {} ;
Stek2 = { {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}};

array_necro_kol = {};
array_necro_kol = { 110, 70, 30, 14, 7, 4, 3};

NecroPara = {}
NecroPara = { { ["id1"] = 29, ["id2"] = 152}, { ["id1"] = 31, ["id2"] = 153}, { ["id1"] = 34, ["id2"] = 154}, { ["id1"] = 35, ["id2"] = 155}, { ["id1"] = 37, ["id2"] = 156}, { ["id1"] = 39, ["id2"] = 157}, { ["id1"] = 41, ["id2"] = 158} }

function NecroBonus1(hero)
  ks = GetHeroSkillMastery(hero, SKILL_NECROMANCY);
  pause1 = 0;
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."NecroBonus1.txt"; eq = ks}, 'pause1F');
  while pause1 == 0 do
    sleep(1);
  end;
  Stek1 = { {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}};
  DenyGarrisonCreaturesTakeAway('Garrison1', 1);
  SetObjectOwner('Garrison1', 1);
  Stek1[1].id, Stek1[2].id, Stek1[3].id, Stek1[4].id, Stek1[5].id, Stek1[6].id, Stek1[7].id = GetHeroCreaturesTypes(hero);
  kol1 = GetHeroSkillMastery(hero, SKILL_NECROMANCY);
  if hero == "Berein" or hero == "Berein2" then NecroCoef1 = 1 + MarkelCoef * GetHeroLevel(hero); else NecroCoef1 = 1; end;
  if HasHeroSkill(hero, NECROMANCER_FEAT_LORD_OF_UNDEAD) then NecroCoef1 = NecroCoef1 * 1.301; end;
  for i = 1, 7 do
    for j = 3, 3 do
      for k = 1, 21 do
        if Stek1[i].id == array_units[j][k].id then
          if Stek1[i].id == 29 or Stek1[i].id == 152 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[1]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 31 or Stek1[i].id == 153 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[2]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 34 or Stek1[i].id == 154 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[3]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 35 or Stek1[i].id == 155 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[4]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 37 or Stek1[i].id == 156 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[5]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 39 or Stek1[i].id == 157 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[6]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          if Stek1[i].id == 41 or Stek1[i].id == 158 then
            Stek1[i].kol = int(NecroCoef1 * array_necro_kol[7]);
            AddObjectCreatures('Garrison1', Stek1[i].id, Stek1[i].kol );
          end;
          k = 21;
        end;
      end;
    end;
  end;
  MakeHeroInteractWithObject (hero, 'Garrison1');
  Stek1[1].id, Stek1[2].id, Stek1[3].id, Stek1[4].id, Stek1[5].id, Stek1[6].id, Stek1[7].id = GetObjectCreaturesTypes('Garrison1');
  for i = 1, 7 do
    if Stek1[i].id > 0 then
      Stek1[i].kol = GetObjectCreatures('Garrison1', Stek1[i].id);
    end;
  end;
  while kol1 > 0 do
    for i = 1, 7 do
      if Stek1[i].id > 0 then
        if GetObjectCreatures('Garrison1', Stek1[i].id) < Stek1[i].kol then
          kol1 = kol1 - 1;
          if HasHeroSkill(hero, 62) then
            for j = 1, 7 do
              if Stek1[i].id == NecroPara[j].id1 and GetHeroCreatures(hero, NecroPara[j].id2) > 0 then
                AddHeroCreatures(hero, NecroPara[j].id2, Stek1[i].kol);
                RemoveObjectCreatures('Garrison1', NecroPara[j].id2, Stek1[i].kol);
                for k = 1, 7 do
                  if Stek1[k].id == NecroPara[j].id2 then
                    Stek1[k].kol = 0;
                  end;
                end;
              end;
              if Stek1[i].id == NecroPara[j].id2 and GetHeroCreatures(hero, NecroPara[j].id1) > 0 then
                AddHeroCreatures(hero, NecroPara[j].id1, Stek1[i].kol);
                RemoveObjectCreatures('Garrison1', NecroPara[j].id1, Stek1[i].kol);
                for k = 1, 7 do
                  if Stek1[k].id == NecroPara[j].id1 then
                    Stek1[k].kol = 0;
                  end;
                end;
              end;
            end;
          end;
          Stek1[i].kol = 0;
          if kol1 == 0 then
            for j = 1, 7 do
              if Stek1[j].kol ~= 0 then
                if Stek1[j].id > 0 then
                  RemoveObjectCreatures('Garrison1', Stek1[j].id, Stek1[j].kol);
                end;
              end;
            end;
            i = 7;
          end;
        end;
      end;
    end;
    sleep(1);
  end;
  sleep(3);
--  if HasHeroSkill(hero, 104) or HasHeroSkill(hero, 82) then
--    DublikatHero1( hero);
--  end;
end;

function NecroBonus2(hero)
  ks = GetHeroSkillMastery(hero, SKILL_NECROMANCY);
  pause2 = 0;
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."NecroBonus1.txt"; eq = ks}, 'pause2F');
  while pause2 == 0 do
    sleep(1);
  end;
  Stek2 = { {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}, {["kol"] = 0, ["id"] = 0}};
  DenyGarrisonCreaturesTakeAway('Garrison2', 1);
  SetObjectOwner('Garrison2', 2);
  Stek2[1].id, Stek2[2].id, Stek2[3].id, Stek2[4].id, Stek2[5].id, Stek2[6].id, Stek2[7].id = GetHeroCreaturesTypes(hero);
  kol2 = GetHeroSkillMastery(hero, SKILL_NECROMANCY);
  if hero == "Berein" or hero == "Berein2" then NecroCoef2 = 1 + MarkelCoef * GetHeroLevel(hero); else NecroCoef2 = 1; end;
  if HasHeroSkill(hero, NECROMANCER_FEAT_LORD_OF_UNDEAD) then NecroCoef2 = NecroCoef2 * 1.301; end;
  for i = 1, 7 do
    for j = 3, 3 do
      for k = 1, 21 do
        if Stek2[i].id == array_units[j][k].id then
          if Stek2[i].id == 29 or Stek2[i].id == 152 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[1]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 31 or Stek2[i].id == 153 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[2]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 34 or Stek2[i].id == 154 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[3]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 35 or Stek2[i].id == 155 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[4]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 37 or Stek2[i].id == 156 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[5]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 39 or Stek2[i].id == 157 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[6]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          if Stek2[i].id == 41 or Stek2[i].id == 158 then
            Stek2[i].kol = int(NecroCoef2 * array_necro_kol[7]);
            AddObjectCreatures('Garrison2', Stek2[i].id, Stek2[i].kol );
          end;
          k = 21;
        end;
      end;
    end;
  end;
  MakeHeroInteractWithObject (hero, 'Garrison2');
  Stek2[1].id, Stek2[2].id, Stek2[3].id, Stek2[4].id, Stek2[5].id, Stek2[6].id, Stek2[7].id = GetObjectCreaturesTypes('Garrison2');
  for i = 1, 7 do
    if Stek2[i].id > 0 then
      Stek2[i].kol = GetObjectCreatures('Garrison2', Stek2[i].id);
    end;
  end;
  while kol2 > 0 do
    for i = 1, 7 do
      if Stek2[i].id > 0 then
        if GetObjectCreatures('Garrison2', Stek2[i].id) < Stek2[i].kol then
          kol2 = kol2 - 1;
          if HasHeroSkill(hero, 62) then
            for j = 1, 7 do
              if Stek2[i].id == NecroPara[j].id1 and GetHeroCreatures(hero, NecroPara[j].id2) > 0 then
                AddHeroCreatures(hero, NecroPara[j].id2, Stek2[i].kol);
                RemoveObjectCreatures('Garrison2', NecroPara[j].id2, Stek2[i].kol);
                for k = 1, 7 do
                  if Stek2[k].id == NecroPara[j].id2 then
                    Stek2[k].kol = 0;
                  end;
                end;
              end;
              if Stek2[i].id == NecroPara[j].id2 and GetHeroCreatures(hero, NecroPara[j].id1) > 0 then
                AddHeroCreatures(hero, NecroPara[j].id1, Stek2[i].kol);
                RemoveObjectCreatures('Garrison2', NecroPara[j].id1, Stek2[i].kol);
                for k = 1, 7 do
                  if Stek2[k].id == NecroPara[j].id1 then
                    Stek2[k].kol = 0;
                  end;
                end;
              end;
            end;
          end;
          Stek2[i].kol = 0;
          if kol2 == 0 then
            for j = 1, 7 do
              if Stek2[j].kol ~= 0 then
                if Stek2[j].id > 0 then
                  RemoveObjectCreatures('Garrison2', Stek2[j].id, Stek2[j].kol);
                end;
              end;
            end;
            i = 7;
          end;
        end;
      end;
    end;
    sleep(1);
  end;
  sleep(3);
--  if HasHeroSkill(hero, 104) or HasHeroSkill(hero, 82) then
--    DublikatHero2( hero);
--  end;
end;

arrayGradeDip1 = {};
arrayGradeDip2 = {};
arrayGradeDip1 = {   7,   9,  11,  13,  21,  23,  25,  27,  35,  37,  39,  41,  49,  51,  53,  55,  63,  65,  67,  68,  69,  77,  79,  81,  83,  98, 100, 102, 105, 123, 125, 127, 129}
arrayGradeDip2 = { 109, 110, 111, 112, 134, 135, 136, 137, 155, 156, 157, 158, 148, 149, 150, 151, 162, 163, 164,  70, 165, 141, 142, 143, 144, 169, 170, 171, 172, 176, 177, 178, 179}


function diplomacy1(hero)
  pause1 = 0;
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."Diplomacy.txt", 'pause1F');
  while pause1 == 0 do
    sleep(1);
  end;
  Stek1 = { {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}};
  DenyGarrisonCreaturesTakeAway('Garrison3', 1);
  SetObjectOwner('Garrison3', 1);
  Stek1[1].id1, Stek1[2].id1, Stek1[3].id1, Stek1[4].id1, Stek1[5].id1, Stek1[6].id1, Stek1[7].id1 = GetHeroCreaturesTypes(hero);
  for i = 1, 7 do
    if Stek1[i].id1 > 0 then
      for a = 1, length(arrayGradeDip1) do
        if Stek1[i].id1 == arrayGradeDip1[a] then
          if GetHeroCreatures(hero, arrayGradeDip2[a]) < GetHeroCreatures(hero, Stek1[i].id1) then
            Stek1[i].id2 = arrayGradeDip2[a];
          else
            Stek1[i].id2 = -1;
          end;
          a = length(arrayGradeDip1);
        end;
      end;
      if Stek1[i].id2 == 0 then
        for a = 1, length(arrayGradeDip2) do
          if Stek1[i].id1 == arrayGradeDip2[a] then
            if GetHeroCreatures(hero, arrayGradeDip1[a]) <= GetHeroCreatures(hero, Stek1[i].id1) then
              Stek1[i].id2 = arrayGradeDip1[a];
            else
              Stek1[i].id2 = -1;
            end;
            a = length(arrayGradeDip2);
          end;
        end;
      end;
    end;
  end;
  kol1 = 0;
  if HasArtefact( hero, 88, 1) then k1 = CrownOfLeaderBonus; else k1 = 1; end;
  if hero == "Rolf" or hero == "Rolf2" then k1 = 2; end;
  for i = 1, 7 do
    for j = 1, 8 do
      for k = 1, 21 do
        if Stek1[i].id1 == array_units[j][k].id and Stek1[i].id2 > 0 then
          Stek1[i].kol = int(k1 * DiplomacyCoef * kolUnit1[array_units[j][k].lvl]);
          AddObjectCreatures('Garrison3', Stek1[i].id2, Stek1[i].kol );
          k = 21;
          j = 8;
          kol1 = kol1 + 1;
        end;
      end;
    end;
  end;
  MakeHeroInteractWithObject (hero, 'Garrison3');
  Stek1[1].id2, Stek1[2].id2, Stek1[3].id2, Stek1[4].id2, Stek1[5].id2, Stek1[6].id2, Stek1[7].id2 = GetObjectCreaturesTypes('Garrison3');
  for i = 1, 7 do
    if Stek1[i].id2 > 0 then
      Stek1[i].kol = GetObjectCreatures('Garrison3', Stek1[i].id2);
    end;
  end;
  x1, y1 = GetObjectPosition(hero);
  
  pause1 = 0;
  if GetHeroSkillMastery(hero, SKILL_NECROMANCY) > 0 then
    sleep(2);
    startThread (Confirm1F);
  end;
  
  while kol1 > 0 and pause1 == 0 do
    for i = 1, 7 do
      if Stek1[i].id2 > 0 then
        if GetObjectCreatures('Garrison3', Stek1[i].id2) < Stek1[i].kol then
          for j = 1, 7 do
            if j ~= i then
              if Stek1[j].id2 > 0 then
                RemoveObjectCreatures('Garrison3', Stek1[j].id2, Stek1[j].kol);
              end;
            end;
          end;
          i = 7;
          kol1 = 0;
--          pause1 = 1;
        end;
      end;
    end;
    x1_actual, y1_actual = GetObjectPosition(hero);
    if x1_actual ~= x1 or y1_actual ~= y1 then kol1 = 0; end;
    sleep(1);
  end;
  DiplomacyEnable1 = 1;
  sleep(3);
  if GetHeroSkillMastery(hero, SKILL_NECROMANCY) > 0 then
    NecroBonus1(hero);
  end;
end;


function diplomacy2(hero)
  pause2 = 0;
  MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Diplomacy.txt", 'pause2F');
  while pause2 == 0 do
    sleep(1);
  end;
--  MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."Diplomacy.txt" );
  Stek2 = { {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}, {["kol"] = 0, ["id1"] = 0, ["id2"] = 0}};
  DenyGarrisonCreaturesTakeAway('Garrison4', 1);
  SetObjectOwner('Garrison4', 2);
  Stek2[1].id1, Stek2[2].id1, Stek2[3].id1, Stek2[4].id1, Stek2[5].id1, Stek2[6].id1, Stek2[7].id1 = GetHeroCreaturesTypes(hero);
  for i = 1, 7 do
    if Stek2[i].id1 > 0 then
      for a = 1, length(arrayGradeDip1) do
        if Stek2[i].id1 == arrayGradeDip1[a] then
          if GetHeroCreatures(hero, arrayGradeDip2[a]) < GetHeroCreatures(hero, Stek2[i].id1) then
            Stek2[i].id2 = arrayGradeDip2[a];
          else
            Stek2[i].id2 = -1;
          end;
          a = length(arrayGradeDip1);
        end;
      end;
      if Stek2[i].id2 == 0 then
        for a = 1, length(arrayGradeDip2) do
          if Stek2[i].id1 == arrayGradeDip2[a] then
            if GetHeroCreatures(hero, arrayGradeDip1[a]) <= GetHeroCreatures(hero, Stek2[i].id1) then
              Stek2[i].id2 = arrayGradeDip1[a];
            else
              Stek2[i].id2 = -1;
            end;
            a = length(arrayGradeDip2);
          end;
        end;
      end;
    end;
  end;
  kol2 = 0;
  if HasArtefact( hero, 88, 1) then k2 = CrownOfLeaderBonus; else k2 = 1; end;
  if hero == "Rolf" or hero == "Rolf2" then k2 = 2; end;
  for i = 1, 7 do
    for j = 1, 8 do
      for k = 1, 21 do
        if Stek2[i].id1 == array_units[j][k].id and Stek2[i].id2 > 0 then
          Stek2[i].kol = int(k2 * DiplomacyCoef * kolUnit2[array_units[j][k].lvl]);
          AddObjectCreatures('Garrison4', Stek2[i].id2, Stek2[i].kol );
          k = 21;
          j = 8;
          kol2 = kol2 + 1;
        end;
      end;
    end;
  end;
  MakeHeroInteractWithObject (hero, 'Garrison4');
  Stek2[1].id2, Stek2[2].id2, Stek2[3].id2, Stek2[4].id2, Stek2[5].id2, Stek2[6].id2, Stek2[7].id2 = GetObjectCreaturesTypes('Garrison4');
  for i = 1, 7 do
    if Stek2[i].id2 > 0 then
      Stek2[i].kol = GetObjectCreatures('Garrison4', Stek2[i].id2);
    end;
  end;
  x2, y2 = GetObjectPosition(hero);
  
  pause2 = 0;
  if GetHeroSkillMastery(hero, SKILL_NECROMANCY) > 0 then
    sleep(2);
    startThread (Confirm2F);
  end;
  
  while kol2 > 0 and pause2 == 0 do
    for i = 1, 7 do
      if Stek2[i].id2 > 0 then
        if GetObjectCreatures('Garrison4', Stek2[i].id2) < Stek2[i].kol then
          for j = 1, 7 do
            if j ~= i then
              if Stek2[j].id2 > 0 then
                RemoveObjectCreatures('Garrison4', Stek2[j].id2, Stek2[j].kol);
              end;
            end;
          end;
          i = 7;
          kol2 = 0;
--          pause2 = 1;
        end;
      end;
    end;
    x2_actual, y2_actual = GetObjectPosition(hero);
    if x2_actual ~= x2 or y2_actual ~= y2 then kol1 = 0; end;
    sleep(1);
  end;
  DiplomacyEnable2 = 1;
  sleep(3);
  if GetHeroSkillMastery(hero, SKILL_NECROMANCY) > 0 then
    NecroBonus2(hero);
  end;
end;

function NoActivity (hero1, hero2)
  bonus = 1;
  if HasHeroSkill(hero2,  21)   then bonus = bonus + 3; end;
  if HasHeroSkill(hero2, 141)   then bonus = bonus + 3; end;
  if HasArtefact (hero2, 57, 1) then bonus = bonus + 3; end;
  if HasArtefact (hero2, 59, 1) then bonus = bonus + 3; end;
  ChangeHeroStat(hero1, 2, bonus);
end;

PathFindingX = {} ;
PathFindingX = { 50, 56, 48, 50, 44, 44, 56, 51};

PathFindingY = {} ;
PathFindingY = { 45, 49, 52, 45, 48, 42, 41, 38};

function PathFinding(HeroWithPerk, HeroWithoutPerk, race)
--  if HasHeroSkill(HeroWithPerk, 177) then GiveHeroBattleBonus(HeroWithPerk, HERO_BATTLE_BONUS_ATTACK, 2); GiveHeroBattleBonus(HeroWithPerk, HERO_BATTLE_BONUS_DEFENCE, 2); end;
--  GiveHeroBattleBonus(HeroWithPerk, HERO_BATTLE_BONUS_LUCK, 1);
  hodi1(HeroWithPerk);
  sleep(1);
  MoveHeroRealTime(HeroWithPerk, PathFindingX[race], PathFindingY[race]);
  sleep(10);
  
  InitCombatExecThread(HeroMax1)
  sleep(5)
  SaveHeroesInfoBeforeCombat{HeroMax1, HeroMax2}
  sleep(5)
  MakeHeroInteractWithObject (HeroWithoutPerk, HeroWithPerk);
  
  while IsHeroAlive(HeroWithoutPerk) and IsHeroAlive(HeroWithPerk) do
		MakeHeroInteractWithObject(HeroWithoutPerk, HeroWithPerk);
		sleep(10);
	end;
end;

NavUse1 = 0;
NavUse2 = 0;

array_artNav = {}
array_artNav[1] = {'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'a9', 'a10', 'a11', 'a12', 'a13', 'a14', 'a15', 'a16', 'a17', 'a18', 'a19'}
array_artNav[2] = {'b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7', 'b8', 'b9', 'b10', 'b11', 'b12', 'b13', 'b14', 'b15', 'b16', 'b17', 'b18', 'b19'}

function Navigation1()
  SetObjectPosition('red10', 5, 5, UNDERGROUND);
  sleep(1);
  MoveHeroRealTime(heroes1[0], 22, 79);
  for i = 1, length(array_artNav[1]) do
    Trigger (OBJECT_TOUCH_TRIGGER, array_artNav[1][i],   'NavigationUse1');
  end;
end;

function Navigation2()
  SetObjectPosition('blue10', 5, 6, UNDERGROUND);
  sleep(1);
  MoveHeroRealTime(heroes2[0], 42, 29);
  for i = 1, length(array_artNav[2]) do
    Trigger (OBJECT_TOUCH_TRIGGER, array_artNav[2][i],   'NavigationUse2');
  end;
end;

function NavigationUse1()
  for i = 1, length(array_artNav[1]) do
    if IsObjectExists(array_artNav[1][i]) == 1 then
      RemoveObject(array_artNav[1][i]);
    end;
  end;
  if HasHeroSkill(HeroMax1, 21) then transferArt (heroes1[0], HeroMax1); NavUse1 = 1; end
  SetObjectPosition(heroes1[0], 35, 85);
end;

function NavigationUse2()
  for i = 1, length(array_artNav[2]) do
    if IsObjectExists(array_artNav[2][i]) == 1 then
      RemoveObject(array_artNav[2][i]);
    end;
  end;
  if HasHeroSkill(HeroMax2, 21) then transferArt (heroes2[0], HeroMax2); NavUse2 = 1; end;
  SetObjectPosition(heroes2[0], 42, 24);
end;

ForestGuardUse1 = 0;
ForestGuardUse2 = 0;

function ForestGuard1(hero)
  if ForestGuardUse1 == 0 then
    if GetHeroCreatures(hero, 146) > 0 then
      RemoveHeroCreatures(hero, 146, 10);
      ForestGuardUse1 = 1;
    else
      if GetHeroCreatures(hero, 45) > 0 then
        RemoveHeroCreatures(hero, 45, 10);
        ForestGuardUse1 = 1;
      end;
    end;
  end;
end;

function ForestGuard2(hero)
  if ForestGuardUse2 == 0 then
    if GetHeroCreatures(hero, 146) > 0 then
      RemoveHeroCreatures(hero, 146, 10);
      ForestGuardUse2 = 1;
    else
      if GetHeroCreatures(hero, 45) > 0 then
        RemoveHeroCreatures(hero, 45, 10);
        ForestGuardUse2 = 1;
      end;
    end;
  end;
end;


DefendUsAllUse1 = 0;
DefendUsAllUse2 = 0;

function DefendUsAll1(hero)
  if DefendUsAllUse1 == 0 then
    if GetHeroCreatures(hero, 173) > 0 then
      RemoveHeroCreatures(hero, 173, 15);
      DefendUsAllUse1 = 1;
    else
      if GetHeroCreatures(hero, 117) > 0 then
        RemoveHeroCreatures(hero, 117, 15);
        DefendUsAllUse1 = 1;
      end;
    end;
  end;
end;


function DefendUsAll2(hero)
  if DefendUsAllUse2 == 0 then
    if GetHeroCreatures(hero, 173) > 0 then
      RemoveHeroCreatures(hero, 173, 15);
      DefendUsAllUse2 = 1;
    else
      if GetHeroCreatures(hero, 117) > 0 then
        RemoveHeroCreatures(hero, 117, 15);
        DefendUsAllUse2 = 1;
      end;
    end;
  end;
end;

function Insights(hero)
  if KnowHeroSpell(hero, array_spells[2][8].id) and KnowHeroSpell(hero, array_spells[2][9].id) and KnowHeroSpell(hero, array_spells[2][10].id) and KnowHeroSpell(hero, array_spells[2][11].id) and KnowHeroSpell(hero, array_spells[2][12].id) then
  else
    rnd = random(5) + 8;
    while KnowHeroSpell(hero, array_spells[2][rnd].id) do
      rnd = random(5) + 8;
    end;
    TeachHeroSpell(hero, array_spells[2][rnd].id);
  end;
end;

function Function_CUSTOM_F(hero, CUSTOM_ABILITY)

  if (CUSTOM_ABILITY == CUSTOM_ABILITY_1) and (GetObjectOwner(hero) == 1) then
    HeroR1 = hero;
    x1, y1 = GetObjectPosition(HeroR1);
    DenyGarrisonCreaturesTakeAway('regrade1', 0);
    MakeHeroInteractWithObject (hero, 'regrade1');
    startThread (RegradeUnit1);
  end;

  if (CUSTOM_ABILITY == CUSTOM_ABILITY_1) and (GetObjectOwner(hero) == 2) then
    HeroR2 = hero;
    x2, y2 = GetObjectPosition(HeroR2);
    DenyGarrisonCreaturesTakeAway('regrade2', 0);
    MakeHeroInteractWithObject (hero, 'regrade2');
    startThread (RegradeUnit2);
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_2) and (hero == HeroMax1) and HasHeroSkill(hero, 20) then
    Scouting1Q();
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_2) and (hero == HeroMax2) and HasHeroSkill(hero, 20) then
    Scouting2Q();
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_2) and GetObjectOwner(hero) == 1 and HasHeroSkill(hero, 112) then
    Disguise1Q();
    DisguiseHero1 = hero;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_2) and GetObjectOwner(hero) == 2 and HasHeroSkill(hero, 112) then
    Disguise2Q();
    DisguiseHero2 = hero;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == HeroMax1) then
    SaleArmyQuestion(HeroMax1)
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == HeroMax2) then
    SaleArmyQuestion(HeroMax2)
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == HeroMax1) then
    startThread(FortunateAdventure1)
    --QuestionBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."FortunateAdventure.txt", 'FortunateAdventure1Ok', 'no');
    --SetObjectOwner('Dwel1', PLAYER_1);
    --startThread(HeraldFunction1);
    --MoveCameraForPlayers( 1, 89, 82, 0, 40, 0, 0, 0, 0, 1);
    --sleep(2);
    --MakeHeroInteractWithObject (hero, 'Dwel1');
    --HeraldUse1 = 1;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == HeroMax2) then
    startThread(FortunateAdventure2)
    --SetObjectOwner('Dwel2', PLAYER_2);
    --startThread(HeraldFunction2);
    --MoveCameraForPlayers( 2, 81, 7, 0, 40, 0, 3.14, 0, 0, 1);
    --sleep(2);
    --MakeHeroInteractWithObject (hero, 'Dwel2');
    --HeraldUse2 = 1;
  end;

end;

SaleArmyUse1 = 0;
SaleArmyUse2 = 0;

function SaleArmyQuestion(hero)
  if GetObjectOwner(hero) == 1 then
    price = 0;
    if HasArtefact( hero, 88, 1) then k = CrownOfLeaderBonus else k = 1; end;
    for i = 1, 8 do
      for j = 1, 21 do
        if GetObjectDwellingCreatures('RANDOMTOWN1', array_units[i][j].id) > 0 then
          price = price + SaleArmyCoef * GetObjectDwellingCreatures('RANDOMTOWN1', array_units[i][j].id) * array_units[i][j].price1;
        end;
      end;
    end;
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), {GetMapDataPath().."SaleArmy.txt"; eq = 0.5 * price}, 'SaleArmyQ1', 'no');
  end;
  if GetObjectOwner(hero) == 2 then
    price = 0;
    if HasArtefact( hero, 88, 1) then k = CrownOfLeaderBonus else k = 1; end;
    for i = 1, 8 do
      for j = 1, 21 do
        if GetObjectDwellingCreatures('RANDOMTOWN2', array_units[i][j].id) > 0 then
          price = price + SaleArmyCoef * GetObjectDwellingCreatures('RANDOMTOWN2', array_units[i][j].id) * array_units[i][j].price1;
        end;
      end;
    end;
    QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), {GetMapDataPath().."SaleArmy.txt"; eq = 0.5 * price}, 'SaleArmyQ2', 'no');
  end;
end;

function SaleArmyQ1()
  SaleArmy('RANDOMTOWN1', HeroMax1);
  SaleArmyUse1 = 1;
end;

function SaleArmyQ2()
  SaleArmy('RANDOMTOWN2', HeroMax2);
  SaleArmyUse2 = 1;
end;

function SaleArmy(town, hero)
  price = 0;
  if HasArtefact( hero, 88, 1) then k = CrownOfLeaderBonus else k = 1; end;
  for i = 1, 8 do
    for j = 1, 21 do
      if GetObjectDwellingCreatures(town, array_units[i][j].id) > 0 then
        SetPlayerResource (GetObjectOwner(hero), GOLD, (GetPlayerResource (GetObjectOwner(hero), GOLD) + k * SaleArmyCoef * GetObjectDwellingCreatures(town, array_units[i][j].id) * array_units[i][j].price1));
        price = price + SaleArmyCoef * GetObjectDwellingCreatures(town, array_units[i][j].id) * array_units[i][j].price1;
        SetObjectDwellingCreatures(town, array_units[i][j].id, 0);
      end;
    end;
  end;
  x, y = GetObjectPosition(hero);
  Play2DSoundForPlayers ( GetObjectOwner(hero), "/Sounds/_(Sound)/Interface/Ingame/Buy.xdb#xpointer(/Sound)", x, y, 0);
  ShowFlyingSign({GetMapDataPath().."Estates.txt"; eq = price}, hero, GetObjectOwner(hero), 5.0);
end;


SnatchUse1 = 0;
SnatchUse2 = 0;

function Snatch_CUSTOM_F(hero, CUSTOM_ABILITY)

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == HeroMax1) then
    if hero2race == 1 then MakeHeroInteractWithObject (hero, 'lavka16'); end;
    if hero2race == 2 then MakeHeroInteractWithObject (hero, 'lavka12'); end;
    if hero2race == 3 then MakeHeroInteractWithObject (hero, 'lavka13'); end;
    if hero2race == 4 then MakeHeroInteractWithObject (hero, 'lavka14'); end;
    if hero2race == 5 then MakeHeroInteractWithObject (hero, 'lavka9');  end;
    if hero2race == 6 then MakeHeroInteractWithObject (hero, 'lavka10'); end;
    if hero2race == 7 then MakeHeroInteractWithObject (hero, 'lavka11'); end;
    if hero2race == 8 then MakeHeroInteractWithObject (hero, 'lavka15'); end;
    if SnatchUse1 == 0 then SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + 3000)); end;
    SnatchUse1 = 1;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_3) and (hero == HeroMax2) then
    if hero1race == 1 then MakeHeroInteractWithObject (hero, 'lavka7'); end;
    if hero1race == 2 then MakeHeroInteractWithObject (hero, 'lavka4'); end;
    if hero1race == 3 then MakeHeroInteractWithObject (hero, 'lavka5'); end;
    if hero1race == 4 then MakeHeroInteractWithObject (hero, 'lavka6'); end;
    if hero1race == 5 then MakeHeroInteractWithObject (hero, 'lavka1'); end;
    if hero1race == 6 then MakeHeroInteractWithObject (hero, 'lavka2'); end;
    if hero1race == 7 then MakeHeroInteractWithObject (hero, 'lavka3'); end;
    if hero1race == 8 then MakeHeroInteractWithObject (hero, 'lavka8'); end;
    if SnatchUse2 == 0 then SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + 3000)); end;
    SnatchUse2 = 1;
  end;

end;

HeraldUse1 = 0;
HeraldUse2 = 0;

GlesUse1 = 0;
GlesUse2 = 0;

function Herald_CUSTOM_F(hero, CUSTOM_ABILITY)

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == HeroMax1) then
    SetObjectOwner('Dwel1', PLAYER_1);
    startThread(HeraldFunction1);
    MoveCameraForPlayers( 1, 89, 82, 0, 20, 0, 0, 0, 0, 1);
    --sleep(2);
    --MakeHeroInteractWithObject (hero, 'Dwel1');
    --HeraldUse1 = 1;
  end;

  if (CUSTOM_ABILITY==CUSTOM_ABILITY_4) and (hero == HeroMax2) then
    SetObjectOwner('Dwel2', PLAYER_2);
    startThread(HeraldFunction2);
    MoveCameraForPlayers( 2, 81, 7, 0, 20, 0, 3.14, 0, 0, 1);
    --sleep(2);
    --MakeHeroInteractWithObject (hero, 'Dwel2');
    --HeraldUse2 = 1;
  end;

end;

function HeraldFunction1()
  SetObjectOwner('Dwel1', PLAYER_1);
  MoveCameraForPlayers( 1, 89, 82, 0, 20, 0, 0, 0, 0, 1);

  if (HasHeroSkill(HeroMax1, 102)) and HeraldUse1 == 0 then
    SetObjectDwellingCreatures('Dwel1',  90, 16);
  end;
  if (HeroMax1 == "Nikolas" or HeroMax1 == "Nikolas2") and GlesUse1 == 0 then
    SetObjectDwellingCreatures('Dwel1', 116, 40);
    GlesUse1 = 1;
  end;
  while HeraldUse1 ~= 2 do
    sleep(5);
    if GetObjectCreatures('Dwel1', 116) > 0 then
      AddObjectCreatures(HeroMax1, 116, GetObjectCreatures('Dwel1', 116));
      RemoveObjectCreatures('Dwel1', 116, GetObjectCreatures('Dwel1', 116));
    end;
    if GetObjectCreatures('Dwel1',  90) > 0 then
      AddObjectCreatures(HeroMax1,  90, GetObjectCreatures('Dwel1',  90));
      HeraldUse1 = 1;
      RemoveObjectCreatures('Dwel1',  90, GetObjectCreatures('Dwel1',  90));
    end;
  end;
end;

function HeraldFunction2()
  SetObjectOwner('Dwel2', PLAYER_2);
  MoveCameraForPlayers( 2, 81, 7, 0, 40, 0, 3.14, 0, 0, 1);

  if (HasHeroSkill(HeroMax2, 102)) and HeraldUse2 == 0 then
    SetObjectDwellingCreatures('Dwel2',  90, 16);
  end;
  if (HeroMax2 == "Nikolas" or HeroMax2 == "Nikolas2") and GlesUse2 == 0 then
    SetObjectDwellingCreatures('Dwel2', 116, 40);
    GlesUse2 = 1;
  end;
  while HeraldUse2 ~= 2 do
    sleep(5);
    if GetObjectCreatures('Dwel2', 116) > 0 then
      AddObjectCreatures(HeroMax2, 116, GetObjectCreatures('Dwel2', 116));
      RemoveObjectCreatures('Dwel2', 116, GetObjectCreatures('Dwel2', 116));
    end;
    if GetObjectCreatures('Dwel2',  90) > 0 then
      AddObjectCreatures(HeroMax2,  90, GetObjectCreatures('Dwel2',  90));
      HeraldUse2 = 1;
      RemoveObjectCreatures('Dwel2',  90, GetObjectCreatures('Dwel2',  90));
    end;
  end;
end;

SetObjectDwellingCreatures('Dwel1', 116, 0);
SetObjectDwellingCreatures('Dwel1',  90, 0);

SetObjectDwellingCreatures('Dwel2', 116, 0);
SetObjectDwellingCreatures('Dwel2',  90, 0);


GoblinSupportEnable1 = 0;
GoblinSupportEnable2 = 0;

function GoblinSupport1(hero)
  if GoblinSupportEnable1 == 0 then
    AddHeroCreatures(hero, 118, 50);
    GiveHeroWarMachine(hero, WAR_MACHINE_BALLISTA);
    GiveHeroWarMachine(hero, WAR_MACHINE_FIRST_AID_TENT);
    GiveHeroWarMachine(hero, WAR_MACHINE_AMMO_CART);
  end;
  GoblinSupportEnable1 = 1;
end;

function GoblinSupport2(hero)
  if GoblinSupportEnable2 == 0 then
    AddHeroCreatures(hero, 118, 50);
    GiveHeroWarMachine(hero, WAR_MACHINE_BALLISTA);
    GiveHeroWarMachine(hero, WAR_MACHINE_FIRST_AID_TENT);
    GiveHeroWarMachine(hero, WAR_MACHINE_AMMO_CART);
  end;
  GoblinSupportEnable2 = 1;
end;

HauntMineEnable1 = 0;
HauntMineEnable2 = 0;

function HauntMine1(hero)
  if HauntMineEnable1 == 0 then
    AddHeroCreatures(hero, 34, 20);
  end;
  HauntMineEnable1 = 1;
end;

function HauntMine2(hero)
  if HauntMineEnable2 == 0 then
    AddHeroCreatures(hero, 34, 20);
  end;
  HauntMineEnable2 = 1;
end;


LogisticsEnable1 = 0;
LogisticsEnable2 = 0;
LogisticsNoMoney1 = 0;
LogisticsNoMoney2 = 0;


function Logistics1(hero)
  if hero == HeroMax1 and StLvlUp1 == 1 then
    SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) + LogisticsSum));
    LogisticsEnable1 = 1;
  end;
end;

function Logistics2(hero)
  if hero == HeroMax2 and StLvlUp2 == 1 then
    SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) + LogisticsSum));
    LogisticsEnable2 = 1;
  end;
end;

function DelLogistics1(hero)
  if GetPlayerResource (PLAYER_1, GOLD) >= LogisticsSum then
    if GetHeroLevel(hero) > 1 then
      SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) - LogisticsSum));
    end;
    LogisticsNoMoney1 = 0;
  else
    LogisticsNoMoney1 = 1;
  end;
  LogisticsEnable1 = 1;
end;

function DelLogistics2(hero)
  if GetPlayerResource (PLAYER_2, GOLD) >= LogisticsSum then
    if GetHeroLevel(hero) > 1 then
      SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) - LogisticsSum));
    end;
    LogisticsNoMoney2 = 0;
  else
    LogisticsNoMoney2 = 1;
  end;
  LogisticsEnable2 = 1;
end;

LearningEnable1 = 0;
LearningEnable2 = 0;


function DelLearning1(hero)
  if (GetHeroSkillMastery(hero, 3) == 2 or GetHeroSkillMastery(hero, 183) == 2) or (GetHeroSkillMastery(hero, 3) == 0 or GetHeroSkillMastery(hero, 183) == 0) then
    race = getrace(hero);
    rnd = random(100);
    if rnd <= PercentA[race] then
      ChangeHeroStat(hero, STAT_ATTACK, 1);
    end;
    if rnd > PercentA[race] and rnd <= (PercentA[race] + PercentD[race]) then
      ChangeHeroStat(hero, STAT_DEFENCE, 1);
    end;
    if rnd > (PercentA[race] + PercentD[race]) and rnd <= (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
    end;
    if rnd > (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
    end;
    LearningEnable1 = LearningEnable1 - 1;
  end;
end;

function DelLearning2(hero)
  if (GetHeroSkillMastery(hero, 3) == 2 or GetHeroSkillMastery(hero, 183) == 2) or (GetHeroSkillMastery(hero, 3) == 0 or GetHeroSkillMastery(hero, 183) == 0) then
    race = getrace(hero);
    rnd = random(100);
    if rnd <= PercentA[race] then
      ChangeHeroStat(hero, STAT_ATTACK, 1);
    end;
    if rnd > PercentA[race] and rnd <= (PercentA[race] + PercentD[race]) then
      ChangeHeroStat(hero, STAT_DEFENCE, 1);
    end;
    if rnd > (PercentA[race] + PercentD[race]) and rnd <= (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_SPELL_POWER, 1);
    end;
    if rnd > (PercentA[race] + PercentD[race] + PercentS[race]) then
      ChangeHeroStat(hero, STAT_KNOWLEDGE, 1);
    end;
    LearningEnable2 = LearningEnable2 - 1;
  end;
end;



array_skills_Hero = {}
array_skills_Hero = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_skills_Hero1 = {}
array_skills_Hero1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_skills_Hero2 = {}
array_skills_Hero2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_perks_Hero = {}
array_perks_Hero = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_perks_Hero1 = {}
array_perks_Hero1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_perks_Hero2 = {}
array_perks_Hero2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

array_arts_Hero = {}
array_arts_Hero = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}

array_arts_Hero1 = {}
array_arts_Hero1 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}

array_arts_Hero2 = {}
array_arts_Hero2 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}

array_army_Hero = {}
array_army_Hero = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};

array_army_Hero1 = {}
array_army_Hero1 = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};

array_army_Hero2 = {}
array_army_Hero2 = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};

array_machine_Hero = {}
array_machine_Hero = { 0, 0, 0}

array_machine_Hero1 = {}
array_machine_Hero1 = { 0, 0, 0}

array_machine_Hero2 = {}
array_machine_Hero2 = { 0, 0, 0}

function SubHero(hero1, hero2)
  j = 1;
  for i = 1, 26 do
    array_skills_Hero[i] = GetHeroSkillMastery(hero1, array_skills[i]);
  end;

  for i = 1, 189 do
    if HasHeroSkill(hero1, array_perks[i]) then
      array_perks_Hero[j] = array_perks[i];
      j = j + 1;
      kol_perks_Hero = j;
    end;
  end;

  k = 1;
  for i = 0, 2 do
    for j = 1, length (array_arts[i]) do
      if HasArtefact(hero1, array_arts[i][j].id, 0) then
        array_arts_Hero[k].ID = array_arts[i][j].id;
        k = k + 1;
      end;
      if HasArtefact(hero1, array_arts[i][j].id, 1) then
        array_arts_Hero[k - 1].Eq = 1;
        RemoveArtefact(hero1, array_arts[i][j].id);
      end;
    end;
  end;

  j = 1;
  for i = 1, 179 do
    if GetHeroCreatures( hero1, i) > 0 then
      array_army_Hero[j].ID  = i;
      array_army_Hero[j].kol = GetHeroCreatures( hero1, i);
      j = j + 1;
    end;
  end;

  j = 1;
  for i = 1, 4 do
    if HasHeroWarMachine(hero1, i) and i ~= 2 then
      array_machine_Hero[j]  = i;
      j = j + 1;
    end;
  end;
  
  expHero = GetHeroStat(hero1, STAT_EXPERIENCE);
  attHero = GetHeroStat(hero1, STAT_ATTACK);
  defHero = GetHeroStat(hero1, STAT_DEFENCE);
  spHero  = GetHeroStat(hero1, STAT_SPELL_POWER);
  knHero  = GetHeroStat(hero1, STAT_KNOWLEDGE);

  x, y = GetObjectPosition(hero1);
  RemoveObject(hero1);
  DeployReserveHero(hero2, x, y, 0);
  Trigger( HERO_ADD_SKILL_TRIGGER, hero2, 'no');
  WarpHeroExp(hero2, expHero);
  for i = 1, 26 do
    for j = 1, array_skills_Hero[i] do
      if array_skills_Hero[i] >= j then
        if GetHeroSkillMastery(hero2, array_skills[i]) < array_skills_Hero[i] then
          GiveHeroSkill(hero2, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_Hero do
    GiveHeroSkill(hero2, array_perks_Hero[i]);
  end;
  
  k = 0;
  for i = 1, 189 do
    if HasHeroSkill( hero2, array_perks[i]) then
      k = k + 1;
    end;
  end;
  while k < (kol_perks_Hero - 1) do
    for i = 1, kol_perks_Hero do
      if HasHeroSkill( hero2, array_perks_Hero[i]) == nil then
        GiveHeroSkill(hero2, array_perks_Hero[i]);
        k = k + 1;
        if array_perks_Hero[i] == 115 and GetHeroCreatures(hero2, 146) > 0 then RemoveHeroCreatures(hero2, 146, 10); end;
        if array_perks_Hero[i] == 181 and GetHeroCreatures(hero2, 173) > 0 then RemoveHeroCreatures(hero2, 173, 15); end;
      end;
    end;
  end;

  for i = 1, length(array_army_Hero) do
    if array_army_Hero[i].ID ~= 0 then
      AddHeroCreatures(hero2, array_army_Hero[i].ID, array_army_Hero[i].kol);
      if GetHeroCreatures(hero2, 88) > 0 then RemoveHeroCreatures(hero2, 88, GetHeroCreatures(hero2, 88)); end;
    end;
  end;

  for i = 1, length(array_machine_Hero) do
    if array_machine_Hero[i] ~= 0 then
      GiveHeroWarMachine(hero2, array_machine_Hero[i]);
    end;
  end;
  
  if StartBonus[GetObjectOwner(hero2)] == 'spell' then
    TeachHeroSpell(hero2, array_spells[BonusSpells[GetObjectOwner(hero2) - 1].m1][BonusSpells[GetObjectOwner(hero2) - 1].sp1].id );
    TeachHeroSpell(hero2, array_spells[BonusSpells[GetObjectOwner(hero2) - 1].m2][BonusSpells[GetObjectOwner(hero2) - 1].sp2].id );
  end;

  attHero = attHero - GetHeroStat(hero2, STAT_ATTACK); --print(attHero2);
  defHero = defHero - GetHeroStat(hero2, STAT_DEFENCE); --print(defHero2);
  spHero  = spHero  - GetHeroStat(hero2, STAT_SPELL_POWER); --print(spHero2);
  knHero  = knHero  - GetHeroStat(hero2, STAT_KNOWLEDGE); --print(knHero2);

  if attHero > 0 then ChangeHeroStat(hero2, STAT_ATTACK,      attHero); end;
  if defHero > 0 then ChangeHeroStat(hero2, STAT_DEFENCE,     defHero); end;
  if spHero  > 0 then ChangeHeroStat(hero2, STAT_SPELL_POWER,  spHero); end;
  if knHero  > 0 then ChangeHeroStat(hero2, STAT_KNOWLEDGE,    knHero); end;

  for i = 1, length(array_arts_Hero) do
    if array_arts_Hero[i].ID ~= 0 and array_arts_Hero[i].Eq == 1 then
      GiveArtefact(hero2, array_arts_Hero[i].ID);
    end;
  end;
  for i = 1, length(array_arts_Hero) do
    if array_arts_Hero[i].ID ~= 0 and array_arts_Hero[i].Eq == 0 then
      GiveArtefact(hero2, array_arts_Hero[i].ID);
    end;
  end;

  sleep(2);

  array_skills_Hero = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_perks_Hero = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_arts_Hero = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}
  array_army_Hero = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};
  array_machine_Hero = { 0, 0, 0}
end;



function DublikatHero1(hero1)
--  print('steel1');
  j = 1;
  for i = 1, 26 do
    array_skills_Hero1[i] = GetHeroSkillMastery(hero1, array_skills[i]);
  end;

  for i = 1, 189 do
    if HasHeroSkill(hero1, array_perks[i]) then
      array_perks_Hero1[j] = array_perks[i];
      j = j + 1;
      kol_perks_Hero1 = j;
    end;
  end;

  k = 1;
  for i = 0, 2 do
    for j = 1, length (array_arts[i]) do
      if HasArtefact(hero1, array_arts[i][j].id, 0) then
        array_arts_Hero1[k].ID = array_arts[i][j].id;
        k = k + 1;
      end;
      if HasArtefact(hero1, array_arts[i][j].id, 1) then
        array_arts_Hero1[k - 1].Eq = 1;
        RemoveArtefact(hero1, array_arts[i][j].id);
      end;
    end;
  end;

  j = 1;
  for i = 1, 179 do
    if GetHeroCreatures( hero1, i) > 0 then
      array_army_Hero1[j].ID  = i;
      array_army_Hero1[j].kol = GetHeroCreatures( hero1, i);
      j = j + 1;
    end;
  end;

  j = 1;
  for i = 1, 4 do
    if HasHeroWarMachine(hero1, i) and i ~= 2 then
      array_machine_Hero1[j]  = i;
      j = j + 1;
    end;
  end;
  
  expHero1 = GetHeroStat(hero1, STAT_EXPERIENCE);
  attHero1 = GetHeroStat(hero1, STAT_ATTACK);
  defHero1 = GetHeroStat(hero1, STAT_DEFENCE);
  spHero1  = GetHeroStat(hero1, STAT_SPELL_POWER);
  knHero1  = GetHeroStat(hero1, STAT_KNOWLEDGE);

  x, y = GetObjectPosition(hero1);
  RemoveObject(hero1);
  
  for i = 0, 7 do
    for j = 1, length(dublikat_heroes[i]) do
      if (hero1 == dublikat_heroes[i][j].name or hero1 == dublikat_heroes[i][j].name2) then
        HeroMax1 = dublikat_heroes[i][j].name3;
      end;
    end;
  end;

  DeployReserveHero(HeroMax1, x, y, 0);
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax1, 'no');
  WarpHeroExp(HeroMax1, expHero1);
  for i = 1, 26 do
    for j = 1, array_skills_Hero1[i] do
      if array_skills_Hero1[i] >= j then
        if GetHeroSkillMastery(HeroMax1, array_skills[i]) < array_skills_Hero1[i] then
          GiveHeroSkill(HeroMax1, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_Hero1 do
    GiveHeroSkill(HeroMax1, array_perks_Hero1[i]);
  end;

  k = 0;
  for i = 1, 189 do
    if HasHeroSkill( HeroMax1, array_perks[i]) then
      k = k + 1;
    end;
  end;
  while k < kol_perks_Hero1 do
    for i = 1, kol_perks_Hero1 do
      if HasHeroSkill( HeroMax1, array_perks_Hero1[i]) == nil then
        GiveHeroSkill(HeroMax1, array_perks_Hero1[i]);
        k = k + 1;
        if array_perks_Hero1[i] == 115 and GetHeroCreatures(HeroMax1, 146) > 0 then RemoveHeroCreatures(HeroMax1, 146, 10); end;
        if array_perks_Hero1[i] == 181 and GetHeroCreatures(HeroMax1, 173) > 0 then RemoveHeroCreatures(HeroMax1, 173, 15); end;
      end;
    end;
  end;


  for i = 1, length(array_army_Hero1) do
    if array_army_Hero1[i].ID ~= 0 then
      AddHeroCreatures(HeroMax1, array_army_Hero1[i].ID, array_army_Hero1[i].kol);
      if GetHeroCreatures(HeroMax1, 88) > 0 then kolCreatures1 = GetHeroCreatures(HeroMax1, 88); RemoveHeroCreatures(HeroMax1, 88, kolCreatures1); end;
    end;
  end;

--  print('ttt');

  for i = 1, length(array_machine_Hero1) do
    if array_machine_Hero1[i] ~= 0 then
      GiveHeroWarMachine(HeroMax1, array_machine_Hero1[i]);
    end;
  end;
  
--  print('1');

  if StartBonus[1] == 'spell' then
    TeachHeroSpell(HeroMax1, array_spells[BonusSpells[0].m1][BonusSpells[0].sp1].id );
    TeachHeroSpell(HeroMax1, array_spells[BonusSpells[0].m2][BonusSpells[0].sp2].id );
  end;
  
--  print('2');

  attHero1 = attHero1 - GetHeroStat(HeroMax1, STAT_ATTACK); --print(attHero2);
  defHero1 = defHero1 - GetHeroStat(HeroMax1, STAT_DEFENCE); --print(defHero2);
  spHero1  = spHero1  - GetHeroStat(HeroMax1, STAT_SPELL_POWER); --print(spHero2);
  knHero1  = knHero1  - GetHeroStat(HeroMax1, STAT_KNOWLEDGE); --print(knHero2);

  if attHero1 > 0 then ChangeHeroStat(HeroMax1, STAT_ATTACK,      attHero1); end;
  if defHero1 > 0 then ChangeHeroStat(HeroMax1, STAT_DEFENCE,     defHero1); end;
  if spHero1  > 0 then ChangeHeroStat(HeroMax1, STAT_SPELL_POWER,  spHero1); end;
  if knHero1  > 0 then ChangeHeroStat(HeroMax1, STAT_KNOWLEDGE,    knHero1); end;
  
  for i = 1, length(array_arts_Hero1) do
    if array_arts_Hero1[i].ID ~= 0 and array_arts_Hero1[i].Eq == 1 then
      GiveArtefact(HeroMax1, array_arts_Hero1[i].ID);
    end;
  end;
  
  if Name(HeroMax1) == "Una" then
    for i = 1, 10 do
      if array_FreeRunes[i] == 2 then
        TeachHeroSpell(HeroMax1, array_spells[4][i].id);
      end;
    end;
  end;

--  print('3');

  array_skills_Hero1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_perks_Hero1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_arts_Hero1 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}
  array_army_Hero1 = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};
  array_machine_Hero1 = { 0, 0, 0}
end;

function DublikatHero2(hero2)
  j = 1;
  for i = 1, 26 do
    array_skills_Hero2[i] = GetHeroSkillMastery(hero2, array_skills[i]);
  end;

  for i = 1, 189 do
    if HasHeroSkill(hero2, array_perks[i]) then
      array_perks_Hero2[j] = array_perks[i];
      j = j + 1;
      kol_perks_Hero2 = j;
    end;
  end;

  k = 1;
  for i = 0, 2 do
    for j = 1, length (array_arts[i]) do
      if HasArtefact(hero2, array_arts[i][j].id, 0) then
        array_arts_Hero2[k].ID = array_arts[i][j].id;
        k = k + 1;
      end;
      if HasArtefact(hero2, array_arts[i][j].id, 1) then
        array_arts_Hero2[k - 1].Eq = 1;
        RemoveArtefact(hero2, array_arts[i][j].id);
      end;
    end;
  end;

  j = 1;
  for i = 1, 179 do
    if GetHeroCreatures( hero2, i) > 0 then
      array_army_Hero2[j].ID  = i;
      array_army_Hero2[j].kol = GetHeroCreatures( hero2, i);
      j = j + 1;
    end;
  end;

  j = 1;
  for i = 1, 4 do
    if HasHeroWarMachine(hero2, i) and i ~= 2 then
      array_machine_Hero2[j]  = i;
      j = j + 1;
    end;
  end;
  
  expHero2 = GetHeroStat(hero2, STAT_EXPERIENCE);
  attHero2 = GetHeroStat(hero2, STAT_ATTACK);
  defHero2 = GetHeroStat(hero2, STAT_DEFENCE);
  spHero2  = GetHeroStat(hero2, STAT_SPELL_POWER);
  knHero2  = GetHeroStat(hero2, STAT_KNOWLEDGE);

  x, y = GetObjectPosition(hero2);
  RemoveObject(hero2);

  for i = 0, 7 do
    for j = 1, length(dublikat_heroes[i]) do
      if (hero2 == dublikat_heroes[i][j].name or hero2 == dublikat_heroes[i][j].name2) then
        HeroMax2 = dublikat_heroes[i][j].name4;
      end;
    end;
  end;

  DeployReserveHero(HeroMax2, x, y, 0);
  Trigger( HERO_ADD_SKILL_TRIGGER, HeroMax2, 'no');
  WarpHeroExp(HeroMax2, expHero2);
  for i = 1, 26 do
    for j = 1, array_skills_Hero2[i] do
      if array_skills_Hero2[i] >= j then
        if GetHeroSkillMastery(HeroMax2, array_skills[i]) < array_skills_Hero2[i] then
          GiveHeroSkill(HeroMax2, array_skills[i]);
        end;
      end;
    end;
  end;
  for i = 1, kol_perks_Hero2 do
    GiveHeroSkill(HeroMax2, array_perks_Hero2[i]);
  end;
  
  k = 0;
  for i = 1, 189 do
    if HasHeroSkill( HeroMax2, array_perks[i]) then
      k = k + 1;
    end;
  end;
  while k < kol_perks_Hero2 do
    for i = 1, kol_perks_Hero2 do
      if HasHeroSkill( HeroMax2, array_perks_Hero2[i]) == nil then
        GiveHeroSkill(HeroMax2, array_perks_Hero2[i]);
        k = k + 1;
        if array_perks_Hero2[i] == 115 and GetHeroCreatures(HeroMax2, 146) > 0 then RemoveHeroCreatures(HeroMax2, 146, 10); end;
        if array_perks_Hero2[i] == 181 and GetHeroCreatures(HeroMax2, 173) > 0 then RemoveHeroCreatures(HeroMax2, 173, 15); end;
      end;
    end;
  end;

  for i = 1, length(array_army_Hero2) do
    if array_army_Hero2[i].ID ~= 0 then
      AddHeroCreatures(HeroMax2, array_army_Hero2[i].ID, array_army_Hero2[i].kol);
      if GetHeroCreatures(HeroMax2, 88) > 0 then kolCreatures2 = GetHeroCreatures(HeroMax2, 88); RemoveHeroCreatures(HeroMax2, 88, kolCreatures2); end;
    end;
  end;

--  print('ttt');

  for i = 1, length(array_machine_Hero2) do
    if array_machine_Hero2[i] ~= 0 then
      GiveHeroWarMachine(HeroMax2, array_machine_Hero2[i]);
    end;
  end;
  
--  print('1');

  if StartBonus[2] == 'spell' then
    TeachHeroSpell(HeroMax2, array_spells[BonusSpells[1].m1][BonusSpells[1].sp1].id );
    TeachHeroSpell(HeroMax2, array_spells[BonusSpells[1].m2][BonusSpells[1].sp2].id );
  end;
  
--  print('2');
  
  sleep(1);
  
--  print(GetHeroStat(HeroMax2, STAT_ATTACK));
--  print(GetHeroStat(HeroMax2, STAT_DEFENCE))
--  print(GetHeroStat(HeroMax2, STAT_SPELL_POWER))
--  print(GetHeroStat(HeroMax2, STAT_KNOWLEDGE))

  attHero2 = attHero2 - GetHeroStat(HeroMax2, STAT_ATTACK); --print(attHero2);
  defHero2 = defHero2 - GetHeroStat(HeroMax2, STAT_DEFENCE); --print(defHero2);
  spHero2  = spHero2  - GetHeroStat(HeroMax2, STAT_SPELL_POWER); --print(spHero2);
  knHero2  = knHero2  - GetHeroStat(HeroMax2, STAT_KNOWLEDGE); --print(knHero2);

  if attHero2 > 0 then ChangeHeroStat(HeroMax2, STAT_ATTACK,      attHero2); end;
  if defHero2 > 0 then ChangeHeroStat(HeroMax2, STAT_DEFENCE,     defHero2); end;
  if spHero2  > 0 then ChangeHeroStat(HeroMax2, STAT_SPELL_POWER,  spHero2); end;
  if knHero2  > 0 then ChangeHeroStat(HeroMax2, STAT_KNOWLEDGE,    knHero2); end;
  
  for i = 1, length(array_arts_Hero2) do
    if array_arts_Hero2[i].ID ~= 0 and array_arts_Hero2[i].Eq == 1 then
      GiveArtefact(HeroMax2, array_arts_Hero2[i].ID);
    end;
  end;
  
  if Name(HeroMax2) == "Una" then
    for i = 1, 10 do
      if array_FreeRunes[i] == 2 then
        TeachHeroSpell(HeroMax2, array_spells[4][i].id);
      end;
    end;
  end;
  
  sleep(2);
  
--  print('3');

  array_skills_Hero2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_perks_Hero2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  array_arts_Hero2 = {{["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0},  {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}, {["ID"] = 0, ["Eq"] = 0}}
  array_army_Hero2 = {{["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}, {["ID"] = 0, ["kol"] = 0}};
  array_machine_Hero2 = { 0, 0, 0}
end;



--------------------------------------------------------------------------------

function NecroArtSet(hero)
  if GetHeroSkillMastery(hero,          SKILL_TRAINING) > 0 then ChangeHeroStat(hero, 1, -2); ChangeHeroStat(hero, 2, -2); end;
  if GetHeroSkillMastery(hero,            SKILL_GATING) > 0 then ChangeHeroStat(hero, 1, -2); ChangeHeroStat(hero, 4, -2); end;
  if GetHeroSkillMastery(hero,        SKILL_NECROMANCY) > 0 then ChangeHeroStat(hero, 2, -2); ChangeHeroStat(hero, 3, -2); end;
  if GetHeroSkillMastery(hero,           SKILL_AVENGER) > 0 then ChangeHeroStat(hero, 2, -2); ChangeHeroStat(hero, 4, -2); end;
  if GetHeroSkillMastery(hero,        SKILL_ARTIFICIER) > 0 then ChangeHeroStat(hero, 3, -2); ChangeHeroStat(hero, 4, -2); end;
  if GetHeroSkillMastery(hero,        SKILL_INVOCATION) > 0 then ChangeHeroStat(hero, 1, -2); ChangeHeroStat(hero, 3, -2); end;
  if GetHeroSkillMastery(hero,     HERO_SKILL_RUNELORE) > 0 then ChangeHeroStat(hero, 2, -2); ChangeHeroStat(hero, 3, -2); end;
  if GetHeroSkillMastery(hero, HERO_SKILL_DEMONIC_RAGE) > 0 then ChangeHeroStat(hero, 1, -2); ChangeHeroStat(hero, 2, -2); end;
end;


--Pokupka statov

stat1 = 0;
stat2 = 0;
statA1 = 0;
statD1 = 0;
statS1 = 0;
statK1 = 0;
statA2 = 0;
statD2 = 0;
statS2 = 0;
statK2 = 0;

        --Igrok 1
function napPlus1(hero)
  SetObjectEnabled('napadenie1', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie1', nil );
  if stat1 == 0 then MakeHeroInteractWithObject (hero_1, 'napadenie1'); else MakeHeroInteractWithObject (hero_1, 'dolm1'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie1', 'nap1' );
  SetObjectEnabled('napadenie1', nil);
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  2500));
  stat1 = stat1 + 1;
  statA1 = statA1 + 1;
  if stat1 < 2 then SetObjectEnabled('napadenie1', nil); end;
end;

function nap1(hero)
  hero_1 = hero;
  if stat1 < 2 then
     if (GetPlayerResource(1, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."napadeniePlus1.txt", 'napPlus1', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function defPlus1(hero)
  SetObjectEnabled('zashchita1', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita1', nil );
  if stat1 == 0 then MakeHeroInteractWithObject (hero_1, 'zashchita1'); else MakeHeroInteractWithObject (hero_1, 'dolm2'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita1', 'def1' );
  SetObjectEnabled('zashchita1', nil);
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  2500));
  stat1 = stat1 + 1;
  statD1 = statD1 + 1;
  if stat1 < 2 then SetObjectEnabled('zashchita1', nil); end;
end;

function def1(hero)
  hero_1 = hero;
  if stat1 < 2 then
     if (GetPlayerResource(1, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."zashchitaPlus1.txt", 'defPlus1', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function koldPlus1(hero)
  SetObjectEnabled('koldovstvo1', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo1', nil );
  if stat1 == 0 then MakeHeroInteractWithObject (hero_1, 'koldovstvo1'); else MakeHeroInteractWithObject (hero_1, 'dolm3'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo1', 'kold1' );
  SetObjectEnabled('koldovstvo1', nil);
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  2500));
  stat1 = stat1 + 1;
  statS1 = statS1 + 1;
  if stat1 < 2 then SetObjectEnabled('koldovstvo1', nil); end;
end;

function kold1(hero)
  hero_1 = hero;
  if stat1 < 2 then
     if (GetPlayerResource(1, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."koldovstvoPlus1.txt", 'koldPlus1', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function znPlus1(hero)
  SetObjectEnabled('znanie1', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'znanie1', nil );
  if stat1 == 0 then MakeHeroInteractWithObject (hero_1, 'znanie1'); else MakeHeroInteractWithObject (hero_1, 'dolm4'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'znanie1', 'zn1' );
  SetObjectEnabled('znanie1', nil);
  SetPlayerResource (PLAYER_1, GOLD, (GetPlayerResource (PLAYER_1, GOLD) -  2500));
  stat1 = stat1 + 1;
  statK1 = statK1 + 1;
  if stat1 < 2 then SetObjectEnabled('znanie1', nil); end;
end;

function zn1(hero)
  hero_1 = hero;
  if stat1 < 2 then
     if (GetPlayerResource(1, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."znaniePlus1.txt", 'znPlus1', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_1 ), GetMapDataPath().."s_no.txt" );
  end;
end;

        --Igrok 2

function napPlus2(hero)
  SetObjectEnabled('napadenie2', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie2', nil );
  if stat2 == 0 then MakeHeroInteractWithObject (hero_2, 'napadenie2'); else MakeHeroInteractWithObject (hero_2, 'dolm1'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie2', 'nap2' );
  SetObjectEnabled('napadenie2', nil);
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  2500));
  stat2 = stat2 + 1;
  statA2 = statA2 + 1;
  if stat2 < 2 then SetObjectEnabled('napadenie2', nil); end;
end;

function nap2(hero)
  hero_2 = hero;
  if stat2 < 2 then
     if (GetPlayerResource(2, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."napadeniePlus1.txt", 'napPlus2', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function defPlus2(hero)
  SetObjectEnabled('zashchita2', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita2', nil );
  if stat2 == 0 then MakeHeroInteractWithObject (hero_2, 'zashchita2'); else MakeHeroInteractWithObject (hero_2, 'dolm2'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita2', 'def2' );
  SetObjectEnabled('zashchita2', nil);
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  2500));
  stat2 = stat2 + 1;
  statD2 = statD2 + 1;
  if stat2 < 2 then SetObjectEnabled('zashchita2', nil); end;
end;

function def2(hero)
  hero_2 = hero;
  if stat2 < 2 then
     if (GetPlayerResource(2, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."zashchitaPlus1.txt", 'defPlus2', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function koldPlus2(hero)
  SetObjectEnabled('koldovstvo2', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo2', nil );
  if stat2 == 0 then MakeHeroInteractWithObject (hero_2, 'koldovstvo2'); else MakeHeroInteractWithObject (hero_2, 'dolm3'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo2', 'kold2' );
  SetObjectEnabled('koldovstvo2', nil);
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  2500));
  stat2 = stat2 + 1;
  statS2 = statS2 + 1;
  if stat2 < 2 then SetObjectEnabled('koldovstvo2', nil); end;
end;

function kold2(hero)
  hero_2 = hero;
  if stat2 < 2 then
     if (GetPlayerResource(2, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."koldovstvoPlus1.txt", 'koldPlus2', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function znPlus2(hero)
  SetObjectEnabled('znanie2', true);
  Trigger( OBJECT_TOUCH_TRIGGER, 'znanie2', nil );
  if stat2 == 0 then MakeHeroInteractWithObject (hero_2, 'znanie2'); else MakeHeroInteractWithObject (hero_2, 'dolm4'); end;
  Trigger( OBJECT_TOUCH_TRIGGER, 'znanie2', 'zn2' );
  SetObjectEnabled('znanie2', nil);
  SetPlayerResource (PLAYER_2, GOLD, (GetPlayerResource (PLAYER_2, GOLD) -  2500));
  stat2 = stat2 + 1;
  statK2 = statK2 + 1;
  if stat2 < 2 then SetObjectEnabled('znanie2', nil); end;
end;

function zn2(hero)
  hero_2 = hero;
  if stat2 < 2 then
     if (GetPlayerResource(2, 6) >= 2500) then
        QuestionBoxForPlayers (GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."znaniePlus1.txt", 'znPlus2', 'no');
        else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."NO.txt" );
     end;
     else MessageBoxForPlayers(GetPlayerFilter( PLAYER_2 ), GetMapDataPath().."s_no.txt" );
  end;
end;

function BoatMove(hero)
  sleep(2);
  MoveHeroRealTime(hero, 9, 19);
end;

function Name(hero)
  for i = 0, 7 do
    for j = 1, length(dublikat_heroes[i]) do
      if hero == dublikat_heroes[i][j].name or hero == dublikat_heroes[i][j].name2 or hero == dublikat_heroes[i][j].name3 or hero == dublikat_heroes[i][j].name4 then
        nameH = dublikat_heroes[i][j].name;
        j = length(dublikat_heroes[i]);
        i = 7;
      end;
    end;
  end;
  return nameH;
end;

function AutoSave()
  i1 = 0;
  while GetDate (DAY) == 2 or GetDate (DAY) == 3 do
    sleep (100);
    i1 = i1 + 1;
    Save(GetMapDataPath().."AutoSave");
  end;
end;


SetObjectEnabled('napadenie1', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie1', 'nap1' );

SetObjectEnabled('zashchita1', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita1', 'def1' );

SetObjectEnabled('koldovstvo1', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo1', 'kold1' );

SetObjectEnabled('znanie1', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'znanie1', 'zn1' );

SetObjectEnabled('napadenie2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'napadenie2', 'nap2' );

SetObjectEnabled('zashchita2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'zashchita2', 'def2' );

SetObjectEnabled('koldovstvo2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'koldovstvo2', 'kold2' );

SetObjectEnabled('znanie2', nil);
Trigger( OBJECT_TOUCH_TRIGGER, 'znanie2', 'zn2' );

Trigger( OBJECT_TOUCH_TRIGGER, 'port1', 'TeleportStartZone1' ); SetObjectEnabled('port1', nil); SetDisabledObjectMode('port1', 2);
Trigger( OBJECT_TOUCH_TRIGGER, 'port2', 'TeleportStartZone2' ); SetObjectEnabled('port2', nil); SetDisabledObjectMode('port2', 2);

Trigger( OBJECT_TOUCH_TRIGGER, 'boat4', 'BoatMove' );

-- Opisaniya

SetObjectEnabled('bonus1', nil);

SetObjectEnabled('bonus2', nil);

OverrideObjectTooltipNameAndDescription ('port1', GetMapDataPath().."portNAME.txt", GetMapDataPath().."portDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('port2', GetMapDataPath().."portNAME.txt", GetMapDataPath().."portDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('stat1', GetMapDataPath().."regenStatNAME.txt", GetMapDataPath().."regenStatDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('stat2', GetMapDataPath().."regenStatNAME.txt", GetMapDataPath().."regenStatDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('skill1', GetMapDataPath().."buyskillNAME.txt", GetMapDataPath().."buyskillDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('skill2', GetMapDataPath().."buyskillNAME.txt", GetMapDataPath().."buyskillDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('oko1', GetMapDataPath().."notext.txt", GetMapDataPath().."notext.txt");
OverrideObjectTooltipNameAndDescription ('oko2', GetMapDataPath().."notext.txt", GetMapDataPath().."notext.txt");
OverrideObjectTooltipNameAndDescription ('napadenie1', GetMapDataPath().."napadenieNAME.txt", GetMapDataPath().."NapadeniePlus1.txt");
OverrideObjectTooltipNameAndDescription ('zashchita1', GetMapDataPath().."zashchitaNAME.txt", GetMapDataPath().."zashchitaPlus1.txt");
OverrideObjectTooltipNameAndDescription ('koldovstvo1', GetMapDataPath().."koldovstvoNAME.txt", GetMapDataPath().."koldovstvoPlus1.txt");
OverrideObjectTooltipNameAndDescription ('znanie1', GetMapDataPath().."znanieNAME.txt", GetMapDataPath().."znaniePlus1.txt");
OverrideObjectTooltipNameAndDescription ('napadenie2', GetMapDataPath().."napadenieNAME.txt", GetMapDataPath().."NapadeniePlus1.txt");
OverrideObjectTooltipNameAndDescription ('zashchita2', GetMapDataPath().."zashchitaNAME.txt", GetMapDataPath().."zashchitaPlus1.txt");
OverrideObjectTooltipNameAndDescription ('koldovstvo2', GetMapDataPath().."koldovstvoNAME.txt", GetMapDataPath().."koldovstvoPlus1.txt");
OverrideObjectTooltipNameAndDescription ('znanie2', GetMapDataPath().."znanieNAME.txt", GetMapDataPath().."znaniePlus1.txt");
OverrideObjectTooltipNameAndDescription ('bandit_map', GetMapDataPath().."banditNAME.txt", GetMapDataPath().."bandit_mapDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('mostovik_map', GetMapDataPath().."mostovikNAME.txt", GetMapDataPath().."mostovik_mapDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('vsev_map', GetMapDataPath().."vsevNAME.txt", GetMapDataPath().."vsev_mapDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('tari_map', GetMapDataPath().."tariNAME.txt", GetMapDataPath().."tari_mapDSCRP.txt");
OverrideObjectTooltipNameAndDescription ('bonus1', GetMapDataPath().."bonusNAME.txt", GetMapDataPath().."bon.txt");
OverrideObjectTooltipNameAndDescription ('bonus2', GetMapDataPath().."bonusNAME.txt", GetMapDataPath().."bon.txt");

end;