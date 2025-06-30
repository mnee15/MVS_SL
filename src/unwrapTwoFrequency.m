function [unwrappedPhase, k] = unwrapTwoFrequency(wEq, wH, phEq, ph_high)
    
    k = round(((wEq/wH)*phEq-ph_high)/(2*pi));
    unwrappedPhase = ph_high + 2*pi*(k);

end