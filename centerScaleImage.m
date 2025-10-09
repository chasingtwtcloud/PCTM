function outputImage = centerScaleImage(inputImage, scale_factor)
% 中心缩放并保持图像尺寸不变

[h, w, channels] = size(inputImage);

% 计算缩放后的尺寸
new_h = round(h * scale_factor);
new_w = round(w * scale_factor);

% 缩放图像
scaledImage = imresize(inputImage, [new_h, new_w],'bicubic');

% 创建与原始图像相同尺寸的黑色画布
outputImage = zeros(h, w, channels, 'like', inputImage);

% 计算放置位置（居中）
start_row = max(1, floor((h - new_h) / 2) + 1);
start_col = max(1, floor((w - new_w) / 2) + 1);
end_row = min(h, start_row + new_h - 1);
end_col = min(w, start_col + new_w - 1);

% 将缩放后的图像放置在中心
outputImage(start_row:end_row, start_col:end_col, :) = scaledImage;

% 转换回原始数据类型
if isinteger(inputImage)
    outputImage = cast(outputImage, class(inputImage));
end
end

