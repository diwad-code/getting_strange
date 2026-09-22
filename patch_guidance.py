import os

stations = ['station_01.gd', 'station_02.gd', 'station_03.gd', 'station_04.gd']
for station in stations:
    path = os.path.join('C:\\getting_strange\\scripts\\levels', station)
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if 'NarrativeGuidanceService' in content:
        print(f'{station} already has guidance')
        continue
        
    scene_name = station.replace('.gd', '')
    beat_id = 's' + scene_name.split('_')[1] + '_composition'
    
    # Imports
    import re
    content = re.sub(
        r'(extends Node2D\s*\n\n.*?)(const |signal )',
        r'\1const NarrativeGuidanceService := preload(\"res://scripts/core/narrative_guidance_service.gd\")\nconst GuidanceBeat := preload(\"res://scripts/core/guidance_beat.gd\")\n\n\2',
        content,
        flags=re.DOTALL
    )
    
    content = re.sub(
        r'(@onready var camera.*?\n)',
        r'\1@onready var guidance_service: NarrativeGuidanceService = \n',
        content
    )
    
    content = content.replace(
        'func _ready() -> void:\n\tcamera = StationCameraRig.bind(self, player)\n',
        'func _ready() -> void:\n\tcamera = StationCameraRig.bind(self, player)\n\t_setup_guidance()\n'
    )
    
    guidance_code = f'''
func _setup_guidance() -> void:
\tif guidance_service == null:
\t\treturn
\t_register_beat(&\"{beat_id}\", GuidanceBeat.Tier.L0_COMPOSITION, &\"observation\", &\"factual\", \"\", \"\", &\"\", \"\")

func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
\tvar beat := GuidanceBeat.new()
\tbeat.beat_id = beat_id
\tbeat.scene_id = &\"{scene_name}\"
\tbeat.tier = tier
\tbeat.thought_kind = thought_kind
\tbeat.truth_scope = truth_scope
\tbeat.text_pl = text_pl
\tbeat.text_en = text_en
\tbeat.cooldown_s = 8.0
\tbeat.hypothesis_id = hypothesis_id
\tbeat.predicted_check = predicted_check
\tguidance_service.register_beat(beat)
'''
    
    content = content.replace(
        '\nfunc _on_airlock_body_entered',
        guidance_code + '\nfunc _on_airlock_body_entered'
    )
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f'Updated {station}')
