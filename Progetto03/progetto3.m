function IM = progetto3(im, height, width)

    [r, c] = size(im);
    
    x_scale = (height - 1) / (r - 1);
    y_scale = (width - 1) / (c - 1);
    
    x2 = (1 : 1 / x_scale : r);
    y2 = (1 : 1 / y_scale : c)';
    
    IM = uint8(interp2(double(im), y2, x2));