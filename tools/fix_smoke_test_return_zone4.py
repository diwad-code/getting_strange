import os
lines = open('tests/smoke_test.gd', 'r', encoding='utf-8').read().splitlines()
for i, line in enumerate(lines):
    if 'player.global_position = Vector2(615.0, 296.0)' in line and 'station_03' in ''.join(lines[i-15:i+15]):
        lines[i] = '	player.global_position = Vector2(15.0, 238.0)'
    if 'player.global_position = Vector2(615.0, 296.0)' in line and 'station_04' in ''.join(lines[i-15:i+15]):
        lines[i] = '	player.global_position = Vector2(15.0, 238.0)'
    if 'player.global_position = Vector2(615.0, 296.0)' in line and 'station_05' in ''.join(lines[i-15:i+15]):
        lines[i] = '	player.global_position = Vector2(15.0, 238.0)'
open('tests/smoke_test.gd', 'w', encoding='utf-8').write('\n'.join(lines))

