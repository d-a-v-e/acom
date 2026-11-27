<!-- prompt_version: extract_events_v0 -->

# Instructions

Read the journal entry given and scan it for events.

## Do

Events can be:
- in the past and already complete [occurred]
- in the past and still ongoing [ongoing]
- in the future and not yet happened [planned]

The user's personal private journal may have grammatical and spelling mistakes.
The user may have fuzzy memories and may not be able to remember the exact dates of events — do not make up dates.
It is fine to scope by year or month if the text is not clear on an exact date.
Use the journal's entry date to anchor from, not the current date, for example "in 2 weeks time" or "last weekend" or "6 months ago" etc.

## Don't

Don't extract life phases or eras (school, uni, living in a place, "that whole period after...") unless the text also names a concrete event inside them.
Ignore pseudo events like "i miss travelling" or "i miss seeing friends" as they are not concrete events.
Ignore other people's events as they are not the user's events unless the user is involved in the event.

# Entry

Written on: {{written_on}}

{{body}}

# Output format

Return a single JSON object only — no markdown fences, no commentary.

Shape:

```json
{
  "events": [
    {
      "start_date": "YYYY-MM-DD",
      "end_date": "YYYY-MM-DD",
      "status": "occurred",
      "summary": "one short sentence"
    }
  ]
}
```

Field rules:

- `start_date` / `end_date`: incomplete dates allowed as strings — `YYYY`, `YYYY-MM`, or `YYYY-MM-DD`. Match the precision the text supports; do not invent a day or month.
- `end_date` may be `null` when the span is still open.
- `status`: one of `occurred`, `planned`, `ongoing`.
- `summary`: one short sentence describing what happened or will happen.
