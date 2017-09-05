(defpackage :argfiles
  (:use :common-lisp)
  (:export with-argfiles)
  (:nicknames :af))

(in-package :argfiles)

(defun with-argfiles (linefunc &key begin prefile postfile end)
 (and begin (funcall begin))
  (labels ((argfile (st fname)
             (when (streamp st)
               (and prefile (funcall prefile fname))
               (loop
                  for line = (read-line st nil nil)
                  while line
                  do
                    (funcall linefunc line))
               (and postfile (funcall postfile fname)))))
    (if (cdr sb-ext:*posix-argv*)
        (mapcar #'(lambda (fname)
                    (if (string= fname "-")
                        (argfile *standard-input* nil)
                        (with-open-file (st fname
                                            :direction :input
                                            :if-does-not-exist nil
					    :element-type :default)
                          (argfile st fname))))
                (cdr sb-ext:*posix-argv*))
        (argfile *standard-input* nil)))
  (and end (funcall end)))
