# How to create the dev branch and open a PR (step-by-step)

Do these steps **in order** in your terminal. Use **WSL** or **Git Bash** if you're on Windows.

---

## Step 1: Open terminal in the project folder

```bash
cd "/home/elonerajeev/Multi-Cloud DevOps Deployment Platform"
```

*(If you're in Windows PowerShell and the project is under WSL, use:)*  
`cd "\\wsl.localhost\Debian\home\elonerajeev\Multi-Cloud DevOps Deployment Platform"`  
*Then for git commands use WSL: `wsl` then run the bash commands below inside WSL.*

---

## Step 2: Check if git is initialized and remote exists

```bash
git status
git remote -v
```

- If you see "not a git repository": run **Step 2a**.  
- If you see a list of files and `origin` URL: skip to **Step 3**.

### Step 2a: Initialize and add remote (only if needed)

```bash
git init
git remote add origin https://github.com/elonerajeev/Multi-Cloud-DevOps-Deployment-Platform.git
git fetch origin
```

---

## Step 3: Create the dev branch

**If your changes are NOT pushed to GitHub yet (main on GitHub is old):**

```bash
git checkout -b dev origin/main
```

*(If that fails with "pathspec 'origin/main' did not match", use:)*  
`git checkout -b dev`

**If you already pushed everything to main (main on GitHub is up to date):**

```bash
git checkout -b dev
```

---

## Step 4: Stage and commit all changes

```bash
git add -A
git status
```

Check that the listed files are the ones you expect. Then:

```bash
git commit -m "feat: platform improvements - health/ready, docker-compose, GitHub Actions, network policy, security, Jenkins rollback"
```

*(If it says "nothing to commit, working tree clean", your changes are already committed; skip to Step 5.)*

---

## Step 5: Push dev to GitHub

```bash
git push -u origin dev
```

- You may be asked for your GitHub username and **Personal Access Token** (not your password).  
- If you use SSH: ensure `origin` uses SSH URL, e.g.  
  `git remote set-url origin git@github.com:elonerajeev/Multi-Cloud-DevOps-Deployment-Platform.git`  
  then run `git push -u origin dev` again.

---

## Step 6: Open the Pull Request in the browser

1. Open this link:  
   **https://github.com/elonerajeev/Multi-Cloud-DevOps-Deployment-Platform/compare/main...dev**

2. Click the green **"Create pull request"** button.

3. Set the title, e.g.:  
   `Platform improvements: health checks, Docker Compose, CI, security`

4. In the description you can write something like:  
   `Platform improvements: backend /health & /ready, docker-compose, GitHub Actions CI, K8s NetworkPolicy & securityContext, Jenkins rollback + health check, branching docs. See docs/BRANCHING_STRATEGY.md.`

5. Click **"Create pull request"**.

6. When ready, click **"Merge pull request"** to merge **dev** into **main**.

---

## Quick copy-paste (all commands)

```bash
cd "/home/elonerajeev/Multi-Cloud DevOps Deployment Platform"
git checkout -b dev origin/main || git checkout -b dev
git add -A
git commit -m "feat: platform improvements - health/ready, docker-compose, GitHub Actions, network policy, security, Jenkins rollback"
git push -u origin dev
```

Then open: **https://github.com/elonerajeev/Multi-Cloud-DevOps-Deployment-Platform/compare/main...dev** and create the PR.

---

## If something goes wrong

| Problem | What to do |
|--------|------------|
| `origin/main` not found | Use `git checkout -b dev` (no `origin/main`). |
| "Nothing to commit" | You're already committed; just run `git push -u origin dev`. |
| Push rejected (e.g. no permission) | Check GitHub login; use a Personal Access Token or SSH key. |
| Branch `dev` already exists | Run `git checkout dev` then `git add -A`, `git commit` (if needed), `git push -u origin dev`. |
