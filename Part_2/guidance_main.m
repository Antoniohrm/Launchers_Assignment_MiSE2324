function [Rocket, Mission, Simulation] = guidance_main(Rocket, Mission, Simulation)
    
    % DISPERSION TO NOMINAL CASE WOULD BE APPLIED HERE, TBD
    
    % Calculation of initial conditions done in the same way than in the first
    % part of the assignment
    
    h0 = cross(Rocket.r(end, :), Rocket.v(end, :));
    omega0 = h0 / (norm(Rocket.r(end, :))^2);
    
    pv0 = Rocket.vrel(end, :) / norm(Rocket.vrel(end, :));
    pr0 = -1 * cross(omega0, pv0);
    
    pv0 = [0.00717455882451979 0.00189176695719250 1.39065267020346e-05];
    pr0 = [-0.471450881157315 0.283642987474452 -0.0329878811855235];
    
    state0 = [Rocket.r(end, :), Rocket.v(end, :)];
    propt0 = Rocket.tstage(Rocket.actstage);
    
    tguess = 30;
    
    xopt0 = [tguess * 1e-2, pr0, pv0];
    
    % Design variable bounds
    
    minburntime = 10;
    
    optconstraints(1, 1:2) = [minburntime, propt0] * 1e-2;
    
    % Thrust Angular Velocity (prU) Optimization Constraints
    optconstraints(2, 1:2) = [-1, 1] * 30 * (pi/180);             
    optconstraints(3, 1:2) = [-1, 1] * 30 * (pi/180);
    optconstraints(4, 1:2) = [-1, 1] * 30 * (pi/180);
    
    % Thrust Direction (pvU) Optimization Constraints
    optconstraints(5, 1:2) = [-1, 1];
    optconstraints(6, 1:2) = [-1, 1];
    optconstraints(7, 1:2) = [-1, 1];
    
    % Separate into lower and upper bounds
    
    optlowerbounds = optconstraints(:,1); % Lower Constraint
    optupperbounds = optconstraints(:,2); % Upper Constraint
    
    npoints = 150;
    
    for i = 1:Simulation.nsims
    
        tvec = [];
        xvec = [];
        mvec = [];
    
        % First we modify the state
    
        if i == 1
            state0disp = state0;
            tcorr = 1;
        else
            Simulation.rdisp(i, :) = normrnd(0, Simulation.rdispteo / 3, 1, 3);
            Simulation.vdisp(i, :) = normrnd(0, Simulation.vdispteo / 3, 1, 3);
            Simulation.tdisp(i) = normrnd(1, Simulation.tdispteo / 3, 1, 1);
        
            
            state0disp = state0 + [Simulation.rdisp(i, :), Simulation.vdisp(i, :)];
            tcorr = Simulation.tdisp(i);
        end
    
        % Proceed with the optimization
    
        Rocket.exoburncounter = 1;
        
        nonlcon = @(xopt) costGuidanceFn(xopt, state0disp, npoints, Mission, Rocket, tcorr);
        
        options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp', 'MaxFunctionEvaluations',10000);
        
        resopt = fmincon(@(xopt) fMinFn(xopt), xopt0,[],[],[],[],[optlowerbounds],[optupperbounds],nonlcon, options);
        
        agstate0 = [state0disp, resopt(2:7)];
        
        [tvec, xvec, mvec] = propagateGuidedBurn(resopt(1) * 1e2, agstate0, Rocket, Mission, tcorr, npoints);
    
        Simulation.burntime(i) = tvec(end);
    
        Rocket.exoburncounter = Rocket.exoburncounter + 1;
    
        % Now we propagate until apoapsis, by setting the event function to stop
        % the integration when the first exo atmospheric burn has been done
        % 'Rocket.exoburncounter == 2' and when the dot product of the position and
        % the velocity vectors of the rocket is zero, going from positive to
        % negative (direction = -1)
        
        options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission),'AbsTol',1e-9,'RelTol',1e-8);
        [t , state] = ode45(@(t,state) ballisticDer(t, state, Rocket, Mission),[0, 1.5 * Mission.torbit], [xvec(end, :)], options);
        
        tvec = [tvec, t' + tvec(end)];
        mvec = [mvec; ones(size(t)) .* mvec(end)];
        xvec = [xvec; state];
    
        [xvec, mvec] = impBurn(xvec, mvec, Rocket, Mission, Mission.rorbit);
        Rocket.exoburncounter = Rocket.exoburncounter + 1;
    
        options = odeset('Events',@(t, state) eventsfun(t, state, Rocket, Mission),'AbsTol',1e-9,'RelTol',1e-8);
        [t , state] = ode45(@(t,state) ballisticDer(t, state, Rocket, Mission),[0, 1.5 * Mission.torbit], [xvec(end, :)], options);
    
        % We perform a final circularization burn
    
        tvec = [tvec, t' + tvec(end)];
        mvec = [mvec; ones(size(t)) .* mvec(end)];
        xvec = [xvec; state];
    
        [xvec, mvec] = impBurn(xvec, mvec, Rocket, Mission, Mission.rorbit);
    
        % We store the results of the simulation
        
        orel = AST_pvecle(xvec(end, :), Mission.mu);
    
        Simulation.ecc(i) = orel(2);
    
        Simulation.rp(i) = (orel(1)) * (1 - orel(2)) - (Mission.re * 1e-3);
        Simulation.ra(i) = (orel(1)) * (1 + orel(2)) - (Mission.re * 1e-3);
    
        Simulation.mf(i) = mvec(end);
        Simulation.mexcess(i) = mvec(end) - (Rocket.m0(3) - Rocket.mprop(3));
    
        plot([Rocket.t; tvec' + Rocket.t(end)], vecnorm(transpose([Rocket.r; xvec(:, 1:3)])) - (Mission.re));
    
        hold on
    
        xlim([0, 1000]);
    
        % finalt = [Rocket.t; tvec' + Rocket.t(end)];
        % finalr = vecnorm(transpose([Rocket.r; xvec(:, 1:3)])) - (Mission.re);
        % finalv = vecnorm(transpose([Rocket.v; xvec(:, 4:6)]));
        % 
        % size(finalt)
        % size(finalr)
        % size(finalv)
        % 
        % figure
        % plot(finalt, finalr)
        % figure
        % plot(finalt, finalv)
    
    
    end
end