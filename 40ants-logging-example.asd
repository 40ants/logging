(defsystem "40ants-logging-example"
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :class :package-inferred-system
  :description "Provides CI settings for 40ants-logging."
  :source-control (:git "https://github.com/40ants/logging")
  :bug-tracker "https://github.com/40ants/logging/issues"
  :pathname "src"
  :depends-on ("40ants-logging-example/cli")
  :build-operation "program-op"
  :build-pathname "logging-example"
  :entry-point "40ants-logging-example/cli::main")


#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c (eql (asdf:find-system "40ants-logging-example"))))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))

(asdf:register-system-packages "log4cl" (list "LOG"))
