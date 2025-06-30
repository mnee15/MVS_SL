function [K, E, R, T] = loadCalibrationTxt(filename)
E = zeros(4,4);
K = zeros(3,3);

f = fopen(filename, "r");
i=1;

while ~feof(f)
    line = fgetl(f);
    if i>=2 && i<=5
        row = str2double(split(line, " "));
        row = row(1:4);
        E(i-1, :) = row;
    end

    if i>=8 && i<=10
        row = str2double(split(line, " "));
        row = row(1:3);
        K(i-7, :) = row;
    end
    i = i+1;
end

R = E(1:3, 1:3);
T = E(1:3, 4);
end