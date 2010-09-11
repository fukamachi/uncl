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

(defun modifier-reader (stream)
  (let ((char (read-char stream nil)))
    (unread-char char stream)
    (unless (whitespacep char)
      (read-preserving-whitespace stream))))

(defun regex/modifier (regex modifier)
  (format nil "~@[(?~(~a~))~]~a" modifier regex))

(defmacro* match-mode-ppcre-lambda-form (args% modifier)
  ``(lambda (,',str#)
      (cl-ppcre:scan
       ,(regex/modifier (car ,args#) ,modifier)
       ,',str#)))

(defmacro* subst-mode-ppcre-lambda-form (args% modifier%)
  ``(lambda (,',str#)
      (,(if (find #\G (symbol-name ,modifier#))
            'cl-ppcre:regex-replace-all
            'cl-ppcre:regex-replace)
       ,(regex/modifier (car ,args#) (delete #\G (symbol-name ,modifier#)))
       ,',str#
       ,(cadr ,args#))))

(defun sharp-tilde-reader (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (let ((mode-char (read-char stream)))
    (cond
      ((char= mode-char #\m)
       (match-mode-ppcre-lambda-form
        (segment-reader stream
                        (read-char stream)
                        1)
        (modifier-reader stream)))
      ((char= mode-char #\s)
       (subst-mode-ppcre-lambda-form
        (segment-reader stream
                        (read-char stream)
                        2)
        (modifier-reader stream)))
      (t (error "Unknown #~~ mode character")))))
