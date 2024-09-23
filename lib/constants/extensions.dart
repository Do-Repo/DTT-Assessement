extension DollarFormat on num {
  String toDollarString() {
    final parts = toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    // Add commas to the integer part
    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }

    // Return the formatted string with a dollar sign
    if (decimalPart == '00') return '\$${buffer.toString()}';

    return '\$${buffer.toString()}.$decimalPart';
  }
}

extension IntExtension on int? {
  String? toNullableString() {
    if (this == null) {
      return null;
    } else {
      return toString();
    }
  }
}
