import os
for s in ['03', '04', '05']:
    path = f'scripts/levels/station_{s}.gd'
    lines = open(path, 'r', encoding='utf-8').read().splitlines()
    new_lines = []
    for line in lines:
        if line.startswith('@onready var return_zone: Area2D =') and not line.strip().endswith('ReturnZone'):
            line = '@onready var return_zone: Area2D = '
        new_lines.append(line)
    open(path, 'w', encoding='utf-8').write('\n'.join(new_lines))

