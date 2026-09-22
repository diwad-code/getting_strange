import os
for s in ['03', '04', '05']:
    path = f'scripts/levels/station_{s}.gd'
    content = open(path, 'r', encoding='utf-8').read()
    if 'if return_zone:' not in content and 'if airlock_zone:' in content:
        content = content.replace('if airlock_zone:', 'if return_zone:')
    open(path, 'w', encoding='utf-8').write(content)

