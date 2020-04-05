myim = ones(1370,1000);
map = gray(127);
myim(:,:)=80;
imwrite(myim,map,'myGrayimage.png')
I = imread('myGrayimage.png');
circle1 = [750 230 75];  % at 40 the 6mm diameter
circle2 = [750 458 63];  % at 50 the 5mm diameter
circle3 = [750 687 50];  % at 60 the 4mm diameter
circle4 = [750 915 38];  % at 70 the 3mm diameter
circle5 = [750 1144 25]; % at 80 the 2mm diameter
wcircle1 = [375 230 25]; % at 40 the 6mm diameter
wcircle2 = [375 458 38];
wcircle3 = [375 687 50];
wcircle4 = [375 915 63];
wcircle5 = [375 1144 75];
circle = [circle1; circle2; circle3; circle4; circle5];
blackim = insertShape(I,'FilledCircle',circle,...
    'Color', 'black');
wcircle = [wcircle1; wcircle2; wcircle3; wcircle4; wcircle5];
blackwhite = insertShape(blackim,'FilledCircle',wcircle,...
    'Color', 'white');
myxd = linspace(-20,20,1000);
myyd = linspace(30,90,1372);
Igray = uint8(rgb2gray(blackwhite));
image(myxd,myyd,Igray); 
xlabel('Lateral distance [mm]')
ylabel('Axial distance [mm]')
colormap(gray(127))
axis('image')
axis([-20 20 35 90])