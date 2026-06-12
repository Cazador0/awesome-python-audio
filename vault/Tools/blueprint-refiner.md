---
tags: [tool, llm, integration]
authority: 7
updated: 2026-06-12
---

# Tool: Blueprint refiner (Claude, optional)

Optional LLM backend behind the deterministic translator's hooks, implemented as
`BlueprintRefiner` in `music_data_science/integrations/refine.py`
([cazador0/ACE-Step-1.5](https://github.com/cazador0/ACE-Step-1.5)). The pipeline runs
fully without it — [[prompt-translation]] is deterministic by default; this adds taste,
not capability.

## What it refines

| Method | In → out |
| --- | --- |
| `refine_blueprint(description, base=None)` | free-text song idea (plus optional draft) → a complete `SongBlueprint`: caption, pinned `bpm`/`key_scale`/`time_signature`, duration, one StemSpec per layer |
| `refine_plan(plan)` | a deterministic stem-edit plan → tightened windows, production-precise captions, destructive edits ordered last — never new edits the user didn't ask for |
| `as_plan_hook()` | adapter to plug `refine_plan` into `PromptTranslator(llm_refine=...)` |

## Structured-outputs guarantee

Calls go through the Anthropic SDK's structured outputs (`client.messages.parse`), so
the response is schema-validated against the pydantic models — **no free-text parsing,
no regex extraction**. What comes back is a valid `SongBlueprint`/`EditPlan` or an
error, never junk that [[acestep-api]] would choke on downstream.

## Refusal fallback

If the model declines a plan refinement, `refine_plan` returns the deterministic plan
unchanged — refinement degrades to a no-op, the pipeline never stalls on it. Same
spirit as the queue fallback in [[task-queue]]: optional layers fail *toward* the
deterministic path.

## Install / environment

- `pip install music-data-science[llm]` — the `anthropic` package is imported lazily;
  the core package never requires it.
- `ANTHROPIC_API_KEY` must be set in the environment; the model id defaults to
  `DEFAULT_MODEL` in `integrations/refine.py`.
- No key, no package, or no budget? Skip the hook entirely — [[prompt-translation]]
  alone produces a valid blueprint.
