function [t, state, dypress, Rocket, Mission] = endoAtmPhase(Rocket, Mission)

state0 = zeros(1, 7);
state0(1:3) = Rocket.r(1, :);
state0(4:6) = Rocket.v(1, :);
state0(7) = Rocket.m0(Rocket.actstage);


inttime = Rocket.tstage;

[t, state] = ode45(@(t, state) endoAtmDer(t, state, Rocket, Mission), [0, inttime(Rocket.actstage)], state0);
% [ders] = endoAtmDer(0, state0, Rocket, Mission)
% size(ders)
% t = 0;

% To calculate dynamic pressure
vrel = [];
dens = [];
dypress = [];
for i = 1:length(state)
    vrel(i,1:3) = state(i,4:6) - cross([0, 0, Mission.we], state(i,1:3));
    [rho, ~, ~, ~] = expEarthAtm(norm(state(i,1:3)) - Mission.re);
    dens(i,1) = rho;
    dypress(i,1) = 0.5 * dens(i,1) * norm(vrel(i,1:3))^2;
end

end