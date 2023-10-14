clear
clc
close all

Rocket = Rocket;
Mission = Mission;

Rocket.r(1, :) = Rocket.r0(Mission);
Rocket.v(1, :) = Rocket.v0(Mission);
Rocket.cexh = Rocket.cexhcalc(Mission);

[Rocket, Mission] = Staging(Rocket, Mission);
[t, state, Rocket, Mission] = endoAtmPhase(Rocket, Mission);

alt = [];
vel = [];
for i = 1:length(state(:, 1))
    alt(i) = norm(state(i, 1:3)) - Mission.re;
    vel(i) = norm(state(i, 4:6));
%     dp(i) = norm(state(i, 8));
end

figure(1)
plot(t, alt/1000)
xlabel('Time [s]')
ylabel('Altitude [km]')
figure(2)
plot(t, vel/1000)
xlabel('Time [s]')
ylabel('Velocity [km/s]')

% Stage 1 maximum dynamic pressure peak of 45,000 Pa
% figure(3)
% plot(t, dp)
