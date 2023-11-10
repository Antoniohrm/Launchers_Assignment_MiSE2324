function [tvec, xvec, mvec] = propagateGuidedBurn(tf, agstate0, Rocket, Mission, tcorr, npoints)

% agstate0 = [rx0, ry0, rz0, vx0, vy0, vz0, pr0x, pr0y, pr0z, pv0x, pv0y,
%           pv0z]

% Initialize final state results matrix

xvec = zeros(npoints, 6);

tf = tf;
x0 = agstate0(1:6);
p0 = agstate0(7:12);
xvec(1, :) = x0;

tvec = tf * linspace(0, 1, npoints);

[omega, phi, ~] = computeMatrices(x0, tf, Mission);

% xhom = phi * [x0(1:3); x0(4:6)];

mvec = zeros(npoints, 1);

mvec(1) = Rocket.m0(Rocket.actstage);

mdot = Rocket.mdot(Rocket.actstage);
thrust = Rocket.mdot(Rocket.actstage) * Rocket.cexh(Rocket.actstage);

dis = zeros(npoints, 3);
dic = zeros(npoints, 3);

for i = 1:npoints
    t = tvec(i);

    [~, ~, gamma] = computeMatrices(x0, t, Mission);

    pmat = gamma * [p0(1:3); p0(4:6)];

    pmat = pmat / norm(pmat);

    mvec(i) = mvec(1) - (mdot * t);

    dis(i, :) = (((thrust * tcorr) / mvec(i)) * sin(omega * t)) * pmat(2, :);
    dic(i, :) = (((thrust * tcorr) / mvec(i)) * cos(omega * t)) * pmat(2, :);

end

for p = 2:npoints

    matppart = zeros(2, 3);

    [~, phi, ~] = computeMatrices(x0, tvec(p), Mission);

    xhom = phi * [x0(1:3); x0(4:6)];
    
    if p == 0
        for i = 1:3
            matppart(1, i) = (-1 / omega) * (tvec(1) * dis(1, i));
            matppart(2, i) = (tvec(1) * dic(1, i));
        end
    else
        for i = 1:3
             matppart(1, i) = (-1 / omega) * trapz(tvec(1:p), dis(1:p, i));
             matppart(2, i) = trapz(tvec(1:p), dic(1:p, i));
        end
    end
    
    xp = phi * matppart;
    
    xf = xhom + xp;

    xvec(p, 1:3) = xf(1, :);
    xvec(p, 4:6) = xf(2, :);
end

end
