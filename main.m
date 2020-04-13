clear all;

soundSpeed = 1540; % [m/s]
no_ele = 1; %total number of elements
channelSpacing = 0.2; %60/128
fs = 60e6;
sampleSpacing = (1/fs)*soundSpeed*1000/2; %sample number vs mm
times = 1;

field_init(0);
% final_rf = zeros(401,401);

Angle = 1:361;
phantom_positions = [2.75 0 0]/100; %% 55/2 mm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

new_phantom_positions = rotatePhantom(phantom_positions, Angle);
%         generateRF2;
rf_us = zeros(5000,size(new_phantom_positions,1));
for ii = 1:size(new_phantom_positions,1)
    
    temp = generateRF2(new_phantom_positions(ii,:));
    rf_us(1:size(temp,1),ii) = temp;
end
figure(1)
imagesc(db(abs(rf_us)))
% plot(rf_us)

post_recon = zeros(401,401);
for i = 1:401
    for j = 1:401
        for angle = 1:361
            
            ypos = (i - 201);
            zpos = 0;
            xpos = (j - 201) + 0.02/0.05; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            xdis = xpos * 0.05;
            ydis = ypos * 0.05;
            zdis = zpos * 0.05;
            positions2 = [xdis ydis zdis]/1000;  %  The position of the phantom [m]
            new_positions2(angle,:) = rotatePhantom(positions2, angle);
            dis = sqrt(new_positions2(angle,1).^2 + new_positions2(angle,3).^2);
            pixeldis(angle) = round(dis'*1000/sampleSpacing);
            
            post_recon(j,i) = post_recon(j,i) + (rf_us(pixeldis(angle),angle));
            
        end
    end
end
%%
figure(2)
imagesc(db(abs(post_recon)))
%%
% samples = 1:length(rf_us);
% time = (samples./fs)./2; % [s]
%
% distance = time.*soundSpeed.*100; % [s * m/s * 100cm/m]

% imagesc(db(abs(hilbert(rf_us))));
% imagesc(db(abs(hilbert(final_rf))));

% subplot(3,1,1)
% plot(rf_us)
% xlabel('samples')
% subplot(3,1,2)
% plot(time, rf_us)
% xlabel('Time [s]')
% subplot(3,1,3)
% plot(distance, rf_us)
% xlabel('Distance [cm]')


% plot3(0/100, 0, 3/100, 'ro', 1/100, 0, 3/100,  'go',new_phantom_positions(:,1), new_phantom_positions(:,2), new_phantom_positions(:,3), 'ko');
% xlabel('x')
% ylabel('y')
% zlabel('z')
%
out = DAS_ultrasound(rf_us, no_ele, fs, channelSpacing, soundSpeed,times);

% imagesc(out);
env = abs(hilbert(out));
st = 1;
ed = 2321;
% x = [1 size(out,2)]*0.5/times-size(out)*0.5/times/2;
x = [1 size(out,2)]*channelSpacing;
% y = [st size(postBF_F,1)]*sampleSpacing;
y = [st ed]*sampleSpacing/2;
env = env/max(max(env(st:ed,:)));

figure
imagesc(x,y,db(env(st:ed,:)),[-40 0]);
% imagesc(abs(env(3000:end-500,:)));
colormap(gray)
axis image
colorbar