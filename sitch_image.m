%%this function is used in order to obtain sitched image
%we sitch two images together

function final_image = sitch_image(I1,I2)

%converting the two images into grayscale
Ig1=rgb2gray(I1);
Ig2=rgb2gray(I2);

%finding the corner points in the image
Cb1=cornermetric(Ig1);
Cb2=cornermetric(Ig2);

% %avoiding the corner points in both the images
Cb1(1,1) = 0;
Cb1(end,end) = 0;
Cb2(1,1) = 0;
Cb2(end,end) = 0;

disp('anms done')

%applying adaptive non maximum supression
[y1 x1 rmax1]=anms(Cb1,50);
[y2 x2 rmax2]=anms(Cb2,50);

%displaying the two images with the selected points in them
subplot(1,2,1);
imagesc(I1);
hold all
plot(x1,y1,'or','MarkerSize',2,'MarkerFaceColor','r');

subplot(1,2,2);
imagesc(I2);
hold all
plot(x2,y2,'or','MarkerSize',2,'MarkerFaceColor','r');

disp('fearture descriptor done');

%calculating the feature descriptor in both the images
p1=feat_desc(Ig1,y1,x1);
p2=feat_desc(Ig2,y2,x2);

disp('feature matching done');
%matching the feature points in both the images
m=feat_match(p1,p2);

%selecting valid points
m1 = find(m~=-1);
m2=m(m1);

%final points in both the images
xfin2=x2(m2);
yfin2=y2(m2);
xfin1=x1(m1);
yfin1=y1(m1);

%displaying valid points in bth images
subplot(1,2,1);
imagesc(I1);
hold on;
plot(x1(m1), y1(m1),'.r');

subplot(1,2,2);
imagesc(I2);
hold on;
plot(x2(m2), y2(m2),'.r');

disp('applying ransac');
 
%appyling the RANSAC on both the images 
thresh=0.5;
[H inliers_idx]=ransac_est_homography(yfin1,xfin1,yfin2,xfin2,thresh);

%applying the homography to the corner points in image 2
    Ylen=size(Ig2,1);
    Xlen=size(Ig2,2);
    
    X=[1;Xlen;1;Xlen];
    Y=[1;1;Ylen;Ylen];
 
    [tx ty]=apply_homography(H,X,Y);

    % creating a bin of the obtained second image
    mintx=round(min(tx));
    maxtx=round(max(tx));
    minty=round(min(ty));
    maxty=round(max(ty));
   
    %array of all the co ordinatines of image 2
    [Xarr Yarr]=meshgrid(mintx:maxtx,minty:maxty);
    
    %reshaping it in order to apply inverse matrix
    Xarr=reshape(Xarr,[size(Xarr,1)*size(Xarr,2),1]);
    Yarr=reshape(Yarr,[size(Yarr,1)*size(Yarr,2),1]);

    %calculating inverse homography inorder to obtain the co ordinates of
    %second image into first
      Hinv=H^-1;    
      [ntx nty]=apply_homography(Hinv,Xarr,Yarr);

      
   % Creating a new image  for transformed second image
    minx=min(mintx,1);
    miny=min(minty,1);
    
    maxx=max(maxtx,size(I1,2));
    maxy=max(maxty,size(I1,1));
    
    %final canvas of the sitched image
   I=zeros(maxy-miny+1,maxx-minx+1,3);

    if (minx>=1)
        stx=1;
    else
        stx=1-minx;
    end
    if (miny>=1)
        sty=1;
    else
        sty=1-miny;
    end
    
    %copying the first image into the canvas directly
    I(sty:sty+size(I1,1)-1,stx:stx+size(I1,2)-1,:)=I1(:,:,:);
   
    %finding the offset in the image
    if (mintx<1)
       offx=1-mintx; 
    else
        offx=0;
    end
    if (minty<1)
       offy=1-minty; 
    else
        offy=0;
    end
    
    %%finding the valid homographed points in image2
    ntx=round(ntx);
    nty=round(nty);
    
    idx=(ntx>=1 & ntx<=size(I2,2) & nty>=1 & nty<=size(I2,1));
    
    ntx=ntx(idx);
    nty=nty(idx);
    
    Yarr=Yarr(idx);
    Xarr=Xarr(idx);
    
    %copying the second image into the canvas overlaping the first one
    for i=1:size(Xarr,1)
        I(Yarr(i)+offy,Xarr(i)+offx,:)=I2(nty(i),ntx(i),:);
    end
    final_image=uint8(I);
    disp('sitching done')
end

 