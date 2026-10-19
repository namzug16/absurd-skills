# Absurd Skills

This repository is Gustavo's collection of reusable AI agent skills, focused on practical development workflows and tools, including Dart, server-rendered HTML, Basecoat, HTMX, and Relic. Skills live in `skills/` and can be installed with `npx skills add namzug16/absurd-skills`.

## Skill Location

- Create every new skill in this repository under `skills/<skill-name>/`, with its instructions in `SKILL.md` and any supporting resources alongside it.
- This repository is the source of truth for skills created here, regardless of which agent is working (OpenCode, Claude, or any other agent).
- Do not save new skills to an agent's global, user-level, or agent-specific skill directory instead of this repository. Only install or copy skills elsewhere when explicitly requested.
- Follow the structure and conventions of existing skills, and update the skill list in `README.md` when adding a new skill.

## Git Commits

Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) when creating commits.

**Format:** `<type>(<optional scope>): <description>`

- **Types:** `feat`, `fix`, `refactor`, `perf`, `docs`, `style`, `test`, `build`, `ci`, `chore`, `revert`.
- Use imperative, lowercase descriptions without a trailing period (e.g., `feat(auth): add password reset`).
- Keep the subject under 72 characters, ideally 50.
- Make commits atomic: one logical change per commit.
- Include a body when additional context or rationale is needed.
- Mark breaking changes with `!` after the type/scope and include a `BREAKING CHANGE:` footer.
- Reference related issues in footers when applicable (e.g., `Fixes #123`).
- Never commit unrelated changes or broken code.
- Do not commit or push unless explicitly requested.
