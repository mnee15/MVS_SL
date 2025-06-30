function plotCropArea(unwrRectEroR,CropX,CropY)

rectanglePosition = [CropX(1),CropY(1)];
rectangleWidth = numel(CropX);
rectangleHeight = numel(CropY);
imageWithRectangle = insertShape(unwrRectEroR, 'Rectangle', ...
[rectanglePosition, rectangleWidth, rectangleHeight], ...
'Color', 'red', 'LineWidth', 2);
figure;
imshow(imageWithRectangle);
title('Image with Rectangle');