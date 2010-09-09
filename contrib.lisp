(in-package :uncl)

(defun last (list)
  (car (cl:last list)))

(defun range (start end)
  (loop for i from start upto end collect i))

(defun sort* (seq pred &key key)
  (cl:sort (copy-seq seq) pred :key key))

(defun string* (&rest args)
  (apply #'concatenate 'string (mapcar #'string-downcase args)))

(defun slurp-stream (stream)
  (cl:let ((seq (cl:make-string (cl:file-length stream))))
    (cl:read-sequence seq stream)
    seq))

(defun slurp (file)
  (cl:with-open-file (stream file) (slurp-stream stream)))
