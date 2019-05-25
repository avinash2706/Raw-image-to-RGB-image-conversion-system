
clear; close all; clc

raw = imread('raw.tiff');
size(raw)
class(raw)
min(raw,[],'all')
max(raw,[],'all')
figure
imshow(raw); title('raw image');
raw = double(raw);


% Linearize 

b = 2047;
s = 13584;
im_linear = mat2gray(raw,[b s]);
figure
imshow(im_linear); title('linearized');
imwrite(im_linear,'linearized.jpg')



% Visualize the Bayer mosaic


im_zoom=im_linear(1000:1100,1000:1100);
figure
imshow(im_zoom);title('visualizing the Bayer mosaic');
imwrite(im_zoom,'zoomed.jpg')



% Discover the Bayer pattern


top_left = im_linear(1:2:end, 1:2:end);
top_right = im_linear(1:2:end, 2:2:end);
bot_left = im_linear(2:2:end, 1:2:end);
bot_right = im_linear(2:2:end, 2:2:end);
crossavg1 = (top_right+bot_left)/2;
crossavg2 = (top_left+bot_right)/2;

figure
subplot(2,2,1);
imshow(top_left),title('top_left');
subplot(2,2,2);
imshow(top_right),title('top_right');
subplot(2,2,3);
imshow(bot_left),title('bot_left');
subplot(2,2,4);
imshow(bot_right),title('bot_right');

rggb = cat(3,top_left,crossavg1,bot_right);
bggr = cat(3,bot_right,crossavg1,top_left);
grbg = cat(3,top_right,crossavg2,bot_left);
gbrg = cat(3,bot_left,crossavg2,top_right);

figure
subplot(2,2,1);
imshow(rggb),title('rggb');
subplot(2,2,2);
imshow(bggr),title('bggr');
subplot(2,2,3);
imshow(grbg),title('grbg');
subplot(2,2,4);
imshow(gbrg),title('gbrg');

imwrite(rggb,'best_bayer.jpg');



% White balance


red = rggb(:,:,1);
green= rggb(:,:,2);
blue= rggb(:,:,3);

meanred = mean2(red);
meangreen = mean2(green);
meanblue = mean2(blue);

greyred = (meangreen/meanred)*red;
greyblue = (meangreen/meanblue)*blue;
greygreen = green;
im_gw = cat(3,greyred,greygreen,greyblue);


maxred = max(max(red));
maxgreen = max(max(green));
maxblue = max(max(blue));

whitered = (maxgreen/maxred)*red;
whiteblue = (maxgreen/maxblue)*blue;
whitegreen = green;
im_ww = cat(3,whitered,whitegreen,whiteblue);

figure
subplot(2,1,1);
imshow(im_gw),title('grey-world');
subplot(2,1,2);
imshow(im_ww),title('white-world');

imwrite(im_gw,'grey_world.jpg');
imwrite(im_ww,'white_world.jpg');



% Brighten and gamma-correct


grayscale = rgb2gray(im_gw);
alpha = max(max(grayscale));
scale = alpha*im_gw;
figure
imshow(scale);
imwrite(scale,'brightened.jpg');

gamma = (scale).^(1/2.2);
figure
imshow(gamma);
imwrite(gamma,'final.jpg');
imwrite(gamma,'final.png');
imwrite(gamma,'compressed.jpg','quality',30);
