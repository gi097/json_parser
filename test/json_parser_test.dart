///
/// Json Parser
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
import 'package:test/test.dart';

import 'package:json_parser/json_parser.dart';
import 'data_class.dart';
import 'json_parser_test.reflectable.dart';

void main() {
  initializeReflectable();

  test('tests parsing of a simple json string', () {
    DataClass instance = new DataClass();
    String json = '{ "name":"John", "age":30, "car":null }';
    JsonParser.parseJObject<DataClass>(json, instance);

    expect("John", instance.name);
    expect(30, instance.age);
    expect(null, instance.car);
  });

  test('tests parsing of a json list', () {
    String json = '[{ "name":"John", "age":30, "car":null },'
        '{ "name":"Giovanni", "age":20, "car":"Volkswagen" }]';

    // We need to do pre-fill the list. This can't be done using only a Type,
    // since dart does not support deep copy or creating an instance of only
    // a type.
    List<DataClass> buffer = new List<DataClass>();
    int itemCount = JsonParser.getJArrayCount(json);
    for (int i = 0; i < itemCount; i++) {
      buffer.add(new DataClass());
    }
    JsonParser.parseJArray<DataClass>(json, buffer);

    expect("John", buffer[0].name);
    expect(30, buffer[0].age);
    expect(null, buffer[0].car);

    expect("Giovanni", buffer[1].name);
    expect(20, buffer[1].age);
    expect("Volkswagen", buffer[1].car);
  });
}
