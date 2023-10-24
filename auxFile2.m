function [Rocket, Mission] = exoAtmPhase(Rocket, Mission)

%first propelled arc is developed
X_final_gt = [Rocket.r(end,:),Rocket.v(end,:)];

position = X_final_gt(1:3);
velocity = X_final_gt(4:6);
rp = norm(position);
vp = norm(velocity);

% Specific energy and semimajor axis of the orbit
E = vp^2/2 - Mission.mu/rp;
a = -Mission.mu/(2*E);

% Eccentricity and distance from the focus
ecc = 1 - rp/a;
ra = a*(1 + ecc);

r0 = X_final_gt(1:3);
v0 = X_final_gt(4:6);

% Inertial velocity
v_Ine = norm(v0);

% Relative velocity
v_Rel = v0 - cross([0 0 Mission.we], r0);

% Specific angular momentum vector
h0 = cross(r0, v0);

% Orbit vector
w_Orb = h0/rp^2;

% Unit vectors for pr and pv
pvU = v_Rel/norm(v_Rel);
prU = -cross(w_Orb, pvU);

% Extended initial state
augState0 = [X_final_gt, prU, pvU];

% Initial burn time and desired final altitude
propTime0 = Rocket.tstage(3); % seconds

finalRa = 700e3 + Mission.re; % Final altitude in meters

% Initial design variable settings
opt0Sc = [100*1e-2, prU, pvU];
state0 = X_final_gt;

% Design variable bounds
xConstraint(1, 1:2) = [50 propTime0] * 1e-2;
% Thrust Angular Velocity (prU) Optimization Constraints
xConstraint(2, 1:2) = [-1 1]*30*pi/180;             
xConstraint(3, 1:2) = [-1 1]*30*pi/180;
xConstraint(4, 1:2) = [-1 1]*30*pi/180;
% Thrust Direction (pvU) Optimization Constraints
xConstraint(5, 1:2) = [-1 1];
xConstraint(6, 1:2) = [-1 1];
xConstraint(7, 1:2) = [-1 1];

xlower_constraint = xConstraint(:,1); % Lower Constraint
xupper_constraint = xConstraint(:,2); % Upper Constraint

% Nonlinear constraint function

r_v0_Exo = [position velocity];
Ra_f = 700000 + Mission.re;
Rp_f = norm(position);
M0 = Rocket.m0(3); % o Rocket.m(end,:) mismo valor, bien
W_Earth = [0 0 Mission.we];
mfr_Exo = Rocket.mdot(3);
C = Rocket.cexh(3);

nonlcon = @(x)costFunc(x, Rocket, Mission);

options_mincon = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp', 'MaxFunctionEvaluations', 10000);
Xsc = fmincon(@fSolveFun, opt0Sc', [], [], [], [], [xlower_constraint], [xupper_constraint], nonlcon, options_mincon);

% Results
propTime = Xsc(1) * 1e+2 % Burn time in seconds

% Final extended state
augState = [r_v0_Exo, Xsc(2:4)', Xsc(5:7)'];

% Orbit integration
opt_Exo = odeset('AbsTol',1e-4,'RelTol',1e-6);
[t_Exo  sol_Exo] = ode45(@(t,state) exoAtmDer(t, state,Rocket, Mission),[0 propTime], augState,opt_Exo);
% [tExo, solExo] = ode45(@(t, x) exoFlightDeriv(t, x, C, mfr_Exo, M0, mu, W_Earth), [0 propTime], augState, opt_Exo);

[Rocket, Mission] = updateRocket(t_Exo, sol_Exo, Rocket, Mission);
mflow = Rocket.m0(Rocket.actstage) - (t_Exo * Rocket.mdot(Rocket.actstage));
Rocket.m = [Rocket.m; mflow];

pos = sol_Exo(:, 1:3);
vel = sol_Exo(:, 4:6);

% Orbit analysis
posN = zeros(length(t_Exo), 1);
velN = zeros(length(t_Exo), 1);
velRN = zeros(length(t_Exo), 1);

for ii = 1:length(t_Exo)
    posN(ii) = norm(pos(ii, :));
    velN(ii) = norm(vel(ii, :));
    velRN(ii) = norm(vel(ii, :) - cross([0 0 Mission.we], pos(ii, :)));
end

% % Plots
% figure
% plot(t_Exo, (posN - Mission.re) * 1e-3, 'r', 'LineWidth', 3);
% set(gca, 'FontSize', 14);
% xlabel('Time [s]', 'FontSize', 14);
% ylabel('Altitude [km]', 'FontSize', 14);
% grid on
% 
% figure
% plot(t_Exo, (velN) * 1e-3, 'r', 'LineWidth', 3);
% set(gca, 'FontSize', 14);
% xlabel('Time [s]', 'FontSize', 14);
% ylabel('Inertial Velocity [km/s]', 'FontSize', 14);
% grid on

% figure
% plot(t_Exo, (velRN) * 1e-3, 'r', 'LineWidth', 3);
% set(gca, 'FontSize', 14);
% xlabel('Time [s]', 'FontSize', 14);
% ylabel('Relative Velocity [km/s]', 'FontSize', 14);
% grid on

% State at the end of the propelled arc
Xf_1 = sol_Exo(end, 1:6);
rf_1 = Xf_1(1:3);
vf_1 = Xf_1(4:6);

% Final relative velocity
vfRel_1 = norm(vf_1 - cross([0 0 Mission.we], rf_1));

% Computation of orbital elements
eleF_1 = AST_pvecle(Xf_1, Mission.mu);
a_final_1 = eleF_1(1);
ecc_f_1 = eleF_1(2);

% Distances from Earth center to apogee and perigee points
raf_1 = a_final_1 * (1 + ecc_f_1);
rpf_1 = a_final_1 * (1 - ecc_f_1);

% Apogee and perigee altitudes
haf_1 = (raf_1 - Mission.re) * 1e-3 % Apogee altitude in km
hpf_1 = (rpf_1 - Mission.re) * 1e-3 % Perigee altitude in km

end


















