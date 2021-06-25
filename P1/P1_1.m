clear all;
x = 0.0025; % metro
mi0 = 4*pi*1E-7;
d = 0.35; %metro
K = 4000; %N/m
z = 0.4; %metro
N = 200;
deltaY = 0.3;

%%RESOLULUÇÂO
Fx = K*deltaY;

% d - y = 0.3
%calculo do fluxo em que Fx = Fmag - phi cte

dRel = 2*x/(mi0*z*deltaY^2);

dL = 400/dRel; 

%phi = sqrt(2*Fx/dRel);

%Relutância
%Rel = 2*x/(mi0*z*deltaY);

I = sqrt(Fx*2/dL)

%V = 3*I








