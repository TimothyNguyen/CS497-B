CREATE TABLE movies(
    movieID SERIAL PRIMARY KEY, 
    title VARCHAR, 
    genresTemp VARCHAR
);

CREATE TABLE users(
    userID SERIAL PRIMARY KEY,
    email VARCHAR, 
    password VARCHAR, 
    name VARCHAR, 
    emailVerified BOOLEAN
);

CREATE TABLE links(
    movieID SERIAL PRIMARY KEY,
    imdbID INTEGER,
    tmdbID INTEGER,
    FOREIGN KEY (movieID)
        REFERENCES movies
);

CREATE TABLE ratings(
    userID INTEGER,
    movieID INTEGER,
    rating NUMERIC,
    PRIMARY KEY (userID, movieID),
    FOREIGN KEY (userID)
        REFERENCES users,
    FOREIGN KEY (movieID)
        REFERENCES movies
);

CREATE TABLE recommendations(
    userID INTEGER,
    movieID INTEGER,
    tmdbID INTEGER, 
    PRIMARY KEY (userID, movieID),
    FOREIGN KEY (userID)
        REFERENCES users,
    FOREIGN KEY (movieID)
        REFERENCES movies
);


-- Movies
\COPY movies(movieID, title, genresTemp) FROM '/var/lib/postgresql/data/ml-25m/movies.csv' CSV HEADER;
-- Converts genres to array
ALTER TABLE movies ADD genres TEXT[];
UPDATE movies
SET genres = string_to_array(genresTemp, '|');
ALTER TABLE movies DROP COLUMN genresTemp;

-- Increment new IDs for new movies
ALTER SEQUENCE movies_movieid_seq RESTART WITH 209172;

-- Have user ID's start at 170000 (above training/test data)
ALTER SEQUENCE users_userid_seq RESTART WITH 170000;

-- Links
\COPY links(movieID, imdbID, tmdbID) FROM '/var/lib/postgresql/data/ml-25m/links.csv' CSV HEADER;

-- Increment new IDs for new movies
ALTER SEQUENCE links_movieid_seq RESTART WITH 209172;


-- For presentation purposes 
-- Adding in fake ratings for the first user (Hans' email)
INSERT INTO users VALUES (DEFAULT, 'hquiogue@umass.edu', 'this-should-be-encrypted-but-its-not', 'Hans Quiogue', 't');

-- Family movies (should get recommendations similar to these...)
INSERT INTO ratings VALUES (170000, 1, 1);
INSERT INTO ratings VALUES (170000, 48, 1);
INSERT INTO ratings VALUES (170000, 107, 1);
INSERT INTO ratings VALUES (170000, 169, 1);
INSERT INTO ratings VALUES (170000, 344, 0);