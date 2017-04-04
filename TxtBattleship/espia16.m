function  C  = espia16( filename )
file = fileread(filename);  % Llegim l'arxiu
grid = strsplit(file,'\n'); % Separem cada vaixell
grid = grid(1:10);

for i = 1:length(grid)      %Passem per tots els valors del fitxer
    v = (grid(i));          %Lleigim el primer vaixell
    v = strsplit(v{1},'-'); %ens quedem només amb les lletres i numeros
    n = 1;
    for j = 1:length(v)     %Passem per les caselles de cada vaixell
        pos = cell2mat( v(j) );%Canviem el format perquè el poguem llegir
        Lletra = int8(pos(1))-64;%passem la lletra a decimal
        Numero = str2num(pos(2:end));%Agafem tots els valors després de la lletra, que seràn els numeros
        Taula(i,n)=Lletra;
        n=n+1;
        Taula(i,n)=Numero;
        n=n+1;
        
    end
end

[Vaixells Posicions] = size(Taula);   
n=0;
for i = 1:Vaixells
    for n =0:2:4
        if Taula(i,8-n)==0 && Taula(i,7-n)==0
            Taula(i,8-n)= -1;
            Taula(i,7-n)= -1;
        else
            if Taula(i,5-n)==Taula(i,7-n)
                Taula(i,7-n)=1;
                if Taula(i,8-n)<Taula(i,6-n)
                    Taula(i,8-n)=1;
                else
                    Taula(i,8-n)=0;                
                end
            end
            if Taula(i,6-n)==Taula(i,8-n)
                Taula(i,7-n)=0;
                if Taula(i,7-n)<Taula(i,5-n)
                    Taula(i,8-n)=1;
                else
                    Taula(i,8-n)=0;                
                end
            end
        end
   end
end

%% Passem a binari
Binary = [];
for i = 1:Vaixells
    for j = 1:Posicions
        if Taula(i,j) >= 1 && (j == 2 || j == 1)
            bin = dec2bin(Taula(i,j),4);
            Binary = [Binary bin];
        end
        if Taula(i,j) == 0 & j > 2
            bin = dec2bin(Taula(i,j));
            Binary = [Binary bin];
        end
        if Taula(i,j) == 1 & j > 2
            bin = dec2bin(Taula(i,j));
            Binary = [Binary bin];
        end
        if Taula(i,j) > 1 && (j > 2)
            Taula(i,j) = 0;
            bin = dec2bin(Taula(i,j));
            Binary = [Binary bin];
        end
        if Taula(i,j) <0
            break
        end
    end
end
  
%% Passem a hexadecimal
b1 = Binary(1:14);   %Vaixell de 4
b2 = Binary(15:26);  %1r vaixell de 3
b3 = Binary(27:38);  %2n vaixell de 3
b4 = Binary(39:48);  %1r vaixell de 2
b5 = Binary(49:58);  %2n vaixell de 2
b6 = Binary(59:68);  %2n vaixell de 2
b7 = Binary(69:76);  %1r vaixell de 1
b8 = Binary(77:84);  %2n vaixell de 1
b9 = Binary(85:92);  %3r vaixell de 1
b10 = Binary(93:100);%4t vaixell de 1

% Dupliquem els bits de la lletra dels vaixells d'una casella
b7b = [];
b8b = [];
b9b = [];
b10b = [];
    for n = 1:4
        b7b = [b7b b7(n) b7(n)];
        b8b = [b8b b8(n) b8(n)];
        b9b = [b9b b9(n) b9(n)];
        b10b = [b10b b10(n) b10(n)];
    end
  b7 = [b7b b7(5:length(b7))];
  b8 = [b8b b8(5:length(b8))];
  b9 = [b9b b3(5:length(b9))];
  b10 = [b10b b4(5:length(b10))];
% teniem 128 - 100 = 28 bits
% 6 bits no els fem servir per si de cas 28 - 6 = 22
% ens queden 22 - 16 = 6 bits
% Posem un bit de més a la primera lletra de cada vaixell dels que queden, excepte els de 3:
b1 = [b1(1) b1];    %Vaixell de 4
b4 = [b4(1) b4];    %Vaixell de 2
b5 = [b5(1) b5];    %Vaixell de 2
b6 = [b6(1) b6];    %Vaixell de 2

Bin = [b1 b2 b3 b4 b5 b6 b7 b8 b9 b10];
L = length(Bin);

B1=Bin(1:L/4);
B2=Bin(1*L/4+1:L/2);
B3=Bin(L/2+1:3*L/4);
B4=Bin(3*L/4+1:length(Bin));

C = [dec2hex(bin2dec(B1),8) dec2hex(bin2dec(B2),8) dec2hex(bin2dec(B3),8) dec2hex(bin2dec(B4),8)];

end

