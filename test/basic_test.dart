import 'package:test/test.dart';

import 'package:euc/euc.dart';
import 'package:euc/jis.dart';

main() {
  group('EucJP()', () {
    test('.encode()', () {
      expect(EucJP().encode("おはよう世界"),
          equals([164, 170, 164, 207, 164, 232, 164, 166, 192, 164, 179, 166]));
    });

    test('.decode()', () {
      expect(
          EucJP().decode(
              [164, 170, 164, 207, 164, 232, 164, 166, 192, 164, 179, 166]),
          equals("おはよう世界"));
    });

    test('.encoder.bind()', () async {
      final input = () async* {
        yield "おはよ";
        yield "う世界";
      }();
      expect(
          await EucJP()
              .encoder
              .bind(input)
              .fold<List<int>>([], (previous, element) => previous + element),
          equals([164, 170, 164, 207, 164, 232, 164, 166, 192, 164, 179, 166]));
    });

    test('.decodeStream()', () async {
      final input = () async* {
        yield [164, 170, 164, 207, 164];
        yield [232, 164, 166, 192, 164, 179];
        yield [166];
      }();
      expect(await EucJP().decodeStream(input), equals("おはよう世界"));
    });
  });

  group('ShiftJIS()', () {
    test('.encode()', () {
      expect(ShiftJIS().encode("おはよう世界"),
          equals([130, 168, 130, 205, 130, 230, 130, 164, 144, 162, 138, 69]));
    });

    test('.decode()', () {
      expect(
          ShiftJIS().decode(
              [130, 168, 130, 205, 130, 230, 130, 164, 144, 162, 138, 69]),
          equals("おはよう世界"));
    });

    test('.encoder.bind()', () async {
      final input = () async* {
        yield "おはよ";
        yield "う世界";
      }();
      expect(
          await ShiftJIS()
              .encoder
              .bind(input)
              .fold<List<int>>([], (previous, element) => previous + element),
          equals([130, 168, 130, 205, 130, 230, 130, 164, 144, 162, 138, 69]));
    });

    test('.decodeStream()', () async {
      final input = () async* {
        yield [130, 168, 130, 205, 130];
        yield [230, 130, 164, 144, 162, 138];
        yield [69];
      }();
      expect(await ShiftJIS().decodeStream(input), equals("おはよう世界"));
    });
  });
}
