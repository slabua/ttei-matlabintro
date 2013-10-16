function [indices, IM] = pmatch_morph(im, k)
% PMATCH_MORPH Effettua il pattern matching morfologico di un'immagine su di un'altra.
%
%   [INDICES, I2] = PMATCH(I1, K)
%   La funzione verifica se l'immagine K e' presente nell'immagine I1,
%    restituendo, in caso affermativo, le coordinate dei centri del pattern
%    trovato nella matrice INDICES di dimensioni M*2, dove M e' il numero
%    di match riscontrati.
%   La matrice I2 sara' invece una copia dell'immagine I1, dove vengono
%    pero' evidenziate le occorrenze del pattern, in riquadri con dimensione
%    pari a quella del pattern stesso.

    [r, c] = size (im);
    [rk, ck] = size (k);
    rkmed = round(rk / 2);
    ckmed = round(ck / 2);
    
    maxPx = max(im(:));
    
    IM = im;
    
    square3 = strel('square', 3);
    k = imopen(k, square3);
    
    % oppure
    % k = bwmorph(boolean(k), 'open');
    
    kstrel = strel(k);
    positions = imerode(im, kstrel);
    
    % IM = positions;
    
    [i, j] = find(positions);
    
    indices = [i, j];
    
    [row, col] = size(indices);
    
    % Tracciatura riquadro.
    for (i = 1 : row),
        
        rr = indices(i, 1);
        cc = indices(i, 2);
        
        ra = max(rr - rkmed, 0);
        rb = min(rr + rkmed, r);
        ca = max(cc - ckmed, 0);
        cb = min(cc + ckmed, c);
        
        IM(ra : rb, ca) = maxPx;
        IM(ra : rb, cb) = maxPx;
        IM(ra, ca : cb) = maxPx;
        IM(rb, ca : cb) = maxPx;
        
    end;