(uiop:define-package #:40ants-logging-tests/core
  (:use #:cl)
  (:import-from #:40ants-logging
                #:*core-appenders*
                #:*level*
                #:*on-change-hooks*
                #:*repl-appenders*
                #:remove-repl-appender
                #:setup-for-backend
                #:setup-for-cli
                #:setup-for-repl)
  (:import-from #:rove
                #:deftest
                #:ok
                #:testing))
(in-package #:40ants-logging-tests/core)


(deftest test-example ()
  (ok t "Replace this test with something useful."))


(defmacro with-clean-logging-state (() &body body)
  `(let ((old-core-appenders *core-appenders*)
         (old-repl-appenders *repl-appenders*)
         (old-level *level*)
         (old-on-change-hooks *on-change-hooks*))
     (unwind-protect
          (progn
            (setf *core-appenders* nil
                  *repl-appenders* nil
                  *level* nil
                  *on-change-hooks* nil)
            ,@body)
       (setf *core-appenders* old-core-appenders
             *repl-appenders* old-repl-appenders
             *level* old-level
             *on-change-hooks* old-on-change-hooks))))


(deftest hooks-are-called-after-configuration-change ()
  (with-clean-logging-state ()
    (let ((calls nil))
      (setf *on-change-hooks*
            (list (lambda ()
                    (push :first calls))
                  :not-a-function
                  (lambda ()
                    (push :second calls))))
      (setup-for-backend)
      (ok (equal (reverse calls)
                 '(:first :second))))))


(deftest hooks-are-called-for-all-public-state-changes ()
  (with-clean-logging-state ()
    (let ((count 0))
      (setf *on-change-hooks*
            (list (lambda ()
                    (incf count))))
      (setup-for-cli)
      (setup-for-repl)
      (remove-repl-appender)
      (ok (= count 3)))))
