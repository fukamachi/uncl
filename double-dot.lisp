(in-package :uncl)

(defun n.. (start end)
  (loop for i from start upto end collect i))

(defun 1.. (end)
  (n.. 1 end))

(defun 0.. (end)
  (n.. 0 end))
