clear all
clc
mu = 398602*1e+9;
Re = 6378137 ;
rf = 22913*1e+3 + Re;%1164*1e+3 +Re;
vf = 2940;%3688.9;%8880;

vC =sqrt(mu/rf)

finalRa = 22913*1e+3 + Re;%22922*1e+3 + Re;

E    = vf^2/2 - mu/rf;
SAXI = -mu/(2*E);
%
ECC  = finalRa/SAXI-1
rpf   = SAXI*(1 - ECC)
hpf = ( rpf - Re)*1e-3;
%
wN=2*pi/86164;
%
incl= 56*pi/pi;
%
%wVec = [0 0 wN]
%rVec = finalRa*[0 cos(incl) sin(incl)];


