function [check, stops, direction] = eventsfun(t, state, Rocket, Mission)

stops = [0, 0, 0];

h = norm(state(1:3)) - Mission.re;

if h < 101 && Rocket.actstage == 1
    check(1) = h-100;
    stops(1) = 1; %
    direction(1) = 1;
elseif Rocket.actstage == 1
    check(2) = state(7) - (Rocket.m0(Rocket.actstage) - Rocket.mprop(Rocket.actstage));
    stops(2) = 1;
    direction(2) = -1;
elseif Rocket.actstage == 2
    check(3) = state(7) - (Rocket.m0(Rocket.actstage) - Rocket.mprop(Rocket.actstage));
    stops(3) = 1;
    direction(3) = -1;
elseif Rocket.actstage == 3
    check(4) = norm(state(1:3)) - (Mission.rorbit - 10);
    %check(4) = dot(state(1:3), state(4:6));
    stops(4) = 1;
    direction(4) = -1;
end

end