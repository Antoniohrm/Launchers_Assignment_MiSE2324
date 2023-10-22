function [ders] = ballisticDer(t, state, Rocket, Mission)

weight = -1 * Rocket.m0(Rocket.actstage) * (Mission.mu / (norm(state(1:3))^3)) * state(1:3);

ders(1:3) = state(4:6);
ders(4:6) = weight / Rocket.m0(Rocket.actstage);
ders(7) = 0;

ders = transpose(ders);

end
