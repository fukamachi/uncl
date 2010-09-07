(in-package :cl-user)

(sb-ext:unlock-package :cl)

(defpackage uncl
  (:nicknames :ucl)
  (:use :cl :cl-ppcre :cl-interpol)
  (:import-from :cl-interpol
                :*stream*
                :*start-char*
                :*term-char*
                :*pair-level*
                :*inner-delimiters*
                :*saw-backslash*
                :*readtable-copy*
                :inner-reader
                :read-char*
                :*previous-readtables*)
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
           :let
           :defmacro
           :slurp

           ;; for debug
           :mac
           :print-form-and-results
           :dis

           ;; alias
           :fn
           :def
           :call
           :append!
           :reverse!
           :inc!
           :dec!
           :push!
           :pop!
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
           :y/n?

           ;; from COMMON-LISP
           :in-package
           :use-package
           :defpackage
           :defun
           :apply
           :append
           :reverse
           :+
           :-
           :*
           :/
           :<
           :>
           :<=
           :>=
           :=
           :nil
           :t
           :cons
           :list
           :car
           :cdr
           :caar
           :cadr
           :cdar
           :cddr
           :loop
           :format
           :do
           ))

(defpackage uncl-user
  (:use :uncl))

(setf *print-case* :downcase)
