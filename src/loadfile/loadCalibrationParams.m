function stereoParams = loadCalibrationParams(stereoCalibrationType, calibrationParameterPath, height, width)
    switch stereoCalibrationType
        case StereoCalibration.Matlab
            data = load(calibrationParameterPath);
%             stereoParams = data.stereoParams32;
            stereoParams = data.stereoParams;
        case StereoCalibration.OpenCV
            stereoParams = loadStereoCalibrationParams(calibrationParameterPath, height, width);
    end
end