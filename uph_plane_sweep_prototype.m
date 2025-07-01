clear
close all

addpath(genpath('src/'))

ref_cam = 2;
src_cams = [0, 1, 3, 4, 5, 6, 7, 8];

% 경로 바꾸기
root_dir = "C:/Users/USER/Desktop/mvs_data";
data_date = "250617_studio_data";
object = "250617_plane_dither";
calib_path = "250324_studio_data/20250324_SL_camera_calib/params";

pitch = [18, 20, 22];
height = 1024; width = 1280;
NStep = 3;

filterSize = 1;

%% load uphs and masks
uph_ref_dir = sprintf("%s/%s/%s/cam%02d", root_dir, data_date, object, ref_cam);
[uph_ref, mask_ref] = unwrapThreeFrequency(uph_ref_dir, pitch, height, width, NStep);

calib_filename_ref = sprintf("%s/%s/%08d_cam.txt", root_dir, calib_path, ref_cam);
[K_ref, Rt_ref, ~, ~] = loadCalibrationTxt(calib_filename_ref);

[H,W] = size(uph_ref);
uphs_src = zeros(H,W,length(src_cams));
masks_src = zeros(H,W,length(src_cams));
K_srcs = zeros(3,3,length(src_cams));
Rt_srcs = zeros(4,4,length(src_cams));

for i=1:length(src_cams)
    uph_src_dir = sprintf("%s/%s/%s/cam%02d", root_dir, data_date, object, src_cams(i));
    [uph_src, mask_src] = unwrapThreeFrequency(uph_src_dir, pitch, height, width, NStep);

    calib_filename_src = sprintf("%s/%s/%08d_cam.txt", root_dir, calib_path, src_cams(i));
    [K_src, Rt_src, ~, ~] = loadCalibrationTxt(calib_filename_src);

    uphs_src(:,:,i) = uph_src;
    masks_src(:,:,i) = mask_src;
    K_srcs(:,:,i) = K_src;
    Rt_srcs(:,:,i) = Rt_src;
end

%%
depth_hypothesis = linspace(2200, 2500, 200);
cost_volume = phase_based_cost_volume(uph_ref, uphs_src, K_ref, K_srcs, Rt_ref, Rt_srcs, depth_hypothesis);

%%
depth_map = zeros(H,W);

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


%% depth to pointcloud
pc = depth2pc(depth_map, K_ref);

% NaN 값이 포함된 행 찾기
nanIndices = any(isnan(pc), 2);  % NaN 값이 있는 행 인덱스

% NaN이 아닌 점들로 필터링
pc = pc(~nanIndices, :);

pc_world = ones(size(pc, 1), 4);
pc_world(:,1) = pc(:, 1); pc_world(:,2) = pc(:, 2); pc_world(:,3) = pc(:, 3);

pc_world = Rt_ref \ pc_world';
pc_world = pc_world';
pc_world = pointCloud(pc_world(:,1:3));

figure
pcshow(pc_world)
colormap("jet")
clim([2350, 2500])

% pcwrite(pc_world, "SL_247.ply")