(defsystem "40ants-logging"
  :description "Functions to configure log4cl for different contexts: REPL, Backend, Command Line Application."
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/logging"
  :source-control (:git "https://github.com/40ants/logging")
  :bug-tracker "https://github.com/40ants/logging/issues"
  :class :40ants-asdf-system
  :defsystem-depends-on ("40ants-asdf-system")
  :pathname "src"
  :depends-on ("40ants-logging/core")
  :in-order-to ((test-op (test-op "40ants-logging-tests"))))
