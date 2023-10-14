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
end

figure(1)
plot(t, alt)
figure(2)
plot(t, vel)