import os
lines = open('tests/smoke_test.gd', 'r', encoding='utf-8').read().splitlines()
for i, line in enumerate(lines):
    if 'station_02 must complete' in line:
        lines[i-4] = '	player.global_position = Vector2(615.0, 296.0)'
    if 'security door must be sealed initially' in line:
        lines[i-3] = '	player.global_position = Vector2(50.0, 238.0)'
open('tests/smoke_test.gd', 'w', encoding='utf-8').write('\n'.join(lines))

