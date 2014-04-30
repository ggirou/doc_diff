DART_VERSION=`dart --version 2>&1 | sed -E "s/Dart VM version: (.+) \(.+/\\1/"`

cat /dev/null > .dart
docgen --out dart-sdk/$DART_VERSION --parse-sdk .dart
rm .dart
