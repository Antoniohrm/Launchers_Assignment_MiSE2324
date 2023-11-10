function [Rocket, Mission] = impulsiveBurn(Rocket, Mission, r)

% This function yields the modified 'Rocket' object with the updated last 
% velocity vector and mass changed, while taking 'Rocket' and 'Mission' 
% objects and the desired r value (in scalar form) for the opposite side
% of the orbit
% IMPORTANT: it assumes that the burn is being done either in the apogee or
% the perigee, where the velocity vector is perpendicular to the radius
% vector

desireda = (norm(Rocket.r(end, :)) + r) / 2;

newvnorm = sqrt(Mission.mu * ((2 / norm(Rocket.r(end, :))) - (1 / desireda)));

deltav = abs(newvnorm - norm(Rocket.v(end, :)))

vunit = Rocket.v(end, :) / norm(Rocket.v(end, :));
Rocket.v(end, :) = newvnorm * vunit;

usedm = Rocket.m(end) - (Rocket.m(end) / (exp(deltav / Rocket.cexh(Rocket.actstage))));
Rocket.m(end) = Rocket.m(end) - usedm;

end