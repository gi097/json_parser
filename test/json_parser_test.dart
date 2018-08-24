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

  test('tests a single json object', () {
    String json = '{ "name":"John", "age":30, "car":null }';

    JsonParser parser = new JsonParser();
    DataClass instance = parser.parseJson<DataClass>(json);

    expect("John", instance.name);
    expect(30, instance.age);
    expect(null, instance.car);
  });

  test('tests byte data', () {
    String json = '{ "data":"QmFzZTY0IGlzIHdvcmtpbmch" }';

    JsonParser parser = new JsonParser();
    DataClass instance = parser.parseJson<DataClass>(json);

    expect("Base64 is working!", String.fromCharCodes(instance.data));
  });

  test('test a json array', () {
    String json = '[{ "name":"John", "age":30, "car":null },'
        '{ "name":"Giovanni", "age":20, "car":"Volkswagen" }]';

    JsonParser parser = new JsonParser();
    List buffer = parser.parseJson<DataClass>(json);

    expect("John", buffer[0].name);
    expect(30, buffer[0].age);
    expect(null, buffer[0].car);

    expect("Giovanni", buffer[1].name);
    expect(20, buffer[1].age);
    expect("Volkswagen", buffer[1].car);
  });

  test('test a json object with list properties', () {
    String json = '[{ "name":"John", "age":30, "car":null, '
        '"marks":[{ "mark":1 }, { "mark":10 }]}, '
        '{ "name":"Giovanni", "age":20, "car":"Volkswagen", '
        '"marks":[{ "mark":9 }]}]';

    JsonParser parser = new JsonParser();
    List buffer = parser.parseJson<DataClass>(json);

    expect("John", buffer[0].name);
    expect(30, buffer[0].age);
    expect(null, buffer[0].car);
    expect(1, buffer[0].marks[0].mark);
    expect(10, buffer[0].marks[1].mark);

    expect("Giovanni", buffer[1].name);
    expect(20, buffer[1].age);
    expect("Volkswagen", buffer[1].car);
    expect(9, buffer[1].marks[0].mark);
  });
}
