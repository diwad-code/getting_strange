import os
lines = open('tests/smoke_test.gd', 'r', encoding='utf-8').read().splitlines()
for i, line in enumerate(lines):
    if 'must complete on entering return zone' in line:
        if 'return_zone' not in lines[i-1]:
             lines[i-1] = lines[i-1].replace('airlock_zone', 'return_zone')
open('tests/smoke_test.gd', 'w', encoding='utf-8').write('\n'.join(lines))

