(uiop:define-package #:40ants-logging
  (:use #:cl)
  (:nicknames #:40ants-logging/core)
  (:import-from #:log4cl-extras/config)
  (:export #:setup-for-backend
           #:setup-for-cli))
(in-package #:40ants-logging)


(defvar *mode* nil)


(defun setup-for-backend (&key (level :warn))
  (let ((appenders
          (list (list 'this-console
                      :stream *standard-output*
                      :layout :json
                      :filter level))))

    (log4cl-extras/config:setup
     (list :level level
           :appenders appenders))))


(defun setup-for-cli (&key (level :warn))
  (let ((appenders
          (list (list 'this-console
                      :layout :plain
                      :filter level))))
    (log4cl-extras/config:setup
     (list :level level
           :appenders appenders))))


;; (defun old-setup ()
;;   (let ((appenders
;;           (cond
;;             ((string-equal (current-environment)
;;                            "development")
;;              (list '(this-console
;;                      :layout :plain
;;                      :filter :debug)))
;;             (t
;;              (list `(this-console
;;                      :stream ,*standard-output*
;;                      :layout :json
;;                      :filter :debug))))))

;;     (log4cl-extras/config:setup
;;      (list :level :warn
;;            :appenders appenders))))
