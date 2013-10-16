function progetto4

    % imposta i colori dei tre gruppi di classificazione
    colors = [255, 150, 80];
    
    % imposta l'area minima delle cellule da visualizzare
    smallest = 100;
    
    % imposta la soglia di circolarita'
    circ_thresh = 1;
    
    % memorizzazione immagine
    im = imread('blood_cells.tiff');
    [r, c] = size(im);
    
    subplot(2, 2, 1);
    % figure;
    imshow(im);
    % imwrite(im, '01.png', 'png');
    
    im = imclearborder(not(im)); % provare un'implementazione personale
    IM = im;
    
    subplot(2, 2, 2);
    % figure;
    imshow(not(IM));
    % imwrite(not(IM), '02.png', 'png');
    
    % generazione labels e conteggio
    [label, max_conn] = bwlabel(im);
    
    % eliminazione delle componenti piccole (pixels < smallest)
    for (i = 1 : max_conn),
        if (sum(sum(label == i)) < smallest),
            IM = IM .* not(label == i);
        end;
    end;
    
    subplot(2, 2, 3);
    % figure;
    imshow(not(IM));
    % imwrite(not(IM), '03.png', 'png');
    
    % aggiornamento delle variabili dopo il preprocessamento
    [label, max_conn] = bwlabel(IM);
    
    label_circ = bwlabel(bwfill(IM, 'holes'));
    label_perim = bwlabel(bwperim(label_circ));
    
    % verifica del numero di nuclei e controllo circolarita'
    for (i = 1 : max_conn),
        label_cell = bwlabel(not(label == i));
        nuclei = max(max(label_cell)) - 1;
        
        area = sum(sum(label_circ == i));
        perim = sum(sum(label_perim == i));
        circ_test = (perim ^ 2) / (area * 4 * pi);
        
        if (circ_test < circ_thresh),
            if (nuclei == 1),
                mask = ((label == i) * (colors(1) - 1)) + 1;
            else,
                mask = ((label == i) * (colors(2) - 1)) + 1;
            end;
        else,
            mask = ((label == i) * (colors(3) - 1)) + 1;
        end;
        
        IM = IM .* mask;
    end;
    
    % visualizzazione immagine
    subplot(2, 2, 4);
    % figure;
    imshow(uint8(IM));
    % imwrite(uint8(IM), '04.png', 'png');
    
    % visualizzazione del negativo per una maggiore corrispondenza con
    %  l'immagine di partenza
    figure;
    IM = abs(IM - max(max(IM)));
    imshow(uint8(IM));
    % imwrite(uint8(IM), '05.png', 'png');