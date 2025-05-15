CREATE TABLE genre (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE perfomer (
    perfomer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE genre_perfomer (
    genre_perfomer_id SERIAL PRIMARY KEY,
    genre_id INTEGER NOT NULL,
    perfomer_id INTEGER NOT NULL,
    CONSTRAINT fk_genre FOREIGN KEY(genre_id) REFERENCES genre(genre_id) ON DELETE CASCADE, 
    CONSTRAINT fk_perfomer FOREIGN KEY(perfomer_id) REFERENCES perfomer(perfomer_id) ON DELETE CASCADE
);

CREATE TABLE album (
    album_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    release_date DATE NOT NULL,
    CONSTRAINT chk_release_date CHECK (release_date >= '1900-01-01')
);

CREATE TABLE perfomer_album (
    perfomer_album_id SERIAL PRIMARY KEY,
    perfomer_id INTEGER NOT NULL,
    album_id INTEGER NOT NULL,
    CONSTRAINT fk_perfomer FOREIGN KEY(perfomer_id) REFERENCES perfomer(perfomer_id) ON DELETE CASCADE,
    CONSTRAINT fk_album FOREIGN KEY(album_id) REFERENCES album(album_id) ON DELETE CASCADE
);

CREATE TABLE track (
    track_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    duration INTEGER NOT NULL,
    album_id INTEGER REFERENCES album(album_id) NOT NULL,
    CONSTRAINT chk_duration CHECK (duration BETWEEN 15 AND 1800)
);

CREATE TABLE collection (
    collection_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    release_date DATE NOT NULL,
    CONSTRAINT chk_release_date CHECK (release_date >= '1900-01-01')
);

CREATE TABLE collection_track (
    collection_track_id SERIAL PRIMARY KEY,
    collection_id INTEGER NOT NULL,
    track_id INTEGER NOT NULL,
    CONSTRAINT fk_collection FOREIGN KEY(collection_id) REFERENCES collection(collection_id) ON DELETE CASCADE,
    CONSTRAINT fk_track FOREIGN KEY(track_id) REFERENCES track(track_id) ON DELETE CASCADE
);

