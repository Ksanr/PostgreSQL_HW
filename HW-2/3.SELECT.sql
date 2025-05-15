-- Название и продолжительность самого длительного трека.

select name, duration from track
where duration = (select MAX(duration) from track);

-- Название треков, продолжительность которых не менее 3,5 минут.

select name from track
where duration > 3.5 * 60;

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно.

select name from collection
where release_date between '01/01/2018' and '31/12/2020';

-- Исполнители, чьё имя состоит из одного слова.

select name from perfomer
where char_length(name) = char_length(replace(name, ' ', '')) ;


-- Название треков, которые содержат слово «мой» или «my».
select name from track
where lower(name) like '%my%' or lower(name) like '%мой%';



-- Количество исполнителей в каждом жанре.
select name, count(perfomer_id) from genre 
join genre_perfomer on genre.genre_id = genre_perfomer.genre_id
group by name;


-- Количество треков, вошедших в альбомы 2019–2020 годов.
select name, count(track_id) from collection c
join collection_track ct on c.collection_id  = ct.collection_id  
where c.release_date between '01/01/2019' and '31/12/2020'
group by name;

-- Средняя продолжительность треков по каждому альбому.
select c.name, avg(duration) from collection c
join collection_track ct on c.collection_id  = ct.collection_id 
join track t on ct.track_id = t.track_id
group by c.name;


-- Все исполнители, которые не выпустили альбомы в 2020 году.
select p.name from perfomer p
join perfomer_album pa on p.perfomer_id = pa.perfomer_id 
join album a on pa.album_id = a.album_id
where a.release_date not between '01/01/2020' and '31/12/2020';

-- Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
select c.name from collection c 
join collection_track ct on c.collection_id = ct.collection_id
join track t on ct.track_id = t.track_id
join perfomer_album pa on t.album_id = pa.album_id
join perfomer p on pa.perfomer_id = p.perfomer_id
where p.name = 'Queen';


-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
select a.name from album a 
join perfomer_album pa on a.album_id = pa.album_id
join genre_perfomer gp on pa.perfomer_id = gp.perfomer_id
group by a.name, gp.genre_id
having count(gp.genre_id) > 1;

-- Наименования треков, которые не входят в сборники.
select t.name from track t
left join collection_track ct on t.track_id = ct.track_id 
where ct.collection_track_id is null;

-- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
select p.name from perfomer p
join perfomer_album pa on p.perfomer_id = pa.perfomer_id
join track t on pa.album_id = t.track_id
where t.duration = (select min(duration) from track);

-- Названия альбомов, содержащих наименьшее количество треков.
select a.name from album a
group by a.name
having count(*) = (
    select min(cnt) from (
        select count(*) as cnt
        from album 
        group by name
    ) subq
);



