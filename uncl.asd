(in-package :cl-user)

(defpackage uncl-asd
  (:use :cl :asdf))

(in-package :uncl-asd)

(defsystem uncl
  :version "1.0.0-SNAPSHOT"
  :author "Eitarow Fukamachi"
  :license "MIT"
  :depends-on (:cl-ppcre :cl-interpol :cl-utilities :named-readtables)
  :serial t
  :components ((:file "package")
               (:file "helper")
               (:file "anonym-function")
               (:file "sharp-backquote")
               (:file "hash-reader")
               (:file "defmacro")
               (:file "ppcre")
               (:file "special-form")
               (:file "string")
               (:file "contrib")
               (:file "alias")
               (:file "debug")))

(defmethod asdf:perform :after ((op load-op) (c (eql (find-system :uncl))))
  (funcall (intern (symbol-name :enable-uncl-syntax) (find-package :uncl))))
