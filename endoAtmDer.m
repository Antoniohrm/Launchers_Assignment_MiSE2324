function [t, ders] = endoAtmDer(t, state, Rocket, Mission)

ders = zeros(1, 7);      % [rxdot, rydot, rzdot, vxdot, vydot, vzdot, mdot]

[dens, p, ~, a] = expEarthAtm(Rocket.h(Mission));

stage = Rocket.actstage; % Just to keep the code more readable

% Thrust is calculated in three lines to help keep the code readable,
% also, assuming that AoA is always 0, it will always be directed along
% the velocity vector direction

thrust = ((Rocket.mdot(stage) * Rocket.isp(stage) * Mission.g) + ...
    (Rocket.nozzlepress(stage) - p) * Rocket.nozzlesurf(stage)) * ...
    (state(1:3) / norm(state(1:3)));
thrust = thrust * (Rocket.h(Mission) < 100); % Bool to cut of engine after VR

% Drag is also directed along the velocity vector, but in the opposite
% direction
mach = norm(state(4:6)) / a;    % In a separate line to keep the code readable
% drag = (0.5 * dens * (norm(state(4:6))^2) * Rocket.aerosurf * Rocket.cd(mach)) * ...
    %(-1 * state(4:6) / norm(state(4:6)));

drag = (0.5 * dens * (norm(state(4:6))^2) * Rocket.aerosurf * 0.25) * ...
    (-1 * state(1:3) / norm(state(1:3)));


weight = -1 * state(7) * (Mission.mu / (norm(state(1:3))^3)) * state(1:3);

ders(1:3) = state(4:6);
ders(4:6) = (thrust + weight + drag) / state(7);

%ders(4:6) = [0, 0, 0];

ders(7) = -1 * Rocket.mdot(stage);
ders = transpose(ders);

end