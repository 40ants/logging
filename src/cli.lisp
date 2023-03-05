(uiop:define-package #:40ants-logging-example/cli
  (:use #:cl)
  (:import-from #:defmain)
  (:import-from #:log4cl)
  (:import-from #:log4cl-extras/context
                #:with-fields)
  (:import-from #:40ants-logging
                #:setup-for-backend))
(in-package #:40ants-logging-example/cli)


(defun make-request-id ()
  "This function makes a unique ID for a run to demonstrate structural logging."
  (princ-to-string (get-universal-time)))


(defun run-backend-loop ()
  (loop for i upfrom 0
        do (with-fields (:iteration i)
             (log:info "Sleeping 15 seconds")
             (sleep 15))))

(defun run-cli-loop ()
  (loop for i upto 15
        do (with-fields (:iteration i)
             (log:info "Sleeping 1 seconds")
             (sleep 1))))


(defun run-as-backend (&key verbose)
  (setup-for-backend
   :level (if verbose
              :debug
              :info))
  (with-fields (:request-id (make-request-id))
    (log:info "Running as a backend.")
    (log:debug "Now I'm going to do an infinite loop.")
    (run-backend-loop)))


(defun run-as-cli (&key verbose)
  (40ants-logging:setup-for-cli
   :level (if verbose
              :debug
              :info))
  (with-fields (:request-id (make-request-id))
    (log:info "Running as a command line application.")
    (run-cli-loop)
    (with-fields (:another "Nested logging var")
      (log:debug "Exiting"))))


(defmain:defmain (main) ((backend "Run as a backend instead of command line mode."
                                  :flag t)
                         (verbose "Set DEBUG level instead of INFO."
                                  :flag t))
  "Example program to demonstrate logging in different contexts."
  (cond
    (backend
     (run-as-backend :verbose verbose))
    (t
     (run-as-cli :verbose verbose))))
