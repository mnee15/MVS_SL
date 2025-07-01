function cost_volume = phase_based_cost_volume(ref_uph, src_uphs, K_ref, K_srcs, Rt_ref, Rt_srcs, depth_hypotheses)
    % source_phases: H*W*N array
    % K_sources, T_sources: 3*3*N array, 4*4*N array
    % reference_phase: (H, W)
    % based on plane sweep algorithm
    
    [H, W] = size(ref_uph);
    [xx, yy] = meshgrid(1:W, 1:H);
    homog_coords = [xx(:)'; yy(:)'; ones(1, H*W)];
    cam_dirs = inv(K_ref) * homog_coords; % (3, N)
    
    S = size(src_uphs, 3);
    D = length(depth_hypotheses);
    cost_volume = zeros(H, W, D);
    ref_phase_flat = ref_uph(:);

    for d_idx = 1:D
        d = depth_hypotheses(d_idx);
        phase_errors = zeros(H*W, S);

        % for each source view
        for s = 1:S
            phase_s = src_uphs(:,:,s);
            K_s = K_srcs(:,:,s);
            Rt_s = Rt_srcs(:,:,s);
            
            T_rel = Rt_s / Rt_ref;
            R_rel = T_rel(1:3, 1:3);
            t_rel = T_rel(1:3, 4);

            P_ref = cam_dirs * d;
            P_src = R_rel * P_ref + t_rel;
            proj = K_s * P_src;
            u = proj(1,:) ./ proj(3,:);
            v = proj(2,:) ./ proj(3,:);
            
            sampled_phase = interp2(phase_s, u, v, 'linear', NaN);
            phase_errors(:, s) = abs(sampled_phase' - ref_phase_flat);
        end
        
        % aggregate phase error from all source views (e.g., mean)
        cost_volume(:,:,d_idx) = reshape(mean(phase_errors, 2, 'omitnan'), H, W);
    end

%     % select depth with minimal cost
%     [~, best_idx] = min(cost_volume, [], 3);
%     depth_map = reshape(depth_hypotheses(best_idx), H, W);
end
