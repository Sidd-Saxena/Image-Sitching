%the following function performs the RANSAC between the two images 
%we randomly select 4 points in the images and perform homography on it
%and check wheather which sets of points provide the maximum no of inliers
%within the threshold.
function [H_temp,inlier_ind] = ransac_est_homography(y1, x1, y2, x2, thresh)

%calculating the length of the matrix
no = length(y1);

%setting the maxi um number of iteration to be performed on RANSAC
maxIteration = factorial(no)/factorial(no-4)/24; 
min_inliers = round(0.2*no);

%creating a blank matrix for the inliers
inlier_ind = [];

iter = 0;
while iter < maxIteration
    iter = iter + 1;
    
    % Randomly sample 4 points
    rand_ind = randperm(no, 4)';
    
    y1_final = y1(rand_ind);
    x1_final = x1(rand_ind);
    y2_final = y2(rand_ind);
    x2_final = x2(rand_ind);

 %Calculating the homography matrix for these 4 randomly selected points
  H_temp = est_homography(x1_final, y1_final, x2_final, y2_final);
    
%retriving the homography points for the feature points in image 2 to
  %image 1 using inverse homography functions
    [x1_homo y1_final] = apply_homography(H_temp, x2, y2);
    
 %Calculating the eucledian distance between the two obtained points
    Eucl_dist = sqrt((y1_final-y1).^2 + (x1_homo-x1).^2);
    
%checking if the euclidean distanceisless than the threshold
   sum_dist=sum(Eucl_dist<thresh);
    if sum_dist<min_inliers
        continue; 
    elseif sum_dist > size(inlier_ind,1)
        inlier_ind = find(Eucl_dist<thresh);
        length(inlier_ind)
    end         
end
% Calculating the final homography
H_temp = est_homography(x1(inlier_ind), y1(inlier_ind), x2(inlier_ind), y2(inlier_ind));
end
 
 

