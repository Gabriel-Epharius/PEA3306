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
PotenciaNominal = 2.5e6

a = tensaoPrimario/tensaoSecudario; %Rel n de espiras;
%%%%%%%%%%%       CALCULO DOS PARAMETROS    %%%%%%%%%%%%%
cosPhiZero = potenciaVazio/(tensaoVazio*correnteVazio); % Não seria tensão nominal embaixo ? %



Ip = correnteVazio*cosPhiZero;
Rp = tensaoVazio/Ip;
senPhiZero = sqrt(1-cosPhiZero^2);
Im = sqrt(correnteVazio^2-Ip^2); %corrente de magnetizacao - 
Im = correnteVazio*senPhiZero;
Xm = tensaoVazio/Im; % reatencia de magnetizacaoo

%Ensaio Em Curto
Rcc = potenciaCurto/(correnteCurto^2);
Zcc = tensaoCurto/correnteCurto;
Xcc = sqrt(Zcc^2-Rcc^2); %reatancia de Curto
X1=Xcc/2; %VER necessidade de refletir o x2 para lado da alta
x2 = Xcc/(2*a^2);
X2Linha = x2*a^2;
R1 = Rcc/2;
R2 = Rcc/(2*a^2);  %refletido pro lado da alta. Confirmar
cosPcc = Rcc/Zcc;
faseZcc = acos(cosPcc); % fase de Zcc


i = 1;
for porcentoDaNominal = 0.3:0.1:1.3
    
    vetorPorcentagens(i)= porcentoDaNominal;
    correnteNominalPrimario = (porcentoDaNominal*2.5e6)/19.1e3;
    correnteNominalSecundario = (porcentoDaNominal*2.5e6)/3.81e3; 
    
    
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
legend ({"Curva FP unit�rio", "Curva FP Capacitivo 0.6"}, "location", "south");
legend show;


subplot(2,2,2) % second subplot REGULACAO
plot(vetorPorcentagensRegs,regulacoesFPUnitario);
hold on;
plot(vetorPorcentagensRegs,regulacoesFPCapacitivo);

set(gca, 'FontSize', 8)
xlabel('% Snom');
ylabel('Regulacao (%)');

grid on;
legend ({"Curva FP unit�rio", "Curva FP Capacitivo 0.6"}, "location", "north");
legend show;
arq=['EC1_2021_PEA3306_z',num2str(grupo),'_',num2str(nusp),'.png']; 
print(fig, arq);










