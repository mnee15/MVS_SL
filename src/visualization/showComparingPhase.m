function showComparingPhase(ph_composite, ph_nshifted, crossSection, dir, pointDistance)
    
    [FringeHeight, FringeWidth] = size(ph_composite);
    if (dir==1)
        
        % figure, plot((1:pointDistance:FringeHeight),ph_composite(1:pointDistance:FringeHeight,crossSection),'o', 'DisplayName', 'Distorted pattern', 'LineWidth', 3)
        figure, plot(ph_composite(:,crossSection), 'DisplayName', 'Single-Shot', 'LineWidth', 3)
        set(gca, 'FontSize', 14);

        hold on
        plot(ph_nshifted(:,crossSection), 'DisplayName', 'Orig pattern', 'LineWidth', 3)
        grid on
        % title(titleName)
        xlabel('y (pixel)', 'FontSize', 24);
        ylabel('phase (rad)', 'FontSize', 24)
        legend('Location', 'northwest', 'FontSize', 16)
        axis square
        % xticks(0:200:1500);
        % yticks(0:20:140);
    else
        figure, plot((1:pointDistance:FringeWidth), ph_composite(crossSection, 1:pointDistance:FringeWidth),'o', 'DisplayName', 'Distorted pattern', 'LineWidth', 3)
        % figure, plot(ph_composite(crossSection, :), 'DisplayName', 'Single-Shot', 'LineWidth', 3)

        set(gca, 'FontSize', 14);
        hold on
        plot(ph_nshifted(crossSection, :),'DisplayName', 'Orig pattern', 'LineWidth', 3)
        grid on
        % title(titleName)
        xlabel('x (pixel)', 'FontSize', 24);
        ylabel('phase (rad)', 'FontSize', 24)
        legend('Location', 'northwest', 'FontSize', 16)
        axis square
        % xticks(0:200:2000);
        % yticks(0:20:180);
    
    end

end