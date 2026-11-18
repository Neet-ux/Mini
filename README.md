# SkillBridge — Skill Gap Analyzer
Third-Year BSc Computer Science Project

## What it does
SkillBridge lets students compare their current skills against the requirements
of a target job, visualizes the gap with Chart.js, and recommends free learning
resources for every missing skill.

## Panels
| Panel | URL | Credentials |
|-------|-----|-------------|
| Viewer | index.html / dashboard.html | none |
| Admin  | admin.html | admin / admin123 |

## Quick demo (no install)
Open `index.html` in a browser. The demo uses localStorage as a fake database,
so you can try everything: run analyses, and log into the admin panel to add
jobs and students.

## Production run (Flask + MySQL)
1. Install dependencies:  `pip install -r requirements.txt`
2. Create the database:  `mysql -u root -p < schema.sql`
3. Edit `DB` config at the top of `app.py` with your MySQL password.
4. Copy the frontend into `static/`:  `cp index.html dashboard.html admin.html static/`
   and `cp -r assets/* static/`
5. Run:  `python app.py`  →  http://127.0.0.1:5000

## API summary
- `GET  /api/jobs` — all jobs with required skills
- `POST /api/analyze` — body `{"skills":[...], "job_id":1}` → match %, missing skills, resources
- `POST /api/admin/login`, `GET/POST/DELETE /api/admin/users`, `POST/DELETE /api/admin/jobs`, `GET /api/admin/stats`

## Stack
HTML · CSS · JavaScript · Bootstrap 5 · Chart.js · Python Flask · MySQL

## Free deployment (zero cost)
- App: PythonAnywhere free tier, or Render/Railway free web service
- DB: Aiven free MySQL, or TiDB Cloud free tier, or keep MySQL local (XAMPP)
