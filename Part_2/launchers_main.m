clear
clc
close all

% Initialize Rocket and Mission objects

Rocket = Rocket;
Mission = Mission;

Rocket.r(1, :) = Rocket.r0(Mission);                % Initialize position
Rocket.v(1, :) = Rocket.v0(Mission);                % Initialize ECI velocity
Rocket.cexh = Rocket.cexhcalc(Mission);             % Initialize velocities
Rocket.m(1) = Rocket.m0(Rocket.actstage);           % Initialize mass


[Rocket, Mission] = Staging(Rocket, Mission);
[Rocket, Mission] = endoAtmPhase(Rocket, Mission);



% % Propagate ballistic flight to visualize resulting orbit
% 
% optionsfree = odeset('RelTol',1e-10);
% [t, state] = ode45(@(t, state) ballisticDer (t, state, Rocket, Mission), [0, 4 * Mission.torbit], [Rocket.r(end, :), Rocket.v(end, :)], optionsfree);
% [Rocket, Mission] = updateRocket(t, state, Rocket, Mission);

% % Print extra fuel after circularizing
% 
% extrapropfuel = Rocket.m(end) - (Rocket.m0(3) - Rocket.mprop(3))
% 
% % Calculate altitude profiles and plot results
% 
% Rocket.hf = Rocket.h(Mission) * 1e-3;
% plotResults(Rocket, Mission);
