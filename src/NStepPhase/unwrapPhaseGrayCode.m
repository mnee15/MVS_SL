function [uph, codeWord] = unwrapPhaseGrayCode(ph, Iavg, Id, FringePitch, NStep, NBits, folderName) 
    
    %Initial codeword to be zeros 
    bcode = zeros(size(Id));
    for nBin = 1:NBits
        % Read binary patterns out
        fileName = sprintf('%s/%02d.bmp', folderName, NStep + nBin - 1);

        I0 = im2gray(imread(fileName));
        % I0 = imfilter(I0, GF, 'same');

        % I0 = imfilter(I0, GF, 'same');

        % Binarize the image
        Icode = zeros(size(I0));
        Icode(I0 > Iavg) = 1;

        % Adjust codeword 
        bcode = bcode * 2 + Icode;% 
    end

    codeLUT = GenInverseGrayCodeLUT(NBits);

    [ FringeHeight, FringeWidth] = size(bcode);
    % generate codeword by looking up the graycode table
    codeWord = bcode;
    for i = 1: FringeHeight
        for j = 1:FringeWidth 
            codeWord(i, j) = codeLUT(bcode(i, j)+1);
        end
    end

    % codeWord(mask < 100) = 0;
    % unwrap the phase value
    uph = ph + codeWord * 2*pi;
    
    % Shift phase back to the original values
    shift = -pi + pi/FringePitch;
    uph = uph - shift; 
    
    suph = medfilt2(uph, [3 30]);
    % else
    %     % suph = uph;
    %     % suph = medfilt2(uph, [3 3]);
    % end
    uph = uph - round((uph - suph)/(2*pi))*2*pi;

end
