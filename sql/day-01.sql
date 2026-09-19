-- =========================================
-- DAN 01
-- SQLBolt lekcije 1, 2 i 3
-- SELECT, WHERE sa brojevima, WHERE sa tekstom
-- =========================================


-- -----------------------------------------
-- Lekcija 1: SELECT
-- -----------------------------------------

-- 1. Ime i grad svih kupaca
SELECT ime, grad
FROM kupci;

-- 2. Sve kolone tabele proizvodi
SELECT *
FROM proizvodi;

-- 3. Cena i naziv proizvoda, cena kao prva kolona.
--    Redosled kolona u rezultatu odredjuje redosled u SELECT-u,
--    a ne redosled kolona u tabeli.
SELECT cena, naziv
FROM proizvodi;


-- -----------------------------------------
-- Lekcije 2 i 3: WHERE, brojevi i tekst
-- -----------------------------------------

-- 1. Naziv i cena proizvoda skupljih od 10000
SELECT naziv, cena
FROM proizvodi
WHERE cena > 10000;

-- 2. Proizvodi iz kategorije Komponente sa cenom izmedju 7000 i 12000.
--    Za tacnu vrednost se koristi =, ne LIKE.
--    LIKE bez % ili _ je samo sporiji =.
SELECT naziv, kategorija, cena
FROM proizvodi
WHERE kategorija = 'Komponente'
  AND cena BETWEEN 7000 AND 12000;

-- 3. Kupci iz Novog Sada ili iz Beograda
SELECT ime, grad
FROM kupci
WHERE grad = 'Novi Sad' OR grad = 'Beograd';

-- 3b. Isto, preko IN. Kracе kad ima vise vrednosti.
--     IN proverava tacnu jednakost, ne pretrazuje delove teksta.
SELECT ime, grad
FROM kupci
WHERE grad IN ('Novi Sad', 'Beograd');

-- 4. Proizvodi ciji naziv sadrzi rec "monitor", malim slovima.
--    Ovo vraca NULA redova jer u PostgreSQL-u LIKE razlikuje
--    velika i mala slova, a u tabeli pise "Monitor 27"".
--    U SQLite-u i MySQL-u bi ovo radilo. SQLBolt koristi SQLite,
--    zato se rezultat razlikuje od lokalnog.
SELECT naziv, cena
FROM proizvodi
WHERE naziv LIKE '%monitor%';

-- 4a. Resenje broj 1: ILIKE.
--     Kratko, ali postoji samo u PostgreSQL-u.
SELECT naziv, cena
FROM proizvodi
WHERE naziv ILIKE '%monitor%';

-- 4b. Resenje broj 2: LOWER nad kolonom.
--     Radi u svakoj bazi. LOWER ide na KOLONU, jer su velika
--     slova u podacima, a ne u trazenom tekstu.
--     Napomena za 3. mesec: LOWER() nad kolonom sprecava
--     bazu da koristi indeks nad tom kolonom.
SELECT naziv, cena
FROM proizvodi
WHERE LOWER(naziv) LIKE '%monitor%';