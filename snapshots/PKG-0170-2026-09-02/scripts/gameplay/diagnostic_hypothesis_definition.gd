class_name DiagnosticHypothesisDefinition
extends Resource

## Static, authored statement of a falsifiable hypothesis in one diagnostic sequence.
## The resource names evidence and a predicted observable result; stations perform
## the test locally and never let this asset decide it for the player.

@export var hypothesis_id: StringName = &""
@export var source_fact: StringName = &""
@export_multiline var predicted_outcome: String = ""
@export var required_evidence: Array[StringName] = []
@export var trial_result: StringName = &""
@export var closure_id: StringName = &""
