%%%/////////////////////////////////////////////////////////////////////////////
%%%         EC1 - PEA3306 - 23/05/2021 - TRANSFORMADORES
%%%     
%%%      11325312 Felipe Daniel Rodrigues Marques
%%%      10335020 Gabriel Moraes da Cruz
%%%      11261909 Jorge Henrique Losso Giglio
%%%      11347241 Lucas Chequer Pecin
%%%       
%%%         FATOR DE POT�NCIA DA CARGA: 0,6 CAPACITIVO
%%%
%%%         VARI�VEIS
%%%
%%%         Pv - Pot�ncia em vazio (W)
%%%         Vv - Tens�o em vazio (V)
%%%         Iv - Corrente em vazio (A)
%%%         Rp - Resist�ncia de perdas (ohms)
%%%         Xm - Reat�ncia de magnetiza��o (ohms)
%%%         Pcc - Pot�ncia em curto-circuito (W)
%%%         Vcc - Tens�o em curto-circuito (V)
%%%         Icc - Corrente em curto-circuito (A)
%%%         zcc - Imped�ncia de curto-circuito (ohms)
%%%         rcc - Resist�ncia de curto-circuito (ohms)
%%%         xcc - Reat�ncia de curto-circuito (ohms)
%%%         V1 - Tens�o no prim�rio (V)
%%%         V2 - Tens�o no secund�rio (V)
%%%         Ip - Corrente de perdas no ferro (A)
%%%         Im - Corrente de magnetiza��o (A)
%%%         a - Rela��o de transforma��o
%%%         fp - Fator de pot�ncia
%%%         r1 - Resist�ncia de perdas na AT (ohms)
%%%         x1 - Reat�ncia de perdas na AT (ohms)
%%%         r2 - Resist�ncia de perdas na BT (ohms)
%%%         x2 - Reat�ncia de perdas na BT (ohms)
%%%         Pu - Pot�ncia �til (W)
%%%         Pt - Pot�ncia total (W)
%%%         Pfe - Perdas no ferro (W)
%%%         Pj - Perdas joule (W)
%%%         n - Rendimento
%%%         R - Regula��o
%%%         Pn - Pot�ncia nominal (VA)
%%%         In1 - Corrente nominal no prim�rio (A)
%%%         In2 - Corrente nominal no secund�rio (A)
%%%         r_at - Resist�ncia referida a alta tens�o (ohms)
%%%         x_at - Reat�ncia de magnetiza��o referida a alta tens�o (ohms)
%%%         r_bt - Resist�ncia referida a baixa tens�o (ohms)
%%%         x_bt - Reat�ncia de magnetiza��o referida a baixa tens�o (ohms)
%%%         V_at - Tens�o referida a alta tens�o (V)
%%%         V_bt - Tens�o referida a baixa tens�o (V)
%%%         I_at - Corrente referida a alta tens�o (A)
%%%         I_bt - Corrente referida a baixa tens�o (A)
%%%         E1 - Tens�o no ramo de perdas do n�cleo (V)
%%%         E2 - Tens�o no ramo de perdas do ferro (V)
%%%         i - Contador
%%%         b - Contador
%%%
%%%
%%%/////////////////////////////////////////////////////////////////////////////
clear; clf;
nusp = 11325312;
grupo = 52;
Pv = 8140;
Vv = 3810;
Iv = 9.86;
Pcc = 8890;
Vcc = 854;
Icc = 131;
V1 = 19100;
V2 = 3810;
a = V1/V2;
fp = 0.6;
Pn = 2500000;
In1 = Pn/V1;
In2 = Pn/V2;

%%%/////////////////////////////////////////////////////////////////////////////
%%%                        C�LCULO DOS PAR�METROS
%%%/////////////////////////////////////////////////////////////////////////////
cos_phi = Pv/(Vv*Iv);
phi = acos(Pv/(Vv*Iv));
sin_phi = sin(phi);
Rp = Vv/(Iv*cos_phi);
Xm = Vv/(Iv*sin_phi);
Ip = Vv/Rp;
Im = sqrt((Iv^2) - (Ip^2));

zcc = Vcc/Icc;
rcc = Pcc/(Icc^2);
xcc = sqrt((zcc^2) - (rcc^2));

cos_pcc = rcc/zcc;
fase_zcc = acos(cos_pcc);

I_alta = In1;
V2Linha = V1;
I2Linha = I_alta;

V = V2Linha + I_alta*(cos(fase_zcc)-1i*sin(fase_zcc))*(rcc+j*xcc);
Relu = (abs(V)/V1) - 1;

Zeq_perdas = 1/(1/Rp + 1/(1i*Xm))*a**2; % Já refletido para a  alta tensão.
I0 = V1/Zeq_perdas;
I1 = I2Linha + I0;

%%%/////////////////////////////////////////////////////////////////////////////
%%%                          PAR�METROS NA AT
%%%/////////////////////////////////////////////////////////////////////////////
r1 = r2linha = rcc/2;
x1 = x2linha = xcc/2;


%%%/////////////////////////////////////////////////////////////////////////////
%%%                          PAR�METROS NA BT
%%%/////////////////////////////////////////////////////////////////////////////
r2 = rcc/(2*(a^2));
x2 = xcc/(2*(a^2));


%%%/////////////////////////////////////////////////////////////////////////////
%%%          C�LCULO DE TENS�ES E CORRENTES REFLETIDAS A ALTA TENS�O
%%%/////////////////////////////////////////////////////////////////////////////
r_at = r1;
x_at = x1;
V_at = V1;
E1 = Vv;
I_at = (V1 - E1)/(r1 + 1i*x1);

%%%/////////////////////////////////////////////////////////////////////////////
%%%          C�LCULO DE TENS�ES E CORRENTES REFLETIDAS A BAIXA TENS�O
%%%/////////////////////////////////////////////////////////////////////////////
r_bt = (a^2)*r2;
x_bt = (a^2)*x2;
V_bt = a*V2;
I_bt = Pn/V_bt;
E2 = E1;

%%%/////////////////////////////////////////////////////////////////////////////
%%%                          C�LCULO DE POT�NCIAS
%%%/////////////////////////////////////////////////////////////////////////////
Pu = Vcc*Icc*fp;
Pfe = ((abs(V)/V1)^2)*(Pv*(1 - Relu));
Pj = Pcc;
Pt = Pu + Pfe + Pj;


%%%/////////////////////////////////////////////////////////////////////////////
%%%                              RENDIMENTO
%%%/////////////////////////////////////////////////////////////////////////////
rendimento = ((V2Linha*abs(I2Linha))/(V2Linha*abs(I2Linha)+ abs(Pj)+Pfe));

i = 1;
for porcentoDaNominal = 0.3:0.1:1.3
    vetorPorcentagens(i) = porcentoDaNominal;  % Vetor com porcentagens da nominal. Vai de 0,3 a 1,3 variando de 0.1 por passo.
    In1 = (porcentoDaNominal*Pn)/V1;           % Calculo da corrente nominal do primario na determinada porcentagem de carga.
    In2 = (porcentoDaNominal*Pn)/V2;           % Calculo da corrente nominal do secundario na determinada porcentagem de carga.
    
    I_alta_unitario(i) = In1;                % Calculo da corrente refletida ao lado da alta tensao com carga unitaria.
    I_alta_capacitivo(i) = In1*(acos(0.6)-1i*acos(0.6));
    V2Linha = V1;
    I2Linha = I_alta_unitario(i);
    I2Linha_capacitivo = I_alta_capacitivo(i);

    
    V0_total(i) = V2Linha + I_alta_unitario(i)*(1i*xcc + rcc)/2;
    I0_total(i) = V0_total(i)/Zeq_perdas;
    V_total(i) = V2Linha + I_alta_unitario(i)*(1i*xcc + rcc)/2 + I0_total(i)*(1i*xcc + rcc)/2;
    
    I1_total(i) = I0_total(i) + I_alta_unitario(i);
    
    V_capacitivo(i) = V2Linha + I_alta_capacitivo(i)*(1i*xcc + rcc);
    I0_capacitivo(i) = V0_total(i)/Zeq_perdas;
    V0_capacitivo(i) = V2Linha + I_alta_capacitivo(i)*(1i*xcc + rcc)/2 + I0_capacitivo(i)*(1i*xcc + rcc)/2;
    
    I1_capacitivo(i) = I0_capacitivo(i) + I_alta_capacitivo(i);
    
    
    Pfe = abs((V_total(i)^2)/Rp); 
    Pfe_capacitivo = abs((V_capacitivo(i)^2)/Rp); 
    Pcu = (r1 + r2)*(I2Linha^2); 
    Pcu_capacitivo = abs((r1 + r2)*(I2Linha_capacitivo^2));
      
    P_unitario = a*V2*I2Linha;
    P_capacitivo = a*V2*abs(I2Linha_capacitivo)*0.6;

    rendimentos_unitario(i) = 100*(P_unitario/(P_unitario + Pfe + Pcu));
    rendimentos_capacitivo(i) = 100*(P_capacitivo/(P_capacitivo + Pfe_capacitivo + Pcu_capacitivo));
    regulacoes_unitario(i) = 100*((abs(V_total(i))-V2Linha)/V2Linha);
    regulacoes_capacitivo(i) = 100*abs(((abs(V_capacitivo(i))-V2Linha)/V2Linha));
    i = i+1;
endfor



%%%/////////////////////////////////////////////////////////////////////////////
%%%              TRA�ADO DOS GR�FICOS E GRAVA��O DE IMAGEM
%%%/////////////////////////////////////////////////////////////////////////////
fig=figure();
titulo=['EC1 - Grupo z', num2str(grupo), ' - ', num2str(nusp), ' - ', date()];
subplot(2,2,1) % primeiro subplot RENDIMENTO
plot(vetorPorcentagens, rendimentos_unitario);
hold on;
plot(vetorPorcentagens, rendimentos_capacitivo);
title(titulo);
set(gca, 'FontSize', 8)
xlabel('% Snom');
ylabel('Rendimento (%)');
grid on;
legend({"Curva FP unitario", "Curva FP Capacitivo 0.6"}, "location", "south");
legend show;

subplot(2,2,2) % segundo subplot REGULA��O
plot(vetorPorcentagens, regulacoes_unitario);
hold on;
plot(vetorPorcentagens, regulacoes_capacitivo);
set(gca, 'FontSize', 8)
xlabel('% Snom');
ylabel('Regulacao (%)');
grid on;
legend({"Curva FP unitario", "Curva FP Capacitivo 0.6"}, "location", "south");
legend show;

%arq=['EC1_2021_PEA3306_z', num2str(grupo), ' _ ', num2str(nusp), '.png'] % GERA��O DO ARQUIVO IMAGEM
#print(fig, arq);

%%%/////////////////////////////////////////////////////////////////////////////
%%%                        IMPRESS�O DOS RESULTADOS
%%%/////////////////////////////////////////////////////////////////////////////
%%%disp(['XXXXXXXX ', num2str(?), ' [?]']);
%%%disp(['XXXXXXXX ', num2str(?), ' [?]']);
%%%disp(['XXXXXXXX ', num2str(?), ' [?]']);