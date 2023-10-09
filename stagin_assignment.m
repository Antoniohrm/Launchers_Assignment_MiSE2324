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
deltav = v_orbit + 2; % Rule of thumb

% Rocket parameters
strcoeff = rocket.strcoeff;

% Numerical Solution Scheme
exhaust = rocket.isp*mission.g;

rocket.isp
% For initial guess of p
exhaust_media=(exhaust(1)+exhaust(2)+exhaust(3))/3;
strcoeff_media=(strcoeff(1)+strcoeff(2)+strcoeff(3))/3;

syms p
equ = 3*exhaust_media*log((1+p*exhaust_media)/(p*exhaust_media*strcoeff_media)) == deltaV;
p_guess = solve(equ); %-3.294612e-4

%Funcion 1
fun = @f;
p = fzero(fun, double(p_guess),[],exhaust(1),exhaust(2),exhaust(3),strcoeff(1),strcoeff(2),strcoeff(3),deltav);

%Mass ratio for each stage (2 < Λ < 10)
mass_rat = (1+p*exhaust)./(p*exhaust.*strcoeff);

%PL ratio for each stage (0.01 < 𝜆 < 0.2)
pl_rat = (1-mass_rat.*strcoeff)./((1-strcoeff).*mass_rat);

%Total PL ratio
tot_pl_rat = pl_rat(1)*pl_rat(2)*pl_rat(3);

%GMLO
M_0 = mission.mpl/tot_pl_rat

% PL_ratio = M_PL / M_0;                  % Payload Ratio
% Str_Eff = M_str / (M_str + M_PL);       % Structural efficiency
syms M_str
equ = e1 == M_str1 / (M_str1 + M_PL); %OJOO AQUI
% solve(equ,)

% e1 = 0.1;
% e2 = 0.13;
% Prop_ratio = M_prop / M_0;              % Propellant Ratio
% Mass_ratio = M_0 / (M_PL + M_str);      % Mass Ratio = Initial mass/Empty mass

save Variables.mat g0 M_0