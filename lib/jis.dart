import 'dart:convert';
import 'dart:math';
import './jis-table.dart';

class JISDecoder extends Converter<List<int>, String> {
  @override
  convert(input) {
    List<int> result = [];
    for (int i = 0; i < input.length; i++) {
      var c1 = input[i];
      if (c1 <= 0x7F) {
        // ASCII Compatible (partially)
        result.addAll(JIS_TABLE[c1] ?? []);
      } else if (c1 >= 0xa1 && c1 <= 0xdf) {
        // Half-width Hiragana
        result.addAll(JIS_TABLE[c1] ?? []);
      } else if (c1 >= 0x81 && c1 <= 0x9f) {
        // JIS X 0208
        var c2 = input[++i];
        result.addAll(JIS_TABLE[(c1 << 8) + c2] ?? []);
      } else if (c1 >= 0xe0 && c1 <= 0xef) {
        // JIS X 0208
        var c2 = input[++i];
        result.addAll(JIS_TABLE[(c1 << 8) + c2] ?? []);
      } else if (c1 >= 0xfa && c1 <= 0xfc) {
        // JIS X 0208
        var c2 = input[++i];
        result.addAll(JIS_TABLE[(c1 << 8) + c2] ?? []);
      } else {
        // Unknown
        result.addAll([]);
      }
    }
    return utf8.decode(result);
  }

  @override
  Sink<List<int>> startChunkedConversion(Sink<String> sink) =>
      _ByteConversionSink(sink);
}

class JISEncoder extends Converter<String, List<int>> {
  @override
  List<int> convert(String s) {
    List<int> result = [];
    for (int i = 0; i < s.length; i++) {
      var bytes = utf8.encode(s[i]);
      var value = 0;

      for (var i = 0, length = bytes.length; i < length; i++) {
        value += bytes[i] * (pow(256, (bytes.length - i - 1)) as int);
      }

      result.addAll(UTF_TABLE[value] ?? []);
    }
    return result;
  }

  @override
  Sink<String> startChunkedConversion(Sink<List<int>> sink) =>
      _StringConversionSink(sink, this);
}

class ShiftJIS extends Encoding {
  @override
  Converter<List<int>, String> get decoder => JISDecoder();

  @override
  Converter<String, List<int>> get encoder => JISEncoder();

  @override
  String get name => 'Shift_JIS';
}

class _ByteConversionSink extends ByteConversionSinkBase {
  _ByteConversionSink(this._sink)
      : _utf8sink = ByteConversionSink.withCallback(
          (accumulated) => _sink.add(utf8.decode(accumulated)),
        );
  final Sink<String> _sink;
  final ByteConversionSink _utf8sink;
  int? _c1;

  @override
  void add(List<int> chunk) {
    addSlice(chunk, 0, chunk.length, false);
  }

  @override
  void addSlice(List<int> input, int start, int end, bool isLast) {
    int i = start;
    while (i < end) {
      var c1 = _c1 ?? input[i++];
      if (c1 <= 0x7F) {
        // ASCII Compatible (partially)
        _utf8sink.add(JIS_TABLE[c1] ?? []);
        _c1 = null;
      } else if (c1 >= 0xa1 && c1 <= 0xdf) {
        // Half-width Hiragana
        _utf8sink.add(JIS_TABLE[c1] ?? []);
        _c1 = null;
      } else if (c1 >= 0x81 && c1 <= 0x9f) {
        if (i < end) {
          // JIS X 0208
          var c2 = input[i++];
          _utf8sink.add(JIS_TABLE[(c1 << 8) + c2] ?? []);
          _c1 = null;
        } else {
          _c1 = c1;
        }
      } else if (c1 >= 0xe0 && c1 <= 0xef) {
        if (i < end) {
          // JIS X 0208
          var c2 = input[i++];
          _utf8sink.add(JIS_TABLE[(c1 << 8) + c2] ?? []);
          _c1 = null;
        } else {
          _c1 = c1;
        }
      } else {
        // Unknown
        _utf8sink.add([]);
        _c1 = null;
      }
    }
    if (isLast) {
      close();
    }
  }

  @override
  void close() {
    var c1 = _c1 ?? 0xFF;
    if (c1 <= 0x7F) {
      // ASCII Compatible (partially)
      _utf8sink.add(JIS_TABLE[c1] ?? []);
    }
    _utf8sink.close();
    _sink.close();
  }
}

class _StringConversionSink extends StringConversionSinkMixin {
  _StringConversionSink(this._sink, this._encoder);
  final Sink<List<int>> _sink;
  final Converter<String, List<int>> _encoder;

  @override
  void add(String str) {
    _sink.add(_encoder.convert(str));
  }

  @override
  void addSlice(String str, int start, int end, bool isLast) {
    _sink.add(_encoder.convert(str.substring(start, end)));
    if (isLast) {
      _sink.close();
    }
  }

  @override
  void close() {
    _sink.close();
  }
}
