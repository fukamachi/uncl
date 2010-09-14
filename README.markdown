# Un-Common Lisp

Un-Common Lisp is a new dialect of Lisp.

## Dependencies

UnCL only works on [SBCL](http://www.sbcl.org/).  
Depends on cl-ppcre, cl-interpol, cl-utilities and named-readtables.

## Installation

    (require 'asdf) ;; You should put this your .sbclrc, if not yet.
    (require 'asdf-install)
    (asdf-install:install "http://github.com/fukamachi/uncl/tarball/master")

## How to use?

Put the following lines to your .sbclrc to try.

    (require 'uncl)
    (in-package :uncl-user)
    
    ;; Putting some reader macros to the readtable.
    ;; For detail, see following "Features" section.
    (enable-uncl-syntax)

If you would determine to use UnCL in your cool application, just replace <code>(:use :cl)</code> to <code>(:use :uncl)</code> in defpackage.

    (defpackage your-package
      (:use :uncl))
    (enable-uncl-syntax)

## Features

### Renamed built-in

<code>lambda</code> is too long to type. UnCL have, so as modern dialects of Lisp do, <code>fn</code> instead.

    * (fn (x) (* x 2))
    => #<FUNCTION (lambda (x)) {12DD32B5}>

This example can also be written below.

    * [* _ 2]
    => #<FUNCTION (lambda (_)) {12B9844D}>

* suffix "-p" -> "?"
* prefix "n" -> suffix "!"

### More powerful

<code>defmacro*</code> has auto-gensym syntax.

    ;; THIS IS A EXAMPLE FOR A EXAMPLE
    (defmacro* 1+10x (n%)
      `(let ((,num# (* 10 ,n#)))
         (1+ ,num#)))

<code>symbol%</code> is executed only once, and <code>symbol#</code> is going to be expanded to gensym one.

<code>let*</code> destructure it's arguments if need it.

    (let* (x 1
           (y z) (list x 20))
      (+ x y z))
    => (+ 1 1 20)
    => 22

### More anaphoric

UnCL's <code>if</code> is anaphoric one.

    (if (find-user 10)
      (get-name it) ;; `it' refers a result of the conditional part
      'not-found)

So are <code>cond</code> and <code>and</code>.

### Double dot syntax

    '(1..10)
    => (1 2 3 4 5 6 7 8 9 10)
    (mapcar [* _ 2] '(1..10))
    => (2 4 6 8 10 12 14 16 18 20)

## FAQ

**Q**: How do you pronounce UnCL?  
**A**: Same as "uncle".

## License

Copyright (c) 2010 深町英太郎 (E.Fukamachi).  
Licensed under the MIT License (http://www.opensource.org/licenses/mit-license.php)
