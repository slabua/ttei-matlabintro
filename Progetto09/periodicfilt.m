function IM = periodicfilt(im, threshold, varargin)
% PERIODICFILT Filtro adattivo per immagini corrotte con rumore periodico.
%
%   RESTOREDIM = PERIODICFILT(NOISYIM, THRESHOLD)
%   La funzione permette di ripristinare un'immagine corrotta con rumore
%    periodico. E' possibile individuare e rimuovere impulsi con coordinate
%    sconosciute nel piano delle frequenze, soltanto tramite la soglia
%    THRESHOLD che indica la differenza di ampiezza tra l'impulso e gli
%    otto punti circostanti.
%
%   RESTOREDIM = PERIODICFILT(NOISYIM, THRESHOLD, DIM)
%   DIM permette di specificare il lato della maschera di filtraggio.
%   DIM deve assumere valori dispari e maggiori di 1, in caso contrario,
%    la dimensione verra' impostata al valore di default, 3.
%   Se invece si immette un valore pari ma maggiore di 1, DIM assumera' il
%    valore DIM + 1.

    [r, c] = size(im);
    
    if (~isa(im, 'double')),
        im = im2double(im);
    end;
    
    fourier = fft2(im);
    fmodulo = fftshift(abs(fourier)); % log
    ffase = angle(fourier);
    
    if (nargin == 3),
        dim = round(varargin{1});
        if (dim <= 1),
            dim = 3;
            disp('DIM deve assumere valori dispari e maggiori di 1.');
            disp(sprintf('Nuovo valore di DIM utilizzato: %d.', dim));
        elseif (mod(dim, 2) == 0),
            dim = dim + 1;
            disp('DIM deve assumere valori dispari e maggiori di 1.');
            disp(sprintf('Nuovo valore di DIM utilizzato: %d.', dim));
        end;
    else,
        dim = 3;
    end;
    
    addedDiff = (dim - 1) / 2;
    addedSum = (dim + 1) / 2;
    maskDim = dim * dim;
    
    fmodPad = zeros(r + dim -1, c + dim - 1);
    fmodPad(addedSum : r + addedDiff, addedSum : c + addedDiff) = fmodulo;
    
    h = waitbar(0, 'Avanzamento in corso...');
    for (row = addedSum : r + addedDiff),
        for (col = addedSum : c + addedDiff),
            
            mask = fmodPad(row - addedDiff : row + addedDiff, col - addedDiff : col + addedDiff);
            vettTemp = sort(mask(:));
            
            medVett = sum(vettTemp(1 : end - 1)) / (maskDim - 1);
            maxVett = max(vettTemp);
            
            diff = abs(medVett - maxVett);
            
            if (diff > threshold),
                if (fmodPad(row, col) == maxVett),
                    fmodPad(row, col) = vettTemp((length(vettTemp) + 1) / 2);
                end;
            end;
            
        end;
        waitbar(row / r, h);
    end;
    
    close(h);
    
    fmodulo = fmodPad(addedSum : r + addedDiff, addedSum : c + addedDiff);
    
    modulo = ifftshift(fmodulo); % exp
    cos = cos(ffase);
    sin = sin(ffase) * i;
    
    IM = real(ifft2(modulo .* (cos + sin)));
    IM = IM - min(IM(:));
    IM = IM / max(IM(:));