(in-package :uncl)

#.`(defreadtable uncl:syntax
       (:merge :standard)
       (:macro-char #\[ #'anonym-function)
       (:macro-char #\] (get-macro-character #\)))
       (:macro-char #\" #'string-reader)
       (:dispatch-macro-char #\# #\~ #'sharp-tilde-reader)
       (:dispatch-macro-char #\# #\{ #'sharp-left-brace)
       (:dispatch-macro-char #\# #\` #'sharp-backquote-reader))

(defun enable-uncl-syntax ()
  (in-readtable uncl:syntax))

(defun disable-uncl-syntax ()
  (in-readtable :standard))
