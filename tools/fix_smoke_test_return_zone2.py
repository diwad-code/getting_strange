import os
lines = open('tests/smoke_test.gd', 'r', encoding='utf-8').read().splitlines()
for i, line in enumerate(lines):
    if 'station_03 must complete on entering return zone' in line:
        lines[i-1] = lines[i-1].replace('AirlockZone', 'ReturnZone')
    if 'station_04 must complete on entering return zone' in line:
        lines[i-1] = lines[i-1].replace('AirlockZone', 'ReturnZone')
    if 'station_05 must complete on entering return zone' in line:
        lines[i-1] = lines[i-1].replace('AirlockZone', 'ReturnZone')
open('tests/smoke_test.gd', 'w', encoding='utf-8').write('\n'.join(lines))

