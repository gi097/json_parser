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
  static void parseJObject<T>(String input, T instance) {
    InstanceMirror instanceMirror = reflectable.reflect(instance);
    Map<String, dynamic> converted = jsonDecode(input);
    converted.forEach((k, v) => instanceMirror.invokeSetter(k, v));
  }

  /// Consumes a list and parses the json and places all values of the
  /// properties in the correct location of the instance.
  /// Buffer is expected to contain the proper amount of items.
  static void parseJArray<T>(String input, List<T> buffer) {
    List<dynamic> converted = jsonDecode(input);
    assert(converted.length == buffer.length);

    for (int i = 0; i < converted.length; i++) {
      InstanceMirror instanceMirror = reflectable.reflect(buffer[i]);
      converted[i].forEach((k, v) {
        instanceMirror.invokeSetter(k, v);
      });
    }
  }

  /// Useful method for a caller to determine how much items the buffer needs
  /// to contain.
  static int getJArrayCount(String input) {
    List<dynamic> converted = jsonDecode(input);
    return converted.length;
  }
}
