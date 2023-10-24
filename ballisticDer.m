function [ders] = ballisticDer(t, state, Rocket, Mission)

weightacc = -1 * (Mission.mu / (norm(state(1:3))^3)) * state(1:3);

ders(1:3) = state(4:6);
ders(4:6) = weightacc;
% ders(7) = 0;

ders = transpose(ders);

end
