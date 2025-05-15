INSERT INTO public.genre
(genre_id, "name")
values
	(nextval('genre_genre_id_seq'::regclass), 'pop'),
	(nextval('genre_genre_id_seq'::regclass), 'rock'),
	(nextval('genre_genre_id_seq'::regclass), 'classic');


INSERT INTO public.perfomer
(perfomer_id, "name")
values
	(nextval('perfomer_perfomer_id_seq'::regclass), 'Queen'),
	(nextval('perfomer_perfomer_id_seq'::regclass), 'Beetles'), 
	(nextval('perfomer_perfomer_id_seq'::regclass), 'Aqua'), 
	(nextval('perfomer_perfomer_id_seq'::regclass), 'Him');

INSERT INTO public.genre_perfomer
(genre_perfomer_id, genre_id, perfomer_id)
values
	(nextval('genre_perfomer_genre_perfomer_id_seq'::regclass), 2, 1),
	(nextval('genre_perfomer_genre_perfomer_id_seq'::regclass), 2, 2),
	(nextval('genre_perfomer_genre_perfomer_id_seq'::regclass), 2, 4),
	(nextval('genre_perfomer_genre_perfomer_id_seq'::regclass), 1, 3);


INSERT INTO public.album
(album_id, "name", release_date)
values
	(nextval('album_album_id_seq'::regclass), 'The Works', '27/02/1984'),
	(nextval('album_album_id_seq'::regclass), 'Dark Light', '23/09/2005'),
	(nextval('album_album_id_seq'::regclass), 'Rubber Soul', '03/12/1965'),
	(nextval('album_album_id_seq'::regclass), 'Aquarium', '26/03/1997');

INSERT INTO public.perfomer_album
(perfomer_album_id, perfomer_id, album_id)
values
	(nextval('perfomer_album_perfomer_album_id_seq'::regclass), 1, 1),
	(nextval('perfomer_album_perfomer_album_id_seq'::regclass), 4, 2),
	(nextval('perfomer_album_perfomer_album_id_seq'::regclass), 2, 3),
	(nextval('perfomer_album_perfomer_album_id_seq'::regclass), 3, 4);


INSERT INTO public.track
(track_id, "name", duration, album_id)
values
	(nextval('track_track_id_seq'::regclass), 'Radio Ga Ga', 345, 1),
	(nextval('track_track_id_seq'::regclass), 'The Cage', 269, 2),
	(nextval('track_track_id_seq'::regclass), 'Drive My Car', 147, 3),
	(nextval('track_track_id_seq'::regclass), 'Barbie Girl', 197, 4),
	(nextval('track_track_id_seq'::regclass), 'I Want to Break Free', 202, 1),
	(nextval('track_track_id_seq'::regclass), 'Girl', 153, 3);


INSERT INTO public.collection
(collection_id, "name", release_date)
values
	(nextval('collection_collection_id_seq'::regclass), 'Rock 1', '12/12/2010'),
	(nextval('collection_collection_id_seq'::regclass), 'Rock 2', '14/06/2011'),
	(nextval('collection_collection_id_seq'::regclass), 'Rock 3', '20/10/2011'),
	(nextval('collection_collection_id_seq'::regclass), 'Rock 4', '05/03/2019');


INSERT INTO public.collection_track
(collection_track_id, collection_id, track_id)
values
	(nextval('collection_track_collection_track_id_seq'::regclass), 1, 1),
	(nextval('collection_track_collection_track_id_seq'::regclass), 2, 2),
	(nextval('collection_track_collection_track_id_seq'::regclass), 3, 3),
	(nextval('collection_track_collection_track_id_seq'::regclass), 4, 5);
