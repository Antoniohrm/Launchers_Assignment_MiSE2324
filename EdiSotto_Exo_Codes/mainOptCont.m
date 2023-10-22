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
rp = 163*1e+3 +Re; %radio perigeo
%
vp = 8260 + 260;% This values are obtained through the video of the launch VA244. The velocity in the video (8260 m/s) 
                % is relative velocity modulus. The added value of 260 m/s
                % is the projection of the Earth Velocity at Kourou on the
                % launch Azimuth direction (56 deg)
%
RAAN = 0;           %[rad]
INCL = 56*pi/180;   %[rad]
TRAN = 0*pi/180;    %[rad]
WPER = 20*pi/180;   %[rad]
%
%
E    = vp^2/2 - mu/rp; % Orbit Energy
SAXI = -mu/(2*E); % Semimajor Axis
%
ECC  = 1 - rp/SAXI; % e=(1-r_peri/a)
ra   = SAXI*(1 + ECC); %r_apo=a*(1 + e)
%
ele0 = [ SAXI, ECC, INCL, RAAN, WPER, TRAN]; % elementos orbitales finales
%
X    = AST_pelvec(ele0, mu); % conversion de elementos orbitales a cartesianas
%
% Initialise the primer assuming directed along the velocity vector and the
% angualar velocity as the orbit mean motion 
% 
r0 = X(1:3);
v0 = X(4:6);
%
velIne = norm(v0) %velocidad inercial
%
velRel = v0 - cross(wV, r0); %velocidad relativa a la superficie (Kourou)
%
h0   = cross(r0,v0); % momento angular

wOrb = h0/rp^2;  % velocidad angular ¿ en el perigeo ?
%
%pvU = X(4:6)/norm(X(4:6));
pvU = velRel/norm(velRel); %lagrarian multipliers in the orbit.
prU = -cross(wOrb, pvU);% the minus sign comes from the primer dynamics prU = -pVUDot 
%
augState0 = [X, prU, pvU];
%
propTime0 = 639; %200;%600;%639; %sec propellant time [sec]
finalRa = 22922*1e+3 + Re; %final apoapsis radius [m]
%finalRp = 3.9574e+05;
%
opt0Sc     = [propTime0*1e-2, prU, pvU]; %optimization initializing values
%
state0 = X;
%
%Time optimization bounds
xBound(1, 1:2) = [200 1000]*1e-2; % normalized
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
%
% Flow = FBound(:,1);
% Fupp = FBound(:,2);
%
nonlcon = @cConFun;
%
options = optimoptions('fmincon','Display','iter', 'Algorithm', 'sqp','MaxFunctionEvaluations',3000);
Xsc = fmincon(@fSolveFun,opt0Sc',[],[],[],[],[xlb],[xub],nonlcon, options);
%
propTime = Xsc(1)*1e+2 %valor optimo 1 (propellant time) denormalizado
%
augState = [state0, Xsc(2:4)', Xsc(5:7)'];

[tExo  solExo] = ode45(@exoFlightDeriv,[0 propTime], augState); % determinacion del augmented state para la propagación final.
%
pos = solExo(:, 1:3); % posicion durante todo el trayecto
vel = solExo(:, 4:6); % velocity durante todo el trayecto
%
for ii =1:length(tExo)
    posN(ii) = norm(pos(ii,:)); % Modulo de la posicion en el trayecto (intento de radio)
    velN(ii) = norm(vel(ii,:)); % Modulo de la velocidad en el trayecto 
    
    velRN(ii) = norm(vel(ii,:) - cross(wV, pos(ii,:)));
end
%
figure
plot(tExo, (posN - Re)*1e-3,'r', 'LineWidth',3) %plot radio-radio de la tierra
set(gca, 'FontSize',14)
xlabel('Time [s]', 'FontSize',14)
ylabel('Altitude [km]', 'FontSize',14)
grid on 
%
%
figure
plot(tExo, (velN)*1e-3,'r','LineWidth',3); %plot velocidad
set(gca, 'FontSize',14);
xlabel('Time [s]', 'FontSize',14);
ylabel('Inertal Velocity [km/s]', 'FontSize',14);
grid on 
%
figure
plot(tExo, (velRN)*1e-3,'r','LineWidth',3); %plot velocidad relativa
set(gca, 'FontSize',14);
xlabel('Time [s]', 'FontSize',14);
ylabel('Relative Velocity [km/s]', 'FontSize',14);
grid on 
%
%exoFlightDeriv(0, augState0)
Xf = solExo(end,1:6); %valor final de la orbita
%
rf = Xf(1:3); %posicion final
vf = Xf(4:6); %velocidad final
%
vfRel = norm (vf - cross(wV, rf)) %velociadad relativa final
%
eleF = AST_pvecle(Xf,mu); % conversion a elementos orbitales finales
%
SAXI_F = eleF(1);
ECC_F  = eleF(2);
%
raf    = SAXI_F*(1 + ECC_F); %radio apoapsis final
rpf    = SAXI_F*(1 - ECC_F); %radio periapsis final
%

haf = (raf -Re)*1e-3 % comprobacion del error final con respecto al target (apoapsis)
hpf = (rpf -Re)*1e-3 % comprobacion del error final con respecto al target (periapsis)
