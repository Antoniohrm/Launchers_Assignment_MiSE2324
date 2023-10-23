function [c, ceq] = costFunc(x, Rocket, Mission)

propt = x(1) * 1e2;
pr = x(2:4)';
pv = x(5:7)';

agstate = [Rocket.r(end, :), Rocket.v(end, :), pr, pv, Rocket.m(end)];

[t, state] = ode45(@(t, state) exoAtmDer (t, state, Rocket, Mission), [0, propt], agstate);

stateOL = AST_pvecle(state(end, 1:6), Mission.mu);

if Rocket.exoburncounter == 1
    rapf = stateOL(1) * (1 + stateOL(2));
    ceq = (rapf - Mission.rorbit) * 1e-7;
elseif Rocket.exoburncounter == 2
    rapf = stateOL(1) * (1 + stateOL(2));
    rpef = stateOL(1) * (1 - stateOL(2));

    ceq(1) = (rapf - Mission.rorbit) * 1e-7;
    ceq(2) = (rpef - Mission.rorbit) * 1e-7;
    %ceq(3) = stateOL(2) * 1e-10;
end


c = [];


end