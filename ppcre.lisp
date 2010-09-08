(in-package :uncl)

(defun segment-reader (stream ch n)
  (if (> n 0)
      (let ((chars))
        (do ((curr (read-char stream)
                   (read-char stream)))
            ((char= ch curr))
          (push curr chars))
        (cons (coerce (nreverse chars) 'string)
              (segment-reader stream ch (- n 1))))))

(defmacro* match-mode-ppcre-lambda-form (args%)
  ``(lambda (,',str#)
      (cl-ppcre:scan
       ,(car ,args#)
       ,',str#)))

(defmacro* subst-mode-ppcre-lambda-form (args%)
  ``(lambda (,',str#)
      (cl-ppcre:regex-replace-all
       ,(car ,args#)
       ,',str#
       ,(cadr ,args#))))

(defun |#~-reader| (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (let ((mode-char (read-char stream)))
    (cond
      ((char= mode-char #\m)
       (match-mode-ppcre-lambda-form
        (segment-reader stream
                        (read-char stream)
                        1)))
      ((char= mode-char #\s)
       (subst-mode-ppcre-lambda-form
        (segment-reader stream
                        (read-char stream)
                        2)))
      (t (error "Unknown #~~ mode character")))))

(defun make-pairs (list)
  (if (null list) list
      (destructuring-bind (x y &rest rest) list
        (cons `(,x ,y) (make-pairs rest)))))

(set-dispatch-macro-character #\# #\~ #'|#~-reader|)
