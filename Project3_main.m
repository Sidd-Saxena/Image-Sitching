
    %                                                         Project 3
%Image Mosaicing (Sitching of images)

%Name: Siddharth Saxena
%Penn Id :27304651

%Note : the code has been written in MATLAB R2013a. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
clear all
clc

%reading the two images
I1=imread('Detkin1.jpg');
I2=imread('Detkin2.jpg');
I3=imread('Detkin3.jpg');
I4=imread('Detkin4.jpg');


%Creating the image cell consisting of all the images to be sitched
Img_cell = cell(4,1);
Img_cell{1} = I1;
Img_cell{2} = I2;
Img_cell{3} = I3;
Img_cell{4} = I4;


%Creating a mosaic of all the images 
img_mosaic = mymosaic(Img_cell);

%Displaying the mosaic image
figure;
imagesc((img_mosaic));

