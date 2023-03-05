(defsystem "40ants-logging-tests"
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :class :package-inferred-system
  :description "Provides tests for 40ants-logging."
  :source-control (:git "https://github.com/40ants/logging")
  :bug-tracker "https://github.com/40ants/logging/issues"
  :pathname "t"
  :depends-on ("40ants-logging-tests/core")
  :perform (test-op :after (op c)
                    (symbol-call :rove :run c))  )
