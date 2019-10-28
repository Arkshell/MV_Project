rgb = imread('charact2.bmp');
if ndims(rgb) == 3
    I = rgb2gray(rgb);
else
    I = rgb;
end
 
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
 
L = watershed(gradmag);
Lrgb = label2rgb(L);
 
se = strel('disk', 20);
Io = imopen(I, se);
 
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
 
Ioc = imclose(Io, se);
 
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
 
fgm = imregionalmax(Iobrcbr);
 
It1 = rgb(:, :, 1);
It2 = rgb(:, :, 2);
It3 = rgb(:, :, 3);
It1(fgm) = 255; It2(fgm) = 0; It3(fgm) = 0;
I2 = cat(3, It1, It2, It3);
 
se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);
 
fgm4 = bwareaopen(fgm3, 20);
It1 = rgb(:, :, 1);
It2 = rgb(:, :, 2);
It3 = rgb(:, :, 3);
It1(fgm4) = 255; It2(fgm4) = 0; It3(fgm4) = 0;
I3 = cat(3, It1, It2, It3);
 
bw = im2bw(Iobrcbr, graythresh(Iobrcbr));
 
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
 
gradmag2 = imimposemin(gradmag, bgm | fgm4);
L = watershed(gradmag2);
 
It1 = rgb(:, :, 1);
It2 = rgb(:, :, 2);
It3 = rgb(:, :, 3);
fgm5 = imdilate(L == 0, ones(3, 3)) | bgm | fgm4;
It1(fgm5) = 255; It2(fgm5) = 0; It3(fgm5) = 0;
I4 = cat(3, It1, It2, It3);
 
Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');

