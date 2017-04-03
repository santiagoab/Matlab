function [RevTime,DistCrit,splDir,splRev,splTot,splGlob,splGlobPond] = RoomAcousticsCalculator
%%Acústica Arquitectònica
%
%% Paràmetres d'entrada
%% Freqüència a la que treballem
% Amb valors de 125, 250, 500, 1000, 2000, 4000 Hz
f = 1000;

%% Paràmetres d'entrada
%% MIDES SALA
Altura = 3;     	% m
Profunditat = 10;   % m
Amplada = 5;    	% m
S_Porta = 2.5;  	% m2
S_Finestra_1 = 4;   % m2
S_Finestra_2 = 4;   % m2
S_Butaques = 3; 	% m2
N_Butaques = 20;	% Num butaques
%% Paràmetres ambientals
Temp = 20;  	% ºC
Hum = 40;   	% (%)
%% PARÀMETRES ACÚSTICS
P_Font = 30;	% Wac
Q = 4;      	% Factor directivitat
P_Orador = [1 2.5 1];   % Posició orador
P_Receptor =   [8 2.5 1.8]; % Posició receptor
%% Coeficients absorció
F_O =[0 125 250 500 1000 2000 4000];
for i = 2:7
	if f > F_O(i-1) && f <= F_O(i)
    	j = i-1;
    	break
	end
end
% Material Acústic
M_Ac = [0.70 0.66 0.72 0.92 0.88 0.75];
% Guix
M_Gx = [0.02 0.03 0.04 0.05 0.04 0.03];
% Parquet
M_Pq = [0.04 0.04 0.07 0.06 0.06 0.07];
% Cortina
M_Ct = [0.07 0.31 0.49 0.75 0.70 0.60];
% Totxo
M_Tx = [0.36 0.44 0.31 0.29 0.39 0.25];
% Vidre
M_Vd = [ 0.35 0.25 0.18 0.12 0.07 0.04];
% Fusta
M_Ft = [ 0.28 0.22 0.17 0.09 0.10 0.11];
% Cadira tapissada (no ocupada)
M_Rb = [0.2 0.401 0.604 0.771 0.6 0.6];
CA_S =  M_Ac;    	%c.a sostre
CA_T =  M_Pq;    	%c.a terra
CA_P_L_1 = M_Gx; 	%c.a paret lateral 1
CA_P_L_2 = M_Ct; 	%c.a paret lateral 2
CA_P_F = M_Tx;   	%c.a paret frontal
CA_P_D = M_Gx;   	%c.a paret darrere
CA_F_1 = M_Vd;   	%c.a finestra 1
CA_F_2 = M_Vd;   	%c.a finestra 2
CA_P = M_Ft;     	%c.a porta
CA_B = M_Rb ;    	%c.a butaques


%% CÀLCULS
%
Volume = Altura*Profunditat*Amplada;
%Superfícies
S_Sostre = Profunditat*Amplada;    %sostre
S_Terra = (Profunditat*Amplada)-(N_Butaques*S_Butaques);    %terra
S_P_L_1 = (Altura*Profunditat)-S_Finestra_1-S_Finestra_2;     %paret lateral 1
S_P_L_2 = (Altura*Profunditat)-S_Porta;    %paret lateral 2
S_P_F = Altura*Amplada;    	%paret frontal
S_P_D = Altura*Amplada;    	%paret darrere

%% Coef. Absorció total
Absorption = (CA_S(j)*S_Sostre)+(CA_T(j)*S_Terra)+(CA_P_L_1(j)*S_P_L_1)+(CA_P_L_2(j)*S_P_L_2)+(CA_P_F(j)*S_P_F)+(CA_P_D(j)*S_P_D)+(CA_F_1(j)*S_Finestra_1)+(CA_F_2(j)*S_Finestra_2)+(CA_P(j)*S_Porta)+(CA_B(j)*(N_Butaques*S_Butaques));

%% Càlcul Rev Time
C = 331.4 + 0.6*Temp+0.012*Hum; % Velocitat aire
RevTime = (24*log(10)/C)*(Volume/Absorption);
%% Càlcul Distància crítica
DistCrit = sqrt(24*log(10)*Volume/16*pi*C*RevTime);
%% Càlcul dB SPL
p0 = 2*10^-5;   % Pressió límit
Abs_p = 101325; % Pressió absoluta
R_spe = 287.058; % R específic aire (J/(kg*K)
K_to_C = 273.15; % Passar de Kelvin a Celsius
p_air = Abs_p / (R_spe * (Temp+ K_to_C) );  % Càlcul pressió de l'aire
pc = C * p_air;  % Càlcul Rayls
R = sqrt((P_Orador(1) - P_Receptor(1))^2+(P_Orador(2)-P_Receptor(2))^2 + (P_Orador(3) - P_Receptor(3))^2);
% SPL Directe
splDir = 10*log10((P_Font*pc*(Q/(4*pi*(R^2))))/p0^2);
% SPL Reverberant
RR = Absorption/(1-(CA_S(j))+(CA_T(j))+(CA_P_L_1(j))+(CA_P_L_2(j))+(CA_P_F(j))+(CA_P_D(j))+(CA_F_1(j))+(CA_F_2(j))+(CA_P(j))+(CA_B(j)*(N_Butaques)));
splRev = 10*log10((P_Font*pc*4/RR)/p0^2);
% SPL Global
splGlob = 10*log10((P_Font*pc*( (Q/(4*pi*(R^2))) + (4/RR)))/p0^2);



end


