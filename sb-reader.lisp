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
      (cons (read-after-hook (car expr))
            (read-after-hook (cdr expr)))))
