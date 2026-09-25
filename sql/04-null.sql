-- =========================================
-- 04 - NULL
-- SQLBolt lekcija 8
-- 25.09.2026.
-- =========================================
--
-- NULL znaci "nepoznato", nije prazan tekst ni nula.
-- Poredjenje sa nepoznatim daje nepoznat rezultat,
-- a WHERE propusta samo ono sto je sigurno tacno.
-- Zato = NULL nikad ne radi, koristi se IS NULL.
--
-- Suvisan JOIN mnozi redove i tiho kvari brojeve.
-- Spajaj samo tabele iz kojih ti treba kolona.


-- Priprema: ubacene dve prazne vrednosti u bazu.
-- UPDATE porudzbine SET status = NULL WHERE id = 13;
-- UPDATE kupci SET grad = NULL WHERE id = 5;


-- 1. Porudzbine bez statusa. 1 red.
SELECT porudzbine.id, porudzbine.datum
FROM porudzbine
WHERE porudzbine.status IS NULL;


-- 2. Porudzbine koje nisu isporucene. 4 reda.
--    PAZNJA: ovo NE hvata porudzbinu 13, jer != ne vidi NULL.
SELECT porudzbine.id, porudzbine.status
FROM porudzbine
WHERE porudzbine.status != 'isporuceno';


-- 2b. Tacna verzija, hvata i porudzbinu bez statusa. 5 redova.
SELECT porudzbine.id, porudzbine.status
FROM porudzbine
WHERE porudzbine.status != 'isporuceno'
   OR porudzbine.status IS NULL;


-- 3. Kupci koji nemaju nijednu porudzbinu. 2 reda.
--    LEFT JOIN napravi prazan red, a IS NULL ga prepoznaje.
--    Ovo se zove anti-join i stalno se trazi na intervjuima.
SELECT kupci.ime, kupci.grad
FROM kupci
LEFT JOIN porudzbine
    ON kupci.id = porudzbine.kupac_id
WHERE porudzbine.kupac_id IS NULL;


-- 4. Svi kupci, prazan grad prikazan kao 'Nepoznato'.
--    COALESCE vraca prvu vrednost koja nije NULL.
--    Menja se SAMO prikaz, baza ostaje netaknuta.
--    AS daje kolonu citljivo ime u rezultatu.
SELECT kupci.ime, COALESCE(kupci.grad, 'Nepoznato') AS grad
FROM kupci;