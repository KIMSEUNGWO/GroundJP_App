import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:groundjp/widgets/init.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  await initServices();
  runApp(const ProviderScope(child: MyApp()));
}

initServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 로케일 데이터 를 초기화 합니다.
  await initializeDateFormatting();

  // LINE Login API 연동
  LineSDK.instance.setup('2005763087').then((_) => print('LineSDK Prepared'));

  // KAKAO API 연동
  KakaoSdk.init(
    nativeAppKey: '846cc1cb59dc2342563d230f78e577cd',
    javaScriptAppKey: '037e9d8910b3cbec6a1e2e16b22dfb29',
  );

  // 가로모드 방지
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932), // IPhone 15 Pro Max Size
      builder: (context, child) {
        return MaterialApp(
          title: 'GroundJP',
          theme: themeData(),
          color: const Color(0xFFF1F3F5),
          home: const InitApp(),
        );
      },
    );
  }
}


themeData() {
  return ThemeData(
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: const Color(0xFFF1F3F5),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xFFF1F3F5),
      titleTextStyle: TextStyle(
        color: const Color(0xFF292929),
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 1.4.h,
      ),
    ),

    colorScheme: const ColorScheme.light(

      onPrimary: Color(0xFF2F69DD), // 메인 컬러 1
      onSecondary: Color(0xFF77C0F4), // 메인 컬러 2
      onTertiary: Color(0xFFE9F1FA), // 메인 컬러 3

      primary: Color(0xFF292929), // 폰트 컬러 1
      secondary: Color(0xFF767676), // 폰트 컬러 2
      tertiary: Color(0xFF999999), // 폰트 컬러 2

      error: Color(0xFFFF5D5D)
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 20.sp,
        color: const Color(0xFF292929),
        fontWeight: FontWeight.w600,
        height: 1.4.h,
      ),
      displayMedium: TextStyle(
        fontSize: 18.sp,
        color: const Color(0xFF292929),
      ),
      displaySmall: TextStyle(
        fontSize: 16.sp,
        color: const Color(0xFF292929)
      ),
      bodyLarge: TextStyle(
        fontSize: 14.sp,
        color: const Color(0xFF292929)
      ),
      bodyMedium: TextStyle(
        fontSize: 12.sp,
        color: const Color(0xFF797979)
      ),
      bodySmall: TextStyle(
        fontSize: 10.sp,
        color: const Color(0xFF797979)
      ),
    ),

  );
}
