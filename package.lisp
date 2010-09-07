(in-package :cl-user)

(sb-ext:unlock-package :cl)

(defpackage uncl
  (:nicknames :ucl)
  (:use :cl :cl-ppcre)
  (:export :flatten
           :group
           :set-macro-symbol
           :define-macro-symbol
           :init-readtable
           :and
           :afn
           :dfn
           :alet
           :if
           :defmacro
           :slurp

           ;; for debug
           :mac
           :print-form-and-results
           :dis

           ;; alias
           :fn
           :zero?
           :complex?
           :rational?
           :real?
           :float?
           :integer?
           :constant?
           :number?
           :plus?
           :minus?
           :even?
           :odd?
           :symbol?
           :keyword?
           :function?
           :string?
           :list?
           :cons?
           :array?
           :vector?
           :equal?
           :type?
           :y/n?

           ;; from COMMON-LISP
           :in-package
           :defpackage
           ))

(setf *print-case* :downcase)
