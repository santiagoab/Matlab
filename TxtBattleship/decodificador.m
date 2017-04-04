C = '043423303AFE482B1CE7C0B3363CDC04';
L = length(C);

B1_b = C(1:L/4);
B2_b = C(L/4 + 1:2*L/4);
B3_b = C(2*L/4 + 1:3*L/4);
B4_b = C(3*L/4 + 1:L);

D1 = dec2bin(hex2dec(B1_b), 32);
D2 = dec2bin(hex2dec(B2_b), 32);
D3 = dec2bin(hex2dec(B3_b), 32);
D4 = dec2bin(hex2dec(B4_b), 32);

D = [D1(3:length(D1)) D2(3:length(D2))  D3(3:length(D3))  D4(3:length(D4)) ];


%1r Barco 4 caselles
B_4_duplicat = [D(1) '---' D(2:5)];
B_4 = [bin2dec(D(2:5)) bin2dec(D(6:9))];     %Vaixell de 4
B_4_Pos = D(10:15);


% Barco 3 caselles
B_3_1       = [bin2dec(D(16:19))    bin2dec(D(20:23))];
B_3_1_Pos   = D(24:27);

B_3_2       =     [bin2dec(D(28:31))     bin2dec(D(32:35))];
B_3_2_Pos   = D(36:39);


% Vaixells de 2
B_2_1_duplicat = [D(40) '---' D(41:44)];
B_2_1       = [bin2dec(D(41:44)) bin2dec(D(45:48))];
B_2_2_Pos   = D(49:50);

B_2_2_duplicat = [D(51) '---' D(52:55)];
B_2_2 = [bin2dec(D(52:55)) bin2dec(D(56:59))];
B_2_2_Pos = D(60:61);

B_2_2_duplicat = [D(62)     '---'   D(63:66)];
B_2_3 = [bin2dec(D(63:66)) bin2dec(D(67:70))];
B_2_3_Pos = D(71:72);

% Vaixells de 1
B_1_1_Casella =   (D(73:80));
B_1_1_Num     =   bin2dec(D(81:84));

B_1_2_Casella =   (D(85:92));
B_1_2_Num     =   bin2dec(D(93:96));

B_1_3_Casella =   (D(97:104));
B_1_3_Num     =   bin2dec(D(105:108));

B_1_4_Casella =   (D(109:116));
B_1_4_Num     =   bin2dec(D(117:120));

