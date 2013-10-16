function IM = particles(im, percent)
%
% -- 
% Salvatore La Bua (slabua@gmail.com)
% DICGIM - University of Palermo

    se = strel('square', 3);
    p = logical(imopen(im, se));
    
    % p_noBorders = imclearborder(p);
    % p_borders = xor(p, p_noBorders);
    
    marker = p;
    marker(2 : end - 1, 2 : end - 1) = 0;
    p_borders = imreconstruct(marker, p, 4);
    p_noBorders = xor(p, p_borders);
    
    % figure, imshow(p_borders), title('Bordi');
    
    p_nBlabel = bwlabel(p_noBorders, 4);
    maxConn = max(p_nBlabel(:));
    
    areas = zeros(1, maxConn);
    for (i = 1 : maxConn),
        areas(i) = sum(sum(p_nBlabel == i));
    end;
    
    % areas = sort(areas);
    % minArea = areas(1);
    minArea = min(areas);
    
    testArea = minArea + ((minArea / 100) * percent);
    
    p_sovrapp = p_nBlabel;
    p_nBlabel(p_nBlabel ~= 0) = 1;
    
    for (i = 1 : maxConn),
        if (sum(sum(p_sovrapp == i)) <= testArea),
            p_sovrapp(p_sovrapp == i) = 0;
        end;
    end;
    
    p_sovrapp(p_sovrapp ~= 0) = 1;
    
    p_noSovrapp = xor(p_nBlabel, p_sovrapp);
    
    % figure, imshow(p_sovrapp), title('Sovrapposte');
    % figure, imshow(p_noSovrapp), title('Non Sovrapposte');
    
    IM = cat(3, p_sovrapp, p_noSovrapp, p_borders);
    figure, imshow(IM);