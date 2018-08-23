///
/// Json Parser
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
library json_parser;

import 'dart:convert';

import 'package:json_parser/reflectable.dart';
import 'package:reflectable/mirrors.dart';

/// JsonParser lets you parse a json file. You need to provide an instance
/// of a class which contains all the properties declared in the json file.
/// JsonParser will then try to set the values for all the specified
/// properties.
class JsonParser {
  /// Parses the json and places all values of the properties in the correct
  /// location of the instance.
  static void parseFromJsonString<T>(String input, T instance) {
    InstanceMirror instanceMirror = reflectable.reflect(instance);
    Map<String, dynamic> converted = jsonDecode(input);
    // TODO: Test support for lists/arrays
    converted.forEach((k, v) => instanceMirror.invokeSetter(k, v));
  }
}
