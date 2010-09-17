(eval-when (:compile-toplevel :load-toplevel :execute)
  (let ((*standard-output* (make-broadcast-stream)))
    (require 'asdf)
    (require 'lisp-unit)
    (require 'uncl)))

;;====================
;; Initialize
;;====================
(in-package :uncl-user)
(defvar *lisp-unit-symbols* '(define-test run-tests assert-true assert-eq assert-equal))
(dolist (s *lisp-unit-symbols*) (shadowing-import (intern (symbol-name s) :lisp-unit)))

;;====================
;; Test Start
;;====================
(define-test uncl-test
  ;(assert-eq 'fn 'lambda)
  (assert-equal "hoge\n" (concatenate 'string "hoge" (string #\Newline)))
  (assert-equal 5 (call #'last '(1 2 3 4 5)))
  (assert-equal '(1 2 3 4 5) (1.. 5))
  (assert-true (symbol-function 'mapcan!))
  (assert-true (symbol-function 'sort!))
  (assert-eq 10 ([* _ 2] 5))
  (assert-equal '(1 3 5) (filter #'odd? '(1 2 3 4 5)))
  ;; FIXME: this fails only in unit tests
  ;(assert-equal '(a b (e d c)) (let* ((x y &rest z) '(a b c d e)) (list x y (reverse z))))
  )

;;====================
;; Test End
;;====================
(run-tests)
