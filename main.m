clc;
clear;
close all



sar_path = ['.\test_img\large_sar2.png'];  
opt_path = ['.\test_img\large_opt2.png'];

u_s_origin = imread(sar_path);
figure,imshow(u_s_origin)
title('SAR')
if size(u_s_origin,3) == 3
    u_s = rgb2gray(u_s_origin);
else
    u_s = u_s_origin;
end
u_s = double(u_s);
[row_s,col_s,~] = size(u_s);

u_o_origin = imread(opt_path);
figure,imshow(u_o_origin)
title('Optical')
if size(u_o_origin,3) == 3
    u_o = rgb2gray(u_o_origin);
else
    u_o = u_o_origin;
end
u_o = double(u_o);
[row_o,col_o,~] = size(u_o);

tic
%%%%%%%%%%%%%PCo coefficient %%%%%%%%%%%%%%%%%

feat_s = PC_ori(u_s,9,-2);
feat_o = PC_ori(u_o,9,-2);

%%%%%%%%%%%%%NCC-FFT%%%%%%%%%%%%%%%%%%

R = NCC(feat_s,feat_o);

figure,imagesc(R)
title('NCC Result')
figure,mesh(R)
title('NCC Result 3D')
%%%%%%%%%%%%Peak sharpening%%%%%%%%%%%

temp_max = max(max(R));
[max_x1,max_y1] = find(R==temp_max);
R_sharp = regionalmax(R);

figure,imagesc(R_sharp);
title('NCC after sharpening')
figure,mesh(R_sharp);
title('NCC after sharpening 3D')

temp_max = max(max(R_sharp));
[max_x2,max_y2] = find(R_sharp==temp_max);

%%%%%%%%%%%%Conditional selection%%%%%%%%%%%%%

dis_12 = sqrt((max_x1-max_x2)^2 + (max_y1-max_y2)^2);
weight = R(max_x2,max_y2)/R(max_x1,max_y1);
if weight>0.8 && dis_12 >10
    max_x = max_x2;
    max_y = max_y2;
else
    max_x = max_x1;
    max_y = max_y1;
end

%%%%%%%%%%%%%%%%Show matched images%%%%%%%%%%%%%%%%%%%%%

time = toc;
disp(['Calculation time is  ',num2str(time),' s'])
disp(['The matching position is x=',num2str(max_x),' y=',num2str(max_y)])
tran_s = zeros(row_s,col_s);
tran_s(max_x:max_x+row_s-1,max_y:max_y+col_s-1) = u_s;
falseColorOverlay = imfuse( u_o, tran_s);
figure,imshow(falseColorOverlay)
title('matched SAR (red) overlay on Optical (green)')