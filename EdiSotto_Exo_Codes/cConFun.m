
function [c, ceq] = cConFun(x);
%
global state0 finalRa mu
%
propTime = x(1)*1e+2;
pr       = x(2:4)';
pv       = x(5:7)';
%
augState = [state0, pr, pv];%
[tExo  solExo] = ode45(@exoFlightDeriv,[0 propTime], augState);
%
Xf = solExo(end,1:6);
%
eleF = AST_pvecle(Xf,mu);
%
SAXI_F = eleF(1);
ECC_F  = eleF(2);
%
raf    = SAXI_F*(1 + ECC_F);
%
ceq   = (raf - finalRa)*1e-7;
c = [];



end 