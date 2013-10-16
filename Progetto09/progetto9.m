function noiseim = createnoise(type, M, N, varargin)
% CREATENOISE Generazione di maschere di rumore Salt & Pepper, Gaussiano e Periodico.
%
%   NOISEIM = CREATENOISE(TYPE, M, N, PA, PB)
%   Viene generata in uscita la matrice NOISEIM di dimensione M*N relativa al
%    disturbo di tipo TYPE. PA e PB sono parametri opzionali che variano in
%    funzione del tipo di disturbo utilizzato.
%
%   TYPE puo' assumere i valori di: 'Salt & Pepper', 'Gaussian' e 'Periodic'.
%
%   Se il tipo di rumore e' 'Salt & Pepper', i parametri PA e PB sono
%    scalari e rappresentano rispettivamente il valore di probabilita' dei
%    pixel bianchi e neri.
%    - Default: PA = 0.05, PB = 0.05.
%
%   Se il tipo di rumore e' 'Gaussian', i parametri PA e PB sono scalari e
%    rappresentano rispettivamente il valore di media e deviazione standard.
%    - Default: PA = 0, PB = 1.
%
%   Se il tipo di rumore e' 'Periodic', il parametro PA e' un array di
%    coppie di valori rappresentanti le coordinate x e y dell'impulso di
%    rumore nel piano delle frequenze. Il parametro PB invece e' uno
%    scalare che rappresenta l'ampiezza del relativo impulso.
%    - Per default vengono disposti otto impulsi su una circonferenza con
%      raggio = (min(M, N) / 4). L'intensita' degli impulsi e' stata posta
%      a 10'000.
%
% -- 
% Salvatore La Bua (slabua@gmail.com)
% DICGIM - University of Palermo

    % Controllo dei parametri.
    if (nargin == 5),
        Pa = varargin{1};
        Pb = varargin{2};
    elseif ((nargin >= 3) & (nargin < 5)),
        disp('Non tutti i parametri sono stati immessi.');
        disp('Verranno utilizzati i valori di Pa e Pb di default.');
    else,
        error('Numero di parametri immessi non corretto.');
    end;
    
    % Controllo del tipo di disturbo da generare.
    switch lower(type),
        case ('salt & pepper'),
            % Impostazione valori di default per Pa e Pb.
            %  Pa -> probabilita' di salt sul numero totale di pixel.
            %  Pb -> probabilita' di pepper sul numero totale di pixel.
            if (nargin < 5),
                Pa = 0.05;
                Pb = 0.05;
            end;
            
            totPx = M * N;
            totPa = Pa * totPx;
            totPb = Pb * totPx;
            
            randEl = randperm(totPx);
            
            noiseim = 0.5 * ones(M, N);
            noiseim(randEl <= totPa) = 1;
            noiseim(randEl > totPa & randEl <= (totPa + totPb)) = 0;
            
        case ('gaussian'),
            % Impostazione valori di default per Pa e Pb.
            %  Pa -> valore medio.
            %  Pb -> deviazione standard.
            if (nargin < 5),
                Pa = 0;
                Pb = 1;
            end;
            
            noiseim = Pa + randn(M, N) * Pb;
            
            % Si e' scelto di utilizzare 256 livelli di grigio.
            noiseim = im2double(im2uint8(noiseim));
            
        case ('periodic'),
            % Impostazione valori di default per Pa e Pb.
            %  Pa -> coordinate (x, y) degli impulsi.
            %  Pb -> intensita' degli impulsi.
            % Si lavora nel dominio della frequenza, alla fine la maschera
            %  di disturbo viene riportata del dominio dello spazio.
            if (nargin < 5),
                % Coordinate del centro dell'immagine.
                cx = M / 2 + 1;
                cy = N / 2 + 1;
                
                % Calcolo delle coordinate degli impulsi.
                % E' stata scelta, per default, una costellazione di otto
                %  punti disposti su una circonferenza.
                
                radius = round(min(M, N) / 4);
                pt45 = round(radius * cos(pi / 4));
                
                % Inizializzazione delle variabili Pa e Pb.
                % Coordinate dei gli impulsi.
                Pa = [ radius,   0;     % asse  x  positivo
                       pt45,  pt45;     % primo   quadrante
                        0,  radius;     % asse  y  positivo
                      -pt45,  pt45;     % secondo quadrante
                      -radius,   0;     % asse  x  negativo
                      -pt45, -pt45;     % terzo   quadrante
                        0, -radius;     % asse  y  negativo
                       pt45, -pt45 ];   % quarto  quadrante
                
                [rPa, cPa] = size(Pa);
                
                % Ampiezza degli impulsi.
                Pb = 10000 * ones(1, rPa);
                
            end;
            
            rows = size(Pa);
            noiseim = zeros(M, N);
            for (i = 1 : rows(1)),
                noiseim(cx + Pa(i, 1), cy + Pa(i, 2)) = Pb(i);
            end;
            
            noiseim = noiseim * (1 + eps*i);
            noiseim = real(ifft2(ifftshift(noiseim)));
            noiseim = noiseim - min(noiseim(:));
            noiseim = noiseim / max(noiseim(:));
            
        otherwise,
            error('Maschera di disturbo non riconosciuta.');
            
    end;