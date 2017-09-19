function [bd, ad] = bpass_dtmf( fc,Fs,Aa,Ap )

%%%%%%%%
% Tacka 2. Projektovanje filtra za zadate gabarite Fs,fc, Aa,Ap
%%%%%%%%

% KORAK 1: Zadavanje gabarita (specifikacija u analognom domenu)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fp1=(fc-10)/Fs;
Fp2=(fc+10)/Fs;
Fp=[Fp1 Fp2];

Fa1=(fc-30)/Fs;
Fa2=(fc+30)/Fs;
Fa=[Fa1 Fa2];

% KORAK 1.1: Racunanje anal. frekvencije i ucestanosti
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ts = 1/Fs;
Wp=2*pi*Fp;
Wa=2*pi*Fa;


% KORAK 2: Zadavanje gabarita u digitalnom domenu, transformacija u digitalni domen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ovaj korak ne treba jel je Fp i Fa vec podeljeni sa Fs tj pomnozeno sa Ts
% wp=Ts*Wp;
% wa=Ts*Wa;

% KORAK 3: Zadavanje gabarita analognog prototipa (predistorzija ucestanosti za BIL transformaciju)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Wpap=(2/Ts)*tan(Wp/2); 
Waap=(2/Ts)*tan(Wa/2);

% KORAK 3.1: Korekcija ucestanosti, posto je transformacija ucestanosti nelinearna
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(Wpap(1)*Wpap(2)>Waap(1)*Waap(2))
    Waap(2)=Wpap(1)*Wpap(2)/Waap(1);
else
    Waap(1)=Wpap(1)*Wpap(2)/Waap(2);
end;


% centralna ucestanost
w0=sqrt(Wpap(1)*Wpap(2));

% KORAK 4: Zadavanje gabarita NF normalizovanog filtra 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Wpn=1;
Wan=(Waap(2)-Waap(1))/(Wpap(2)-Wpap(1));
k = Wpn/Wan;
B=Wpap(2)-Wpap(1);


% KORAK 5: Sinteza normalizovanog NF filtra pomocu aprokcimacija
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D = (10^(0.1*Aa)-1)/(10^(0.1*Ap)-1);
N = ceil( acosh(sqrt(D))/acosh(1/k) );
[z,p,k]=cheb2ap(N,Aa);
ban=k*poly(z);
aan=poly(p);

% KORAK 6: Transformacija normalizovanog NF -> Analogni NF prototip
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[bad,aad]=lp2bp(ban,aan,w0,B);

% KORAK 7: Nule i polovi analognog -> nule i polove digitalnog  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[bd,ad]=bilinear(bad,aad,Fs);

end

