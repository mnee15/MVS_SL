function [Kp, Ep, Rp, Tp] = loadProjCalib(calib_dir)
file_txtC = sprintf('%s/ProjRotationMatrix.txt', calib_dir);
Cf0 = textread(file_txtC);
Rp = Cf0(1:3, 1:3);

file_txtD = sprintf('%s/ProjTranslationVector.txt', calib_dir);
Df0 = textread(file_txtD);
Tp = Df0(:, 1);

file_txtB = sprintf('%s/ProjIntrinsicMatrix.txt', calib_dir);
Bf0 = textread(file_txtB);
Kp = Bf0(1:3, 1:3);

Ep = zeros(4,4);
Ep(1:3,1:3) = Rp;
Ep(1:3,4) = Tp;
Ep(4,4) = 1;
end