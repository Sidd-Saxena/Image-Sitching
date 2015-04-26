% % %%feat_desc function is used to identify the feature descriptors of the
% % %%selected feature points from the anms function
% 
% function p = feat_desc(im, y, x)
% % Frequently used constants
% imgsize = size(im);
% nr = imgsize(1);
% nc = imgsize(2);
% 
% %% Gaussian pre-filtering
% h = fspecial('gaussian', [5 5], 2);
% im = imfilter(im, h, 'symmetric', 'same');
% 
% %% Create 40-by-40 window and sub-sample
% % Get the inds of corners
% inds = sub2ind(size(im), y, x);
% 
% % Get matrices of subs and locate corners
% [cols, rows] = meshgrid(1:size(im,2), 1:size(im,1));
% corner_cols = cols(inds);  % n-by-1
% corner_rows = rows(inds);
% 
% % JUST GET THE INDS AND STORE THEM (LINEARIZED)
% 
% rows_list = zeros(64,length(y));
% cols_list = zeros(64,length(y));
% count = 0;
% for i = -15:5:20
%     for j = -15:5:20
%         count = count + 1;
%         rows_tmp = corner_rows + i;  % n-by-1
%         cols_tmp = corner_cols + j;
%         
%         % MAY JUST THROW OUT THE PIXELS TOO CLOSE TO BOUNDRY
%         
%         % Deal with points outside boundaries
%         rows_tmp(rows_tmp<1) = 1 - rows_tmp(rows_tmp<1);
%         rows_tmp(rows_tmp>nr) = 2*nr+1 - rows_tmp(rows_tmp>nr);
%         
%         cols_tmp(cols_tmp<1) = 1 - cols_tmp(cols_tmp<1);
%         cols_tmp(cols_tmp>nc) = 2*nc+1 - cols_tmp(cols_tmp>nc);
%  
%         % Store the subs
%         rows_list(count,:) = rows_tmp';
%         cols_list(count,:) = cols_tmp';
%     end
% end
% 
% % Get the descripters
% p = [];
% for count = 1:length(y)
%     indices = sub2ind(imgsize, rows_list(:,count), cols_list(:,count));
%     % Normalization: 0-mean, 1-std
%     value = double( im(indices) );
%     value = value - mean(value);
%     value = value/std(value);
%     
%     if mean(value) > 1e-10
%         disp('MEAN of descripters is not ZERO');
%         return;
%     end
%     if std(value)-1 > 1e-10
%         disp('STD of descripters is not ONE');
%         return;
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     p = cat(2, p, value);
% end
function [m] = feat_match(p1,p2)
    %Descriptor Matching
    thresh=0.75;
    m=-1*ones(size(p1,2),1);
    for i=1:size(p1,2)
        tmp=bsxfun(@minus,p1(:,i),p2);
        tmp=sum(tmp.*tmp);
        [abc idx]=sort(tmp,2);
        if (abc(1)/abc(2)<thresh)
            m(i)=idx(1);
        else
            m(i)=-1;
        end
    end
    %mmm=sum(m~=-1)
end


