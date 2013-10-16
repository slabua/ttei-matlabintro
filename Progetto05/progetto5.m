function IM = progetto5(im, action, varargin)

    action = action(1:3);
    
    imageClass = class(im);
    imageClass = imageClass(1:5);
    
    maxValue = 255;
    
    if (action == 'neg'),
        if (imageClass == 'uint8'),
            IM = uint8(maxValue - double(im));
        else,
            IM = (maxValue - (im * maxValue)) / maxValue;
        end;
    elseif (action == 'log'),
        c = varargin{1};
        
        if (imageClass == 'uint8'),
            IM = c * log(1 + double(im));
            
            % Abilitando la seguente riga si ottiene l'adattamento
            %  della distribuzione del colore all'intera gamma
            %  dinamica delle immagini di tipo uint8 [0, 255].
            %
            IM = uint8(IM * maxValue / max(max(IM)));
            
            % Per contro, se viene utilizzata la seguente riga,
            %  e' necessario utilizzare un parametro c scelto come
            %  segue:
            %  c = 255 / (log(1 + max(max(IM)))) = 45.9859.
            %
            % IM = uint8(IM);
            
        else,
            IM = c * log(1 + (im * maxValue));
            IM = IM / max(max(IM));
        end;
    elseif (action == 'gam'),
        c = varargin{1};
        gam = varargin{2};
        % gam > 1 => piu' scuro
        % gam < 1 => piu' chiaro
        
        if (imageClass == 'uint8'),
            IM = c * (double(im) .^ gam);
            
            % Abilitando la seguente riga si inibisce la funzione
            %  della costante c, in quanto i valori dell'immagine
            %  verranno adattati automaticamente alla gamma dinamica
            %  delle immagini uint8 [0, 255].
            % Valori ottimali si ottengono per gam = [0.4, 0.5].
            % I valori di c si possono ottenere dalla formula generale:
            %  Per gam = 0.4  => c = 27.7923.
            %  Per gam = 0.45 => c = 21.0667.
            %  Per gam = 0.5  => c = 15.9687.
            %
            IM = uint8(IM * maxValue / max(max(IM)));
            
            % Per contro, se viene utilizzata la seguente riga,
            %  e' necessario scegliere di volta in volta opportuni
            %  valori per le costanti c e gam.
            %
            % IM = uint8(IM);
            
        else,
            IM = c * ((im * maxValue) .^ gam);
            IM = IM / max(max(IM));
        end;
    elseif (action == 'str'),
        m = varargin{1};
        E = varargin{2};
        
        if (imageClass == 'uint8'),
            IM = 1 ./ (1 + ((m ./ (double(im) / (double(max(max(im)))))) .^ E));
            IM = uint8(IM * maxValue / max(max(IM)));
        else,
            IM = 1 ./ (1 + ((m ./ im) .^ E));
            IM = IM / max(max(IM));
        end;
    end;