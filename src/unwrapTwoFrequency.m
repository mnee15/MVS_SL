function [uphHL, maskH] = unwrapTwoFrequency(data_dir, pitch, height, width, NStep)
    
    pitchH = pitch(1); pitchL = pitch(2);
    phL_path = sprintf("%s/%02d_pitch", data_dir, pitch(2));
    phH_path = sprintf("%s/%02d_pitch", data_dir, pitch(1));
    
    [phL, maskL] = calculateNStepPhase(height, width, phL_path, NStep);
    [phH, maskH] = calculateNStepPhase(height, width, phH_path, NStep);
    
    phEqHL = mod(phH - phL, 2*pi) - pi;
    pitchHL = (pitchH * pitchL) / (pitchL - pitchH);
    kHL = round(((pitchHL / pitchH) * (phEqHL + pi) - (phH + pi)) / (2 * pi));
    uphHL = phH + 2 * pi * kHL;
end