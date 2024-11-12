

class StringValidator {

  static const specialCharPattern = r'[!@#$%^&*(),.?":{}|<>]';
  static const sqlInjectionPatterns = [
    r"' or 1=1",  // 간단한 SQL 인젝션 패턴
    r"' or '1'='1", // 유사한 패턴
    r"--", // SQL 주석 패턴
    r"—",
    r";", // SQL 명령어 구분자
  ];

  String? validateNickname(String? nickname, int nicknameMaxLength) {
    // 1. 닉네임 값이 null인 경우
    if (nickname == null || nickname.isEmpty) {
      return '닉네임을 입력해주세요.';
    }

    // 3. 띄어쓰기가 존재하는 경우
    if (nickname.contains(' ')) {
      return '띄어쓰기는 사용할 수 없습니다.';
    }

    // 4. 문자열 'null'이 포함되는 경우
    if (nickname.toLowerCase().contains('null')) {
      return 'null 을 포함한 문자열은 사용할 수 없습니다.';
    }

    if (RegExp(specialCharPattern).hasMatch(nickname)) {
      return '특수문자는 사용할 수 없습니다.';
    }

    print(nickname);
    for (var pattern in sqlInjectionPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(nickname)) {
        return '사용할 수 없는 닉네임 입니다.';
      }
    }

    if (nickname.length < 2 || nickname.length > nicknameMaxLength) {
      return '닉네임은 2자 ~ $nicknameMaxLength자까지 사용할 수 있습니다.';
    }

    // 닉네임이 모든 검사를 통과한 경우
    return null;
  }
}