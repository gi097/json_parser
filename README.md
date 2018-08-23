# JSON Parser for Flutter
Flutter does not provide support for auto mapping JSON to object instances.
This project is an attempt to make reflection work on Flutter. Using reflection we
are able to parse a JSON string and map it's values to an instance of a Dart object.

## Getting started
Every Flutter/Dart application has a `main()` entry point. In that class and method
you need to add at least the following:

```dart
import 'package:reflectable/reflectable.dart';

void main() {
  initializeReflectable();
}
```

You will see that the method `initializeReflectable()` is not declared. That is
fine, since you need to generate a code file first.

First create a `build.yml` file in your Flutter application project. Then add the
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
flutter packages pub run lib/main.dart build
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
JsonParser.parseFromJsonString<DataClass>(json, instance);
```

If all goes well, `instance` will automatically contain all your values specified
in the JSON.

## TODO's
Currently the parser is only being tested on `String` and `int` types. Later
we will add support for more complex types such as arrays and nested objects.
