class_name DiagnosticCommitmentDefinition
extends Resource

## Static, authored description of a person's bounded commitment (Flyweight Pattern).
## For dynamic instances requiring scene-local mutation, set resource_local_to_scene = true.
## It deliberately models scope, disclosed risk and the real alternative without
## reducing the decision to a moral score.

@export var commitment_id: StringName = &""
@export var person_id: StringName = &""
@export_multiline var scope: String = ""
@export_multiline var known_cost: String = ""
@export var required_disclosure: Array[StringName] = []
@export_multiline var alternative_route: String = ""
@export var outcome_key: StringName = &""
@export var trace_key: StringName = &""
