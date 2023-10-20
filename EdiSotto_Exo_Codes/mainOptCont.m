%This is the main function for the optimum control problem implementing the
%optimisation of the first boost of VA 244 flight 
%
clear all
close all
%
global state0  mu finalRa
%
% All the values are expressed in SI 
%
mu = 398602*1e+9;
Re = 6378140;
wV = [ 0 0  2*pi/86164];
rp = 163*1e+3 +Re;
%
vp = 8260 + 260;% This values are obtained through the video of the launch VA244. The velocity in the video (8260 m/s) 
                % is relative velocity modulus. The added value of 260 m/s
                % is the projection of the Earth Velocity at Kourou on the
                % launch Azimuth direction (56 deg)
%
RAAN = 0;
INCL = 56*pi/180;
TRAN = 0*pi/180;
WPER = 20*pi/180;
%
%
E    = vp^2/2 - mu/rp;
SAXI = -mu/(2*E);
%
ECC  = 1 - rp/SAXI;
ra   = SAXI*(1 + ECC);
%
ele0 = [ SAXI, ECC, INCL, RAAN, WPER, TRAN];
%
X    = AST_pelvec(ele0, mu);
%
% Initialise the primer assuming directed along the velocity vector and the
% angualar velocity as the orbit mean motion 
% 
r0 = X(1:3);
v0 = X(4:6);
%
velIne = norm(v0)
%
velRel = v0 - cross(wV, r0);
%
h0   = cross(r0,v0);

wOrb = h0/rp^2; 
%
%pvU = X(4:6)/norm(X(4:6));
pvU = velRel/norm(velRel);
prU = -cross(wOrb, pvU);% the minus sign comes from the primer dynamics prU = -pVUDot 
%
augState0 = [X, prU, pvU];
%
propTime0 = 200;%600;%639; %sec
finalRa = 22922*1e+3 + Re;
%finalRp = 3.9574e+05;
%
opt0Sc     = [propTime0*1e-2, prU, pvU];
%
state0 = X;
%
xBound(1, 1:2) = [200 1000]*1e-2;
xBound(2, 1:2) = [-1 1]*30*pi/180; % Thrust angular velocity pr is limited at 30 deg/s
xBound(3, 1:2) = [-1 1]*30*pi/180;
xBound(4, 1:2) = [-1 1]*30*pi/180;
%
xBound(5, 1:2) = [-1 1];
xBound(6, 1:2) = [-1 1];
xBound(7, 1:2) = [-1 1];
%
%FBound(1,:)    = xBound(1,   1:2);
%
xlb = xBound(:,1);
xub = xBound(:,2);
%
% Flow = FBound(:,1);
% Fupp = FBound(:,2);
%
nonlcon = @cConFun;
%
options = optimoptions('fmincon','Display','iter', 'Algorithm', 'sqp','MaxFunctionEvaluations',3000);
Xsc = fmincon(@fSolveFun,opt0Sc',[],[],[],[],[xlb],[xub],nonlcon, options);
%
propTime = Xsc(1)*1e+2
%
augState = [state0, Xsc(2:4)', Xsc(5:7)'];

[tExo  solExo] = ode45(@exoFlightDeriv,[0 propTime], augState);
%
pos = solExo(:, 1:3);
vel = solExo(:, 4:6);
%
for ii =1:length(tExo)
    posN(ii) = norm(pos(ii,:));
    velN(ii) = norm(vel(ii,:));
    
    velRN(ii) = norm(vel(ii,:) - cross(wV, pos(ii,:)));
end
%
figure
plot(tExo, (posN - Re)*1e-3,'r', 'LineWidth',3)
set(gca, 'FontSize',14)
xlabel('Time [s]', 'FontSize',14)
ylabel('Altitude [km]', 'FontSize',14)
grid on 
%
%
figure
plot(tExo, (velN)*1e-3,'r','LineWidth',3);
set(gca, 'FontSize',14);
xlabel('Time [s]', 'FontSize',14);
ylabel('Inertal Velocity [km/s]', 'FontSize',14);
grid on 
%
figure
plot(tExo, (velRN)*1e-3,'r','LineWidth',3);
set(gca, 'FontSize',14);
xlabel('Time [s]', 'FontSize',14);
ylabel('Relative Velocity [km/s]', 'FontSize',14);
grid on 
%
%exoFlightDeriv(0, augState0)
Xf = solExo(end,1:6);
%
rf = Xf(1:3);
vf = Xf(4:6);
%
vfRel = norm (vf - cross(wV, rf))
%
eleF = AST_pvecle(Xf,mu);
%
SAXI_F = eleF(1);
ECC_F  = eleF(2);
%
raf    = SAXI_F*(1 + ECC_F);
rpf    = SAXI_F*(1 - ECC_F);
%

haf = (raf -Re)*1e-3
hpf = (rpf -Re)*1e-3
