clear all;
phi = acos(0.6);
a = 440/220;

Z = 3.549*a^2*(cos(phi) - i*sin(phi)); %capacitivo
rcc = 0.109;
xcc = 0.516;
zcc = rcc +i*xcc;

Zcc = 2*zcc;

rp = 483.83;
xm = j*175.83;

V1 = 396;

I2 = V1/(Zcc + Z);

Z0 = rp*xm/(rp+xm);
I0 = V1/Z0;

V2 = V1 - Zcc*I2;

I1 = I2 + I0;

Pf = real(V1*conj(I1));

Pu = real(V2*conj(I2));

zeta = 100*Pu/Pf




% 
% I2 = I1 - I0;
% 
% Pf = real(V1*conj(I1));
% 
% V2 = V0 - zcc*I2;
% Pu = real(V2*conj(I2));
% 
% zeta = 100*Pu/Pf;


