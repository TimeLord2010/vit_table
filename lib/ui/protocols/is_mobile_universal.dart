import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

bool isMobile() {
  if (kIsWeb) return false;
  return Platform.isAndroid || Platform.isIOS;
}
