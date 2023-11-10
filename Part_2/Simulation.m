classdef Simulation

    properties

        % Conditions of the simulation

        nsims = 10;                 % (# of simulations)
        rdispteo = 10e3;            % m (3 sigma of random position dispersion)
        vdispteo = 10;              % m/s (3 sigma of random velocity dispersion)
        tdispteo = .1;              % fraction over 1 (3 sigma of random thrust dispersion)   

        % Deviations from the nominal case at the end of the endo phase

        rdisp = zeros(1, 3);        % m
        vdisp = zeros(1, 3);        % m/s
        tdisp = [0];                % fraction over 1

        % Results, each row corresponds to a different simulation
        
        burntime = [0];             % s (Only for the guided burn)
        mf = [0];                   % kg (Final mass)
        mexcess = [0];              % kg (Excess mass)

        % Final orbit data to assess validity of simulation (after circularizing)

        ra = [0];                   % m
        rp = [0];                   % m
        ecc = [0];                  % Adimensional

    end

end

