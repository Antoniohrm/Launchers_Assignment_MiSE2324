function [c, ceq] = costGuidanceFn(xopt, state, npoints, Mission, Rocket, tcorr)

% xopt = [tf, pr0x, pr0y, pr0z, pv0x, pv0y, pv0z]
% state = [rx, ry, rz, vx, vy, vz]

tf = xopt(1) * 1e2;

x0 = state;
tvec = linspace(0, tf, npoints);

[omega, phi, ~] = computeMatrices(x0, tf, Mission);

xhom = phi * [x0(1:3); x0(4:6)];

mvec = zeros(npoints, 1);

xvec(1, :) = x0(1:6);
mvec(1) = Rocket.m0(Rocket.actstage);

mdot = Rocket.mdot(Rocket.actstage);
thrust = Rocket.mdot(Rocket.actstage) * Rocket.cexh(Rocket.actstage);

dis = zeros(npoints, 3);
dic = zeros(npoints, 3);

for i = 1:npoints

    t = tvec(i);

    [~, ~, gamma] = computeMatrices(x0, t, Mission);

    pmat = gamma * [xopt(2:4); xopt(5:7)];

    pmat = pmat / norm(pmat);

    mvec(i) = mvec(1) - (mdot * t);

    dis(i, :) = (((thrust * tcorr) / mvec(i)) * sin(omega * t)) * pmat(2, :);
    dic(i, :) = (((thrust * tcorr) / mvec(i)) * cos(omega * t)) * pmat(2, :);

end

matppart = zeros(2, 3);

[~, phi, ~] = computeMatrices(x0, tf, Mission);

for i = 1:3
    matppart(1, i) = (-1 / omega) * trapz(tvec, dis(:, i));
    matppart(2, i) = trapz(tvec, dic(:, i));
end

xp = phi * matppart;

xf = xhom + xp;


% Define target apogee and perigee

rptarget = 150e3 + Mission.re; % m
ratarget = Mission.horbit + Mission.re; % m

orel = AST_pvecle([xf(1, :), xf(2, :)], Mission.mu); % Inputs in m

rp = (orel(1)) * (1 - orel(2)); % m
ra = (orel(1)) * (1 + orel(2)); % m

ceq(1) = (ra - ratarget) * 1e-7;
% ceq(2) = (rp - rptarget) * 1e-7;

c = [];

end