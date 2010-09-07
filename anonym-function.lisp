(in-package :uncl)

(defun anonym-function (stream char)
  (declare (ignore char))
  `(lambda (,(intern "_" *package*)) ,(read-delimited-list #\] stream t)))

(set-macro-character #\[ #'anonym-function)
(set-macro-character #\] (get-macro-character #\)))
