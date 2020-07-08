extension DoubleHelpers on double {
  String toCommaString() {
    String text = this.toStringAsFixed(1).split('.')[0];
    String valStr = this.toStringAsFixed(2).toString();
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

    text += '.' + valStr.substring(valStr.length - 2, valStr.length);

    return text;
  }
}
