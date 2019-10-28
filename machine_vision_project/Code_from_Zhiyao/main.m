%% image reading
% read image1
fileID = fopen('charact1.txt'); 
formatSpec = '%s';
A = fscanf(fileID,formatSpec);
A = reshape(A, [64,64]);
image1 = zeros(size(A));
for i=1:size(A)
    for j=1:size(A)
        if A(i,j)-'A'<0
            image1(i,j)= str2num(A(i,j));
        else
            image1(i,j)=A(i,j)-'A'+10;
        end
    end
end
image1 = double(image1);
imshow(image1);
imhist(image1);
%% thresholding
% 1.display histogram to derive thresholding point
 hist1 = imhist(image1);

image1_thre = imbinarize(image1);

%% segment picture
segment=segment_pick(image1_thre);

%% picture rotate


image1_r90=imagerotate(image1_thre,segment,90);
segment_r90=segment_pick(image1_r90);
image1_r35=imagerotate(image1_r90,segment,35);
subplot(1,3,1)
imshow(image1_thre);
subplot(1,3,2)
imshow(image1_r90);
subplot(1,3,3)
imshow(image1_r35);
%% charactor outline

character=struct('outline',{});
for i=1:size(segment,2)
    character(i).outline=bwperim(segment(i).array,8);
%      subplot(2,size(segment,2),i)
%      imshow(character(i).outline);
%      subplot(2,size(segment,2),6+i)
%      imshow(thining(segment(i).array));
end
%% image2
image2=rgb2gray(image2);
image2_hist=histeq(image2);

Y=dct2(image2_hist); 
[m,n]=size(image2_hist); 
I=zeros(m,n);
%¸ßÆµÆÁ±Î
I(1:m/3,1:n/3)=1; 
Ydct=Y.*I;
%ÄæDCT±ä»»
Y=uint8(idct2(Ydct)); 
subplot(1,2,1),imshow(Y);
Title=('Image Denoising Based on Discrete Cosine Transform');
subplot(1,2,2),imshow(image2_hist)
Title=('plain Image');

