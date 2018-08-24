///
/// Json Parser
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
library json_parser;

import 'dart:convert';

import 'package:json_parser/reflectable.dart';
import 'package:reflectable/mirrors.dart';

/// JsonParser lets you parse a json file. You must provide a type
/// of a class which contains all the properties declared in the json file.
/// JsonParser will then try to set the values for all the specified
/// properties.
class JsonParser {

  /// Consumes a json object and parses it if needed. It will place all
  /// values of the properties in the correct location of a new instance.
  static dynamic parseJson<T>(dynamic input) {
    dynamic parsed;
    if (input is String) {
      parsed = jsonDecode(input);
    } else if (input is List) {
      parsed = input;
    } else if (input is Map) {
      return _parseJsonObjectInternal<T>(input);
    } else {
      throw new UnsupportedError('The specified JSON input type is invalid.');
    }

    if (parsed is Map) {
      return _parseJsonObjectInternal<T>(parsed);
    }

    List<T> buffer = new List(parsed.length);
    for (int i = 0; i < parsed.length; i++) {
      buffer[i] = _parseJsonObjectInternal<T>(parsed[i]);
    }

    return buffer;
  }

  static dynamic _parseJsonObjectInternal<T>(dynamic input) {
    Map<String, dynamic> parsed;
    if (input is String) {
      parsed = jsonDecode(input);
    } else if (input is Map) {
      parsed = input;
    } else {
      throw new UnsupportedError('The specified JSON input type is invalid.');
    }

    ClassMirror classMirror = reflectable.reflectType(T);
    T instance = classMirror.newInstance("", null);

    // Map values to the specified instance of the object.
    InstanceMirror instanceMirror = reflectable.reflect(instance);
    parsed.forEach((k, v) {
      if (v is List) {
        // TODO: get the type of a list inside the instance
      }
      instanceMirror.invokeSetter(k, v);
    });

    return instance;
  }
}
