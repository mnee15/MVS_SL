function [pc, P_orig] = xyz2ply_world(x_trim,y_trim,z_trim, R_r, E)
%% Save ply file
    P_rect = [x_trim(:), y_trim(:), z_trim(:)];
    
    P_orig = (R_r' * P_rect')';
    P_orig_homo = ones(size(P_orig, 1), 4);
    P_orig_homo(:,1:3) = P_orig;
    P_world_homo = (E \ P_orig_homo')';
    P_world = P_world_homo(:, 1:3);
    
    nanIndices = any(isnan(P_world), 2);  % NaN 값이 있는 행 인덱스
    P_world = P_world(~nanIndices, :);
    
    pc = pointCloud(P_world);
end

