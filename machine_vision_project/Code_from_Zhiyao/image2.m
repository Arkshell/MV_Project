%% read image2
rgb = imread('charact2.bmp');
if ndims(rgb) == 3
    I = rgb2gray(rgb);
else
    I = rgb;
end

figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(1, 2, 1); imshow(rgb); title('ԭͼ');
subplot(1, 2, 2); imshow(I); title('�Ҷ�ͼ');
%%
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(1, 2, 1); imshow(I,[]), title('�Ҷ�ͼ��')
subplot(1, 2, 2); imshow(gradmag,[]), title('�ݶȷ�ֵͼ��')

se = strel('disk', 4);
Io = imopen(I, se);
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);

Ioc = imclose(Io, se);
Ic = imclose(I, se);
figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(2, 2, 1); imshow(I, []); title('�Ҷ�ͼ��');
subplot(2, 2, 2); imshow(Io, []); title('������ͼ��');
subplot(2, 2, 3); imshow(Ic, []); title('�ղ���ͼ��');
subplot(2, 2, 4); imshow(Ioc, []), title('���ղ���');
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
subplot(2, 2, 1); imshow(I, []); title('�Ҷ�ͼ��');
subplot(2, 2, 2); imshow(Ioc, []); title('���ղ���');
subplot(2, 2, 3); imshow(Iobr, []); title('���ڿ����ؽ�ͼ��');
subplot(2, 2, 4); imshow(Iobrcbr, []), title('���ڱյ��ؽ�ͼ��');
%%
fgm = imregionalmax(Iobrcbr);
figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(1, 3, 1); imshow(I, []); title('�Ҷ�ͼ��');
subplot(1, 3, 2); imshow(Iobrcbr, []); title('�����ؽ��Ŀ��ղ���');
subplot(1, 3, 3); imshow(fgm, []); title('�ֲ�����ͼ��');
histogram(Iobrcbr);
imshow(im2bw(Iobrcbr,0.46));