import os
lines = open('tests/smoke_test.gd', 'r', encoding='utf-8').read().splitlines()
in_03_05 = False
for i, line in enumerate(lines):
    if 'func _test_station_03' in line or 'func _test_station_04' in line or 'func _test_station_05' in line:
        in_03_05 = True
    elif 'func _test_station_' in line:
        in_03_05 = False
    if in_03_05:
        if 'airlock_zone' in line:
            lines[i] = line.replace('airlock_zone', 'return_zone')
        if 'airlock zone missing' in line:
            lines[i] = line.replace('airlock zone', 'return zone')
open('tests/smoke_test.gd', 'w', encoding='utf-8').write('\n'.join(lines))

