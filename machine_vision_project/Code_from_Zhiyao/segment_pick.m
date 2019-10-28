function segment=segment_pick(image)
%% edge detection, get[row_list,column_list]
row_list=[1];
column_list=[1];
for i=2:size(image,1)-1
    % i is the number of rolls of image1

    if (sum(image(i,:))==0 && sum(image(i+1,:)) ~=0)||(sum(image(i,:))==0 && sum(image(i-1,:))~=0)
    row_list = [row_list,i];
    end
end

for j=2:size(image,2)-1
    % j is the number of rolls of image1

    if (sum(image(:,j))==0 && sum(image(:,j+1)) ~=0)||(sum(image(:,j))==0 && sum(image(:,j-1))~=0)
    column_list = [column_list,j];
    end
end
row_list=unique([row_list,size(image,1)]);
column_list=unique([column_list,size(image,2)]);

%% sub-pictiure pickout
segment = struct('array',{},'row',{ },'column',{});
count=1;
for i=1:length(row_list)-1
    for j=1:length(column_list)-1
        if (row_list(i)+1)<=(row_list(i+1)-1) || (column_list(j)+1)<=(column_list(j+1)-1)
        temp = image(row_list(i)+1:row_list(i+1)-1,column_list(j)+1:column_list(j+1)-1);
              if length(find(temp==0))~=size(temp,1)*size(temp,2)
            segment(count).array=temp;
            segment(count).row=[row_list(i)+1,row_list(i+1)-1];
            segment(count).column=[column_list(j)+1,column_list(j+1)-1];
            count=count+1;
              end
        end
    end
end

end