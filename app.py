"""SkillBridge — Flask + MySQL backend (Third-Year BSc CS Project)
Run:  pip install -r requirements.txt
      mysql -u root -p < schema.sql
      python app.py
"""
from flask import Flask, request, jsonify, send_from_directory
import mysql.connector

app = Flask(__name__, static_folder="static", static_url_path="")

DB = dict(host="localhost", user="root", password="YOUR_MYSQL_PASSWORD", database="skillbridge")

def db():
    return mysql.connector.connect(**DB)

# ---------- Viewer API ----------
@app.get("/")
def home():
    return send_from_directory("static", "index.html")

@app.get("/api/jobs")
def jobs():
    c = db().cursor(dictionary=True); c.execute("SELECT * FROM jobs"); rows = c.fetchall()
    for r in rows:
        c2 = db().cursor(); c2.execute("SELECT skill FROM job_skills WHERE job_id=%s", (r["id"],))
        r["skills"] = [x[0] for x in c2.fetchall()]
    return jsonify(rows)

@app.post("/api/analyze")
def analyze():
    d = request.json                      # {"skills": [...], "job_id": 1}
    conn = db(); cur = conn.cursor()
    cur.execute("SELECT title, level FROM jobs WHERE id=%s", (d["job_id"],))
    row = cur.fetchone()
    if not row:
        return jsonify({"error": "job not found"}), 404
    cur.execute("SELECT skill FROM job_skills WHERE job_id=%s", (d["job_id"],))
    required = [x[0] for x in cur.fetchall()]
    have = [s for s in required if s in d["skills"]]
    missing = [s for s in required if s not in d["skills"]]
    match = round(len(have) / len(required) * 100) if required else 0
    # fetch free resources for missing skills
    cur.execute("""SELECT skill, title, url, cost FROM resources
                   WHERE skill IN (%s)""" % ",".join(["%s"]*len(missing)), tuple(missing))
    resources = [{"skill": s, "title": t, "url": u, "cost": cst} for s, t, u, cst in cur.fetchall()]
    return jsonify({"job": row[0], "level": row[1], "have": have, "missing": missing,
                    "match": match, "band": "Ready" if match >= 80 else ("Nearly There" if match >= 50 else "Needs Work"),
                    "resources": resources})

# ---------- Admin API (protect with login in production!) ----------
@app.post("/api/admin/login")
def admin_login():
    d = request.json
    conn = db(); cur = conn.cursor()
    cur.execute("SELECT id FROM admins WHERE username=%s AND password=%s", (d.get("user"), d.get("pass")))
    return jsonify({"ok": bool(cur.fetchone())})

@app.get("/api/admin/users")
def users():
    c = db().cursor(dictionary=True); c.execute("SELECT * FROM users"); return jsonify(c.fetchall())

@app.post("/api/admin/users")
def add_user():
    d = request.json; conn = db(); cur = conn.cursor()
    cur.execute("INSERT INTO users (name,email,target,skills) VALUES (%s,%s,%s,%s)",
                (d["name"], d["email"], d.get("target",""), ",".join(d.get("skills",[]))))
    conn.commit(); return jsonify({"ok": True, "id": cur.lastrowid})

@app.delete("/api/admin/users/<int:uid>")
def del_user(uid):
    conn = db(); conn.cursor().execute("DELETE FROM users WHERE id=%s", (uid,)); conn.commit()
    return jsonify({"ok": True})

@app.post("/api/admin/jobs")
def add_job():
    d = request.json; conn = db(); cur = conn.cursor()
    cur.execute("INSERT INTO jobs (title,level) VALUES (%s,%s)", (d["title"], d.get("level","Entry")))
    jid = cur.lastrowid
    for s in d.get("skills", []):
        cur.execute("INSERT IGNORE INTO job_skills (job_id, skill) VALUES (%s,%s)", (jid, s))
    conn.commit(); return jsonify({"ok": True, "id": jid})

@app.delete("/api/admin/jobs/<int:jid>")
def del_job(jid):
    conn = db(); cur = conn.cursor()
    cur.execute("DELETE FROM job_skills WHERE job_id=%s", (jid,))
    cur.execute("DELETE FROM jobs WHERE id=%s", (jid,))
    conn.commit(); return jsonify({"ok": True})

@app.get("/api/admin/stats")
def stats():
    conn = db(); cur = conn.cursor()
    out = {}
    for key, q in {"jobs": "SELECT COUNT(*) FROM jobs", "users": "SELECT COUNT(*) FROM users",
                   "resources": "SELECT COUNT(*) FROM resources", "skills": "SELECT COUNT(DISTINCT skill) FROM job_skills"}.items():
        cur.execute(q); out[key] = cur.fetchone()[0]
    return jsonify(out)

if __name__ == "__main__":
    app.run(debug=True)
