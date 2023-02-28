clc;
clear;
%% This section puts the image in an array and declears all the required constants
OGImage_array = imread('Test_Image.jpg'); %Please Put The Image Name Here
[width,height,depth] = size(OGImage_array);
Y_downsample_factor = 2;
UV_downsample_factor = 4;
Y = zeros(int32(width/Y_downsample_factor),int32(height/Y_downsample_factor));
U = zeros(int32(width/Y_downsample_factor),int32(height/Y_downsample_factor));
V = zeros(int32(width/Y_downsample_factor),int32(height/Y_downsample_factor));

R = OGImage_array(:,:,1);
G = OGImage_array(:,:,2);
B = OGImage_array(:,:,3);

%% This section performes the downsampling as well as the YUV converstion in the same loop
disp("█░░░░ YUV converstion and Downsampling started...");
    for y = 2:Y_downsample_factor:width
        for x = 2:Y_downsample_factor:height
            %if ((mod(x,Y_downsample_factor) == 0 && mod(y,Y_downsample_factor) == 0))
           Y(y/Y_downsample_factor,x/Y_downsample_factor) =  int8(0.299*R(y,x) + 0.587*G(y,x) + 0.114*B(y,x));
            if (mod(x,UV_downsample_factor) == 0 && mod(y,UV_downsample_factor) == 0)
           U(y/UV_downsample_factor,x/UV_downsample_factor) = int8(-0.147*R(y,x) - 0.289*G(y,x) + 0.436*B(y,x));
           V(y/UV_downsample_factor,x/UV_downsample_factor) =  int8(0.615*R(y,x) - 0.515*G(y,x) - 0.100*B(y,x));
            end
        end
    end
%% Data gets sent to reciver
disp("Data sent to reciver ---->");
    U_UPSAMPLED = zeros(int32(width/Y_downsample_factor),int32(height/Y_downsample_factor));
    V_UPSAMPLED = zeros(int32(width/Y_downsample_factor),int32(height/Y_downsample_factor));
    
%% U and V get upsampled by 2 since they were down sampled by 4
    disp("██░░░ UV upsampling started,with interpolation");
    for y = 2:(width/UV_downsample_factor) - 1 
        for x = 2:(height/UV_downsample_factor) - 1
        U_UPSAMPLED(y*Y_downsample_factor,x*Y_downsample_factor) = U(y,x);
        U_UPSAMPLED(y*Y_downsample_factor+1,x*Y_downsample_factor+0) = U(y,x);
        U_UPSAMPLED(y*Y_downsample_factor+0,x*Y_downsample_factor+1) = U(y,x);
        U_UPSAMPLED(y*Y_downsample_factor+1,x*Y_downsample_factor+1) = U(y,x);

        V_UPSAMPLED(y*Y_downsample_factor,x*Y_downsample_factor) = V(y,x);
        V_UPSAMPLED(y*Y_downsample_factor+1,x*Y_downsample_factor+0) = V(y,x);
        V_UPSAMPLED(y*Y_downsample_factor+0,x*Y_downsample_factor+1) = V(y,x);
        V_UPSAMPLED(y*Y_downsample_factor+1,x*Y_downsample_factor+1) = V(y,x);
        end
    end
    %% YUV to RGB converstion occurs
        disp("███░░ YUV to RGB...");
    for y = 2:Y_downsample_factor:width
        for x = 2:Y_downsample_factor:height
       R(y,x) = int8(Y(y/Y_downsample_factor,x/Y_downsample_factor) + 1.140*V_UPSAMPLED(y/Y_downsample_factor,x/Y_downsample_factor));
       G(y,x) = int8(Y(y/Y_downsample_factor,x/Y_downsample_factor) - 0.395*U_UPSAMPLED(y/Y_downsample_factor,x/Y_downsample_factor) - 0.581*V_UPSAMPLED(y/Y_downsample_factor,x/Y_downsample_factor));
       B(y,x) = int8(Y(y/Y_downsample_factor,x/Y_downsample_factor) + 2.032*U_UPSAMPLED(y/Y_downsample_factor,x/Y_downsample_factor));
        end
    end

    %{
       RGB = [R G B];
   RGB = double(RGB);
   R = double(R);
   G = double(G);
   B = double(B);
%Design the Gaussian Kernel
%Standard Deviation
sigma = 1.76;
%Window size
win_size = 4;
[x,y]=meshgrid(-win_size:win_size,-win_size:win_size);

M = size(x,1)-1;
N = size(y,1)-1;
Exp_comp = -(x.^2+y.^2)/(2*sigma*sigma);
Kernel= exp(Exp_comp)/(2*pi*sigma*sigma);
%increasing kernel center point to make the gaussian blur behave as a
%sharpeing filter as well
Kernel(win_size+1,win_size+1) = Kernel(win_size+1,win_size+1)*2;

R_Filter=zeros(size(R));
G_Filter=zeros(size(G));
B_Filter=zeros(size(B));


%Convolution
for i = 1:size(R,1)-M
    for j =1:size(R,2)-N
        TempR = int8(R(i:i+M,j:j+M).*Kernel);
        TempG = int8(G(i:i+M,j:j+M).*Kernel);
        TempB = int8(B(i:i+M,j:j+M).*Kernel);

        R_Filter(i,j)=sum(TempR(:));
        G_Filter(i,j)=sum(TempG(:));
        B_Filter(i,j)=sum(TempB(:));

    end
end
    
    
%}

%% Median Filtering

disp("████░ Filtering Stage...");
    
RGB_pre_filter(:,:,1) = uint8(R);
RGB_pre_filter(:,:,2) = uint8(G);
RGB_pre_filter(:,:,3) = uint8(B);
RGB_post_filiter = zeros(size(RGB_pre_filter));
window_length = 3;
window = zeros(window_length*window_length);
edgex = (int32(window_length/2));
edgey = (int32(window_length /2));
for depth  = 1:3
    if(depth == 1)
        disp("████░ Filtering Stage (R/RGB)...");
    elseif(depth == 2)
        disp("████░ Filtering Stage (RG/RGB)...");
    else
        disp("████░ Filtering Stage (RGB/RGB)...");
    end
    for x = edgex:(width - edgex) 
            for y = edgey:(height - edgey)
                i = 1;
                for fx = 1:window_length
                    for fy = 1:window_length
                        window(i) = RGB_pre_filter(x + fx - edgex,y + fy - edgey,depth);
                        i = i + 1;
                window = sort(window);
                loc = fix((window_length*window_length/2)) + window_length - 1;
                if(window(loc)>255)
                    RGB_post_filiter(x,y,depth) = uint8(255);
                elseif(window(loc)<0)
                    RGB_post_filiter(x,y,depth) = uint8(0);
                else
                    RGB_post_filiter(x,y,depth) = uint8(window(loc));
                end
                    end
                end
            end
     end
end


%% MSE and PSNR calculation
MSE = single(0);
for depth = 1:3
    for y = 1:width
        for x = 1:height
            MSE = MSE + single((RGB_post_filiter(y,x,depth) - OGImage_array(y,x,depth))^2);
        end
    end
end
MSE = MSE*(1/(width*height*depth));
PSNR = 10*log(255/MSE);
%figure,imshow(Output);
%imshow(cat(3,R_Filter,G_Filter,B_Filter))
imshow(uint8(RGB_post_filiter))
%imshow(cat(3,Y,U,V))

%imshow(cat(3,[Y U_UPSAMPLED V_UPSAMPLED]))
disp("█████ Done !");
fprintf("MSE = %.2f and PSNR = %.2f\n",MSE, PSNR);

