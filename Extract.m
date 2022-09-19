function [NC extractwatermark]=Extract(watermarkedimage,w1,xx1,yy1,xx2,yy2)
watermark1=imread(w1);
[wm]=double(watermark1);
RGB=imread(watermarkedimage); 
or_dou= double(rgb2ycbcr(RGB)); 
Mm=size(wm,1);	                %Height
Nm=size(wm,2);	                %Width

rr=size(RGB,1);	                %Height
cc=size(RGB,2);

R=or_dou(:,:,1);
G=or_dou(:,:,2);
B=or_dou(:,:,3);
tamresim=[];
tamresim(1:rr,1:cc)=G;

pfilter = 'pkva' ;              % Pyramidal filter
dfilter = 'pkva' ;              % Directional filter
coeffs_or = pdfbdec( double(tamresim), pfilter, dfilter,1 );
t2=coeffs_or{1};

 watermarked_image=double(t2);
blocksize=8;    % set the size of the block in cover to be used for each bit in watermark
% determine size of watermarked image
Mw=size(watermarked_image,1);	        %Height
Nw=size(watermarked_image,2);	        %Width

% determine maximum message size based on cover object, and blocksize
max_message=3*Mw*Nw/(blocksize^2);

x=1;
y=1;

for (kk = 1:3:max_message)
dct_block = dct2(watermarked_image(y:y+blocksize-1,x:x+blocksize-1));

message_vector(kk)=  (dct_block(xx1,yy1))*log(dct_block(1,1)+1);
message_vector(kk+1)=(dct_block(xx2,yy2))*log(dct_block(1,1)+1);
message_vector(kk+2)=(dct_block(yy2,xx2))*log(dct_block(1,1)+1);
  if (x+blocksize) >= Nw
        x=1;
        y=y+blocksize;
    else
        x=x+blocksize;
    end
    
end
d1=reshape(message_vector(1:Mm*Nm*3),Mm,Nm,3);




extractwatermark(:,:,1)=arnold_rec(d1(:,:,1),10,10,50);
extractwatermark(:,:,2)=arnold_rec(d1(:,:,2),10,10,50);
extractwatermark(:,:,3)=arnold_rec(d1(:,:,3),10,10,50);

kont=double(extractwatermark);

 NC=NC_calc(kont,wm);
end