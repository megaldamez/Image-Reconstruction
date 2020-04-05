%  Compress the data to show 60 dB of
%  dynamic range for the cyst phantom image
%
%  version 1.3 by Joergen Arendt Jensen, April 1, 1998.
%  version 1.4 by Joergen Arendt Jensen, August 14, 2007.
%          Calibrated 50 dB display made

f0=160e6;                 %  Transducer center frequency [Hz]
fs=60e6;                  %  Sampling frequency [Hz]
c=1540;                   %  Speed of sound [m/s]
no_lines=3;               %  Number of lines in image
image_width=40/1000;      %  Size of image sector
d_x=image_width/no_lines; %  Increment for image
tstart=1;
%  Read the data and adjust it in time 


min_sample=0;
for i=1:no_lines

  %  Load the result
  load('MQP3.mat','DataArray3')
  rf_data = [DataArray3(:,i)];
  
  %  Find the envelope
  
  rf_env=abs(hilbert([zeros(round(tstart*fs-min_sample),1); rf_data]));
  env(1:max(size(rf_env)),i)=rf_env;
 end

%  Do logarithmic compression

D=10;         %  Sampling frequency decimation factor
dB_range=50;  % Dynamic range for display in dB

disp('Finding the envelope')
log_env=env(1:D:max(size(env)),:)/max(max(env));
log_env=20*log10(log_env);
log_env=127/dB_range*(log_env+dB_range);

%  Make an interpolated image

disp('Doing interpolation')
ID=20;
[n,m]=size(log_env);
new_env=zeros(n,m);
%%
new_env = log_env;
%%
% for i=1:m
%   new_env(:,i)=log_env(:,i);
%  end
% [n,m]=size(new_env);
%%  
fn=fs/D;
clf
image(((1:(ID*no_lines-1))*d_x/ID-no_lines*d_x/2)*1000,((1:n)/fn+min_sample/fs)*1540/2*1000,new_env)
xlabel('Lateral distance [mm]')
ylabel('Axial distance [mm]')
colormap(gray(128))
axis('image')
axis([-20 20 35 90])