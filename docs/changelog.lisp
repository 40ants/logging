(uiop:define-package #:40ants-logging-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog))
(in-package #:40ants-logging-docs/changelog)


(defchangelog (:ignore-words ("SLY"
                              "ASDF"
                              "REPL"
                              "HTTP"))
  (0.2.0 2024-11-20
         "
## Changed

* Now  40ants-logging:setup-for-backend function and 40ants-logging:setup-for-cli function keep nested loggers. This way you will not loose setup made by Log4SLY or Log4SLYNK interactively.
* Also, setup functions now keeps original appender's stream, which prevents from occational disruption of the base logging process.
")
  (0.1.0 2023-02-05
         "* Initial version."))
