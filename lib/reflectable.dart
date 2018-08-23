///
/// Json Parser
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///
library json_parser;

import 'package:reflectable/reflectable.dart';

class Reflector extends Reflectable {
  const Reflector() : super(invokingCapability);
}

/// Use this annotation to make a class reflectable
const reflectable = const Reflector();
