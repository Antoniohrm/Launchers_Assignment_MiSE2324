function [q] = qCalc(Rocket, Mission)

[dens, ~, ~, ~] = expEarthAtm(Rocket.hf(:));
q = 0.5 .* dens .* norm(Rocket.vrel).^2;

end