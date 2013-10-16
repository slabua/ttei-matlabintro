function IM = addnoise(im, noise, type)
% ADDNOISE Costruzione di un'immagine con rumore additivo.
%
%   NOISYIM = ADDNOISE(IM, NOISE, TYPE)
%   La funzione realizza un'immagine rumorosa effettuando la somma tra
%    l'immagine originale IM e la maschera di rumore NOISE. Entrambe le
%    immagini devono avere le stesse dimensioni.
%   IM puo' essere un'immagine di tipo double, uint8 e uint16;
%    l'immagine NOISYIM sara' dello stesso tipo dell'immagine IM.
%    In qualsiasi caso le immagini verranno scalate alla rispettiva gamma
%    dinamica del tipo di appartenenza.
%   TYPE puo' essere 'salt & pepper', 'gaussian' e 'periodic'.
%   Unica particolarita' si ha nel caso in cui si voglia sommare un rumore
%    di tipo 'salt & pepper', per cui la maschera di rumore passata come
%    parametro deve essere preventivamente adeguata al fine di evitare di
%    ottenere un'immagine finale con un rumore diverso da quello Salt &
%    Pepper propriamente detto.

    [rIm, cIm] = size(im);
    [rN, cN] = size(noise);
    
    if ((rIm ~= rN) | (cIm ~= cN)),
        error('Dimensioni errate.');
    end;
    
    imClass = class(im);
    
    switch (imClass),
        case ('uint8'),
            maxDynR = (2 ^ 8) - 1;
            im = im2double(im);
        case ('uint16'),
            maxDynR = (2 ^ 16) - 1;
            im = im2double(im);
        otherwise,
            maxDynR = 1;
    end;
    
    if (~isa(noise, 'double')),
        noise = im2double(noise);
    end;
    
    minNval = min(noise(:));
    maxNval = max(noise(:));
    
    switch lower(type),
        case ('salt & pepper'),
            noise(noise == minNval) = -Inf;
            noise(noise == maxNval) = Inf;
            noise((noise ~= Inf) & (noise ~= -Inf)) = 0;
            
            IM = im + noise;
            
            vett = unique(sort(IM(:)));
            
            IM = IM - vett(2);
            IM = IM / vett(end - 1);
            
        case ('gaussian'),
            
            IM = im + noise;
            IM = IM - min(IM(:));
            IM = IM / max(IM(:));
            
        case ('periodic'),
            noise = noise - minNval;
            noise = noise / max(noise(:));
            
            IM = im + noise;
            IM = IM - min(IM(:));
            IM = IM / max(IM(:));
        otherwise,
            error('Maschera di disturbo non riconosciuta.');
    end;
    
    switch (imClass),
        case ('uint8'),
            IM = im2uint8(IM);
        case ('uint16'),
            IM = im2uint16(IM);
        otherwise,
    end;
    
    if (max(IM(:)) == Inf),
        IM(IM == -Inf) = 0;
        IM(IM == Inf) = maxDynR;
    end;