import os

stations = ['station_01.gd', 'station_02.gd', 'station_03.gd', 'station_04.gd']
for station in stations:
    path = os.path.join('C:\\getting_strange\\scripts\\levels', station)
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    content = content.replace('preload(\\\"res://scripts/core/narrative_guidance_service.gd\\\")', 'preload(\"res://scripts/core/narrative_guidance_service.gd\")')
    content = content.replace('preload(\\\"res://scripts/core/guidance_beat.gd\\\")', 'preload(\"res://scripts/core/guidance_beat.gd\")')
    
    content = content.replace(
        '@onready var guidance_service: NarrativeGuidanceService = \n',
        '@onready var guidance_service: NarrativeGuidanceService = \n'
    )
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
