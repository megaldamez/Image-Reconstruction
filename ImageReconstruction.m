% clear all;

load('MQP5.mat','DataArray3')

baseLine = mean(mean(DataArray3(1000:4000,:)));
rfData = DataArray3 - baseLine;
rfData(1:300,:) = 0;

rfData_2 = imresize(rfData, [5000*6/8 2]); %% converting 80MHz to 60MHz

soundSpeed = 1540; % [m/s]
no_ele = 1; %total number of elements
channelSpacing = 0.2; %60/128
fs = 60e6; %sample frequency
sampleSpacing = (1/fs)*soundSpeed*1e2; %sample number vs mm
times = 1;


%%
figure(1)
imagesc(db(abs(rfData_2)))

%%
post_recon = zeros(401,401);
for i = 1:401
    for j = 1:401
        for angle = 0:360
            zpos = (i - 201);
            ypos = 0;
            xpos = (j - 201) + 0.0275/0.05; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            xdis = xpos * 0.05;
            ydis = ypos * 0.05;
            zdis = zpos * 0.05;
            positions2 = [xdis ydis zdis]/1000;  %  The position of the phantom [m]
            new_positions2 = rotatePhantom(positions2, angle);
            dis = sqrt(new_positions2(:,1).^2 + new_positions2(:,3).^2);
            pixeldis = round(dis'*1000/sampleSpacing);
            
            post_recon(j,i) = post_recon(j,i) + (rfData_2(pixeldis));
            
        end
    end
end
%%
figure(2)
imagesc(db(abs(post_recon)))

%%
out = DAS_ultrasound(post_recon, no_ele, fs, channelSpacing, soundSpeed,times);
% out1 = DAS_ultrasound(post_recon, no_ele, fs, channelSpacing, soundSpeed,times);
% 
% imagesc(out);
env = abs(hilbert(out));
st = 1;
ed = 2321;
% x = [1 size(out,2)]*0.5/times-size(out)*0.5/times/2;
x = [1 size(out,2)]*0.5*0.05;
% y = [st size(postBF_F,1)]*sampleSpacing;
y = [st ed]*sampleSpacing/2*3;
env = env/max(max(env));

%%
figure(3)
imagesc(x,y,db(env),[-40 0]);
% imagesc(abs(env(3000:end-500,:)));
ylabel('Axial Distance [mm]')
xlabel('Lateral Distance [mm]')
colormap(gray)
axis image
% axis([20 60 0 2])
colorbar

%         xpos = (i - 201);
%         ypos = 0;
%         zpos = (j - 201) + 0.03/0.05;
%         xdis = xpos * 0.05;
%         ydis = ypos * 0.05;
%         zdis = zpos * 0.05;
%         positions2 = [xdis ydis zdis]/1000;  %  The position of the phantom [m]
%         dis = sqrt(positions2(1).^2 + positions2(3).^2);
%         pixeldis = round(dis'*1000/sampleSpacing);
%         post_recon(j,i) = (rfData_2(pixeldis));