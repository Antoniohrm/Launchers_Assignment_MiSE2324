close all; clear all; clc;

% Constants
g0 = 9.81;

deltaV = 9700; % m/s
M_PL = 1500; % Kg

% Rocket parameters

% PL_ratio = M_PL / M_0;                  % Payload Ratio
% Str_Eff = M_str / (M_str + M_PL);       % Structural efficiency
e1 = 0.1;
e2 = 0.13;
% Prop_ratio = M_prop / M_0;              % Propellant Ratio
% Mass_ratio = M_0 / (M_PL + M_str);      % Mass Ratio = Initial mass/Empty mass

%Relationships among rocket parameters


% Tsiolkosky Equation
% syms Isp
% eqn = deltaV == g0*Isp*log(Mass_ratio);
% solve(eqn);

% Numerical Solution Scheme

Isp1 = 400;
Isp2 = 430;
c1 = Isp1*g0;
c2 = Isp2*g0;
% N_stages = 2;

%myfun = @(p,c1,c2,Str_Eff1,Str_Eff2) (c1*log((1+p*c1)/(p*c1*Str_Eff1)))+(c2*log((1+p*c2)/(p*c2*Str_Eff2))) - deltaV;  % parameterized function

%Function 2 esta basura funciona
c_media=(c1+c2)/2;
e_media=(e1+e2)/2;
% fun = @lagrange_initial_guess;
% p_mal = fzero(fun, -3.294612e-4,[],c_media,e_media,deltaV);

syms p
equ=3*c_media*log((1+p*c_media)/(p*c_media*e_media))==deltaV;
p_bien = solve(equ); %-3.294612e-4


%Funcion 1 -2.832e-4
fun = @f;
p = fzero(fun, double(p_bien),[],c1,c2,e1,e2,deltaV);

%Mass ratio for each stage (2 < Λ < 10)
Mass_ratio1 = (1+p*c1)/(p*c1*e1);
Mass_ratio2 = (1+p*c2)/(p*c2*e2);

%PL ratio for each stage (0.01 < 𝜆 < 0.2)
PL_ratio1 = (1-Mass_ratio1*e1)/((1-e1)*Mass_ratio1);
PL_ratio2 = (1-Mass_ratio2*e2)/((1-e2)*Mass_ratio2);

%Total PL ratio
total_PL_ratio = PL_ratio1*PL_ratio2;

%GMLO
M_0 = M_PL/total_PL_ratio


