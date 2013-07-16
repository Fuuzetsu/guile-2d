(use-modules (figl gl)
             (srfi srfi-1)
             (srfi srfi-9)
             (srfi srfi-42)
             (ice-9 format)
             (2d sprite)
             (2d game-loop)
             (2d window)
             (2d vector)
             (2d input)
             (2d helpers)
             (2d coroutine))

(define window-width 800)
(define window-height 600)
(define sprite #f)

(define (key-down key mod unicode)
  (cond ((any-equal? key (keycode escape) (keycode q))
         (close-window)
         (quit))))

;; Draw our sprite
(define (render)
  (draw-sprite sprite))

;; Register callbacks.
(set-render-callback (lambda () (render)))
(set-key-down-callback (lambda (key mod unicode) (key-down key mod unicode)))

;; Open the window.
(open-window window-width window-height)

;; Load a sprite and center it on the screen.
(set! sprite (load-sprite "images/sprite.png" #:position (vector (/ window-width 2)
                                                                 (/ window-height 2))))

;; Simple script that moves the sprite to a random location every
;; second.
(coroutine
  (while #t
    (set-sprite-position! sprite (vector (random window-width)
                                         (random window-height)))
    (wait 60)))

(run-game-loop)
