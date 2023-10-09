function y = lagrange_initial_guess(p,c_media,e_media,deltaV)
y = 3*c_media*log((1+p*c_media)/(p*c_media*e_media))-deltaV;
end