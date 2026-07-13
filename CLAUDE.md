<!-- skillrunner:begin (managed by `sr bootstrap` — do not edit inside) -->
## skillrunner (`sr`) — use it every session

This project (stack: **swift**) is served by `sr` (aka `skillrunner`), a central
skill dispatcher on your PATH. It detects the stack and prints "marching orders"
(rules + steps) for YOU (Claude) to execute — it never reasons or edits files itself.

When a request matches a skill:
1. `sr status` — stack + whether docs/project-profile.md and docs/module-registry.md are cached.
2. `sr list` — skills with one-line descriptions; map the task to the right one.
3. `sr emit <skill>` — print the marching orders, then READ and FOLLOW the "Rules you MUST follow" section.
4. A skill tagged `[needs approval]` → only propose a plan/goal and STOP for the user; do not edit files first.
5. First task in a project with no docs/project-profile.md → run `learn-project` before implementing.

If a task clearly matches a skill, prefer `sr emit <skill>` over improvising.
<!-- skillrunner:end -->
