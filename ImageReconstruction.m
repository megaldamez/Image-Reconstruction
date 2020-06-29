% clear all;

load('MQP4.mat','DataArray3')

baseLine = mean(mean(DataArray3(1000:4000,:)));
rfData = DataArray3 - baseLine;
rfData(1:300,:) = 0;

rfData_2 = imresize(rfData, [5000*6/8 361]); %% converting 80MHz to 60MHz

soundSpeed = 1540; % [m/s]
no_ele = 1; %total number of elements
channelSpacing = 0.2; %60/128
fs = 60e6; %sample frequency
sampleSpacing = (1/fs)*soundSpeed*1000/2; %sample number vs mm
times = 1;

%%
figure(1)
imagesc((abs(rfData_2)))
xlabel('Angle') 
ylabel('Number of Samples')

%%
post_recon = zeros(401,401);
for i = 1:201
    for j = 1:201
        for angle = 0:360
            ypos = (i - 201);
            zpos = 0;
            xpos = (j - 201) + 27.5/0.05;
            xdis = xpos * 0.05;
            ydis = ypos * 0.05;
            zdis = zpos * 0.05;
            positions2 = [xdis ydis zdis]/1000;
            new_positions2 = rotatePhantom3(positions2, angle);
            dis = sqrt(new_positions2(:,1).^2 + new_positions2(:,2).^2);
            pixeldis = round(dis'*1000/sampleSpacing);
            
            post_recon(j,i) = post_recon(j,i) + (rfData_2(pixeldis,(angle+1)));
            
        end
    end
end
%%
figure(2)
imagesc(db(abs(post_recon)))
title('Post Reconstruction')
xlabel('Pixels')
ylabel('Pixels')
%% 
env = abs(hilbert(post_recon));
x = [1 401]*0.05;
y = [1 401]*0.05;
env = env/max(max(env));
%%
figure(4)
imagesc(x,y,db(env),[-25 0]);
ylabel('Axial Distance [cm]')
xlabel('Lateral Distance [cm]')
colormap(gray)
axis image
colorbar