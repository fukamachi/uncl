(in-package :uncl)

(defun sharpL-reader (stream subchar n-args)
  "from iterate"
  (declare (ignore subchar))
  (let* ((form (read stream t nil t))
         (bang-vars (sort (bang-vars form) #'< :key #'bang-var-num))
         (bang-var-nums (mapcar #'bang-var-num bang-vars))
         (max-bv-num (if bang-vars
                         (reduce #'max bang-var-nums :initial-value 0)
                         0)))
    (cond 
      ((null n-args)
       (setq n-args max-bv-num))
      ((< n-args max-bv-num)
       (error "#L: digit-string ~d specifies too few arguments" n-args)))
    (let* ((bvars (let ((temp nil))
                    (dotimes (i n-args (nreverse temp))
                      (push (make-bang-var (1+ i)) temp))))
           (args (mapcar #'(lambda (x) (declare (ignore x)) (gensym))
                         bvars))
           (ignores (set-difference bvars bang-vars))
           (decl (if ignores `(declare (ignore .,ignores)) nil))
           (body (if (list-of-forms? form)
                     (if decl (cons decl form) form)
                     (if decl (list decl form) (list form))))
           (subbed-body (sublis (pairlis bvars args) body)))
      `#'(lambda ,args ,.subbed-body))))

(defun make-bang-var (n)
  (intern (format nil "$~d" n)))

(defun list-of-forms? (x)
  (and (consp x) (consp (car x))
       (not (eq (caar x) 'lambda))))

(defun bang-vars (form)
  (delete-duplicates (bang-vars-1 form '()) :test #'eq))

(defun bang-vars-1 (form vars)
  (cond
    ((consp form)
     (bang-vars-1 (cdr form)
                  (bang-vars-1 (car form) vars)))
    ((and (symbolp form) (bang-var? form)) (cons form vars))
    (t vars)))

(defun bang-var? (sym)
  (char= (char (symbol-name sym) 0) #\$))

(defun bang-var-num (sym)
  (let ((num (read-from-string (subseq (symbol-name sym) 1))))
    (if (not (and (integerp num) (> num 0)))
        (error "#L: ~a is not a valid variable specifier" sym)
        num)))

(set-dispatch-macro-character #\# #\L #'sharpL-reader)
