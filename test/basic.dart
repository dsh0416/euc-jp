import 'package:test/test.dart';

import 'package:euc/euc.dart';
import 'package:euc/jis.dart';

main() {
  group('EucJP()', () {
    test('.encode()', () {
      expect(EucJP().encode("おはよう世界"), equals([
        164, 170, 164, 207, 164, 232, 164, 166, 192, 164, 179, 166
      ]));
    });

    test('.decode()', () {
      expect(EucJP().decode([
        164, 170, 164, 207, 164, 232, 164, 166, 192, 164, 179, 166
      ]), equals("おはよう世界"));
    });
  });
  

  group('ShiftJIS()', () {
    test('.encode()', () {
      expect(ShiftJIS().encode("おはよう世界"), equals([
        130, 168, 130, 205, 130, 230, 130, 164, 144, 162, 138, 69
      ]));
    });

    test('.decode()', () {
      expect(EucJP().decode([
        164, 170, 164, 207, 164, 232, 164, 166, 192, 164, 179, 166
      ]), equals("おはよう世界"));
    });
  });
}
