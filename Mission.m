classdef Mission
    properties

        % Initialize constants

        g = 9.81                        % m/s2
        mu = 3.886e14                   % m3/s2
        re = 6371e3                     % m
        we = (2 * pi) / (24 * 60 * 60); % deg/s    
        latlaunch = 5.2                 % deg (North)

        % Constraints

        horbit = 700e3                  % m
        mpl = 300                       % kg
        maxg = [6, 6, 4]                % g's
        maxq = 45000                    % Pa
        vrlim = 100                     % m (End of vertical rising)

        % Assumptions

        excessdeltav = 2000;

    end

    methods

        function res = orbitv(obj)
            res = sqrt(obj.mu / (obj.re + obj.horbit));
        end

        function res = deltav(obj)
            res = obj.orbitv + obj.excessdeltav;
        end

        function res = werad2(obj)
            res = obj.we * (pi / 180);
        end
        
    end
end