clear
clc
close all

Rocket = Rocket;
Mission = Mission;

Rocket.r(1, :) = Rocket.r0(Mission);
Rocket.v(1, :) = Rocket.v0(Mission);
Rocket.cexh = Rocket.cexhcalc(Mission);

[Rocket, Mission] = Staging(Rocket, Mission);
[t, state, te, ye, dypress, Rocket, Mission] = endoAtmPhase(Rocket, Mission);
% te is a column vector of the times at which events occurred
% It give us the time when the event happened
% ye contains the solution value at each of the event times in te
% No entiendo los valores que da

alt = [];
vel = [];
for i = 1:length(state(:, 1))
    alt(i) = norm(state(i, 1:3)) - Mission.re;
    vel(i) = norm(state(i, 4:6));
end

tol = 0.001;
pos = find(abs(t - te(1)) < tol)
mediumpos = pos(1) + ceil((pos(end)-pos(1))/2); %Position that we arrive to 100m

figure(1)
plot(t(1:mediumpos), alt(1:mediumpos)/1000)
hold on
plot(t(mediumpos:end), alt(mediumpos:end)/1000)
xlabel('Time [s]')
ylabel('Altitude [km]')

figure(1)
plot(t, alt/1000)
xlabel('Time [s]')
ylabel('Altitude [km]')
figure(2)
plot(t, vel/1000)
xlabel('Time [s]')
ylabel('Velocity [km/s]')

% Stage 1 maximum dynamic pressure peak of 45,000 Pa
figure(3)
plot(t, dypress, 'b-')
hold on
plot([t(1),t(end)], [Mission.maxq, Mission.maxq],'r-')
xlabel('Time [s]')
ylabel('Dynamic Pressure [Pa]')
