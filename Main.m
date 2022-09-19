
clear all;
clc;
close all;
tic;
o1='512Lena.bmp';
o2='512Avion.bmp';
o3='512peppers.bmp';
o4='512ttu.bmp';
w1='32_d2.bmp';
w2='32_d1.bmp';
w3='32_d5.bmp';
derece=30;
xx1=5;
yy1=2;
xx2=4;
yy2=3;

[ww PSNR1]=embed(w1,o1,xx1,yy1,xx2,yy2);
imwrite(ww,'watermarkedimage.png');
embedtime=toc;

%%[ JPEG30 JPEG90 JPEG2000_5 JPEG2000_10 SP01 SP002 Gauss001 Gauss003 Med2x2 Med3x3 Butter100_1 Butter100_3 Sharpening02 Sharpening1 blurring02 blurring1 scaling4 scaling025 Cropping25 Cropping50 Lowpass jpeg88 jpeg725 Gauss0004 Gauss0025 Med51 rot inrot]= attacks(ww,derece);
%% attacked images imwrite
tic;
wimage='watermarkedimage.png';
w1='32_d2.bmp';
[NC extractwatermark]=Extract(wimage,w1,xx1,yy1,xx2,yy2);
imwrite(extractwatermark,'extract_watermark.png');
extracttime=toc;
total=embedtime+extracttime;
