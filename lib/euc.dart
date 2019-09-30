import 'dart:convert';
import './euc-table.dart';

class EucJPDecoder extends Converter<List<int>, String> {
  @override
  convert(input) {
    List<int> result = [];
    for (int i = 0; i < input.length; i++) {
      var c1 = input[i];
      if (c1 <= 0x7E) {
        // ASCII Compatible
        result.addAll(EUC_TABLE[c1] ?? []);
      } else if (c1 == 0x8e) {
        // Hiragana
        var c2 = input[++i];
        result.addAll(EUC_TABLE[(c1 << 8) + c2] ?? []);
      } else if (c1 == 0x8f) {
        // JIS X 0212
        var c2 = input[++i];
        var c3 = input[++i];
        result.addAll(EUC_TABLE[(c1 << 16) + (c2 << 8) + c3] ?? []);
      } else {
        // JIS X 0208
        var c2 = input[++i];
        result.addAll(EUC_TABLE[(c1 << 8) + c2] ?? []);
      }
    }
    return utf8.decode(result);
  }
}

class EucJP extends Encoding {
  @override
  Converter<List<int>, String> get decoder => EucJPDecoder();

  @override
  // TODO: implement encoder
  Converter<String, List<int>> get encoder => null;

  @override
  String get name => 'EUC-JP';
}
