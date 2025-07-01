function pts_3d = depth_to_pointcloud(depth_map, K)
    [H, W] = size(depth_map);
    [xx, yy] = meshgrid(1:W, 1:H);

    fx = K(1,1);
    fy = K(2,2);
    cx = K(1,3);
    cy = K(2,3);

    Z = depth_map;
    X = (xx - cx) .* Z / fx;
    Y = (yy - cy) .* Z / fy;

    pts_3d = cat(3, X, Y, Z);           % (H, W, 3)
    pts_3d = reshape(pts_3d, [], 3);    % (H*W, 3)
end