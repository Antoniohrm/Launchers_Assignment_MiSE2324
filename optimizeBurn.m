function [Xsc] = optimizeBurn(Rocket, Mission)

angmom0 = cross(Rocket.r(end, :), Rocket.v(end, :));
worb0 = angmom0 / (norm(Rocket.r(end, :)) ^2);

pvU = Rocket.vrel(end, :) / norm(Rocket.vrel(end, :));
prU = -1 * cross(worb0, pvU);

agstate0 = [Rocket.r(end, :), Rocket.v(end, :), prU, pvU];

propt = Rocket.tstage(Rocket.actstage);

opt0Sc = [propt * 1e-2, prU, pvU];

state0 = [Rocket.r(end, :), Rocket.v(end, :)];

%Time optimization bounds
xBound(1, 1:2) = [1 propt]*1e-2; % normalized
% Thrust angular velocity (pru) optimization bounds
xBound(2, 1:2) = [-1 1]*30*pi/180; % Thrust angular velocity pr is limited at 30 deg/s
xBound(3, 1:2) = [-1 1]*30*pi/180;
xBound(4, 1:2) = [-1 1]*30*pi/180;
% Thrust direction (pvu) optimization bounds
xBound(5, 1:2) = [-1 1];
xBound(6, 1:2) = [-1 1];
xBound(7, 1:2) = [-1 1];
%
%FBound(1,:)    = xBound(1,   1:2);
%
xlb = xBound(:,1);
xub = xBound(:,2);

nonlcon = @costFunc;

options = optimoptions('fmincon','Display','iter', 'Algorithm', 'sqp','MaxFunctionEvaluations',3000);
Xsc = fmincon(@fSolveFun,opt0Sc',[],[],[],[],[xlb],[xub],@(x) nonlcon(x, Rocket, Mission), options);

end