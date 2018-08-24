#!/bin/bash

# Fast fail the script on failures.
set -e

# Use the version of Dart SDK from the Flutter repository instead of whatever
# version is in the PATH.
export PATH="../flutter/bin/cache/dart-sdk/bin:$PATH"

echo "Path to dart is:"
which dart

echo "Using Dart version:"
dart --version

../flutter/bin/flutter packages get

echo "Generating code for reflection."

../flutter/bin/flutter packages pub run build_runner build

echo "Analyzing the extracted Dart libraries."

../flutter/bin/flutter analyze lib test

../flutter/bin/flutter test

if [ "$COVERALLS_TOKEN" ]; then
  echo "Found coveralls key. Starting coveralls process..."
  ../flutter/bin/flutter packages pub global activate dart_coveralls
  ../flutter/bin/flutter packages pub global run dart_coveralls report \
    --token $COVERALLS_TOKEN \
    --retry 2 \
    --exclude-test-files \
    test/json_parser_test.dart
fi
