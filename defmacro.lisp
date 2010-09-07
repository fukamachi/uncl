(in-package :uncl)

(defun g!-symbol-p (s)
  (if (symbolp s)
      (let ((str (symbol-name s)))
        (string= str "#" :start1 (1- (length str))))))

(defun o!-symbol-p (s)
  (if (symbolp s)
      (let ((str (symbol-name s)))
        (string= str "%" :start1 (1- (length str))))))

(defun o!-symbol-to-g!-symbol (s)
  (let ((str (symbol-name s)))
    (symb (subseq str 0 (1- (length str)))
          "#")))

(defmacro defmacro/g! (name args &body body)
  (let ((symbs (remove-duplicates
                (remove-if-not #'g!-symbol-p
                               (flatten body)))))
    `(defmacro ,name ,args
       (let ,(mapcar
              (lambda (s)
                `(,s (gensym ,(subseq
                               (symbol-name s)
                               2))))
              symbs)
         ,@body))))

(defmacro defmacro! (name args &body body)
  (let* ((os (remove-if-not #'o!-symbol-p args))
         (gs (mapcar #'o!-symbol-to-g!-symbol os)))
    `(defmacro/g! ,name ,args
       `(let ,(mapcar #'list (list ,@gs) (list ,@os))
          ,(progn ,@body)))))
