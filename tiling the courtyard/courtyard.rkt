#lang racket
(require 2htdp/image)

#|-------------------------------------------------------------------------------
 | Name: ---
 | Pledge: I pledge my honor that I have abided by the Stevens Honor System.
 |-------------------------------------------------------------------------------|#


#|-------------------------------------------------------------------------------|
 |                       Lab Ex: Tiling the Courtyard                            |
 |-------------------------------------------------------------------------------|#

#|
|          Tiling the Couryard Ex:
|
|   Goal: Implement courtyard problem to work for at least P(7) in under 10 seconds
|   
|   Proof:
|   P(n): 2^n x 2^n courtyard with one hole can be tiled using triominoes
|   for all n that are positive integers
|
|   Basis: P(0) = 2^0 x 2^0 = 1x1, which is just a 1x1 grid with the one hole (TRUE)
|
|   P(1) = 2^1 x 2^1 = 2x2, which is a hole on any of the 4 quadrants, with a triomino filling the rest of the grid
|#

;variable size for squares
(define control-size 10)

;Makes a square with an input color
;Type signature (mk-sq str) -> image
(define (mk-sq col) (square control-size "solid" col))

;short form of 3 colors (red, blue, green, brown)
(define mk-rd (mk-sq "red"))
(define mk-bl (mk-sq "blue"))
(define mk-gr (mk-sq "green"))
(define mk-yl (mk-sq "yellow"))
(define mk-or (mk-sq "orange"))


(define mk-pr (mk-sq "purple"))
(define mk-br (mk-sq "brown"))
(define mk-bk (mk-sq "black"))
(define mk-wh (mk-sq "white"))

(define empty-sq mk-wh) ;empty square
(define hole-sq mk-br) ;square for hole
(define fill-sq mk-pr) ;filler square

;test for mk-row (shows a row of 3 squares, red->blue->green)
(define squares (list mk-rd mk-bl mk-gr) )

;Displays row, given a list of images
;Type signature (mk-row lst[image]) -> prints row of images
(define (mk-row lst)
  (if (= 1 (length lst)) (car lst) (beside (car lst) (mk-row (cdr lst))) ))

;test for mk-grid (shows a 3x3 grid,
; row 1: red->blue->green
; row 2: green->red->blue
; row 3: blue->green->red
(define squares-grid (list (list mk-rd mk-bl mk-gr)
                           (list mk-gr mk-br mk-bl)
                           (list mk-bl mk-gr mk-rd)) )

;Displays grid, given a list of list of images
; Type signature (mk-grid lst[lst[image]]) ->prints grid of images
(define (mk-grid lst)
  (if (= 1 (length lst)) (mk-row (car lst)) (above (mk-row (car lst)) (mk-grid (cdr lst)))))


;Sets square on grid at (x, y) to new square (image)
(define (set-grid lst x y image)
  
  (list-set lst y (list-set (list-ref lst y) x image) ))


#| (UNUSED FUNCTION)
| Places triomino on grid
|
| Consider the top left as (x y) and bottom right as (x+1, y+1)
|
| dir:
| 0 ->  *
|      **
|
| 1 -> *
|      **
|
| 2 -> **
|      *
|
| 3 -> **
|       *
|
| Notice that each consecutive dir is just a clockwise rotation of the previous
|
| Ex:
| (mk-grid (place-tri squares-grid 0 0 0 mk-wh))
| (mk-grid (place-tri squares-grid 0 0 1 mk-wh))
| (mk-grid (place-tri squares-grid 0 0 2 mk-wh))
| (mk-grid (place-tri squares-grid 0 0 3 mk-wh))
|
|#
; Type signature (place-tri grid x y dir col) -> places triomino on grid
(define (place-tri lst x y dir col)
  (cond [(= dir 0) (set-grid (set-grid (set-grid lst (+ x 1) y col) x (+ y 1) col) (+ x 1) (+ y 1) col)]
        [(= dir 1) (set-grid (set-grid (set-grid lst x y col) x (+ y 1) col) (+ x 1) (+ y 1) col)]
        [(= dir 2) (set-grid (set-grid (set-grid lst x y col) x (+ y 1) col) (+ x 1) y col)]
        [(= dir 3) (set-grid (set-grid (set-grid lst x y col) (+ x 1) y col) (+ x 1) (+ y 1) col)]))


; Generates grid of n x n
(define (gen-grid n)
  (define (gen-helper n n-copy)
    (if (= n 0) '() (cons (make-list n-copy empty-sq) (gen-helper (- n 1) n-copy) ))
    )

  (gen-helper n n))

; Generates grid of 2^n x 2^n
; Ex:
; (mk-grid (gen-court 1))
; "Solved couryard" (mk-grid (set-grid (place-tri (gen-court 1) 0 0 0 mk-rd) 0 0 mk-br))
(define (gen-court n)
  (gen-grid (expt 2 n)))


; Checks if court is complete
; Ex:
; "Solved couryard" (full-court? (set-grid (place-tri (gen-court 1) 0 0 0 mk-rd) 0 0 mk-br)) -> #t
; "Couryard w/o single dot" (full-court? (place-tri (gen-court 1) 0 0 0 mk-rd)) -> #f
(define (full-court? grid)
  (if (empty? grid) #t (if (list? (member empty-sq (car grid))) #f (full-court? (cdr grid)) ) ))

; Checks if court is empty
; Ex:
; (empty-court?  (gen-court 3)) -> #t
; (empty-court? (set-grid (place-tri (gen-court 1) 0 0 0 mk-rd) 0 0 mk-br)) -> #f
(define (empty-court? grid)
  (null? (remove (apply append grid) (list empty-sq)))

  )

;Remove function for reduce
(define (remove L R)
  (define (recurse acc L)
    (if (null? L) (reverse acc)
        (recurse (if (member (car L) R)
                     acc
                     (cons (car L) acc))
                 (cdr L))))
  (recurse '() L))

;Reduce function
(define (reduce cnd lst)
  (remove (map cnd lst) (list #f)))


; gets index a
; Ex:
; (indx (list  1 2 3 4 5) 2) -> 3
(define (indx lst a)
  (car (remove (map (lambda (x y) (if (= x a) y #f )) (range (length lst)) lst) (list  #f)))

  )

; gets sublist (a ... b)
; Ex:
; (get-sublist (list  1 2 3 4 5) 0 2) -> '(1 2 3)
(define (get-sublist lst a b)
  (remove (map (lambda (x y) (if (and (<= x b) (>= x a)) y #f )) (range (length lst)) lst) (list  #f))

  )

; gets submatrix (a ... b) x (c ... d)
; Ex:
; (mk-grid (get-submatrix squares-grid 0 1 0 1)) -> row 1: (red->blue), row 2: (green->brown) 
(define (get-submatrix lst a b c d)
  (remove (map (lambda (x y) (if (and (<= x d) (>= x c)) (get-sublist y a b) #f )) (range (length lst)) lst) (list  #f))
  )

; Split court into 4 pieces (assuming court is even length/width)
; 1/2  1
;  a | b  1/2
; -------
;  c | d  1
;
; a -> (0 1/2) x (0 1/2)
; b -> (1/2 1) x (0 1/2)
; c -> (0 1/2) x (1/2 1)
; d -> (1/2 1) x (1/2 1)
;
; Ex:
; (split-court (gen-court 2)) -> (list (list empty-sq empty-sq empty-sq empty-sq)*), *done 4 times
; (split-court (set-grid (place-tri (gen-court 1) 0 0 0 mk-rd) 0 0 mk-br)))
; (split-court (get-submatrix squares-grid 0 1 0 1)) -> (list red blue list green brown)
(define (split-court grid)
  (define len-grid (length grid))

  (define quad-a (get-submatrix grid 0 (- (/ len-grid 2) 1) 0 (- (/ len-grid 2) 1)))
  
  (define quad-b (get-submatrix grid (/ len-grid 2) len-grid 0 (- (/ len-grid 2) 1)))
  
  (define quad-c (get-submatrix grid 0 (- (/ len-grid 2) 1) (/ len-grid 2) len-grid))
  
  (define quad-d (get-submatrix grid (/ len-grid 2) len-grid (/ len-grid 2) len-grid))

  (list quad-a quad-b quad-c quad-d))

; Given a set of quads that has a hole in one of them, fill the middle of the to-be combined court if there is no hole in the quad
; only takes courts of > 4x4
; (filler-triomino (split-court (set-grid (gen-court 2) 0 0 hole-sq))) -> row 1: (hole, wh, wh, wh), (wh, wh, fill, wh), (wh, fill, fill, wh), (wh, wh, wh, wh)
; NOTE: col default value is fill-sq
(define (filler-triomino quads [col fill-sq])
  (define len-quad (length (car quads)))

  (list 
  (if (empty-court? (indx quads 0)) (set-grid (indx quads 0) (- len-quad 1) (- len-quad 1) col) (indx quads 0))
  (if (empty-court? (indx quads 1)) (set-grid (indx quads 1) 0 (- len-quad 1) col) (indx quads 1))
  (if (empty-court? (indx quads 2)) (set-grid (indx quads 2) (- len-quad 1) 0 col) (indx quads 2))
  (if (empty-court? (indx quads 3)) (set-grid (indx quads 3) 0 0 col) (indx quads 3))
  )
  
  )

; Does filler-triomino but takes a whole court instead
(define (filler-triomino-c court [col fill-sq])
  (combine-quads (filler-triomino (split-court court) col)))

; Combines quads to make a court
; Ex
; (mk-grid (combine-quads (split-court (set-grid (gen-court 2) 0 0 hole-sq))))
; (mk-grid (combine-quads (filler-triomino (split-court (set-grid (gen-court 1) 0 0 hole-sq)))))
; (mk-grid (combine-quads (filler-triomino (split-court (set-grid (gen-court 2) 0 0 hole-sq)))))
; (mk-grid (combine-quads (filler-triomino (split-court (set-grid (gen-court 3) 0 0 hole-sq)))))
(define (combine-quads quads)
  (define len-quad (length (car quads)))

  (define (combine-help n qd1 qd2)
    (map (lambda (x) (append (indx qd1 x) (indx qd2 x))) (range n))

    )

  
  (define result-top (combine-help len-quad (indx quads 0) (indx quads 1)))
  (define result-bottom (combine-help len-quad (indx quads 2) (indx quads 3)))
  
  (append result-top result-bottom)
)

#|
| Solve courtyard for P(n)
|
| P(n): 2^n x 2^n courtyard
|
| Algorithm works as such:
| 1) Place one-piece in a location
| 2) split court into quads, put triomino in quad that does not contain one-piece/filler square
| 3) repeat step 2 till the problem becomes small grids of P(1)
| 4) fill P(1)'s
| 5) combine courtyard, problem solved
|
| Note: (x y) are points that must EXIST on the court otherwise out of bounds error
|
| Ex:
| P(0): (mk-grid (solve-courtyard 0 0 0)) -> sets one-piece at (0 0) and solves for P(0)
| P(1): (mk-grid (solve-courtyard 1 1 0)) -> sets one-piece at (1 0) and solves for P(1)
| P(2): (mk-grid (solve-courtyard 2 1 0)) -> sets one-piece at (1 0) and solves for P(2)
| P(3): (mk-grid (solve-courtyard 3 1 0)) -> sets one-piece at (1 0) and solves for P(3)
| P(4): (mk-grid (solve-courtyard 4 1 0)) -> sets one-piece at (1 0) and solves for P(4)
| P(7): (mk-grid (solve-courtyard 7 1 0)) -> sets one-piece at (1 0) and solves for P(7)
|
| ...
| P(n): (solve-courtyard n x y) -> sets one-piece at (x y) and solves for P(n)
|#
; Type signature (solve-courtyard n x y) -> completed courtyard

(define (solve-courtyard n x y)
  (define temp-court (set-grid (gen-court n) x y hole-sq))

  ;Combines until it is a court
  (define (combine-till result)
      (if (list? (caar result)) (combine-till (combine-quads result)) result))

  ;Implements algorithm stated above
  (define (solve-recurse n col result)
    
    (cond [(= n 2) (filler-triomino-c result col)]
          [else

           (combine-till (list (solve-recurse (/ n 2) mk-rd (indx (split-court (filler-triomino-c result fill-sq)) 0))
                      (solve-recurse (/ n 2) mk-bl (indx (split-court (filler-triomino-c result fill-sq)) 1))
                      (solve-recurse (/ n 2) mk-gr (indx (split-court (filler-triomino-c result fill-sq)) 2))
                      (solve-recurse (/ n 2) mk-yl (indx (split-court (filler-triomino-c result fill-sq)) 3)) ))])
    )
  
  (cond [(= (expt 2 n) 1) temp-court] ;P(0) Case
        [(= (expt 2 n) 2) (filler-triomino-c temp-court fill-sq)] ;P(1) Case
        [else

         
         (combine-till (solve-recurse (expt 2 n) mk-rd (filler-triomino-c temp-court fill-sq))) ;P(n) case
         ])





  )












