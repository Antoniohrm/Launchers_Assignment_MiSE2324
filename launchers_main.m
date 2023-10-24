clear
clc
close all

% Initialize Rocket and Mission objects

Rocket = Rocket;
Mission = Mission;

Rocket.r(1, :) = Rocket.r0(Mission);                % Initialize position
Rocket.v(1, :) = Rocket.v0(Mission);                % Initialize ECI velocity
Rocket.cexh = Rocket.cexhcalc(Mission);             % Initialize velocities
Rocket.m(1) = Rocket.m0(Rocket.actstage);              % Initialize mass

% Rocket.kickangle = 1.275;
Rocket.kickangle = 1.4;

[Rocket, Mission] = Staging(Rocket, Mission);
[Rocket, Mission] = endoAtmPhase(Rocket, Mission);
[Rocket, Mission] = exoAtmPhase(Rocket, Mission);
% optionsfree = odeset('RelTol',1e-10);
% [t, state] = ode45(@(t, state) ballisticDer (t, state, Rocket, Mission), [0, 0.75 * Mission.torbit], [Rocket.r(end, :), Rocket.v(end, :)], optionsfree);
% [Rocket, Mission] = updateRocket(t, state, Rocket, Mission);
max(Rocket.h(Mission))


[xsph, ysph, zsph] = sphere;
xsph = xsph * Mission.re;
ysph = ysph * Mission.re;
zsph = zsph * Mission.re;

figure(1)

% subplot(1, 2, 1)
% surf(xsph, ysph, zsph);
% axis equal
% hold on
% plot3(Rocket.r(:, 1), Rocket.r(:, 2), Rocket.r(:, 3), 'LineWidth', 1);
% subplot(1, 2, 2)
% plot(Rocket.t, Rocket.h(Mission) * 1e-3);

subplot(2, 2, 1)
surf(xsph, ysph, zsph);
axis equal
hold on
plot3(Rocket.r(:, 1), Rocket.r(:, 2), Rocket.r(:, 3), 'LineWidth', 1);
subplot(2, 2, 2)
plot(Rocket.t, vecnorm(transpose(Rocket.v)));
subplot(2, 2, 3)
plot(Rocket.t, vecnorm(transpose(Rocket.vrel)));
subplot(2, 2, 4)
plot(Rocket.t, Rocket.h(Mission) * 1e-3);

% figure(2)
% 
% plot(Rocket.t, Rocket.m)

% subplot(1, 3, 1)
% plot(Rocket.t, vecnorm(transpose(Rocket.v)));
% subplot(1, 3, 2)
% plot(Rocket.t, vecnorm(transpose(Rocket.vrel)));
% subplot(1, 3, 3)
% plot(Rocket.t, Rocket.v)