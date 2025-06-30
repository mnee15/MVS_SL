function unwrappedPhase = unwrapThreeFrequency(wH, wM, wL, phase1, phase2, phase3)
% function [unwrappedPhase, uph_low] = unwrapThreeFrequency(wH, wM, wL, phase1, phase2, phase3)
    [wHM, phHM] = getEqFreq(wH, wM, phase1, phase2);
    % showImage(phHM)
    
    [wML, phML] = getEqFreq(wM, wL, phase2, phase3);
    showImage(phML), title('phML')
    
    [wHML, phHML] = getEqFreq(wHM, wML, phHM, phML);
    figure, imagesc(phHML - pi), colormap(gray), set(gca, 'DataAspectRatio', [1 1 1]), title('phHML');
    
    [uph_hm, ~] = unwrapTwoFrequency(wHML, wHM, phHML, phHM);
    figure, imagesc(uph_hm), colormap(gray), set(gca, 'DataAspectRatio', [1 1 1]), title('uph_hm');
    
    [uph_ml, ~] = unwrapTwoFrequency(wHM, wML, uph_hm, phML);
    figure, imagesc(uph_ml), colormap(gray), set(gca, 'DataAspectRatio', [1 1 1]), title('uph_ml');
    
    [uph_low, ~] = unwrapTwoFrequency(wML, wL, uph_ml, phase3);
    figure, imagesc(uph_low), colormap(gray), set(gca, 'DataAspectRatio', [1 1 1]), title('uph_low');
    
    [unwrappedPhase, ~] = unwrapTwoFrequency(wL, wM, uph_low, phase2);
    unwrappedPhase = unwrappedPhase + 2*pi;

end