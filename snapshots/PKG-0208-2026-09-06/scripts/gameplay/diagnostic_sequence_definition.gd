class_name DiagnosticSequenceDefinition
extends Resource

## Static authored contract for a 2–4-station diagnostic argument.
## Runtime state belongs exclusively to GameStateManager.decisions; this resource
## only specifies the sequence's evidence, trial, commitments and persistence keys.

@export var sequence_id: StringName = &""
@export var station_ids: Array[StringName] = []
@export var entry_gate: StringName = &""
@export_multiline var discrepancy: String = ""
@export var required_source_facts: Array[StringName] = []
@export var hypotheses: Array[DiagnosticHypothesisDefinition] = []
@export var trial_id: StringName = &""
@export var commitments: Array[DiagnosticCommitmentDefinition] = []
@export var trace_key: StringName = &""
@export var guidance_beat_ids: Array[StringName] = []
@export var state_keys: Array[StringName] = []
@export var migration_revision: int = 1
