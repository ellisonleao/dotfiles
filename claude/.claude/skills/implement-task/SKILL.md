---
name: implement-task
description: >-
  Implement a task based on a Jira card in the Opendock Nova monorepo: read the
  card description, create a branch from staging as task/OD-XXXX-short-context,
  incrementally implement the changes, and add tests where needed. Does not
  commit changes. Use when the user asks to implement, work on, or start a Jira
  ticket in the OD project.
---

# implement-task — Opendock Nova

Implements a Jira card end-to-end: reads the ticket, creates a branch, codes the
changes, adds tests, and stops before committing. Follow
[AGENTS.md](~/code/ls/opendock-nova/AGENTS.md) for repo-wide conventions.

## Step-by-step workflow

### 1. Resolve the Jira ticket

- If the user provided a key (e.g. `OD-1234`), fetch it with `getJiraIssue` using
  cloudId `opendock.atlassian.net`.
- Read the **summary**, **description**, and any **acceptance criteria** or sub-tasks.
- If the description references linked issues or sub-tasks, fetch those too.
- Ask the user to clarify anything ambiguous before writing a single line of code.

### 2. Explore the codebase

- Use the Task / explore agent to understand the area of code that will be touched.
- Identify affected apps (`apps/neutron`, `apps/helios`, etc.) and shared libs
  (`libs/core`, `libs/satellite`, `libs/subspace`).
- Check for relevant existing skills under
  `/home/ellison/code/ls/opendock-nova/.claude/skills/` and load any that apply
  (e.g. `add-neutron-entity-table`, `helios-appointment-calendar`).

### 3. Create a branch from `staging`

```bash
git checkout staging 
git pull
git checkout -b task/OD-<KEY>-<short-context>
```

- `<short-context>` is 2–5 hyphenated lowercase words describing the change.
- Example: `task/OD-1234-add-carrier-eta-field`

### 4. Implement incrementally

- Break the work into small, logical units and implement them one at a time.
- After each unit, verify the build/linter still passes on changed files:
  ```bash
  npm run neutron:lint
  ```

### 5. Add tests where needed

| Layer                                     | Tool                                                        | Notes                                  |
| ----------------------------------------- | ----------------------------------------------------------- | -------------------------------------- |
| Unit / integration (Neutron, `libs/core`) | `npx jest <path> --no-coverage`                             | Run in sandbox                         |
| Testcontainer controller specs            | `npx jest <path> --no-coverage`                             | Run in sandbox                         |
| Frontend unit tests (Helios, Luna, etc.)  | `npx vitest run --config vitest.config.ts --project=<name>` | See `frontend-unit-tests-vitest` skill |
| E2E / Playwright (`e2e/`)                 | Do **not** run — edit files only                            | Tell user to execute locally           |

- Prefer Supertest (Jest) over Playwright for API-level coverage.
- Mirror existing test file layout (tests mirror `src/` structure).

### 6. CodeRabbit review

Code review the code after all the changes

### 7. Final check before handing off

- Run the linter on all changed files.
- Run unit tests for changed modules.
- Make sure CodeRabbit review is passing.
- Summarize what was implemented, what was skipped, and what the user should
  run/verify locally.
- **Do not commit.** Present the changes and wait for explicit user approval.

## Key conventions

- Branch: `task/OD-<KEY>-<short-context>` off `staging`.
- No auto-commit; never use `git commit` without explicit user request.
- Conventional changelog format when the user does ask to commit:
  `type(scope): OD-<KEY> short description` (first line ≤ 72 chars).
