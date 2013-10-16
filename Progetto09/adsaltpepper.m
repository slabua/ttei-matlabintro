function IM = adsaltpepper(im, maxDim)
% ADSALTPEPPER Filtro adattivo mediano per immagini corrotte con rumore Salt & Pepper.
%
%   RESTOREDIM = ADSALTPEPPER(NOISYIM, MAXDIM)
%   La funzione esegue un filtro mediano con dimensione iniziale della
%    maschera quadrata di lato 3 e prosegue aumentando la dimensione della
%    stessa fino a MAXDIM.
%   Per ciascun valore di lato della maschera, NOISYIM viene interamente
%    processata; la dimensione del lato della maschera viene incrementata
%    soltanto se non e' stato possibile effettuare correzioni adeguate.

%   Adattato da adpmedian.m del DIPUM Toolbox.

    IM = im;
    IM(:) = 0;
    
    maxDim = round(maxDim);
    if (maxDim <= 1),
        maxDim = 3;
        disp('DIM deve assumere valori dispari e maggiori di 1.');
        disp(sprintf('Nuovo valore di DIM utilizzato: %d.', maxDim));
    elseif (mod(maxDim, 2) == 0),
        maxDim = maxDim + 1;
        disp('DIM deve assumere valori dispari e maggiori di 1.');
        disp(sprintf('Nuovo valore di DIM utilizzato: %d.', maxDim));
    end;
    
    alreadyProcessed = IM;
    
    for (dim = 3 : 2 : maxDim),
        mask = ones(dim);
        
        % Matrice dei valori minimi.
        minPx = ordfilt2(im, 1, mask, 'symmetric');
        
        % Matrice dei valori mediani.
        medPx = medfilt2(im, [dim dim], 'symmetric');
        % Matrici dei valori medi (non produce risultati soddisfacenti).
        % medPx = filter2(mask, im, 'symmetric') / (dim * dim);
        
        % Matrice dei valori massimi.
        maxPx = ordfilt2(im, dim * dim, mask, 'symmetric');
        
        % La matrice mediantrue ha 1 nei punti in cui il valore mediano
        %  e' diverso dal minimo e dal massimo presenti nella maschera
        %  attuale di scorrimento e nei punti in cui non e' stato ancora
        %  eseguita alcun a correzione.
        mediantrue = ((minPx < medPx) & (medPx < maxPx) & ~alreadyProcessed);
        
        % La matrice imtrue ha 1 nei punti in cui il valore l'immagine
        %  e' diversa dal minimo e dal massimo presenti nella maschera
        %  attuale di scorrimento.
        imtrue = ((minPx < im) & (im < maxPx));
        
        % Punti in cui i valori mediani e l'immagine sono diversi dai
        %  valori massimi della maschera.
        notcorrupted  = mediantrue & imtrue;
        
        % Punti in cui i valori mediani corrispondono ai punti in cui
        %  l'immagine assume i valori massimi della maschera.
        medianOutput = mediantrue & ~imtrue;
        
        % Nei punti in cui e' verificata la prima condizione, l'immagine
        %  risultato non viene alterata rispetto all'immagine in ingresso,
        %  altrimenti si utilizzano i valori mediani precedentemente
        %  calcolati.
        IM(notcorrupted) = im(notcorrupted);
        IM(medianOutput) = medPx(medianOutput);
        
        % Permette di iterare il processo di correzione finche' non viene
        %  raggiunta la dimensione massima della maschera e finche' tutte le
        %  posizioni che e' possibile correggere non lo siano gia' state.
        alreadyProcessed = (alreadyProcessed | mediantrue);
        if all(alreadyProcessed(:)),
            break;
        end;
        
    end;
    
    % Per eventuali punti rimanenti si utilizza lil valore mediano.
    IM(~alreadyProcessed) = medPx(~alreadyProcessed);