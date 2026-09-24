# AI AGENT WORKFLOW & CODE QUALITY GUIDELINES

> **⚠️ CRITICAL**: You are an AI code assistant operating in a **Flutter monorepo**.
> You **MUST** read and follow this entire document before writing ANY code.
> Failure to comply will result in rejected Pull Requests.

---

## Table of Contents

1. [Tech Stack Restriction](#1-tech-stack-restriction)
2. [Repository Architecture](#2-repository-architecture)
3. [Strict Boundaries — What NOT To Do](#3-strict-boundaries--what-not-to-do)
4. [Git Workflow Protocol](#4-git-workflow-protocol)
5. [Branch Naming Convention](#5-branch-naming-convention)
6. [Commit Convention](#6-commit-convention)
7. [Pull Request Process](#7-pull-request-process)
8. [Pre-PR Checklist](#8-pre-pr-checklist)
9. [Flutter / Dart Code Standards](#9-flutter--dart-code-standards)
10. [AI Agent — Mandatory Rules](#10-ai-agent--mandatory-rules)
11. [AI Agent — Step-by-Step Workflow](#11-ai-agent--step-by-step-workflow)
12. [Review & Merge Policy](#12-review--merge-policy)
13. [Conflict Resolution](#13-conflict-resolution)

---

## 1. Tech Stack Restriction

- This entire repository uses **FLUTTER & DART ONLY**.
- Do **NOT** scaffold, initialize, or introduce any other frameworks, runtimes, or languages (no Node.js, Python, Java-backend, etc.).
- All projects must use standard Flutter project structure.

---

## 2. Repository Architecture

This is a **monorepo** where each assignment has separate workspaces per member (identified by MSSV).

```text
cse441-team13/                          ← ROOT (do NOT run Flutter here)
├── README.md                           ← Project info (for humans)
├── CONTRIBUTING.md                     ← This file (for AI agents & contributors)
├── .gitignore
│
├── bai-tap-1/                          ← Assignment 1
│   ├── 2351170574/                     ← Phùng Minh Anh's Flutter project
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   ├── models/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   ├── services/
│   │   │   ├── utils/
│   │   │   └── theme/
│   │   ├── test/
│   │   ├── assets/
│   │   └── pubspec.yaml
│   ├── 2251172456/                     ← Phạm Văn Phước's Flutter project
│   ├── 2351170570/                     ← Ngô Tuấn Anh's Flutter project
│   └── 2351170616/                     ← Nguyễn Đình Tuấn Sơn's Flutter project
│
├── bai-tap-2/
│   ├── 2351170574/
│   ├── 2251172456/
│   ├── 2351170570/
│   └── 2351170616/
│
└── ...
```

### Internal Flutter Project Structure

Each member workspace (`bai-tap-X/<MSSV>/`) is a standalone Flutter project:

```text
<MSSV>/
├── lib/
│   ├── main.dart                  # Entry point
│   ├── models/                    # Data models (DTOs, entities)
│   │   └── user_model.dart
│   ├── screens/                   # Full-page screens/views
│   │   ├── home_screen.dart
│   │   └── login_screen.dart
│   ├── widgets/                   # Reusable UI components
│   │   ├── custom_button.dart
│   │   └── input_field.dart
│   ├── services/                  # Business logic (API, DB, auth)
│   │   └── auth_service.dart
│   ├── utils/                     # Helpers, constants, extensions
│   │   ├── constants.dart
│   │   └── helpers.dart
│   └── theme/                     # App theme & styling
│       └── app_theme.dart
├── test/                          # Unit & widget tests
├── assets/                        # Images, fonts, etc.
└── pubspec.yaml                   # Dependencies
```

### Target Scope Rule

> **All modifications MUST be restricted to `bai-tap-X/<current-member-MSSV>/` only.**

---

## 3. Strict Boundaries — What NOT To Do

### ❌ NO Cross-Workspace Pollution
- **NEVER** edit, format, or delete files belonging to **other members** or **other assignments**.
- **NEVER** edit root-level files (`.gitignore`, `CONTRIBUTING.md`, `README.md`) unless explicitly instructed.

### ❌ NO Nested .git Repositories (CRITICAL)
- If you clone or paste an existing Flutter template into the workspace, you **MUST** delete any nested `.git/` folder inside `bai-tap-X/<MSSV>/` immediately.
- **NEVER** create git submodules.

### ❌ NEVER Run Flutter Commands at Root
- **NEVER** run `flutter pub get`, `flutter build`, or `flutter run` in the root folder.
- **ALWAYS** `cd` into the assigned member workspace first:
  ```bash
  cd bai-tap-X/<MSSV>/
  ```

### ❌ NO Direct Push to `main`
- **NEVER** commit or push directly to `main`.
- Always work on a separate branch and create a Pull Request.

### ❌ NO Prohibited Content in Code
- **NEVER** include: API keys, secrets, passwords (hardcoded)
- **NEVER** include: IDE config files (`.idea/`, `.vscode/`)
- **NEVER** include: build artifacts, dead code, unused imports
- **NEVER** use `print()` for debugging — use `debugPrint()` or a logger

---

## 4. Git Workflow Protocol

```text
main (stable, protected)
 │
 ├── bai-tap-1/2351170574       ← Branch for member's assignment
 ├── bai-tap-1/2251172456
 ├── bai-tap-2/2351170574
 └── ...
```

### Step-by-step:

```bash
# 1. Update main
git checkout main
git pull origin main

# 2. Create a new branch
git checkout -b bai-tap-X/<MSSV>

# 3. Navigate to your workspace
cd bai-tap-X/<MSSV>/

# 4. Work: code, test, commit (see sections below)

# 5. Push branch
git push -u origin bai-tap-X/<MSSV>

# 6. Create Pull Request on GitHub → Wait for review → Merge
```

---

## 5. Branch Naming Convention

**Format**: `<bai-tap-X>/<MSSV>`

| Ví dụ | Giải thích |
|-------|------------|
| `bai-tap-1/2351170574` | Bài tập 1 — Phùng Minh Anh |
| `bai-tap-2/2251172456` | Bài tập 2 — Phạm Văn Phước |
| `bai-tap-1/2351170570` | Bài tập 1 — Ngô Tuấn Anh |

**Rules**:
- Lowercase only, separated by hyphens `-`
- No special characters, no Vietnamese diacritics
- Branch name must clearly identify assignment + member

---

## 6. Commit Convention

### Format

```
<type>(<scope>): <short description>

[Optional body: detailed explanation]

[Optional footer: breaking changes, issue refs]
```

### Types

| Type | Meaning | Example |
|------|---------|---------|
| `feat` | New feature | `feat(bai-tap-1): add login screen` |
| `fix` | Bug fix | `fix(bai-tap-1): fix email validation error` |
| `docs` | Documentation | `docs: update README` |
| `style` | Code formatting (no logic change) | `style(bai-tap-1): apply dart format` |
| `refactor` | Code restructure (no behavior change) | `refactor(bai-tap-2): extract widget` |
| `test` | Add/update tests | `test(bai-tap-1): add AuthService unit test` |
| `chore` | Config, build, deps | `chore: update pubspec.yaml` |

### Rules:
- Description ≤ 72 characters
- Use present tense: "add" (not "added")
- Do not end with a period
- Scope should identify the assignment: `bai-tap-1`, `bai-tap-2`, etc.

---

## 7. Pull Request Process

### PR Title Format

```
[<Type>] <Assignment> - <Short description>

Examples:
[Feature] Bài tập 1 - Login screen
[Fix] Bài tập 2 - Fix crash on form submit
[Refactor] Bài tập 1 - Extract reusable widgets
```

### PR Description Template

```markdown
## 📝 Description
<!-- Briefly describe what this PR does -->

## 👤 Member
<!-- Your name and MSSV -->

## 🔗 Related
<!-- Related issue or task (if any) -->

## 📸 Screenshots / Video
<!-- Attach screenshots/video if UI changes -->

## ✅ Checklist
- [ ] Code builds successfully (`flutter build`)
- [ ] Tested on emulator / real device
- [ ] No warnings from `flutter analyze`
- [ ] Commit messages follow convention
- [ ] Branch name follows format
- [ ] No unnecessary files (build, IDE config...)
- [ ] Complex functions have comments
- [ ] (If UI change) Screenshots attached

## 🧪 How to Test
1. `cd bai-tap-X/<MSSV>/`
2. `flutter pub get`
3. `flutter run`
4. ...

## 📌 Notes
<!-- Any additional notes for the reviewer -->
```

---

## 8. Pre-PR Checklist

Before creating a PR, you **MUST** run these commands inside the member workspace:

```bash
cd bai-tap-X/<MSSV>/

# 1. Code analysis — must have ZERO errors/warnings
flutter analyze

# 2. Format code
dart format .

# 3. Build check
flutter build apk --debug      # Android
# or
flutter build ios --debug       # iOS (macOS only)

# 4. Run tests (if any)
flutter test

# 5. Verify no unnecessary files
git status
git diff --stat
```

### ❌ PR Will Be REJECTED If:
- Pushed directly to `main`
- Code doesn't build
- Has errors/warnings from `flutter analyze`
- Commit messages don't follow convention
- PR contains unrelated changes
- PR description is missing or too brief
- Contains unnecessary files (build, `.idea/`, `.vscode/`...)
- Code is not formatted (`dart format`)
- Modifies files outside assigned workspace

---

## 9. Flutter / Dart Code Standards

### 9.1 Naming Convention

| Type | Convention | Example |
|------|-----------|---------|
| File | `snake_case` | `login_screen.dart` |
| Class | `PascalCase` | `LoginScreen` |
| Variable, Function | `camelCase` | `userName`, `getUserData()` |
| Constant | `camelCase` or `SCREAMING_SNAKE_CASE` | `maxRetries`, `API_BASE_URL` |
| Widget | `PascalCase` | `CustomButton` |
| Enum | `PascalCase` (values: `camelCase`) | `UserRole.admin` |
| Private | prefix `_` | `_isLoading`, `_buildHeader()` |

### 9.2 Widget Rules

```dart
// ✅ GOOD: Small, clear, reusable widget
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

// ❌ BAD: Monolithic widget with all logic in one place
class MyScreen extends StatefulWidget {
  // ... 500+ lines of code in a single widget
}
```

### 9.3 General Rules

- **1 main class/widget per file** (private helpers allowed)
- **Max 300 lines per file** — split into smaller widgets if exceeded
- **Use `const` constructors** whenever possible
- **No magic numbers** — use named constants
- **Comment complex logic only** — don't comment obvious code
- **Use `final`** for variables that don't change
- **Max widget nesting depth: 4–5 levels** — extract sub-widgets beyond that
- **No `print()`** — use `debugPrint()` or a logging package
- **Use `final` and `const`** aggressively for better performance
- **Import ordering**: dart: → package: → relative imports

---

## 10. AI Agent — Mandatory Rules

> 🤖 This section is specifically for **AI tools** (GitHub Copilot, Gemini, ChatGPT, Claude, Cursor, Windsurf, etc.).

### The AI Agent MUST:

1. **Read this CONTRIBUTING.md FIRST** before writing any code
2. **Identify the target workspace**: `bai-tap-X/<MSSV>/`
3. **Only modify files within that workspace** — never touch other members' code
4. **Follow the directory structure** in Section 2 exactly
5. **Follow naming conventions** in Section 9.1 exactly
6. **Generate code in small, focused modules** — one feature/fix per PR
7. **Keep each file ≤ 300 lines**
8. **Run quality checks** before suggesting a push (Section 8)
9. **Use proper commit messages** following Section 6
10. **Never push directly to `main`** — always create a branch + PR

### The AI Agent MUST NOT:

| ❌ Forbidden | ✅ Do This Instead |
|-------------|-------------------|
| Push directly to `main` | Create branch → PR |
| Use `git add .` | `git add bai-tap-X/<MSSV>/` (specific paths) |
| Generate entire app in one shot | Generate module by module |
| Skip `flutter analyze` | Always run before push |
| Hardcode strings/colors/sizes | Use `constants.dart` or `app_theme.dart` |
| Nest widgets > 5 levels | Extract into separate widget files |
| Use `print()` | Use `debugPrint()` or logger |
| Create files in wrong directories | Follow directory structure in Section 2 |
| Edit other members' workspaces | Stay in `bai-tap-X/<current-MSSV>/` only |
| Run Flutter commands at root | Always `cd bai-tap-X/<MSSV>/` first |
| Create nested `.git/` directories | Delete `.git/` if copied from template |
| Introduce non-Flutter frameworks | Flutter & Dart ONLY |
| Generate dead code / unused imports | Clean, minimal code only |
| Commit `.idea/`, `.vscode/`, `build/` | These are in `.gitignore` |

---

## 11. AI Agent — Step-by-Step Workflow

When tasked to work for `<member-MSSV>` on `<bai-tap-X>`:

```
┌─────────────────────────────────────────────────────┐
│  STEP 1: Understand Requirements                    │
│  • Read this CONTRIBUTING.md                        │
│  • Identify scope: which assignment, which feature  │
│  • Identify files to create/modify                  │
│  • Verify target workspace: bai-tap-X/<MSSV>/      │
└──────────────────┬──────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────┐
│  STEP 2: Branch Management                          │
│  git checkout main                                  │
│  git pull origin main                               │
│  git checkout -b bai-tap-X/<MSSV>                   │
└──────────────────┬──────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────┐
│  STEP 3: Navigate & Setup                           │
│  cd bai-tap-X/<MSSV>/                               │
│  flutter pub get                                    │
│  (Delete .git/ if exists inside workspace)          │
└──────────────────┬──────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────┐
│  STEP 4: Implement Code                             │
│  • Follow directory structure (Section 2)           │
│  • Follow naming convention (Section 9.1)           │
│  • Max 300 lines per file                           │
│  • Extract reusable widgets                         │
│  • Use constants and themes                         │
└──────────────────┬──────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────┐
│  STEP 5: Quality Check (MANDATORY)                  │
│  cd bai-tap-X/<MSSV>/                               │
│  flutter analyze       ← ZERO errors/warnings      │
│  dart format .          ← Code formatted            │
│  flutter build          ← Build succeeds            │
│  flutter test           ← Tests pass (if any)       │
└──────────────────┬──────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────┐
│  STEP 6: Commit & Push                              │
│  git add bai-tap-X/<MSSV>/  ← SPECIFIC paths only  │
│  git commit -m "<type>(bai-tap-X): <description>"   │
│  git push -u origin bai-tap-X/<MSSV>               │
└──────────────────┬──────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────┐
│  STEP 7: Create Pull Request                        │
│  • Use PR title format (Section 7)                  │
│  • Fill in PR template completely                   │
│  • Attach screenshots if UI changes                 │
│  • Wait for review from team lead                   │
└─────────────────────────────────────────────────────┘
```

### Commit Templates for AI

```bash
# New feature
git commit -m "feat(bai-tap-X): add <feature-name>

- Created <filename> with <functionality>
- Added <widget/service/model> for <purpose>
- Follows CONTRIBUTING.md guidelines"

# Bug fix
git commit -m "fix(bai-tap-X): fix <bug-description>

- Root cause: <explanation>
- Solution: <approach>"

# Refactor
git commit -m "refactor(bai-tap-X): restructure <component>

- Extracted <widget> from <source>
- Improved readability and reusability"
```

---

## 12. Review & Merge Policy

### Who Reviews?
- **Team Lead (Phùng Minh Anh — 2351170574)**: Reviews and approves all PRs
- **Other members**: May review, but at least **1 approval from the team lead** is required to merge

### Review Criteria
- [ ] Code follows conventions (naming, structure)
- [ ] Directory structure is correct
- [ ] No dead code or unused imports
- [ ] `flutter analyze` has zero warnings
- [ ] Commit messages follow format
- [ ] PR description is complete
- [ ] UI displays correctly (if applicable)
- [ ] Does **NOT** affect other members' code or other assignments
- [ ] No nested `.git/` directories

### Merge Process
1. PR created → Assign team lead as reviewer
2. Reviewer checks all criteria above
3. If changes needed → Comment with specifics → Author fixes → Push again
4. When approved → **Squash and Merge**
5. Delete branch after merge

---

## 13. Conflict Resolution

```bash
# 1. Update main
git checkout main
git pull origin main

# 2. Switch to your branch
git checkout <your-branch>

# 3. Rebase onto main
git rebase main

# 4. Resolve conflicts (if any)
# - Open conflicted files
# - Keep correct code, remove markers (<<<<, ====, >>>>)
# - git add <resolved-file>
# - git rebase --continue

# 5. Force push (after rebase)
git push origin <your-branch> --force-with-lease
```

> ⚠️ Always use `--force-with-lease` instead of `--force` to avoid overwriting others' work.

---

*Last updated: September 2026*
