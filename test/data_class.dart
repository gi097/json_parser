///
/// Json Parser
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
import 'package:json_parser/reflectable.dart';

/// DataClass contains all properties which we declare in our json
@reflectable
class DataClass {
  String name;
  int age;
  String car;

  /// You need to define lists like this. The cast method casts List<dynamic>
  /// to the correct type
  List<Mark> _marks = [];
  List<Mark> get marks => _marks;
  set marks(List list) {
    _marks = list.cast<Mark>();
  }
}

@reflectable
class Mark {
  int mark;
}
