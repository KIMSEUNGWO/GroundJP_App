import 'dart:ui';

import 'package:groundjp/component/search_word_helper.dart';
import 'package:groundjp/domain/enums/language_enum.dart';

enum Region {
  ALL("전국", "All", "全国"),

  // 홋카이도 지방
  HOKKAIDO("홋카이도", "Hokkaido", "北海道"),

  // 도호쿠 지방
  AOMORI("아오모리현", "Aomori", "青森県"),
  AKITA("아키타현", "Akita", "秋田県"),
  YAMAGATA("야마가타현", "Yamagata", "山形県"),
  IWATE("이와테현", "Iwate", "岩手県"),
  FUKUSHIMA("후쿠시마현", "Fukushima", "福島県"),
  MIYAGI("미야기현", "Miyagi", "宮城"),

  // 간토 지방
  KANAGAWA("가나가와현", "Kanagawa", "神奈川県"),
  GUNMA("군마현", "Gunma", "群馬県"),
  TOCHIGI("도치기현", "Tochigi", "栃木県"),
  TOKYO("도쿄도", "Tokyo", "東京都"),
  SAITAMA("사이타마현", "Saitama", "埼玉県"),
  IBARAKI("이바라키현", "Ibaraki", "茨城県"),
  CHIBA("치바현", "Chiba", "千葉県"),

  // 주부 지방
  GIFU("기후현", "Gifu", "岐阜県"),
  NAGANO("나가노현", "Nagano", "長野県"),
  NIIGATA("니가타현", "Niigata", "新潟県"),
  TOYAMA("토야마현", "Toyama", "富山県"),
  SHIZUOKA("시즈오카현", "Shizuoka", "静岡県"),
  AICHI("아이치현", "Aichi", "愛知県"),
  YAMANASHI("야마나시현", "Yamanashi", "山梨県"),
  ISHIKAWA("이시카와현", "Ishikawa", "石川県"),
  FUKUI("후쿠이현", "Fukui", "福井県"),

  // 긴키 지방
  KYOTO("교토부", "Kyoto", "京都府"),
  NARA("나라현", "Nara", "奈良県"),
  MIE("미에현", "Mie", "三重県"),
  SHIGA("시가현", "Shiga", "滋賀県"),
  OSAKA("오사카부", "Osaka", "大阪府"),
  WAKAYAMA("와카야마현", "Wakayama", "和歌山県"),
  HYOGO("효고현", "Hyogo", "兵庫県"),

  // 주고쿠 지방
  TOTTORI("돗토리현", "Tottori", "鳥取県"),
  SHIMANE("시마네현", "Shimane", "島根県"),
  YAMAGUCHI("야마구치현", "Yamaguchi", "山口県"),
  OKAYAMA("오카야마현", "Okayama", "岡山県"),
  HIROSHIMA("히로시마현", "Hiroshima", "広島県"),

  // 시코쿠 지방
  KAGAWA("가가와현", "Kagawa", "香川県"),
  KOCHI("고치현", "Kochi", "高知県"),
  TOKUSHIMA("도쿠시마현", "Tokushima", "徳島県"),
  EHIME("에히메현", "Ehime", "愛媛県"),

  // 규슈 지방
  KAGOSHIMA("가고시마현", "Kagoshima", "鹿児島県"),
  KUMAMOTO("구마모토현", "Kumamoto", "熊本県"),
  NAGASAKI("나가사키현", "Nagasaki", "長崎県"),
  MIYAZAKI("미야자키현", "Miyazaki", "宮崎県"),
  SAGA("사가현", "Saga", "佐賀県"),
  OITA("오이타현", "Oita", "大分県"),
  OKINAWA("오키나와현", "Okinawa", "沖縄県"),
  FUKUOKA("후쿠오카현", "Fukuoka", "福岡県");
  
  final String ko, en, jp;

  const Region(this.ko, this.en, this.jp);

  static Region? valueOf(String? data) {
    List<Region> values = Region.values;
    for (var o in values) {
      if (o.name == data) return o;
    }
    return null;
  }

  bool isStartWith(LanguageType langType, String word) {
    return _getRegion(langType).toLowerCase().startsWith(word);
  }

  String _getRegion(LanguageType langType) {
    return switch (langType) {
      LanguageType.JP => jp,
      LanguageType.KO => ko,
      LanguageType.EN => en
    };
  }

  int compareTo(Region o2, LanguageType langType) {
    return _getRegion(langType).compareTo(o2._getRegion(langType));
  }

  static Region findByName(String? regionName) {
    return Region.values
        .firstWhere(
          (region) => region.name == regionName,
          orElse: () => Region.ALL
        );
  }

  String getLocaleName(Locale locale) {
    return _getRegion(LanguageType.getType(locale));
  }

  static SearchWordData searchLanguage(String word) {
    word = word.toLowerCase();
    for (var region in Region.values) {
      
      SearchWordData? name = _search(word, region.name.toLowerCase(), region);
      if (name != null) return name;
      SearchWordData? jp = _search(word, region.jp, region);
      if (jp != null) return jp;
      SearchWordData? ko = _search(word, region.ko, region);
      if (ko != null) return ko;
      SearchWordData? en = _search(word, region.en.toLowerCase(), region);
      if (en != null) return en;
    }

    return SearchWordData(word, null);
  }
  
  static SearchWordData? _search(String word, String compare, Region compareRegion) {
    int index = word.indexOf(compare);
    if (index != -1) {
      String replace = word.replaceRange(index, index + compare.length, '');
      return SearchWordData(replace, compareRegion);
    } else {
      return null;
    }
  }
  
}