#|
exec /usr/local/bin/sbcl --script "$0" "$@"
; or use following instead: exec /usr/local/bin/sbcl --noinform --non-interactive --load "$0" "$@"
|#

(load "/home/kaw/lang/lisp/argfiles.lisp")

(let ((ln 1))
  (af:with-argfiles
      #'(lambda (line)
          (format t "~5D ~:@(~A~)~%" ln line)
          (incf ln))
    :prefile
    #'(lambda (fname)
        (format t "====[ ~A ]================~%" (or fname "*STDIN*")))
    :end
    #'(lambda ()
        (format t "==========================~%"))))
