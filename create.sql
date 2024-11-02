-- remove if there is a function to remove tables and sequences
DROP FUNCTION IF EXISTS remove_all();

-- create a function that removes tables and sequences
CREATE or replace FUNCTION remove_all() RETURNS void AS $$
DECLARE
    rec RECORD;
    cmd text;
BEGIN
    cmd := '';

    FOR rec IN SELECT
            'DROP SEQUENCE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace
        WHERE
            relkind = 'S' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    FOR rec IN SELECT
            'DROP TABLE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace WHERE relkind = 'r' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    EXECUTE cmd;
    RETURN;
END;
$$ LANGUAGE plpgsql;

select remove_all();


CREATE TABLE adresa (
    id_adresa SERIAL NOT NULL,
    mesto VARCHAR(256) NOT NULL,
    ulica VARCHAR(256),
    cislo_domu INTEGER NOT NULL,
    psc INTEGER
);
ALTER TABLE adresa ADD CONSTRAINT pk_adresa PRIMARY KEY (id_adresa);

CREATE TABLE fyzicka_osoba (
    id_profil INTEGER NOT NULL,
    meno VARCHAR(256) NOT NULL,
    priezvisko VARCHAR(256) NOT NULL,
    rodne_cislo INTEGER NOT NULL
);
ALTER TABLE fyzicka_osoba ADD CONSTRAINT pk_fyzicka_osoba PRIMARY KEY (id_profil);

CREATE TABLE najomca (
    id_profil INTEGER NOT NULL,
    domace_zviera VARCHAR(256)
);
ALTER TABLE najomca ADD CONSTRAINT pk_najomca PRIMARY KEY (id_profil);

CREATE TABLE nehnutelnost (
    id_nehnutelnost SERIAL NOT NULL,
    id_adresa INTEGER NOT NULL,
    id_typ_nehnutelnosti INTEGER NOT NULL,
    uzitkova_plocha INTEGER NOT NULL,
    cena INTEGER NOT NULL
);
ALTER TABLE nehnutelnost ADD CONSTRAINT pk_nehnutelnost PRIMARY KEY (id_nehnutelnost);

CREATE TABLE platba (
    datum DATE NOT NULL,
    id_nehnutelnost INTEGER NOT NULL,
    id_zmluva INTEGER NOT NULL,
    suma INTEGER NOT NULL
);
ALTER TABLE platba ADD CONSTRAINT pk_platba PRIMARY KEY (datum, id_nehnutelnost, id_zmluva);

CREATE TABLE pravnicka_osoba (
    id_profil INTEGER NOT NULL,
    nazov VARCHAR(256) NOT NULL,
    ico INTEGER NOT NULL
);
ALTER TABLE pravnicka_osoba ADD CONSTRAINT pk_pravnicka_osoba PRIMARY KEY (id_profil);

CREATE TABLE prenajimatel (
    id_profil INTEGER NOT NULL,
    narodnost VARCHAR(256)
);
ALTER TABLE prenajimatel ADD CONSTRAINT pk_prenajimatel PRIMARY KEY (id_profil);

CREATE TABLE prenajom (
    id_profil INTEGER NOT NULL,
    id_nehnutelnost INTEGER NOT NULL,
    prenajimatel_id_profil INTEGER NOT NULL,
    id_zmluva INTEGER NOT NULL
    CONSTRAINT ck_prenajom_ownership CHECK (id_profil != prenajimatel_id_profil)
);
ALTER TABLE prenajom ADD CONSTRAINT pk_prenajom PRIMARY KEY (id_profil, id_nehnutelnost, prenajimatel_id_profil, id_zmluva);

CREATE TABLE profil (
    id_profil SERIAL NOT NULL,
    email VARCHAR(256) NOT NULL,
    telefon VARCHAR(256)
);
ALTER TABLE profil ADD CONSTRAINT pk_profil PRIMARY KEY (id_profil);

CREATE TABLE typ_nehnutelnosti (
    id_typ_nehnutelnosti SERIAL NOT NULL,
    nazov VARCHAR(256) NOT NULL
);
ALTER TABLE typ_nehnutelnosti ADD CONSTRAINT pk_typ_nehnutelnosti PRIMARY KEY (id_typ_nehnutelnosti);

CREATE TABLE zmluva (
    id_zmluva SERIAL NOT NULL,
    od DATE NOT NULL,
    "do" DATE
);
ALTER TABLE zmluva ADD CONSTRAINT pk_zmluva PRIMARY KEY (id_zmluva);

CREATE TABLE prenajimatel_nehnutelnost (
    id_profil INTEGER NOT NULL,
    id_nehnutelnost INTEGER NOT NULL
);
ALTER TABLE prenajimatel_nehnutelnost ADD CONSTRAINT pk_prenajimatel_nehnutelnost PRIMARY KEY (id_profil, id_nehnutelnost);

ALTER TABLE fyzicka_osoba ADD CONSTRAINT fk_fyzicka_osoba_profil FOREIGN KEY (id_profil) REFERENCES profil (id_profil) ON DELETE CASCADE;

ALTER TABLE najomca ADD CONSTRAINT fk_najomca_profil FOREIGN KEY (id_profil) REFERENCES profil (id_profil) ON DELETE CASCADE;

ALTER TABLE nehnutelnost ADD CONSTRAINT fk_nehnutelnost_adresa FOREIGN KEY (id_adresa) REFERENCES adresa (id_adresa) ON DELETE CASCADE;
ALTER TABLE nehnutelnost ADD CONSTRAINT fk_nehnutelnost_typ_nehnutelnos FOREIGN KEY (id_typ_nehnutelnosti) REFERENCES typ_nehnutelnosti (id_typ_nehnutelnosti) ON DELETE CASCADE;

ALTER TABLE platba ADD CONSTRAINT fk_platba_nehnutelnost FOREIGN KEY (id_nehnutelnost) REFERENCES nehnutelnost (id_nehnutelnost) ON DELETE CASCADE;
ALTER TABLE platba ADD CONSTRAINT fk_platba_zmluva FOREIGN KEY (id_zmluva) REFERENCES zmluva (id_zmluva) ON DELETE CASCADE;

ALTER TABLE pravnicka_osoba ADD CONSTRAINT fk_pravnicka_osoba_profil FOREIGN KEY (id_profil) REFERENCES profil (id_profil) ON DELETE CASCADE;

ALTER TABLE prenajimatel ADD CONSTRAINT fk_prenajimatel_profil FOREIGN KEY (id_profil) REFERENCES profil (id_profil) ON DELETE CASCADE;

ALTER TABLE prenajom ADD CONSTRAINT fk_prenajom_najomca FOREIGN KEY (id_profil) REFERENCES najomca (id_profil) ON DELETE CASCADE;
ALTER TABLE prenajom ADD CONSTRAINT fk_prenajom_nehnutelnost FOREIGN KEY (id_nehnutelnost) REFERENCES nehnutelnost (id_nehnutelnost) ON DELETE CASCADE;
ALTER TABLE prenajom ADD CONSTRAINT fk_prenajom_prenajimatel FOREIGN KEY (prenajimatel_id_profil) REFERENCES prenajimatel (id_profil) ON DELETE CASCADE;
ALTER TABLE prenajom ADD CONSTRAINT fk_prenajom_zmluva FOREIGN KEY (id_zmluva) REFERENCES zmluva (id_zmluva) ON DELETE CASCADE;

ALTER TABLE prenajimatel_nehnutelnost ADD CONSTRAINT fk_prenajimatel_nehnutelnost_pr FOREIGN KEY (id_profil) REFERENCES prenajimatel (id_profil) ON DELETE CASCADE;
ALTER TABLE prenajimatel_nehnutelnost ADD CONSTRAINT fk_prenajimatel_nehnutelnost_ne FOREIGN KEY (id_nehnutelnost) REFERENCES nehnutelnost (id_nehnutelnost) ON DELETE CASCADE;





