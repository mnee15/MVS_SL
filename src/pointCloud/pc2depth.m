function depthMap = pc2depth(P_orig, K, height, width)
%% depth map
    fx = K(1,1);
    fy = K(2,2);
    cx = K(1,3);
    cy = K(2,3);
    
    % Extract 3D points
    X = P_orig(:,1);
    Y = P_orig(:,2);
    Z = P_orig(:,3);
    
    % Convert to image coordinates
    u = round(fx * X ./ Z + cx);
    v = round(fy * Y ./ Z + cy);
    
    % Initialize depth map
    depthMap = NaN(height, width); % Use NaN for missing values
    
    % Assign depth values to corresponding pixel locations
    for i = 1:length(Z)
        if u(i) > 0 && u(i) <= width && v(i) > 0 && v(i) <= height
            if isnan(depthMap(v(i), u(i))) || Z(i) < depthMap(v(i), u(i))
                depthMap(v(i), u(i)) = Z(i); % Store nearest depth
            end
        end
    end
end

