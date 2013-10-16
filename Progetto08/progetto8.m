function [effeteta, teta] = colorgrad(rgb, varargin)
% COLORGRAD Individuazione dei contorni di un'immagine RGB tramite misura del gradiente con maschere di Sobel.
%
%   [EffeTeta, Teta] = COLORGRAD(RGB)
%   La funzione accetta l'immagine RGB in ingresso e ne calcola il
%    gradiente. La soglia T viene impostata a zero per default.
%   La matrice EffeTeta conterra' il modulo dei vettori di gradiente.
%   La matrice Teta conterra' invece l'angolo dei vettori gradiente.
%
%   [EffeTeta, Teta] = COLORGRAD(RGB, T)
%   La funzione accetta l'immagine RGB in ingresso e ne calcola il
%    gradiente. La soglia T deve appartenere all'intervallo [0, 1].
%   La matrice EffeTeta conterra' il modulo dei vettori di gradiente
%    per i punti in cui esso sia strettamente maggiore alla soglia T.
%   La matrice Teta conterra' invece l'angolo dei vettori gradiente.
%
%   [EffeTeta, Teta] = COLORGRAD(RGB, T, option)
%   La funzione accetta l'immagine RGB in ingresso e ne calcola il
%    gradiente. La soglia T deve appartenere all'intervallo [0, 1].
%    Il parametro option puo' essere 'vect' (si ritorna in uno dei
%    casi precedenti) oppure 'wsum'. In questo caso viene calcolato
%    il gradiente come somma pesata di quelli dei singoli piani di
%    colore R, G e B dell'immagine da elaborare.
%   La matrice EffeTeta conterra' il modulo dei vettori di gradiente
%    per i punti in cui esso sia strettamente maggiore alla soglia T.
%   La matrice Teta conterra' invece l'angolo dei vettori gradiente.
%
% -- 
% Salvatore La Bua (slabua@gmail.com)
% DICGIM - University of Palermo

    rgb = double(rgb);
    sumType = 'vect';
    
    [rv, cv] = size(varargin);
    vararginElements = rv * cv;
    if (vararginElements == 0),
        T = 0;
    elseif ((vararginElements >= 1) & (vararginElements <= 2)),
        T = varargin{1};
        if ((T < 0) | (T > 1)),
            error('La soglia T deve essere in [0, 1].');
        end;
        if (vararginElements == 2),
            sumType = varargin{2};
        end;
    else,
        error('Troppi parametri.');
    end;
    
    R = rgb(:, :, 1);
    G = rgb(:, :, 2);
    B = rgb(:, :, 3);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Gradient using the 'gradient' Matlab funcion.
    % [Rx, Ry] = gradient(R);
    % [Gx, Gy] = gradient(G);
    % [Bx, By] = gradient(B);
    
    % Gradient using Sobel filtering.
    H_sobel = fspecial('sobel');
    V_sobel = H_sobel';
    
    Rx = imfilter(R, H_sobel);
    Ry = imfilter(R, V_sobel);
    Gx = imfilter(G, H_sobel);
    Gy = imfilter(G, V_sobel);
    Bx = imfilter(B, H_sobel);
    By = imfilter(B, V_sobel);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if (sumType == 'vect'),
        % Sezione relativa alla scelta di calcolo del gradiente vettoriale.
        
        gxx = (Rx .^ 2) + (Gx .^ 2) + (Bx .^ 2);
        gxy = (Rx .* Ry) + (Gx .* Gy) + (Bx .* By);
        gyy = (Ry .^ 2) + (Gy .^ 2) + (By .^ 2);
        
        % S. Di Zenzo
        lambda1 = 0.5 * (gxx + gyy + sqrt( ((gxx - gyy) .^ 2) + (4 * (gxy .^ 2)) ));
        lambda2 = 0.5 * (gxx + gyy - sqrt( ((gxx - gyy) .^ 2) + (4 * (gxy .^ 2)) ));
        
        % Slides
        % lambda = sqrt( 0.5 * ( (gxx + gyy) + ((gxx - gyy) .* cos(2 * teta)) + (2 * gxy .* sin(2 * teta)) ) );
        
        % E' possibile scegliere tra le due alternative ma il risultato non cambia
        %  poiche' successivamente si normalizza alla gamma dinamica [0, 1].
        mod1 = sqrt(lambda1 - lambda2);
        % mod2 = sqrt(lambda1);
        
        modNorm = mod1 / max(mod1(:));
        
    elseif (sumType == 'wsum'),
        % Sezione realtiva alla scelta di media pesata dei gradienti.
        
        gRxx = (Rx .^ 2);
        gRxy = (Rx .* Ry);
        gRyy = (Ry .^ 2);
        lambdaR = 0.5 * (gRxx + gRyy + sqrt( ((gRxx - gRyy) .^ 2) + (4 * (gRxy .^ 2)) ));
        
        gGxx = (Gx .^ 2);
        gGxy = (Gx .* Gy);
        gGyy = (Gy .^ 2);
        lambdaG = 0.5 * (gGxx + gGyy - sqrt( ((gGxx - gGyy) .^ 2) + (4 * (gGxy .^ 2)) ));
        
        gBxx = (Bx .^ 2);
        gBxy = (Bx .* By);
        gByy = (By .^ 2);
        lambdaB = 0.5 * (gBxx + gByy - sqrt( ((gBxx - gByy) .^ 2) + (4 * (gBxy .^ 2)) ));

        mod = sqrt(lambdaR + lambdaG + lambdaB);
        modNorm = mod / max(mod(:));
        
        % Le seguenti istruzioni sono state inserite per poter procedere ad
        %  un calcolo di teta; i risultati potrebbero essere non corretti.
        gxx = (gRxx + gGxx + gBxx) / 3;
        gxy = (gRxy + gGxy + gBxy) / 3;
        gyy = (gRyy + gGyy + gByy) / 3;
        
    end;
    
    % Elimina le divisioni per zero nel calcolo di teta.
    den = gxx - gyy;
    den(den == 0) = eps;
    % E' possibile scegliere tra le due alternative:
    teta1 = 0.5 * atan((2 * gxy) ./ den);
    teta2 = teta1 + (pi / 2);
    
    effeteta = modNorm .* (modNorm > T);
    teta = teta2;