(uiop:define-package #:40ants-logging-docs/index
  (:use #:cl)
  (:import-from #:pythonic-string-reader
                #:pythonic-string-syntax)
  #+quicklisp
  (:import-from #:quicklisp)
  (:import-from #:named-readtables
                #:in-readtable)
  (:import-from #:40ants-doc
                #:defsection
                #:defsection-copy)
  (:import-from #:40ants-logging-docs/changelog
                #:@changelog)
  (:import-from #:docs-config
                #:docs-config)
  (:export #:@index
           #:@readme
           #:@changelog))
(in-package #:40ants-logging-docs/index)

(in-readtable pythonic-string-syntax)


(defmethod docs-config ((system (eql (asdf:find-system "40ants-logging-docs"))))
  ;; 40ANTS-DOC-THEME-40ANTS system will bring
  ;; as dependency a full 40ANTS-DOC but we don't want
  ;; unnecessary dependencies here:
  #+quicklisp
  (ql:quickload "40ants-doc-theme-40ants")
  #-quicklisp
  (asdf:load-system "40ants-doc-theme-40ants")
  
  (list :theme
        (find-symbol "40ANTS-THEME"
                     (find-package "40ANTS-DOC-THEME-40ANTS")))
  )


(defsection @index (:title "40ants-logging - Functions to configure log4cl for different contexts: REPL, Backend, Command Line Application."
                    :ignore-words ("JSON"
                                   "HTTP"
                                   "TODO"
                                   "Unlicense"
                                   "REPL"
                                   "GIT")
                    :external-docs ("https://40ants.com/log4cl-extras/"))
  (40ants-logging system)
  "
[![](https://github-actions.40ants.com/40ants/logging/matrix.svg?only=ci.run-tests)](https://github.com/40ants/logging/actions)

![Quicklisp](http://quickdocs.org/badge/40ants-logging.svg)
"
  (@installation section)
  (@usage section))


(defsection-copy @readme @index)


(defsection @installation (:title "Installation")
  """
You can install this library from Quicklisp, but you want to receive updates quickly, then install it from Ultralisp.org:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :40ants-logging)
```
""")


(defsection @usage (:title "Usage"
                    :ignore-words ("ASDF:PACKAGE-INFERRED-SYSTEM"
                                   "ASDF"
                                   "JSON"
                                   "LOG4CL"
                                   "STDOUT"
                                   "40A"))
  "
This small library encapsulates a logging approach for all 40Ants projects. It provides
a few functions to setup structured logging for two kinds of applications: backend and command-line utility.

For a backend you need to call 40ANTS-LOGGING:SETUP-FOR-BACKEND function. It configures LOG4CL to output all logs to STDOUT in JSON format. We are doing this because these days most backends are running in the Docker or Kubernetes where easiest way to collect logs is to capture daemon's STDOUT.

For a command line utilities we are configuring LOG4CL to use plaintext format. Call 40ANTS-LOGGING:SETUP-FOR-CLI to make the job. Why LOG:CONFIG is not enought? LOG:CONFIG uses LOG4CL appenders which are not aware of fields added by structured logging macro LOG4CL-EXTRAS/CONTEXT:WITH-FIELDS.

You can also build an example app to test how this logging works:

```
./build-example.sh
./logging-example --help
```

"
  (40ants-logging:setup-for-backend function)
  (40ants-logging:setup-for-cli function))
