function progetto1

    lena = imread('lena_256.bmp');
    peppers = imread('peppers_256.bmp');
    
    J = [lena(:, 1:128), peppers(:, 129:256)];
    K = [J(:, 129:256), J(:, 1:128)];
    
    subplot(2,2,1); imshow(J);
    subplot(2,2,2); imshow(K);
    subplot(2,2,3); imhist(J);
    subplot(2,2,4); imhist(K);
    
    % Gli istogrammi di J e K sono identici in quanto non
    %  dipendono dalla disposizione spaziale dei pixel sulla
    %  superficie dell'immagine stessa.
    
end;