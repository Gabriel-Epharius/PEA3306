clear all;

S = 2000;
V1_nom = 230;
V2_nom = 115;
a = V1_nom/V2_nom;
I1_nom = S/V1_nom;
I2_nom = S/V2_nom;

%ENSAIOS
V1 = 115;
I1 = 0.45;
W1 = 30;
V2 = 13.2;
I2 = 8.869;
W2 = 20.1;



%%ENSAIO VAZIO - BAIXA TENSÃO (V2 = V2_nom)
phi0 = acos(W1/(V1*I1));

rp = V1/(I1*cos(phi0));
xm = j*V1/(I1*sin(phi0));

%RESPOSTA 1
Im = abs(V1/xm);

%%ENSAIO CURTO - ALTA TENSÃO (I1 = I1_nom)

Zcc_abs = V2/I2;
Rcc = W2/(I2^2);
Xcc = sqrt(Zcc_abs^2 - Rcc^2);
Zcc = Rcc + j*Xcc;

