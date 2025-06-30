function showImage(I, titleName)

    figure, colormap(gray), imagesc(I), set(gca, 'DataAspectRatio', [1 1 1])
    colorbar
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
    % title(titleName)
    
end