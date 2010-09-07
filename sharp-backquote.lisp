(in-package :uncl)

(defun |#`-reader| (stream sub-char numarg)
  "from Let Over Lambda"
  (declare (ignore sub-char))
  (unless numarg (setq numarg 1))
  `(lambda ,(loop for i from 1 to numarg
               collect (symb '$ i))
     ,(funcall
       (get-macro-character #\`) stream nil)))

(set-dispatch-macro-character #\# #\` #'|#`-reader|)
