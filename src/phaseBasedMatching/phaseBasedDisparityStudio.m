function [disparityMap] =phaseBasedDisparityStudio(unwrPhaseRectL,unwrPhaseRectR,rectH,rectW,maskRectL,maskRectR, disparityPolarity, min, max)

disparityMap = zeros(rectH,rectW);

% Left camera 기준
if disparityPolarity > 0
    % Left uph_rect 가 Right uph_rect 보다 왼쪽에 있을 때, (uph 증가 방향은 오른쪽) 
    for i = 1:rectH
        for j = 2:rectW-1
            flag = 0;
            if maskRectL(i, j) > 0
    %             [~, k] = min(abs(unwrPhaseRectR(i,:) - unwrPhaseRectL(i,j)));
    %             
    %             disparityMap(i,j) = k-j;
    
                k = j + min;
                while (flag == 0) && (k < j + max) && (k > 0)&& (k < rectW)
                    if (maskRectR(i, k)> 0) && (maskRectR(i, k-1)> 0) && (k>0) %?
                        if unwrPhaseRectL(i, j) > unwrPhaseRectR(i, k-1) && (unwrPhaseRectL(i, j) < unwrPhaseRectR(i, k))
                            % I found the rough global stereo matching 
                            % from here I want to apply local stereo matching
                            % with census transform
    %                         if unwrPhaseRectL(i, j) - unwrPhaseRectR(i, k-1) > 1 || unwrPhaseRectL(i, j) - unwrPhaseRectR(i, k) > 1
    %                             break
    %                         end
                            cor_x = k-1 + (unwrPhaseRectL(i,j) - unwrPhaseRectR(i,k-1))/(unwrPhaseRectR(i,k) - unwrPhaseRectR(i,k-1));
                            disparityMap(i, j) = cor_x - j;
%                             disparityMap(i, j) = k-1-j+(unwrPhaseRectL(i,j)-unwrPhaseRectR(i,k-1))/(unwrPhaseRectR(i,k)-unwrPhaseRectR(i,k-1));
    %                         disparityMap(i, j) = j-k;
                            % disp([disparityMap(i, j)])
                            flag = 1;
                        end
                    end
                    k = k+1;
                end
                if (flag == 0) && (k == rectW)
                    disparityMap(i, j) = NaN;
                end
            end
        end
    end

else
    % Left uph_rect 가 Right uph_rect 보다 오른쪽 있을 때, (uph 증가 방향은 오른쪽) 
    for i = 1:rectH
        for j = 2:rectW-1
            flag = 0;
            if maskRectL(i, j) > 0
                k = j - min;
                while (flag == 0) && (k > j - max) && (k > 0)&& (k < rectW)
                    if (maskRectR(i, k)> 0) && (maskRectR(i, k+1)> 0) && (k>0) %?
                        if unwrPhaseRectL(i, j) < unwrPhaseRectR(i, k+1) && (unwrPhaseRectL(i, j) > unwrPhaseRectR(i, k))
                            % I found the rough global stereo matching 
                            % from here I want to apply local stereo matching
                            % with census transform
    %                         if unwrPhaseRectL(i, j) - unwrPhaseRectR(i, k-1) > 1 || unwrPhaseRectL(i, j) - unwrPhaseRectR(i, k) > 1
    %                             break
    %                         end
                            cor_x = k + (unwrPhaseRectL(i,j) - unwrPhaseRectR(i,k))/(unwrPhaseRectR(i,k+1) - unwrPhaseRectR(i,k));
                            disparityMap(i, j) = cor_x - j;
%                             disparityMap(i, j) = k-1-j+(unwrPhaseRectL(i,j)-unwrPhaseRectR(i,k-1))/(unwrPhaseRectR(i,k)-unwrPhaseRectR(i,k-1));
    %                         disparityMap(i, j) = j-k;
                            % disp([disparityMap(i, j)])
                            flag = 1;
                        end
                    end
                    k = k-1;
                end
                if (flag == 0) && (k == rectW)
                    disparityMap(i, j) = NaN;
                end
            end
        end
    end
end

end
