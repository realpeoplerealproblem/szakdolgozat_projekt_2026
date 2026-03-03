# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment

- Python 3.14 via `.venv/` (project-local virtual environment)
- IDE: PyCharm (Black formatter configured)

Activate the venv before running anything:
```bash
source .venv/bin/activate
```

## Common commands

```bash
# Run the application
python main.py

# Install a package and keep dependencies tracked
pip install <package> && pip freeze > requirements.txt

# Install from requirements file
pip install -r requirements.txt
```

## Git workflow

- Commit locally with a clean, descriptive message, then push to `origin/main`
- Commit message format: short imperative subject line, followed by a bullet-point body explaining what changed and why
- Remote: https://github.com/realpeoplerealproblem/szakdolgozat (private)
