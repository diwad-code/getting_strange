import os
for s in ['03', '04', '05']:
    path = f'scripts/levels/station_{s}.gd'
    content = open(path, 'r', encoding='utf-8').read()
    print(f'{s}: AirlockZone in content:', 'AirlockZone' in content)
    print(f'{s}: airlock_zone in content:', 'airlock_zone' in content)

