(in-package :sb-impl)

(defvar *read-after-hook-symbol-functions* nil)

(setf (symbol-function '%read) (symbol-function 'read))
(fmakunbound 'read)

(defun backq-expression-p (object)
  (and (consp object)
       (consp (car object))
       (listp (member (caar object) (list *bq-comma-flag*
                                          *bq-at-flag*
                                          *bq-dot-flag*
                                          *bq-vector-flag*)
                      :test #'eq
                      :key #'car))))

(defmethod read (&rest args)
  (let ((result (apply #'%read args)))
    (if (eq result (nth 2 args))
        result
        (read-after-hook result))))

(defmethod read-after-hook (expr) expr)

(defmethod read-after-hook ((expr symbol))
  (loop for f in *read-after-hook-symbol-functions*
       for result = (funcall f expr) then (funcall f expr)
       until result
       finally (return (or result expr))))

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
  (cl-ppcre:register-groups-bind ((#'parse-integer st) (#'parse-integer en)) ("^(\\d+)\\.\\.(\\d+)$" (symbol-name symb))
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
