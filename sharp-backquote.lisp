(in-package :uncl)

(defun sharp-backquote-reader (stream sub-char numarg)
  (declare (ignore sub-char))
  (unless numarg (setq numarg 1))
  `(lambda ,(loop for i from 1 to numarg
               collect (symb '$ i))
     ,(funcall
       (get-macro-character #\`) stream nil)))
