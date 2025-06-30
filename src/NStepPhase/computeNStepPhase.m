function [ph, mask, texture] = computeNStepPhase(I, gammaTh, NStep)

    I1 = I(:, :, 1);
    
    S = zeros(size(I1));
    C = zeros(size(I1));
    Ip = zeros(size(I1));
    
    for i = 1: NStep
        I1 = I(:, :, i);
        S = S + I1 * sin(2*pi/(NStep) * (i-1));
        C = C + I1 * cos(2*pi/(NStep) * (i-1));
        Ip= Ip + I1/NStep; 
    end
    
    Idp = 2 * sqrt(C.^2 + S.^2)/NStep; 
    ph = -atan2(S, C);
    mask = ones(size(I1));
    gm = Idp./Ip;
%     figure, imagesc(gm);
    mask (gm < gammaTh) = 0;
    texture = uint8(Idp + Ip);

end
