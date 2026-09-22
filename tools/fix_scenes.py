import os
for s in ['03', '04', '05']:
    path = f'scenes/levels/station_{s}.tscn'
    content = open(path, 'r', encoding='utf-8').read()
    if 'AirlockZone' in content:
        content = content.replace('AirlockZone', 'ReturnZone')
        open(path, 'w', encoding='utf-8').write(content)

