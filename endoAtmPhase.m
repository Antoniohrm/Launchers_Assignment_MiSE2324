function [t, state, te, ye, dypress, Rocket, Mission] = endoAtmPhase(Rocket, Mission)

state0 = zeros(1, 7);
state0(1:3) = Rocket.r(1, :);
state0(4:6) = Rocket.v(1, :);
state0(7) = Rocket.m0(Rocket.actstage);


inttime = Rocket.tstage;
% options = [];
options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission),'RelTol',1e-9,'AbsTol',1e-8);
% [t, state] = ode45(@(t, state) endoAtmDer(t, state, Rocket, Mission), [0, inttime(Rocket.actstage)], options, state0);
[t, state, te, ye, ie] = ode45(@(t, state) endoAtmDer(t, state, Rocket, Mission), [0, inttime(Rocket.actstage)], state0, options);
% [ders] = endoAtmDer(0, state0, Rocket, Mission)
% te is a column vector of the times at which events occurred
% It give us the time when the event happened
% ye contains the solution value at each of the event times in te
% No entiendo los valores que da

% size(ders)

% t = 0;

% To calculate dynamic pressure
vrel = [];
dens = [];
dypress = [];
for i = 1:length(state)
    vrel(i,1:3) = state(i,4:6) - cross([0, 0, Mission.we], state(i,1:3));
    [rho, ~, ~, ~] = expEarthAtm(norm(state(i,1:3)) - Mission.re);
    dens(i,1) = rho;
    dypress(i,1) = 0.5 * dens(i,1) * norm(vrel(i,1:3))^2;
end

% Velocity at the end of the VR, 100m

tol = 0.001;
pos = find(abs(t - te(1)) < tol);
mediumpos = pos(1) + ceil((pos(end)-pos(1))/2); %Position that we arrive to 100m

vel = [];
for i = 1:length(state(:, 1))
    vel(i) = norm(state(i, 4:6));
end
% Time arrival to VR
tvr = t(mediumpos);             % Time until end of VR
vvr = vel(mediumpos);           % Velocity at the end of VR

% Instantaneus Kick Angle
kick = 1;               % deg
runit = state(1:3) / norm(state(1:3));
eunit = cross([0 0 Mission.we], runit) / norm(cross([0 0 Mission.we], runit));
vgtvec = vvr * (cosd(kick) * runit + sind(kick) * eunit);






end