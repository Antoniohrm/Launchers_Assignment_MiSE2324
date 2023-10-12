function [deriv] = endoFlightDeriv(rocket,mission)
%endoFlightDeriv(t, X, earthPararm, launcherParam, phaseCode) COPIADO

% I need mass, altitude, thrust
re = mission.re;
wEarth = mission.wEarth;
g = mission.g;
mu = mission.mu;
% Stage 1 parameters
m0 = rocket.m0;
mdot1 = rocket.mdot1;
T1 = rocket.T1;
%Rocket Mach and CD parameters
cddata = rocket.cddata;


%T = mdot*exhaust+(pe-pa)*Ae;
altitude = linspace(0, 100000, 10);
[rho,press,temp,a] = expEarthAtm(altitude);
mdot1 = (T1-(pe(1)-press)*Ae(1))/exhaust(1);
plot(mdot1,altitude)
xlabel('Mass flow rate')
ylabel('Altitude')



rdot = v;
vdot = (T/m)*ba - (mu/norm(r)^3)*ba - (D/m)*ba
end

