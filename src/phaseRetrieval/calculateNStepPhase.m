function [ph, mask] = calculateNStepPhase(height, width, folderName, NStep)


    S = zeros(height, width);
    C = zeros(height, width);
    Ip = zeros(height, width);
    Iavg = zeros(height, width);

    for i = 1:NStep
        imgPath = sprintf("%s/%02d.bmp", folderName, i-1);
        img = double(im2gray(imread(imgPath)));
    
        S = S + img * sin(2*pi/(NStep) * (i-1));
        C = C + img * cos(2*pi/(NStep) * (i-1));
        Ip= Ip + img/NStep; 
        Iavg =Iavg+ img/NStep;
    end
    
    GF = fspecial('Gaussian', [5, 5],5/3);
    S = imfilter(S, GF, 'same');
    C = imfilter(C, GF, 'same');
    
    Idp = 2 * sqrt(C.^2 + S.^2)/NStep; 
    ph = -atan2(S, C);
    mask = ones(size(Ip))*255;
    gm = Idp./Ip;
    
    mask (gm < 0.05) = 0;
    mask(Iavg < 5) = 0;
    
    texture = uint8(Idp + Ip);

end