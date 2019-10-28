%% read image2
rgb = imread('charact2.bmp');
if ndims(rgb) == 3
    I = rgb2gray(rgb);
else
    I = rgb;
end

figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(1, 2, 1); imshow(rgb); title('原图');
subplot(1, 2, 2); imshow(I); title('灰度图');
%%
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(1, 2, 1); imshow(I,[]), title('灰度图像')
subplot(1, 2, 2); imshow(gradmag,[]), title('梯度幅值图像')

se = strel('disk', 4);
Io = imopen(I, se);
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);

Ioc = imclose(Io, se);
Ic = imclose(I, se);
figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(2, 2, 1); imshow(I, []); title('灰度图像');
subplot(2, 2, 2); imshow(Io, []); title('开操作图像');
subplot(2, 2, 3); imshow(Ic, []); title('闭操作图像');
subplot(2, 2, 4); imshow(Ioc, []), title('开闭操作');
%%
sigma = 20;
gausFilter = fspecial('gaussian', [10,10], sigma);
gaus= imfilter(Ioc, gausFilter, 'replicate');
c_= imfilter(I, gausFilter, 'replicate');
a = imbinarize(gaus);
b = imbinarize(Ioc);
c = imbinarize(c_);

subplot(3, 1, 1); imshow(a, []); title('gause');
subplot(3, 1, 2); imshow(b, []); title('openclose');
subplot(3, 1, 3); imshow(c, []); title('direct gause');


%%
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(2, 2, 1); imshow(I, []); title('灰度图像');
subplot(2, 2, 2); imshow(Ioc, []); title('开闭操作');
subplot(2, 2, 3); imshow(Iobr, []); title('基于开的重建图像');
subplot(2, 2, 4); imshow(Iobrcbr, []), title('基于闭的重建图像');
%%
fgm = imregionalmax(Iobrcbr);
figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(1, 3, 1); imshow(I, []); title('灰度图像');
subplot(1, 3, 2); imshow(Iobrcbr, []); title('基于重建的开闭操作');
subplot(1, 3, 3); imshow(fgm, []); title('局部极大图像');
histogram(Iobrcbr);
imshow(im2bw(Iobrcbr,0.46));