function plotCrop3D(x,y,z,zmin,zmax)

    figure('Name','3D','Color','white'),
    surf(x, y, z, 'FaceColor', 'interp',...
                 'EdgeColor', 'none',...
                 'FaceLighting', 'phong');
    set(gca, 'DataAspectRatio', [1, 1, 1])
    set(gca,'FontSize',20)
    set(gca, 'FontWeight', 'bold')
    % set(gca, 'xdir', 'reverse')
    % set(gca, 'ydir', 'reverse')
    % set(gca, 'zdir', 'reverse')

    set(gca, 'FontSize',16)

    % view(0, 90);
    camlight headlight

     
    colormap('jet');
    clim([zmin zmax]);
    zlim([zmin zmax]);
%     title('Plane geometry')

    xlabel('x (mm)','FontSize', 20, 'FontWeight', 'bold');
    ylabel('y (mm)','FontSize', 20, 'FontWeight', 'bold');
    zlabel('z (mm)','FontSize', 20, 'FontWeight', 'bold');
end
