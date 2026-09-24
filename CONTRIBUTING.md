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

This repository is a **Flutter monorepo** designed to host all team assignments throughout the semester (`bai-tap-1/`, `bai-tap-2/`, `bai-tap-3/`, etc.).

### Monorepo Structure

```text
cse441-team13/                          ← ROOT (do NOT run Flutter here)
├── README.md                           ← Project info & per-assignment feature breakdown
├── CONTRIBUTING.md                     ← Global workflow & standard guidelines (this file)
├── .gitignore
│
├── bai-tap-1/                          ← Assignment 1 (shared Flutter project)
│   ├── lib/
│   │   ├── main.dart                   # [Shared] App skeleton & navigation entry
│   │   ├── models/                     # Data models (assigned per member)
│   │   ├── screens/                    # Full-page screens (assigned per member)
│   │   ├── widgets/                    # UI widgets (assigned per member)
│   │   ├── services/                   # Business logic & Mock Data (assigned per member)
│   │   ├── utils/                      # [Shared] Helpers, constants
│   │   └── theme/                      # App theme & styling
│   ├── test/
│   ├── assets/
│   └── pubspec.yaml
│
├── bai-tap-2/                          ← Assignment 2 (same standard structure)
│   └── ...
│
├── bai-tap-3/                          ← Assignment 3 (same standard structure)
│   └── ...
│
└── ...
```

### Assignment Feature Ownership & Mapping

- For each assignment (`bai-tap-X/`), the team works on **1 shared Flutter project**.
- The specific breakdown of features, assigned members (MSSV), and allocated files for each assignment is **defined in [README.md](./README.md)** under that assignment's section.
- **Rule for Developers & AI Agents**:
  - **Always inspect [README.md](./README.md)** first to identify which feature and which specific files belong to the member (MSSV) you are working for in `bai-tap-X/`.
  - Only modify files within that member's allocated scope.

### 💡 Core Universal Principle: Self-Contained Features & Autonomous Data

This principle applies to **ALL assignments** across the course:

1. **Self-Contained Data (Mock Data / In-memory Service First)**:
   - This is a modular team assignment. **DO NOT** create tightly coupled shared databases (e.g. monolithic SQLite schemas) or complex cross-feature global state machines that create blockers between members.
   - Each member's feature manages its own data locally via **Mock Data** or **In-memory Services** inside their assigned `services/` and `models/`.
   - Each screen MUST run and function independently. Any member or examiner can open that screen, interact with mock data, and test UI/UX without depending on another member's unfinished code.
2. **Zero Cross-Dependency**:
   - No member waits for another member's feature to be ready.
   - Example: Screen A displays and manipulates its own mock dataset; Screen B operates on its own mock dataset without requiring Screen A's logic to be merged.
3. **Plug-and-Play Integration**:
   - Shared files like `main.dart` only provide the tab/navigation skeleton (e.g., `BottomNavigationBar` or routing) to host the separate screens. Shared skeleton files are set up once by the team lead.

### Target Scope Rule

> **All modifications for an assignment MUST be restricted to `bai-tap-X/` directory only.**
> Each member only modifies files **within their assigned feature scope** as specified in `README.md`.
> Files marked as `[Shared]` (`main.dart`, `constants.dart`, `helpers.dart`) require team agreement before editing.

---

## 3. Strict Boundaries — What NOT To Do

### ❌ NO Cross-Feature Pollution & Coupling
- **NEVER** edit files belonging to **another member's feature scope** without prior discussion.
- **NEVER** force tight data coupling (e.g. demanding another member's model/DB be finished before you can render your screen). Always provide fallback/mock data.
- **NEVER** edit root-level files (`.gitignore`, `CONTRIBUTING.md`, `README.md`) unless explicitly instructed.
- **Shared files** (`main.dart`, `constants.dart`, `helpers.dart`) require team agreement before modification.

### ❌ NO Nested .git Repositories (CRITICAL)
- If you clone or paste an existing Flutter template into the workspace, you **MUST** delete any nested `.git/` folder inside `bai-tap-X/` immediately.
- **NEVER** create git submodules.

### ❌ NEVER Run Flutter Commands at Root
- **NEVER** run `flutter pub get`, `flutter build`, or `flutter run` in the root folder.
- **ALWAYS** `cd` into the assignment directory first:
  ```bash
  cd bai-tap-X/
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

# 3. Navigate to the assignment directory
cd bai-tap-X/

# 4. Work: code within your assigned feature scope, test, commit

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
1. `cd bai-tap-X/`
2. `flutter pub get`
3. `flutter run`
4. ...

## 📌 Notes
<!-- Any additional notes for the reviewer -->
```

---

## 8. Pre-PR Checklist

Before creating a PR, you **MUST** run these commands inside the assignment directory:

```bash
cd bai-tap-X/

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
- Modifies files outside assigned feature scope

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

### 10.1 The AI Agent MUST:

1. **Read this CONTRIBUTING.md & README.md FIRST** before writing any code.
2. **Identify the assigned member (MSSV) and feature scope** (see table in Section 2 and README.md).
3. **Only modify files within that member's assigned scope** — never touch other members' code or shared files.
4. **Use Self-Contained Mock Data**: Always implement features with internal mock data (in-memory list / service). **DO NOT** create dependencies on other members' models, shared databases, or global state.
5. **Follow the directory structure** in Section 2 exactly.
6. **Follow naming conventions** in Section 9.1 exactly.
7. **Keep each file ≤ 300 lines** — extract sub-widgets if needed.
8. **Run quality checks** before suggesting a push (`flutter analyze`, `dart format .`).
9. **Use proper commit messages** following Section 6 (`feat(bai-tap-X): ...`).
10. **Never push directly to `main`** — always create a branch `bai-tap-X/<MSSV>` + PR.

### 10.2 The AI Agent MUST NOT:

| ❌ Forbidden | ✅ Do This Instead |
|-------------|-------------------|
| Push directly to `main` | Create branch `bai-tap-X/<MSSV>` → PR |
| Use `git add .` | Stage only modified assigned files (e.g., `git add bai-tap-1/lib/screens/...`) |
| Demand shared DB or cross-module state | Use self-contained mock data & in-memory CRUD |
| Edit files outside assigned feature scope | Only modify files owned by the specified member |
| Edit shared files (`main.dart`, `constants.dart`) | Ask user/lead before modifying shared files |
| Generate entire app in one shot | Generate module by module within member's scope |
| Skip `flutter analyze` | Always run before push (must be zero errors) |
| Hardcode strings/colors/sizes | Use `constants.dart` or `app_theme.dart` |
| Nest widgets > 5 levels | Extract into separate widget files in `widgets/` |
| Use `print()` | Use `debugPrint()` or logger |
| Run Flutter commands at root | Always `cd bai-tap-X/` first |
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
│  • Read this CONTRIBUTING.md & README.md            │
│  • Identify: which assignment, which feature scope  │
│  • Check feature ownership table in README.md for that specific assignment        │
│  • Identify files to create/modify within scope     │
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
│  cd bai-tap-X/                                      │
│  flutter pub get                                    │
│  (Delete .git/ if exists inside project)            │
└──────────────────┬──────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────┐
│  STEP 4: Implement Code                             │
│  • ONLY modify files within your feature scope      │
│  • Follow directory structure (Section 2)           │
│  • Follow naming convention (Section 9.1)           │
│  • Max 300 lines per file                           │
│  • Extract reusable widgets                         │
│  • Use constants and themes                         │
│  • Do NOT touch other members' feature files        │
└──────────────────┬──────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────┐
│  STEP 5: Quality Check (MANDATORY)                  │
│  cd bai-tap-X/                                      │
│  flutter analyze       ← ZERO errors/warnings      │
│  dart format .          ← Code formatted            │
│  flutter build          ← Build succeeds            │
│  flutter test           ← Tests pass (if any)       │
└──────────────────┬──────────────────────────────────┘
                   ▼
┌─────────────────────────────────────────────────────┐
│  STEP 6: Commit & Push                              │
│  git add bai-tap-X/     ← Assignment directory only │
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
