CREATE DATABASE IF NOT EXISTS skillbridge;
USE skillbridge;

CREATE TABLE admins (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL          -- demo only: hash in production!
);

CREATE TABLE jobs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  level ENUM('Entry','Mid','Senior') DEFAULT 'Entry'
);

CREATE TABLE job_skills (
  job_id INT, skill VARCHAR(80),
  PRIMARY KEY (job_id, skill),
  FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
);

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  email VARCHAR(120) UNIQUE NOT NULL,
  target VARCHAR(100), skills TEXT
);

CREATE TABLE resources (
  id INT AUTO_INCREMENT PRIMARY KEY,
  skill VARCHAR(80), title VARCHAR(150), url VARCHAR(255), cost VARCHAR(30)
);

INSERT INTO admins (username, password) VALUES ('admin','admin123');

INSERT INTO jobs (title, level) VALUES
 ('Frontend Developer','Entry'), ('Backend Developer','Entry'), ('Data Analyst','Entry'),
 ('Full-Stack Developer','Mid'), ('Machine Learning Engineer','Mid'), ('DevOps Engineer','Mid'),
 ('UI/UX Designer','Entry'), ('Android Developer','Entry');

INSERT INTO job_skills (job_id, skill) VALUES
 (1,'HTML'),(1,'CSS'),(1,'JavaScript'),(1,'React'),(1,'Git'),(1,'REST APIs'),
 (2,'Python'),(2,'SQL'),(2,'Flask'),(2,'Git'),(2,'REST APIs'),(2,'Docker'),
 (3,'Python'),(3,'SQL'),(3,'Excel'),(3,'Statistics'),(3,'Power BI'),(3,'Data Cleaning'),
 (4,'HTML'),(4,'CSS'),(4,'JavaScript'),(4,'Python'),(4,'SQL'),(4,'Git'),(4,'REST APIs'),(4,'Docker'),
 (5,'Python'),(5,'Statistics'),(5,'Machine Learning'),(5,'SQL'),(5,'Pandas'),(5,'Git'),
 (6,'Linux'),(6,'Git'),(6,'Docker'),(6,'CI/CD'),(6,'Cloud'),(6,'Networking'),
 (7,'Figma'),(7,'Wireframing'),(7,'HTML'),(7,'CSS'),(7,'Prototyping'),(7,'User Research'),
 (8,'Kotlin'),(8,'Java'),(8,'XML'),(8,'Git'),(8,'REST APIs'),(8,'Firebase');

INSERT INTO users (name,email,target,skills) VALUES
 ('Aarav Sharma','aarav@student.dev','Data Analyst','Python,SQL,HTML,CSS'),
 ('Priya Patel','priya@student.dev','Frontend Developer','HTML,CSS,JavaScript,Git'),
 ('Rohan Iyer','rohan@student.dev','Backend Developer','Python,Git');

INSERT INTO resources (skill,title,url,cost) VALUES
 ('Python','freeCodeCamp Python','https://www.freecodecamp.org/learn/scientific-computing-with-python/','Free'),
 ('Python','CS50P (Harvard)','https://cs50.harvard.edu/python/','Free'),
 ('SQL','SQLBolt','https://sqlbolt.com/','Free'),
 ('SQL','SQLZoo','https://sqlzoo.net/','Free'),
 ('JavaScript','MDN JS Guide','https://developer.mozilla.org/en-US/docs/Web/JavaScript','Free'),
 ('React','React Official Docs','https://react.dev/learn','Free'),
 ('Flask','Flask Quickstart','https://flask.palletsprojects.com/quickstart/','Free'),
 ('Machine Learning','Andrew Ng ML (Coursera)','https://www.coursera.org/learn/machine-learning','Audit Free'),
 ('Docker','Docker Get-Started','https://docs.docker.com/get-started/','Free'),
 ('Git','Learn Git Branching','https://learngitbranching.js.org/','Free'),
 ('Power BI','Microsoft PL-300 Path','https://learn.microsoft.com/training/browse/?products=power-bi','Free'),
 ('Statistics','Khan Academy Statistics','https://www.khanacademy.org/math/statistics-probability','Free'),
 ('Pandas','Kaggle Pandas','https://www.kaggle.com/learn/pandas','Free'),
 ('Figma','Figma Official Tutorials','https://help.figma.com/','Free'),
 ('REST APIs','REST API Tutorial','https://restfulapi.net/','Free'),
 ('HTML','MDN HTML','https://developer.mozilla.org/en-US/docs/Web/HTML','Free'),
 ('CSS','CSS-Tricks Guides','https://css-tricks.com/guides/','Free'),
 ('Kotlin','Android Dev Codelabs','https://developer.android.com/courses','Free'),
 ('Linux','Linux Journey','https://linuxjourney.com/','Free');
