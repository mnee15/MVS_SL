function plotAll3D(x,y,z,zmin,zmax)

    figure('Name','Full 3D','Color','white'),
    surf(x(:, :), y(:, :), z(:, :), 'FaceColor', 'interp',...
                 'EdgeColor', 'none',...
                 'FaceLighting', 'phong');
    set(gca, 'DataAspectRatio', [2, 2, 1])
    set(gca, 'xdir', 'reverse')
    view(0, 90);
    camlight headlight
    axis on
    grid on
    colormap('jet');
    clim([zmin zmax]);
    zlim([zmin zmax]);
    title('Plane board geometry')
    
    xlabel('x (mm)','FontSize',12);
    ylabel('y (mm)','FontSize',12);
    zlabel('z (mm)','FontSize',12);

end
