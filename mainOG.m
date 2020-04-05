clear all;

soundSpeed = 1540;
no_ele = 128; %total number of elements
channelSpacing = 0.2;%60/128;
fs = 40e6; %sample frequency
sampleSpacing = (1/fs)*soundSpeed*1e3; %sample number vs mm
times = 1;

generateRF;

for i = 1:size(prebeam,3)
    rf_us(:,i) = prebeam(:,i,i);
end

rf_us = vertcat(zeros(round(t*fs-60),size(prebeam,3)),rf_us);
figure(1)
imagesc(db(abs(rf_us)))
out = DAS_ultrasound(rf_us, no_ele, fs, channelSpacing, soundSpeed,times);

% imagesc(out);
figure(2)
env = abs(hilbert(out));
st = 1;
ed = 2900;
% x = [1 size(out,2)]*0.5/times-size(out)*0.5/times/2;
x = [1 size(out,2)]*channelSpacing;
% y = [st size(postBF_F,1)]*sampleSpacing;
y = [st ed]*sampleSpacing/2;
env = env/max(max(env(st:ed,:)));
figure(3)
imagesc(x,y,db(env(st:ed,:)),[-40 0]);
% imagesc(abs(env(3000:end-500,:)));
colormap(gray)
axis image
colorbar