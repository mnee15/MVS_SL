%% TODO: 이거 좌표계 둘 합치면 좀 이상함..?

clear
close all
addpath(genpath('src/'))

% 경로 바꾸기
root_dir = "C:/Users/USER/Desktop/mvs_data";
data_date = "250617_studio_data";
object = "250617_plane_dither";
calib_path = "250324_studio_data/20250324_SL_camera_calib/params";

pitch = [18, 20, 22];
height = 1024; width = 1280;
NStep = 3;

filtering = false;
filterSize = 5;

cam1_num = 7; cam2_num = 4; cam3_num = 2;


%%
% load stereoParams
calib_filename1 = sprintf("%s/%s/%08d_cam.txt", root_dir, calib_path, cam1_num);
calib_filename2 = sprintf("%s/%s/%08d_cam.txt", root_dir, calib_path, cam2_num);
calib_filename3 = sprintf("%s/%s/%08d_cam.txt", root_dir, calib_path, cam3_num);

[K1, E1, R1, t1] = loadCalibrationTxt(calib_filename1);
[K2, E2, R2, t2] = loadCalibrationTxt(calib_filename2);
[K3, E3, R3, t3] = loadCalibrationTxt(calib_filename3);

%%
% % intrinsics
cameraParams1 = cameraParameters('K', K1);
cameraParams2 = cameraParameters('K', K2);
cameraParams3 = cameraParameters('K', K3);

% extrincs
R12 = R2 * R1'; % 카메라 1에서 카메라 2로의 회전
T12 = t2 - R12 * t1; % 카메라 1에서 카메라 2로의 이동 (카메라 2 좌표계 위에서 카메라 1 원점 위치)
R13 = R3 * R1'; % 카메라 1에서 카메라 3로의 회전
T13 = t3 - R13 * t1; % 카메라 1에서 카메라 3로의 이동 (카메라 3 좌표계 위에서 카메라 1 원점 위치)

if T12(1) > 0
    disparityPolarity12 = 1;
else
    disparityPolarity12 = -1;
end

if T13(1) > 0
    disparityPolarity13 = 1;
else
    disparityPolarity13 = -1;
end

stereoParams12 = stereoParameters(cameraParams1, cameraParams2, R12', T12);
stereoParams13 = stereoParameters(cameraParams1, cameraParams3, R13', T13);

%% 3 freq unwrapped phase
uph1_dir = sprintf("%s/%s/%s/cam%02d", root_dir, data_date, object, cam1_num);
uph2_dir = sprintf("%s/%s/%s/cam%02d", root_dir, data_date, object, cam2_num);
uph3_dir = sprintf("%s/%s/%s/cam%02d", root_dir, data_date, object, cam3_num);

[uph1, mask1] = unwrapThreeFrequency(uph1_dir, pitch, height, width, NStep);
[uph2, mask2] = unwrapThreeFrequency(uph2_dir, pitch, height, width, NStep);
[uph3, mask3] = unwrapThreeFrequency(uph3_dir, pitch, height, width, NStep);

% if masking

% mask1 = imread(sprintf("C:/Users/USER/Desktop/mvs/250410_studio_data/uph/%s/mask/%02d.png", object, cam1_num));
% mask2 = imread(sprintf("C:/Users/USER/Desktop/mvs/250410_studio_data/uph/%s/mask/%02d.png", object, cam2_num));
% mask3 = imread(sprintf("C:/Users/USER/Desktop/mvs/250410_studio_data/uph/%s/mask/%02d.png", object, cam3_num));

%%
uph1(mask1==0) = 0;
uph2(mask2==0) = 0;
uph3(mask3==0) = 0;

figure
imshow(uph1)
clim([min(uph1(:)), max(uph1(:))])
title("uph1")

figure
imshow(uph2)
clim([min(uph2(:)), max(uph2(:))])
title("uph2")

figure
imshow(uph3)
clim([min(uph3(:)), max(uph3(:))])
title("uph3")

% if filtering

% uph1 = imgaussfilt(uph1, filterSize);
% uph2 = imgaussfilt(uph2, filterSize);

%% rectify images 1 / 2
[uph12_rect, uph21_rect, reprojectionMatrix12, camMatrix12, camMatrix21, R_r12, R_r21] = rectifyStereoImages(uph1, uph2, stereoParams12, 'OutputView', 'full');
[mask12_rect, mask21_rect] = rectifyStereoImages(mask1, mask2, stereoParams12, 'OutputView', 'full');

% visualize rectified uph

% figure
% imshow(uph12_rect)
% clim([min(uph12_rect(:)), max(uph12_rect(:))])
% title("uph1 rect")
% 
% figure
% imshow(uph21_rect)
% clim([min(uph21_rect(:)), max(uph21_rect(:))])
% title("uph2 rect")

figure
imshowpair(uph12_rect, uph21_rect, 'montage')
title('Rectified Images 1,2')

%% rectify images 1 / 3
[uph13_rect, uph31_rect, reprojectionMatrix13, camMatrix13, camMatrix31, R_r13, R_r31] = rectifyStereoImages(uph1, uph3, stereoParams13, 'OutputView', 'full');
[mask13_rect, mask31_rect] = rectifyStereoImages(mask1, mask3, stereoParams13, 'OutputView', 'full');

figure
imshowpair(uph13_rect, uph31_rect, 'montage')
title('Rectified Images 1,3')

%% find disparity 1 / 2
[rectH_12, rectW_12] = size(uph12_rect);
disparityMap12 = phaseBasedDisparityStudio(uph12_rect, uph21_rect, rectH_12, rectW_12, mask12_rect, mask21_rect, disparityPolarity12, 0, rectW_12);

figure
imshow(disparityMap12)
clim([min(disparityMap12(:)), max(disparityMap12(:))])
title("Disparity 1,2")

%% find disparity 1 / 3
[rectH_13, rectW_13] = size(uph13_rect);
disparityMap13 = phaseBasedDisparityStudio(uph13_rect, uph31_rect, rectH_13, rectW_13, mask13_rect, mask31_rect, disparityPolarity13, 0, rectW_13);

figure
imshow(disparityMap13)
clim([min(disparityMap13(:)), max(disparityMap13(:))])
title("Disparity 1,3")

%% reconstruct 3D point cloud
xyzPoints12 = reconstructScene(disparityMap12, reprojectionMatrix12);
x12 = xyzPoints12(:,:,1); y12 = xyzPoints12(:,:,2); z12 = xyzPoints12(:,:,3);

xyzPoints13 = reconstructScene(disparityMap13, reprojectionMatrix13);
x13 = xyzPoints13(:,:,1); y13 = xyzPoints13(:,:,2); z13 = xyzPoints13(:,:,3);

%%
z_min = 2000; z_max = 2500;

x_trim12 = -x12; y_trim12 = -y12; z_trim12 = -z12;

x_trim12(z_trim12>z_max) = NaN; x_trim12(z_trim12<z_min) = NaN;
y_trim12(z_trim12>z_max) = NaN; y_trim12(z_trim12<z_min) = NaN;
z_trim12(z_trim12>z_max) = NaN; z_trim12(z_trim12<z_min) = NaN;


x_trim13 = -x13; y_trim13 = -y13; z_trim13 = -z13;

x_trim13(z_trim13>z_max) = NaN; x_trim13(z_trim13<z_min) = NaN;
y_trim13(z_trim13>z_max) = NaN; y_trim13(z_trim13<z_min) = NaN;
z_trim13(z_trim13>z_max) = NaN; z_trim13(z_trim13<z_min) = NaN;


% figure
% surf(x_trim12,y_trim12,-z_trim12, 'FaceColor', 'interp',...
%     'EdgeColor', 'none',...
%     'FaceLighting', 'phong');
% set(gca, 'DataAspectRatio', [1, 1, 1])
% axis equal;
% camlight right
% view(0, 90 );
% set(gca, 'xdir', 'reverse')
% title('PC 12')
% colorbar
% 
% figure
% surf(x_trim13,y_trim13,-z_trim13, 'FaceColor', 'interp',...
%     'EdgeColor', 'none',...
%     'FaceLighting', 'phong');
% set(gca, 'DataAspectRatio', [1, 1, 1])
% axis equal;
% camlight right
% view(0, 90 );
% set(gca, 'xdir', 'reverse')
% title('PC 13')
% colorbar

%% Save ply file 1 / 2
pc12 = xyz2ply(x_trim12, y_trim12, z_trim12);

figure
pcshow(pc12)
colormap("jet")

% pcwrite(pc, "skull_active_stereo.ply")

%% Point cloud 1 / 2 - cam1 coord

[pc_world12, P_orig12] = xyz2ply_world(x_trim12,y_trim12,z_trim12, R_r12, E1);

figure
pcshow(pc_world12)
colormap("jet")

%% Save ply file 1 / 3
pc13 = xyz2ply(x_trim13, y_trim13, z_trim13);

figure
pcshow(pc13)
colormap("jet")

% pcwrite(pc, "skull_active_stereo.ply")

%% Point cloud 1 / 3 - cam1 coord

[pc_world13, P_orig13] = xyz2ply_world(x_trim13,y_trim13,z_trim13, R_r13, E1);

figure
pcshow(pc_world13)
colormap("jet")

%% Combine
pc_combined = pcmerge(pc_world12, pc_world13, 0.1);

figure
pcshow(pc_combined)
colormap('jet')

%% Savve ply file
% pc_dir = sprintf("C:/Users/KHW/Desktop/mvs/studio_data/3d_results/%s", object);
% if exist(pc_dir, "dir") == 0
%     mkdir(pc_dir);
% end
% 
% pcwrite(pc12, sprintf("%s/cam%d_%d.ply", pc_dir, cam1_num, cam2_num));
% pcwrite(pc13, sprintf("%s/cam%d_%d.ply", pc_dir, cam1_num, cam3_num));