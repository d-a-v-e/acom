# ACOM (working name)

A local-first Rails app that extracts dated events, themes and open threads from journal-style entries, and measures how well it does it.

## Current stage
Vertical slice: one synthetic entry → model → JSON events → compared with a hand-written fixture → precision, recall and F1.

## Data
This repo is public. It holds synthetic and public data only. Never commit real personal writing.

## Who writes what
- The author writes the core by hand: extraction logic, eval metrics and labelled fixtures. Coding agents don't write or edit these unless asked.
- Coding agents do the glue: setup, config, model-call plumbing, rake tasks, CI, docs, and specs for glue code.

## Commands
- Tests: `bundle exec rspec`
- Lint: `bin/rubocop`
- Security scan: `bin/brakeman`

## Working rules
- Small diffs. Explain anything non-obvious in one sentence.
- Run the tests before saying anything is done.
- Ask before adding a gem.
