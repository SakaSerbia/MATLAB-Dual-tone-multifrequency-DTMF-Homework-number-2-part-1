%%%%%%%%
% Stefan Tesanovic, OE 675/2016
%%%%%%%%
% Bazirano na kodu asistenta prilozenog uz 2. domaci zadatak, skolska 2016/2017.
%%%%%%%%


clear all
close all
clc



disp('Unesi broj telefona za koji zelis da generises DTMF signal.')
disp('Dozvoljeno je uneti samo brojeve od 0 do 9')
prompt = 'Tvoj broj je: ';
strNumber = input(prompt,'s');
number = strNumber - '0';

tone_duration = 0.3;
fs = 8000;


frequency_pairs = zeros(length(number),2);

for i = 1:length(number)
    
    if (number(i)==1)
        frequency_pairs(i,1)=697/fs;
        frequency_pairs(i,2)=1209/fs;
    end;
    if (number(i)==2)
        frequency_pairs(i,1)=697/fs;
        frequency_pairs(i,2)=1336/fs;
    end;
    if (number(i)==3)
        frequency_pairs(i,1)=697/fs;
        frequency_pairs(i,2)=1477/fs;
    end;
    
    if (number(i)==4)
        frequency_pairs(i,1)=770/fs;
        frequency_pairs(i,2)=1209/fs;
    end;
    
    if (number(i)==5)
        frequency_pairs(i,1)=770/fs;
        frequency_pairs(i,2)=1336/fs;
    end;
    
    if (number(i)==6)
        frequency_pairs(i,1)=770/fs;
        frequency_pairs(i,2)=1477/fs;
    end;
    
    if (number(i)==7)
        frequency_pairs(i,1)=852/fs;
        frequency_pairs(i,2)=1209/fs;
    end;
    
    if (number(i)==8)
        frequency_pairs(i,1)=852/fs;
        frequency_pairs(i,2)=1336/fs;
    end;
    
    if (number(i)==9)
        frequency_pairs(i,1)=852/fs;
        frequency_pairs(i,2)=1477/fs;
    end;
    
    if (number(i)==(-6)) % '*'-'0'=-6
        frequency_pairs(i,1)=941/fs;
        frequency_pairs(i,2)=1209/fs;
    end;
        
    if (number(i)==0)
        frequency_pairs(i,1)=941/fs;
        frequency_pairs(i,2)=1336/fs;
    end;
        
    if (number(i)==(-13)) % '#'-'0'=-13
        frequency_pairs(i,1)=941/fs;
        frequency_pairs(i,2)=1477/fs;
    end;
    
    
end;

                
%amplitude spektralnih komponenti
A1 = 1;
A2 = 1;


x = zeros(1,length(number)*(tone_duration*fs));

for i = 0:length(number)-1
    index1 = int32(1.5*i*tone_duration*fs+1);
    index2 = int32((1.5*i+1)*tone_duration*fs);
    n = double(1:index2 - index1 + 1);
    x(index1:index2) = A1*cos(2*pi*frequency_pairs(number(i+1)+1,1)*n) + A2*cos(2*pi*frequency_pairs(number(i+1)+1,2)*n);
end

fileName=[strNumber,'.wav'];
wavwrite(x,fs,fileName);







