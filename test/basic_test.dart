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

    test('issue #5', () {
      expect(ShiftJIS().decode([142, 82, 250, 177, 32, 149, 113, 142, 247]),
          equals('山﨑 敏樹'));
    });

    test('Windows-31J Round Trip (IBM Kanji)', () {
      final cs = ShiftJIS();
      for (var c0 = 0xFA; c0 <= 0xFC; c0 += 1) {
        for (var c1 = 0x40; c1 <= 0xFC; c1 += 1) {
          if (c0 == 0xFA && (0x4A <= c1 && c1 <= 0x5B)) continue;
          if (c1 == 0x7F) continue;
          if (c0 == 0xFC && c1 == 0x4C) break;
          expect(cs.encode(cs.decode([c0, c1])), [c0, c1]);
        }
      }
    });

    test('Windows-31J Non Round Trip (IBM Kanji)', () {
      final cs = ShiftJIS();
      expect(cs.encode(cs.decode([0xFA, 0x40])), [0xFA, 0x40]);
      expect(cs.encode(cs.decode([0xFA, 0x41])), [0xFA, 0x41]);
      expect(cs.encode(cs.decode([0xFA, 0x42])), [0xFA, 0x42]);
      expect(cs.encode(cs.decode([0xFA, 0x43])), [0xFA, 0x43]);
      expect(cs.encode(cs.decode([0xFA, 0x44])), [0xFA, 0x44]);
      expect(cs.encode(cs.decode([0xFA, 0x45])), [0xFA, 0x45]);
      expect(cs.encode(cs.decode([0xFA, 0x46])), [0xFA, 0x46]);
      expect(cs.encode(cs.decode([0xFA, 0x47])), [0xFA, 0x47]);
      expect(cs.encode(cs.decode([0xFA, 0x48])), [0xFA, 0x48]);
      expect(cs.encode(cs.decode([0xFA, 0x49])), [0xFA, 0x49]);
      expect(cs.encode(cs.decode([0xFA, 0x4A])), [0x87, 0x54]);
      expect(cs.encode(cs.decode([0xFA, 0x4B])), [0x87, 0x55]);
      expect(cs.encode(cs.decode([0xFA, 0x4C])), [0x87, 0x56]);
      expect(cs.encode(cs.decode([0xFA, 0x4D])), [0x87, 0x57]);
      expect(cs.encode(cs.decode([0xFA, 0x4E])), [0x87, 0x58]);
      expect(cs.encode(cs.decode([0xFA, 0x4F])), [0x87, 0x59]);
      expect(cs.encode(cs.decode([0xFA, 0x50])), [0x87, 0x5A]);
      expect(cs.encode(cs.decode([0xFA, 0x51])), [0x87, 0x5B]);
      expect(cs.encode(cs.decode([0xFA, 0x52])), [0x87, 0x5C]);
      expect(cs.encode(cs.decode([0xFA, 0x53])), [0x87, 0x5D]);
      expect(cs.encode(cs.decode([0xFA, 0x54])), [0x81, 0xCA]);
      expect(cs.encode(cs.decode([0xFA, 0x55])), [0xFA, 0x55]);
      expect(cs.encode(cs.decode([0xFA, 0x56])), [0xFA, 0x56]);
      expect(cs.encode(cs.decode([0xFA, 0x57])), [0xFA, 0x57]);
      expect(cs.encode(cs.decode([0xFA, 0x58])), [0x87, 0x8A]);
      expect(cs.encode(cs.decode([0xFA, 0x59])), [0x87, 0x82]);
      expect(cs.encode(cs.decode([0xFA, 0x5A])), [0x87, 0x84]);
      expect(cs.encode(cs.decode([0xFA, 0x5B])), [0x81, 0xE6]);
    });

    test('Windows-31J Round Trip', () {
      final f = (text) {
        final cs = ShiftJIS();
        expect(cs.decode(cs.encode(text)), text);
      };
      f('FA40	ⅰ	ⅱ	ⅲ	ⅳ	ⅴ	ⅵ	ⅶ	ⅷ	ⅸ	ⅹ	Ⅰ	Ⅱ	Ⅲ	Ⅳ	Ⅴ	Ⅵ'
          'FA50	Ⅶ	Ⅷ	Ⅸ	Ⅹ	￢	￤	＇	＂	㈱	№	℡	∵ 纊	褜	鍈	銈'
          'FA60	蓜	俉	炻	昱	棈	鋹	曻	彅	丨	仡	仼	伀	伃	伹	佖	侒'
          'FA70	侊	侚	侔	俍	偀	倢	俿	倞	偆	偰	偂	傔	僴	僘	兊'
          'FA80	兤	冝	冾	凬	刕	劜	劦	勀	勛	匀	匇	匤	卲	厓	厲	叝'
          'FA90	﨎	咜	咊	咩	哿	喆	坙	坥	垬	埈	埇	﨏	塚	增	墲	夋'
          'FAA0	奓	奛	奝	奣	妤	妺	孖	寀	甯	寘	寬	尞	岦	岺	峵	崧'
          'FAB0	嵓	﨑	嵂	嵭	嶸	嶹	巐	弡	弴	彧	德	忞	恝	悅	悊	惞'
          'FAC0	惕	愠	惲	愑	愷	愰	憘	戓	抦	揵	摠	撝	擎	敎	昀	昕'
          'FAD0	昻	昉	昮	昞	昤	晥	晗	晙	晴	晳	暙	暠	暲	暿	曺	朎'
          'FAE0	朗	杦	枻	桒	柀	栁	桄	棏	﨓	楨	﨔	榘	槢	樰	橫	橆'
          'FAF0	橳	橾	櫢	櫤	毖	氿	汜	沆	汯	泚	洄	涇	浯'
          'FB40	涖	涬	淏	淸	淲	淼	渹	湜	渧	渼	溿	澈	澵	濵	瀅	瀇'
          'FB50	瀨	炅	炫	焏	焄	煜	煆	煇	凞	燁	燾	犱	犾	猤	猪	獷'
          'FB60	玽	珉	珖	珣	珒	琇	珵	琦	琪	琩	琮	瑢	璉	璟	甁	畯'
          'FB70	皂	皜	皞	皛	皦	益	睆	劯	砡	硎	硤	硺	礰	礼	神'
          'FB80	祥	禔	福	禛	竑	竧	靖	竫	箞	精	絈	絜	綷	綠	緖	繒'
          'FB90	罇	羡	羽	茁	荢	荿	菇	菶	葈	蒴	蕓	蕙	蕫	﨟	薰	蘒'
          'FBA0	﨡	蠇	裵	訒	訷	詹	誧	誾	諟	諸	諶	譓	譿	賰	賴	贒'
          'FBB0	赶	﨣	軏	﨤	逸	遧	郞	都	鄕	鄧	釚	釗	釞	釭	釮	釤'
          'FBC0	釥	鈆	鈐	鈊	鈺	鉀	鈼	鉎	鉙	鉑	鈹	鉧	銧	鉷	鉸	鋧'
          'FBD0	鋗	鋙	鋐	﨧	鋕	鋠	鋓	錥	錡	鋻	﨨	錞	鋿	錝	錂	鍰'
          'FBE0	鍗	鎤	鏆	鏞	鏸	鐱	鑅	鑈	閒	隆	﨩	隝	隯	霳	霻	靃'
          'FBF0	靍	靏	靑	靕	顗	顥	飯	飼	餧	館	馞	驎	髙'
          'FC40	髜	魵	魲	鮏	鮱	鮻	鰀	鵰	鵫	鶴	鸙	黑'
          '8740 ①	②	③	④	⑤	⑥	⑦	⑧	⑨	⑩	⑪	⑫	⑬	⑭	⑮	⑯'
          '8750	⑰	⑱	⑲	⑳	Ⅰ	Ⅱ	Ⅲ	Ⅳ	Ⅴ	Ⅵ	Ⅶ	Ⅷ	Ⅸ	Ⅹ		㍉'
          '8760	㌔	㌢	㍍	㌘	㌧	㌃	㌶	㍑	㍗	㌍	㌦	㌣	㌫	㍊	㌻	㎜'
          '8770	㎝	㎞	㎎	㎏	㏄	㎡									㍻'
          '8780	〝	〟	№	㏍	℡	㊤	㊥	㊦	㊧	㊨	㈱	㈲	㈹	㍾	㍽	㍼'
          '8790	≒	≡	∫	∮	∑	√	⊥	∠	∟	⊿	∵	∩	∪');
    });

    test('Windows-31J Symbols', () {
      final cs = ShiftJIS();
      expect(cs.decode([0x81, 0x5C]), equals('\u{2015}')); // ―
      expect(cs.decode([0x81, 0x60]), equals('\u{FF5E}')); // ～
      expect(cs.decode([0x81, 0x61]), equals('\u{2225}')); // ∥
      expect(cs.decode([0x81, 0x7C]), equals('\u{FF0D}')); // －
      expect(cs.decode([0x81, 0x91]), equals('\u{FFE0}')); // ￠
      expect(cs.decode([0x81, 0x92]), equals('\u{FFE1}')); // ￡
      expect(cs.decode([0x81, 0xCA]), equals('\u{FFE2}')); // ￢

      expect(cs.encode('\u{FF02}'), equals([0xFA, 0x57])); // ＂
      expect(cs.encode('\u{FF07}'), equals([0xFA, 0x56])); // ＇
      expect(cs.encode('\u{FF0D}'), equals([0x81, 0x7C])); // －
      expect(cs.encode('\u{FF5E}'), equals([0x81, 0x60])); // ～
      expect(cs.encode('\u{FFE0}'), equals([0x81, 0x91])); // ￠
      expect(cs.encode('\u{FFE1}'), equals([0x81, 0x92])); // ￡
      expect(cs.encode('\u{FFE2}'), equals([0x81, 0xCA])); // ￢
      expect(cs.encode('\u{FFE4}'), equals([0xFA, 0x55])); // ￤
    });

    test('Windows-31J Overlapping Symbols', () {
      final cs = ShiftJIS();
      final f = (u, List<List<int>> j) {
        expect(cs.encode(u), equals(j.first));
        for (final i in j) {
          expect(cs.decode(i), equals(u));
        }
      };
      f('\u{222A}', [
        [0x81, 0xBE],
        [0x87, 0x9C],
      ]);
      f('\u{2229}', [
        [0x81, 0xBF],
        [0x87, 0x9B],
      ]);
      f('\u{FFE2}', [
        [0x81, 0xCA],
        [0xEE, 0xF9],
        [0xFA, 0x54],
      ]);
      f('\u{2220}', [
        [0x81, 0xDA],
        [0x87, 0x97],
      ]);
      f('\u{22A5}', [
        [0x81, 0xDB],
        [0x87, 0x96],
      ]);
      f('\u{2261}', [
        [0x81, 0xDF],
        [0x87, 0x91],
      ]);
      f('\u{2252}', [
        [0x81, 0xE0],
        [0x87, 0x90],
      ]);
      f('\u{221A}', [
        [0x81, 0xE3],
        [0x87, 0x95],
      ]);
      f('\u{2235}', [
        [0x81, 0xE6],
        [0x87, 0x9A],
        [0xFA, 0x5B],
      ]);
      f('\u{222B}', [
        [0x81, 0xE7],
        [0x87, 0x92],
      ]);
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
