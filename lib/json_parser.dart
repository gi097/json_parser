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
  final Map<String, ClassMirror> classes = <String, ClassMirror>{};

  JsonParser() {
    for (ClassMirror classMirror in reflectable.annotatedClasses) {
      classes[classMirror.simpleName] = classMirror;
    }
  }

  /// Consumes a json object and parses it if needed. It will place all
  /// values of the properties in the correct location of a new instance.
  dynamic parseJson<T>(dynamic input) {
    return _parseJson(input, T);
  }

  dynamic _parseJson(dynamic input, Type type) {
    dynamic parsed;
    if (input is String) {
      parsed = jsonDecode(input);
    } else if (input is List) {
      parsed = input;
    } else {
      throw new UnsupportedError('The specified JSON input type is invalid.');
    }

    // Item is a single json object
    if (parsed is Map) {
      return _parseJsonObjectInternal(parsed, type);
    }

    // Item is a json array, loop through it
    List buffer = new List(parsed.length);
    for (int i = 0; i < parsed.length; i++) {
      buffer[i] = _parseJsonObjectInternal(parsed[i], type);
    }
    return buffer;
  }

  dynamic _parseJsonObjectInternal(Map input, Type type) {
    ClassMirror classMirror = reflectable.reflectType(type);
    dynamic instance = classMirror.newInstance("", []);

    // Map values to the specified instance of the object.
    InstanceMirror instanceMirror = reflectable.reflect(instance);
    input.forEach((k, v) {
      // This is a very ugly workaround since Dart has lots of limitations
      // regarding to types in Lists. Since we can only get a full name of a
      // List instance, we need to compare it to the declared reflectable
      // items. If we find a match, we get the type of that subtype of a List.
      // TODO: Make this better
      var property = instanceMirror.invokeGetter(k);

      classes.forEach((key, val) {
        if ('List<$key>' == property.runtimeType.toString()) {
          dynamic t = val.newInstance("", []);
          v = _parseJson(v, t.runtimeType);
        } else if (key == property.runtimeType.toString()) {
          dynamic t = val.newInstance("", []);
          v = _parseJsonObjectInternal(v, t.runtimeType);
        }
      });

      // Decode base64, we can only check types using strings...
      if ('Uint8List' == property.runtimeType.toString()) {
        v = base64Decode(v);
      }

      instanceMirror.invokeSetter(k, v);
    });

    return instance;
  }
}
