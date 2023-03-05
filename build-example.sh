#!/bin/bash

set -e

clpm bundle exec ros run -- --eval '(asdf:make "40ants-logging-example")' --quit

mv src/logging-example ./
