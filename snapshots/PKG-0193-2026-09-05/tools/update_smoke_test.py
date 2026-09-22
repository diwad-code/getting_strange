import os
content = open('tests/smoke_test.gd', 'r', encoding='utf-8').read()
content = content.replace('airlock_zone := station.get_node_or_null("ReturnZone")', 'airlock_zone := station.get_node_or_null("AirlockZone")')
content = content.replace('airlock := station.get_node_or_null("ReturnZone")', 'airlock := station.get_node_or_null("AirlockZone")')
open('tests/smoke_test.gd', 'w', encoding='utf-8').write(content)

