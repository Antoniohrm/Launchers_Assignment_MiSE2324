function [t, state, te, ye, Rocket, Mission] = endoAtmPhase(Rocket, Mission)

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

% Velocity at the end of the VR, 100m

Rocket.r = state(:, 1:3);
Rocket.v = state(:, 4:6);
Rocket.vrel = Rocket.vrelCalc(Mission);
Rocket.m = state(end, 7);
norm(Rocket.v(end, :))
Rocket.v(end, :) = Rocket.applyKickangle(Mission)

figure(1)

subplot(1, 3, 1)
plot(t, vecnorm(transpose(Rocket.v)));
subplot(1, 3, 2)
plot(t, vecnorm(transpose(Rocket.vrel)));
subplot(1, 3, 3)
plot(t, Rocket.v)
% 
% figure(2)
% 
% subplot(2, 2, 1)
% plot(t, Rocket.v(:, 1));
% subplot(2, 2, 2)
% plot(t, Rocket.v(:, 2));
% subplot(2, 2, 3)
% plot(t, Rocket.v(:, 3));
% subplot(2, 2, 4)
% plot(t, Rocket.h(Mission));


% % Time arrival to VR
% tvr = t(mediumpos);             % Time until end of VR
% % vvr = vel(mediumpos);           % Velocity at the end of VR
% vvr = norm(vrel(end,1:3))
% 
% % Instantaneus Kick Angle
% kick = 1;               % deg
% runit = state(end,1:3) / norm(state(end,1:3));
% eunit = cross([0 0 Mission.we], runit) / norm(cross([0 0 Mission.we], runit));
% vgtvec = vvr * ((cosd(kick) * runit) + (sind(kick) * eunit)); % Releative Velocity at the beginning of gravity turn
% 
% state(end,4:6) = vgtvec + cross([0, 0, Mission.we], state(end,1:3));
% 
% % Integration for Gravity Turn of 1st Stage
% options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission),'RelTol',1e-9,'AbsTol',1e-8);
% [t, state, te, ye, ie] = ode45(@(t, state) endoAtmDer(t, state, Rocket, Mission), [0, inttime(Rocket.actstage)], state0, options);
% 






end