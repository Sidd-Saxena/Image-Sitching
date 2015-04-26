%%this function is used to calculate the image descriptor for all the
%%feature points calculated by the anms function

function [p] = feat_desc(im, y, x)
    %Descriptor Computation
    im=padarray(im,[20 20],'both');
    p=zeros(64,size(y,1));
    y=y+20;
    x=x+20;
    
    %implementing guassian smoothing
    a=0.6;
    gx=[(0.25-a/2) 0.25 a 0.25 (0.25-a/2)];
    gy=gx';
    G=conv2(gx,gy);
    
    %finding the image descriptor for all the points in the image
    for i=1:size(y,1)
        p(:,i)=kernel(im((y(i)-20):(y(i)+19),(x(i)-20):(x(i)+19)),G);
    end
end