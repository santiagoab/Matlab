C = 'E9E2B09493AE222D254713D38B524527';
L = length(C);

B1 = C(1:L/4);
B2 = C(L/4 + 1:2*L/4);
B3 = C(2*L/4 + 1:3*L/4);
B4 = C(3*L/4 + 1:L);

D1 = dec2bin(hex2dec(B1), 32);
D2 = dec2bin(hex2dec(B2), 32);
D3 = dec2bin(hex2dec(B3), 32);
D4 = dec2bin(hex2dec(B4), 32);

D = [D1 D2 D3 D4];


Max_errors = 12;
Seccio = floor(length(D)/Max_errors);
Num_errors = 0;
for i= 1:Seccio:length(D)
    R = round(rand*11 + 1);

    if D(i+R) == 1
        D(i+R) = '0';
    else
        D(i+R) = '1';
    end
    Num_errors = Num_errors + 1;
    if Num_errors == 12
        break
    end
end


L = length(D);

B1 = D(1:L/4);
B2 = D(L/4 + 1:2*L/4);
B3 = D(2*L/4 + 1:3*L/4);
B4 = D(3*L/4 + 1:L);


C = [dec2hex(bin2dec(B1),8) dec2hex(bin2dec(B2),8) dec2hex(bin2dec(B3),8) dec2hex(bin2dec(B4),8)];

