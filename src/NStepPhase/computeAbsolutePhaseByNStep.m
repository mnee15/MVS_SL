function [uph_nstep, ph, mask, codeWord] = computeAbsolutePhaseByNStep(FringeHeight, FringeWidth, FringePitch, NStep, NBits, folderName, gammaTh, IavgThreshold)
    % Extract phase data from N-Step images, compute phase, and unwrap using Gray code with adjustable thresholds

    % Load images and compute phase
    [ph, mask, Iavg, Id] = loadAndComputeNStepPhase(FringeHeight, FringeWidth, FringePitch, NStep, folderName, gammaTh, IavgThreshold);
    % Unwrap phase using Gray code
    [uph_nstep, codeWord] = unwrapPhaseGrayCode(ph, Iavg, Id, FringePitch, NStep, NBits, folderName);

end
