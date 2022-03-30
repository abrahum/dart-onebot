/// Support for doing something awesome.
///
/// More dartdocs go here.
library onebot;

import 'package:logging/logging.dart';

export 'event.dart';
export 'message.dart';
export 'impl.dart';
export 'app.dart';
export 'action.dart';
export 'src/comms.dart';
export 'src/error.dart';
export 'src/utils.dart';

final logger = Logger('onebot');

// TODO: Export any libraries intended for clients of this package.
