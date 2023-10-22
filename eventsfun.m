function [check, stops, direction] = eventsfun(t, state, Rocket, Mission)

stops = [0, 0, 0];

h = norm(state(1:3)) - Mission.re;
if h < 101 && Rocket.actstage == 1
    check(1) = h-100;
    stops(1) = 1; %
    direction(1) = 1;
elseif Rocket.actstage == 1
    check(2) = state(7) - (Rocket.m0(1) - Rocket.mprop(1));
    stops(2) = 1;
    direction(2) = -1;
elseif Rocket.actstage == 3
    check(3) = norm(state(1:3)) - (Mission.rorbit - 100);
    stops(3) = 1;
    direction(3) = 1;
end

end