
    %Overall Mosaicing Function
function img_mosaic = mymosaic(img_input)
%calculating the total no of images in the cell
    num=numel(img_input);
    %selecting the center image as the refrence image
    st=ceil(num/2);
    img_mosaic=img_input{st};
    %sitching the images on the right side
    for i=st+1:num
        img_mosaic=sitch_image(img_mosaic,img_input{i});
    end
     %sitching the images on the left side
    for i=st-1:-1:1
        img_mosaic=sitch_image(img_mosaic,img_input{i});
    end
end