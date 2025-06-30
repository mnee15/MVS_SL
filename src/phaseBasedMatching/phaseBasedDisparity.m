function [disparityMap] =phaseBasedDisparity(unwrPhaseRectL,unwrPhaseRectR,rectH,rectW,maskRectL,maskRectR)

disparityMap = zeros(rectH,rectW);

for i = 1:rectH
    for j = rectW:-1:2
        flag = 0;
        if maskRectR(i, j) > 0
            k = j+1;
            while (flag == 0) && (k < rectW)
                k = k+1;
                if (maskRectL(i, k)> 0)&&(k<rectW-1) %?
                    
                    if unwrPhaseRectL(i, k-1) < unwrPhaseRectR(i, j) && (unwrPhaseRectL(i, k) > unwrPhaseRectR(i, j))
                        % I found the rough global stereo matching 
                        % from here I want to apply local stereo matching
                        % with census transform
                        disparityMap(i, j) = k-1-j+(unwrPhaseRectR(i,j)-unwrPhaseRectL(i,k-1))/(unwrPhaseRectL(i,k)-unwrPhaseRectL(i,k-1));
                        % disp([disparityMap(i, j)])
                        flag = 1;
                    end
                end
            end
            if (flag == 0) && (k == rectW)
                disparityMap(i, j) = NaN;
            end
        end
    end
end

end
