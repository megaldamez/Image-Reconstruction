% clear all;

load('MQP1.mat','DataArray2')

soundSpeed = 1540; % [m/s]
no_ele = 1; %total number of elements
channelSpacing = 0.2; %60/128
fs = 10e6; %sample frequency
sampleSpacing = (1/fs)*soundSpeed*1e2; %sample number vs mm
times = 1;

rf_us = DataArray2;
% field_init(0);
% % final_rf = zeros(401,401);
% 
% Angle = 1:361;
% phantom_positions = [0 0 30]/1000;
% %
% 
% new_phantom_positions = rotatePhantom(phantom_positions, Angle);
% %         generateRF2;
% A = squeeze(DataArray(:,:,1));
% DataArray(:,:,1) = A;
% A = A-2000;
% A = A(:,[1:10]);
% B = squeeze(DataArray(:,1,:));
% DataArray(:,1,:) = B;
%%
figure(1)
% subplot(2,1,1)
% plot(A)
% subplot(2,1,2)
% plot(B)
plot(rf_us)
% imagesc(db(abs(A)))
figure(2)
% subplot(2,1,1)
% imagesc(db(abs(A)))
% subplot(2,1,2)
imagesc(db(abs(rf_us)))
%%
% for i = 1:size(DataArray)
%     rf_us(:,i) = DataArray(:,i,i);
% end
% 
% samples = 1:length(rf_us);
% t = (samples./fs)./2; % [s]
% 
% rf_us = vertcat(zeros(round(t*fs-60),size(DataArray,3)),rf_us);
%%
%zeros(5000,size(new_phantom_positions,1));
% rf_us = log(double(rf_us));
% for ii = 1:size(new_phantom_positions,1)
%     
%     temp = generateRF2(new_phantom_positions(ii,:));
%     rf_us(1:size(temp,1),ii) = temp;
% end
% figure(1)
% plot(A)
% figure(1)
% imagesc(db(abs(rf_us)))
%%
post_recon = zeros(401,401);
for i = 1:401
    for j = 201
        xpos = (i - 201);
        ypos = 0;
        zpos = (j - 201) + 0.03/0.05;
        xdis = xpos * 0.05;
        ydis = ypos * 0.05;
        zdis = zpos * 0.05;
        positions2 = [xdis ydis zdis]/1000;  %  The position of the phantom [m]
        dis = sqrt(positions2(1).^2 + positions2(3).^2);
        pixeldis = round(dis'*1000/sampleSpacing);
        post_recon(j,i) = (rf_us(pixeldis));
    end
end


figure(3)
imagesc(db(abs(post_recon)))
% imagesc(db(abs(hilbert(rf_us))));
% imagesc(db(abs(hilbert(final_rf))));
%%
% samples = 1:length(rf_us);
% time = (samples./fs)./2; % [s]
% 
% distance = time.*soundSpeed.*100; % [s * m/s * 100cm/m]
% 
% 
% subplot(3,1,1)
% plot(rf_us)
% xlabel('samples')
% subplot(3,1,2)
% plot(time, rf_us)
% xlabel('Time [s]')
% subplot(3,1,3)
% plot(distance, rf_us)
% xlabel('Distance [cm]')
%%

% plot3(0/100, 0, 3/100, 'ro', 1/100, 0, 3/100,  'go',new_phantom_positions(:,1), new_phantom_positions(:,2), new_phantom_positions(:,3), 'ko');
% xlabel('x')
% ylabel('y')
% zlabel('z')
%%
out = DAS_ultrasound(rf_us, no_ele, fs, channelSpacing, soundSpeed,times);
% out1 = DAS_ultrasound(post_recon, no_ele, fs, channelSpacing, soundSpeed,times);
% 
% imagesc(out);
env = abs(hilbert(out));
st = 1;
ed = 2321;
% x = [1 size(out,2)]*0.5/times-size(out)*0.5/times/2;
x = [1 size(out,2)]*channelSpacing;
% y = [st size(postBF_F,1)]*sampleSpacing;
y = [st ed]*sampleSpacing/2;
env = env/max(max(env(st:ed,:)));

%%
figure(4)
imagesc(x,y,db(env(st:ed,:)),[-20 0]);
% imagesc(abs(env(3000:end-500,:)));
colormap(gray)
axis image
colorbar