-- ============================================================
-- 05 - Izrazi u SELECT-u (SQLBolt lekcija 9)
-- Baza: prodavnica
-- ============================================================

-- Pravilo za ceo fajl: svaka kolona koja nije obicna kolona iz tabele
-- (dakle svaki izracunati izraz) mora da dobije AS i citljivo ime.
-- Bez AS-a PostgreSQL kolonu nazove ?column? ili po funkciji (round, coalesce).


-- 1. Naziv, cena i cena sa PDV-om, zaokruzena na 2 decimale.
-- ROUND(izraz, 2) - drugi argument je broj decimala.
SELECT
    naziv,
    cena,
    ROUND(cena * 1.2, 2) AS cena_sa_pdv
FROM proizvodi;


-- 2. Za svaku stavku: naziv proizvoda, kolicina, cena i vrednost stavke.
-- Sortirano od najvece vrednosti.
--
-- Osnovna tabela je stavke_porudzbine, jer zadatak kaze "za svaku stavku".
-- Pravilo: tabela iz koje krecem je ona o kojoj zadatak govori.
--
-- Kad u upitu postoje dve tabele, svaka kolona dobija prefiks tabela.kolona,
-- cak i kad se imena ne poklapaju. Bez prefiksa se ne vidi odakle sta dolazi.
--
-- ORDER BY koristi alias vrednost_stavke, ne ponovljenu formulu.
-- Razlog je redosled izvrsavanja: FROM -> WHERE -> SELECT -> ORDER BY.
-- ORDER BY ide POSLE SELECT-a, pa alias u tom trenutku vec postoji.
SELECT
    proizvodi.naziv,
    stavke_porudzbine.kolicina,
    proizvodi.cena,
    proizvodi.cena * stavke_porudzbine.kolicina AS vrednost_stavke
FROM stavke_porudzbine
LEFT JOIN proizvodi
    ON proizvodi.id = stavke_porudzbine.proizvod_id
ORDER BY vrednost_stavke DESC;
-- Napomena: ovde LEFT i INNER JOIN daju isto, jer strani kljuc garantuje
-- da svaka stavka pokazuje na postojeci proizvod. LEFT je samo bezbednija navika.


-- 3. Ime kupca, datum registracije i broj dana od registracije.
-- Oduzimanje dva datuma u PostgreSQL-u vraca ceo broj dana.
SELECT
    ime,
    datum_registracije,
    CURRENT_DATE - datum_registracije AS dana_od_registracije
FROM kupci;


-- 4. Naziv i cena sa PDV-om, samo gde je cena sa PDV-om veca od 20000.
--
-- Formula se MORA ponoviti u WHERE-u. Alias cena_sa_pdv tu ne radi.
-- Razlog je isti redosled kao gore: WHERE se izvrsava PRE SELECT-a,
-- pa u trenutku filtriranja alias jos ne postoji.
--
-- Zapamti par: alias ne radi u WHERE, radi u ORDER BY.
SELECT
    naziv,
    cena * 1.2 AS cena_sa_pdv
FROM proizvodi
WHERE cena * 1.2 > 20000;


-- 5. Jedna kolona u formatu "Marko Petrovic (Novi Sad)".
--
-- || je operator za spajanje teksta (konkatenacija).
--
-- Zamka: kupac sa id = 5 ima grad = NULL.
-- Opste pravilo: bilo sta spojeno sa NULL daje NULL.
-- Vazi i za tekst i za brojeve: NULL + 5 je NULL, NULL * 0 je NULL.
-- NULL nije prazan string i nije nula, nego "ne zna se",
-- pa i ceo rezultat postaje "ne zna se".
--
-- COALESCE(kolona, zamena) vraca prvu vrednost koja nije NULL.
-- Ne menja podatak u bazi, samo prikaz.
SELECT
    ime || ' (' || COALESCE(grad, 'Nepoznato') || ')' AS kupac
FROM kupci;