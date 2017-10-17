DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

INSERT INTO users (fname, lname)
VALUES ('Truong','Nguyen');
INSERT INTO users (fname, lname)
VALUES ('David','Bodow');
INSERT INTO users (fname, lname)
VALUES ('Jack','Bauer');

DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO questions (title, body, user_id)
VALUES ('Sky', 'Why is the sky blue?',1);

INSERT INTO questions (title, body, user_id)
VALUES ('42', 'What is the meaning of life?',2);

INSERT INTO questions (title, body, user_id)
VALUES ('CS', 'P = NP',3);

INSERT INTO questions (title, body, user_id)
VALUES ('Platypus', 'What is the lifecycle of a Platypus?',2);

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows(
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO question_follows (user_id, question_id)
VALUES (1, 1);

INSERT INTO question_follows (user_id, question_id)
VALUES (2, 2);

INSERT INTO question_follows (user_id, question_id)
VALUES (3, 3);

INSERT INTO question_follows (user_id, question_id)
VALUES (2, 4);

INSERT INTO question_follows (user_id, question_id)
VALUES (1, 2);

INSERT INTO question_follows (user_id, question_id)
VALUES (2, 3);

INSERT INTO question_follows (user_id, question_id)
VALUES (1, 4);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
    FOREIGN KEY (question_id) REFERENCES questions(id)
    FOREIGN KEY (user_id) REFERENCES users(id)
    FOREIGN KEY (parent_id) REFERENCES replies(id)
);

INSERT INTO replies (question_id, parent_id, user_id, body)
VALUES (
  2, NULL, 1,
  'To eat lots of food'
);

INSERT INTO replies (question_id, parent_id, user_id, body)
VALUES (
  2, 1, 2,
  'That''s Phat!'
);

INSERT INTO replies (question_id, parent_id, user_id, body)
VALUES (
  1, NULL, 3,
  'A purple wizard was trying to paint the ceiling red but tripped.'
);

INSERT INTO replies (question_id, parent_id, user_id, body)
VALUES (
  1, 2, 1,
  'Because air is blue.'
);

INSERT INTO replies (question_id, parent_id, user_id, body)
VALUES (
  3, NULL, 2,
  'No.'
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes(
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
    FOREIGN KEY (question_id) REFERENCES questions(id)
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO question_likes (question_id, user_id)
VALUES (1, 1);

INSERT INTO question_likes (question_id, user_id)
VALUES (1, 2);

INSERT INTO question_likes (question_id, user_id)
VALUES (1, 3);

INSERT INTO question_likes (question_id, user_id)
VALUES (2, 1);

INSERT INTO question_likes (question_id, user_id)
VALUES (2, 2);

INSERT INTO question_likes (question_id, user_id)
VALUES (3, 1);
