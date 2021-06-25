%Definição de todos os valores iniciais

tensaoVazio = 3810;
tensaoCurto = 854;
correnteVazio= 9.86;
correnteCurto = 131;
potenciaVazio = 8140;
potenciaCurto = 8890;
tensaoPrimario = 19100; 
tensaoSecudario = 3810;
correnteNominalPrimario = 2.5e6/19.1e3
correnteNominalSecundario = 2.5e6/3.81e3
PotenciaNominal = 2.5e6;

a = tensaoPrimario/tensaoSecudario; %Relação número de espiras;

%%%%%%%%%%%       CALCULO DOS PARAMETROS    %%%%%%%%%%%%%

cosPhiZero = potenciaVazio/(tensaoVazio*correnteVazio); % Cosseno da fase da corrente em vazio.

%Resultados provenientes do Ensaio em Vazio
%Rp =  (tensaoVazio^2)/potenciaVazio; %Resistência de perdas no Ferro 

%Ip = tensaoVazio/Rp; %corrente que passa sobre o ramo da 

%resistência de perdas no Ferro 
Ip = correnteVazio*cosPhiZero; % Parte real da corrente em vazio.

Rp = tensaoVazio/Ip;           % Resistência equivalente do ferro.

senPhiZero = sqrt(1-cosPhiZero^2); %Seno da fase da corrente em vazio.

Im = correnteVazio*senPhiZero; % Corrente de magnetização (Parte imaginária pura da corrente em vazio).

Xm = tensaoVazio/Im; % reatância de magnetização

%%%%%Ensaio Em Curto%%%%%% 


Rcc = potenciaCurto/(correnteCurto^2); %Resistência equivalente de curto.

Zcc = tensaoCurto/correnteCurto; %Impedância equivalente de curto.

Xcc = sqrt(Zcc^2-Rcc^2); %Reatância de Curto

X1 = X2linha = Xcc/2; %Supondo reatâncias iguais para ambos os lados.  %VER necessidade de refletir o X2 para lado da alta

X2 = X1/2*a^2; % X2 refletido pelo lado da baixa tensão.

R1 = R2linha = Rcc/2; % Supondo resistências e reatâncias iguais para ambos os lados.

R2 = Rcc/(2*a^2);  %Refletido pro lado da baixa tensão.

cosPcc = Rcc/Zcc; %Cosseno de da fase da impedância equivalente de curto.

faseZcc = acos(cosPcc); % fase de Zcc

%defasagem da corrente sera dada por indutivo da carga - fp unitario

Ialta = correnteNominalPrimario; %
V2Linha = tensaoPrimario;
I2Linha = Ialta;

%%%%%%%%%%%%%%##################################




V1 = V2Linha+Ialta*(cos(faseZcc)+j*sin(faseZcc)); %ver reflexoes
Relu = (abs(V1)/tensaoPrimario)-1;%confirmar se eh relu. Nao esta em porcentagem
PerdasNoFerroEmWatts = (abs(V1)/tensaoPrimario)^2*(potenciaVazio*(1-Relu)); % valorProxima a Rp*Ip^2
%PerdasCobreEmWatts = potenciaCurto; %adotei potenciaCurto como perdas do Cu

ZeqRamoPerdas = 1/(1/Rp+1/(j*Xm));
I0 = V1/ZeqRamoPerdas;
I1 = I2Linha+I0;
%PerdasJoule = R1*I1^2+R2*I2Linha^2; %ver se formulaEstaCorreta I2
%PerdasJoule = (R1+R2)*I2Linha^2;
PerdasJoule = potenciaCurto;
%aproximacao minha
rendimento =  ((V2Linha*abs(I2Linha))/( V2Linha*abs(I2Linha)+abs(PerdasJoule)+PerdasNoFerroEmWatts ));
%rendimento2 = 1-((abs(PerdasJoule)+PerdasNoFerroEmWatts)/((1-Relu)*V2Linha*abs(I2Linha)));

%duvida quanto a perdas Joules


i = 1;
for porcentoDaNominal = 0.3:0.1:1.3
    
    vetorPorcentagens(i)= porcentoDaNominal; % Vetor com porcentagens da nominal - vai de 0,3 a 1,3 variando de 0.1 por passo.
    correnteNominalPrimario = (porcentoDaNominal*2.5e6)/19.1e3; %Cálculo da corrente nominal do primário na determinada porcentagem de carga.
    correnteNominalSecundario = (porcentoDaNominal*2.5e6)/3.81e3; %Cálculo da corrente nominal do secundário. na determinada porcentagem de carga.
    
    
    IaltaUnitario = correnteNominalPrimario; %Cálculo da corrente refletida ao lado da alta tensãoo com carga unitária.
    IaltaCapacitivo = correnteNominalPrimario*(acos(0.6)-j*acos(0.6)); %%%Aqui estava indutiva antes!!!!
    V2Linha = tensaoPrimario;
    I2Linha = IaltaUnitario;
    I2LinhaCapacitivo = IaltaCapacitivo;

    V1 = V2Linha+IaltaUnitario*(j*Xcc+Rcc);
    V1Capacitivo = V2Linha+IaltaCapacitivo*(j*Xcc+Rcc);
    PerdasNoFerroEmWatts = abs(V1^2/Rp); 
    PerdasNoFerroEmWattsCapacitivo = abs(V1Capacitivo^2/Rp); 
    PerdasCobreEmWatts = (R1+R2)*I2Linha^2; 
    PerdasCobreEmWattsCapacitivo = abs((R1+R2)*I2LinhaCapacitivo^2);
      
    PotenciaDeSaidaUnitario = a*tensaoSecudario*I2Linha*1;
    PotenciaDeSaidaCapacitivo = a*tensaoSecudario*abs(I2LinhaCapacitivo)*0.6;

    rendimentosFPUnitario(i) = 100*(PotenciaDeSaidaUnitario/(PotenciaDeSaidaUnitario+PerdasNoFerroEmWatts+PerdasCobreEmWatts));
    rendimentosFPCapacitivo(i) = 100*(PotenciaDeSaidaCapacitivo/(PotenciaDeSaidaCapacitivo+PerdasNoFerroEmWattsCapacitivo+PerdasCobreEmWattsCapacitivo));
    i=i+1;
 
endfor


b = 1;
for porcentoDaNominalRegs = 0.3:0.1:1.4
    
    vetorPorcentagensRegs(b)= porcentoDaNominalRegs;
    correnteNominalPrimario = (porcentoDaNominalRegs*2.5e6)/19.1e3;
    correnteNominalSecundario = (porcentoDaNominalRegs*2.5e6)/3.81e3; 
    
    
    IaltaUnitario = correnteNominalPrimario;
    IaltaCapacitivo = correnteNominalPrimario*(acos(0.6)+j*acos(0.6));
    V2Linha = tensaoPrimario;
    I2Linha = IaltaUnitario;
    I2LinhaCapacitivo = IaltaCapacitivo;

    V1 = V2Linha+IaltaUnitario*(j*Xcc+Rcc); 
    V1Capacitivo = V2Linha+IaltaCapacitivo*(j*Xcc+Rcc);
    PerdasNoFerroEmWatts = abs(V1^2/Rp); 
    PerdasNoFerroEmWattsCapacitivo = abs(V1Capacitivo^2/Rp); 
    PerdasCobreEmWatts = (R1+R2)*I2Linha^2; 
    PerdasCobreEmWattsCapacitivo = abs((R1+R2)*I2LinhaCapacitivo^2);
      
    PotenciaDeSaidaUnitario = a*tensaoSecudario*I2Linha*1;
    PotenciaDeSaidaCapacitivo = a*tensaoSecudario*I2Linha*0.6;

    regulacoesFPUnitario(b) = 100*((abs(V1)-V2Linha)/V2Linha);
    regulacoesFPCapacitivo(b) = 100*abs(((abs(V1Capacitivo)-V2Linha)/V2Linha));
    b=b+1;
 
endfor

%%%%%%%%%%%%%% GRAFICO %%%%%%%%%%%%%%5
%Rendimento


fig=figure();
titulo=['EC1 - Grupo z',num2str(52),' - ', num2str(2),' - ', date()];
titulo=['EC1 - Grupo z52'];
subplot(2,2,1) % first subplot RENDIMENTO
plot(vetorPorcentagens,rendimentosFPUnitario);
hold on;
plot(vetorPorcentagens,rendimentosFPCapacitivo);
title(titulo);
set(gca, 'FontSize', 8)
xlabel('% Snom');
ylabel('Rendimento (%)');
grid on;
legend ({"Curva FP unitário", "Curva FP Capacitivo 0.6"}, "location", "south");
legend show;


subplot(2,2,2) % second subplot REGULACAO
plot(vetorPorcentagensRegs,regulacoesFPUnitario);
hold on;
plot(vetorPorcentagensRegs,regulacoesFPCapacitivo);

set(gca, 'FontSize', 8)
xlabel('% Snom');
ylabel('Regulacao (%)');

grid on;
legend ({"Curva FP unitário", "Curva FP Capacitivo 0.6"}, "location", "north");
legend show;
arq=['EC1_2021_PEA3306_z', '52' ,'_', '11325312' ,'.png']; %Colocar NUSP do Felipe !
print(fig, arq);



