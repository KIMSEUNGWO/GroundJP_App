
import 'dart:ui';

enum LanguageType {

  KO,
  EN,
  JP;

  static LanguageType getLangType(String word) {
    bool hasJapanese = word.contains(RegExp(r'[ぁ-ゔ\u4E00-\u9FFF]'));
    if (hasJapanese) return LanguageType.JP;

    bool hasKorean = word.contains(RegExp(r'[가-힣]'));
    if (hasKorean) return LanguageType.KO;

    bool hasEnglish = word.contains(RegExp(r'[a-zA-Z]'));
    if (hasEnglish) return LanguageType.EN;

    // 언어 판별이 모호한 경우 기본값 반환
    return LanguageType.JP;
  }

  static LanguageType getType(Locale locale) {
    if (locale.languageCode == 'ja') return LanguageType.JP;
    if (locale.languageCode == 'ko') return LanguageType.KO;
    if (locale.languageCode == 'en') return LanguageType.EN;
    return LanguageType.JP;
  }
}