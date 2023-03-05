<a id="x-2840ANTS-LOGGING-DOCS-2FINDEX-3A-40README-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

# 40ants-logging - Functions to configure log4cl for different contexts: REPL, Backend, Command Line Application.

<a id="40-ants-logging-asdf-system-details"></a>

## 40ANTS-LOGGING ASDF System Details

* Version: 0.1.0

* Description: Functions to configure log4cl for different contexts: `REPL`, Backend, Command Line Application.

* Licence: Unlicense

* Author: Alexander Artemenko <svetlyak.40wt@gmail.com>

* Homepage: [https://40ants.com/logging][66d9]

* Bug tracker: [https://github.com/40ants/logging/issues][cd63]

* Source control: [GIT][0aac]

[![](https://github-actions.40ants.com/40ants/logging/matrix.svg?only=ci.run-tests)][2779]

![](http://quickdocs.org/badge/40ants-logging.svg)

<a id="x-2840ANTS-LOGGING-DOCS-2FINDEX-3A-3A-40INSTALLATION-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Installation

You can install this library from Quicklisp, but you want to receive updates quickly, then install it from Ultralisp.org:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :40ants-logging)
```
<a id="x-2840ANTS-LOGGING-DOCS-2FINDEX-3A-3A-40USAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Usage

This small library encapsulates a logging approach for all `40A`nts projects. It provides
a few functions to setup structured logging for two kinds of applications: backend and command-line utility.

For a backend you need to call [`40ants-logging:setup-for-backend`][0072] function. It configures `LOG4CL` to output all logs to `STDOUT` in `JSON` format. We are doing this because these days most backends are running in the Docker or Kubernetes where easiest way to collect logs is to capture daemon's `STDOUT`.

For a command line utilities we are configuring `LOG4CL` to use plaintext format. Call [`40ants-logging:setup-for-cli`][5fca] to make the job. Why `LOG:CONFIG` is not enought? `LOG:CONFIG` uses `LOG4CL` appenders which are not aware of fields added by structured logging macro [`log4cl-extras/context:with-fields`][b464].

You can also build an example app to test how this logging works:

```
./build-example.sh
./logging-example --help
```
Here is how it's output looks like for `CLI` mode:

```
% ./logging-example
<INFO> [2023-03-05T10:44:25.861365Z] 40ants-logging-example/cli cli.lisp (run-as-cli) Running as a command line application.
  Fields:
    request-id: 120002
<INFO> [2023-03-05T10:44:25.864960Z] 40ants-logging-example/cli cli.lisp (run-cli-loop) Sleeping 1 seconds
  Fields:
    request-id: 120002
    iteration: 0
<INFO> [2023-03-05T10:44:26.865200Z] 40ants-logging-example/cli cli.lisp (run-cli-loop) Sleeping 1 seconds
  Fields:
    request-id: 120002
    iteration: 1
...
```
and for backend mode:

```json
% ./logging-example --backend
{"fields":{"logger":"40ants-logging-example/cli","func":"run-as-backend","file":"cli.lisp","request-id":"120002"},"level":"INFO","message":"Running as a backend.","timestamp":"2023-03-05T10:46:12.812570Z"}
{"fields":{"logger":"40ants-logging-example/cli","func":"run-backend-loop","file":"cli.lisp","request-id":"120002","iteration":0},"level":"INFO","message":"Sleeping 15 seconds","timestamp":"2023-03-05T10:46:12.822253Z"}
{"fields":{"logger":"40ants-logging-example/cli","func":"run-backend-loop","file":"cli.lisp","request-id":"120002","iteration":1},"level":"INFO","message":"Sleeping 15 seconds","timestamp":"2023-03-05T10:46:27.822530Z"}
...
```
<a id="x-2840ANTS-LOGGING-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-2840ANTS-LOGGING-3ASETUP-FOR-BACKEND-20FUNCTION-29"></a>

### [function](342a) `40ants-logging:setup-for-backend` &key (level :warn)

Configures `LOG4CL` for logging in `JSON` format.

<a id="x-2840ANTS-LOGGING-3ASETUP-FOR-CLI-20FUNCTION-29"></a>

### [function](a4a9) `40ants-logging:setup-for-cli` &key (level :warn)

Configures `LOG4CL` for logging in plain-text format with context fields support.


[0072]: #x-2840ANTS-LOGGING-3ASETUP-FOR-BACKEND-20FUNCTION-29
[5fca]: #x-2840ANTS-LOGGING-3ASETUP-FOR-CLI-20FUNCTION-29
[b464]: https://40ants.com/log4cl-extras/#x-28LOG4CL-EXTRAS-2FCONTEXT-3AWITH-FIELDS-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29
[66d9]: https://40ants.com/logging
[0aac]: https://github.com/40ants/logging
[2779]: https://github.com/40ants/logging/actions
[342a]: https://github.com/40ants/logging/blob/194850daf5d426928d4542b072bf4ec2dca076c2/src/core.lisp#L13
[a4a9]: https://github.com/40ants/logging/blob/194850daf5d426928d4542b072bf4ec2dca076c2/src/core.lisp#L26
[cd63]: https://github.com/40ants/logging/issues

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
