function eqFreq = calculateEqFreq(t1, t2, t3)
    if (nargin == 2)
        eqFreq = (t1*t2)/abs(t2-t1);
    elseif (nargin == 3)
        t12 = t2*t1/abs(t2-t1);
        eqFreq = t3*t12/abs(t3-t12);
    end
end