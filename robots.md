# Repository Guidelines

This repository contains the core application files. Each merge to the `main` branch creates a new app version. As such, code quality requirements are strict:

1. **No Bugs Allowed** – every change must be thoroughly tested. Bugs are not acceptable in the versioned releases.
2. **Clean Code** – prefer simple and readable code. Follow consistent style and formatting.
3. **Easy Maintenance** – write self‑documenting code, add comments where clarity is needed, and keep dependencies organized.
4. **Comprehensive Testing** – add unit and widget tests for all features. Run the full test suite before merging.
5. **Descriptive Commits** – commit messages should explain "why" a change was made, not just "what" was changed.
6. **No TODOs in Production** – remove or complete temporary code and avoid leaving unfinished tasks in merges.
7. **Documentation Updates** – update README or other docs whenever public APIs or workflows change.
8. **Security Best Practices** – do not commit secrets or keys. Review dependencies for vulnerabilities.

Agents automating tasks in this repository must follow these guidelines and refuse actions that would compromise code quality or stability.
