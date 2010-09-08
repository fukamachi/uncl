(in-package :uncl)

(defmacro aif (test-form then-form &optional else-form)
  (let ((it-symb (intern "IT" *package*)))
    `(let ((,it-symb ,test-form))
       (if ,it-symb ,then-form ,else-form))))

(defmacro and (&rest args)
  (cond ((null args) t)
        ((null (cdr args)) (car args))
        (t `(aif ,(car args) (and ,@(cdr args))))))

(defmacro afn (parms &body body)
  `(labels ((self ,parms ,@body))
     #'self))

(defmacro* dfn (&rest ds)
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

(defmacro let2 (letargs &rest body)
  `(let ,(group letargs 2) ,@body))

(defmacro alet (letargs &rest body)
  `(let ((this) ,@(group letargs 2))
     (setq this ,@(last body))
     ,@(butlast body)
     (lambda (&rest params)
       (apply this params))))

(defmacro* acond (&rest clauses)
  (if (null clauses)
      nil
      (let ((cl1 (car clauses))
            (it-symb (intern "IT" *package*)))
        `(let ((,sym# ,(car cl1)))
           (if ,sym#
               ,(if (member it-symb (flatten (cdr cl1)))
                    `(let ((,it-symb ,sym#)) ,@(cdr cl1))
                    `(progn ,@(cdr cl1)))
               (acond ,@(cdr clauses)))))))

(defmacro acond2 (&rest clauses)
  `(acond ,@(group clauses 2)))
