function [Rocket, Mission] = endoAtmPhase(Rocket, Mission)

state0 = zeros(1, 7);
state0(1:3) = Rocket.r(1, :);
state0(4:6) = Rocket.v(1, :);
state0(7) = Rocket.m0(Rocket.actstage);


% First integration, first stage until vertical rising

options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission),'RelTol',1e-9,'AbsTol',1e-8);
[t, state, te, ye, ie] = ode45(@(t, state) endoAtmDer(t, state, Rocket, Mission), [0, Rocket.tstage(Rocket.actstage)], state0, options);
% [ders] = endoAtmDer(0, state0, Rocket, Mission)
% te is a column vector of the times at which events occurred
% It give us the time when the event happened
% ye contains the solution value at each of the event times in te
% No entiendo los valores que da

% Velocity at the end of the VR, 100m

Rocket.r = state(:, 1:3);
Rocket.v = state(:, 4:6);
Rocket.vrel = Rocket.vrelCalc(Mission);
Rocket.m = state(:, 7);
Rocket.t = t;
Rocket.v(end, :) = Rocket.applyKickangle(Mission)

state0(1:3) = Rocket.r(end, :);
state0(4:6) = Rocket.v(end, :);
state0(7) = Rocket.m(end);

options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission),'RelTol',1e-9,'AbsTol',1e-8);
[t, state, te, ye, ie] = ode45(@(t, state) endoAtmDer(t, state, Rocket, Mission), [0, Rocket.tstage(Rocket.actstage)], state0, options);

Rocket.r = [Rocket.r; state(:, 1:3)];
Rocket.v = [Rocket.v; state(:, 4:6)];
Rocket.vrel = Rocket.vrelCalc(Mission);
Rocket.m = [Rocket.m; state(:, 7)];
Rocket.t = [Rocket.t; t + Rocket.t(end)];

% Third integration, second sage for t(second stage) fixed time, no events

Rocket.actstage = Rocket.actstage + 1;

state0(1:3) = Rocket.r(end, :);
state0(4:6) = Rocket.v(end, :);
state0(7) = Rocket.m0(Rocket.actstage);

[t, state] = ode45(@(t, state) endoAtmDer(t, state, Rocket, Mission), [0, Rocket.tstage(Rocket.actstage)], state0);

Rocket.r = [Rocket.r; state(:, 1:3)];
Rocket.v = [Rocket.v; state(:, 4:6)];
Rocket.vrel = Rocket.vrelCalc(Mission);
Rocket.m = [Rocket.m; state(:, 7)];
Rocket.t = [Rocket.t; t + Rocket.t(end)];

% Separate second stage

Rocket.actstage = Rocket.actstage + 1;
Rocket.m(end) = Rocket.m0(Rocket.actstage);

end