import 'package:flutter/cupertino.dart';

import 'package:innout/model/transaction_type.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'In And Out',
    },
    'zh': {
      'title': '出入',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'] ?? 'In And Out';
  }

  String transactionTypeToString(TransactionType transactionType) {
    var typeToString = {
      TransactionType.clothing: '衣物',
      TransactionType.food: '饮食',
      TransactionType.grocery: '生活用品',
      TransactionType.electronics: '电子',
      TransactionType.office: '办公用品',
      TransactionType.salary: '工资',
      TransactionType.stock: '股票',
      TransactionType.option: '债券',
      TransactionType.gift: '礼品',
      TransactionType.others: '其他'
    };

    return typeToString[transactionType] ?? 'null';
  }
}

AppLocalizations localizations;
