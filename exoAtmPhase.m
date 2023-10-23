function [Rocket, Mission] = exoAtmPhase(Rocket, Mission)

% optburn = optimizeBurn(Rocket, Mission);
% 
% propTime = optburn(1) * 1e+2
% 
% agstate = [Rocket.r(end, :), Rocket.v(end, :), optburn(2:4)', optburn(5:7)', Rocket.m0(Rocket.actstage)];
% 
% [t,  state] = ode45(@(t, state) exoAtmDer(t, state, Rocket, Mission), [0, propTime], agstate);
% 
% [Rocket, Mission] = updateRocket(t, state, Rocket, Mission);

% Propagate until the rocket reaches 700 km apogee in a ballistic arc
tballarc = 425;

options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission));
[t, state] = ode45(@(t, state) ballisticDer(t, state, Rocket, Mission), [0, 1000], [Rocket.r(end, :), Rocket.v(end, :), Rocket.m(end)], options);
t(end)
[Rocket, Mission] = updateRocket(t, state, Rocket, Mission);


% % Impulsive maneuver
% 
% deltav = norm(Rocket.v(end, :)) - Mission.orbitv
% 
% Rocket.v(end, :) = Mission.orbitv * (Rocket.v(end, :) / norm(Rocket.v(end, :)));

% Now optimize circularization burn

Rocket.exoburncounter = Rocket.exoburncounter + 1;

optburn = optimizeBurn(Rocket, Mission);

propTime = optburn(1) * 1e+2;

agstate = [Rocket.r(end, :), Rocket.v(end, :), optburn(2:4)', optburn(5:7)', Rocket.m(end)];

[t,  state] = ode45(@(t, state) exoAtmDer(t, state, Rocket, Mission), [0, propTime], agstate);

[Rocket, Mission] = updateRocket(t, state, Rocket, Mission);
% 
% Plot circularization

options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission), 'RelTol', 1e-10);
options = odeset('RelTol', 1e-10);
[t, state,] = ode45(@(t, state) ballisticDer(t, state, Rocket, Mission), [0, Mission.torbit], [Rocket.r(end, :), Rocket.v(end, :), Rocket.m(end)], options);

[Rocket, Mission] = updateRocket(t, state, Rocket, Mission);


end