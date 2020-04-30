clear all;

soundSpeed = 1540; % [m/s]
no_ele = 1; %total number of elements
channelSpacing = 0.2; %60/128
fs = 60e6;
sampleSpacing = (1/fs)*soundSpeed*1000/2; %sample number vs mm
Angle = 0:360;
% Angle = [0 90 180 270];
phantom_positions = [3 0 0]/100; %% 55/2 mm %%%%%%%%%%%%%%%%%%
times = 1;

field_init(0);
% final_rf = zeros(401,401);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

new_phantom_positions = rotatePhantom3(phantom_positions, Angle);
%         generateRF2;
rf_us = zeros(5000,size(new_phantom_positions,1));
for ii = 1:size(new_phantom_positions,1)
    
    temp = generateRF2(new_phantom_positions(ii,:));
    rf_us(1:size(temp,1),ii) = temp;
end
%%
figure(1)
imagesc(db(abs(rf_us)))


%%
post_recon = zeros(401,401);
for i = 1:401
    for j = 1:401
        for angle = 0:360
            zpos = (i - 201);
            ypos = 0;
            xpos = (j - 201) + 0.03/0.05; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            xdis = xpos * 0.05;
            ydis = ypos * 0.05;
            zdis = zpos * 0.05;
            positions2 = [xdis ydis zdis]/1000;  %  The position of the phantom [m]
            new_positions2 = rotatePhantom3(positions2, angle);
            dis = sqrt(new_positions2(:,1).^2 + new_positions2(:,3).^2);
            pixeldis = round(dis'*1000/sampleSpacing);
            
            post_recon(j,i) = post_recon(j,i) + (rf_us(pixeldis));
            
        end
    end
end
%%
figure(2)
imagesc(db(abs(post_recon)))
%%
% out = DAS_ultrasound(rf_us, no_ele, fs, channelSpacing, soundSpeed,times);

% imagesc(out);
env = abs(hilbert(post_recon));
st = 1;
ed = 2321;
% x = [1 size(out,2)]*0.5/times-size(out)*0.5/times/2;
x = [st size(out,2)]*channelSpacing;%-10;
% y = [st size(postBF_F,1)]*sampleSpacing;
y = [st ed]*sampleSpacing/2;
env = env/max(max(env(st:ed,:)));
%%
figure(3)
imagesc(x,y,db(env),[-20 0]);
% imagesc(abs(env(3000:end-500,:)));
ylabel('Axial Distance [mm]')
xlabel('Lateral Distance [mm]')
colormap(gray)
axis image
% axis([15 36 3 9])
colorbar