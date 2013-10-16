ttei-matlabintro
================

Salvatore La Bua (slabua@gmail.com)  
DICGIM - University of Palermo

---

Introduction to Matlab through simple exercises for the 2004/2005 Digital Image Processing course.

* This repository contains ten (10) projects assigned to students during the Academic year 2004/2005 for the Digital Image Processing course, in order to get the initial grasp of Matlab and implement some of the algorithms and techniques introduced in the course programme.
 * The assignment abstracts are reported below in italian language only.
 * The code provided is a personal implementation for each of the assignments listed below.

* Questo repository contiene dieci (10) progetti assegnati agli studenti durante l'anno accademico 2004/2005 per il corso di Teoria e Techniche di Elaborazione delle Immagini Digitali, al fine di sviluppare la praticità iniziale con Matlab ed implementare alcuni algoritmi e tecniche introdotte nel programma del corso.
 * Il codice fornito è una personale implementazione dei progetti assegnati ed elencati sotto.

Progetto n. 1
-------------
Le immagini "lena_256.bmp" e "peppers_256.bmp" hanno dimensioni 256 x 256 pixel, con profondità di 8 bit/pixel.  
Dopo averle visualizzate, costruire e visualizzare una nuova immagine, J, tale che la sua metà di sinistra, cioè le colonne dalla 1 alla 128, sia uguale alla metà di sinistra dell’immagine Lena, mentre la metà di destra, cioè le colonne dalla 129 alla 256, sia uguale alla metà di destra dell’immagine Peppers.
* (a) Calcolare e visualizzare l’istogramma di J. Costruire quindi e visualizzare una nuova immagine, K, scambiando tra di loro la metà di sinistra e la metà di destra di J.
* (b) Calcolare e visualizzare l’istogramma di K. Discutere brevemente la relazione tra gli istogrammi di J e K.

Progetto n. 2
-------------
* (a) Scrivere una funzione Matlab capace di effettuare lo zooming e lo shrinking di una immagine, utilizzando il metodo della replica dei pixel. Il fattore di zoom/shrink (che si suppone intero) è fornito in input alla funzione, insieme all’immagine da elaborare.
* (b) Utilizzare la funzione di cui al punto a) per contrarre l’immagine rose_1024.jpg da 1024 x 1024 a 256 x 256 pixels.
* (c) Utilizzare la funzione di cui al punto a) per magnificare l’immagine ottenuta al punto b) a 1024 x 1024. Confrontare il risultato con l’immagine originale e motivare le differenze.

Progetto n. 3
-------------
* (a) Scrivere una funzione Matlab capace di effettuare lo zooming e lo shrinking di una immagine, utilizzando il metodo dell’interpolazione lineare. Le dimensioni finali (orizzontale e verticale) dell’immagine sono fornite in input alla procedura, insieme all’immagine da elaborare.
* (b) Utilizzare la funzione di cui al punto a) per contrarre l’immagine rose_1024.jpg da 1024 x 1024 a 256 x 256 pixels.
* (c) Utilizzare la funzione di cui al punto a) per magnificare l’immagine ottenuta al punto b) a 1024 x 1024. Confrontare il risultato con l’immagine originale e motivare le differenze.

Progetto n. 4
-------------
Visualizzare l’immagine binaria (pixel di sfondo a 0) "blood_cells.tiff".  
L’immagine contiene delle cellule, che occorre classificare come:
* normali (tipo 1), se circolari e con nucleo;
* sovrapposte (tipo 2), se circolari e con più di un nucleo;
* sconosciute (tipo 3), in tutti gli altri casi.

Poiché le cellule sono rappresentate da componenti connesse dell’immagine, eventualmente contenenti una o più cavità, la procedura consigliata prevede il labeling preliminare di tutte le componenti connesse dell’immagine (suggerimento: utilizzare il comando bwlabel di Matlab), seguita dalla eliminazione (pixel a colore di sfondo) di quelle che toccano i bordi dell’immagine e
di quelle di dimensione molto piccola (suggerimento: basarsi sul numero di pixel di valore 1 presenti in ogni componente connessa).  
Conclusa questa fase di preprocessing, le componenti connesse superstiti possono essere classificate secondo i criteri citati. A tal fine, poiché il nucleo di una cellula corrisponde ad una cavità presente all’interno di una componente connessa, occorre analizzare ciascuna componente connessa per valutarne la "circolarità" e il numero di cavità.
* Se la componente connessa è circolare e possiede esattamente una cavità, la cellula corrispondente può essere classificata di tipo 1.
* Se la componente connessa è circolare ed esibisce più di una cavità, la cellula corrispondente è di tipo 2.
* In tutti gli altri casi, la cellula è di tipo 3.

Pertanto, per ogni componente connessa devono essere eseguite le seguenti operazioni:
* A. Isolare la componente connessa presa in considerazione e contarne le cavità (suggerimento: se f è l’immagine binaria relativa alla sola componente connessa considerata, il numero delle sue cavità è uguale al numero delle componenti connesse del complemento di f meno 1).  
Se f ha almeno una cavità, occorre testarne la circolarità (se f non ha cavità, la cellula è di tipo 3).
* B. (Test di circolarità):
 * (a) Riempire le cavità di f (suggerimento: utilizzare il comando bwfill di Matlab), ottenendo l’immagine g. L’area A ed il perimetro P di g possono essere utilizzate per determinarne la circolarità.
 * (b) Il numero di pixel di g con valore 1 è l’area A.
 * (c) Il boundary di g può essere ottenuto utilizzando il comando h = bwperim(g). Il numero di pixel di valore 1 di h è il perimetro P della cellula.
 * (d) Per una regione perfettamente circolare (nel continuo) si dovrebbe avere: ρ = P²/A = 4π.
In generale, per una regione connessa (nel continuo) si ha ρ ≥ 4π. Pertanto, se il rapporto ρ /(4π) risulta maggiore di una certa soglia, la regione può essere considerata non circolare (suggerimento: utilizzare una soglia pari a 1).
* C. Se il test di circolarità non è soddisfatto, la cellula è di tipo 3. Altrimenti può essere classificata di tipo 1 (se ha solo una cavità) o di tipo 2 (se ha più di una cavità).

Il risultato della classificazione deve essere una immagine contenente tutte e solo le regioni corrispondenti a componenti non eliminate durante la fase di preprocessing, rappresentate con tre livelli di grigio o colori differenti, in modo da evidenziare l’appartenenza di ogni cellula a una delle tre classi (suggerimento: scegliere tre livelli di grigio o colori facilmente distinguibili).

Progetto n. 5
-------------
* (a) Scrivere una unica funzione Matlab capace di effettuare su una immagine di ingresso una delle seguenti trasformazioni di intensità, a seconda del valore di uno degli argomenti di input:
 * negativo (‘neg’): s = L – 1 – r, con 0 <= r <= L – 1;
 * log (‘log’): s = clog(1 + r ), con c costante e r >= 0;
 * gamma (‘gamma’): s = cr^γ, con c e γ costanti e 0 <= r <= L – 1;
 * stretching (‘stretch’): s = 1 / (1 + (m/r)^E), con m (soglia) e E (pendenza) costanti e 0 <= r <= L – 1.

Si noti che l’immagine di ingresso può essere di classe uint8 o double, e che l’immagine di uscita deve essere della stessa classe dell’immagine di ingresso (suggerimento: utilizzare la funzione class
di Matlab).  
L’immagine di ingresso è il primo degli argomenti di input, il tipo di trasformazione è il secondo argomento. Poiché alcune delle trasformazioni richiedono in ingresso altri parametri (c per la log, c e γ per la gamma, m e E per lo stretching), la funzione da scrivere deve poter accettare in ingresso un numero differente di argomenti, a seconda del tipo di trasformazione da effettuare (suggerimento: utilizzare la funzione varargin di Matlab).
* (b) Utilizzare la funzione di cui al punto a) per migliorare la qualità delle immagini spine.jpg e bone-scan.tif, con l’obiettivo di ottenere il miglior risultato visuale possibile per ciascuna delle trasformazioni. Discutere le eventuali differenze tra i risultati ottenuti.

Progetto n. 6
-------------
* (a) Scrivere una unica funzione Matlab capace di effettuare su due immagini di ingresso una delle quattro operazioni aritmetiche, a seconda del valore di uno degli argomenti di input. L’uscita deve essere una immagine dello stesso tipo di quelle di ingresso (uint8, uint16 o double), con appropriato scaling del risultato delle operazioni aritmetiche.
* (b) Scrivere una funzione Matlab per il filtraggio spaziale dell’immagine di ingresso. La dimensione del filtro può essere 3 x 3, 5 x 5 o 7 x 7, a seconda del valore di uno degli argomenti di input. I coefficienti del filtro devono essere accettati in input dall’utente. L’uscita deve essere una immagine dello stesso tipo di quelle di ingresso (uint8, uint16 o double).
* (c) Utilizzare la funzione di cui al punto precedente per implementare le tecniche di enhancement basate sul laplaciano e di high-boost studiate a lezione.
* (d) Applicare le tecniche di cui al punto precedente per migliorare la qualità di almeno due delle immagini presenti nel database, con l’obiettivo di ottenere il miglior risultato visuale possibile per ciascuna delle tecniche. Discutere le differenze tra i risultati ottenuti, al variare delle caratteristiche dei filtri adoperati.

Progetto n. 7
-------------
* (a) Scrivere la funzione Matlab hsi = rgb2hsi(rgb) per implementare la conversione di una immagine M x N a colori dallo spazio RGB allo spazio HSI, utilizzando le equazioni di mapping studiate a lezione. L’immagine di ingresso (uint8, uint16 o double) è un array M x N x 3, con la terza dimensione rappresentativa, nell’ordine, dei piani R, G e B. L’immagine di uscita (double, con valori in [0, 1]) è un array M x N x 3, con la terza dimensione rappresentativa, nell’ordine, dei piani H, S e I.
* (b) Scrivere la funzione Matlab rgb = hsi2rgb(hsi) per implementare la conversione di una immagine M x N a colori dallo spazio HSI allo spazio RGB, utilizzando le equazioni di mapping studiate a lezione. L’immagine di ingresso (double, con valori in [0, 1]) è un array M x N x 3, con la terza dimensione rappresentativa, nell’ordine, dei piani H, S e I. L’immagine di uscita (double, con valori in [0, 1]) è un array M x N x 3, con la terza dimensione rappresentativa, nell’ordine, dei piani R, G e B.
* (c) Utilizzare la funzione di cui al punto (a) per generare le componenti H, S e I di almeno due delle immagini a colori presenti nel database e confrontare le immagini così ottenute con le componenti HSV ottenibili applicando la funzione esistente rgb2hsv. Discutere le differenze.

Progetto n. 8
-------------
* (a) Utilizzando le tecniche viste a lezione, scrivere la funzione Matlab:  
[effeteta, teta] = colorgrad(rgb, T)  
per implementare il gradiente vettoriale per immagini RGB. rgb è l’immagine di ingresso (double, con valori in [0, 1]), T è un valore di soglia (default = 0) in [0, 1]. Le uscite (double) effeteta e teta sono, rispettivamente, il modulo e la direzione, espressa in radianti, del gradiente vettoriale RGB. I valori di effeteta sono in [0,1]. Per l’implementazione delle derivate si utilizzino le maschere di Sobel. La soglia T si applica ponendo effeteta(x, y) = 0 nei punti in cui effeteta è minore o uguale a T.
* (b) Applicare la funzione di cui al punto (a) per estrarre i contorni di almeno due delle immagini a colori presenti nel database, per diversi valori della soglia T. Discutere i risultati.
* (c) Confrontare i risultati del punto precedente con quelli che si ottengono calcolando il gradiente di colore come somma (normalizzata in [0, 1]) dei gradienti delle tre immagini di intensità R, G e B. Utilizzare anche in questo caso le maschere di Sobel per l’implementazione delle derivate. Effettuare i confronti a parità di valore di soglia.

Progetto n. 9
-------------
* (a) Scrivere la funzione Matlab noiseim = createnoise(type, M, N, Pa, Pb) per generare l’immagine di rumore noiseim di dimensione M x N, i cui elementi sono numeri del tipo specificato dall’argomento type, con i parametri a e b. In particolare:
 * Se type = ‘salt & pepper’, noiseim è un array di numeri casuali di ampiezza 0 con probabilità Pa e ampiezza 1 con probabilità Pb. I valori di default sono Pa = Pb = 0.05. Si intende che gli elementi di imnoise non uguali a 0 o a 1 vanno posti ad un valore convenzionale (per esempio 0.5) che corrisponde ad assenza di rumore.
 * Se type = ‘gaussian’, noiseim è un array di numeri casuali con distribuzione gaussiana con media Pa e deviazione standard Pb. I valori di default sono Pa = 0, Pb = 1.
 * Se type = ‘periodic’, noiseim è un pattern spaziale di rumore sinusoidale. Pa è in questo caso un array k x 2 che contiene k coppie di coordinate del piano u, v che rappresentano le locazioni degli impulsi di rumore nel piano delle frequenze, riferite al centro del piano delle frequenze (M/2 + 1, N/2 + 1). Pb è un vettore 1 x k contenente le ampiezze degli impulsi.
* (b) Utilizzare la funzione di cui al punto (a) per corrompere almeno due delle immagini a livelli di grigio presenti nel database del corso, utilizzando in maniera appropriata il modello di degrado semplificato g(x,y) = f(x,y) + η(x,y). Discutere i risultati ottenuti, al variare dei parametri di rumore, e confrontarli con quelli ottenibili con la funzione Matlab IPT imnoise, se applicabile.
* (c) Progettare e implementare dei filtri adattivi appropriati per la riduzione del rumore gaussiano e impulsivo, e un filtro per la riduzione del rumore periodico. Applicare i filtri alle immagini rumorose di cui al punto (b) e discutere i risultati ottenuti, al variare dei parametri di rumore e delle caratteristiche dei filtri.

Progetto n. 10
--------------
* (a) Implementare una procedura di template matching, sia utilizzando elaborazioni tradizionali sia utilizzando elaborazioni morfologiche, ed applicarla alle immagini ukt.jpg e bigtee.jpg (che funge da template) presenti nel database del corso. Confrontare i risultati ottenuti nei due casi, evidenziando analogie e differenze.
* (b) Data l’immagine particles.jpg presente nel database del corso, nella quale si suppone che tutte le particelle abbiano la stessa dimensione, implementare un algoritmo morfologico capace di produrre tre immagini distinte, costituite rispettivamente dalle:
 * Sole particelle che toccano il bordo;
 * Sole particelle parzialmente sovrapposte (due o più);
 * Sole particelle non sovrapposte.
