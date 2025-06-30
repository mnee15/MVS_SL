function [] = showPhase(phase, dir, titleName)
    
    figure, imagesc(phase), colormap(gray), set(gca, 'DataAspectRatio', [1 1 1]);
    colorbar
    title(titleName)
    
    % x축과 y축 비활성화
    ax = gca;  % 현재 축을 가져옴
    ax.XAxis.Visible = 'off';
    ax.YAxis.Visible = 'off';
    
    % xtick 및 ytick 비활성화
    ax.XTick = [];
    ax.YTick = [];
    
    % xticklabel 및 yticklabel 비활성화
    ax.XTickLabel = [];
    ax.YTickLabel = [];

    % if (dir == 1)
    %     crossSection = floor(size(phase,2)/2);
    %     disp(crossSection)
    %     figure, plot(phase(:, crossSection))
    %     titleName = sprintf("%s - vertical cross section", titleName);
    %     xlabel("y (pixel)")
    %     title(titleName)
    % else
    %     crossSection = floor(size(phase,1)/2);
    %     figure, plot(phase(crossSection, :))
    %     titleName = sprintf("%s - horizontal cross section", titleName);
    %     xlabel("x (pixel)")
    %     title(titleName)
    % end
    % ylabel('phaese (rad)')
    % grid on

end