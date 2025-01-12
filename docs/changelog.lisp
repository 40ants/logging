(uiop:define-package #:40ants-logging-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog))
(in-package #:40ants-logging-docs/changelog)


(defchangelog (:ignore-words ("SLY"
                              "ASDF"
                              "REPL"
                              "LOG4SLY"
                              "LOG4SLYNK"
                              "HTTP"))
  (0.3.0 2025-01-12
         "
## Changed

* Now 40ANTS-LOGGING:SETUP-FOR-BACKEND function and 40ANTS-LOGGING:SETUP-FOR-CLI function set the given level not only for appender but also for a root logger, preventing REPL pollution with all debug logs.
* Also, 40ANTS-LOGGING:SETUP-FOR-REPL function now uses :DEBUG as default for :LEVEL argument. This way you only need to set needed log level for selected packages using LOG4SLY and Emacs.
"
         )
  (0.2.0 2024-11-20
         "
## Changed

* Now 40ANTS-LOGGING:SETUP-FOR-BACKEND function and 40ANTS-LOGGING:SETUP-FOR-CLI function keep nested loggers. This way you will not loose setup made by LOG4SLY or LOG4SLYNK interactively.
* Also, setup functions now keeps original appender's stream, which prevents from occational disruption of the base logging process.
")
  (0.1.0 2023-02-05
         "* Initial version."))
