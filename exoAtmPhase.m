function [Rocket, Mission, Xsc] = exoAtmPhase(Rocket, Mission)

angmom0 = cross(Rocket.r(end, :), Rocket.v(end, :));
worb0 = angmom0 / (norm(Rocket.r(end, :)) ^2);

pvU = Rocket.vrel(end, :) / norm(Rocket.vrel(end, :));
prU = -1 * cross(worb0, pvU);

agstate0 = [Rocket.r(end, :), Rocket.v(end, :), prU, pvU];

propt = Rocket.tstage(Rocket.actstage);

opt0Sc = [propt * 1e-2, prU, pvU];

state0 = [Rocket.r(end, :), Rocket.v(end, :)];

%Time optimization bounds
xBound(1, 1:2) = [50 propt]*1e-2; % normalized
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

propTime = Xsc(1)*1e+2;
%
agstate = [state0, Xsc(2:4)', Xsc(5:7)', Rocket.m0(Rocket.actstage)];

[t,  state] = ode45(@(t, state) exoAtmDer(t, state, Rocket, Mission), [0 propTime], agstate);

Rocket.r = [Rocket.r; state(:, 1:3)];
Rocket.v = [Rocket.v; state(:, 4:6)];
Rocket.m = [Rocket.m; state(:, 13)];
Rocket.t = [Rocket.t; t + Rocket.t(end)];
Rocket.vrel = Rocket.vrelCalc(Mission);

end



















