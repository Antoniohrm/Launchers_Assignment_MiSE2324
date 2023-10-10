classdef Rocket
    properties

        isp = [310, 310, 330]           % s
        strcoeff = [0.10, 0.12, 0.14]   % %
        mstruct = zeros(3, 1)           % kg
        aerosurf = 1                    % m2
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
                ]

        % Rocket parameters
        m0 = 0;
    end

    methods

        function r = cd(obj, m)
            if m <= obj.cddata(1, 1)
                r = obj.cddata(1, 2);
            elseif m >= obj.cddata(size(obj.cddata, 1), 1)
                r = obj.cddata(size(obj.cddata, 1), 2);
            else
                r = 0;
            end
        end
    end

end












