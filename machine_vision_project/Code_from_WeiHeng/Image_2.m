Image=imread('charact2.bmp');
subplot(3,4,1);
imshow(Image);
%read the file of the image.
image2=rgb2gray(Image);
%get the gray level image of the image
subplot(3,4,2);
imshow(image2);
imcontrast
%%
se = strel('disk', 3);
Io = imopen(image2, se);
% Ioc = imclose(Io, se);
imshow(Io);
imshow(imbinarize(Io,0.425));

%%
%sharpen the edge of the image and apply the gaussfilter to the image.
sharp_image=imsharpen(image2,'Radius',2,'Amount',1);
subplot(3,4,3);
imshow(sharp_image);
smooth_image1 = imgaussfilt(sharp_image,2.2);
subplot(3,4,4);
imshow(smooth_image1);
smooth_image2 = imbilatfilt(smooth_image1,200);
subplot(3,4,4);
imshow(smooth_image2);
binary_image=imbinarize(smooth_image2,0.46);
subplot(3,4,5);
imshow(binary_image);



%eliminate the noise of the picture
CC=bwconncomp(binary_image);
numPixels = cellfun(@numel,CC.PixelIdxList);%the pixels in each region
[big_arrange,idx]=sort(numPixels);
meanPixels= mean(big_arrange);
for i=1:size(big_arrange,2)
    if(big_arrange(i)<meanPixels)
        binary_image(CC.PixelIdxList{idx(i)}) = 0;
    end
end
subplot(3,4,6);
imshow(binary_image);

%%
for i=1:size(region,1)
    subplot(2,5,i); imshow(region(i).Image);
      
end
%%
%segment the image
region=regionprops(binary_image,'Image','BoundingBox');
[width,length]=arrayfun(@(x) size(x.Image),region);
length_mean=mean(length);
width_mean=mean(width);
Rank=zeros(11,1);
for i=1:size(region,1)
    if(size(region(i).Image,2)>1.2*width_mean)
        for k=round(length(i)/2)-5:round(length(i)/2)+5
            Rank(k-round(length(i)/2)+6)=size(find(region(i).Image(:,k)==1),1);
        end
        [a,b]=min(Rank);
        b=b+round(length(i)/2)-6;
        region(i).Image(:,b)=0;
    end
end
segment_image=zeros(size(binary_image,1),size(binary_image,2));
for i=1:size(region,1)
    for n=round(region(i).BoundingBox(1)):round(region(i).BoundingBox(1))+region(i).BoundingBox(3)-1
        for m=round(region(i).BoundingBox(2)):round(region(i).BoundingBox(2))+region(i).BoundingBox(4)-1
            segment_image(m,n)=region(i).Image(m-round(region(i).BoundingBox(2))+1,n-round(region(i).BoundingBox(1))+1);
            %match the centroid of the original image and the rotated image
        end
    end
end
segment_image=logical(segment_image);
subplot(3,4,7);
imshow(segment_image);
%%


%rotate the image by 90 degree counterclockwise
figure(2)
region=regionprops(segment_image,'Image','Centroid');
rotate_image1=zeros(size(segment_image,1),size(segment_image,2));
for k=1:13
    angle=-90;
    subplot(4,4,k);
    rotateimage=imrotate(region(k).Image,angle,'bilinear','loose');
    
    crop_image=regionprops(rotateimage,'Image');
    info_rotate=regionprops(crop_image.Image,'Centroid');
    imshow(crop_image.Image);
    %get the centroid of the rotated image
    for n=-(round(info_rotate.Centroid(:,1)-1)):size(crop_image.Image,2)-round(info_rotate.Centroid(:,1))
        for m=-(round(info_rotate.Centroid(:,2)-1)):size(crop_image.Image,1)-round(info_rotate.Centroid(:,2))
            if(rotate_image1(m+round(region(k).Centroid(2)),n+round(region(k).Centroid(1)))~=1)
                rotate_image1(m+round(region(k).Centroid(2)),n+round(region(k).Centroid(1)))=crop_image.Image(round(info_rotate.Centroid(:,2))+m,round(info_rotate.Centroid(:,1))+n);
            end
            %match the centroid of the original image and the rotated image
        end
    end
end
figure(1)
subplot(3,4,8);
imshow(rotate_image1);%show the image of rotate 90 degree counterclockwise



%rotate the image by 35 degree clockwise
figure(3)
region=regionprops(segment_image,'Image','Centroid');
rotate_image1=zeros(size(segment_image,1),size(segment_image,2));
for k=1:13
    angle=35;
    subplot(4,4,k);
    rotateimage=imrotate(region(k).Image,angle,'bilinear','loose');
    crop_image=regionprops(rotateimage,'Image');
    info_rotate=regionprops(crop_image.Image,'Centroid');
    imshow(crop_image.Image);
    %get the centroid of the rotated image
    for n=-(round(info_rotate.Centroid(:,1)-1)):size(crop_image.Image,2)-round(info_rotate.Centroid(:,1))
        for m=-(round(info_rotate.Centroid(:,2)-1)):size(crop_image.Image,1)-round(info_rotate.Centroid(:,2))
            if(rotate_image1(m+round(region(k).Centroid(2)),n+round(region(k).Centroid(1)))~=1)
                rotate_image1(m+round(region(k).Centroid(2)),n+round(region(k).Centroid(1)))=crop_image.Image(round(info_rotate.Centroid(:,2))+m,round(info_rotate.Centroid(:,1))+n);
            end
            %match the centroid of the original image and the rotated image
        end
    end
end
figure(1)
subplot(3,4,9);
imshow(rotate_image1);%show the image of rotate by 35 degree clockwise



%show the outline of the image 
outline_image=segment_image;
for l=1:size(outline_image,1)
    for m=1:size(outline_image,2)
        if(l-1>1&&m-1>1)
            if(segment_image(l,m-1)==1&&segment_image(l-1,m)==1&&segment_image(l+1,m)==1&&segment_image(l,m+1)==1)
                outline_image(l,m)=0;
            end
        end
    end
end
 subplot(3,4,10);
 imshow(outline_image);
 
 
 
 %show the image in one-pixel thin
 onepixel_image1=segment_image;
 subplot(3,4,11);
 imshow(bwmorph(segment_image,'thin',inf));
 
 
 
 %Scale and display the characters
 scale=cat(1,size(region(1).Image),size(region(2).Image),size(region(3).Image),size(region(4).Image),size(region(5).Image),size(region(6).Image));
 scalemax=max(scale);     
 str= struct('a',{},'b',{});
 for i=1:13
     str(i).a=zeros(scalemax(1),size(region(i).Image,2));
     str(i).a(1:size(region(i).Image,1),1:size(region(i).Image,2))=region(i).Image;
 end
 str(1).b=str(4).a;str(2).b=str(6).a;str(3).b=str(8).a;
 str(4).b=str(1).a;str(5).b=str(2).a;str(6).b=str(3).a;
 str(7).b=str(5).a;str(8).b=str(7).a;str(9).b=str(9).a;
 str(10).b=str(10).a;str(11).b=str(11).a;str(12).b=str(12).a;
 str(13).b=str(13).a;
 scale_image=zeros(scalemax(1),1);
 for i=1:size(str,2)
      scale_image=cat(2,scale_image,zeros(scalemax(1),1),str(i).b);
 end
subplot(3,4,12);
imshow(scale_image); 