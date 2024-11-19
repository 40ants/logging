(uiop:define-package #:40ants-logging-example/cli
  (:use #:cl)
  (:import-from #:defmain)
  (:import-from #:log4cl)
  (:import-from #:log4cl-extras/context
                #:with-fields)
  (:import-from #:40ants-logging
                #:setup-for-backend)
  (:import-from #:40ants-slynk
                #:start-slynk-if-needed))
(in-package #:40ants-logging-example/cli)


(defun make-request-id ()
  "This function makes a unique ID for a run to demonstrate structural logging."
  (princ-to-string (get-universal-time)))


(defun run-loop ()
  (loop for i upfrom 0
        do (with-fields (:iteration i)
             (log:info "Sleeping 15 seconds")
             (log:debug "This should not be visible unless --verbose option was given")
             (sleep 15))))


(defun run-as (func &key verbose)
  (funcall func
   :level (if verbose
              :debug
              :info))
  (start-slynk-if-needed)
  
  (with-fields (:request-id (make-request-id))
    (log:info "Running as a backend.")
    (log:debug "Now I'm going to do an infinite loop.")
    (run-loop)))



(defmain:defmain (main) ((backend "Run as a backend instead of command line mode."
                                  :flag t)
                         (verbose "Set DEBUG level instead of INFO."
                                  :flag t))
  "Example program to demonstrate logging in different contexts."
  (unwind-protect
       (run-as (cond
                 (backend #'setup-for-backend)
                 (t #'40ants-logging:setup-for-cli))
               :verbose verbose)
    (with-fields (:another "Nested logging var")
      (log:debug "Exiting"))))


(defun test-fun ()
  (log:warn "FDFD"))
