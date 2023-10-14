function [stateint, Rocket, Mission] = endoAtmPhase(Rocket, Mission)

state = zeros(1, 7);
state(1:3) = Rocket.r(1, :);
%state(4:6) = Rocket.v(1, :);
state(4:6) = [1, 1, 1];
state(7) = Rocket.m0(1);

max_time = 60;
curstate = [];

%[t, stateint] = ode45(@(t, curstate) endoAtmDer(t, curstate, Rocket, Mission), [0, max_time], state);
[t, ders] = endoAtmDer(0, state, Rocket, Mission)
% w = Rocket.m0(1) * Mission.g * sind(Mission.latlaunch)
% w = Rocket.m0(1) * Mission.g * cosd(Mission.latlaunch)


end