function [med_uphML_HM, maskH] = unwrapThreeFrequency(data_dir, pitch, height, width, NStep)

    pitchH = pitch(1); pitchM = pitch(2); pitchL = pitch(3);
    phL_path = sprintf("%s/%02d_pitch", data_dir, pitch(3));
    phM_path = sprintf("%s/%02d_pitch", data_dir, pitch(2));
    phH_path = sprintf("%s/%02d_pitch", data_dir, pitch(1));
    
    [phL, maskL] = calculateNStepPhase(height, width, phL_path, NStep);
    [phM, maskM] = calculateNStepPhase(height, width, phM_path, NStep);
    [phH, maskH] = calculateNStepPhase(height, width, phH_path, NStep);
    
    phEqML = mod(phM - phL, 2*pi) - pi;
    pitchML = (pitchM * pitchL) / (pitchL - pitchM);
    kML = round(((pitchML / pitchM) * (phEqML + pi) - (phM + pi)) / (2 * pi));
    uphML = phM + 2 * pi * kML;

    phEqHM = mod(phH - phM, 2*pi) - pi;
    pitchHM = (pitchH * pitchM) / (pitchM - pitchH);
    kHM = round(((pitchHM / pitchH) * (phEqHM + pi) - (phH + pi)) / (2 * pi));
    uphHM = phH + 2 * pi * kHM;

    phEqHL = mod(phH - phL, 2*pi) - pi;
    pitchHL = (pitchH * pitchL) / (pitchL - pitchH);
    kHL = round(((pitchHL / pitchH) * (phEqHL + pi) - (phH + pi)) / (2 * pi));
    uphHL = phH + 2 * pi * kHL;
    
    phEqML_HM = mod(phEqHM - phEqML, 2 * pi) - pi;
    pitchML_HM = (pitchML * pitchHM) / (pitchML - pitchHM);
   
    kH_ML_HM = round(((pitchML_HM / pitchH) * (phEqML_HM + pi) - (phH + pi)) / (2 * pi));
    uphH_ML_HM = phH + 2 * pi * kH_ML_HM;
    
    med_uph = medfilt2(uphH_ML_HM, [5, 20]);
    uph = phH + 2 * pi * round((med_uph - phH) / (2*pi));

    phEqML_HM = mod(phEqHM - phEqML, 2 * pi) - pi;
    pitchML_HM = (pitchML * pitchHM) / (pitchML - pitchHM);

    kH_ML_HM = round(((pitchML_HM / pitchH) * (phEqML_HM + pi) - (phH + pi)) / (2 * pi));
    uphH_ML_HM = phH + 2 * pi * kH_ML_HM;
    med_phEqML_HM = medfilt2(phEqML_HM, [5, 500]);
    med_uphML_HM = medfilt2(uphH_ML_HM, [5, 500]);
end