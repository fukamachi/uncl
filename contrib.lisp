(in-package :uncl)

(defun last (list)
  (car (cl:last list)))

(defun sort (seq pred &key key)
  (cl:sort (copy-seq seq) pred :key key))

(defun mapcan (f &rest lists)
  (apply #'append (apply #'mapcar f lists)))
