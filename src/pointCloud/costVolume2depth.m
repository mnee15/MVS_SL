function depth_map = costVolume2depth(cost_volume, depth_hypothesis, mask_ref, height, width)
depth_map = zeros(height, width);

for y=1:H
    for x=1:W
        if mask_ref(y,x) == 0
            depth_map(y,x) = 0;
            continue
        end

        cost = squeeze(cost_volume(y,x,:));
        [~, min_d_idx] = min(cost);
        
        if min_d_idx == 1 || min_d_idx == length(depth_hypothesis)
            depth_map(y,x) = depth_hypothesis(min_d_idx);
            continue
        end

        c1 = cost(min_d_idx - 1);
        c2 = cost(min_d_idx);
        c3 = cost(min_d_idx + 1);

        denom = c1 - 2*c2 + c3;
        if abs(denom) < 1e-5
            delta = 0;
        else
            delta = 0.5 * (c1 - c3) / denom;
        end

        refined_depth = depth_hypothesis(min_d_idx) + delta * (depth_hypothesis(min_d_idx + 1) - depth_hypothesis(min_d_idx));
        depth_map(y,x) = refined_depth;
    end
end

end

