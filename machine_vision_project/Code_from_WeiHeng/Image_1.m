fid=fopen('charact1.txt');
%open the file in the folder
[Image,COUNT]=fscanf(fid,'%s',[64,64]);
%create an matrix which contains the data of the file.
fclose(fid);
table = [zeros(1,'0'-1) , 0:9 , zeros(1,'A'-'9'-1) , ('A':'Z')-'A' + 10]; 
% match the A-Z to the number 10-36 to transform the char data to number.
image1=table(Image');
subplot(3,4,1);
imshow(image1,[0,31]);
%show the answer to the question, produce the original image
binary_image=imbinarize(image1);
subplot(3,4,2);
imshow(binary_image);
%%
s=regionprops(binary_image,'Image','BoundingBox','Centroid');
%find the bounding of characters to separate the characters and the centroid of characters



%plot the separate image
figure(2)
for k=1:6
    subplot(2,3,k);
    imshow(s(k).Image);
end



%draw the bounding of the separate image
figure(1)
subplot(3,4,3);
imshow(binary_image);
hold on 
for j = 1 : 6
     BB = s(j).BoundingBox;
     rectangle('Position',[BB(1),BB(2),BB(3),BB(4)],'EdgeColor','r','LineWidth',1);   
end
hold off



%plot the centroid of each character
centroids=cat(1,s.Centroid);
subplot(3,4,4);
imshow(binary_image);
hold on 
plot(centroids(:,1),centroids(:,2),'b+');
hold off



%rotate the image by 90 degree counterclockwise
figure(3)
rotate_image1=zeros(size(binary_image,1));
for k=1:6
    angle=-90;
    subplot(2,3,k);
    rotateimage=imrotate(s(k).Image,angle,'bilinear','loose');
    crop_image=regionprops(rotateimage,'Image');
    info_rotate=regionprops(crop_image.Image,'Centroid');
    imshow(crop_image.Image);
    %get the centroid of the rotated image
    for n=-(round(info_rotate.Centroid(:,1)-1)):size(crop_image.Image,2)-round(info_rotate.Centroid(:,1))
        for m=-(round(info_rotate.Centroid(:,2)-1)):size(crop_image.Image,1)-round(info_rotate.Centroid(:,2))
            rotate_image1(m+round(centroids(k,2)),n+round(centroids(k,1)))=crop_image.Image(round(info_rotate.Centroid(:,2))+m,round(info_rotate.Centroid(:,1))+n);
            %match the centroid of the original image and the rotated image
        end
    end
end
figure(1)
subplot(3,4,5);
imshow(rotate_image1);%show the image of rotate 90 degree counterclockwise



%rotate the image by 35 degree clockwise
figure(4)
rotate_image2=zeros(size(binary_image,1));
for k=1:6
    angle=35;
    subplot(2,3,k);
    rotateimage=imrotate(s(k).Image,angle,'bilinear','loose');
    %rotate the crop image with specific angle.
    crop_image=regionprops(rotateimage,'Image');
    info_rotate=regionprops(crop_image.Image,'Centroid');
    imshow(crop_image.Image);
    %get the centroid of the rotated image
    rotate_centroids=cat(1,info_rotate.Centroid);
    for n=-(round(info_rotate.Centroid(:,2)-1)):size(crop_image.Image,1)-round(info_rotate.Centroid(:,2))
        for m=-(round(info_rotate.Centroid(:,1)-1)):size(crop_image.Image,2)-round(info_rotate.Centroid(:,1))
            rotate_image2(n+round(centroids(k,2)),m+round(centroids(k,1)))=crop_image.Image(round(info_rotate.Centroid(:,2))+n,round(info_rotate.Centroid(:,1))+m);
            %match the centroid of the original image and the rotated image
        end
    end
end
figure(1)
subplot(3,4,6);
imshow(rotate_image2);%show the image of rotate by 35 degree clockwise



%show the outline of the image 
outline_image=binary_image;
for l=1:size(outline_image,1)
    for m=1:size(outline_image,2)
        if(l-1>1&&m-1>1)
            if(binary_image(l,m-1)==1&&binary_image(l-1,m)==1&&binary_image(l+1,m)==1&&binary_image(l,m+1)==1)
                outline_image(l,m)=0;
            end
        end
    end
end
 subplot(3,4,7);
 imshow(outline_image);
 
 
 
 %show the image in one-pixel thin
 onepixel_image1=binary_image;
 subplot(3,4,8);
 imshow(bwmorph(binary_image,'thin',inf));


 
 %Scale and display the characters
 scale=cat(1,size(s(1).Image),size(s(2).Image),size(s(3).Image),size(s(4).Image),size(s(5).Image),size(s(6).Image));
 scalemax=max(scale);     
 str= struct('a',{});
 for i=1:6
     str(i).a=zeros(scalemax(1),size(s(i).Image,2));
     str(i).a(1:size(s(i).Image,1),1:size(s(i).Image,2))=s(i).Image;
 end
 scale_image=zeros(scalemax(1),1);
 for i=1:size(str,2)
      scale_image=cat(2,scale_image,zeros(scalemax(1),1),str(i).a);
 end
subplot(3,4,[10 11]);
imshow(scale_image);