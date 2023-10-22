clear
clc
close all

Rocket = Rocket;
Mission = Mission;

Rocket.r(1, :) = Rocket.r0(Mission);
Rocket.v(1, :) = Rocket.v0(Mission);
Rocket.cexh = Rocket.cexhcalc(Mission);
Rocket.m = Rocket.m0(Rocket.actstage);

[Rocket, Mission] = Staging(Rocket, Mission);
[Rocket, Mission] = endoAtmPhase(Rocket, Mission);

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

plot(Rocket.t, Rocket.m)


% te is a column vector of the times at which events occurred
% It give us the time when the event happened
% ye contains the solution value at each of the event times in te
% No entiendo los valores que da

% plot(t, Rocket.h(Mission));



% alt = [];
% vel = [];
% for i = 1:length(state(:, 1))
%     alt(i) = norm(state(i, 1:3)) - Mission.re;
%     vel(i) = norm(state(i, 4:6));
% end
% 
% tol = 0.001;
% pos = find(abs(t - te(1)) < tol);
% mediumpos = pos(1) + ceil((pos(end)-pos(1))/2); %Position that we arrive to 100m

% figure(1)
% plot(t(1:mediumpos), alt(1:mediumpos)/1000)
% hold on
% plot(t(mediumpos:end), alt(mediumpos:end)/1000)
% xlabel('Time [s]')
% ylabel('Altitude [km]')
% 
% figure(2)
% plot(t(1:mediumpos), vel(1:mediumpos)/1000)
% hold on
% plot(t(mediumpos:end), vel(mediumpos:end)/1000)
% xlabel('Time [s]')
% ylabel('Velocity [km/s]')

% % Stage 1 maximum dynamic pressure peak of 45,000 Pa
% figure(3)
% plot(t, dypress, 'b-')
% hold on
% plot([t(1),t(end)], [Mission.maxq, Mission.maxq],'r-')
% xlabel('Time [s]')
% ylabel('Dynamic Pressure [Pa]')
