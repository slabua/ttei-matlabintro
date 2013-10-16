function IM = progetto6a(im1, im2, op)
% PROGETTO6A Operazioni aritmetiche tra immagini dello stesso tipo e stesse dimensioni.
%
%   I3 = PROGETTO6A(I1, I2, OP)
%   Accetta in ingresso due immagini dello stesso tipo e delle stesse
%    dimensione ed effettua su di esse l'operazione aritmetica specificata
%    da OP.
%
%   L'operazione puo' essere:
%    Addizione:         '+',
%    Sottrazione:       '-',
%    Moltiplicazione:   '*',
%    Divisione:         ['/' | ':'].

    im1Class = class(im1);
    im2Class = class(im2);
    
    [r1, c1] = size(im1);
    [r2, c2] = size(im2);
    
    if ((im1Class(1:5) ~= im2Class(1:5)) | (r1 ~= r2) | (c1 ~= c2)),
        error('Le immagini non sono dello stesso tipo oppure non hanno le stesse dimensioni.');
        % return;
    else,
        imClass = im1Class(1:5);
        r = r1;
        c = c1;
        if (imClass == 'uint8'),
            maxValue = 255;
            IM = uint8(zeros(r, c));
        elseif (imClass == 'uint1'),
            maxValue = (2 ^ 16) - 1;
            IM = uint16(zeros(r, c));
        else,
            maxValue = 1;
            IM = zeros(r, c);
        end;
    end;
    
    if (op == '+'),
        tmp = double(im1) + double(im2);
    elseif (op == '-'),
        tmp = double(im1) - double(im2);
        tmp = tmp - min(min(tmp));
    elseif (op == '*'),
        tmp = double(im1) .* double(im2);
    elseif ((op == '/') | (op == ':')),
        % Il valore del fattore moltiplicativo presente nella costante toll
        %  e' stato scelto in modo che toll valga "1" per immagini uint8.
        % Toll varia proporzionalmente in funzione del tipo di immagine.
        toll = maxValue * 0.003922;
        tmp = (double(im1) + toll) ./ (double(im2) + toll);
        
        % Trasformazione esponenziale.
        tau = 1;
        % tau > 1 => piu' scuro
        % tau < 1 => piu' chiaro
        
        tmp = maxValue * (1 - exp( -(tmp / tau)));
        
        % Trasformazione lineare a tratti:
        % Si potrebbe utilizzare al posto di quella esponenziale,
        %  ma i risultati non sono dei migliori.
        %
        %  x in [0, 1]   => f(x) = (mx + q) = (-255x + 256)
        %  x in (1, inf) => f(x) = 1
        %
        % for (i = 1 : r),
        %     for (j = 1 : c),
        %         if (tmp(i, j) <= 1),
        %             tmp(i, j) = (- 255 * tmp(i, j)) + 256;
        %         end;
        %     end;
        % end;
    end;
    
    tmp = tmp  * maxValue / max(max(tmp));
    IM(:) = tmp(:);