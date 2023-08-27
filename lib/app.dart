import 'package:alertus/core/constants/font.dart';
import 'package:alertus/core/constants/router.dart';
import 'package:alertus/core/utils/scroll_behaviour_utils.dart';
import 'package:alertus/screens/home_screen.dart';
import 'package:alertus/screens/login_screen.dart';
import 'package:alertus/screens/register_screen.dart';
import 'package:alertus/screens/role_screen.dart';
import 'package:alertus/screens/setting_screen.dart';
import 'package:alertus/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Alert Us',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            fontFamily: BaseFonts.gilroy,
          ),
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: const ScrollBehaviourUtils(),
              child: child ?? Container(),
            );
          },
          home: const SplashScreen(),
          routes: {
            ROUTER.role: (context) => const RoleScreen(),
            ROUTER.login: (context) => const LoginScreen(),
            ROUTER.register: (context) => const RegisterScreen(),
            ROUTER.home: (context) => const HomeScreen(),
            ROUTER.setting: (context) => const SettingScreen(),
          },
        );
      },
    );
  }
}