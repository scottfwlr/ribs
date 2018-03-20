CREATE TABLE papers (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author_id INTEGER,

  FOREIGN KEY(author_id) REFERENCES scientist(id)
);

CREATE TABLE scientists (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  institute_id INTEGER,

  FOREIGN KEY(institute_id) REFERENCES institute(id)
);

CREATE TABLE institutes (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  institutes (id, name)
VALUES
  (1, "Harvard"),
  (2, "Yale"), 
  (3, "Princeton");

INSERT INTO
  scientists (id, fname, lname, institute_id)
VALUES
  (1, "Steven", "Hawking", 1),
  (2, "Richard", "Feynman", 1),
  (3, "John", "Nash", 2),
  (4, "John", "Von Neumann", 3);

INSERT INTO
  papers (id, title, author_id)
VALUES
  (1, "A Brief History of Time", 1),
  (2, "Operator Theory", 4),
  (3, "Game Theory and its Applications", 3),
  (4, "Equilibria in Games", 3),
  (5, "Lockpicking 101", 2);
