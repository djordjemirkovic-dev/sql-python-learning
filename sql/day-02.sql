-- -----------------------------------------
-- Lekcija 6: INNER JOIN
-- -----------------------------------------
-- PK (primarni kljuc) = identitet reda u svojoj tabeli
-- FK (strani kljuc)   = pokazuje na PK u drugoj tabeli
-- JOIN spaja redove gde se FK poklapa sa PK, uslov ide posle ON.
-- Kad dve tabele imaju istu kolonu (npr. id), pise se tabela.kolona


-- 11. Za svaku porudzbinu: id, datum i ime kupca.
--     INNER JOIN vraca samo redove koji imaju par na obe strane.
--     Kupci bez porudzbina (Vladimir, Tijana) zato NE izlaze.
SELECT porudzbine.id, porudzbine.datum, kupci.ime
FROM porudzbine
INNER JOIN kupci
    ON porudzbine.kupac_id = kupci.id;


-- 12. Isto, samo kupci iz Novog Sada, od najstarije porudzbine.
--     WHERE i ORDER BY dolaze posle svih JOIN-ova.
SELECT porudzbine.id, porudzbine.datum, kupci.ime
FROM porudzbine
INNER JOIN kupci
    ON porudzbine.kupac_id = kupci.id
WHERE kupci.grad = 'Novi Sad'
ORDER BY porudzbine.datum ASC;


-- 13. Za svaku stavku: id porudzbine, naziv proizvoda, kolicina.
--     PAZNJA: JOIN na pogresne kolone NE baca gresku,
--     vraca redove koji izgledaju normalno a podaci su pogresni.
--     Provera: procitaj ON kao recenicu, proveri jedan poznat red,
--     prebroj redove (treba 28).
SELECT stavke_porudzbine.porudzbina_id, proizvodi.naziv, stavke_porudzbine.kolicina
FROM stavke_porudzbine
INNER JOIN proizvodi
    ON proizvodi.id = stavke_porudzbine.proizvod_id;


-- 13b. Isto, sa alijasima. Kraci zapis, isti rezultat.
SELECT s.porudzbina_id, p.naziv, s.kolicina
FROM stavke_porudzbine s
INNER JOIN proizvodi p
    ON p.id = s.proizvod_id;


-- 14. Za svaku stavku: ime kupca, naziv proizvoda, kolicina.
--     Stavka nema kupac_id, zna samo porudzbinu.
--     Put do kupca: stavke -> porudzbine -> kupci
--     Put do proizvoda: stavke -> proizvodi
--     Cetiri tabele, tri JOIN-a.
SELECT kupci.ime, proizvodi.naziv, stavke_porudzbine.kolicina
FROM stavke_porudzbine
INNER JOIN proizvodi
    ON proizvodi.id = stavke_porudzbine.proizvod_id
INNER JOIN porudzbine
    ON porudzbine.id = stavke_porudzbine.porudzbina_id
INNER JOIN kupci
    ON porudzbine.kupac_id = kupci.id;