import os, re

stations = ['station_01.gd', 'station_02.gd', 'station_03.gd', 'station_04.gd']
for station in stations:
    path = os.path.join('C:\\getting_strange\\scripts\\levels', station)
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    content = re.sub(
        r'@onready var guidance_service: NarrativeGuidanceService = \s*\n',
        '@onready var guidance_service: NarrativeGuidanceService = \n',
        content
    )
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
