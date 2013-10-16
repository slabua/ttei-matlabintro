function IM = progetto2(im, action, scale)
% progetto2(im, action, scale)
%
% im: matrice dell'immagine.
% action: ['s' | 'z']
%  's' per shrinking, 'z' per zooming.
% scale: fattore di scala.

    [r, c] = size(im);
    
    if (action == 's'),
        IM = im(1 : scale : r, 1 : scale : c);
    else (action == 'z'),
        r2 = r * scale;
        c2 = c * scale;
        
        factor = ones(scale, 1);
        
        pre = eye(r);
        pre = pre(:)';
        pre = reshape(factor * pre, r2, r);
        
        post = eye(c);
        post = post(:)';
        post = reshape(factor * post, c2, c)';
        
        IM = uint8(pre * double(im) * post);
    end;