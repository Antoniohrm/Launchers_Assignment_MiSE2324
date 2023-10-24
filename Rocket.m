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
        kickangle = 1.4;                  % degrees
        exoburncounter = 1;

        % State

        r = zeros(1, 3);        % m    (Position in ECI)
        v = zeros(1, 3);        % m/s  (Velocity in ECI)
        vrel = zeros(1, 3);     % m/s  (Relative velocity)
        m = [];                 % kg   (Initialized to 0)
        t = [0];                % s    (Initialized to 0)
        hf = zeros(1, 3);       % km   (Altitude, to be filled after finishing)

        vdot = zeros(1, 3);     % m/s2 (Acceleration in ECI)

        actstage = 1;           % (Current active stage)

        
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

        % Events parameters

        tvr = 0;                % (index of time at the end of the vertical rising)
        toptburn = 0;           % (index of the end of the first exoAtm burn)
        tcirc1 = 0;             % (index of time of the first circularization burn)
        tcirc2 = 0;             % (index of time of the second circularization burn)
        tstburn = zeros(1, 3);  % (index of time of burnout for each stage)
        
        
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

                slope = (obj.cddata(it - 1, 2) - obj.cddata(it - 2, 2)) / (obj.cddata(it - 1, 1) - obj.cddata(it - 2, 1));
                b = obj.cddata(it - 2, 2) - (slope * obj.cddata(it - 2, 1));
                res = (slope * m) + b;
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
            res = vecnorm(transpose(obj.r)) - Mission.re;
        end

        function res = vrelCalc(obj, Mission)
            res = obj.v - cross(repmat([0, 0, Mission.we], size(obj.r, 1), 1), obj.r, 2);
        end

        function res = applyKickangle(obj, Mission)
            runit = obj.r(end, :) / norm(obj.r(end, :));
            e = cross([0, 0, Mission.we], obj.r(end, :));
            eunit = e / norm(e);

            vrelpitched = norm(obj.vrel(end, :)) * ((cosd(obj.kickangle) * runit) + (sind(obj.kickangle) * eunit));
            res = vrelpitched + cross([0, 0, Mission.we], obj.r(end, :));
        end

    end

end












