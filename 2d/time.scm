;;; guile-2d
;;; Copyright (C) 2013 David Thompson <dthompson2@worcester.edu>
;;;
;;; Guile-2d is free software: you can redistribute it and/or modify it
;;; under the terms of the GNU Lesser General Public License as
;;; published by the Free Software Foundation, either version 3 of the
;;; License, or (at your option) any later version.
;;;
;;; Guile-2d is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; Lesser General Public License for more details.
;;;
;;; You should have received a copy of the GNU Lesser General Public
;;; License along with this program.  If not, see
;;; <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Time-based signals.
;;
;;; Code:

(define-module (2d time)
  #:use-module (2d agenda)
  #:use-module (2d coroutine)
  #:use-module (2d signals)
  #:export (time-every
            time-each
            time-delay))

(define (time-every agenda delay value)
  "Create a new signal that emits VALUE every DELAY ticks of AGENDA.
VALUE may be a signal, in which case the stored value of the signal
will be emitted."
  (let ((ticker (make-root-signal (signal-ref-maybe value))))
    (define (tick)
      (signal-set! ticker (signal-ref-maybe value)))
    (schedule-interval agenda tick delay)
    ticker))

(define (time-each agenda value)
  "Create a new signal that emits VALUE every agenda update."
  (time-every agenda 1 value))

(define (time-delay agenda delay signal)
  "Create a new signal that delays propagation of values received from
SIGNAL by DELAY ticks of AGENDA."
  (make-signal (signal-ref signal)
               (colambda (self from)
                 (let ((value (signal-ref from)))
                   (wait agenda delay)
                   (signal-set! self value)))
               (list signal)))
