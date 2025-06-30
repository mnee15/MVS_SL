function showCrossSection(I, crossSection, xmin, xmax, dir)

    dp = log(abs(fftshift(fft2(I)))+1);
    if (dir == 1)
        figure, plot(dp(crossSection, :))
        set(gca, 'FontSize', 15);
        xlabel("f_x", 'FontSize', 25)
    else
        figure, plot(dp(:, crossSection))
        set(gca, 'FontSize', 15);
        xlabel("f_y", 'FontSize', 25)
    end
    grid on
    xlim([xmin xmax])
    ylabel("fft(image)","FontSize",25)
    
 
end