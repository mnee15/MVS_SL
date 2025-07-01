clear
close all

addpath(genpath('src/'))

% 경로 바꾸기
root_dir = "C:/Users/USER/Desktop/mvs_data";
data_date = "250617_studio_data";
object = "250617_plane_dither";
calib_path = "250324_studio_data/20250324_SL_camera_calib/params";

cam1_num = 7; cam2_num = 4;

pitch = [18, 20, 22];
height = 1024; width = 1280;
NStep = 3;

filtering = false;
filterSize = 5;

%%
% load stereoParams
calib_filename1 = sprintf("%s/%s/%08d_cam.txt", root_dir, calib_path, cam1_num);
calib_filename2 = sprintf("%s/%s/%08d_cam.txt", root_dir, calib_path, cam2_num);

[K1, E1, R1, t1] = loadCalibrationTxt(calib_filename1);
[K2, E2, R2, t2] = loadCalibrationTxt(calib_filename2);

%%
% distorsion_coeff = [-0.14556580788210735 0.1140118978769209 0.0008105705787220145 0.00031151440043769574 -0.0220879592787855];
% intrinsics
cameraParams1 = cameraParameters('K', K1);
cameraParams2 = cameraParameters('K', K2);

% extrincs
R = R2 * R1'; % 카메라 1에서 카메라 2로의 회전
T = t2 - R * t1; % 카메라 1에서 카메라 2로의 이동 (카메라 2 좌표계 위에서 카메라 1 원점 위치)

if T(1) > 0
    disparityPolarity = 1;
else
    disparityPolarity = -1;
end

stereoParams = stereoParameters(cameraParams1, cameraParams2, R', T);

%% 3 freq unwrapped phase

uph1_dir = sprintf("%s/%s/%s/cam%02d", root_dir, data_date, object, cam1_num);
uph2_dir = sprintf("%s/%s/%s/cam%02d", root_dir, data_date, object, cam2_num);

[uph1, mask1] = unwrapThreeFrequency(uph1_dir, pitch, height, width, NStep);
[uph2, mask2] = unwrapThreeFrequency(uph2_dir, pitch, height, width, NStep);

% if masking

% mask1 = imread(sprintf("%s/%s/%s/cam%02d/%02d_mask.png", root_dir, data_date, object, cam1_num, cam1_num));
% mask2 = imread(sprintf("%s/%s/%s/cam%02d/%02d_mask.png", root_dir, data_date, object, cam2_num, cam2_num));

%%
uph1(mask1==0) = 0;
uph2(mask2==0) = 0;

figure
imshow(uph1)
clim([min(uph1(:)), max(uph1(:))])
title("uph1")

figure
imshow(uph2)
clim([min(uph2(:)), max(uph2(:))])
title("uph2")

% if filtering

% uph1 = imgaussfilt(uph1, filterSize);
% uph2 = imgaussfilt(uph2, filterSize);

%% rectify uph
[uph1_rect, uph2_rect, reprojectionMatrix, camMatrix1, camMatrix2, R_r1, R_r2] = rectifyStereoImages(uph1, uph2, stereoParams, 'OutputView', 'full');
[mask1_rect, mask2_rect] = rectifyStereoImages(mask1, mask2, stereoParams, 'OutputView', 'full');

% visualize rectified uph

figure
imshowpair(uph1_rect, uph2_rect, 'montage')
title('Rectified Images')

%% find disparity
[rectH, rectW] = size(uph1_rect);
disparityMap = phaseBasedDisparityStudio(uph1_rect, uph2_rect, rectH, rectW, mask1_rect, mask2_rect, disparityPolarity, 0, rectW);

figure
imshow(disparityMap)
clim([min(disparityMap(:)), max(disparityMap(:))])
title("Disparity")

%% reconstruct 3D point cloud
% z_min = 800; z_max = 2500;
z_min = 2000; z_max = 2500;
xyzPoints = reconstructScene(disparityMap, reprojectionMatrix);

x = xyzPoints(:,:,1);
y = xyzPoints(:,:,2);
z = xyzPoints(:,:,3);

x_trim = -x; y_trim = -y; z_trim = -z;

x_trim(z_trim>z_max) = NaN; x_trim(z_trim<z_min) = NaN;
y_trim(z_trim>z_max) = NaN; y_trim(z_trim<z_min) = NaN;
z_trim(z_trim>z_max) = NaN; z_trim(z_trim<z_min) = NaN;

figure
surf(x_trim,y_trim,-z_trim, 'FaceColor', 'interp',...
    'EdgeColor', 'none',...
    'FaceLighting', 'phong');
set(gca, 'DataAspectRatio', [1, 1, 1])
axis equal;
camlight right
view(0, 90);
set(gca, 'xdir', 'reverse')
colorbar

%% Save ply file
pc = xyz2ply(x_trim, y_trim, z_trim);

figure
pcshow(pc)
colormap("jet")

% pcwrite(pc, "skull_active_stereo.ply")
%% Save ply file (cam1 coordinate)

[pc_world, P_orig] = xyz2ply_world(x_trim,y_trim,z_trim, R_r1, E1);

figure
pcshow(pc_world)
colormap("jet")

% pcwrite(pc, sprintf("./cam%d_%d_world.ply", cam1_num, cam2_num));

%% Depth map
depthMap = pc2depth(P_orig, K1, height, width);

figure
imshow(depthMap)
clim([z_min, z_max])
colormap('jet')
%% save depth map
% depth_dir = sprintf("C:/Users/KHW/Desktop/mvs/studio_data/3d_results/%s/depth_map", object);
% if exist(depth_dir, "dir") == 0
%     mkdir(depth_dir);
% end
% 
% save(sprintf("%s/cam%d_%d.mat", depth_dir, cam1_num, cam2_num), "depthMap");
