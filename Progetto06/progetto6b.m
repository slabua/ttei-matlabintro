function RES = progetto6b(im, dim, varargin)
% PROGETTO6B Filtraggio immagine tramite parametri immessi dall'utente.
%
% I2 = PROGETTO6B(I1, DIM, varargin);
% La funzione ritorna un'immagine dello stesso tipo dell'immagine da
%  elaborare.
%
% I parametri di ingresso sono:
%
%  Immagine da elaborare,
%  Dimensione del filtro da applicare all'immagine,
%  Un numero variabile di parametri che indicano i coefficienti della
%   maschera del filtro.
%
%  I coefficienti possono essere forniti singolarmente,
%   in forma di vettore,
%   in forma di matrice quadrata.
%
% ---------------------------------------------------------------------
%
%   I2 = PROGETTO6B(I1, DIM, W1, ..., Wdim)
%   Accetta DIM * DIM parametri Wi che rappresentano i coefficienti
%    della matrice del filtro da applicare all'immagine.
%
%   I2 = PROGETTO6B(I1, DIM, filterVector)
%   Accetta un vettore di DIM * DIM coefficienti del filtro.
%
%   I2 = PROGETTO6B(I1, DIM, filterMatrix)
%   Accetta la matrice quadrata (DIM, DIM) dei coefficienti del filtro.
%
% -- 
% Salvatore La Bua (slabua@gmail.com)
% DICGIM - University of Palermo

    % Raccolta informazioni sull'immagine da elaborare.
    [r, c] = size(im);
    imClass = class(im);
    imClass = imClass(1:5);
    
    % Inizializzazione delle variabili in funzione della classe
    %  dell'immagine.
    if (imClass == 'uint8'),
        maxValue = 255;
        RES = uint8(zeros(r, c));
    elseif (imClass == 'uint1'),
        maxValue = (2 ^ 16) - 1;
        RES = uint16(zeros(r, c));
    else,
        maxValue = 1;
        RES = zeros(r, c);
    end;
    
    % Numero dei parametri variabili passati alla funzione.
    [rv, cv] = size(varargin);
    vararginElements = rv * cv;
    
    % Controllo dei parametri:
    % Viene controllato se sono stati passati gli elementi della
    %  matrice del filtro, un vettore o la matrice del filtro stesso.
    % Viene inoltre verificato che il numero degli elementi che comporranno
    %  il filtro sia coerente con la dimensione immessa come secondo
    %  parametro.
    if (vararginElements == 1),
        filter = varargin{1};
        if (length(filter) == (dim * dim)),
            filt = zeros(dim);
            filt(:) = filter;
            filter = filt';
        end;
    else,
        if (length(varargin) ~= (dim * dim)),
            error('Il numero di elementi del filtro non corrisponde alla dimensione immessa.');
            % return;
        end;
        
        w = zeros(1, dim);
        for (i = 1 : dim * dim),
            w(i) = varargin{i};
        end;
        
        filter = zeros(dim);
        filter(:) = w;
        filter = filter';
    end;
    
    if (length(filter) ~= dim),
        error('Il numero di elementi del filtro non corrisponde alla dimensione immessa.');
        % return;
    end;
    
    % Numero di righe/colonne da aggiungere sopra/sotto/a sinistra/a destra
    %  dell'immagine di partenza per poter effettuare le operazioni di
    %  filtraggio.
    added = fix(dim / 2);
    
    % Calcolo del colore di sfondo come valore medio in funzione della
    %  classe dell'immagine.
    % PS: Questo e' superfluo quando si colorano anche gli angoli
    %  (vedere blocco Riempimento).
    bg = maxValue / 2;
    
    % Instanziazione della matrice temporanea allargata di elaborazione.
    % Rimuovere la costante bg se non si considera la riga sopra riportata.
    r2 = r + (2 * added);
    c2 = c + (2 * added);
    
    IM = bg * ones(r2, c2);
    IM(added + 1 : end - added, added + 1 : c + added) = im;
    
    % Riempimento del bordo della nuova immagine temporanea.
    for (i = 1 : added),
        % righe up
        IM(i, added + 1 : end - added) = im(1, :);
        % righe down
        IM(end - i + 1, added + 1 : end - added) = im (end, :);
        % colonne left
        IM(added + 1 : end - added, i) = im(:, 1);
        % colonne right
        IM(added + 1 : end - added, end - i + 1) = im(:, end);
        % angolo upper-left
        IM(i, 1 : added) = im(1, 1);
        % angolo upper-right
        IM(i, end - added + 1 : end) = im(1, end);
        % angolo lower-left
        IM(end - i + 1, 1 : added) = im(end, 1);
        % angolo lower-right
        IM(end - i + 1, end - added + 1 : end) = im(end, end);
    end;
    
    % Matrice vuota che conterra' il valore dei pixel calcolato
    %  sull'immagine precedentemente creata.
    IM2 = zeros(r2, c2);
    
    % Calcolo del valore dei pixel.
    for (i = 1 : r2 - dim + 1),
        for (j = 1 : c2 - dim + 1),
            mask = IM(i : i + dim - 1, j : j + dim - 1);
            IM2(i + added, j + added) = sum(sum(mask .* filter));
        end;
    end;
    
    % Rifinitura dei bordi dell'immagine per portarla alle dimensioni di
    %  partenza.
    IM2 = IM2(added + 1 : end - added, added + 1 : end - added);
    
    % Conversione della matrice temporanea al tipo dell'immagine di
    %  partenza.
    RES(:) = IM2(:);