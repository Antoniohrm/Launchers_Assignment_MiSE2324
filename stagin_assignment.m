%clear all; close all; clc
rocket = Rocket;
mission = Mission;

re = mission.re;
wEarth = mission.wEarth;

deltav = 0; % m/s ?? Delta V for 700km??
% Kourou launch base in ECI. Inertial equatorial RF
latlaunch = mission.latlaunch*pi/180; %degrees north, in rad

% Calculation of Mission Delta V

%orbit_Vel = sqrt(mu/(Re+h))
v_orbit = mission.orbitv;

% mission_deltaV = orbit_Vel+LossesAndGains_Vel+GainduetoEarths rotation Vel
% v_er = Earth's angular velocity (rad/s)
r0 = [re*cos(latlaunch) 0 re*sin(latlaunch)]; %m
% v_er = wEarth*r0*cos(kourou_lat);
%A = asin(cos(incl))...
% v_gain = v_orbit-sqrt((v_orbit*sin(A)-V_er)^2 + (v_orbit*cos(A))^2);
% v_lg = 1.6; %Aprox for LEO
deltav = v_orbit + 2000; % Rule of thumb

% Rocket parameters
strcoeff = rocket.strcoeff;

% Numerical Solution Scheme
exhaust = rocket.isp*mission.g;

% For initial guess of p
exhaust_media=(exhaust(1)+exhaust(2)+exhaust(3))/3;
strcoeff_media=(strcoeff(1)+strcoeff(2)+strcoeff(3))/3;

syms p
equ = 3*exhaust_media*log((1+p*exhaust_media)/(p*exhaust_media*strcoeff_media)) == deltav;
p_guess = solve(equ); %-4.3851e-04

%Funcion 1
fun = @f;
p = fzero(fun, double(p_guess),[],exhaust,strcoeff,deltav);

%Mass ratio for each stage (2 < Λ < 10)
mass_rat = (1+p*exhaust)./(p*exhaust.*strcoeff);

%PL ratio for each stage (0.01 < 𝜆 < 0.2)
pl_rat = (1-mass_rat.*strcoeff)./((1-strcoeff).*mass_rat);

%Total PL ratio
tot_pl_rat = pl_rat(1)*pl_rat(2)*pl_rat(3);

%GMLO
m0 = mission.mpl/tot_pl_rat;
rocket.m0 = m0; % No me lo esta guardando


syms mp1
equ = mass_rat(1)==m0/(m0-mp1);
mp1 = double(solve(equ,mp1));

syms ms1
equ = strcoeff(1)==ms1/(ms1+mp1);
ms1 = double(solve(equ,ms1));

syms m02
equ = m0==m02+ms1+mp1;
m02 = double(solve(equ,m02));

syms mp2
equ = mass_rat(2)==m02/(m02-mp2);
mp2 = double(solve(equ,mp2));

syms ms2
equ = strcoeff(2)==ms2/(ms2+mp2);
ms2 = double(solve(equ,ms2));

syms m03
equ = pl_rat(2)==m03/m02;
m03 = double(solve(equ,m03));

syms mp3
equ = mass_rat(3)==m03/(m03-mp3);
mp3 = double(solve(equ,mp3));

syms ms3
equ = strcoeff(3)==ms3/(ms3+mp3);
ms3 = double(solve(equ,ms3));

