function [omega, phi, gamma] = computeMatrices(x, t, Mission)

omega = sqrt(Mission.mu / (norm(x(1:3))^3));

phi = [cos(omega * t), (1 / omega) * sin(omega * t);
    -1 * omega * sin(omega * t), cos(omega * t)
    ];

gamma = [cos(omega * t), omega * sin(omega * t);
    -1 * (1 / omega) * sin(omega * t), cos(omega * t)
    ];

end