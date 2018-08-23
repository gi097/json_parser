# JSON Parser for Flutter
[![Build Status](https://travis-ci.org/gi097/json_parser.svg?branch=develop)](https://travis-ci.org/gi097/json_parser)
[![Stars](http://starveller.sigsev.io/api/repos/gi097/json_parser/badge)](http://starveller.sigsev.io/gi097/json_parser)
[![Coverage Status](https://coveralls.io/repos/github/gi097/json_parser/badge.svg?branch=develop)](https://coveralls.io/github/gi097/json_parser?branch=develop)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](LICENSE)

Flutter does not provide support for auto mapping JSON to object instances.
This project is an attempt to make reflection work on Flutter. Using reflection we
are able to parse a JSON string and map it's values to an instance of a Dart object.

## Getting started
First of all add the following dependencies to your `pubspec.yaml`:

```
dependencies:
  json_parser: any
  build_runner: 0.8.3
```

Every Flutter/Dart application has a `main()` entry point. In that method
you need to add at least the following:

```dart
void main() {
  initializeReflectable();
}
```

You will see that the method `initializeReflectable()` is not declared. That is
fine, since you need to generate a code file first.

First create a `build.yaml` file in your Flutter application project. Then add the
following content:

```
targets:
  $default:
    builders:
      reflectable:
        generate_for:
          - lib/main.dart
        options:
          formatted: true
```

`lib/main.dart` points to the location of the Dart class containing the `main()`
method entry of your application.

Then open up your terminal in your project root and type the following:

```bash
flutter packages pub run build_runner build
```

As mentioned before, `lib/main.dart` specifies the folder name of the location of
the class containing the `main()` entry. Usually in Flutter applications this is
the `/lib` folder. If all goes well, you will see a generated `.reflectable.dart`
file. Import the generated class in your `main()` entry class.

In order to make the mapping work, you need to create a new Dart object which
has the same property names as your JSON. We are using the following example:

```json
{ "name":"John", "age":30, "car":null }
```

Then we will use the following Dart class:

```dart
import 'package:json_parser/reflectable.dart';

@reflectable
class DataClass {
  String name;
  int age;
  String car;
}
```

Note the usage of `@reflectable`. All your classes which will be used for JSON
parsing need to use this annotation.

Then you are all set and able to start the parsing. You can parse a JSON string
using the following method:

```dart
DataClass instance = new DataClass();
String json = '{ "name":"John", "age":30, "car":null }';
JsonParser.parseJObject<DataClass>(json, instance);
```

If all goes well, `instance` will automatically contain all your values specified
in the JSON.

You can also parse JSON arrays with a given type. However this is a bit more 
complex due limitations on Dart and Flutter:

```dart
String json = '[{ "name":"John", "age":30, "car":null },'
   '{ "name":"Giovanni", "age":20, "car":"Volkswagen" }]';
List<DataClass> buffer = new List<DataClass>();
int itemCount = JsonParser.getJArrayCount(json);
for (int i = 0; i < itemCount; i++) {
   buffer.add(new DataClass());
}
JsonParser.parseJArray<DataClass>(json, buffer);
```

## TODO's
Currently the parser is only being tested on primitive properties. Later
we will test and add support for more complex types such as nested objects.
