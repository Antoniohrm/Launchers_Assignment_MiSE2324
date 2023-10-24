function y = f(p_guess,exhaust,strcoeff,deltav)
y = (exhaust(1)*log((1+p_guess*exhaust(1))/(p_guess*exhaust(1)*strcoeff(1)))) + ...
    (exhaust(2)*log((1+p_guess*exhaust(2))/(p_guess*exhaust(2)*strcoeff(2)))) + ...
    (exhaust(3)*log((1+p_guess*exhaust(3))/(p_guess*exhaust(3)*strcoeff(3)))) - deltav;
end