-- ============================================================
-- 07 - HAVING, filtriranje grupa (SQLBolt lekcija 11)
-- Baza: prodavnica
-- ============================================================

-- Kljucna razlika koju ova lekcija uvodi:
--
--   WHERE  filtrira REDOVE, pre grupisanja.
--   HAVING filtrira GRUPE,  posle grupisanja.
--
-- Iz toga sledi prakticno pravilo:
-- WHERE ne moze da sadrzi agregat. HAVING gotovo uvek sadrzi agregat.
-- Ako u HAVING napises uslov bez agregata, taj uslov verovatno pripada
-- u WHERE, gde se izvrsava ranije i nad manje redova, dakle brze.
--
-- HAVING mora da dobije USLOV, nesto sto je tacno ili netacno.
-- Gola agregatna funkcija bez poredjenja daje gresku:
-- "argument of HAVING must be type boolean, not type bigint".


-- 1. Kategorije sa vise od 3 proizvoda. 2 reda.
SELECT
    proizvodi.kategorija,
    COUNT(proizvodi.naziv) AS broj_proizvoda
FROM proizvodi
GROUP BY proizvodi.kategorija
HAVING COUNT(proizvodi.naziv) > 3
ORDER BY broj_proizvoda DESC;


-- 2. Kategorije sa prosecnom cenom vecom od 10000. 2 reda.
--
-- Primeti da se u HAVING formula AVG(cena) ponavlja, ne koristi se alias.
-- Isti razlog kao kod WHERE: HAVING se izvrsava pre SELECT-a,
-- pa alias prosecna_cena u tom trenutku jos ne postoji.
-- Redosled: FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY.
-- Samo ORDER BY sme da koristi alias.
SELECT
    proizvodi.kategorija,
    ROUND(AVG(cena), 2) AS prosecna_cena
FROM proizvodi
GROUP BY proizvodi.kategorija
HAVING AVG(cena) > 10000;


-- 3. Samo proizvodi ispod 20000. Kategorije koje imaju bar 2 takva.
-- Prikazati broj i prosecnu cenu tih proizvoda. 3 reda.
--
-- Oba filtera u jednom upitu, i tu se vidi zasto su to dva razlicita mesta:
--   WHERE  izbacuje pojedinacne proizvode skuplje od 20000
--   HAVING izbacuje cele kategorije kojima je posle toga ostao manje od 2
--
-- Monitori ispadaju u celosti, jer su im oba proizvoda preko 20000,
-- pa ta grupa posle WHERE-a nema vise nijedan red.
SELECT
    proizvodi.kategorija,
    COUNT(proizvodi.naziv) AS broj_proizvoda,
    ROUND(AVG(cena), 2) AS prosecna_cena
FROM proizvodi
WHERE proizvodi.cena < 20000
GROUP BY proizvodi.kategorija
HAVING COUNT(proizvodi.naziv) >= 2;


-- 4. Kupci sa vise od 2 porudzbine. 2 reda.
--
-- COUNT(porudzbine.id), ne COUNT(*).
-- Pravilo: COUNT po primarnom kljucu tabele koju brojis.
-- Primarni kljuc ne moze biti NULL u pravom redu, pa je NULL samo u
-- fantomskom redu koji LEFT JOIN napravi za kupca bez porudzbina.
-- COUNT(*) bi taj red izbrojao i dao 1 umesto 0.
--
-- Isti COUNT mora stajati i u SELECT i u HAVING. Ako se razlikuju,
-- upit u jednom redu broji porudzbine a u drugom redove.
--
-- Zasto je ovde LEFT ili INNER svejedno:
-- Vladimir i Tijana imaju 0 porudzbina, a HAVING > 2 ih ionako izbacuje.
-- LEFT JOIN ih uvede, HAVING ih odmah izbaci.
-- Opste pravilo: razlika izmedju LEFT i INNER postoji samo ako nesto
-- u upitu zadrzava redove bez poklapanja. Ako ih kasniji filter brise,
-- razlike nema.
--
-- GROUP BY ide po id-u, ime se nosi uz njega. Ime nije jedinstveno.
SELECT
    kupci.ime,
    COUNT(porudzbine.id) AS broj_porudzbina
FROM kupci
LEFT JOIN porudzbine
    ON kupci.id = porudzbine.kupac_id
GROUP BY kupci.id, kupci.ime
HAVING COUNT(porudzbine.id) > 2
ORDER BY broj_porudzbina DESC;


-- 5. Proizvodi kojih je naruceno vise od 3 komada, bez otkazanih porudzbina.
-- 3 reda: Mis bezicni 5, SSD 1TB 4, USB hub 4.
--
-- Osnovna tabela je porudzbine, jer se filter odnosi na porudzbinu.
-- INNER JOIN jer nas zanimaju samo proizvodi koji jesu naruceni.
--
-- ZAMKA, i ovo je najvaznija stvar u fajlu:
-- WHERE status != 'otkazano' NE RADI.
-- Porudzbina 13 ima status NULL. NULL != 'otkazano' nije tacno,
-- ali nije ni netacno, nego je NULL. WHERE propusta samo ono sto je tacno,
-- pa porudzbina 13 tiho ispada iako nije otkazana.
--
-- IS DISTINCT FROM je operator napravljen tacno za ovo:
-- tretira NULL kao vrednost koja se razlikuje od svega,
-- pa je NULL IS DISTINCT FROM 'otkazano' tacno i red ostaje.
-- Prenosiva alternativa za druge baze je uslov u zagradama:
-- (status != 'otkazano' OR status IS NULL).
--
-- Zasto je zamka opasna: sa pogresnim uslovom se gube stavke porudzbine 13,
-- Monitor 24" padne sa 3 na 2, a Stalak za laptop sa 3 na 1.
-- Ali oba su ispod granice od 3, pa HAVING > 3 u OBA slucaja vraca
-- ista 3 reda. Greska postoji, rezultat je slucajno isti, i ne vidi se.
-- Zato se medjurezultati proveravaju, a ne samo finalni broj.
SELECT
    proizvodi.naziv,
    SUM(stavke_porudzbine.kolicina) AS ukupna_kolicina
FROM porudzbine
INNER JOIN stavke_porudzbine
    ON porudzbine.id = stavke_porudzbine.porudzbina_id
INNER JOIN proizvodi
    ON proizvodi.id = stavke_porudzbine.proizvod_id
WHERE porudzbine.status IS DISTINCT FROM 'otkazano'
GROUP BY proizvodi.id, proizvodi.naziv
HAVING SUM(stavke_porudzbine.kolicina) > 3
ORDER BY ukupna_kolicina DESC;