-- ============================================================
-- 06 - Agregatne funkcije i GROUP BY (SQLBolt lekcija 10)
-- Baza: prodavnica
-- ============================================================

-- Dva pravila koja drze ceo fajl:
-- 1. Svaka kolona u SELECT-u mora biti ili unutar agregata ili u GROUP BY.
--    Inace baza ne zna koju vrednost iz grupe da prikaze i baca gresku.
-- 2. COUNT(*) broji REDOVE. COUNT(kolona) broji vrednosti koje nisu NULL.
--    Ta razlika je sustina zadatka 3.


-- 1. Ukupan broj proizvoda, prosecna cena, najniza i najvisa cena. Jedan red.
--
-- Za broj redova se koristi COUNT, nikad MAX(id).
-- MAX(id) vraca najveci id, sto se poklapa sa brojem redova samo dok
-- nijedan red nije obrisan i dok SERIAL nije preskocio broj.
-- Takav upit radi, ne prijavljuje gresku, i daje netacan rezultat.
SELECT
    COUNT(proizvodi.id) AS ukupan_broj_proizvoda,
    ROUND(AVG(cena), 2) AS prosecna_cena,
    MIN(cena) AS minimalna_cena,
    MAX(cena) AS maksimalna_cena
FROM proizvodi;


-- 2. Po kategoriji: broj proizvoda i prosecna cena. Sortirano po broju opadajuce.
-- 4 reda, koliko ima kategorija.
--
-- ORDER BY koristi alias broj_proizvoda, jer se ORDER BY izvrsava posle SELECT-a.
-- U WHERE isti alias ne bi radio.
SELECT
    kategorija,
    COUNT(*) AS broj_proizvoda,
    ROUND(AVG(cena), 2) AS prosecna_cena
FROM proizvodi
GROUP BY kategorija
ORDER BY broj_proizvoda DESC;


-- 3. Broj porudzbina po kupcu. Svi kupci, i oni bez porudzbina sa nulom.
-- 8 redova.
--
-- Dve zamke u jednom upitu:
--
-- a) LEFT JOIN, ne INNER. Vladimir i Tijana nemaju porudzbine.
--    INNER JOIN bi ih izbacio i vratio 6 redova.
--
-- b) COUNT(porudzbine.kupac_id), ne COUNT(*).
--    LEFT JOIN za Vladimira vraca jedan red u kom su sve kolone iz
--    porudzbine jednake NULL. Taj red fizicki postoji.
--    COUNT(*) bi ga izbrojao i dao 1 umesto 0.
--    COUNT(kolona) vidi NULL i preskace ga, pa daje 0.
--
-- Pazi i na ovo: bilo kakav WHERE nad kolonama desne tabele pretvara
-- LEFT JOIN u INNER JOIN, jer NULL ne prolazi nijedan uslov poredjenja.
-- Cak ni uslov koji izgleda uvek tacan, kao kolona = kolona,
-- jer NULL = NULL nije tacno nego je NULL.
--
-- GROUP BY ide po id-u, ne samo po imenu. Ime nije jedinstveno:
-- dva kupca sa istim imenom bi se spojila u jedan red sa zbirom porudzbina.
SELECT
    kupci.ime,
    COUNT(porudzbine.kupac_id) AS broj_porudzbina
FROM kupci
LEFT JOIN porudzbine
    ON kupci.id = porudzbine.kupac_id
GROUP BY kupci.id, kupci.ime
ORDER BY broj_porudzbina DESC;


-- 4. Po proizvodu: ukupna narucena kolicina i ukupna vrednost.
-- Samo proizvodi koji su bar jednom naruceni. Sortirano po vrednosti opadajuce.
--
-- INNER JOIN jer zadatak izostavlja nenarucene proizvode.
-- LEFT JOIN bi ih zadrzao sa NULL u oba zbira.
--
-- ON ide proizvodi.id = stavke_porudzbine.proizvod_id.
-- Procitaj taj ON naglas kao recenicu pre nego sto pustis upit.
-- Spajanje na pogresnu kolonu ne daje gresku, nego daje tacne brojeve
-- za pogresan odnos, i to je najopasnija vrsta greske u SQL-u.
SELECT
    proizvodi.naziv,
    SUM(stavke_porudzbine.kolicina) AS narucena_kolicina,
    SUM(stavke_porudzbine.kolicina * proizvodi.cena) AS ukupna_vrednost
FROM proizvodi
INNER JOIN stavke_porudzbine
    ON proizvodi.id = stavke_porudzbine.proizvod_id
GROUP BY proizvodi.id, proizvodi.naziv
ORDER BY ukupna_vrednost DESC;


-- 5. Broj porudzbina po statusu. 4 reda.
--
-- Cetvrti red je NULL, jer porudzbina 13 nema status.
-- GROUP BY ne koristi = za poredjenje. Da koristi, NULL se ne bi mogao
-- grupisati ni sa cim, jer NULL = NULL nije tacno.
-- GROUP BY i DISTINCT sve NULL-ove smatraju istom vrednoscu i stavljaju
-- ih u jednu grupu.
--
-- U pravom izvestaju ta NULL grupa je alarm, ne smetnja:
-- znaci da postoji porudzbina bez statusa, dakle ili bug u aplikaciji
-- ili nedostaje NOT NULL ogranicenje na koloni.
SELECT
    porudzbine.status,
    COUNT(*) AS broj_porudzbina
FROM porudzbine
GROUP BY porudzbine.status;


-- 5b. Isti podaci, ali jedan red sa fiksnim kolonama.
--
-- COUNT(*) FILTER (WHERE ...) broji samo redove koji zadovoljavaju uslov.
-- Standardni SQL i PostgreSQL ga podrzavaju, MySQL i SQL Server ne.
-- Tamo se isto radi preko CASE WHEN unutar agregata.
--
-- PAZI, ovaj upit je namerno ostavljen nepotpun kao primer greske:
-- saberi tri broja i dobices 14, a u tabeli ima 15 porudzbina.
-- Porudzbina 13 je nestala jer joj je status NULL, a status = 'u obradi'
-- za NULL nije ni tacno ni netacno, nego je NULL, pa red ne ulazi
-- ni u jedan filter. Nigde se ne vidi da je ispao.
--
-- Pravilo: rucno nabrajanje vrednosti pokazuje samo ono sto si ocekivao
-- da u podacima postoji. GROUP BY pokazuje ono sto stvarno postoji.
-- Prvo pusti GROUP BY da vidis koje vrednosti ima, pa onda pisi filtere.
--
-- Navika koja ovo hvata svaki put: saberi delove i uporedi sa celinom.
-- Zbir po kategorijama mora da bude jednak COUNT(*) cele tabele.
-- Ista provera hvata i greske u JOIN-u i greske u WHERE-u.
SELECT
    COUNT(*) FILTER (WHERE status = 'u obradi')   AS u_obradi,
    COUNT(*) FILTER (WHERE status = 'isporuceno') AS isporuceno,
    COUNT(*) FILTER (WHERE status = 'otkazano')   AS otkazano
FROM porudzbine;