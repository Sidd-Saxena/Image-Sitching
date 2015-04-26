
%the anms function performs the adaptive non maximum supression
%%we calculate the selected maximum no of feature points in the image 

function [y x rmax] = anms(cimg, max_pts)
    %Adaptive Non-Maximal Suppression
    C=double(imregionalmax(cimg));
    
    cimg=C.*cimg;
    corners=find(cimg);
   %calculating the co ordinates of feature points of both the images
    [y x]=ind2sub(size(cimg),corners);
    
    %initialization the distance to infinity
    dist=inf*ones(size(y,1),1);
    
    
    for i=1:size(y,1)
        for j=1:size(y,1)
            if (cimg(y(j),x(j))>cimg(y(i),x(i)))
                tmp=(y(i)-y(j))*(y(i)-y(j)) + (x(i)-x(j))*(x(i)-x(j));
                if (tmp<dist(i))
                    dist(i)=tmp;
                end
            end
        end
    end
    
    %sorting the distances in descending order
    [abc idx]=sort(dist,'descend');
    
    y=y(idx);
    x=x(idx);
    
    %calculating the co ordinates of the selected feature points
    y=y(1:max_pts);
    x=x(1:max_pts);
    
    %calculating the maximum radial distance
    rmax=sqrt(abc(max_pts));
end






