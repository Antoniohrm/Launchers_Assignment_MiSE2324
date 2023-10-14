function [t, state, Rocket, Mission] = endoAtmPhase(Rocket, Mission)

state0 = zeros(1, 7);
state0(1:3) = Rocket.r(1, :);
state0(4:6) = Rocket.v(1, :);
state0(7) = Rocket.m0(Rocket.actstage);

inttime = Rocket.tstage;

[t, state] = ode45(@(t, state) endoAtmDer(t, state, Rocket, Mission), [0, inttime(Rocket.actstage)], state0);
% [ders] = endoAtmDer(0, state0, Rocket, Mission)
% size(ders)
% t = 0;

end