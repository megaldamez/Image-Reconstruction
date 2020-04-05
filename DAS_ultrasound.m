
function out = DAS_ultrasound(rf, no_ele, Fs, channelSpacing, speedSound,times)

ns = size(rf,1);   % number of samples
nl = size(rf,2);   % number of lines

sampleSpacing = (1/Fs*speedSound)*1000/2; % spacing between samples in photoacoustic imaging

postBF = zeros(ns,nl*times);

hlfapt = round(no_ele/2);

% win = hamming(round(hlfapt)*2+1)';
for r = 1:nl*times % final line
%     if r<64
%         win = hanning((128-r)*2)';
%         F = 128-r;
%     else
%         win = hanning((128-(128-r))*2)';
%         F = 128-(128-r);
%     end
    %     RF(:,:) = RFframe(:,:,m);
    RF = rf;
    for j = 1:ns
          for i = r/times-hlfapt:r/times+hlfapt
%         for i = 1:128
            if i > 0 && i <= nl
                depth = j*(sampleSpacing*1);
                width = (r/times-(i)) * channelSpacing;
                rad = sqrt((depth)^2 + width^2);
                delay = (rad - depth)/(sampleSpacing);
                value = j+delay;
                f_value = floor(value);
                c_value = ceil(value);
                if delay == 0
                    postBF(j,r) = postBF(j,r) + RF(j,ceil(i));
                elseif c_value < ns
                    y_c = RF(c_value,ceil(i));
                    y_f = RF(f_value,ceil(i));
                    alpha = (value - f_value)/(c_value - f_value);
                    if alpha >0 && alpha <1
                        y = (1-alpha)*y_f + alpha*y_c;
                        postBF(j,r) = postBF(j,r) + y;
                    else
                        postBF(j,r) = postBF(j,r) + RF(j,ceil(i));
                    end 
                end
            end
        end
    end
end

out = postBF;