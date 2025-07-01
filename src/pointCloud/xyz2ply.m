function pc = xyz2ply(x_trim,y_trim,z_trim)
%% Save ply file
    pc = pointCloud([x_trim(:) y_trim(:) z_trim(:)]);
    
    % Point Cloud의 위치 데이터 추출
    xyzPoints = pc.Location;
    
    % NaN 값이 포함된 행 찾기
    nanIndices = any(isnan(xyzPoints), 2);  % NaN 값이 있는 행 인덱스
    
    % NaN이 아닌 점들로 필터링
    cleanXYZPoints = xyzPoints(~nanIndices, :);
    % NaN이 제거된 Point Cloud 생성
    pc = pointCloud(cleanXYZPoints);
end

