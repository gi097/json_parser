///
/// Json Parser
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
import 'dart:typed_data';
import 'package:json_parser/reflectable.dart';

/// DataClass contains all properties which we declare in our json
@reflectable
class DataClass {
  String name = "";
  int age = 0;
  String car = "";
  Uint8List data = new Uint8List(0);

  /// You need to define lists like this. The cast method casts List<dynamic>
  /// to the correct type
  List<Mark> _marks = [];
  List<Mark> get marks => _marks;
  set marks(List list) {
    _marks = list.cast<Mark>();
  }

  List<double> _latlng = [];
  List<double> get latlng => _latlng;
  set latlng(List list) {
    _latlng = list.cast<double>();
  }
}

@reflectable
class Mark {
  int mark = 0;
}
