function [ph, mask, Iavg, Id] = loadAndComputeNStepPhase(FringeHeight, FringeWidth, FringePitch, NStep, folderName, gammaTH, IavgTh)

    Iavg = zeros([FringeHeight, FringeWidth]);
    Imgs = zeros([FringeHeight, FringeWidth, NStep]);

    for Step = 1 : NStep
    
        fileName = sprintf('%s/%02d.bmp', folderName, Step-1);
        Id = im2gray(imread(fileName));
        Iavg =Iavg+ double(Id)/NStep;
        Imgs(:, :, Step) = double(Id);

    end

    [ph, mask, texture] = computeNStepPhase(Imgs, gammaTH, NStep);

    figure;
    imshow(Iavg);
    title(Iavg);
    clim([0, 255]);

    mask(Iavg < IavgTh) = 0;
    shift = -pi + pi/FringePitch; 
%     shift = -pi - pi/FringePitch;
%     shift = 0;
    ph = atan2(sin(ph  + shift), cos(ph + shift));
    
end