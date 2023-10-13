function [Rocket, Mission] = Staging(Rocket, Mission)
    
    % For initial guess of p
    cexh_avg = mean(Rocket.cexh);
    strcoeff_avg = mean(Rocket.strcoeff);
    
    %Lagrange initial guess
    syms p
    equ = 3 * cexh_avg * log((1 + (p * cexh_avg)) / (p * cexh_avg * strcoeff_avg)) == Mission.deltav;
    p_guess = solve(equ, p); %-4.3851e-04
    
    %Funcion 1
    fun = @f;
    p = fzero(fun, double(p_guess),[],Rocket.cexh, Rocket.strcoeff, Mission.deltav);
    
    %Mass ratio for each stage (2 < Λ < 10)
    Rocket.mratio = (1 + (p * Rocket.cexh)) ./ (p * Rocket.cexh .* Rocket.strcoeff);
    
    %PL ratio for each stage (0.01 < 𝜆 < 0.2)
    Rocket.plratio = (1 - (Rocket.mratio .* Rocket.strcoeff)) ./ ((1 - Rocket.strcoeff) .* Rocket.mratio);
    
    %GMLO
    Rocket.m0(1) = Mission.mpl / prod(Rocket.plratio);
    
    syms mp1
    equ = Rocket.mratio(1) == Rocket.m0(1) / (Rocket.m0(1) - mp1);
    Rocket.mprop(1) = double(solve(equ,mp1));
    
    syms ms1
    equ = Rocket.strcoeff(1) == ms1 / (ms1 + Rocket.mprop(1));
    Rocket.mstr(1) = double(solve(equ,ms1));
    
    syms m02
    equ = Rocket.m0(1) == m02 + Rocket.mstr(1) + Rocket.mprop(1);
    Rocket.m0(2) = double(solve(equ, m02));
    
    syms mp2
    equ = Rocket.mratio(2) == Rocket.m0(2) / (Rocket.m0(2) - mp2);
    Rocket.mprop(2) = double(solve(equ,mp2));
    
    syms ms2
    equ = Rocket.strcoeff(2) == ms2 / (ms2 + Rocket.mprop(2));
    Rocket.mstr(2) = double(solve(equ,ms2));
    
    syms m03
    equ = Rocket.plratio(2) == m03 / Rocket.m0(2);
    Rocket.m0(3) = double(solve(equ, m03));
    
    syms mp3
    equ = Rocket.mratio(3) == Rocket.m0(3) / (Rocket.m0(3) - mp3);
    Rocket.mprop(3) = double(solve(equ,mp3));
    
    syms ms3
    equ = Rocket.strcoeff(3) == ms3 / (ms3 + Rocket.mprop(3));
    Rocket.mstr(3) = double(solve(equ,ms3));
    
    Rocket.th = (Rocket.m0 - Rocket.mprop) .* Mission.maxg * Mission.g;
    Rocket.mdot = Rocket.th ./ Rocket.cexh;
    Rocket.tstage = Rocket.mprop ./ Rocket.mdot;

end