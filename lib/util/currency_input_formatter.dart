import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    print(oldValue.text);
    print(newValue.text);

    bool withDot = false;
    String afterDot;

    if (newValue.text.contains('.')) {
      if (newValue.text.lastIndexOf('.') != newValue.text.indexOf('.')) {
        print('A1 the final value is ${oldValue.text}');
        return oldValue;
      }
      afterDot = newValue.text.split('.')[1];
      if (afterDot.length > 2) {
        print('A2 the final value is ${oldValue.text}');
        return oldValue;
      }

      withDot = true;
    }

    String text = newValue.text.replaceAll(',', '');
    double val = double.parse(text);
    String valStr = val.toStringAsFixed(2).toString();
    String beforeDot = valStr.substring(0, valStr.length - 3);

    if (beforeDot.length > 3) {
      text = beforeDot.replaceRange(beforeDot.length - 3, beforeDot.length - 3, ',');
    }
    if (beforeDot.length > 6) {
      text = text.replaceRange(text.length - 7, text.length - 7, ',');
    }
    if (beforeDot.length > 9) {
      text = text.replaceRange(text.length - 11, text.length - 11, ',');
    }
    if (beforeDot.length > 12) {
      text = text.replaceRange(text.length - 15, text.length - 15, ',');
    }

    //text += withDot ? '$afterDot' : '';

    print("B the final value is $text the afterdot is $afterDot");

    TextEditingValue textEditingValue = TextEditingValue(text: text, selection: TextSelection.fromPosition(TextPosition(offset: text.length)));

    return textEditingValue;
  }
}
