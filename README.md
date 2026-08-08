<a id="x-2840ANTS-LOGGING-DOCS-2FINDEX-3A-40README-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

# 40ants-logging - Functions to configure log4cl for different contexts: REPL, Backend, Command Line Application.

<a id="40-ants-logging-asdf-system-details"></a>

## 40ANTS-LOGGING ASDF System Details

* Description: Functions to configure log4cl for different contexts: `REPL`, Backend, Command Line Application.
* Licence: Unlicense
* Author: Alexander Artemenko <svetlyak.40wt@gmail.com>
* Homepage: [https://40ants.com/logging/][3eb9]
* Bug tracker: [https://github.com/40ants/logging/issues][cd63]
* Source control: [GIT][0aac]
* Depends on: [global-vars][07be], [log4cl-extras][691c]

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

This small library encapsulates a logging approach for all `40Ants` projects. It provides
a few functions to setup structured logging for two kinds of applications: backend and command-line utility.

<a id="the-main-idea"></a>

### The main idea

The idea of our approach to logging is that an application work in two modes:

* regular;
* `IDE` connected.

In regular mode application should log to the standard output or to the file usually using `JSON` format. These logs should be collected and stored in some kind of log store like ElasticSearch. Usually you want to limit log to store only `WARN` and `ERROR` levels.

In the second mode, a developer has connected to the app and wants to be able to see some log outputs in the `REPL`.

We define two log appenders for these two modes:

* main log appender writes logs in regular mode.
* repl log appender can be added when `REPL` is enabled. This is done automatically if you start Slynk using [`40ants-slynk`][04ac] system.

Note, a developer don't need to see all `INFO` and `DEBUG` logs but only these logs from some package. So, we keep root logger's level the same as was specified for the main log appender. For example, imagine the main appender was configured to log `WARN` and `INFO`, but `REPL` appender configured to show `DEBUG`. When you'll connect to the `REPL`, it will not be cluttered with `DEBUG` messages from the all packages, instead only `WARN` and `ERROR` will be logged to the `REPL` the same as they will be logged to the main appender. But if you want to debug some package, you can set `DEBUG` level for this package only using `LOG4SLY`.

<a id="details"></a>

### Details

For a backend you need to call [`40ants-logging:setup-for-backend`][d0af] function. It configures `LOG4CL` to output all logs to `STDOUT` in `JSON` format. We are doing this because these days most backends are running in the Docker or Kubernetes where easiest way to collect logs is to capture daemon's `STDOUT`.

For a command line utilities we are configuring `LOG4CL` to use plaintext format. Call [`40ants-logging:setup-for-cli`][78f4] to make the job. Why `LOG:CONFIG` is not enought? `LOG:CONFIG` uses `LOG4CL` appenders which are not aware of fields added by structured logging macro [`log4cl-extras/context:with-fields`][b464].

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
If you are using [`40ants-slynk`][04ac] system to setup a Slynk server, then [`40ants-logging:setup-for-repl`][d1f2] function will be called automatically on connect to the repl. You can observe logging configuration by like this:

```
CL-USER> (log:config)
ROOT, DEBUG
|
+-(1)-#<STABLE-THIS-CONSOLE-APPENDER {10055B18F3}>
|     with #<JSON-LAYOUT {10055B6AD3}>
|     :immediate-flush NIL
|     :flush-interval  1
|     :stream-owner    NIL
|     :stream          #<SB-SYS:FD-STREAM for "standard output" {1001D016C3}>
|     :message-count   0
|     :filter          :INFO
|
+-(2)-#<STABLE-THIS-CONSOLE-APPENDER {10023FB1D3}>
      with #<PLAIN-LAYOUT {10055B46D3}>
      :immediate-flush NIL
      :flush-interval  1
      :stream-owner    NIL
      :stream          #<SLYNK-GRAY::SLY-OUTPUT-STREAM {1001D00153}>
      :message-count   0
      :filter          :WARN
```
To change log level only for the `REPL`, call `(40ants-logging:setup-for-repl :level :warn)` function. If you will change log level via standard function of `LOG4CL`: `(log:config :warn)`, it will change the global logging level which will affect the backend's log in `JSON` format.

<a id="x-2840ANTS-LOGGING-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-2840ANTS-LOGGING-3ASETUP-FOR-BACKEND-20FUNCTION-29"></a>

### [function](675e) `40ants-logging:setup-for-backend` &key (level \*default-level\*) (filename nil) (layout :json)

Configures `LOG4CL` for logging in `JSON` format.

Here we set for the root logger
the same level as for the main appender.
Usually this level will be higher than level
for the `REPL` appender. We are doing this
to not show `INFO` and `DEBUG` messages in the `REPL`
by default if they are not logged by the main appender.

But you can use `LOG4SLY` to setup more verbose log
levels for subcategories. For example, main appender
can be configured to log `WARN`s and `REPL` appender
configured to show `DEBUG`. But when you'll connect
to the `REPL`, it will not be cluttered with `DEBUG`
messages from the all packages, instead only `WARN`s and `ERROR`s
will be logged to the `REPL` the same as they will be logged
to the main appender. But if you want to debug some package,
you can set `DEBUG` level for it using `LOG4SLY`.

<a id="x-2840ANTS-LOGGING-3ASETUP-FOR-CLI-20FUNCTION-29"></a>

### [function](5c8f) `40ants-logging:setup-for-cli` &key (level \*default-level\*)

Configures `LOG4CL` for logging in plain-text format with context fields support.

<a id="x-2840ANTS-LOGGING-3ASETUP-FOR-REPL-20FUNCTION-29"></a>

### [function](8d1b) `40ants-logging:setup-for-repl` &key (level :debug) (stream \*debug-io\*)

Configures `LOG4CL` for logging in `REPL` when you connect to the running lisp image already configured as a backend or `CLI` application.

If you are using [`40ants-slynk`][04ac] system, this function will be called automatically
when your `SLY` connects to the image.

<a id="x-2840ANTS-LOGGING-3AREMOVE-REPL-APPENDER-20FUNCTION-29"></a>

### [function](02df) `40ants-logging:remove-repl-appender`

Returns configuration the state as it was after [`setup-for-backend`][d0af] or [`setup-for-cli`][78f4] call.

If you are using [`40ants-slynk`][04ac] system, this function will be called automatically
when your `SLY` disconnects from the image.


[b464]: https://40ants.com/log4cl-extras/#x-28LOG4CL-EXTRAS-2FCONTEXT-3AWITH-FIELDS-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29
[3eb9]: https://40ants.com/logging/
[d0af]: https://40ants.com/logging/#x-2840ANTS-LOGGING-3ASETUP-FOR-BACKEND-20FUNCTION-29
[78f4]: https://40ants.com/logging/#x-2840ANTS-LOGGING-3ASETUP-FOR-CLI-20FUNCTION-29
[d1f2]: https://40ants.com/logging/#x-2840ANTS-LOGGING-3ASETUP-FOR-REPL-20FUNCTION-29
[04ac]: https://40ants.com/slynk/#x-28-23A-28-2812-29-20BASE-CHAR-20-2E-20-2240ants-slynk-22-29-20ASDF-2FSYSTEM-3ASYSTEM-29
[0aac]: https://github.com/40ants/logging
[2779]: https://github.com/40ants/logging/actions
[8d1b]: https://github.com/40ants/logging/blob/8c3957f7ef94be2caea0636605fe450ec5f17ac8/src/core.lisp#L122
[02df]: https://github.com/40ants/logging/blob/8c3957f7ef94be2caea0636605fe450ec5f17ac8/src/core.lisp#L149
[675e]: https://github.com/40ants/logging/blob/8c3957f7ef94be2caea0636605fe450ec5f17ac8/src/core.lisp#L38
[5c8f]: https://github.com/40ants/logging/blob/8c3957f7ef94be2caea0636605fe450ec5f17ac8/src/core.lisp#L95
[cd63]: https://github.com/40ants/logging/issues
[07be]: https://quickdocs.org/global-vars
[691c]: https://quickdocs.org/log4cl-extras

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
