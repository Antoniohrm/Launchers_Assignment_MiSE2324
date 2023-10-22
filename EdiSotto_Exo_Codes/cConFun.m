
function [c, ceq] = cConFun(x);
%
global state0 finalRa mu
%
propTime = x(1)*1e+2; %denormalize
pr       = x(2:4)'; %Transpuesto
pv       = x(5:7)'; %Transpuesto
%
augState = [state0, pr, pv];%
[tExo  solExo] = ode45(@exoFlightDeriv,[0 propTime], augState); %propagate exo flight
%
Xf = solExo(end,1:6); %Valores finales (cartesianos)
%
eleF = AST_pvecle(Xf,mu); %valores finales (elementos orbitales)
%
SAXI_F = eleF(1);
ECC_F  = eleF(2);
%
raf    = SAXI_F*(1 + ECC_F); %radio apoapsis final
%
ceq   = (raf - finalRa)*1e-7; % Coeficiente de error, cost function
c = [];



end 