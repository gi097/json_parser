///
/// Json Parser
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
import 'package:test/test.dart';

import 'package:json_parser/json_parser.dart';
import 'data_class.dart';
import 'json_parser_test.reflectable.dart';

/// You MUST import reflectable to support code generation
import 'package:reflectable/reflectable.dart';

void main() {
  initializeReflectable();

  test('tests parsing of a simple json string', () {
    DataClass instance = new DataClass();
    String json = '{ "name":"John", "age":30, "car":null }';
    JsonParser.parseFromJsonString<DataClass>(json, instance);

    expect("John", instance.name);
    expect(30, instance.age);
    expect(null, instance.car);
  });
}
