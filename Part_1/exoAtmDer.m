function [ders] = exoAtmDer(t, state, Rocket, Mission)

% Separate state into components to improve code readability

r = state(1:3);
v = state(4:6);
pr = state(7:9);
pv = state(10:12);
m = Rocket.m0(Rocket.actstage) - (t * Rocket.mdot(Rocket.actstage));

% Components of the velocity derivative

weight = -1 * (Mission.mu / (norm(r)^3)) * r;
thracc = (Rocket.mdot(Rocket.actstage) * Rocket.cexh(Rocket.actstage)) / m;
vdot3 = pv / norm(pv);

% Components of the pr derivative

prdot1 = -1 * (Mission.mu / (norm(r)^3));
prdot2 = (3 * dot(pv, r) * r / (norm(r) ^2) - pv);

ders(1:3) = v;
ders(4:6) = weight + (thracc * vdot3);
ders(7:9) = prdot1 * prdot2;
ders(10:12) = -1 * pr;

ders = transpose(ders);

end