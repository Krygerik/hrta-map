
-- �.�. ������ ������� ���������� ������ � �������� ������,
-- �� ��� ������ ����� �������� ������
function sendSecondPartReport()
  consoleCmd('game_writelog 1');
  sleep(5)
  print('Red_player');

  consoleCmd('game_writelog 0');
end;

sendSecondPartReport()