function [med, var] = medvar(im, totPx)
%
% -- 
% Salvatore La Bua (slabua@gmail.com)
% DICGIM - University of Palermo

    % totPx = length(im(:));
    % vett = sort(unique(im(:)));
    
    % media immagine
    % med = 0;
    % for (i = 1 : length(vett)),
    %     totActualPx = sum(im(:) == vett(i)) / totPx;
    %     med = med + (vett(i) * totActualPx);
    % end;
    med = sum(im(:)) / totPx;
    
    % varianza immagine
    % var = 0;
    % for (i = 1 : length(vett)),
    %     totActualPx = sum(im(:) == vett(i)) / totPx;
    %     var = var + (((vett(i) - med) ^ 2) * totActualPx);
    % end;
    var = (sum(im(:) .^ 2) / totPx) - (med ^ 2);