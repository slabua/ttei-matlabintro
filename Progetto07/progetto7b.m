function IM = hsi2rgb(im)
% HSI2RGB Trasformazione di un'immagine HSI nello spazio RGB.
%
% I2 = HSI2RGB(I1);
% La funzione accetta in ingresso un'immagine HSI double
%  e restituisce un'immagine RGB a valori double.
%
% -- 
% Salvatore La Bua (slabua@gmail.com)
% DICGIM - University of Palermo

    [rows, cols, z] = size(im);
    
    H = im(:, :, 1) * (2 * pi);
    S = im(:, :, 2);
    I = im(:, :, 3);
    
    r = zeros(rows, cols);
    g = zeros(rows, cols);
    b = zeros(rows, cols);
    
    H(H == 0) = 2 * pi;
    
    test_0_120 = ((H > 0) & (H <= (2 * pi / 3)));
    test_120_240 = ((H > (2 * pi / 3)) & (H <= (4 * pi / 3)));
    test_240_360 = ((H > (4 * pi / 3)) & (H <= (2 * pi)));
    
    H(test_120_240) = H(test_120_240) - (2 * pi / 3);
    H(test_240_360) = H(test_240_360) - (4 * pi / 3);
    
    m1 = (1 - S) / 3;
    m2 = (1 / 3) * (1 + ((S .* cos(H)) ./ (cos((pi / 3) - H))));
    m3 = 1 - (m1 + m2);
    
    r(test_0_120) = m2(test_0_120);
    g(test_0_120) = m3(test_0_120);
    b(test_0_120) = m1(test_0_120);
    
    r(test_120_240) = m1(test_120_240);
    g(test_120_240) = m2(test_120_240);
    b(test_120_240) = m3(test_120_240);
    
    r(test_240_360) = m3(test_240_360);
    g(test_240_360) = m1(test_240_360);
    b(test_240_360) = m2(test_240_360);
    
    R = 3 * I .* r;
    G = 3 * I .* g;
    B = 3 * I .* b;
    
    IM = zeros(size(im));
    IM(:, :, 1) = R;
    IM(:, :, 2) = G;
    IM(:, :, 3) = B;
    
    IM = im2double(im2uint16(IM));