function IM = filtromed(im, dim)
% FILTROMED Filtro mediano con maschera di filtraggio a dimensione variabile.
%
%   I2 = FILTROMED(I1, DIM)
%   La funzione effettua il filtraggio mediano dell'immagine I1 con una
%    maschera quadrata di lato DIM.

    [r, c] = size(im);
    IM = zeros(r, c);
    
    addedDiff = (dim - 1) / 2;
    addedSum = (dim + 1) / 2;
    maskDim = dim * dim;
    
    temp = zeros(r + dim - 1, c + dim - 1);
    temp(addedSum : r + addedDiff, addedSum : c + addedDiff) = im;
    
    vett = zeros(1, maskDim);
    
    for (i = addedSum : r + addedDiff),
        for (j = addedSum : c + addedDiff),
            vett(:) = temp(i - addedDiff : i + addedDiff, j - addedDiff : j + addedDiff);
            vett = sort(vett);
            IM(i - addedDiff, j - addedDiff) = vett((maskDim + 1) / 2);
        end;
    end;