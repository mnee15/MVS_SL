function [ph, mask] = calculate3StepPhase(height, width, folderName, alpha)
    
    imgs = zeros(height,width,3);
    mask = zeros(height, width);

    for i = 1:3
        imgPath = sprintf("%s/%02d.bmp", folderName, i-1);
        img = im2gray(imread(imgPath));

        img = imresize(img, [height, width]);

        imgs(:,:,i) = img;
    end
%     img1 = squeeze(imgs(:,:,1));
%     img2 = squeeze(imgs(:,:,2));
%     img3 = squeeze(imgs(:,:,3));

    img1 = squeeze(imgs(:,:,3));
    img2 = squeeze(imgs(:,:,1));
    img3 = squeeze(imgs(:,:,2));

    ph = atan2(((1-cos(alpha))*(img1-img3)),(sin(alpha)*(2*img2-img1-img3)));
%     ph = (atan2(((1-cos(alpha))*(img1-img3)),(sin(alpha)*(2*img2-img1-img3))) + pi/2);

    gm = (((1-cos(alpha)).*(img1-img3)).^2+(sin(alpha)*(2*img2-img1-img3)).^2)./(sin(alpha).*(img1+img3-2*img2*cos(alpha)));
    mask(gm>5) = 1;
%     showImage(gm)
end