function IM = adgaussian(im, maskSize, noise, varargin)
% ADGAUSSIAN Filtro adattivo per immagini corrotte con rumore gaussiano.
%
%   RESTOREDIM = ADGAUSSIAN(NOISYIM, MASKSIZE, NOISE)
%   Il parametro NOISYIM e' l'immagine corrotta dal rumore gaussiano,
%    MASKSIZE e' la dimensione della maschera di filtraggio e NOISE puo'
%    essere sia la "deviazione standard" del rumore gaussiano che ha corrotto
%    - o si presume che lo abbia fatto - l'immagine NOISYIM, oppure
%    un'immagine di rumore gaussiano con le stesse dimensioni di NOISYIM.
%
%   RESTOREDIM = ADGAUSSIAN(NOISYIM, MASKSIZE, NOISE, NOISEMEAN)
%    Il prototipo a quattro parametri tiene in considerazione un'eventuale
%    media del rumore gaussiano specificata dall'utente.
%
% -- 
% Salvatore La Bua (slabua@gmail.com)
% DICGIM - University of Palermo

    [rIm, cIm] = size(im);
    IM = zeros(rIm, cIm);
    maskPx = maskSize * maskSize;
    
    if (~isa(im, 'double')),
        im = im2double(im);
    end;
    
    if (nargin == 3),
        noiseMean = 0;
    else,
        noiseMean = varargin{1};
    end;
    
    if (length(noise) ~= 1),
        [rN, cN] = size(noise);
        
        if (~isa(noise, 'double')),
            noise = im2double(noise);
        end;
        
        if ((rIm ~= rN) | (cIm ~= cN)),
            error('Dimensioni errate.');
        end;
        
        noiseim = noise;
        
    else,
        varN = noise ^ 2;
        noiseim = imnoise(IM, 'gaussian', noiseMean, varN);
    end;
    
    mediaIm = filter2(ones(maskSize), im) / maskPx;
    varIm = (filter2(ones(maskSize), (im .^ 2)) / maskPx) - (mediaIm .^ 2);
    
    mediaN = filter2(ones(maskSize), noiseim) / maskPx;
    varN = (filter2(ones(maskSize), (noiseim .^ 2)) / maskPx) - (mediaN .^ 2);
    
    testMask = (varN > varIm);
    varIm(testMask) = 1;
    varN(testMask) = 1;
    
    IM = im - (varN ./ varIm) .* (im - mediaIm);