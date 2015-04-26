%feat_match provides the index of the matched feature points of the two
%%images using the feature descriptors of the two points by calculating SSD
       
function [m] = feat_match(p1,p2)
    %Descriptor Matching
     % setting up an random threshold value as per the image
     thresh=0.75;
    
     m=-1*ones(size(p1,2),1);
     for i=1:size(p1,2)
 %subtracting the feature descriptor of one feature point in image one
%     %with all the feature points in image 2
        tmp=bsxfun(@minus,p1(:,i),p2);
        tmp=sum(tmp.*tmp);
        %sorting the ssd matrix in descending order
        [abc idx]=sort(tmp,2);
        if (abc(1)/abc(2)<thresh)
            m(i)=idx(1);
        else
            %selecting values which are less than the threshold value set and setting remaining values to -1;
            m(i)=-1;
        end
    end
    %mmm=sum(m~=-1)
end

