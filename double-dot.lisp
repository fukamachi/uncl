(in-package :sb-impl)

(defmethod read-after-hook ((expr cons))
  (if (backq-expression-p expr) expr
      (progn
        (setq expr (replace-double-dot expr))
        (cons (read-after-hook (car expr))
              (read-after-hook (cdr expr))))))

(defmethod read-after-hook ((expr vector))
  (apply #'vector (read-after-hook (coerce expr 'list))))

(defmethod read-after-hook ((expr string)) expr)

(defun double-dot-symbol (symb)
  (cl-ppcre:register-groups-bind
     ((#'parse-integer st) (#'parse-integer en))
     ("^(\\d+)\\.\\.(\\d+)$" (symbol-name symb))
   (list st en)))

(defun replace-double-dot (list)
  (labels ((rec (e)
             (cond
               ((backq-expression-p e) (list e))
               ((consp e) (list (apply #'append (mapcar #'rec e))))
               ((symbolp e) (let ((st-en (double-dot-symbol e)))
                              (if st-en
                                  (destructuring-bind (st en) st-en
                                    (loop for i from st upto en collect i))
                                  (list e))))
               (t (list e)))))
    (apply #'append (mapcar #'rec list))))
