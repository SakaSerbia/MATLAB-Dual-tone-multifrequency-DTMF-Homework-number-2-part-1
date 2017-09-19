clear all
close all 
clc
%%%%%%%%
% Tacka 1. Ucitavanje nepoznatog signala
%%%%%%%%

%nepoznati_broj_1 - 00
%nepoznati_broj_2 - 009
%nepoznati_broj_3 - 00090
%nepoznati_broj_4 - 03182315
%nepoznati_broj_5 - 9909999
%nepoznati_broj_6 - 031823159
%nepoznati_broj_7 - 00880413818808

[x, Fs] = audioread('nepoznati_broj_7.wav');
%Dodajemo nule u x signal kako bi signal trajao 16*N*225, N prestavlja broj
%pritisnutih tastera. Ovo nam je bitno da bi mogli tacno da izanaliziramo signal

x = x';
x = [x, zeros(1, ceil(length(x)/3600)*3600-length(x))];
x = x';

t=1/Fs:1/Fs:length(x)/Fs;
figure(1)
plot(t,x);
title('Nepoznati signal koji je generisao telefon');
xlabel('t(s)'); ylabel('x(t)[V]');

%%%%%%%%
% Tacka 2. bpass_dtmf
%%%%%%%%

%Napravili smo funkciju bpass_dtmf prema zadatim specifikacijama koju cemo
%kasnije koristiliti za filtriranje

%%%%%%%%
% Tacka 3. Filtriramo ucitan signal
%%%%%%%%

w_tehnologija = [697 770 852 941 1209 1336 1477];
Aa=40;
Ap=1;
figure;
snaga = zeros(length(x), 7);
index = 1;
b = zeros(7,9);
a = zeros(7,9);
for k = 1:7
    [b(index,:),a(index,:)] = bpass_dtmf(w_tehnologija(k), Fs, Aa, Ap);
  
    h = filter (b(index,:), a(index,:), x);
    index = index+1;
    snaga(:, k) = h;
    snaga(:, k) = snaga(:, k).*snaga(:,k);
    
   
%     [H,w]=freqz(b,i,4096);
% 
%    
%     plot(w/2/pi*fs,20*log10(abs(H)))
    hold on
    subplot(7,1,k)
    plot (t, h);
    xlabel('t[s]'); ylabel('x(t)[V]')
    title (['signal na izlazu filtra PO oko' num2str(w_tehnologija(k)) 'Hz']);
    grid on;
end;

% impuls =[1 zeros(1,1000)]; % I onda koristio funkciju 
% 
[bi,ai] = bpass_dtmf(w_tehnologija(3), Fs, Aa, Ap);
impuls=[1 zeros(1,length(x)-1)];
yi=filter(bi,ai,impuls);

figure;
plot(t,yi),title('Impulsni odziv filtra PO fc=852Hz'); 
xlabel('t[s]'); ylabel('impuls(t)[V]');

%pole zero map
figure;
[hz2, hp2, ht2] = zplane(bi,ai); 
set(findobj(hz2, 'Type', 'line'), 'LineWidth', 3, 'MarkerSize',12);
set(findobj(hp2, 'Type', 'line'), 'LineWidth', 3, 'MarkerSize',12);
title('Raspored nula i polova')
xlabel('Re(z)');
ylabel('Im(z)');




%%%%%%%%
% Tacka 4. Amplitudske karakretistike svih filtara
%%%%%%%%

figure;
for index=1:7
    [h, w] = freqz(b(index,:), a(index,:), 4096);
    H = abs(h);
    F=w*Fs/(2*pi);
    plot(F, 20*log10(H));
    title('Amplitudske karakteristike projektovanih filtara');
    xlabel('F[Hz]');
    ylabel('|X|[dB]');
    hold all
    grid on
end;

%%%%%%%%
% Tacka 5. Filtriramo ucitan signal
%%%%%%%%

% imam sacuvanu trenutnu snagu svakog filtra u matrici snaga, a treba nam
% usrednjena snaga. Usrednjavacemo svakih 3600 odbiraka, jer nam toliko
% traje svaki ton

%Kako smo u tacki 3 odredili trenutne vrednosti snaga i sacuvali ih u
%matrici snaga sad ih kroz jednu for petlju iscrtavamo jedan ispod drugog
%kao sto smo radili u primerima iznad

figure;
for k = 1:7
    subplot(7,1,k);
    plot(t, snaga(:,k));
    title('Trenutna snaga signala na izlazu iz filtra');
    xlabel('t[s]');
    ylabel('P[W]');
end


p1 = snaga(:,1); p2 = snaga(:,2); p3 = snaga(:,3); p4 = snaga(:,4); 
p5 = snaga(:,5); p6 = snaga(:,6); p7 = snaga(:,7);

%Kao sto je gore objasnjeno duzina x signala je N*16*225
brojTastera = ceil(length(x)/3600);
p01 = 0; p02 = 0; p03 = 0; p04 = 0; p05 = 0; p06 = 0; p07 = 0;

for a = 1:brojTastera
p01 = 0; p02 = 0; p03 = 0; p04 = 0; p05 = 0; p06 = 0; p07 = 0;
    for k=1:3600; 
        %Uzimamo svaki 3600 odbirak
        u=(a-1)*3600;
        p01 = p01+p1(u+k);
        p02 = p02+p2(u+k);
        p03 = p03+p3(u+k);
        p04 = p04+p4(u+k);
        p05 = p05+p5(u+k);
        p06 = p06+p6(u+k);
        p07 = p07+p7(u+k);
    end;
    p1(((a-1)*3600+1):a*3600)=p01/3600;
    p2(((a-1)*3600+1):a*3600)=p02/3600;
    p3(((a-1)*3600+1):a*3600)=p03/3600;
    p4(((a-1)*3600+1):a*3600)=p04/3600;
    p5(((a-1)*3600+1):a*3600)=p05/3600;
    p6(((a-1)*3600+1):a*3600)=p06/3600;
    p7(((a-1)*3600+1):a*3600)=p07/3600;
 
end;


figure
subplot(7,1,1); plot(t, p1); 
title('Srednja snaga signala na izlazu iz filtra');
xlabel('t[s]'); ylabel('P[W]');
subplot(7,1,2); plot(t, p2); 
title('Srednja snaga signala na izlazu iz filtra');
xlabel('t[s]'); ylabel('P[W]');
subplot(7,1,3); plot(t, p3); 
title('Srednja snaga signala na izlazu iz filtra');
xlabel('t[s]'); ylabel('P[W]');
subplot(7,1,4); plot(t, p4); 
title('Srednja snaga signala na izlazu iz filtra');
xlabel('t[s]'); ylabel('P[W]');
subplot(7,1,5); plot(t, p5); 
title('Srednja snaga signala na izlazu iz filtra');
xlabel('t[s]'); ylabel('P[W]');
subplot(7,1,6); plot(t, p6);
title('Srednja snaga signala na izlazu iz filtra');
xlabel('t[s]'); ylabel('P[W]');
subplot(7,1,7); plot(t, p7); 
title('Srednja snaga signala na izlazu iz filtra');
xlabel('t[s]'); ylabel('P[W]');
    
%%%%%%%%
% Tacka 6. Odredjujemo koji je broj pozvan
%%%%%%%%

prag = 0.14;

for a=1:brojTastera
    if (p1((a*3600)-1800)>prag)
        if (p5((a*3600)-1800)>prag)
        brojTelefona(a) = '1';
        end;
        if (p6((a*3600)-1800)>prag)
        brojTelefona(a) = '2';
        end;
        if (p7((a*3600)-1800)>prag)
        brojTelefona(a) = '3';
        end;
    end;
    if (p2((a*3600)-1800)>prag)
        if (p5((a*3600)-1800)>prag)
        brojTelefona(a) = '4';
        end;
        if (p6((a*3600)-1800)>prag)
        brojTelefona(a) = '5';
        end;
        if (p7((a*3600)-1800)>prag)
        brojTelefona(a) = '6';
        end;
    end;
     
    if (p3((a*3600)-1800)>prag)
        if (p5((a*3600)-1800)>prag)
        brojTelefona(a) = '7';
        end;
        if (p6((a*3600)-1800)>prag)
        brojTelefona(a) = '8';
        end;
        if (p7((a*3600)-1800)>prag)
        brojTelefona(a) = '9';
        end;
    end;
     
    if (p4((a*3600)-1800)>prag)
        if (p5((a*3600)-1800)>prag)
        brojTelefona(a) = '*';
        end;
        if (p6((a*3600)-1800)>prag)
        brojTelefona(a) = '0';
        end;
        if (p7((a*3600)-1800)>prag)
        brojTelefona(a) = '#';
        end;
    end;
end;
     
disp(['Broj telefona je:  ', brojTelefona]); 
    
    
