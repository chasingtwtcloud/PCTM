function hog = PC_ori(u,theta,thresh)

u = double(u);

[~,~,~,~,hog] = phasecong3(u,4,theta,3,2.1,0.55,2.0,0.5,10,thresh);

hog = cat(3,hog{:});

end