function [optres] = optimizeBurn(Rocket, Mission)

% This function optimizes a burn straight out of the second stage burnout
% to reach an apoapsis equivalent to the goal circular orbit, defined in 
% the 'Mission.rorbit' parameter of the 'Mission' object

% Prepare initial augmented state

h0 = cross(Rocket.r(end, :), Rocket.v(end, :));
omega0 = h0 / (norm(Rocket.r(end, :))^2);

pvU = Rocket.vrel(end, :) / norm(Rocket.vrel(end, :));
prU = -1 * cross(omega0, pvU);

agstate0 = [Rocket.r(end, :), Rocket.v(end, :)];
propt0 = Rocket.tstage(Rocket.actstage);

opt0Sc = [100 * 1e-2, prU, pvU];

% Design variable bounds

optconstraints(1, 1:2) = [50 propt0] * 1e-2;

% Thrust Angular Velocity (prU) Optimization Constraints
optconstraints(2, 1:2) = [-1 1]*30*pi/180;             
optconstraints(3, 1:2) = [-1 1]*30*pi/180;
optconstraints(4, 1:2) = [-1 1]*30*pi/180;

% Thrust Direction (pvU) Optimization Constraints
optconstraints(5, 1:2) = [-1 1];
optconstraints(6, 1:2) = [-1 1];
optconstraints(7, 1:2) = [-1 1];

% Separate into lower and upper bounds

optlowerbounds = optconstraints(:,1); % Lower Constraint
optupperbounds = optconstraints(:,2); % Upper Constraint

% Create reference to the cost function and declare the initially "empty"
% variable x

nonlcon = @(x)costFunc(x, Rocket, Mission);

optoptions = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp', 'MaxFunctionEvaluations', 10000);
optres = fmincon(@fSolveFun, opt0Sc', [], [], [], [], [optlowerbounds], [optupperbounds], nonlcon, optoptions);

end