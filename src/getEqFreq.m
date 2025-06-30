function [wEq, phEq] = getEqFreq(w1, w2, p1, p2)
    
    if w1 > w2
        wL = w1;
        wH = w2;
        pL = p1;
        pH = p2;
    else
        wL = w2;
        wH = w1;
        pL = p2;
        pH = p1;
    end

    wEq = (wL * wH) / (wL - wH);
    phEq = mod(pH - pL, 2*pi);

end