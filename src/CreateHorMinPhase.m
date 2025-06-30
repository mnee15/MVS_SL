function phmin = CreateHorMinPhase(zmin, fringe_pitch, h, w, calib_dir)

% clear all

Ac = textread(sprintf('%s/CamIntrinsicMatrix.txt', calib_dir));
Rc = textread(sprintf('%s/CamRotationMatrix.txt', calib_dir));
Tc = textread(sprintf('%s/CamTranslationVector.txt', calib_dir));
Ap = textread(sprintf('%s/ProjIntrinsicMatrix.txt', calib_dir));
Rp = textread(sprintf('%s/ProjRotationMatrix.txt', calib_dir));
Tp = textread(sprintf('%s/ProjTranslationVector.txt', calib_dir));

Ac = Ac(:,1:3);
Rc = Rc(:,1:3);
Tc = Tc(:,1);
Ap = Ap(:,1:3);
Rp = Rp(:,1:3);
Tp = Tp(:,1);

Pc = Ac * [Rc, Tc];
Pp = Ap * [Rp, Tp];

% w = 640;
% h = 800;

T = fringe_pitch;

phmin = zeros(h, w);
for vc = 1:h
    for uc = 1:w
        M = [Pc(3,1) * uc - Pc(1,1), Pc(3,2) * uc - Pc(1,2)
             Pc(3,1) * vc - Pc(2,1), Pc(3,2) * vc - Pc(2,2)];
        b = [Pc(1,4) - Pc(3,4) * uc - (Pc(3,3) * uc - Pc(1,3)) * zmin
             Pc(2,4) - Pc(3,4) * vc - (Pc(3,3) * vc - Pc(2,3)) * zmin
             ];
        xy = M\b;
        XX = Ap * Rp * [xy(1), xy(2), zmin]' + Ap * Tp;
        vp = XX(2) / XX(3);
        phmin(vc,uc) = vp * 2 * pi / T;
    end
end

% fileName = sprintf('sgwfgerg.raw');
% fid = fopen(fileName, 'wb');
% fwrite(fid, phmin', 'float32');
% fclose(fid);
% 
% imagesc(phmin); axis equal