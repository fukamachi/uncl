(in-package :uncl)

(defun anonym-function (stream char)
  (declare (ignore char))
  `(lambda (,(intern "_" *package*)) ,(read-delimited-list #\] stream t)))
