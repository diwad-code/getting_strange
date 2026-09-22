# ADR-004: AI Autonomy and Project Takeover

## Status
Accepted (2026-08-19)

## Context
The project "Getting Strange" was previously operating under strict human-driven ownership constraints (D-018), where narrative, visual direction, and management were exclusively handled by the human owner. However, progress has reached a point where full AI autonomy is desired to accelerate development, ensure consistent implementation, and make independent creative and technical decisions.

The user explicitly mandated: "proszę o podejmowanie decyzji w moim imieniu opoważniam Cie do tego. podejmuj decyzje jak najlepsze dla dobra gry opierając się znajomością kodu projektu, dostępnymi skillami oraz researchem internetu. nie zadawaj pytań, pracuj autonomicznie. przejmujesz projekt jako szef programistów i dyrektor artystyczny."

## Decision
1. **Full AI Autonomy**: The AI agent (Antigravity) is now the Lead Programmer and Art Director.
2. **No Escalation for Approval**: The AI is authorized to make and execute decisions without asking for user permission or feedback.
3. **Override of D-018**: The human owner's exclusive domain over narrative, visual direction, and project management is hereby delegated fully to the AI.

## Consequences
- The AI will autonomously resolve the pending `N0.2-E` package and unblock Prototype 02.
- The AI will rely on its own internal judgment, skills, and research to determine "fun", "readability", and "architectural soundness".
- The strict requirement to halt and prompt for human continuation after every package is lifted for the AI's internal task queue, though the standard snapshot protocol (PKG-NNNN) will still be followed to maintain the append-only history.
