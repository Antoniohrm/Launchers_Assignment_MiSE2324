function [Rocket, Mission] = endoAtmPhase(Rocket, Mission)

% First integration, first stage until vertical rising

options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission),'RelTol',1e-9,'AbsTol',1e-8);
[t, state] = ode45(@(t, state) endoAtmDer(t, state, Rocket, Mission), [0, Rocket.tstage(Rocket.actstage)], [Rocket.r(end, :), Rocket.v(end, :), Rocket.m(end)], options);

[Rocket, Mission] = updateRocket(t, state, Rocket, Mission);

% Apply kick angle

Rocket.v(end, :) = Rocket.applyKickangle(Mission);

% Propagate rest of the first stage

options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission),'RelTol',1e-9,'AbsTol',1e-8);
[t, state] = ode45(@(t, state) endoAtmDer(t, state, Rocket, Mission), [0, Rocket.tstage(Rocket.actstage)], [Rocket.r(end, :), Rocket.v(end, :), Rocket.m(end)], options);

[Rocket, Mission] = updateRocket(t, state, Rocket, Mission);

% Propagate second stage until it runs out of fuel

Rocket.actstage = Rocket.actstage + 1;
Rocket.m(end) = Rocket.m0(Rocket.actstage);

options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission),'RelTol',1e-9,'AbsTol',1e-8);
[t, state] = ode45(@(t, state) endoAtmDer(t, state, Rocket, Mission), [0, Rocket.tstage(Rocket.actstage)], [Rocket.r(end, :), Rocket.v(end, :), Rocket.m(end)], options);

[Rocket, Mission] = updateRocket(t, state, Rocket, Mission);

% Separate second stage

Rocket.actstage = Rocket.actstage + 1;
Rocket.m(end) = Rocket.m0(Rocket.actstage);

end