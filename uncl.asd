(in-package :cl-user)

(defpackage uncl-asd
  (:use :cl :asdf))

(in-package :uncl-asd)

(defsystem uncl
  :version "1.0.0-SNAPSHOT"
  :author "Eitarow Fukamachi"
  :license "MIT"
  :depends-on (:cl-ppcre :cl-interpol :cl-utilities)
  :serial t
  :components ((:file "package")
               (:file "util")
               (:file "anonym-function")
               (:file "sharp-backquote")
               (:file "defmacro")
               (:file "ppcre")
               (:file "special-form")
               (:file "debug")
               (:file "string")
               (:file "alias")))

(defmethod asdf:perform :after ((op load-op) (c (eql (find-system :uncl))))
  (funcall (intern (symbol-name :init-readtable) (find-package :uncl))))
