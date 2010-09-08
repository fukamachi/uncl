(in-package :uncl-user)

(defun range (start end)
  (loop for i from start upto end collect i))

(defun slurp-stream (stream)
  (cl:let ((seq (cl:make-string (cl:file-length stream))))
    (cl:read-sequence seq stream)
    seq))

(defun slurp (file)
  (cl:with-open-file (stream file) (slurp-stream stream)))
