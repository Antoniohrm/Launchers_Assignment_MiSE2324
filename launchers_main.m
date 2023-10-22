clear
clc
close all

% Initialize Rocket and Mission objects

Rocket = Rocket;
Mission = Mission;

Rocket.r(1, :) = Rocket.r0(Mission);                % Initialize initial position
Rocket.v(1, :) = Rocket.v0(Mission);                % Initialize initial ECI velocity
Rocket.cexh = Rocket.cexhcalc(Mission);             % Initialize exhaust velocities
Rocket.m = Rocket.m0(Rocket.actstage);              % Initialize initial mass

[Rocket, Mission] = Staging(Rocket, Mission);
[Rocket, Mission] = endoAtmPhase(Rocket, Mission);
[Rocket, Mission, Xsc] = exoAtmPhase(Rocket, Mission);

figure(1)

subplot(2, 2, 1)
plot(Rocket.t, Rocket.vrel(:, 1));
subplot(2, 2, 2)
plot(Rocket.t, Rocket.vrel(:, 2));
subplot(2, 2, 3)
plot(Rocket.t, Rocket.vrel(:, 3));
subplot(2, 2, 4)
plot(Rocket.t, Rocket.h(Mission));

figure(2)

subplot(1, 3, 1)
plot(Rocket.t, vecnorm(transpose(Rocket.v)));
subplot(1, 3, 2)
plot(Rocket.t, vecnorm(transpose(Rocket.vrel)));
subplot(1, 3, 3)
plot(Rocket.t, Rocket.v)