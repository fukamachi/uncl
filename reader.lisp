(in-package :uncl)

(defreadtable uncl:syntax
  (:merge :standard)
  (:macro-char #\[ #'anonym-function)
  (:macro-char #\] (get-macro-character #\)))
  (:macro-char #\" #'string-reader)
  (:dispatch-macro-char #\# #\~ #'sharp-tilde-reader)
  (:dispatch-macro-char #\# #\{ #'sharp-left-brace)
  (:macro-char #\} (get-macro-character #\)))
  (:dispatch-macro-char #\# #\` #'sharp-backquote-reader))

(defun enable-uncl-syntax ()
  (setq *enable-uncl-special-form* t)
  (in-readtable uncl:syntax))

(defun disable-uncl-syntax ()
  (setq *enable-uncl-special-form* nil)
  (in-readtable :standard))
