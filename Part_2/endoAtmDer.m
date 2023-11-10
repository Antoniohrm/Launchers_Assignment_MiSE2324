function [ders] = endoAtmDer(t, state, Rocket, Mission)

ders = zeros(1, 7);      % [rxdot, rydot, rzdot, vxdot, vydot, vzdot, mdot, dp]

[dens, p, ~, a] = expEarthAtm(norm(state(1:3)) - Mission.re);

stage = Rocket.actstage; % Just to keep the code more readable

% Calculation of ECI position unit vector, relative velocity vector
% and relative velocity unit vector

vunit = state(4:6) / norm(state(4:6)); % ECI
vrel = state(4:6) - transpose(cross([0, 0, Mission.we], state(1:3)));
vrelunit = vrel / norm(vrel); % Ojo, todo NANS en primera iteracion
nanIndices = isnan(vrelunit); % % Find NaN values
vrelunit(nanIndices) = 0; % Replace NaN values with a 0

runit = state(1:3) / norm(state(1:3));


% Thrust is calculated in three lines to help keep the code readable,
% also, assuming that AoA is always 0, it will always be directed along
% the velocity vector direction

thrustval = ((Rocket.mdot(stage) * Rocket.isp(stage) * Mission.g) + ...
    (Rocket.nozzlepress(stage) - p) * Rocket.nozzlesurf(stage));

thrustvec = (runit * ((norm(state(1:3)) - Mission.re) < Mission.vrlim)) + ...
    (vrelunit * ((norm(state(1:3)) - Mission.re) >= Mission.vrlim));

thrust = thrustval * thrustvec;


% Drag is also directed along the velocity vector, but in the opposite
% direction

mach = norm(state(4:6)) / a;

dragval = (-0.5 * dens * (norm(vrel)^2) * Rocket.aerosurf * Rocket.cd(mach));

drag_vec = (runit * ((norm(state(1:3)) - Mission.re) < Mission.vrlim)) + ...
    (vrelunit * ((norm(state(1:3)) - Mission.re) >= Mission.vrlim));

drag = dragval * drag_vec;


weight = -1 * state(7) * (Mission.mu / (norm(state(1:3))^3)) * state(1:3);

ders(1:3) = state(4:6);
ders(4:6) = (thrust + drag + weight) / state(7);
ders(7) = -1 * Rocket.mdot(stage);

ders = transpose(ders);

end