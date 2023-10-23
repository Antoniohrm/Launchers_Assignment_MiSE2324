function [Rocket, Mission] = updateRocket(t, state, Rocket, Mission)

Rocket.r = [Rocket.r; state(:, 1:3)];
Rocket.v = [Rocket.v; state(:, 4:6)];
Rocket.t = [Rocket.t; t + Rocket.t(end)];
Rocket.m = [Rocket.m; state(:, size(state, 2))];
Rocket.vrel = Rocket.vrelCalc(Mission);

end