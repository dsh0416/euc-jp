import 'package:euc/euc.dart';

main() {
  print(EucJP().decoder.convert([
    164, 170, 164, 207, 164, 232, 164, 166, 192, 164, 179, 166
  ]));

  print(EucJP().encoder.convert("おはよう世界"));
}
