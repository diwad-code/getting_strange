import os
for s in ['03', '04', '05']:
    path = f'scripts/levels/station_{s}.gd'
    lines = open(path, 'r', encoding='utf-8').read().splitlines()
    new_lines = []
    for line in lines:
        if '@onready var airlock_zone: Area2D = ' in line:
            continue
        if '@onready var airlock_zone' in line:
            line = line.replace('airlock_zone', 'return_zone').replace('AirlockZone', 'ReturnZone')
        new_lines.append(line)
    open(path, 'w', encoding='utf-8').write('\n'.join(new_lines))

