classdef Rocket
    properties

        %Rocket parameters

        isp = [310, 310, 330];          % s
        strcoeff = [0.10, 0.12, 0.14];  % %
        aerosurf = 1;                   % m2
        nozzlesurf = [0.6, 0.3]         % m2
        nozzlepress = [40000, 10000]    % Pa
        cddata = [0.2,  0.27;
                  0.5,  0.26;
                  0.8,  0.25;
                  1.2,  0.5;
                  1.5,  0.46;
                  1.75, 0.44;
                  2,    0.41;
                  2.25, 0.39;
                  2.5,  0.37;
                  2.75, 0.35;
                  3,    0.33;
                  3.5,  0.3;
                  4,    0.28;
                  4.5,  0.26;
                  5,    0.24;
                  5.5,  0.23;
                  6,    0.22;
                  6.5,  0.21
                ];

        % State

        r = zeros(1, 3);        % m    (Position in ECI)
        v = zeros(1, 3);        % m/s  (Velocity in ECI)
        vdot = zeros(1, 3);     % m/s2 (Acceleration in ECI)

        actstage = 1;           % (Currently active stage)

        dp = 0;       % Pa (Dynamic pressure)


        
        % Calculated parameters, initialized to 0

        cexh = zeros(1, 3);     % m/s (Exhaust velocity)
        mratio = zeros(1, 3);   % (Mass ratio per stage)
        plratio = zeros(1, 3);  % (Payload ratio per stage)
        m0 = zeros(1, 3);       % kg (Subrocket mass per stage
        mstr = zeros(1, 3);     % kg
        mprop = zeros(1, 3);    % kg
        th = zeros(1, 3);       % N
        mdot = zeros(1, 3);     % kg/s
        tstage = zeros(1, 3);   % s
        
        
    end

    methods

        function res = cd(obj, m)
            if m <= obj.cddata(1, 1)
                res = obj.cddata(1, 2);
            elseif m >= obj.cddata(size(obj.cddata, 1), 1)
                res = obj.cddata(size(obj.cddata, 1), 2);
            else
                diff = -1;
                it = 1;

                while diff <= 0
                    diff = obj.cddata(it, 1) - m;
                    it = it + 1;
                end

                inc = obj.cddata(it - 1, 1) - obj.cddata(it - 2, 1);
                cont1 = obj.cddata(it - 2, 2) * (1 - (m - obj.cddata(it - 2, 1)) / inc);
                cont2 = obj.cddata(it - 1, 2) * (1 - (obj.cddata(it - 1, 1) - m) / inc);
                res = cont1 + cont2;
            end
        end

        function res = r0(obj, Mission)
            res = [Mission.re * cosd(Mission.latlaunch);
                0;
                Mission.re * sind(Mission.latlaunch)];
        end

        function res = v0(obj, Mission)
            res = cross([0, 0, Mission.we], obj.r(1, :));
        end

        function res = cexhcalc(obj, Mission)
            res = Mission.g .* obj.isp;
        end

        function res = h(obj, Mission)
            res = norm(obj.r) - Mission.re;
        end

%         function res = dypressure(obj, dp)
%             res = 0.5 * dens * vrel^2
%         end

    end

end












