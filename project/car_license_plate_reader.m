clc;
close all;
clear all;

%.................................
f=imread('carplate1.jpg');
f=imresize(f,[400 NaN]);                   %%image loading unit
%no of rows =400 
imshow(f);
g=rgb2gray(f);
g=medfilt2(g,[3 3]);
figure (10);
imshow(g);
%2d median filter
%reduce salt n pepper noise
%the median value in the 3-by-3 neighborhood

%**********************************
stre=strel('disk',1);    %strucruring element
%structuring element of disk shape(matrix of 1) with radius 1

gi=imdilate(g,stre);figure(9); subplot(3,1,1); imshow(gi);
%fill gaps

ge=imerode(g,stre);   %%%% morphological image processing
%shrink or eliminate irrelevant details
figure(9); subplot(3,1,2); imshow(ge);

gdiff=imsubtract(gi,ge);
figure(9); subplot(3,1,3); imshow(gdiff);
gdiff=mat2gray(gdiff);
%amin and amax as min and mx value of image


gdiff=conv2(gdiff,[1 1;1 1]); %convolution of matrix   %brighten(doubt)

gdiff=imadjust(gdiff,[0.5 0.7],[0 1],.1);
%maps intensity from .5-.7 to 0-1 with curve of gamma .1

B=logical(gdiff);%so that size works
[a1 b1]=size(B);
figure(2)
imshow(B)

er=imerode(B,strel('line',100,0));  
%img , structuring element
%removing usless horizontal line
figure(3)
imshow(er)
out1=imsubtract(B,er);

F=imfill(out1,'holes');      %filling the object
figure(11);
subplot(1,2,1);
imshow(out1);
subplot(1,2,2);
imshow(F);
H=bwmorph(F,'thin',1); 
%morphological operation on binary image
%thin it once  %to remove useless thin lines
H=imerode(H,strel('line',3,90));
%structuring element of lenf=gth 3 and degree 90
figure(4)
imshow(H)


final=bwareaopen(H,floor((a1/15)*(b1/15)));  
%remove objects that hav fewer pixels than second argument
%floor rounds the value

%edit here
figure(5)
imshow(final)

Iprops=regionprops(final,'BoundingBox','Image');
hold on                            %add to the exsisting graph
for n=1:size(Iprops,1)               %sixe of iprops in first dimension
    rectangle('Position',Iprops(n).BoundingBox,'EdgeColor','g','LineWidth',2); 
end
hold off                            %reset axis properties