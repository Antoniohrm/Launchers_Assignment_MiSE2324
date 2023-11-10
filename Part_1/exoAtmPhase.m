function [Rocket, Mission] = exoAtmPhase(Rocket, Mission)

% First, we obtain an optimum burn to reach our desired apoapsis just after
% second stage burnout, then, we propagate that burn

[optres] = optimizeBurn(Rocket, Mission);

propt = optres(1) * 1e+2 % Burn time in seconds
agstate = [Rocket.r(end, :), Rocket.v(end, :), optres(2:4)', optres(5:7)'];

% options = odeset('AbsTol',1e-4,'RelTol',1e-6);
options = odeset('AbsTol',1e-9,'RelTol',1e-8);
[t , state] = ode45(@(t,state) exoAtmDer(t, state,Rocket, Mission),[0 propt], agstate, options);

% Update 'Rocket' and 'Mission' objects to keep everything nice and tidy

[Rocket, Mission] = updateRocket(t, state, Rocket, Mission);
usedm = Rocket.m0(Rocket.actstage) - (t * Rocket.mdot(Rocket.actstage));
Rocket.m = [Rocket.m; usedm];
Rocket.toptburn = length(Rocket.t); % Marker to know the time at the end of the optimized burn

Rocket.exoburncounter = Rocket.exoburncounter + 1;

% Now we propagate until apoapsis, by setting the event function to stop
% the integration when the first exo atmospheric burn has been done
% 'Rocket.exoburncounter == 2' and when the dot product of the position and
% the velocity vectors of the rocket is zero, going from positive to
% negative (direction = -1)

options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission),'AbsTol',1e-9,'RelTol',1e-8);
[t , state] = ode45(@(t,state) ballisticDer(t, state, Rocket, Mission),[0, 4 * Mission.torbit], [Rocket.r(end, :), Rocket.v(end, :)], options);

[Rocket, Mission] = updateRocket(t, state, Rocket, Mission);
Rocket.m = [Rocket.m; ones(size(t)) * Rocket.m(end)];

% We perform first circularization impulsive burn

[Rocket, Mission] = impulsiveBurn(Rocket, Mission, Mission.rorbit);
Rocket.tcirc1 = length(Rocket.t);

% We haven't reached a perfect circular orbit, so we propagate until the
% new apogee now

Rocket.exoburncounter = Rocket.exoburncounter + 1;

options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission),'AbsTol',1e-9,'RelTol',1e-8);
[t , state] = ode45(@(t,state) ballisticDer(t, state, Rocket, Mission),[0, 4 * Mission.torbit], [Rocket.r(end, :), Rocket.v(end, :)], options);

[Rocket, Mission] = updateRocket(t, state, Rocket, Mission);
Rocket.m = [Rocket.m; ones(size(t)) * Rocket.m(end)];

% We perform second circularization impulsive burn

[Rocket, Mission] = impulsiveBurn(Rocket, Mission, Mission.rorbit);
Rocket.tcirc2 = length(Rocket.t);






















end