function phaseRect = filterBwareOpen(phaseRect, maskRect, Erosion2)
    
    maskRect_open = bwareaopen(phaseRect, Erosion2);
    phaseOpen = phaseRect.*maskRect_open;

    se2 = strel('disk',Erosion2);
    maskRect_ero = imerode(maskRect,se2);
    maskRect_ero(maskRect_ero>0) = 1;

    phaseRect = phaseOpen.*maskRect_ero;
end