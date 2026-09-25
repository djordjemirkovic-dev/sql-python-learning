-- =========================================
-- DAY 03
-- SQLBolt lekcije 7 i 8
-- LEFT JOIN, NULL
-- =========================================
--
-- LEFT JOIN zadrzava SVE redove iz leve tabele (one posle FROM),
-- i kad nemaju par desno. Nepostojeci par se popuni sa NULL.
--
-- RIGHT JOIN radi isto za desnu tabelu. Retko se koristi,
-- jer uvek mozes da zamenis redosled tabela.
--
-- LEFT i INNER daju razlicit rezultat SAMO ako u levoj tabeli
-- postoje redovi bez para. Isti broj redova = nema nesparenih.


-- 1. Ime i grad SVIH kupaca, i id porudzbine ako je imaju.
--    Kupci bez porudzbina ostaju, sa NULL umesto id-a.
--    17 redova: 15 porudzbina + Vladimir i Tijana sa NULL.
SELECT kupci.ime, kupci.grad, porudzbine.id
FROM kupci
LEFT JOIN porudzbine
    ON kupci.id = porudzbine.kupac_id;


-- 2. Naziv svih proizvoda i id stavke u kojoj se proizvod javlja,
--    ukljucujuci i proizvode koji nikad nisu naruceni.
--    LEFT JOIN: 28 redova. INNER JOIN: takodje 28.
--    Isti broj znaci da svaki proizvod ima bar jednu stavku,
--    pa LEFT JOIN nema koga dodatno da zadrzi.
SELECT proizvodi.naziv, stavke_porudzbine.id
FROM proizvodi
LEFT JOIN stavke_porudzbine
    ON proizvodi.id = stavke_porudzbine.proizvod_id
ORDER BY proizvodi.naziv ASC;


-- 3. Ime kupca i id porudzbine, samo kupci iz Novog Sada,
--    ukljucujuci i one bez porudzbina.
--    7 redova, Tijana je medju njima sa NULL.
--
--    Ovde je uslov u WHERE bezbedan, jer se odnosi na LEVU tabelu.
--    Grad kupca postoji i kad kupac nema nijednu porudzbinu.
SELECT kupci.ime, porudzbine.id
FROM kupci
LEFT JOIN porudzbine
    ON kupci.id = porudzbine.kupac_id
WHERE kupci.grad = 'Novi Sad';


-- 4. Ime svih kupaca i id njihovih ISPORUCENIH porudzbina,
--    tako da se i kupci bez ijedne isporucene i dalje vide.
--    12 redova, Vladimir i Tijana su medju njima sa NULL.
--
--    KLJUCNO: uslov o statusu ide u ON, ne u WHERE.
--    ON je deo pravljenja spoja: kaze sta se racuna kao par.
--    Porudzbina koja nije isporucena nije par, kupac ostaje
--    bez para, i LEFT JOIN ga zadrzava sa NULL.
SELECT kupci.ime, porudzbine.id
FROM kupci
LEFT JOIN porudzbine
    ON kupci.id = porudzbine.kupac_id
    AND porudzbine.status = 'isporuceno';


-- 4b. POGRESNA verzija istog zadatka, ostavljena namerno.
--     WHERE radi POSLE sto je spoj napravljen: prvo nastanu
--     i prazni redovi, pa ih WHERE izbaci jer NULL nije
--     'isporuceno'. Rezultat: LEFT JOIN se ponasa kao INNER JOIN
--     i Vladimir i Tijana nestaju.
--     10 redova umesto 12.
SELECT kupci.ime, porudzbine.id
FROM kupci
LEFT JOIN porudzbine
    ON kupci.id = porudzbine.kupac_id
WHERE porudzbine.status = 'isporuceno';