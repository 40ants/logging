(uiop:define-package #:40ants-logging
  (:use #:cl)
  (:nicknames #:40ants-logging/core)
  (:import-from #:log4cl-extras/config)
  (:import-from #:global-vars
                #:define-global-var)
  (:export #:setup-for-backend
           #:setup-for-cli
           #:setup-for-repl
           #:remove-repl-appender))
(in-package #:40ants-logging)


(define-global-var *core-appenders* nil)

(define-global-var *default-level* :warn)

(define-global-var *level* nil
  "Level given to the last call to SETUP-FOR-BACKEND or SETUP-FOR-CLI functions.")


(defun setup-for-backend (&key (level *default-level*))
  "Configures LOG4CL for logging in JSON format."
  (setf *level* level)
  (setf *core-appenders*
        (list (list 'this-console
                    :stream *standard-output*
                    :layout :json
                    :filter level)))
  
  (log4cl-extras/config:setup
   (list :level :debug
         :appenders *core-appenders*)))


(defun setup-for-repl (&key (level *level*)
                            (stream *debug-io*))
  "Configures LOG4CL for logging in REPL when you connect to the running lisp image already configured as a backend or CLI application.

   If you are using 40ANTS-SLYNK system, this function will be called automatically
   when your SLY connects to the image."
  (let ((appenders
          (list* (list 'this-console
                       :stream stream
                       :layout :plain
                       :filter level)
                 *core-appenders*)))
    (log4cl-extras/config:setup
     (list :level :debug
           :appenders appenders))))


(defun remove-repl-appender ()
  "Returns configuration the state as it was after SETUP-FOR-BACKEND or SETUP-FOR-CLI call.

   If you are using 40ANTS-SLYNK system, this function will be called automatically
   when your SLY disconnects from the image."
  (log4cl-extras/config:setup
     (list :level :debug
           :appenders *core-appenders*)))


(defun setup-for-cli (&key (level *default-level*))
  "Configures LOG4CL for logging in plain-text format with context fields support."
  (setf *level* level)
  (setf *core-appenders*
        (list (list 'this-console
                    :layout :plain
                    :filter level)))
  (log4cl-extras/config:setup
   (list :level :debug
         :appenders *core-appenders*)))
