function IM = rgb2hsi(im)
% RGB2HSI Trasformazione di un'immagine RGB nello spazio HSI.
%
% I2 = RGB2HSI(I1);
% La funzione accetta in ingresso un'immagine RGB uint8, uint16 o double
%  e restituisce un'immagine HSI a valori double.
%
% -- 
% Salvatore La Bua (slabua@gmail.com)
% DICGIM - University of Palermo

    if isa(im, 'uint8'),
        maxValue = 255;
    elseif isa(im, 'uint16'),
        maxValue = (2 ^ 16) - 1;
    elseif isa(im, 'double'),
        maxValue = 1;
    else,
        error('Questa funzione non supporta altri tipi di immagini in ingresso.');
    end;
    
    im = double(im) / maxValue;
    
    R = im(:, :, 1);
    G = im(:, :, 2);
    B = im(:, :, 3);
    
    sum = R + G + B;
    I = sum / 3;
    
    sum(sum == 0) = eps;
    S = 1 - (3 * min(min(R, G), B) ./ sum);
    S(I == 0) = 0;
    
    num = ((R - G) + (R - B)) / 2;
    den = sqrt(((R - G) .^ 2) + ((R - B) .* (G - B)));
    den(den == 0) = eps;
    teta = acos(num ./ den);
    
    H = teta;
    H(B > G) = (2 * pi) - H(B > G);
    H = H / (2 * pi);
    H(S == 0) = 0;
    
    IM = zeros(size(im));
    IM(:, :, 1) = H;
    IM(:, :, 2) = S;
    IM(:, :, 3) = I;