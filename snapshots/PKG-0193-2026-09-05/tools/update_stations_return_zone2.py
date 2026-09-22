import os
for s in ['03', '04', '05']:
    path = f'scripts/levels/station_{s}.gd'
    content = open(path, 'r', encoding='utf-8').read()
    content = content.replace('airlock_zone.body_entered.connect(_on_airlock_body_entered)', 'return_zone.body_entered.connect(_on_return_body_entered)')
    content = content.replace('func _on_airlock_body_entered', 'func _on_return_body_entered')
    open(path, 'w', encoding='utf-8').write(content)

