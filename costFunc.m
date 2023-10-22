function [c, ceq] = costFunc(x, Rocket, Mission)

propt = x(1) * 1e2;
pr = x(2:4)';
pv = x(5:7)';

agstate = [Rocket.r(end, :), Rocket.v(end, :), pr, pv, Rocket.m0(Rocket.actstage)];

[t, state] = ode45(@(t, state) exoAtmDer (t, state, Rocket, Mission), [0, propt], agstate);

stateOL = AST_pvecle(state(end, 1:6), Mission.mu);

rapf = stateOL(1) * (1 + stateOL(2));

c = [];
ceq = (rapf - Mission.rorbit) * 1e-7;

end