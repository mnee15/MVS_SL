function showFourierFrequencyDomain(I, titleName)
    
    % dp = abs(fftshift(fft2(I)));
    dp = log(abs(fft2(I))+1);
    [M, N] = size(I);
    x = 0:(N-1);
    y = 0:(M-1);
    x_shift = ifftshift(x - N/2);
    y_shift = ifftshift(y - M/2);


    figure;
    mesh(x_shift, y_shift, dp)%, set(gca, 'DataAspectRatio', [1 1 1]);
    colormap('jet');
    colorbar;
    % title('2D FFT Magnitude (without fftshift)');

    ax = gca;
    ax.XAxis.FontSize = 15;
    ax.YAxis.FontSize = 15;
    ax.ZAxis.FontSize = 15;
    ax.XAxis.FontWeight = 'bold';
    ax.YAxis.FontWeight = 'bold';
    ax.ZAxis.FontWeight = 'bold';
    xlim([-100 100])
    ylim([-75 75])
    % zlim([0 20])
    caxis([9, 15]);
    xlabel('Frequency X', 'FontSize', 15, 'FontWeight', 'bold');
    ylabel('Frequency Y', 'FontSize', 15, 'FontWeight', 'bold');
    zlabel('Magnitude');
    view(3); % 3D 뷰 설정

end