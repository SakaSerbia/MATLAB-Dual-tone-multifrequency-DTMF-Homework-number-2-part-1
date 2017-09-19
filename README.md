# About 
This work present homework number 2, part 1 for the school year 2016/2017 in [Digital Signal Processing](http://tnt.etf.rs/~oe3dos/) in the 3nd year, Department of Electronics, School of Electrical Engineering, University of Belgrade.

# About the homework number 2 in Serbian
Cilj drugog domaćeg zadatka je da studenti samostalno probaju osnovne metode projektovanja IIR filtara i da projektovane filtre iskoriste za filtriranje signala u određenim primerima.

Domaći zadatak se sastoji iz dva dela. Prvi deo domaćeg zadatka se sastoji od projektovanja IIR filtara propusnika opsega kojim se prepoznaje pozvani broj kod dvotonskog signaliziranja. Drugi deo domaćeg zadatka je primena IIR filtra u interpolaciji i promeni učestanosti odabiranja signala prilikom prelaska sa jednog na drugi audio standard. Cilj drugog dela je i da studenti vide kako na spektar utiče promena učestanosti odabiranja.

# Text of the task in Serbian
Dvotonsko signaliriziranje (Dual-tone multifrequency - DTMF) je metod koji se koristi za uspostavljanje veze u fiksnoj telefoniji kod uređaja sa tasterima (tonsko biranje – tone dialing). Tonsko biranje omogućava značajno brže biranje broja od ranije korišćenog pulsnog rotacionog biranja.

DTMF signal se sastoji od sume dve sinusoide različitih učestanosti. Učestanosti su predefinisane, a na slici 1 je prikazano koje učestanosti odgovaraju kom tasteru. Tako na primer, tasteru 1 odgovaraju dve sinusoide gde je jedna učestanosti 697 Hz, a druga 1209 Hz, tasteru 9 odgovaraju učestanosti 852 Hz i 1477 Hz itd. Korisnik prilikom biranja broja, pritiska tastere, a telefon šalje dvo-tonske signale centrali u kojoj se detektuje koji je broj biran. U centrali se radi Short-Time Furijeova transformacija, tj. se signal koji dolazi se seče na delove i za svaki od delova se nezavisno radi DFT. DFT se računa Gercelovim algoritmom. U fajlu koji prati ovaj dokument 031823159.wav je dat primer signala koji ispravan telefon šalje prilikom pozivanja broja iz imena fajla.

![1](https://user-images.githubusercontent.com/16638876/30589922-b94730d4-9d3c-11e7-9ad8-4f56374c1b6d.png)

Međutim, za detekciju koji je broj pritisnut ne mora se raditi DFT. Moguće napraviti banku filtara propusnika opsega sa centralnim učestanostima na 697 Hz, 770 Hz, 852 Hz, 941 Hz, 1209 Hz, 1336 Hz i 1477Hz. Na osnovu toga da li je na izlazu svakog od filtara energija signala usrednjena na određenom broju odbiraka dovoljno velika, zaključuje se da li signal poseduje odgovarajuću frekvencijsku komponentu. Na kraju se postavljanjem praga na određen nivo određuje koji je broj pozvan.

U ovom zadatku je potrebno u MATLAB-u napisati program koji filtrira ulaznu sekvencu tonova na više različitih učestanosti i na osnovu izlaza odgovarajućih filtara detektuje koji je broj pozvan. Program treba da radi za bilo koju ulaznu sekvencu.

1. Učitati signal iz fajla 031823159.wav ili generisati novi proizvoljan signal za tonsko biranje korišćenjem skripte generisanje_signala.m koja se nalazi u direktorijumu deo1. Prikazati vremenski oblik signala. Vremenska osa treba da bude u sekundama.

2. Napisati funkciju [bz, az] = bpass_dtmf(fc, fs, Aa, Ap) kojom se projektuje filtar propusnik opsega učestanosti pogodan za detekciju jedne od mogućih frekvencijskih komponenti u DTMF signalu. Funkcija kao argument prima centralnu učestanost propusnog opsega fc koja može biti jedna od učestanosti sa slike 1, zatim učestanost odabiranja fs i odgovarajuća slabljenja u nepropusnom (αa) i propusnom (αp) opsegu. Kao povratnu vrednost, funkcija vraća koeficijente polinoma u brojiocu i imeniocu prenosne funkcije filtra napisane u z domenu. Navedeni filtar treba da zadovolji sledeće granične relativne učestanosti:

  a. granične učestanosti propusnog opsega: Fp1 = (fc – 10 Hz)/fs i Fp2 = (fc + 10 Hz)/fs,

  b. granične učestanosti nepropusnih opsega: Fa1 = (fc – 30 Hz)/fs i Fp2 = (fc + 30 Hz)/fs.

Za analogni prototip koristiti inverzni Čebiševljev filtar, a za dikretizaciju koristiti bilinearnu transformaciju. Voditi računa o tome da je transformacija učestanosti nelinearna.

3. Korišćenjem funckije bpass_dtmf projektovati filtre kojima se propušta samo opseg oko učestanosti sa slike 1 i generisati izlaze svih navedenih filtara ako se na njihove ulaze dovodi signal iz tačke 1. Nacrtati vremenske oblike izlaznih signala na jednoj slici jedan ispod drugog (koristiti subplot naredbu).

4. Na jednoj slici, različitim bojama nacrtati amplitudske karakteristike svih filtara iz tačke 3. Frekvencijska osa treba da bude u linearnoj razmeri u hercima, a amplitudska u decibelima.

5. Za detekciju sinusoide koja ima jednu od učestanosti sa slike 1, najlakše je posmatrati trenutnu snagu signala na izlazu svakog od 7 filtara iz tačke 3. Usrednjavanjem određenog broja odbiraka Slika 1 - Učestanosti koje odgovaraju različitim tasterima na tastaturi analognog telefona(više od 100) trenutne snage dobija se signal koji se lako može porediti sa nekakvim predefinisanim pragom. Ako je usrednjena trenutna snaga signala na izlazu iz filtra veća od tog praga, onda u tom trenutku postoji spektralna komponenta na centralnoj učestnosti filtra. Nacrtati vremenske oblike trenutne snage izlaznih signala na jednoj slici jedan ispod drugog (koristiti subplot naredbu), a na drugoj slici i usrednjene trenutne snage.

6. Napisati deo programa koji korišćenjem usrednjenih trenutnih snaga signala, određuje koji broj je pozvan za bilo koju sekvencu pritisnutih tastera.

MATLAB skriptu nazvati dtmf_godinaupisa_brojindeksa.m. U kodu komentarima jasno naznačiti koji deo koda se odnosi na koji deo zadatka.

Sve vremenske ose u ovoj tački treba da budu u sekundama. Neophodno je obeležiti sve ose odgovarajućim oznakama/tekstom.

# Some screenshot
![2](https://user-images.githubusercontent.com/16638876/30590124-9a408450-9d3d-11e7-995a-2ac41e23158b.png)

![3](https://user-images.githubusercontent.com/16638876/30590128-9ed7dd10-9d3d-11e7-9c48-6b8968f87588.png)

![4](https://user-images.githubusercontent.com/16638876/30590132-a2c6d48a-9d3d-11e7-85a0-ba5cc6b43557.png)

![5](https://user-images.githubusercontent.com/16638876/30590134-a66b5e76-9d3d-11e7-8d99-f80cc4c3548b.png)
