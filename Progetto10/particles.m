function [IM, p_borders, p_noSovrapp, p_sovrapp] = particles(im, testArea)
% PARTICLES Effettua la classificazione delle particelle presenti in un'immagine.
%
%   [IM, p_borders, p_noSovrapp, p_sovrapp] = PARTICLES(im)
%   La funzione accetta in ingresso l'immagine di cui deve effettuare la
%    categorizzazione delle particelle e fornisce in uscita quattro matrici:
%    IM e' la matrice rgb composta da:
%     p_borders:    immagine delle componenti connesse ai bordi;
%     p_noSovrapp:  immagine delle componenti connesse singole, non sovrapposte;
%     p_sovrapp:    immagine delle componenti connesse sovrapposte;
%
%   [...] = PARTICLES(im, testArea)
%   Il parametro testArea indica l'area soglia in numero di pixel per la
%    quale le particelle verranno riconosciute come sovrapposte.
%    - Default: 420.

    % Con testArea = 600 vengono gia' riconosciute alcune particelle
    %  sovrapposte come un'unica particella isolata.
    % Il valore 420 e' ottimale per le particelle prese in esame
    %  nell'immagine analizzata.
    if (nargin == 1),
        testArea = 420;
    end;
    
    [r, c] = size(im);
    
    se = strel('square', 3);
    p = logical(imopen(im, se));
    
    marker = p;
    marker(2 : end - 1, 2 : end - 1) = 0;
    p_borders = imreconstruct(marker, p, 4);
    p_noBorders = xor(p, p_borders);
    
    % Per ricavare automaticamente la dimensione minima delle particelle.
    %
    % p_nBlabel = bwlabel(p_noBorders, 4);
    % maxConn = max(p_nBlabel(:));
    % areas = zeros(1, maxConn);
    % for (i = 1 : maxConn),
    %     areas(i) = sum(sum(p_nBlabel == i));
    % end;
    % minArea = min(areas);
    % testArea = minArea + ((minArea / 100) * percent);
    
    tempMark = false(r, c);
    
    p_sovrapp = tempMark;
    p_noSovrapp = tempMark;
    
    for (i = 1 : r),
        for (j = 1 : c),
            
            if (p_noBorders(i, j) == 1),
                tempMark(i, j) = 1;
                temp = imreconstruct(tempMark, p, 4);
                
                if (sum(temp(:)) <= testArea),
                    p_noSovrapp = p_noSovrapp | temp;
                else,
                    p_sovrapp = p_sovrapp | temp;
                end;
                
                tempMark(i, j) = 0;
                p_noBorders(temp) = 0;
            end;
            
        end;
    end;
    
    IM = double(cat(3, p_borders, p_noSovrapp, p_sovrapp));