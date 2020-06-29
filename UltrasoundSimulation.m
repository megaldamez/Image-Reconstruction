clear all;

soundSpeed = 1540; % [m/s]
no_ele = 1; %total number of elements
channelSpacing = 0.2; %60/128
fs = 60e6; %sample frequency
sampleSpacing = (1/fs)*soundSpeed*1000/2;%sample number vs mm
times = 1;
%%
field_init(0);
% final_rf = zeros(401,401);

Angle = 0:360;
phantom_positions = [27.5 0 0]/1000;
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
imagesc((abs(rf_us)))
ylabel('Angle') 
xlabel('Number of Samples')
%%
post_recon = zeros(401,401);
for i = 1:401
    for j = 1:401
        for angle = 0:360
            ypos = (i - 201);
            zpos = 0;
            xpos = (j - 201) + 27.5/0.05; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            xdis = xpos * 0.05;
            ydis = ypos * 0.05;
            zdis = zpos * 0.05;
            positions2 = [xdis ydis zdis]/1000;  %  The position of the phantom [m]
            new_positions2 = rotatePhantom3(positions2, angle);
            dis = sqrt(new_positions2(:,1).^2 + new_positions2(:,2).^2);
            pixeldis = round(dis'*1000/sampleSpacing);

            post_recon(j,i) = post_recon(j,i) + (rf_us(pixeldis,(angle+1)));
            
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
x = [1 401]*0.05/2;
y = [1 401]*0.05/2;
env = env/max(max(env));
%%
figure(3)
imagesc(x,y,db(env),[-20 0]);
title('Final Image with 1 Degree Increments')
ylabel('Axial Distance [cm]')
xlabel('Lateral Distance [cm]')
colormap(gray)
axis image
% axis([15 36 3 9])
colorbar