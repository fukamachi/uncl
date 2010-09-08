(in-package :cl-user)

(sb-ext:unlock-package :cl)

(defpackage uncl
  (:nicknames :ucl)
  (:use :cl :cl-ppcre :cl-interpol :cl-utilities)
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
  (:export :and
           :afn
           :dfn
           :alet
           :if
           :cond
           :let
           :let*
           :defmacro*

           ;; for debug
           :mac
           :print-form-and-results
           :dis

           ;; alias
           :fn
           :def
           :call
           :map
           :append!
           :reverse!
           :set!
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

           ;; from CL-UTILITIES
           :with-gensyms
           :once-only
           :compose

           ;; from COMMON-LISP
           :in-package
           :use-package
           :defpackage
           :defun
           :defmacro
           :quote
           :apply
           :append
           :reverse
           :progn
           :prog1
           :+
           :-
           :*
           :/
           :<
           :>
           :<=
           :>=
           :=
           :not
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

           ;; contrib
           :flatten
           :group
           :range
           :slurp
           ))

(defpackage uncl-user
  (:use :uncl))

(setf *print-case* :downcase)
