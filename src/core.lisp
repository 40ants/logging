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

(define-global-var *repl-appenders* nil)

(define-global-var *default-level* :warn)

(define-global-var *level* nil
  "Level given to the last call to SETUP-FOR-BACKEND or SETUP-FOR-CLI functions.")


(defun get-original-stream ()
  (getf (cdr (first *core-appenders*))
        :stream))


(defun resolve-synonyms (stream)
  (typecase stream
    (synonym-stream
       (resolve-synonyms
        (symbol-value (synonym-stream-symbol stream))))
    (t
       stream)))


(defun setup-for-backend (&key (level *default-level*))
  "Configures LOG4CL for logging in JSON format."
  (setf *level* level)
  (setf *core-appenders*
        (list (list 'this-console
                    :stream (or (get-original-stream)
                                (resolve-synonyms *standard-output*))
                    :layout :json
                    :filter level)))
  
  (let ((children (log4cl::%logger-child-hash log4cl:*root-logger*))
        (orig-root-logger log4cl:*root-logger*))
    (log:info "Changing" orig-root-logger)


    ;; We need to setup
    (setf (log4cl::%logger-child-hash log4cl:*root-logger*)
          (make-hash-table :test 'equal))
    
    (log4cl-extras/config:setup
     (list :level :debug
           :appenders (append *repl-appenders*
                              *core-appenders*)))
    ;; Here we need to restore children because the might be
    ;; changed interactively using LOG4SLIME or LOG4SLY and we don't
    ;; want to loose these settings:
    (setf (log4cl::%logger-child-hash log4cl:*root-logger*)
          children))
  (values))


(defun setup-for-cli (&key (level *default-level*))
  "Configures LOG4CL for logging in plain-text format with context fields support."
  (when *core-appenders*
    (error "Base logging setup already done. Use SET-BASE-LEVEL or SET-REPL-LEVEL to change log levels."))
  
  (setf *level* level)
  (setf *core-appenders*
        (list (list 'this-console
                    ;; Here we keep original stream
                    ;; captured by the first run of setup-for-cli or setup-for-repl
                    :stream (or (get-original-stream)
                                (resolve-synonyms *standard-output*))
                    :layout :plain
                    :filter level)))
  (let ((children (log4cl::%logger-child-hash log4cl:*root-logger*)))
    (log4cl-extras/config:setup
     (list :level :debug
           :appenders (append *repl-appenders*
                              *core-appenders*)))
    ;; Here we need to restore children because the might be
    ;; changed interactively using LOG4SLIME or LOG4SLY and we don't
    ;; want to loose these settings:
    (setf (log4cl::%logger-child-hash log4cl:*root-logger*)
          children))
  (values))


(defun setup-for-repl (&key (level *level*)
                       (stream *debug-io*))
  "Configures LOG4CL for logging in REPL when you connect to the running lisp image already configured as a backend or CLI application.

   If you are using 40ANTS-SLYNK system, this function will be called automatically
   when your SLY connects to the image."
  (setf *repl-appenders*
        (list
         (list 'this-console
               :stream (resolve-synonyms stream)
               :layout :plain
               :filter level)))
  
  (let ((children (log4cl::%logger-child-hash log4cl:*root-logger*)))
    (log4cl-extras/config:setup
     (list :level :debug
           :appenders (append *repl-appenders*
                              *core-appenders*)))
    ;; Here we need to restore children because the might be
    ;; changed interactively using LOG4SLIME or LOG4SLY and we don't
    ;; want to loose these settings:
    (setf (log4cl::%logger-child-hash log4cl:*root-logger*)
          children))
  (values))


(defun remove-repl-appender ()
  "Returns configuration the state as it was after SETUP-FOR-BACKEND or SETUP-FOR-CLI call.

   If you are using 40ANTS-SLYNK system, this function will be called automatically
   when your SLY disconnects from the image."
  (log4cl-extras/config:setup
     (list :level :debug
           :appenders *core-appenders*)))
