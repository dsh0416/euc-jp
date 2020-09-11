# euc

EUC-JP and Shift_JIS Encoding and Decoding Library for Dart Language

[![Build Status](https://travis-ci.org/dsh0416/euc-jp.svg?branch=master)](https://travis-ci.org/dsh0416/euc-jp)

## Examples

```dart
import 'package:euc/euc.dart';
import 'package:euc/jis.dart';

main() {
  // EUC-JP Encoding and Decoding
  print(EucJP().decode([
    164, 170, 164, 207, 164, 232, 164, 166, 192, 164, 179, 166
  ]));

  print(EucJP().encode("おはよう世界"));

  // Shift_JIS Encoding and Decoding
  print(ShiftJIS().decode([
    130, 168, 130, 205, 130, 230, 130, 164, 144, 162, 138, 69
  ]));

  print(ShiftJIS().encode("おはよう世界"));
}
```
