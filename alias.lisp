(in-package :uncl)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (let ( (r (copy-readtable nil)) )
    (defun read-symbol (stream)
      (let ( (*readtable* r) )
        (read-preserving-whitespace stream))))

  (defun symbol-reader-macro-reader (stream char)
    (unread-char char stream)
    (let* ((s (read-symbol stream))
           (f (get s 'symbol-reader-macro)))
      (if f (funcall f stream s) s)))

  (defun set-macro-symbol (symbol readfn)
    (setf (get symbol 'symbol-reader-macro) readfn)
    t)

  (defmacro define-macro-symbol (from to)
    `(set-macro-symbol ',from
                       #'(lambda (stream symbol)
                           (declare (ignore stream symbol))
                           ',to))))

(defparameter p-symbols
  '(slot-exists-p complexp arrayp tailp oddp listp rationalp zerop
    symbolp char-greaterp interactive-stream-p random-state-p
    adjustable-array-p string-not-greaterp
    standard-char-p consp readtablep packagep realp alphanumericp
    plusp digit-char-p evenp special-operator-p string-lessp
    char-not-lessp vectorp both-case-p graphic-char-p endp pathnamep
    string-greaterp numberp wild-pathname-p array-in-bounds-p
    characterp char-not-greaterp logbitp simple-vector-p
    boundp typep hash-table-p stringp pathname-match-p
    slot-boundp array-has-fill-pointer-p integerp
    simple-bit-vector-p alpha-char-p fboundp
    upper-case-p subsetp subtypep output-stream-p open-stream-p
    simple-string-p floatp char-lessp constantp
    string-not-lessp streamp lower-case-p compiled-function-p
    input-stream-p functionp keywordp equalp minusp bit-vector-p))

(defun init-readtable ()
  (map nil (lambda (c)
             (set-macro-character c 'symbol-reader-macro-reader t))
       "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_")

  (dolist (p-symb p-symbols)
    (let ((q-symb (symb (#~s/-?[pP]$/?/ (symbol-name p-symb)))))
      (setf (symbol-function q-symb) (symbol-function p-symb))))

  (setf (symbol-function 'y/n?) (symbol-function 'y-or-n-p))
  (define-macro-symbol if aif)
  (define-macro-symbol fn lambda)
  (define-macro-symbol defmacro defmacro!)

  (enable-escape-sequence))
