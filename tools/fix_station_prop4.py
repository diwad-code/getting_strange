import os
for s in ['03', '04', '05']:
    path = f'scripts/levels/station_{s}.gd'
    content = open(path, 'r', encoding='utf-8').read()
    content = content.replace('@onready var airlock_zone: Area2D = ', '')
    content = content.replace('airlock_zone', 'return_zone')
    open(path, 'w', encoding='utf-8').write(content)

