(in-package :uncl)

(defun string-reader (stream char)
  (let ((*stream* stream)
        (*start-char* char)
        (*term-char* char)
        (*pair-level* 0)
        (*inner-delimiters* nil)
        *saw-backslash*
        *readtable-copy*)
    (prog1 
        (inner-reader nil nil nil nil)
      (read-char*))))
