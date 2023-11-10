function [xvec, mvec] = impBurn(xvec, mvec, Rocket, Mission, r)

% Calculate impulsive maneuver from xvec state vector to circularize at
% apoapsis

desireda = (norm(xvec(end, 1:3)) + r) / 2;

newvnorm = sqrt(Mission.mu * ((2 / norm(xvec(end, 1:3))) - (1 / desireda)));

deltav = abs(newvnorm - norm(xvec(end, 4:6)));

vunit = xvec(end, 4:6) / norm(xvec(end, 4:6));
xvec(end, 4:6) = newvnorm * vunit;

usedm = mvec(end) - (mvec(end) / (exp(deltav / Rocket.cexh(Rocket.actstage))));
mvec(end) = mvec(end) - usedm;

end