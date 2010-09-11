(in-package :uncl)

(defun string-reader (stream char)
  (let ((*stream* stream)
        (*start-char* char)
        (*term-char* char)
        (*pair-level* 0)
        (*inner-delimiters* nil)
        *saw-backslash*
        *readtable-copy*)
    (prog1 
        (inner-reader nil nil nil nil)
      (read-char*))))

(defun %enable-escape-sequence ()
  (push *readtable*
        *previous-readtables*)
  (setq *readtable* (copy-readtable))
  (set-macro-character #\" #'string-reader)
  (values))

(defun %disable-escape-sequence ()
  (if *previous-readtables*
    (setq *readtable* (pop *previous-readtables*))
    (setq *readtable* (copy-readtable nil)))
  (values))

(defmacro enable-escape-sequence ()
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     (%enable-escape-sequence)))

(defmacro disable-escape-sequence ()
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     (%disable-escape-sequence)))
