import 'package:flutter/foundation.dart';

enum DisplayType { single, day, month, year, category }

extension DisplayTypeExtension on DisplayType {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case DisplayType.single: return '次';
      case DisplayType.day: return '日';
      case DisplayType.month: return '月';
      case DisplayType.year: return '年';
      case DisplayType.category: return '类';
      default: return '';
    }
  }
}