function [ww PSNR1]=embed(d1,o1,xx1,yy1,xx2,yy2)
or=imread(o1);
watermark1=imread(d1);
[wm]=double(watermark1);


watermark2(:,:,1)=arnold(wm(:,:,1),10,10,50);
watermark2(:,:,2)=arnold(wm(:,:,2),10,10,50);
watermark2(:,:,3)=arnold(wm(:,:,3),10,10,50);
watermark=watermark2; 


RGB=or; 
or_dou=double(rgb2ycbcr(RGB)); 
R=or_dou(:,:,1);
G=or_dou(:,:,2);
B=or_dou(:,:,3);
tamresim=[];
tamresim(1:512,1:512)=G;
pfilter = 'pkva' ;              % Pyramidal filter
dfilter = 'pkva' ;              % Directional filter
coeffs_or = pdfbdec( double(tamresim), pfilter, dfilter,1 );
t2=coeffs_or{1};





cover_object=t2;
blocksize=8;    % set the size of the block in cover to be used for each bit in watermark
Mc=size(cover_object(:,:,1),1);	        %Height
Nc=size(cover_object(:,:,1),2);	        %Width
max_message=3*Mc*Nc/(blocksize^2);
message=double(watermark);
message = double(message);
Mm=size(message,1);	                %Height
Nm=size(message,2);	                %Width

% reshape the message to a vector
message=round(reshape(message,Mm*Nm*3,1));

% check that the message isn't too large for cover
if (length(message) > max_message)
    error('Message too large to fit in Cover Object')
end


% pad the message out to the maximum message size with ones
message_pad=ones(1,length(message));
message_pad(1:length(message))=message;

% generate shell of watermarked image
watermarked_image=cover_object;



x=1;
y=1;

for (kk = 1:3:length(message_pad))

    % transform block using DCT

 dct_block = dct2(cover_object(y:y+blocksize-1,x:x+blocksize-1));

  dct_block(xx1,yy1)=message_pad(kk)/log(dct_block(1,1)+1);
  dct_block(xx2,yy2)=message_pad(kk+1)/log(dct_block(1,1)+1);
  dct_block(yy2,xx2)=message_pad(kk+2)/log(dct_block(1,1)+1);


   watermarked_image(y:y+blocksize-1,x:x+blocksize-1)= idct2(dct_block);  
 
    
    % move on to next block. At and of row move to next row
    if (x+blocksize) >= Nc
        x=1;
        y=y+blocksize;
    else
        x=x+blocksize;
    end
   
end
 dr=watermarked_image;







coeffs_or{1}=dr;
imrec_damgali=pdfbrec( coeffs_or,  pfilter, dfilter) ;
or_dou(:,:,2)=imrec_damgali(1:512,1:512);

ww=ycbcr2rgb(uint8(or_dou));
ww=uint8(ww);

origImg =double(or);
distImg = double(ww);

        [M ,N, P] = size(origImg);
        error = origImg - distImg;
        MSE = sum(sum(sum(error.^2))) / (M * N * P);

        if(MSE > 0)
            PSNR1 = 20*log10(max(max(max(origImg))))-10*log10(MSE);
        else
            PSNR1 = 99;
        end 





end