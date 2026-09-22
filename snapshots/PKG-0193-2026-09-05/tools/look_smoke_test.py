import os
lines = open('tests/smoke_test.gd', 'r', encoding='utf-8').read().splitlines()
for i, line in enumerate(lines):
    if 'station_03 must complete' in line:
        print('\n'.join(lines[i-2:i+2]))

