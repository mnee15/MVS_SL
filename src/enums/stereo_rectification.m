function [I1_rect, I2_rect, H1, H2, reprojectionMatrix, R_new] = stereo_rectification(I1, I2, K1, K2, E1, E2)
    % Compute the optical center for both cameras
    R1 = E1(1:3, 1:3);
    t1 = E1(1:3, 4);
    R2 = E2(1:3, 1:3);
    t2 = E2(1:3, 4);

    C1 = -R1' * t1;
    C2 = -R2' * t2;
    
    % Compute the new rotation matrix
    % The new x-axis is along the baseline (between camera centers)
    r1 = (C2 - C1);
    if r1(1) < 0
        r1 = -r1;
    end
    r1 = r1 / norm(r1);
    
    % The new y-axis is perpendicular to the x-axis and the original y-axis
    r2 = cross(R1(3, :)', r1);
    r2 = r2 / norm(r2);
    
    % The new z-axis is the cross product of the new x and y axes
    r3 = cross(r1, r2);
    
    % New rotation matrix
    R_new = [r1, r2, r3]';
    
    % Compute the homographies for rectification
    H1 = K2 * R_new * R1' / K1;
    H2 = K2 * R_new * R2' / K2;
    
    % Compute the output limits for both images
    [xlim1, ylim1] = outputLimits(projective2d(H1'), [1 size(I1,2)], [1 size(I1,1)]);
    [xlim2, ylim2] = outputLimits(projective2d(H2'), [1 size(I2,2)], [1 size(I2,1)]);
    
    % Determine the full output view limits
    xMin = floor(min([xlim1 xlim2]));
    xMax = ceil(max([xlim1 xlim2]));
    yMin = floor(min([ylim1 ylim2]));
    yMax = ceil(max([ylim1 ylim2]));
    
    outputView = imref2d([yMax - yMin, xMax - xMin], [xMin xMax], [yMin yMax]);
    
    % Apply the homographies to rectify images
    tform1 = projective2d(H1');
    tform2 = projective2d(H2');
    
    I1_rect = imwarp(I1, tform1, 'OutputView', outputView);
    I2_rect = imwarp(I2, tform2, 'OutputView', outputView);

    % Compute reprojection matrix Q
    B = norm(C2 - C1); % Baseline
    f = K1(1,1); % Focal length
    cx = K1(1,3);
    cy = K1(2,3);
    reprojectionMatrix = [1, 0, 0, -cx;
         0, 1, 0, -cy;
         0, 0, 0, f;
         0, 0, 1/B, 0];
end