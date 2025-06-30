function plotIdealPlane3D(xCrop,yCrop,zFit,zMin,zMax)

    figure,
        surf(xCrop(:, :), yCrop(:, :), zFit(:, :), 'FaceColor', 'interp',...
                     'EdgeColor', 'none',...
                     'FaceLighting', 'phong');
        set(gca, 'DataAspectRatio', [1, 1, 1])
        set(gca, 'xdir', 'reverse')

        %set(gca, 'ydir', 'reverse')
        axis equal;
        view(0, 90);
        camlight left
         
        colormap('jet');
        clim([zMin zMax]);
        zlim([zMin zMax]);

end
