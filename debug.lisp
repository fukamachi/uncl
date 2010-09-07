(in-package :uncl)

(defmacro mac (expr)
  `(pprint (macroexpand-1 ',expr)))

(defmacro print-form-and-results (form)
  `(format t "~&~A --> ~S~%" (write-to-string ',form) ,form))

(defmacro dis (args &body body)
  `(disassemble
    (compile nil
      (lambda ,(mapcar (lambda (a)
                         (if (consp a)
                             (cadr a)
                             a))
                       args)
        (declare
         ,@(mapcar
            #`(type ,(car $1) ,(cadr $1))
            (remove-if-not #'consp args)))
        ,@body))))
