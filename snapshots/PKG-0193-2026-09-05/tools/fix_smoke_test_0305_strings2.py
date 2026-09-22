import os
lines = open('tests/smoke_test.gd', 'r', encoding='utf-8').read().splitlines()
in_03_05 = False
for i, line in enumerate(lines):
    if 'func _test_station_03' in line or 'func _test_station_04' in line or 'func _test_station_05' in line:
        in_03_05 = True
    elif 'func _test_station_' in line:
        in_03_05 = False
    if in_03_05:
        if 'airlock zone missing' in line:
            lines[i] = line.replace('airlock zone', 'return zone')
        if 'entering airlock zone' in line:
            lines[i] = line.replace('entering airlock zone', 'entering return zone')
open('tests/smoke_test.gd', 'w', encoding='utf-8').write('\n'.join(lines))

