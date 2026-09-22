import os
content = open('tests/smoke_test.gd', 'r', encoding='utf-8').read()
content = content.replace('station_01: return_zone missing', 'station_01: airlock zone missing')
content = content.replace('station_02: return_zone missing', 'station_02: airlock zone missing')
for i in range(6, 44):
    content = content.replace(f'station_{i:02d}: return_zone missing', f'station_{i:02d}: airlock zone missing')
    content = content.replace(f'station_{i}a: return_zone missing', f'station_{i}a: airlock zone missing')
    content = content.replace(f'station_{i}b: return_zone missing', f'station_{i}b: airlock zone missing')
    content = content.replace(f'station_{i}c: return_zone missing', f'station_{i}c: airlock zone missing')
open('tests/smoke_test.gd', 'w', encoding='utf-8').write(content)

