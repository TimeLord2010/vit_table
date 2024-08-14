// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

bool isMobile() {
  var userAgent = window.navigator.userAgent;
  return userAgent.contains('Android') ||
      userAgent.contains('iPhone') ||
      userAgent.contains('iPad');
}
