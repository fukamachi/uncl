(in-package :sb-impl)

(sb-ext:unlock-package :sb-int)

(setf (symbol-function '%simple-eval-in-lexenv) (symbol-function 'simple-eval-in-lexenv))
(fmakunbound 'simple-eval-in-lexenv)

(defmethod simple-eval-in-lexenv (original-exp lexenv)
  (%simple-eval-in-lexenv original-exp lexenv))

(defmethod simple-eval-in-lexenv ((original-exp cons) lexenv)
  (if uncl:*enable-uncl-special-form*
      (%simple-eval-in-lexenv
       (case (car original-exp)
         ((not (string= :uncl-user (package-name *package*))) original-exp)
         ((uncl:fn) `(lambda ,@(cdr original-exp)))
         ((if) `(,(intern (symbol-name 'aif) :uncl) ,@(cdr original-exp)))
         ((cond) `(,(intern (symbol-name 'acond2) :uncl) ,@(cdr original-exp)))
         ((let) `(,(intern (symbol-name 'let2) :uncl) ,@(cdr original-exp)))
         ((let*) `(,(intern (symbol-name 'let2*) :uncl) ,@(cdr original-exp)))
         (t (cond
              ((and (consp (car original-exp))
                    (eq (caar original-exp) 'uncl:fn))
               `((lambda ,@(cdar original-exp)) ,@(cdr original-exp)))
              ((keywordp (car original-exp)) `(gethash ,@original-exp))
              (t original-exp))))
       lexenv)
      (%simple-eval-in-lexenv original-exp lexenv)))

(setf (symbol-function '%symbol-function) (symbol-function 'symbol-function))
(setf (symbol-function '%apply) (symbol-function 'apply))
(setf (symbol-function '%funcall) (symbol-function 'funcall))

(defun %keyword-function-or (function &optional default)
  (if (keywordp function)
      (lambda (hash) (gethash function hash))
      (or default function)))

(defun symbol-function (symbol)
  (%keyword-function-or symbol (%symbol-function symbol)))

(defun apply (function &rest arguments)
  (apply #'%apply
         (%keyword-function-or function)
         arguments))

(defun funcall (function &rest arguments)
  (apply (%keyword-function-or function) arguments))

(in-package :uncl)

(defun enable-uncl-special-form ()
  (setq *enable-uncl-special-form* t))

(defun disable-uncl-special-form ()
  (setq *enable-uncl-special-form* nil))
