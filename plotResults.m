function [] = plotResults(Rocket, Mission)

% 3D trajectory over the Earth (Assume spherical Earth)

figure(1)

[xsph, ysph, zsph] = sphere;
xsph = xsph * Mission.re;
ysph = ysph * Mission.re;
zsph = zsph * Mission.re;

surf(xsph, ysph, zsph);
axis equal
hold on
plot3(Rocket.r(:, 1), Rocket.r(:, 2), Rocket.r(:, 3), 'LineWidth', 2);
title('Trajectory of the rocket over the Earth', 'FontSize', 16)
fontsize(gca, 12, 'points')

% Full altitude profile

figure(2)

index = 1:Rocket.tvr;
plot(Rocket.t(index), Rocket.hf(index), 'LineWidth', 3);
hold on
index = Rocket.tvr:Rocket.tstburn(1);
plot(Rocket.t(index), Rocket.hf(index), 'r', 'LineWidth', 3);
hold on
index = Rocket.tstburn(1):Rocket.tstburn(2);
plot(Rocket.t(index), Rocket.hf(index), 'g', 'LineWidth', 3);
hold on
index = Rocket.tstburn(2):Rocket.toptburn;
plot(Rocket.t(index), Rocket.hf(index), 'y', 'LineWidth', 3);
hold on
index = Rocket.toptburn:Rocket.tcirc1;
plot(Rocket.t(index), Rocket.hf(index), 'c', 'LineWidth', 3);
hold on
index = Rocket.tcirc1:Rocket.tcirc2;
plot(Rocket.t(index), Rocket.hf(index), 'm', 'LineWidth', 3);

xlabel('Time since liftoff (s)', 'FontSize', 14)
ylabel('Altitude (km)', 'FontSize', 14)
title('Evolution of altitude over time, from liftoff to second circularization burn', 'FontSize', 16)
legend('Vertical rising', 'First stage gravity turn', 'Second stage gravity turn', ...
    'Optimized exoatmospheric burn', 'Ballistic flight before circularizing', ...
    'Ballistic flight after first circularization', 'FontSize', 12)
fontsize(gca, 12, 'points')

% Endoatmospheric altitude profile

figure(3)

index = 1:Rocket.tvr;
plot(Rocket.t(index), Rocket.hf(index), 'LineWidth', 3);
hold on
index = Rocket.tvr:Rocket.tstburn(1);
plot(Rocket.t(index), Rocket.hf(index), 'r', 'LineWidth', 3);
hold on
index = Rocket.tstburn(1):Rocket.tstburn(2);
plot(Rocket.t(index), Rocket.hf(index), 'g', 'LineWidth', 3);

xlabel('Time since liftoff (s)', 'FontSize', 14)
ylabel('Altitude (km)', 'FontSize', 14)
title('Evolution of altitude over time, from liftoff to second stage burnout', 'FontSize', 16)
legend('Vertical rising', 'First stage gravity turn', 'Second stage gravity turn', 'FontSize', 12)
fontsize(gca, 12, 'points')

% Exoatmospheric altitude profile until second circularization burn

figure(4)

index = Rocket.tstburn(2):Rocket.toptburn;
plot(Rocket.t(index), Rocket.hf(index), 'y', 'LineWidth', 3);
hold on
index = Rocket.toptburn:Rocket.tcirc1;
plot(Rocket.t(index), Rocket.hf(index), 'c', 'LineWidth', 3);
hold on
index = Rocket.tcirc1:Rocket.tcirc2;
plot(Rocket.t(index), Rocket.hf(index), 'm', 'LineWidth', 3);

xlabel('Time since liftoff (s)', 'FontSize', 14)
ylabel('Altitude (km)', 'FontSize', 14)
title('Evolution of altitude over time, from second stage burnout to second circularization burn', 'FontSize', 16)
legend('Optimized exoatmospheric burn', 'Ballistic flight before circularizing', ...
    'Ballistic flight after first circularization', 'FontSize', 12)
fontsize(gca, 12, 'points')

% Exoatmospheric altitude profile until second circularization burn

figure(5)

index = Rocket.tstburn(2):Rocket.toptburn;
plot(Rocket.t(index), Rocket.hf(index), 'y', 'LineWidth', 3);
hold on
index = Rocket.toptburn:Rocket.tcirc1;
plot(Rocket.t(index), Rocket.hf(index), 'c', 'LineWidth', 3);

xlabel('Time since liftoff (s)', 'FontSize', 14)
ylabel('Altitude (km)', 'FontSize', 14)
title('Evolution of altitude over time, from second stage burnout to first circularization burn', 'FontSize', 16)
legend('Optimized exoatmospheric burn', 'Ballistic flight before circularizing', 'FontSize', 12)
fontsize(gca, 12, 'points')

% Full velocity profile

vvec = vecnorm(transpose(Rocket.v));

figure(6)

index = 1:Rocket.tvr;
plot(Rocket.t(index), vvec(index), 'LineWidth', 3);
hold on
index = Rocket.tvr:Rocket.tstburn(1);
plot(Rocket.t(index), vvec(index), 'r', 'LineWidth', 3);
hold on
index = Rocket.tstburn(1):Rocket.tstburn(2);
plot(Rocket.t(index), vvec(index), 'g', 'LineWidth', 3);
hold on
index = Rocket.tstburn(2):Rocket.toptburn;
plot(Rocket.t(index), vvec(index), 'y', 'LineWidth', 3);
hold on
index = Rocket.toptburn:Rocket.tcirc1;
plot(Rocket.t(index), vvec(index), 'c', 'LineWidth', 3);
hold on
index = Rocket.tcirc1:Rocket.tcirc2;
plot(Rocket.t(index), vvec(index), 'm', 'LineWidth', 3);

xlabel('Time since liftoff (s)', 'FontSize', 14)
ylabel('Velocity (m/s)', 'FontSize', 14)
title('Evolution of velocity over time, from liftoff to second circularization burn', 'FontSize', 16)
legend('Vertical rising', 'First stage gravity turn', 'Second stage gravity turn', ...
    'Optimized exoatmospheric burn', 'Ballistic flight before circularizing', ...
    'Ballistic flight after first circularization', 'FontSize', 12)
fontsize(gca, 12, 'points')

% Endoatmospheric velocity profile

figure(7)

index = 1:Rocket.tvr;
plot(Rocket.t(index), vvec(index), 'LineWidth', 3);
hold on
index = Rocket.tvr:Rocket.tstburn(1);
plot(Rocket.t(index), vvec(index), 'r', 'LineWidth', 3);
hold on
index = Rocket.tstburn(1):Rocket.tstburn(2);
plot(Rocket.t(index), vvec(index), 'g', 'LineWidth', 3);

xlabel('Time since liftoff (s)', 'FontSize', 14)
ylabel('Velocity (m/s)', 'FontSize', 14)
title('Evolution of velocity over time, from liftoff to second stage burnout', 'FontSize', 16)
legend('Vertical rising', 'First stage gravity turn', 'Second stage gravity turn', 'FontSize', 12)
fontsize(gca, 12, 'points')

% Exoatmospheric velocity profile until second circularization burn

figure(8)

index = Rocket.tstburn(2):Rocket.toptburn;
plot(Rocket.t(index), vvec(index), 'y', 'LineWidth', 3);
hold on
index = Rocket.toptburn:Rocket.tcirc1;
plot(Rocket.t(index), vvec(index), 'c', 'LineWidth', 3);
hold on
index = Rocket.tcirc1:Rocket.tcirc2;
plot(Rocket.t(index), vvec(index), 'm', 'LineWidth', 3);

xlabel('Time since liftoff (s)', 'FontSize', 14)
ylabel('Velocity (m/s)', 'FontSize', 14)
title('Evolution of velocity over time, from second stage burnout to second circularization burn', 'FontSize', 16)
legend('Optimized exoatmospheric burn', 'Ballistic flight before circularizing', ...
    'Ballistic flight after first circularization', 'FontSize', 12)
fontsize(gca, 12, 'points')

% Exoatmospheric velocity profile until first circularization burn

figure(9)

index = Rocket.tstburn(2):Rocket.toptburn;
plot(Rocket.t(index), vvec(index), 'y', 'LineWidth', 3);
hold on
index = Rocket.toptburn:Rocket.tcirc1;
plot(Rocket.t(index), vvec(index), 'c', 'LineWidth', 3);

xlabel('Time since liftoff (s)', 'FontSize', 14)
ylabel('Velocity (m/s)', 'FontSize', 14)
title('Evolution of velocity over time, from second stage burnout to first circularization burn', 'FontSize', 16)
legend('Optimized exoatmospheric burn', 'Ballistic flight before circularizing', 'FontSize', 12)
fontsize(gca, 12, 'points')

% Full mass profile

figure(10)

index = 1:Rocket.tvr;
plot(Rocket.t(index), Rocket.m(index), 'LineWidth', 3);
hold on
index = Rocket.tvr:Rocket.tstburn(1);
plot(Rocket.t(index), Rocket.m(index), 'r', 'LineWidth', 3);
hold on
index = Rocket.tstburn(1):Rocket.tstburn(2);
plot(Rocket.t(index), Rocket.m(index), 'g', 'LineWidth', 3);
hold on
index = Rocket.tstburn(2):Rocket.toptburn;
plot(Rocket.t(index), Rocket.m(index), 'y', 'LineWidth', 3);
hold on
index = Rocket.toptburn:Rocket.tcirc1;
plot(Rocket.t(index), Rocket.m(index), 'c', 'LineWidth', 3);
hold on
index = Rocket.tcirc1:Rocket.tcirc2;
plot(Rocket.t(index), Rocket.m(index), 'm', 'LineWidth', 3);

% Plot reference no-mass line

hold on
emptypropmass = Rocket.m0(3) - Rocket.mprop(3);
plot([Rocket.t(1), Rocket.t(Rocket.tcirc2)], [emptypropmass, emptypropmass], 'k', 'LineStyle', '-.', 'LineWidth', 2)

xlabel('Time since liftoff (s)', 'FontSize', 14)
ylabel('Mass (kg)', 'FontSize', 14)
title('Evolution of mass over time, from liftoff to second circularization burn', 'FontSize', 16)
legend('Vertical rising', 'First stage gravity turn', 'Second stage gravity turn', ...
    'Optimized exoatmospheric burn', 'Ballistic flight before circularizing', ...
    'Ballistic flight after first circularization', 'Mass of the out-of-fuel rocket', 'FontSize', 12)
fontsize(gca, 12, 'points')

figure(11)

% Endoatmospheric mass profile

index = 1:Rocket.tvr;
plot(Rocket.t(index), Rocket.m(index), 'LineWidth', 3);
hold on
index = Rocket.tvr:Rocket.tstburn(1);
plot(Rocket.t(index), Rocket.m(index), 'r', 'LineWidth', 3);
hold on
index = Rocket.tstburn(1):Rocket.tstburn(2);
plot(Rocket.t(index), Rocket.m(index), 'g', 'LineWidth', 3);

% Plot reference no-mass line

hold on
emptypropmass = Rocket.m0(3) - Rocket.mprop(3);
plot([Rocket.t(1), Rocket.t(Rocket.tstburn(2))], [emptypropmass, emptypropmass], 'k', 'LineStyle', '-.', 'LineWidth', 2)

xlabel('Time since liftoff (s)', 'FontSize', 14)
ylabel('Mass (kg)', 'FontSize', 14)
title('Evolution of mass over time, from liftoff to second stage burnout', 'FontSize', 16)
legend('Vertical rising', 'First stage gravity turn', 'Second stage gravity turn', ...
     'Mass of the out-of-fuel rocket', 'FontSize', 12)
fontsize(gca, 12, 'points')

% Exoatmospheric mass profile

figure(12)

index = Rocket.tstburn(2):Rocket.toptburn;
plot(Rocket.t(index), Rocket.m(index), 'y', 'LineWidth', 3);
hold on
index = Rocket.toptburn:Rocket.tcirc1;
plot(Rocket.t(index), Rocket.m(index), 'c', 'LineWidth', 3);
hold on
index = Rocket.tcirc1:Rocket.tcirc2;
plot(Rocket.t(index), Rocket.m(index), 'm', 'LineWidth', 3);

% Plot reference no-mass line

hold on
emptypropmass = Rocket.m0(3) - Rocket.mprop(3);
plot([Rocket.t(Rocket.tstburn(2)), Rocket.t(Rocket.tcirc2)], [emptypropmass, emptypropmass], 'k', 'LineStyle', '-.', 'LineWidth', 2)

xlabel('Time since liftoff (s)', 'FontSize', 14)
ylabel('Mass (kg)', 'FontSize', 14)
title('Evolution of mass over time, from second stage burnout to second circularization burn', 'FontSize', 16)
legend('Optimized exoatmospheric burn', 'Ballistic flight before circularizing', ...
    'Ballistic flight after first circularization', 'Mass of the out-of-fuel rocket', 'FontSize', 12)
fontsize(gca, 12, 'points')








