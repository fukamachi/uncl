(in-package :uncl)

(defmacro aif (test-form then-form &optional else-form)
  `(let ((it ,test-form))
     (if it ,then-form ,else-form)))

(defmacro and (&rest args)
  (cond ((null args) t)
        ((null (cdr args)) (car args))
        (t `(aif ,(car args) (and ,@(cdr args))))))

(defmacro afn (parms &body body)
  `(labels ((self ,parms ,@body))
     #'self))

(defmacro! dfn (&rest ds)
  `(lambda (&rest ,args#)
     (case (car ,args#)
       ,@(mapcar
          (lambda (d)
            `(,(if (eq t (car d))
                   t
                   (list (car d)))
               (apply (lambda ,@(cdr d))
                      ,(if (eq t (car d))
                           args#
                           `(cdr ,args#)))))
          ds))))

(defmacro alet (letargs &rest body)
  `(let ((this) ,@letargs)
     (setq this ,@(last body))
     ,@(butlast body)
     (lambda (&rest params)
       (apply this params))))
