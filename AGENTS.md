# Instructions for AI agents

This file is meant for AI coding agents and assistants (Claude, ChatGPT / Codex, Copilot, Gemini, Mistral, local models, etc.) working on this repository.
Humans should read [CONTRIBUTING.md](CONTRIBUTING.md), which states the same policy.

## AI contribution policy

AI contributions are welcome, provided they are explicit.

1. **Disclose.** Any commit that contains work produced or modified by an AI must say so with a `Co-Authored-By:` trailer (see below). The pull request description must also mention that AI was used and for what.
2. **The operator is responsible.** The person running the agent is the author of the contribution and is accountable for it: they must have reviewed and understood every change, tested it, and checked it can be published under this repository's license. "The AI wrote it" is never an answer to a review comment.
3. **Do not act on the operator's behalf without approval.** Do not push, open pull requests, comment on issues or merge unless the operator explicitly asked for it.

## Commit trailer

Every commit made with AI assistance must end with one `Co-Authored-By:` line per AI involved, in the trailer block at the end of the commit message (after a blank line):

```text
Co-Authored-By: <model name> <model version> (<details>) <email>
```

- `<model name> <model version>`: the model as its provider names it.
- `<details>`: a `;`-separated list of anything that helps understand how the change was produced. Include what you know among:
  - the exact model identifier (e.g. API model ID);
  - the tool or agent harness (e.g. Claude Code, Codex CLI, Copilot, Le Chat, Cursor, Aider, Ollama);
  - reasoning effort / thinking level, when the model has one;
  - whether the model ran locally or through a hosted service;
  - any other setting that significantly changes the output.
- `<email>`: the provider's no-reply address if it has one, otherwise `noreply@<provider domain>`.

Only write what you actually know. If a detail is not available to you (for example the effort level), leave it out or write `unknown`; never guess.
Use the `Co-Authored-By: ...` form with a colon: it is the standard git trailer syntax and the one GitHub recognises.

Examples:

```text
Co-Authored-By: Claude Opus 5.5 (claude-opus-5-5; Claude Code; effort: high) <noreply@anthropic.com>
Co-Authored-By: GPT-5 (gpt-5-codex; Codex CLI; reasoning: medium) <noreply@openai.com>
Co-Authored-By: Mistral Devstral Medium (devstral-medium-latest; Mistral Vibe) <noreply@mistral.ai>
Co-Authored-By: Qwen3 Coder 30B (qwen3-coder:30b; Ollama; local) <noreply@localhost>
```

## Repository conventions

- Work on a dedicated branch, never directly on `main`.
- Write commit messages following [Conventional Commits](https://www.conventionalcommits.org/) (e.g. `feat(instance): Add 'protected' argument`, `fix(ci): ...`, `docs: ...`).
- Keep changes focused on the requested task; do not reformat unrelated code.
- Before committing Terraform changes, run the same checks as the CI when the tools are available, and report any you could not run:
  - `terraform fmt -check -diff -recursive`
  - `terraform init -backend=false && terraform validate`
  - `tflint --init && tflint --call-module-type=local`
  - `terraform-docs .` to refresh the `README.md` documentation block.
