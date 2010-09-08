(in-package :uncl)

(let ((r (copy-readtable nil)))
  (defun read-symbol (stream)
    (let ((*readtable* r))
      (set-macro-character #\] (get-macro-character #\)))
      (set-macro-character #\} (get-macro-character #\)))
      (read-preserving-whitespace stream))))

(defun double-dot-symbol (symbol)
  (cl-ppcre:register-groups-bind (st en)
      ("^(.+?)\\.\\.(.+?)$" (symbol-name symbol))
    `(range ,@(mapcar #'(lambda (s)
                          (or (parse-integer s :junk-allowed t)
                              (intern s)))
                      (list st en)))))

(defun symbol-reader-macro-reader (stream char)
  (unread-char char stream)
  (let ((s (read-symbol stream)))
    (acond2
     (not (symbolp s)) s
     (get s 'symbol-reader-macro) (funcall it stream s)
     (double-dot-symbol s) it
     t s)))

(defun set-macro-symbol (symbol readfn)
  (setf (get symbol 'symbol-reader-macro) readfn)
  t)

(defmacro define-macro-symbol (from to)
  `(set-macro-symbol ',from
                     #'(lambda (stream symbol)
                         (declare (ignore stream symbol))
                         ',to)))

(defparameter aliases
  '((def defvar)
    (call funcall)
    (y/n? y-or-n-p)
    (map mapcar)
    (append! nconc)
    (reverse! nreverse)
    (set! setf)
    (inc! incf)
    (dec! decf)
    (push! push)
    (pop! pop)
    (zero? zerop)
    (complex? complexp)
    (rational? rationalp)
    (real? realp)
    (float? floatp)
    (integer? integerp)
    (constant? constantp)
    (number? numberp)
    (plus? plusp)
    (minus? minusp)
    (even? evenp)
    (odd? oddp)
    (symbol? symbolp)
    (keyword? keywordp)
    (function? functionp)
    (string? stringp)
    (list? listp)
    (cons? consp)
    (array? arrayp)
    (vector? vectorp)
    ))

(defun defalias (to from)
  (cond
    ((macro-function from)
     (setf (macro-function to) (macro-function from)))
    ((symbol-function from)
     (setf (symbol-function to) (symbol-function from)))
    (t (define-macro-symbol from to))))

(defun init-readtable ()
  (map nil (lambda (c)
             (set-macro-character c #'symbol-reader-macro-reader t))
       "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@$%^&_=+-*/|:<>.?0123456789")

  ;; special forms
  (define-macro-symbol if aif)
  (define-macro-symbol cond acond2)
  (define-macro-symbol fn lambda)
  (define-macro-symbol let let2)
  (define-macro-symbol let* let2*)

  ;; functions
  (dolist (alias aliases)
    (apply #'defalias alias))

  (enable-escape-sequence))
