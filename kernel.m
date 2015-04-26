%this function is used to convolving the guassian filter with the image

function p=kernel(im,G)
    %performing convolution
    im=conv2(double(im),G,'same');
    p=reshape(im(1:5:size(im,1),1:5:size(im,2)),[64,1]);
    %setting the mean to zero and standard deviation to 1
    p=(p-mean(p))/std(p,1,1);
end