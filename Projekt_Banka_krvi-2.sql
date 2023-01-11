DROP DATABASE IF EXISTS baza_banke_krvi;
CREATE DATABASE baza_banke_krvi;
USE baza_banke_krvi;

CREATE TABLE banka_krvi (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    adresa VARCHAR(50) NOT NULL,
    grad VARCHAR(20) NOT NULL,
    kontakt VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE bolnica (
	id INTEGER PRIMARY KEY AUTO_INCREMENT, 
    naziv VARCHAR(50) NOT NULL,
    adresa VARCHAR(50) NOT NULL,
    grad VARCHAR(20) NOT NULL,
    kontakt VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    zaliha_krvne_grupe_A_poz DECIMAL(5,2) NOT NULL DEFAULT 100.00, 
    zaliha_krvne_grupe_A_neg DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    zaliha_krvne_grupe_B_poz DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    zaliha_krvne_grupe_B_neg DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    zaliha_krvne_grupe_AB_poz DECIMAL(5,2) NOT NULL DEFAULT 100.00, 
    zaliha_krvne_grupe_AB_neg DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    zaliha_krvne_grupe_0_poz DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    zaliha_krvne_grupe_0_neg DECIMAL(5,2) NOT NULL DEFAULT 100.00
);

CREATE TABLE pacijent (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(15) NOT NULL,
    prezime VARCHAR(20) NOT NULL,
    OIB CHAR(11) NOT NULL UNIQUE,
    spol CHAR(1) NOT NULL,
    datum_rodenja DATE NOT NULL,
	adresa VARCHAR(50) NOT NULL,
    grad VARCHAR(20) NOT NULL,
    kontakt VARCHAR(15) NOT NULL UNIQUE,
    krvna_grupa VARCHAR(3) NOT NULL,
    CONSTRAINT c1_kriv_oib_p CHECK(LENGTH(OIB) = 11),
    CONSTRAINT c2_spol_p CHECK(spol = 'Ž' OR spol = 'M'),
    CONSTRAINT c3_odabir_krvi CHECK(krvna_grupa = "+A" OR krvna_grupa = "-A" OR 
		   krvna_grupa = "+B" OR krvna_grupa = "-B" OR 
           krvna_grupa = "+AB" OR krvna_grupa = "-AB" OR 
           krvna_grupa = "+0" OR krvna_grupa = "-0")
);

CREATE TABLE zaposlenik (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(15) NOT NULL,
    prezime VARCHAR(20) NOT NULL,
    datum_rodenja DATE NOT NULL,
	adresa VARCHAR(50) NOT NULL,
    grad VARCHAR(20) NOT NULL,
    kontakt VARCHAR(15) NOT NULL UNIQUE,
	email VARCHAR(50) NOT NULL UNIQUE, 
    datum_zaposlenja DATE
);

CREATE TABLE pacijent_u_bolnici (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_pacijent INTEGER NOT NULL,
    id_bolnica INTEGER NOT NULL,
    datum_primanja DATE NOT NULL,
    odjel VARCHAR(50) NOT NULL, 
    soba INTEGER NOT NULL,
    opis VARCHAR(300) NOT NULL,
    kolicina DECIMAL(3,2) NOT NULL,
    FOREIGN KEY (id_pacijent) REFERENCES pacijent(id),
    FOREIGN KEY (id_bolnica) REFERENCES bolnica(id)
);

CREATE TABLE kriterij (
	id INTEGER PRIMARY KEY AUTO_INCREMENT, 
    min_dob INTEGER NOT NULL,
    max_dob INTEGER NOT NULL,
    min_tjelesna_tezina DECIMAL(4,1) NOT NULL,
    max_tjelesna_tezina DECIMAL(4,1) NOT NULL,
    min_tjelesna_temperatura DECIMAL(3,1) NOT NULL,
    max_tjelesna_temperatura DECIMAL(3,1) NOT NULL,
    min_sistolicki_krvni_tlak INTEGER NOT NULL,
	max_sistolicki_krvni_tlak INTEGER NOT NULL,
    min_dijastolicki_krvni_tlak INTEGER NOT NULL,
	max_dijastolicki_krvni_tlak INTEGER NOT NULL,
    min_puls INTEGER NOT NULL,
    max_puls INTEGER NOT NULL,
    min_hemoglobin INTEGER NOT NULL,
    max_hemoglobin INTEGER NOT NULL,
    datum_posljednjeg_darivanja datetime
);

CREATE TABLE darivatelj (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_kriterij INTEGER NOT NULL,
    ime VARCHAR(15) NOT NULL,
    prezime VARCHAR(20) NOT NULL,
    OIB CHAR(11) NOT NULL UNIQUE,
    spol CHAR(1) NOT NULL,
    datum_rodenja DATE NOT NULL,
	adresa VARCHAR(50) NOT NULL,
    grad VARCHAR(20) NOT NULL,
    kontakt VARCHAR(15) NOT NULL UNIQUE,
    krvna_grupa VARCHAR(3) NOT NULL,
    dob INTEGER NOT NULL,
    tjelesna_tezina DECIMAL(4,1) NOT NULL,
    tjelesna_temperatura DECIMAL(3,1) NOT NULL,
    sistolicki_krvni_tlak INTEGER NOT NULL,
    dijastolicki_krvni_tlak INTEGER NOT NULL,
    puls INTEGER NOT NULL,
    hemoglobin DECIMAL(5,2) NOT NULL,
    CONSTRAINT FK_darivatelj_kriterij FOREIGN KEY (id_kriterij) REFERENCES kriterij(id),
    CONSTRAINT c1_kriv_oib_d CHECK(LENGTH(OIB) = 11),
    CONSTRAINT c2_spol_d CHECK(spol = 'Ž' OR spol = 'M'),
    CONSTRAINT c3_odabir_krv_gr CHECK(krvna_grupa = "+A" OR krvna_grupa = "-A" OR 
		   krvna_grupa = "+B" OR krvna_grupa = "-B" OR 
           krvna_grupa = "+AB" OR krvna_grupa = "-AB" OR 
           krvna_grupa = "+0" OR krvna_grupa = "-0")
);

CREATE TABLE prijevoznik (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime_prijevoznika VARCHAR(50) NOT NULL,
    kontakt VARCHAR(15) NOT NULL UNIQUE,
    tip_vozila VARCHAR(20) NOT NULL,
    registarska_oznaka VARCHAR(9) NOT NULL UNIQUE
);

CREATE TABLE zahtjev (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_prijevoznik INTEGER NOT NULL DEFAULT 1,
    id_banka_krvi INTEGER NOT NULL DEFAULT 1,
    id_bolnica INTEGER NOT NULL,
    krvna_grupa VARCHAR(3) NOT NULL,
    kolicina DECIMAL(5,2) NOT NULL, 
    datum_podnesenja TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    status_zahtjeva VARCHAR(15) NOT NULL DEFAULT 'U tijeku',
    CONSTRAINT FK_zahtjev_prijevoznik FOREIGN KEY (id_prijevoznik) REFERENCES prijevoznik(id) ON DELETE CASCADE,
	CONSTRAINT FK_zahtjev_banka_krvi FOREIGN KEY (id_banka_krvi) REFERENCES banka_krvi(id),
    CONSTRAINT FK_zahtjev_bolnica FOREIGN KEY (id_bolnica) REFERENCES bolnica(id),
    CHECK(status_zahtjeva = 'Zaprimljen' OR status_zahtjeva = 'U tijeku' OR status_zahtjeva = 'Odbijen')
);

CREATE TABLE zalihe (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_banka_krvi INTEGER NOT NULL,
    krvna_grupa VARCHAR(3),
    kolicina DECIMAL(6,2) NOT NULL,
    CONSTRAINT FK_zalihe_banke_krvi FOREIGN KEY (id_banka_krvi) REFERENCES banka_krvi(id)
);

CREATE TABLE termin (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_zalihe INTEGER NOT NULL,
    id_zaposlenik INTEGER NOT NULL,
    id_darivatelj INTEGER NOT NULL,
    datum_i_vrijeme TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    kolicina DECIMAL(3,2) DEFAULT 0.45,	 
    CONSTRAINT FK_termin_zalihe FOREIGN KEY (id_zalihe) REFERENCES zalihe(id),
	CONSTRAINT FK_termin_zaposlenik FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id) ON DELETE CASCADE,
    CONSTRAINT FK_termin_darivatelj FOREIGN KEY (id_darivatelj) REFERENCES darivatelj(id) ON DELETE CASCADE
);

INSERT INTO banka_krvi (naziv, adresa, grad, kontakt, email) VALUES ( 'Banka krvi Pula', 'Zagrebačka 30', 'Pula', '052-356-000', 'bankakrvi@ob-pula.hr');

INSERT INTO bolnica VALUES (1, 'Opća bolnica "Dr. Ivo Pedišić"', 'J.J. Strossmayera 59','Sisak', '044-530-000', 'obs@obs.hr', 530, 40, 220, 110, 140, 100, 190, 150),
                           (2, 'Opća bolnica Bjelovar', 'Mihanovićeva 8', 'Bjelovar', '043-279-222', 'ravnateljstvo@obbj.hr', 210, 330, 50, 110, 165, 100, 245, 142),
						   (3, 'Opća županijska bolnica Vinkovci', 'Zvonarska 57', 'Vinkovci', '032-349-349', 'opca.bolnica.vinkovci@vu.t-com.hr', 120, 330, 220, 110, 65, 100, 241, 423),
					       (4, 'Opća bolnica Virovitica', 'Ljudevita Gaja 21', 'Virovitica', '033-747-444', 'ravnateljstvo@bolnica-virovitica.hr', 200, 330, 220, 110, 651, 100, 455, 532),
						   (5, 'Opća bolnica Zadar', 'Bože Peričića 5', 'Zadar', '023-505-505', 'opca.bolnica.zadar@zd.t-com.hr', 400, 330, 220, 110, 52, 168, 255, 216),
						   (6, 'Opća bolnica Zabok', 'Bračak 8', 'Zabok', '049-204-000', 'informacije@bolnica-zabok.hr', 221, 302, 220, 110, 652, 100, 425, 22),
						   (7, 'Opća bolnica "Dr. Josip Benčević"', 'Andrije Štampara 42','Slavonski Brod', '035-201-201', 'opca-bolnica-sb@sb.t-com.hr', 200, 330, 220, 110, 223, 100, 23, 702),
						   (8, 'Opća bolnica Gospić', 'Kaniška 111', 'Gospić', '053-572-433', 'ured.ravnatelja@obgospic.hr', 210, 74, 220, 110, 165, 100, 451, 722),
						   (9, 'Opća bolnica Našice', 'Bana Jelačića 10', 'Našice', '031-488-511', 'bolnica@obnasice.hr', 321, 330, 220, 110, 65, 100, 45, 72),
						   (10, 'Opća bolnica Šibensko-kninske županije', 'Stjepana Radića 83', 'Šibenik', '022-641-900', 'opca-bolnica-sibenik3@si.t-com.hr', 33, 213, 224, 110, 605, 100, 154, 724),
						   (11, 'Opća bolnica "Dr. Tomislav Bardek"', 'Željka Selingera bb', 'Koprivnica', '048-251-000', 'uprava@obkoprivnica.hr', 321, 241, 115, 110, 350, 100, 450, 756),
                           (12, 'Opća bolnica "Hrvatski ponos"', 'Svetoslava Suronje 12', 'Knin', '022-641-111', 'bolnica@obhpknin.hr', 380, 336, 220, 116, 152, 178, 254, 111),
                           (13, 'Opća bolnica Dubrovnik', 'Roka Mišetića 2', 'Dubrovnik', '020-431-777', 'uprava@bolnica-du.hr', 304, 120, 110, 110, 27, 541, 214, 886),
                           (14, 'Opća bolnica Karlovac', 'Andrije Štampara 3', 'Karlovac', '047-608-100', 'ravnateljstvo@bolnica-karlovac.hr', 354, 356, 222, 235, 651, 111, 112, 712),
                           (15, 'Opća bolnica Ogulin', 'Bolnička 38', 'Ogulin', '047-819-700', 'info@bolnica-ogulin.hr', 172, 359, 400, 330, 220, 110, 110, 350),
						   (16, 'Opća bolnica Varaždin', 'I. Meštrovića bb', 'Varaždin', '042-393-000', 'bolnica@obv.hr', 154, 112, 104, 110, 103, 100, 104, 105),
						   (17, 'Županijska bolnica Čakovec', 'I. G. Kovačića 1E', 'Čakovec', '040-375-444', 'bolnica@ck.t-com.hr', 355, 332, 250, 110, 165, 156, 145, 156),
                           (18, 'Opća županijska bolnica Vukovar', 'Županijska 35', 'Vukovar', '032-452-111', 'posta@ob-vukovar.hr', 85, 400, 356, 222, 235, 651, 154, 546),
                           (19, 'Opća županijska bolnica Požega', 'Osječka 107', 'Požega', '034-254-555', 'info@pozeska-bolnica.hr', 380, 334, 225, 112, 152, 100, 342, 272),
                           (20, 'Opća bolnica Pula', 'Aldo Negri 6','Pula', '052-376-500', 'obpula@obpula.hr', 400, 330, 220, 510, 140, 105, 190, 150);

INSERT INTO pacijent VALUES (1, 'Ana', 'Bibić', '12345678901', 'Ž', STR_TO_DATE('01.10.1995.', '%d.%m.%Y.'), 'Ul. Mirka Miočića 23', 'Zagreb', '099-283-5489', '+A'),
							(2, 'Mario', 'Bernobić', '12345678902', 'M', STR_TO_DATE('11.11.1985.', '%d.%m.%Y.'), 'Zagrebačka ul. 16', 'Bjelovar', '098-281-1189', '-A'),
                            (3, 'Gordon', 'Gregorić', '12345678903', 'M', STR_TO_DATE('09.02.1987.', '%d.%m.%Y.'), 'Osječka ul. 24', 'Ogulin', '099-125-2869', '-0'),
                            (4, 'Ančica', 'Jošković', '12345678904', 'Ž', STR_TO_DATE('12.07.1999.', '%d.%m.%Y.'), 'Pulska ul. 16', 'Karlovac', '091-345-5459', '-B'),
                            (5, 'Marin', 'Marić', '12345678905', 'M', STR_TO_DATE('25.04.1995.', '%d.%m.%Y.'), 'Mirna ul. 165', 'Pula', '099-258-1221', '+B'),
                            (6, 'Mario', 'Bernobić', '12345678906', 'M', STR_TO_DATE('10.05.2002.', '%d.%m.%Y.'), 'Berislavićeva ulica 3', 'Čakovec', '099-255-1558', '+A'),
                            (7, 'Emanuela', 'Jurić', '12345678907', 'Ž', STR_TO_DATE('25.07.1998.', '%d.%m.%Y.'), 'Draškovićeva ulica 13', 'Rijeka', '098-885-1452', '+A'),
                            (8, 'Ivan', 'Horvat', '12345678908', 'M', STR_TO_DATE('05.08.1999.', '%d.%m.%Y.'), 'Đorđićeva ulica 23', 'Čakovec', '091-225-5861', '-A'),
                            (9, 'Erik', 'Brekalo', '12345678909', 'M', STR_TO_DATE('18.12.1975.', '%d.%m.%Y.'), 'Latinska ul. 45', 'Našice', '099-366-2546', '+A'),
                            (10, 'Manda', 'Modrić', '12345678910', 'Ž', STR_TO_DATE('08.09.1985.', '%d.%m.%Y.'), 'Zadarska ul. 13', 'Našice', '098-545-5693', '-B'),
                            (11, 'Ana', 'Glavan', '12345678911', 'Ž', STR_TO_DATE('29.08.1987.', '%d.%m.%Y.'), 'Đorđićeva ulica 123', 'Split', '099-235-5263', '-0'),
                            (12, 'Luka', 'Orbanić', '12345678912', 'M', STR_TO_DATE('07.07.1989.', '%d.%m.%Y.'), 'Vlaška ulica 2', 'Bjelovar', '099-585-4625', '+A'),
                            (13, 'Patrik', 'Smoljan', '12345678913', 'M', STR_TO_DATE('10.06.1995.', '%d.%m.%Y.'), 'Zagrebačka ul. 12', 'Rovinj', '099-222-5589', '-AB'),
                            (14, 'Ljubica', 'Pavlić', '12345678914', 'Ž', STR_TO_DATE('10.07.1968.', '%d.%m.%Y.'), 'Varšavska ulica 23', 'Bjelovar', '099-265-5861', '-A'),
                            (15, 'Damir', 'Čop', '12345678915', 'M', STR_TO_DATE('01.01.1995.', '%d.%m.%Y.'), 'Zagrebačka ul. 123', 'Bjelovar', '099-359-2927', '-B'),
                            (16, 'Pavao', 'Pavlić', '12345678916', 'M', STR_TO_DATE('25.09.1989.', '%d.%m.%Y.'), 'Fišerova ulica 43', 'Vinkovci', '099-186-5978', '+0'),
                            (17, 'Antonela', 'Grbić', '12345678917', 'Ž', STR_TO_DATE('18.08.1987', '%d.%m.%Y.'), 'Zagrebačka ul. 2', 'Vinkovci', '099-528-2695', '+AB'),
                            (18, 'Ivana', 'Meštrović', '12345678918', 'Ž', STR_TO_DATE('25.02.1976.', '%d.%m.%Y.'), 'Ulica Marka Stančića 5', 'Našice', '099-215-548', '+AB'),
                            (19, 'Deni', 'Starčević', '12345678919', 'M', STR_TO_DATE('09.04.1986.', '%d.%m.%Y.'), 'Frankopanska ulica 3', 'Rijeka', '099-263-585', '+B'),
                            (20, 'Maja', 'Petrović', '12345678920', 'Ž', STR_TO_DATE('01.11.1983.', '%d.%m.%Y.'), 'Ulica neznane junakinje 6', 'Rovinj', '098-256-9543', '+A'),
                            (21, 'Petar', 'Ivšić', '12345678921', 'M', STR_TO_DATE('29.03.1978.', '%d.%m.%Y.'), 'Gajeva ulica 11', 'Bjelovar', '099-248-7233', '+A'),
                            (22, 'Sanja', 'Belošević', '12345678922', 'Ž', STR_TO_DATE('30.08.1974.', '%d.%m.%Y.'), 'Ulica Milana Makanca 6', 'Gospić', '098-253-8123', '+B'),
                            (23, 'Deni', 'Kaić', '12345678923', 'M', STR_TO_DATE('30.05.1989.', '%d.%m.%Y.'), 'Ulica kraljice Jelene 4', 'Bjelovar', '091-845-8313', '+AB'),
                            (24, 'Moreno', 'Katić', '12345678924', 'M', STR_TO_DATE('29.07.1972.', '%d.%m.%Y.'), 'Ulica kneza Branimira 3', 'Našice', '091-253-558', '+0'),
                            (25, 'Maria', 'Kovač', '12345678925', 'Ž', STR_TO_DATE('18.10.1962.', '%d.%m.%Y.'), 'Ulica Jurja Plemića 2', 'Rovinj', '099-646-535', '-0'),
                            (26, 'Marija', 'Jelić', '12345678926', 'Ž', STR_TO_DATE('28.07.1969.', '%d.%m.%Y.'), 'Ulica Josipa Runjanina 1', 'Bjelovar', '091-475-5861', '-0'),
                            (27, 'Sebastian', 'Slunjski', '12345678927', 'M', STR_TO_DATE('06.06.1966.', '%d.%m.%Y.'), 'Gundulićeva ulica 45', 'Bjelovar', '091-866-8465', '+0'),
                            (28, 'Diego', 'Krizman', '12345678928', 'M', STR_TO_DATE('24.04.1958.', '%d.%m.%Y.'), 'Ulica Ivana Lepušića 67', 'Bjelovar', '091-585-7231', '+A'),
                            (29, 'Aleksandra', 'Bunić', '12345678929', 'Ž', STR_TO_DATE('23.12.1979.', '%d.%m.%Y.'), 'Ulica Hrvoja Vukčića 43', 'Varaždin', '099-862-5812', '+A'),
                            (30, 'Sandra', 'Tokić', '12345678930', 'Ž', STR_TO_DATE('10.08.1975.', '%d.%m.%Y.'), 'Ulica Grgura Ninskog 32', 'Bjelovar', '091-852-5546', '+B'),
                            (31, 'Eva', 'Čilić', '12345678931', 'Ž', STR_TO_DATE('18.11.1999.', '%d.%m.%Y.'), 'Gundulićeva ulica 32', 'Varaždin', '099-643-831', '-B'),
                            (32, 'Josip', 'Marinović', '12345678932', 'M', STR_TO_DATE('11.10.1959.', '%d.%m.%Y.'), 'Zagrebačka ul. 56', 'Vinkovci', '091-486-5669', '-B'),
                            (33, 'Luka', 'Miloslavić', '12345678933', 'M', STR_TO_DATE('27.11.1959.', '%d.%m.%Y.'), 'Trg Ante Starčevića 32', 'Bjelovar', '091-7227-500', '-A'),
                            (34, 'Branko', 'Vranković', '12345678934', 'M', STR_TO_DATE('18.10.1960.', '%d.%m.%Y.'), 'Ulica Antuna Bauera 34', 'Bjelovar', '099-556-540', '-A'),
                            (35, 'Lana', 'Šebalj', '12345678935', 'Ž', STR_TO_DATE('15.01.1982.', '%d.%m.%Y.'), 'Zagrebačka ul. 1', 'Bjelovar', '091-285-4594', '-A'),
                            (36, 'Marin', 'Filipović', '12345678936', 'M', STR_TO_DATE('11.09.1978.', '%d.%m.%Y.'), 'Haulikova ulica 4', 'Bjelovar', '098-256-7884', '+0'),
                            (37, 'Andrea', 'Novak', '12345678937', 'M', STR_TO_DATE('09.03.1974.', '%d.%m.%Y.'), 'Ulica baruna Trenka 3', 'Bjelovar', '098-548-5853', '+A'),
                            (38, 'Jelena', 'Dadić', '12345678938', 'Ž', STR_TO_DATE('03.03.1995.', '%d.%m.%Y.'), 'Prolaz sestara Baković 6', 'Bjelovar', '091-565-8546', '+B'),
                            (39, 'Borna', 'Despot', '12345678939', 'Ž', STR_TO_DATE('15.09.1972.', '%d.%m.%Y.'), 'Šenoina ulica 8', 'Vukovar', '099-512-8623', '+AB'),
                            (40, 'Zrinka', 'Gladina', '12345678940', 'Ž', STR_TO_DATE('16.07.1994.', '%d.%m.%Y.'), 'Jukićeva ulica 9', 'Vukovar', '091-222-1111', '+AB'),
                            (41, 'Vedran', 'Žuvela', '12345678941', 'M', STR_TO_DATE('27.05.1992.', '%d.%m.%Y.'), 'Trg bana Josipa Jelačića 456', 'Vinkovci', '091-101-2002', '+0'),
                            (42, 'Dražen', 'Dudan', '12345678942', 'M', STR_TO_DATE('14.10.1989.', '%d.%m.%Y.'), 'Trg Eugena Kvaternika 43', 'Bjelovar', '099-648-5626', '+0'),
                            (43, 'Maro', 'Dražeta', '12345678943', 'M', STR_TO_DATE('27.05.1992.', '%d.%m.%Y.'), 'Ulica Đure Crnatka 24', 'Osijek', '099-843-2866', '+A'),
                            (44, 'Katarina', 'Čelan', '12345678944', 'Ž', STR_TO_DATE('19.07.1967.', '%d.%m.%Y.'), 'Ulica Frane Bulića 24', 'Bjelovar', '099-845-7526', '+B'),
                            (45, 'Lea', 'Leko', '12345678945', 'Ž', STR_TO_DATE('04.01.1958.', '%d.%m.%Y.'), 'Preradovićeva ulica 1', 'Vinkovci', '099-100-8782', '-B'),
                            (46, 'Dominik', 'Krajina', '12345678946', 'M', STR_TO_DATE('16.10.1963.', '%d.%m.%Y.'), 'Praška ulica 32', 'Šibenik', '099-526-8231', '-B'),
                            (47, 'Mare', 'Bužančić', '12345678947', 'Ž', STR_TO_DATE('09.08.1980.', '%d.%m.%Y.'), 'Jurišićeva ulica 4', 'Varaždin', '099-295-6549', '+A'),
                            (48, 'Tarik', 'Cindro', '12345678948', 'M', STR_TO_DATE('19.12.1989.', '%d.%m.%Y.'), 'Pierottijeva ulica 8', 'Osijek', '098-253-5452', '-B'),
                            (49, 'Gordan', 'Tomić', '12345678949', 'M', STR_TO_DATE('17.02.1963.', '%d.%m.%Y.'), 'Petrinjska ulica 87', 'Zagreb', '099-586-2334', '-B'),
                            (50, 'Goran', 'Terzić', '12345678950', 'M', STR_TO_DATE('18.12.1974.', '%d.%m.%Y.'), 'Park 100. brigade Hrvatske vojske 54', 'Sesvete', '097-756-5852', '+A'),
                            (51, 'Anja', 'Tudorić', '12345678952', 'Ž', STR_TO_DATE('05.05.1969.', '%d.%m.%Y.'), 'Palmotićeva ulica 3', 'Šibenik', '099-002-999', '-0'),
                            (52, 'Etsther', 'Zlatarić', '12345678953', 'Ž', STR_TO_DATE('28.08.1978.', '%d.%m.%Y.'), 'Mrazovićeva ulica 5', 'Šibenik', '099-888-5353', '-A'),
                            (53, 'Stella', 'Šarić', '12345678954', 'Ž', STR_TO_DATE('19.07.1956.', '%d.%m.%Y.'), 'Obrtnički prolaz 24', 'Vinkovci', '099-869-136', '-B'),
                            (54, 'Marinko', 'Mornar', '12345678955', 'M', STR_TO_DATE('06.04.1965.', '%d.%m.%Y.'), 'Kačićeva ulica 1', 'Split', '099-288-5462', '+A'),
                            (55, 'Sara', 'Brozović', '12345678956', 'Ž', STR_TO_DATE('28.05.1977.', '%d.%m.%Y.'), 'Mihanovićeva ulica 3', 'Bjelovar', '099-287-7892', '+0'),
                            (56, 'Dominik', 'Erceg', '12345678957', 'M', STR_TO_DATE('01.10.1995.', '%d.%m.%Y.'), 'Medulićeva ulica 13', 'Osijek', '099-280-7923', '+0'),
                            (57, 'Domagoj', 'Buljan', '12345678958', 'M', STR_TO_DATE('08.08.1998.', '%d.%m.%Y.'), 'Masarykova ulica 57', 'Šibenik', '099-288-5963', '+AB'),
                            (58, 'Danilo', 'Ilić', '12345678959', 'M', STR_TO_DATE('17.01.1980.', '%d.%m.%Y.'), 'Martićeva ulica 32', 'Šibenik', '099-281-8626', '-AB'),
                            (59, 'Mislav', 'Kurtović', '12345678960', 'M', STR_TO_DATE('01.12.1967.', '%d.%m.%Y.'), 'Katančićeva ulica 21', 'Vinkovci', '099-823-5555', '-B'),
                            (60, 'Tanja', 'Bernobić', '12345678961', 'Ž', STR_TO_DATE('21.08.1968.', '%d.%m.%Y.'), 'Marićev prolaz 27', 'Čakovec', '099-312-8449', '-A'),
                            (61, 'Ivo', 'Kovačić', '12345678962', 'M', STR_TO_DATE('11.11.1991.', '%d.%m.%Y.'), 'Margaretska ulica 25', 'Split', '099-862-5545', '+A'),
                            (62, 'Melani', 'Lozančić', '12345678963', 'Ž', STR_TO_DATE('09.07.1993.', '%d.%m.%Y.'), 'Krajiška ulica 3', 'Rijeka', '099-258-5599', '-A'),
                            (63, 'Tea', 'Lovrić', '12345678964', 'Ž', STR_TO_DATE('27.05.1974.', '%d.%m.%Y.'), 'Rovinjska ulica 34', 'Osijek', '099-454-5565', '+AB'),
                            (64, 'Marko', 'Benja', '12345678965', 'M', STR_TO_DATE('29.06.1978.', '%d.%m.%Y.'), 'Kordunska ulica 123', 'Vinkovci', '099-333-7070', '+AB');


INSERT INTO zaposlenik VALUES (1, 'Endi', 'Horvat', STR_TO_DATE('01.10.1995.', '%d.%m.%Y.'), 'Ul. Matije Vlačića 28', 'Poreč', '099-589-7895', 'ehorvat@ob-pula', STR_TO_DATE('21.08.2019.', '%d.%m.%Y.')),
							  (2, 'Irena', 'Bernobić', STR_TO_DATE('01.10.1980.', '%d.%m.%Y.'), 'Augustov prolaz 7', 'Pula', '099-551-263', 'ibernobic@ob-pula', STR_TO_DATE('06.08.2004.', '%d.%m.%Y.')),
                              (3, 'Gordon', 'Grdinić', STR_TO_DATE('01.12.1967.', '%d.%m.%Y.'), 'Akvilejski prilaz 4', 'Pula', '099-579-255', 'ggrdinic@ob-pula', STR_TO_DATE('01.01.1990.', '%d.%m.%Y.')),
                              (4, 'Lara', 'Jošković', STR_TO_DATE('01.12.1990.', '%d.%m.%Y.'), 'Istarska ul. 16', 'Pula', '091-345-5459', 'ljoskovic@ob-pula', STR_TO_DATE('12.04.2013.', '%d.%m.%Y.')),
                              (5, 'Henri', 'Milokanović', STR_TO_DATE('07.12.1995.', '%d.%m.%Y.'), 'Porečka ul. 13', 'Poreč', '099-356-7895', 'hmilokanovic@ob-pula', STR_TO_DATE('12.04.2013.', '%d.%m.%Y.')),
							  (6, 'Melita', 'Lakošeljac', STR_TO_DATE('01.10.1985.', '%d.%m.%Y.'), 'Prilaz Kralja Salomona 3', 'Umag', '091-154-185', 'mlakoseljac@ob-pula', STR_TO_DATE('06.08.2010.', '%d.%m.%Y.')),
                              (7, 'Ines', 'Končar', STR_TO_DATE('01.12.1989.', '%d.%m.%Y.'), 'Murinska ulica 38', 'Umag', '091-547-5624', 'ikoncar@ob-pula', STR_TO_DATE('01.01.2012.', '%d.%m.%Y.')),
                              (8, 'Petar', 'Petrović', STR_TO_DATE('01.12.1974.', '%d.%m.%Y.'), 'Tg Kralja Marka 45', 'Rijeka', '091-145-5455', 'ppetrovic@ob-pula', STR_TO_DATE('14.06.1995.', '%d.%m.%Y.')),
                              (9, 'Mihovil', 'Horvat', STR_TO_DATE('01.10.1995.', '%d.%m.%Y.'), 'Ul. Matije Vlačića 28', 'Poreč', '099-156-7895', 'mhorvat@ob-pula', STR_TO_DATE('21.08.2019.', '%d.%m.%Y.')),
							  (10, 'Maja', 'Benazić', STR_TO_DATE('08.05.1980.', '%d.%m.%Y.'), 'Valdebečki put 72', 'Pula', '099-526-263', 'mbenazic@ob-pula', STR_TO_DATE('05.05.2005.', '%d.%m.%Y.')),
                              (11, 'Matej', 'Mesić', STR_TO_DATE('07.08.1968.', '%d.%m.%Y.'), 'Supilova 4', 'Pula', '099-578-245', 'mmesic@ob-pula', STR_TO_DATE('01.01.1993.', '%d.%m.%Y.')),
                              (12, 'Lena', 'Jošković', STR_TO_DATE('01.12.1990.', '%d.%m.%Y.'), 'Istarska ul. 16', 'Pula', '091-345-2565', 'lenajoskovic@ob-pula', STR_TO_DATE('12.04.2013.', '%d.%m.%Y.')),
                              (13, 'Kristian', 'Cvek', STR_TO_DATE('07.09.1995.', '%d.%m.%Y.'), 'Ul. Vladimira Nazora 28', 'Poreč', '099-256-7885', 'kcvek@ob-pula', STR_TO_DATE('24.04.2019.', '%d.%m.%Y.')),
							  (14, 'Loren', 'Marić', STR_TO_DATE('01.12.1980.', '%d.%m.%Y.'), 'Rovinjska 7', 'Rovinj', '099-245-5862', 'lmaric@ob-pula', STR_TO_DATE('06.08.2004.', '%d.%m.%Y.')),
                              (15, 'Ivana', 'Antolović', STR_TO_DATE('01.04.1968.', '%d.%m.%Y.'), 'Labinska ulica 24', 'Pazin', '099-579-2455', 'iantolovic@ob-pula', STR_TO_DATE('01.07.1991.', '%d.%m.%Y.')),
                              (16, 'Dorian', 'Jakupović', STR_TO_DATE('21.09.1990.', '%d.%m.%Y.'), 'Ulica cara Trpimira 3', 'Pula', '091-585-1472', 'djakupovicc@ob-pula', STR_TO_DATE('10.01.2013.', '%d.%m.%Y.')),
                              (17, 'Marija', 'Leslić', STR_TO_DATE('16.07.1995.', '%d.%m.%Y.'), 'Trpimirova ulica 63', 'Pula', '099-548-1378', 'mleslic@ob-pula', STR_TO_DATE('14.04.2019.', '%d.%m.%Y.')),
							  (18, 'Ivan', 'Ilić', STR_TO_DATE('25.05.1982.', '%d.%m.%Y.'), 'Arsenalska 54', 'Pula', '099-485-1866', 'iilić@ob-pula', STR_TO_DATE('05.05.2006.', '%d.%m.%Y.')),
                              (19, 'Mario', 'Tanković', STR_TO_DATE('01.12.1965.', '%d.%m.%Y.'), 'Marićev prilaz 4', 'Pula', '099-581-2652', 'mtankovic@ob-pula', STR_TO_DATE('23.06.1989.', '%d.%m.%Y.')),
                              (20, 'Sanja', 'Bijelić', STR_TO_DATE('11.07.1990.', '%d.%m.%Y.'), 'Trg Petra Zrinskog 23', 'Rovinj', '091-155-5455', 'abijelic@ob-pula', STR_TO_DATE('09.09.2013.', '%d.%m.%Y.')),
                              (21, 'Maja', 'Perišić', STR_TO_DATE('24.04.1995.', '%d.%m.%Y.'), 'Petrova ulica 6', 'Pula', '098-445-1845', 'mperisic@ob-pula', STR_TO_DATE('10.10.2018.', '%d.%m.%Y.')),
							  (22, 'Luka', 'Majer', STR_TO_DATE('01.10.1980.', '%d.%m.%Y.'), 'Rabarova ulica 34', 'Pula', '099-556-263', 'lmajer@ob-pula', STR_TO_DATE('21.12.2004.', '%d.%m.%Y.')),
                              (23, 'Leona', 'Kmet', STR_TO_DATE('01.12.1969.', '%d.%m.%Y.'), 'Rožanski prilaz 56', 'Pula', '099-568-549', 'lkemt@ob-pula', STR_TO_DATE('01.01.1993.', '%d.%m.%Y.')),
                              (24, 'Sanjin', 'Peruško', STR_TO_DATE('04.05.1990.', '%d.%m.%Y.'), 'Labinska ul. 14', 'Pula', '095-354-4586', 'sperusko@ob-pula', STR_TO_DATE('04.08.2013.', '%d.%m.%Y.')),
                              (25, 'Frano', 'Cetina', STR_TO_DATE('11.10.1993.', '%d.%m.%Y.'), 'Valdebečki put 5', 'Pula', '097-156-5476', 'fcetina@ob-pula', STR_TO_DATE('05.04.2018.', '%d.%m.%Y.')),
							  (26, 'Ivano', 'Blašković', STR_TO_DATE('05.01.1960.', '%d.%m.%Y.'), 'Rizzijeva ulica 4', 'Pula', '091-548-263', 'iblaskovic@ob-pula', STR_TO_DATE('01.07.1984.', '%d.%m.%Y.')),
                              (27, 'Filip', 'Klarić', STR_TO_DATE('05.08.1967.', '%d.%m.%Y.'), 'Lazzijeva ulica 54', 'Pula', '099-579-245', 'fklaric@ob-pula', STR_TO_DATE('11.05.1990.', '%d.%m.%Y.')),
                              (28, 'Rebeka', 'Peruško', STR_TO_DATE('03.03.1990.', '%d.%m.%Y.'), 'Peruškov prilaz 18', 'Pula', '091-586-5188', 'rperusko@ob-pula', STR_TO_DATE('10.04.2015.', '%d.%m.%Y.')),
                              (29, 'Tiziana', 'Zgrablić', STR_TO_DATE('03.03.1995.', '%d.%m.%Y.'), 'Radićeva ulica 3', 'Pazin', '099-186-7556', 'tzgrablic@ob-pula', STR_TO_DATE('20.04.2020.', '%d.%m.%Y.')),
							  (30, 'Tia', 'Rogar', STR_TO_DATE('21.11.1981.', '%d.%m.%Y.'), 'Ročki prilaz 5', 'Pula', '091-556-455', 'trogar@ob-pula', STR_TO_DATE('03.07.2005.', '%d.%m.%Y.')),
                              (31, 'Mia', 'Anočić', STR_TO_DATE('04.04.1967.', '%d.%m.%Y.'), 'Putinjina 7', 'Pula', '099-542-485', 'manocic@ob-pula', STR_TO_DATE('01.05.1994.', '%d.%m.%Y.')),
                              (32, 'Diego', 'Matijaš', STR_TO_DATE('02.05.1990.', '%d.%m.%Y.'), 'Paganorska 36', 'Pula', '091-345-1864', 'dmatijas@ob-pula', STR_TO_DATE('12.04.2013.', '%d.%m.%Y.')),
                              (33, 'Dean', 'Zaharija', STR_TO_DATE('16.06.1995.', '%d.%m.%Y.'), 'Hermana Dalmatin 23', 'Poreč', '091-165-7495', 'dzaharija@ob-pula', STR_TO_DATE('21.08.2019.', '%d.%m.%Y.')),
							  (34, 'Roberto', 'Perković', STR_TO_DATE('19.06.1980.', '%d.%m.%Y.'), 'Santoriova 23', 'Pula', '097-489-878', 'rperkovic@ob-pula', STR_TO_DATE('18.05.2004.', '%d.%m.%Y.')),
                              (35, 'Sandi', 'Šipalo', STR_TO_DATE('11.12.1968.', '%d.%m.%Y.'), 'Ulica Starih Statuta 11', 'Pula', '091-585-1579', 'ssipalo@ob-pula', STR_TO_DATE('08.11.1990.', '%d.%m.%Y.'));
 
 INSERT INTO pacijent_u_bolnici VALUES (1, 1, 2, STR_TO_DATE('11.10.2021.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 202, 'Uznemirenost prstiju i bol u ruci, u kombinaciji s fluktuacijama krvnog tlaka i napadima vrtoglavice', 2.00),
									   (2, 2, 2, STR_TO_DATE('14.01.2022.', '%d.%m.%Y.'), 'Odjel opće i plastične kirurgije', 101, 'Više ubodnih rana u području abdomena', 1.00),
                                       (3, 3, 15, STR_TO_DATE('17.10.2021.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 203, 'Simptomi intervertebralne kile', 3.00),
                                       (4, 4, 14, STR_TO_DATE('04.10.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 201, 'Bolne senzacije trajne prirode u sternumu', 1.50),
                                       (5, 5, 20, STR_TO_DATE('28.10.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 214, 'Bolne senzacije trajne prirode u sternumu', 0.50),
                                       (6, 6, 17, STR_TO_DATE('11.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 103, 'Bolne senzacije trajne prirode u sternumu', 1.50),
                                       (7, 7, 20, STR_TO_DATE('13.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 205, 'Simptomi intervertebralne kile', 2.25),
                                       (8, 8, 17, STR_TO_DATE('14.09.2022.', '%d.%m.%Y.'), 'Odjel opće i plastične kirurgije', 104, 'Više ubodnih rana u područkju abdomena', 1.70),
                                       (9, 9, 9, STR_TO_DATE('21.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 105,  'Uznemirenost prstiju i bol u ruci s fluktuacijama krvnog tlaka', 2.00),
                                       (10, 10, 9, STR_TO_DATE('08.08.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 106, 'Ozljeda glave,mučnina, jaka glavobolja, gubitak napadaja svijesti', 2.00),
                                       (11, 11, 10, STR_TO_DATE('09.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 107, 'Mučnina, jaka glavobolja, gubitak napadaja svijesti, vrtoglavica i zujanje u ušima', 2.00),
                                       (12, 12, 2, STR_TO_DATE('24.08.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 207, 'Uznemirenost prstiju i bol u ruci s fluktuacijama krvnog tlaka', 3.00),
                                       (13, 13, 20, STR_TO_DATE('09.08.2022.', '%d.%m.%Y.'), 'Odjel opće i plastične kirurgije', 108, 'Prostrijelna rana', 1.50),
                                       (14, 14, 2, STR_TO_DATE('10.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 109, 'Potrebna transplantacija tankog crijeva radi autoimunog enteritisa', 2.00),
                                       (15, 15, 2, STR_TO_DATE('11.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 206, 'Ozljeda glave, mučnina, jaka glavobolja, gubitak napadaja svijesti, vrtoglavica i zujanje u ušima', 1.50),
                                       (16, 16, 18, STR_TO_DATE('07.10.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 208, 'Poteškoće u percepciji informacija i slaba koordinacija pokreta', 3.00),
                                       (17, 17, 18, STR_TO_DATE('08.10.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 110, 'Osteoartritis. Potrebna transplantacija hrskavice', 3.00),
                                       (18, 18, 9, STR_TO_DATE('09.10.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 209, 'Ozljeda glave,mučnina, jaka glavobolja, gubitak napadaja svijesti', 1.50),
                                       (19, 19, 20, STR_TO_DATE('10.10.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 210, 'Vrtoglavica i zujanje u ušima, poteškoće u percepciji informacija', 2.00),
                                       (20, 20, 20, STR_TO_DATE('11.10.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 255, 'Potrebna transplantacija tankog crijeva radi Chronove bolesti', 2.00),
                                       (21, 21, 2, STR_TO_DATE('12.10.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 256, 'Potrebna transplantacija tankog crijeva radi autoimunog enteritisa', 2.00),
                                       (22, 22, 6, STR_TO_DATE('12.10.2022.', '%d.%m.%Y.'),'Odjel za transplataciju', 257, 'Potrebna transplantacija tankog crijeva radi Hirschsprungove bolesti', 2.00),
                                       (23, 23, 2, STR_TO_DATE('13.10.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 258, 'Potrebna transplantacija tankog crijeva radi gastroshize', 2.00),
                                       (24, 24, 9, STR_TO_DATE('15.10.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 259, 'Osteoartritis. Potrebna transplantacija hrskavice', 2.00),
                                       (25, 25, 20, STR_TO_DATE('16.10.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 300, 'Potrebna transplantacija kože radi velikih opeklina', 2.00),
                                       (26, 26, 2, STR_TO_DATE('17.10.2022.', '%d.%m.%Y.'),'Odjel za transplataciju', 301, 'Potrebna translantacija srca, pacijent ima prirođenu bolest srca', 2.00),
                                       (27, 27, 2, STR_TO_DATE('18.10.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 302, 'Potrebna transplantacija pluća, pacijent ima respiratornu insuficijenciju', 3.00),
                                       (28, 28, 2, STR_TO_DATE('19.10.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 303, 'Potrebna transplantacija pluća, pacijent ima respiratornu insuficijenciju', 2.00),
                                       (29, 29, 16, STR_TO_DATE('20.10.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 111, 'Potrebna transplantacija pluća', 2.10),
                                       (30, 30, 2, STR_TO_DATE('26.10.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 112, 'Zatajenje jetre, potrebna transplatacija', 2.10),
                                       (31, 31, 16, STR_TO_DATE('23.10.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 211, 'Simptomi intervertebralne kile', 3.00),
                                       (32, 32, 18, STR_TO_DATE('17.10.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 113, 'Gubitak svijesti, izražene glavobolje stalne prirode, poremećaji govora', 2.80),
                                       (33, 33, 2, STR_TO_DATE('27.10.2022.', '%d.%m.%Y.'), 'Odjel opće i plastične kirurgije', 114, 'Gubitak velike količine krvi, ubodne rane u području abdomena, gubitak svijesti', 2.80),
                                       (34, 34, 2, STR_TO_DATE('11.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 212, 'Gubitak svijesti, izražene glavobolje stalne prirode, poremećaji govora, koordinacije', 2.00),
                                       (35, 35, 2, STR_TO_DATE('12.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 213, 'Gubitak svijesti, izražene glavobolje stalne prirode, poremećaji govora, koordinacije', 1.20),
                                       (36, 36, 2, STR_TO_DATE('13.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 214, 'Vrtoglavica i zujanje u ušima, poteškoće u percepciji informacija i slaba koordinacija pokreta', 1.50),
                                       (37, 37, 2, STR_TO_DATE('14.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 215, 'Gubitak svijesti, izražene glavobolje stalne prirode, poremećaji govora, koordinacije', 2.10),
                                       (38, 38, 2, STR_TO_DATE('15.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 216, 'Simptomi intervertebralne kile', 2.00),
									   (39, 39, 18, STR_TO_DATE('16.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 217, 'Vrtoglavica i zujanje u ušima, poteškoće u percepciji informacija i slaba koordinacija pokreta', 2.50),
                                       (40, 40, 18, STR_TO_DATE('17.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 218, 'Vrtoglavica i zujanje u ušima, poteškoće u percepciji informacija i slaba koordinacija pokreta', 1.40),
                                       (41, 41, 18, STR_TO_DATE('21.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 219, 'Simptomi intervertebralne kile', 2.10),
                                       (42, 42, 2, STR_TO_DATE('21.10.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 115, 'Potrebna transplantacija kože radi velikih opeklina', 2.00),
                                       (43, 43, 18, STR_TO_DATE('29.10.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 220, 'Vrtoglavica i zujanje u ušima, te slaba koordinacija pokreta', 1.00),
                                       (44, 44, 2, STR_TO_DATE('29.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 116, 'Simptomi intervertebralne kile', 2.00),
                                       (45, 45, 18, STR_TO_DATE('14.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 117, 'Simptomi intervertebralne kile', 1.00),
                                       (46, 46, 10, STR_TO_DATE('12.11.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 118, 'Simptomi intervertebralne kile', 3.00),
                                       (47, 47, 16, STR_TO_DATE('07.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 119, 'Zbog zatajenje bubrega, potrebna transplatacija', 1.50),
                                       (48, 48, 18, STR_TO_DATE('01.12.2022.', '%d.%m.%Y.'), 'Odjel neurokirurgije', 221, 'Ozljeda glave, mučnina, jaka glavobolja, gubitak napadaja svijesti', 1.50),
                                       (49, 49, 18, STR_TO_DATE('03.12.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 120, 'Zbog zatajenje bubrega, potrebna transplatacija', 1.00),
                                       (50, 50, 6, STR_TO_DATE('04.12.2022.', '%d.%m.%Y.'), 'Odjel hematologije', 121, 'Leukemija, izražen umor, iscrpljenost', 2.00),
                                       (51, 51, 10, STR_TO_DATE('18.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 122, 'Zatajenje jetre, potrebna transplatacija', 1.00),
                                       (52, 52, 10, STR_TO_DATE('19.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 304, 'Zatajenje jetre, potrebna transplatacija', 4.00),
                                       (53, 53, 18, STR_TO_DATE('20.11.2022.', '%d.%m.%Y.'), 'Odjel hematologije', 305, 'Leukemija, izražen umor', 3.00),
                                       (54, 54, 10, STR_TO_DATE('29.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 123, 'Periferna krv je gotovo u potpunosti zamijenila koštanu srž kao izvor matičnih stanica, potrebna transplantacija hematopoetskih matičnih stanica', 4.00),
                                       (55, 55, 2, STR_TO_DATE('21.11.2022.', '%d.%m.%Y.'), 'Odjel hematologije', 306, 'Leukemija, izražen umor', 1.00),
                                       (56, 56, 18, STR_TO_DATE('23.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 124, 'Šećerna bolest, zatajenje bubrega, potrebna transplatacija', 2.00),
                                       (57, 57, 10, STR_TO_DATE('23.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 307, 'Potrebna transplantacija srca, pacijent pati od zatajenja srca i aritmija', 1.40),
                                       (58, 58, 10, STR_TO_DATE('23.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 125, 'Potrebna transplantacija srca, pacijent pati od hipertrofične kardiomiopatije', 1.50),
                                       (59, 59, 18, STR_TO_DATE('24.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 126, 'Periferna krv zamijenila koštanu srž, hitno potrebna transplantacija hematopoetskih matičnih stanica', 1.00),
                                       (60, 60, 17, STR_TO_DATE('07.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 127, 'Zatajenje jetre, potrebna transplatacija', 3.00),
                                       (61, 61, 10, STR_TO_DATE('14.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 308, 'Periferna krv je gotovo u potpunosti zamijenila koštanu srž kao izvor matičnih stanica, potrebna transplantacija hematopoetskih matičnih stanica', 3.00),
                                       (62, 62, 20, STR_TO_DATE('15.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 309, 'Potrebna transplantacija srca, pacijent pati od hipertrofične kardiomiopatije', 1.00),
                                       (63, 63, 18, STR_TO_DATE('18.11.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 128, 'Potrebna transplantacija srca, pacijent pati od hipertrofične kardiomiopatije', 1.00),
                                       (64, 64, 18, STR_TO_DATE('29.9.2022.', '%d.%m.%Y.'), 'Odjel za transplataciju', 310, 'Zatajenje jetre, potrebna transplatacija', 1.00);
    
INSERT INTO kriterij VALUES (1, 18, 24, 55, 100, 36.1, 36.5, 105, 132, 73, 83, 70, 78, 119, 175, NOW()),
							(2, 25, 35, 55, 100, 36.5, 37.0, 109, 134, 75, 85, 71, 76, 119, 175, NOW()),
                            (3, 36, 45, 55, 100, 36.5, 37.0, 111, 137, 78, 87, 72, 78, 119, 175,NOW()),
                            (4, 46, 54, 55, 100, 36.5, 37.0, 115, 142, 80, 89, 72, 77, 119, 175, NOW()),
                            (5, 55, 65, 55, 100, 36.1, 37.0, 118, 147, 82, 91, 72, 76, 119, 175, NOW());
																																								
INSERT INTO darivatelj VALUES (1, 2, 'Ana', 'Matošević', '12346782342', 'Ž', STR_TO_DATE('06.12.1995', '%d.%m.%Y.'), 'Aničićev prilaz 5', 'Pula', '099-246-7890', '+A', 27, 59, 36.3, 120, 85, 73, 120), 
							  (2, 2, 'Mario', 'Marjanović', '12346782343', 'M', STR_TO_DATE('03.12.1987.', '%d.%m.%Y.'), 'Marićev prilaz 15', 'Pula', '099-246-7891', '+A', 35, 85, 36.7, 127, 80, 85, 158),
                              (3, 4, 'Josip', 'Maružin', '12346782344', 'M', STR_TO_DATE('05.06.1966.', '%d.%m.%Y.'), 'Santoriova 52', 'Pula', '099-246-7892', '+AB', 56, 79, 36.7, 130, 85, 74, 162),
                              (4, 4, 'Denis', 'Juranović', '12346752344', 'M', STR_TO_DATE('06.07.1972.', '%d.%m.%Y.'), 'Valdebečki put 37', 'Pula', '099-246-7893', '-B', 50, 85, 36.7, 127, 80, 85, 145),
                              (5, 1, 'Maja', 'Blekić', '12346782345', 'Ž', STR_TO_DATE('09.05.2002.', '%d.%m.%Y.'), 'Peruškov prilaz 15', 'Pula', '099-246-7898', '-B', 20, 56, 36.3, 120, 80, 70, 125),
                              (6, 1, 'Petar', 'Kalčić', '12346782346', 'M', STR_TO_DATE('07.09.2001.', '%d.%m.%Y.'), 'Ružićeva 33', 'Pula', '099-246-7899', '+0', 21, 77, 36.7, 127, 81, 75, 164),
                              (7, 1, 'Sebastian', 'Kovač', '12346782347', 'M', STR_TO_DATE('9.10.2003.', '%d.%m.%Y.'), 'Santoriova 45', 'Pula', '099-246-7880', '-0', 19, 90, 36.7, 130, 80, 77, 134),
                              (8, 2, 'Iva', 'Jurić', '12346782348', 'Ž', STR_TO_DATE('3.12.1997.', '%d.%m.%Y.'), 'Ročki prilaz 7', 'Pula', '099-246-7881', '+AB', 25, 73, 36.7, 127, 80, 72, 138),
                              (9, 2, 'Ivana', 'Mišelić', '12346782310', 'Ž', STR_TO_DATE('03.12.1987.', '%d.%m.%Y.'), 'Paganorska 3', 'Pula', '099-246-7882', '+AB', 35, 85, 36.7, 127, 80, 85, 128),
							  (10, 2, 'Ivan', 'Ivanović', '12346782311', 'M', STR_TO_DATE('13.09.1994.', '%d.%m.%Y.'), 'Valmarinski put 15', 'Pula', '099-246-7883', '+B', 28, 85, 36.7, 127, 80, 85, 141),
                              (11, 2, 'Marko', 'Marković', '12346782312', 'M', STR_TO_DATE('03.12.1987.', '%d.%m.%Y.'), 'Voltićeva 7', 'Pula', '099-246-7884', '+B', 28, 85, 36.7, 127, 80, 85, 168),
                              (12, 2, 'Sara', 'Siljan', '12346782313', 'Ž', STR_TO_DATE('03.12.1989.', '%d.%m.%Y.'), 'Hermana Dalmatin 21', 'Pula', '099-246-7885', '+0', 33, 73, 36.7, 127, 80, 85, 147),
                              (13, 4, 'Leona', 'Radolović', '12346782314', 'Ž', STR_TO_DATE('04.10.1968.', '%d.%m.%Y.'), 'Putinjina 9', 'Pula', '099-246-7886', '+A', 54, 70, 36.7, 127, 80, 85, 159),
                              (14, 3, 'Mia', 'Cetina', '12346782315', 'Ž', STR_TO_DATE('08.05.1978.', '%d.%m.%Y.'), 'Arsenalska 4', 'Pula', '099-246-7887', '+B', 44, 69, 36.7, 127, 80, 85, 144),
                              (15, 1, 'Maja', 'Rozga', '12346782316', 'Ž', STR_TO_DATE('09.10.1999.', '%d.%m.%Y.'), 'Radićeva ulica 8', 'Pula', '099-246-7888', '+AB', 23, 64, 36.7, 127, 80, 85, 122),
                              (16, 1, 'Rebeka', 'Martinović', '12346782317', 'Ž', STR_TO_DATE('07.04.2000.', '%d.%m.%Y.'), 'Savudrijska 15', 'Pula', '099-246-7889', '-AB', 22, 72, 36.7, 127, 80, 85, 121),
                              (17, 2, 'Luka', 'Bernobić', '12346782318', 'M', STR_TO_DATE('05.02.1997.', '%d.%m.%Y.'), 'Prilaz Cerella 2', 'Pula', '099-246-7870', '-B', 25, 91, 36.7, 127, 80, 85, 134),
                              (18, 3, 'Darko', 'Grdina', '12346782319', 'M', STR_TO_DATE('02.11.1985.', '%d.%m.%Y.'), 'Ulica Starih Statuta 4', 'Pula', '099-246-7871', '-B', 37, 87, 36.7, 127, 80, 85, 175),
							  (19, 1, 'Ognjen', 'Lakošeljac', '12346782320', 'M', STR_TO_DATE('03.03.2003.', '%d.%m.%Y.'), 'Marićev prilaz 15', 'Pula', '099-246-7872', '+AB', 19, 74, 36.7, 127, 80, 85, 159),
                              (20, 2, 'Mirko', 'Leslić', '12346782321', 'M', STR_TO_DATE('19.08.1989.', '%d.%m.%Y.'), 'Prilaz kanal 3', 'Pula', '099-246-7873', '-AB', 33, 98, 36.7, 127, 80, 85, 163),
                              (21, 1, 'Petra', 'Antolović', '12346782322', 'Ž', STR_TO_DATE('08.04.2002', '%d.%m.%Y.'), 'Prilaz Plazina 1', 'Pula', '099-246-7874', '+0', 20, 58, 36.7, 127, 80, 85, 164),
                              (22, 1, 'Monika', 'Zgrablić', '12346759811', 'Ž', STR_TO_DATE('09.07.2003.', '%d.%m.%Y.'), 'Padski put 21', 'Pula', '099-246-7875', '-0', 21, 85, 36.7, 127, 80, 85, 126),
                              (23, 2, 'Mauro', 'Peruško', '12346782324', 'M', STR_TO_DATE('06.06.1996.', '%d.%m.%Y.'), 'Palladiova 32', 'Pula', '099-246-7876', '-0', 26, 85, 36.7, 127, 80, 85, 124),
                              (24, 1, 'Dajana', 'Zaharija', '12346782325', 'Ž', STR_TO_DATE('29.05.1985.', '%d.%m.%Y.'), 'Dvigradska 42', 'Pula', '099-246-7877', '+A', 37, 85, 36.7, 127, 80, 85, 135),
                              (25, 2, 'Leo', 'Končar', '12346782326', 'M', STR_TO_DATE('05.05.1988.', '%d.%m.%Y.'), 'Drenovica 24', 'Pula', '099-246-7878', '+A', 34, 85, 36.7, 127, 80, 85, 134),
                              (26, 5, 'Lea', 'Petrović', '12346782327', 'Ž', STR_TO_DATE('02.01.1962.', '%d.%m.%Y.'), 'Divkovićeva 12', 'Pula', '099-246-7879', '+B', 60, 85, 36.7, 127, 80, 85, 138),
                              (27, 5, 'Antonio', 'Horvat', '12346782328', 'M', STR_TO_DATE('13.12.1965.', '%d.%m.%Y.'), 'Argonautska 32', 'Pula', '099-246-6880', '-B', 57, 85, 36.7, 127, 80, 85, 153),
							  (28, 5, 'Toni', 'Marjanović', '12346782329', 'M', STR_TO_DATE('13.02.1967.', '%d.%m.%Y.'), 'Anticova 33', 'Pula', '099-246-6881', '+AB', 55, 85, 36.7, 127, 80, 85, 159),
                              (29, 1, 'Kristian', 'Cetina', '12346782330', 'M', STR_TO_DATE('28.01.1999.', '%d.%m.%Y.'), 'Akvilejski prilaz 12', 'Pula', '099-246-6882', '+B', 23, 85, 36.7, 127, 80, 85, 156),
                              (30, 1, 'Mario', 'Kmet', '12346782323', 'M', STR_TO_DATE('04.09.1989.', '%d.%m.%Y.'), 'Amfiteatarska 3', 'Pula', '099-246-6883', '-0', 23, 85, 36.7, 127, 80, 85, 134),
                              (31, 2, 'Lucija', 'Majer', '12346782331', 'Ž', STR_TO_DATE('03.11.1987.', '%d.%m.%Y.'), 'Antenska 7', 'Pula', '099-246-6884', '-A', 35, 85, 36.7, 127, 80, 85, 159),
                              (32, 1, 'Maria', 'Krizman', '12346782332', 'Ž', STR_TO_DATE('09.07.2003.', '%d.%m.%Y.'), 'Epnova 15', 'Pula', '099-246-6885', '+0', 19, 85, 36.7, 127, 80, 85, 169),
                              (33, 1, 'Silvana', 'Bunić', '12346782333', 'Ž', STR_TO_DATE('26.07.2004.', '%d.%m.%Y.'), 'Dobrilina 25', 'Pula', '099-246-6886', '+0', 18, 85, 36.7, 127, 80, 85, 138),
                              (34, 1, 'Tatjana', 'Burić', '12346782334', 'Ž', STR_TO_DATE('15.05.1998.', '%d.%m.%Y.'), 'Držićeva 5', 'Pula', '099-246-6887', '+AB', 24, 85, 36.7, 127, 80, 85, 136),
                              (35, 5, 'Tin', 'Stanić', '12346782335', 'M', STR_TO_DATE('05.04.1959.', '%d.%m.%Y.'), 'Danteov trg 3', 'Pula', '099-246-6888', '+B', 63, 85, 36.7, 127, 80, 85, 159),
                              (36, 3, 'Leon', 'Sebešić', '12346782365', 'M', STR_TO_DATE('28.07.1984.', '%d.%m.%Y.'), 'Dolinka 23', 'Pula', '099-246-6889', '+B', 38, 85, 36.7, 127, 80, 85, 155),
							  (37, 3, 'Tanja', 'Kontošić', '12346782337', 'Ž', STR_TO_DATE('22.09.1978.', '%d.%m.%Y.'), 'Rabarova ulica 11', 'Pula', '099-246-6981', '-B', 44, 85, 36.7, 127, 80, 85, 154);
			        
INSERT INTO prijevoznik VALUES (1, 'Prijevoznik Česnik', '052-333-678', 'teretni kombi', 'PU-6655-K'),
							   (2, 'Prijevoznik Kostrenč', '052-333-897', 'teretni kombi', 'PU-6656-R'),   
                               (3, 'Prijevoznik Pužnik', '052-333-879', 'teretni kombi', 'PU-6657-V'),
                               (4, 'Prijevoznik Brkić', '052-332-891', 'teretni kombi', 'PU-6658-K'),   
                               (5, 'Prijevoznik Malta', '052-233-805', 'teretni kombi', 'PU-6659-R'),
                               (6, 'Prijevoznik Master', '052-312-885', 'teretni kombi', 'PU-6660-V'),   
                               (7, 'Prijevoznik Hrelja', '052-333-881', 'teretni kombi', 'PU-6661-K'),
                               (8, 'Prijevoznik Tero', '052-385-897', 'teretni kombi', 'PU-6662-R'),   
                               (9, 'Prijevoznik Alpe', '052-354-879', 'teretni kombi', 'PU-6663-V'),
							   (10, 'Prijevoznik Deni', '052-355-897', 'teretni kombi', 'PU-6664-R'),   
                               (11, 'Prijevoznik Palka', '052-362-879', 'teretni kombi', 'PU-6665-V'),
                               (12, 'Prijevoznik Škrabl', '052-385-877', 'teretni kombi', 'PU-6666-R'),   
                               (13, 'Prijevoznik Paleta', '052-352-119', 'teretni kombi', 'PU-6667-V'),
                               (14, 'Prijevoznik Radetić', '052-352-157', 'teretni kombi', 'PU-6668-R'),   
                               (15, 'Prijevoznik Žuvela', '052-113-479', 'teretni kombi', 'PU-6669-V');
     
INSERT INTO zahtjev (id_prijevoznik, id_banka_krvi, id_bolnica, krvna_grupa, kolicina, status_zahtjeva) VALUES (1, 1, 4, '+A', 105.00, 'U tijeku'),
																											   (2, 1, 3, '-0', 50.00, 'U tijeku'),
                                                                                                               (3, 1, 7, '+AB', 30.00, 'U tijeku'),
																											   (4, 1, 9, '-A', 50.00, 'Zaprimljen'),
                                                                                                               (5, 1, 15, '+B', 75.00, 'Zaprimljen'),
																											   (6, 1, 13, '-A', 45.90, 'U tijeku'),
                                                                                                               (7, 1, 6, '+A', 105.30, 'U tijeku'),
																											   (8, 1, 2, '-B', 50.00, 'U tijeku'),
                                                                                                               (9, 1, 11, '+A', 71.00, 'U tijeku'),
																											   (10, 1, 8, '-0', 22.50, 'Zaprimljen'),
                                                                                                               (9, 1, 9, '+0', 10.00, 'Zaprimljen'),
																											   (12, 1, 19, '-AB', 20.25, 'U tijeku'),
                                                                                                               (13, 1, 18, '+AB', 105.00, 'U tijeku'),
																											   (14, 1, 14, '-A', 33.75, 'U tijeku'),
                                                                                                               (9, 1, 17, '+B', 35.10, 'U tijeku'),
                                                                                                               (4, 1, 9, '+B', 35.00, 'Zaprimljen');
		
INSERT INTO zalihe (id_banka_krvi, krvna_grupa, kolicina) VALUES (1, '+A', 1000.00),
																 (1, '-A', 1000.00),
                                                                 (1, '+B', 1000.00),
                                                                 (1, '-B', 1000.00),
                                                                 (1, '+AB', 1000.00),
																 (1, '-AB', 1000.00),
                                                                 (1, '+0', 1000.00),
                                                                 (1, '-0', 1000.00);

INSERT INTO termin (id_zalihe, id_zaposlenik, id_darivatelj) VALUES (1, 1, 1),
																    (2, 5, 31),
                                                                    (3, 5, 26),
                                                                    (4, 12, 4),
																    (5, 3, 34),
                                                                    (3, 12, 36),
                                                                    (6, 5, 20), 
                                                                    (7, 11, 32),
                                                                    (3, 5, 36),
																    (8, 9, 22),
                                                                    (1, 9, 2), 
                                                                    (3, 7, 29),
                                                                    (3, 12, 36),
																    (4, 11, 5),
                                                                    (5, 5, 28), 
                                                                    (6, 23, 16),
																    (7, 33, 33),
                                                                    (8, 5, 34), 
                                                                    (1, 31, 13),
																    (3, 35, 36),
                                                                    (4, 25, 17), 
                                                                    (5, 17, 19),
																    (8, 35, 30),
                                                                    (7, 14, 32);
 
      
/*_______________________________________________ Ispisivanje sadržaja svih tablica _____________________________________________________*/

SELECT * FROM banka_krvi;
SELECT * FROM bolnica;
SELECT * FROM pacijent;
SELECT * FROM zaposlenik;
SELECT * FROM pacijent_u_bolnici;
SELECT * FROM kriterij;
SELECT * FROM darivatelj;
SELECT * FROM prijevoznik;
SELECT * FROM zahtjev;
SELECT * FROM zalihe;
SELECT * FROM termin;

/*_________________________________________________________ Upiti ________________________________________________________________________*/

-- 1. Ispis imena i prezimena zaposlenika, datum zaposlenja, ime i prezime darivatelja te datum termina na kojem je pojedini zaposlenik 'uzeo' krv darivatelju'
SELECT z.ime AS ime_zaposlenika, z.prezime AS prezime_zaposlenika, z.datum_zaposlenja, d.ime AS ime_darivatelja, d.prezime AS prezime_darivatelja, t.datum_i_vrijeme FROM zaposlenik z
	INNER JOIN termin t ON z.id = t.id_zaposlenik
    INNER JOIN darivatelj d ON d.id = t.id_darivatelj; 

-- 2. Ispis imena, prezimena, krvne grupe, odjela i sobe pacijenata kojima je potrebno više od 3 litre krvi
SELECT pacijent.ime, pacijent.prezime, pacijent.krvna_grupa, pacijent_u_bolnici.odjel, pacijent_u_bolnici.soba FROM pacijent, pacijent_u_bolnici 
WHERE pacijent.id = pacijent_u_bolnici.id_pacijent AND kolicina >= 3;

-- 3. Ispis imena prijevoznika, odredište isporuke(naziv, adresa, grad) te vrstu, količinu i broj isporuka (krvna_grupa i količina) poredati uzlazno po gradu 
SELECT p.ime_prijevoznika, b.naziv, b.grad, b.adresa, z.krvna_grupa, SUM(z.kolicina) AS prevezena_kolicina, COUNT(p.id) AS broj_prijevoza FROM prijevoznik p, bolnica b, zahtjev z
WHERE z.id_bolnica = b.id AND z.id_prijevoznik = p.id
GROUP BY p.ime_prijevoznika
ORDER BY b.grad ASC;

-- 4. Ispis zaposlenika koji je 'obavio' najviše termina'
SELECT zaposlenik.*, COUNT(zaposlenik.id) AS broj_termina FROM zaposlenik
	INNER JOIN termin ON termin.id_zaposlenik = zaposlenik.id
    GROUP BY zaposlenik.ime
    ORDER BY broj_termina DESC
    LIMIT 1;
    
-- 5. Kolicina krvi u zalihama nakon pojedinog termina
SELECT id_zaposlenik, id_darivatelj, krvna_grupa, (COUNT(id_zalihe) * termin.kolicina + zalihe.kolicina) AS kolicina_u_zalihama FROM termin 
	INNER JOIN zalihe ON termin.id_zalihe = zalihe.id
    GROUP BY id_zalihe;

-- 6.Ispis prijevoznika koji ima najviše odrađenih zahtjeva
SELECT bolnica.naziv, prijevoznik.ime_prijevoznika
FROM zahtjev 
INNER JOIN prijevoznik ON id_prijevoznik = prijevoznik.id
INNER JOIN bolnica ON id_bolnica = bolnica.id
INNER JOIN banka_krvi ON id_banka_krvi = banka_krvi.id
GROUP BY bolnica.naziv, bolnica.id, prijevoznik.ime_prijevoznika, prijevoznik.id 
HAVING COUNT(prijevoznik.id)>1;

-- 7.Ispis odjela u svim bolnicama i ukupne količine pacijenata u njima
SELECT pacijent_u_bolnici.odjel, COUNT(pacijent_u_bolnici.id) 
FROM bolnica
INNER JOIN pacijent_u_bolnici ON bolnica.id = pacijent_u_bolnici.id_bolnica
GROUP BY pacijent_u_bolnici.odjel
ORDER BY COUNT(pacijent_u_bolnici.id)DESC;

-- 8. Uzeta količina krvne grupe 0 na svim terminima
SELECT SUM(kolicina) AS kolicina_krvi FROM darivatelj 
INNER JOIN termin ON darivatelj.id = termin.id_darivatelj
WHERE krvna_grupa = '-0' OR krvna_grupa = '+0';

-- 9. Ispis krvne grupe koja se najviše donirala po svim bolnicama 
SELECT zalihe.krvna_grupa 
FROM darivatelj 
INNER JOIN termin ON termin.id_darivatelj = darivatelj.id
INNER JOIN zalihe ON zalihe.id = termin.id_zalihe
GROUP BY zalihe.krvna_grupa
ORDER BY COUNT(darivatelj.id)DESC
	LIMIT 1;

-- 10. Ispis donora čij sistolički tlak iznad 125 i dijastolički manji ili jednak od 80 te ime i prezime zaposlenika koji je sudjelovao na terminu
SELECT zaposlenik.ime, zaposlenik.prezime, darivatelj.*  FROM darivatelj 
INNER JOIN termin ON termin.id_darivatelj = darivatelj.id
INNER JOIN zaposlenik ON zaposlenik.id = termin.id_zaposlenik
WHERE sistolicki_krvni_tlak > 125 AND dijastolicki_krvni_tlak <= 80;

/*_________________________________________________________ Pogledi ______________________________________________________________________*/

-- 1. Pogled prosjecan broj pacijenta po mjesecu tijekom prošle godine
CREATE VIEW Prosjecan_br_Pacijenata AS
SELECT CONCAT(MONTH(datum_primanja), "/", YEAR(datum_primanja)) AS mjesec
FROM pacijent_u_bolnici
WHERE YEAR(datum_primanja) = YEAR(CURRENT_TIMESTAMP) - 1
GROUP BY MONTH(datum_primanja); 
 
SELECT * FROM Prosjecan_br_Pacijenata;

-- 2. Pogled koji će prikazati darivtelje i njihove maksikalne podatke iz kriterija
CREATE VIEW darivatelj_max AS
SELECT darivatelj.id,darivatelj.ime,darivatelj.prezime, kriterij.max_dob,kriterij.max_tjelesna_tezina,
kriterij.max_tjelesna_temperatura,kriterij.max_sistolicki_krvni_tlak,kriterij.max_dijastolicki_krvni_tlak,kriterij.max_puls,
kriterij.max_hemoglobin
FROM darivatelj INNER JOIN kriterij
ON darivatelj.id=kriterij.id;

SELECT * FROM darivatelj_max;
  
-- 3.Kreirati pogled koji će ispisati zaposlenike koji su uzeli krv u zadanom terminu.
CREATE VIEW Zaposlenik_Termin AS
SELECT zaposlenik.*
FROM zaposlenik, termin
WHERE zaposlenik.id = termin.id_zaposlenik;

SELECT * FROM Zaposlenik_Termin;

-- 4.Kreirati pogled za pacijente koje su smješteni u bolnici na odjelu neurokirurgije te kojima je potrebna krvna grupa +A.
CREATE VIEW Pacijent_Bolnica AS
SELECT pacijent.*, pacijent_u_bolnici.odjel
FROM pacijent 
INNER JOIN pacijent_u_bolnici ON pacijent.id = pacijent_u_bolnici.id_pacijent
WHERE pacijent_u_bolnici.odjel = 'Odjel neurokirurgije' AND pacijent.krvna_grupa = '+A';

SELECT * FROM Pacijent_Bolnica;

-- 5. Kreirati pogled koji će ispisati ime, prezime, datum rođenja i datum_zaposlenja po silaznom redoslijedu(datum_zaposlenja) s time da ime zaposlenika u imenu sadržava slovo a.
CREATE VIEW Pregled_Zaposlenika AS
SELECT ime, prezime, datum_rodenja, datum_zaposlenja
FROM zaposlenik
WHERE ime LIKE '%a%'
ORDER BY datum_zaposlenja DESC;

SELECT * FROM Pregled_Zaposlenika ;

-- 6. Prikaži sve pacijente poredane po abecednom redu prezimena koji su dali krv u bolnici.
CREATE VIEW pacijent_abc AS
SELECT *
FROM pacijent
WHERE id IN (SELECT id_pacijent FROM pacijent_u_bolnici)
ORDER BY prezime;

SELECT * FROM pacijent_abc;

-- 7.Kreirati pogled za pacijente koju su dali krv u općoj bolnici Pula.
CREATE VIEW Pacijenti_Pula AS
SELECT pacijent.*
FROM pacijent_u_bolnici
INNER JOIN pacijent ON pacijent_u_bolnici.id_pacijent = pacijent.id
INNER JOIN bolnica ON pacijent_u_bolnici.id_bolnica = bolnica.id  
WHERE naziv = "Opća bolnica Pula";

SELECT * FROM Pacijenti_Pula;

-- 8. Napraviti pogled koji ispisuje koliko je puta darivatelj Leon Sebešić donirao krv.
CREATE VIEW donator_Leon AS
SELECT darivatelj.ime, darivatelj.prezime, termin.datum_i_vrijeme, COUNT(darivatelj.id) AS broj_donacija
FROM darivatelj INNER JOIN termin
ON darivatelj.id=termin.id_darivatelj
WHERE ime = 'Leon' AND prezime = 'Sebešić';

SELECT * FROM donator_Leon;

 -- 9. Kreirati pogled koji će ispisati sve zahtjeve koja izdaje bolnica.
CREATE VIEW Zahtjev_Bolnica AS
SELECT zahtjev.*, YEAR (zahtjev.datum_podnesenja) AS godina
FROM zahtjev INNER JOIN bolnica
ON zahtjev.id_bolnica = bolnica.id;

SELECT * FROM Zahtjev_Bolnica; 

-- 10. Kreirati pogled koji prikazuje koji je prijevoznik isporučio pošiljku krvi, koju količinu pošiljke te koju krvnu grupu.
CREATE VIEW Prijevoznik_Krvi AS
SELECT prijevoznik.*, zahtjev.kolicina, zahtjev.krvna_grupa
FROM zahtjev
INNER JOIN prijevoznik ON zahtjev.id_prijevoznik = prijevoznik.id
WHERE zahtjev.status_zahtjeva = 'Zaprimljen';

SELECT * FROM Prijevoznik_Krvi;


/*_________________________________________________________ Funkcije _____________________________________________________________________*/
-- 1.Funkcija koja vraća naziv bolnice iz odabranog grada
DELIMITER //
CREATE FUNCTION GetBolnica(GRAD1 VARCHAR (20))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
RETURN (SELECT naziv FROM bolnica WHERE grad=GRAD1);
END//
DELIMITER ;

SELECT GetBolnica("Pula")

-- 2.Funkcija koja prikazuje zaprimljene pacijente sa krvnom grupom A+ 
DELIMITER //
CREATE FUNCTION GetPacijentByBloodGroup(Krvna_grupa1 VARCHAR(3)) 
RETURNS INTEGER 
DETERMINISTIC
BEGIN
 RETURN (SELECT COUNT(id) FROM pacijent WHERE krvna_grupa=krvna_grupa1);
END//
DELIMITER ;

SELECT GetPacijentByBloodGroup ("+A")

-- 3.Funkcija koja vraća ime i prezime zaposlenika zajedno sa imenom i prezimenom darivatelja na terminu darivanja krvi
DELIMITER //
CREATE FUNCTION ipzipd (id_termin INTEGER) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
RETURN (SELECT CONCAT("vrijeme darivanja:",DATE_FORMAT(t.datum_i_vrijeme, "%Y-%m-%d"),";ime zaposlenika:",z.ime,";ime darivatelja:",d.ime) FROM termin t INNER JOIN zaposlenik z ON t.id_zaposlenik=z.id INNER JOIN darivatelj d ON t.id_darivatelj=d.id WHERE t.id=id_termin);
END//
DELIMITER ;

SELECT ipzipd (4)

-- 4.Funkcija koja vraća količinu utrošene krvne grupe u litrama za pacijente u bolnici
DELIMITER //
CREATE FUNCTION KoličinaKrvi (krvna_grupa1 VARCHAR(3)) RETURNS DECIMAL(5,2)
DETERMINISTIC 
BEGIN
RETURN (SELECT SUM(kolicina) FROM pacijent_u_bolnici b INNER JOIN pacijent p ON b.id_pacijent = p.id WHERE p.krvna_grupa = krvna_grupa1);
END //
DELIMITER ;

SELECT KoličinaKrvi ("+A")

-- 5. Funkcija koja na unešeni određeni OIB vraća osobne podatke darivatelja
DELIMITER // 
CREATE FUNCTION OibPodaci (oib_d VARCHAR(11)) RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN
RETURN (SELECT CONCAT(ime, " " , prezime, " ", spol, " ", DATE_FORMAT(datum_rodenja,"%Y-%m-%d"), " ", adresa, " ", grad, " ", kontakt, " ", krvna_grupa, " ", dob, " ") FROM darivatelj WHERE OIB_d = OIB);
END //
DELIMITER ;

SELECT oibPodaci (12346782317)

-- 6.Funkcija koja na unešenu registraciju vozila vraća podatke prijevoznika
DELIMITER //
CREATE FUNCTION RegOznaka (registarska_o VARCHAR(9)) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
RETURN (SELECT CONCAT(ime_prijevoznika, " ", kontakt, " ", tip_vozila, " ") FROM prijevoznik WHERE registarska_oznaka=registarska_o);
END//
DELIMITER ;

SELECT RegOznaka("PU-6655-K")
 
-- 7. Funkcija koja vraća informaciju o statusu zahtjeva te koja količina krvne grupe treba biti ili je već dostavljena 
DELIMITER //
CREATE FUNCTION StatusZahtjeva (krvna_g VARCHAR(3), status_z VARCHAR(15)) RETURNS DECIMAL(8,2)
DETERMINISTIC
BEGIN
RETURN (SELECT SUM(kolicina) FROM zahtjev WHERE krvna_grupa=krvna_g AND status_zahtjeva=status_z);
END //
DELIMITER ;

SELECT StatusZahtjeva ("-A","Zaprimljen")

-- 8.Funkcija koja vraća podatke o količini krvi potrebne po unešenom odjelu 
DELIMITER // 
CREATE FUNCTION OdjelKrv (odjel_o VARCHAR(50)) RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
RETURN (SELECT SUM(kolicina) FROM pacijent_u_bolnici WHERE odjel = odjel_o);
END //
DELIMITER ;

SELECT OdjelKrv("Odjel neurokirurgije")
 
-- 9.Funkcija koja vraća količinu pacijenata u određenoj zatraženoj granici sistoličkog krvnog tlaka ili dijastoličkog krvnog tlaka
DELIMITER // 
CREATE FUNCTION DKrvTlakSKrvTlak (sk_min INTEGER, sk_max INTEGER, dk_min INTEGER, dk_max INTEGER) RETURNS INTEGER 
DETERMINISTIC 
BEGIN
RETURN (SELECT COUNT(id) FROM darivatelj WHERE sistolicki_krvni_tlak BETWEEN sk_min AND sk_max OR dijastolicki_krvni_tlak BETWEEN dk_min AND dk_max);
END //
DELIMITER ;

SELECT DKrvTlakSKrvTlak (125,150,80,100)

 
-- 10.Funckija koja vraća informacije u određenom prijevozniku i saznajemo maksimalnu količinu krvi koju je taj prijevoznik dostavio i u koju bolnicu te status glasi zahtjeva "zaprimljen"
DELIMITER // 
CREATE FUNCTION PrijevoznikBolnica (id_p INTEGER) RETURNS VARCHAR (100)
DETERMINISTIC
BEGIN
RETURN (SELECT CONCAT("Ime bolnice: ", b.naziv, "; količina: ", a.kolicina) FROM zahtjev z INNER JOIN bolnica b ON z.id_bolnica = b.id INNER JOIN (
SELECT SUM(kolicina) kolicina, id_prijevoznik FROM zahtjev WHERE status_zahtjeva="Zaprimljen" GROUP BY id_bolnica, id_prijevoznik ORDER BY SUM(kolicina) DESC LIMIT 1) a ON z.id_prijevoznik = a.id_prijevoznik WHERE z.id_prijevoznik = id_p LIMIT 1);
END //
DELIMITER ;

SELECT PrijevoznikBolnica (4)

/*_________________________________________________________ Procedure ____________________________________________________________________*/

-- 1. Pohranjena procedura za krvnu grupu koju određeni pacijent može primiti 
DELIMITER //
CREATE PROCEDURE moguce_krvne_grupe_za_pacijenta (IN id_pacijent_p INTEGER, OUT krvna_grupa_p VARCHAR(20))
BEGIN
	DECLARE krvna_grupa_pacijenta VARCHAR(3);
	SELECT krvna_grupa INTO krvna_grupa_pacijenta FROM pacijent 
    WHERE id = id_pacijent_p;
    IF krvna_grupa_pacijenta = '+A' THEN
		SET krvna_grupa_p = CONCAT('+A,  -A,  -0,  +0');
	ELSEIF krvna_grupa_pacijenta = '-A' THEN
		SET krvna_grupa_p = CONCAT('-A,  -0');
	ELSEIF krvna_grupa_pacijenta = '+B' THEN
		SET krvna_grupa_p = CONCAT('+B,  -B,  -0,  +0');
	ELSEIF krvna_grupa_pacijenta = '-B' THEN
		SET krvna_grupa_p = CONCAT('-B,  -0');
	ELSEIF krvna_grupa_pacijenta = '+AB' THEN
		SET krvna_grupa_p = CONCAT('+A,  -A,  +B,  -B,  +AB,  -AB,  +0,  -0');
	ELSEIF krvna_grupa_pacijenta = '-AB' THEN
		SET krvna_grupa_p = CONCAT('-A,  -B,  -0');
	ELSEIF krvna_grupa_pacijenta = '+0' THEN
		SET  krvna_grupa_p = CONCAT('+0,  -0');
	ELSEIF krvna_grupa_pacijenta = '-0' THEN
		SET krvna_grupa_p = '-0';
	END IF;
END //
DELIMITER ;

CALL moguce_krvne_grupe_za_pacijenta(6, @krvna_grupa);
SELECT @krvna_grupa FROM DUAL;

-- 2. Procedura koja vraća upozorenje da donor ne može prerano donirati krv, ukoliko može, vraća trenutni datum i vrijeme 
DELIMITER //
CREATE PROCEDURE ciklus_darivanja_krvi (IN id_darivatelj_d INTEGER, INOUT datum_i_vrijeme_d DATETIME)
BEGIN
	DECLARE spol_darivatelja CHAR(1);
    DECLARE datum_i_vrijeme_doniranja DATETIME;
	SELECT darivatelj.spol, termin.datum_i_vrijeme INTO spol_darivatelja, datum_i_vrijeme_doniranja FROM termin 
		INNER JOIN darivatelj ON darivatelj.id = termin.id_darivatelj
        WHERE darivatelj.id = id_darivatelj_d ;
    IF spol_darivatelja = 'Ž' AND datum_i_vrijeme_doniranja <= datum_i_vrijeme_doniranja - INTERVAL 4 MONTH THEN
		SET datum_i_vrijeme_d = NOW();
	ELSEIF spol_darivatelja = 'M' AND datum_i_vrijeme_doniranja <= datum_i_vrijeme_doniranja - INTERVAL 3 MONTH THEN
		SET datum_i_vrijeme_d = NOW();
	ELSE 
		SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = 'Donor ne može prerano donirati krv!';
	END IF;
		
END //
DELIMITER ;

CALL ciklus_darivanja_krvi(5, @datum_i_vrijeme_d);

-- 3. Dodjeljivanje nagrade pacijentima s obzirom na njihov broj donacija
DELIMITER //
CREATE PROCEDURE nagrade_za_darivatelje (IN id_darivatelj_d INTEGER, INOUT nagrada VARCHAR(100))
BEGIN
	DECLARE ime_darivatelja VARCHAR(15);
	DECLARE spol_darivatelja CHAR(1);
	DECLARE broj_doniranja INTEGER;
	SELECT spol, COUNT(darivatelj.id) INTO spol_darivatelja, broj_doniranja FROM darivatelj
	INNER JOIN termin ON darivatelj.id = termin.id_darivatelj
    WHERE darivatelj.id = id_darivatelj_d;
	IF spol_darivatelja = 'Ž' AND broj_doniranja = 1 OR broj_doniranja = 5 OR broj_doniranja = 10 OR broj_doniranja = 20 OR broj_doniranja = 25 THEN
		SET nagrada = 'Osvojili ste Zahvalnicu i značku!';
	ELSEIF spol_darivatelja = 'Ž' AND broj_doniranja = 35 THEN
		SET nagrada = 'Osvojili ste Zahvalnicu i mali srebrnjak!';
	ELSEIF spol_darivatelja = 'Ž' AND broj_doniranja = 55 THEN
		SET nagrada = 'Osvojili ste Zahvalnicu i veliki srebrnjak!';
	ELSEIF spol_darivatelja = 'Ž' AND broj_doniranja = 75 THEN
		SET nagrada = 'Osvojili ste Zahvalnicu i zlatni znak!';
	ELSEIF spol_darivatelja = 'Ž' AND broj_doniranja = 100 OR broj_doniranja = 125 OR broj_doniranja = 150 THEN
		SET nagrada = 'Osvojili ste Zahvalnicu za izvanredni uspjeh!';
	ELSEIF spol_darivatelja = 'M' AND broj_doniranja = 1 OR broj_doniranja = 10 OR broj_doniranja = 20 OR broj_doniranja = 30 OR broj_doniranja = 40 THEN
		SET nagrada = 'Osvojili ste Zahvalnicu i značku!';
	ELSEIF spol_darivatelja = 'M' AND broj_doniranja = 50 THEN
		SET nagrada = 'Osvojili ste Zahvalnicu i mali srebrnjak!';
	ELSEIF spol_darivatelja = 'M' AND broj_doniranja = 75 THEN
		SET nagrada = 'Osvojili ste Zahvalnicu i veliki srebrnjak!';
	ELSEIF spol_darivatelja = 'M' AND broj_doniranja = 100 THEN
		SET nagrada = 'Osvojili ste Zahvalnicu i zlatni znak!';
	ELSEIF spol_darivatelja = 'M' AND broj_doniranja = 125 OR broj_doniranja = 150 OR broj_doniranja = 200 THEN
		SET nagrada = 'Osvojili ste Zahvalnicu za izvanredni uspjeh!';
	END IF;
END //
DELIMITER ;
CALL nagrade_za_darivatelje(5, @nagrada); 
SELECT @nagrada FROM DUAL;

-- 4. Procedura za automatsko slanje zahtjeva za određenu krvnu grupu te kolicinu iste
 DELIMITER //
CREATE PROCEDURE status_zahtjeva (INOUT id_bolnica_z INTEGER, OUT krvna_grupa_z VARCHAR(4), OUT kolicina INTEGER)
BEGIN   
	DECLARE kolicina_krvi_A_poz INTEGER;
    DECLARE kolicina_krvi_A_neg INTEGER;
	DECLARE kolicina_krvi_B_poz INTEGER;
    DECLARE kolicina_krvi_B_neg INTEGER;
    DECLARE kolicina_krvi_AB_poz INTEGER;
    DECLARE kolicina_krvi_AB_neg INTEGER;
    DECLARE kolicina_krvi_0_poz INTEGER;
    DECLARE kolicina_krvi_0_neg INTEGER;
	
    DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
		SET kolicina = 0;
        
    SELECT bolnica.zaliha_krvne_grupe_A_poz, bolnica.zaliha_krvne_grupe_A_neg, bolnica.zaliha_krvne_grupe_B_poz, 
    bolnica.zaliha_krvne_grupe_B_neg, bolnica.zaliha_krvne_grupe_AB_poz, bolnica.zaliha_krvne_grupe_AB_neg,
    bolnica.zaliha_krvne_grupe_0_poz, bolnica.zaliha_krvne_grupe_0_neg
	INTO kolicina_krvi_A_poz, kolicina_krvi_A_neg, kolicina_krvi_B_poz, kolicina_krvi_B_neg, kolicina_krvi_AB_poz,
    kolicina_krvi_AB_neg, kolicina_krvi_0_poz, kolicina_krvi_0_neg
	FROM bolnica
	WHERE bolnica.id = id_bolnica_z;

	IF kolicina_krvi_A_poz < 100 THEN
        SET kolicina = 100 - kolicina_krvi_A_poz;
        SET krvna_grupa_z = '+A';
        INSERT INTO zahtjev(id_bolnica, krvna_grupa, kolicina) VALUES(id_bolnica_z, krvna_grupa_z, kolicina);
	ELSEIF kolicina_krvi_A_neg < 100 THEN
        SET kolicina = 100 - kolicina_krvi_A_neg;
        SET krvna_grupa_z = '-A';
        INSERT INTO zahtjev(id_bolnica, krvna_grupa, kolicina) VALUES(id_bolnica_z, krvna_grupa_z, kolicina);
	ELSEIF kolicina_krvi_B_poz < 100 THEN
        SET kolicina = 100 - kolicina_krvi_B_poz;
        SET krvna_grupa_z = '+B';
        INSERT INTO zahtjev(id_bolnica, krvna_grupa, kolicina) VALUES(id_bolnica_z, krvna_grupa_z, kolicina);
	ELSEIF kolicina_krvi_B_neg < 100 THEN
        SET kolicina = 100 - kolicina_krvi_B_neg;
        SET krvna_grupa_z = '-B';
        INSERT INTO zahtjev(id_bolnica, krvna_grupa, kolicina) VALUES(id_bolnica_z, krvna_grupa_z, kolicina);
	ELSEIF kolicina_krvi_AB_poz < 100 THEN
        SET kolicina = 100 - kolicina_krvi_AB_poz;
        SET krvna_grupa_z = '+AB';
        INSERT INTO zahtjev(id_bolnica, krvna_grupa, kolicina) VALUES(id_bolnica_z, krvna_grupa_z, kolicina);
	ELSEIF kolicina_krvi_AB_neg < 100 THEN
        SET kolicina = 100 - kolicina_krvi_AB_neg;
        SET krvna_grupa_z = '-AB';
        INSERT INTO zahtjev(id_bolnica, krvna_grupa, kolicina) VALUES(id_bolnica_z, krvna_grupa_z, kolicina);
	ELSEIF kolicina_krvi_0_poz < 100 THEN
        SET kolicina = 100 - kolicina_krvi_0_poz;
        SET krvna_grupa_z = '+0';
        INSERT INTO zahtjev(id_bolnica, krvna_grupa, kolicina) VALUES(id_bolnica_z, krvna_grupa_z, kolicina);
	ELSEIF kolicina_krvi_0_neg < 100 THEN
        SET kolicina = 100 - kolicina_krvi_0_neg;
        SET krvna_grupa_z = '-0';
        INSERT INTO zahtjev(id_bolnica, krvna_grupa, kolicina) VALUES(id_bolnica_z, krvna_grupa_z, kolicina);
	ELSE 
		SIGNAL SQLSTATE '50000'
        SET MESSAGE_TEXT = 'Bolnica ima dostatnu količinu zaliha krvi.';
	END IF;
END //
DELIMITER ;
SET @id_bolnica_z = 3;
CALL status_zahtjeva(@id_bolnica_z, @krvna_grupa_z, @kolicina);
SELECT @krvna_grupa_z, @kolicina FROM DUAL;

-- 5. Procedura za izračun zaliha krvi u banci krvi nakon zahtjeva za krvi bolnica
 DELIMITER //
CREATE PROCEDURE kolicina_krvi_u_banci_krvi_nakon_transkcija (IN id_zahtjev_b INTEGER, INOUT krvna_grupa VARCHAR(4), OUT kolicina INTEGER, INOUT status_zahtjeva VARCHAR(15))
BEGIN   
	
END //
DELIMITER ;
CALL kolicina_krvi_u_banci_krvi_nakon_transkcija(3, @krvna_grupa, @kolicina, @status_zahtjeva);
SELECT @krvna_grupa, @kolicina, @status_zahtjeva FROM DUAL;
DROP PROCEDURE kolicina_krvi_u_banci_krvi_nakon_transkcija;

-- 6. Automatsko dodijeljivanje vrijednosti atributa 'id_kriterij' u relaciju 'darivatelj' po dobnoj grupi darivatelja 
DELIMITER //
CREATE PROCEDURE ogranicenja_kriterij (IN id_darivatelj INTEGER, OUT ime_darivatelja VARCHAR(20), OUT prezime_darivatelja VARCHAR(20), OUT dob_darivatelja INTEGER, OUT id_kriterij_d INTEGER)
BEGIN
	SELECT ime, prezime, dob INTO ime_darivatelja, prezime_darivatelja, dob_darivatelja
    FROM darivatelj
    WHERE id = id_darivatelj;
    
    IF dob_darivatelja >= 18 AND dob_darivatelja <= 24 THEN
		UPDATE darivatelj SET id_kriterij = 1;
        SET id_kriterij_d = 1;
	ELSEIF dob_darivatelja >= 25 AND dob_darivatelja <= 35 THEN
		UPDATE darivatelj SET id_kriterij = 2;
        SET id_kriterij_d = 2;
	ELSEIF dob_darivatelja >= 36 AND dob_darivatelja <= 45 THEN
		UPDATE darivatelj SET id_kriterij = 3;
        SET id_kriterij_d = 3;
	ELSEIF dob_darivatelja >= 46 AND dob_darivatelja <= 54 THEN
		UPDATE darivatelj SET id_kriterij = 4;
        SET id_kriterij_d = 4;
	ELSEIF dob_darivatelja >= 55 AND dob_darivatelja <= 65 THEN
		UPDATE darivatelj SET id_kriterij = 5;
        SET id_kriterij_d = 5;
	ELSE 
		SIGNAL SQLSTATE '50000'
        SET MESSAGE_TEXT = 'Neispravan unos id darivatelja';
	END IF;
END //
DELIMITER ;
DROP PROCEDURE ogranicenja_kriterij;
CALL ogranicenja_kriterij (33, @ime_darivatelja, @prezime_darivatelja, @dob_darivatelja, @id_kriterij);
SELECT @ime_darivatelja, @prezime_darivatelja, @dob_darivatelja, @id_kriterij FROM DUAL;
SELECT * FROM darivatelj WHERE id = 33;
UPDATE darivatelj SET dob = 18 WHERE id = 33;
-- darivatelj sa id-em 28 mora imati 55 godina i kriterije 5
-- INSERT INTO darivatelj VALUES (38, 2, 'Ana', 'Matošević', '69696969696', 'Ž', STR_TO_DATE('06.12.1995', '%d.%m.%Y.'), 'Aničićev prilaz 5', 'Pula', '099-285-7890', '+A', 60, 59, 36.3, 120, 85, 73, 120);
/*_________________________________________________________ Okidači ______________________________________________________________________*/
