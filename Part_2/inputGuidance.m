function [Rocket, Mission] = inputGuidance(Rocket, Mission)

% Initialize Rocket and Mission properties

Rocket.r(1, :) = Rocket.r0(Mission);                % Initialize position
Rocket.v(1, :) = Rocket.v0(Mission);                % Initialize ECI velocity
Rocket.cexh = Rocket.cexhcalc(Mission);             % Initialize velocities
Rocket.m(1) = Rocket.m0(Rocket.actstage);           % Initialize mass


[Rocket, Mission] = Staging(Rocket, Mission);
[Rocket, Mission] = endoAtmPhase(Rocket, Mission);

(norm(Rocket.r(end, :)) - Mission.re) * 1e-3

end