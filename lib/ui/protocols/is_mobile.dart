import 'is_mobile_universal.dart' if (dart.library.html) 'is_mobile_web.dart'
    as imp;

bool isMobile() => imp.isMobile();
