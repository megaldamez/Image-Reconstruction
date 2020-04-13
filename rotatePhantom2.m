function new_p = rotatePhantom(p, Angle)
%  p = [3/100 0 0]; % [cm]
% define the x- and y-data for the original line we would like to rotate
x = p(1,1);
y = p(1,2);
z = p(1,3);
% create a matrix of these points, which will be useful in future calculations
p = reshape(p, [3 1]);
% choose a point which will be the center of rotation
z_center = 0;
y_center = 0;
x_center = 0/100; % [cm] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a matrix which will be used later in calculations
center = repmat([x_center; y_center; z_center], 1, length(x));
% define a 60 degree clockwise rotation matrix
% Angle = 0;
% Angle = [ 90 180 270];
Angle = reshape(Angle, [length(Angle) 1]);
theta = deg2rad(Angle);
%theta = deg2rad(45); % pi/3 radians = 60 degrees
R = zeros(3.*length(theta),2);
m = 0:3:(length(R)-1);
n = 1:length(theta);
R(1+m,:) = [cos(theta(n,:)) -sin(theta(n,:))];
R(3+m,:) = [sin(theta(n,:)) cos(theta(n,:))];
% R = reshape(R, [2 3]);
% do the rotation...
s = p - center;     % shift points in the plane so that the center of rotation is at the origin
s = reshape(s, [1 3]);
l = 1:length(R);
l = vec2mat(l,3);
so = zeros(length(theta),2);
for n = 1:length(theta)
    so(n,:) = s*R(l(n,:),:); % apply the rotation about the origin
    %vo = so * center;   % shift again so the origin goes back to the desired center of rotation
    % this can be done in one line as:
    % vo = R*(p - center) + center
    % pick out the vectors of rotated x- and y-data
    x_rotated(n,:) = so(n,1)+x_center;
    z_rotated(n,:) = 0;
    y_rotated(n,:) = so(n,2)+y_center;
end
new_p = [x_rotated y_rotated z_rotated]; % [cm]

% % make a plot
% plot3(x, y, z, 'ro', x_rotated, y_rotated, z_rotated,  'ko', x_center, y_center, z_center, 'mo');
% xlabel('x')
% ylabel('y')
% zlabel('z')
% axis equal

end