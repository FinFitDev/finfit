import 'package:excerbuys/layout.dart';
import 'package:excerbuys/pages/auth/auth_page.dart';
import 'package:excerbuys/pages/auth/reset_password.dart';
import 'package:excerbuys/pages/auth/reset_password_code.dart';
import 'package:excerbuys/pages/loading_page.dart';
import 'package:excerbuys/pages/auth/verify_email_page.dart';
import 'package:excerbuys/pages/auth/welcome_page.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/layout_wrapper.dart';
import 'package:flutter/material.dart';

void main() => runApp(HealthApp());

class HealthApp extends StatefulWidget {
  @override
  _HealthAppState createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        navigatorKey: NAVIGATOR_KEY,
        title: APP_TITLE,
        theme: ThemeData(
            scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 255, 255, 255),
              primary: Color.fromARGB(255, 255, 255, 255),
              primaryFixed: Color(0xFF191D23),
              primaryContainer: Color.fromARGB(255, 250, 250, 250),
              primaryFixedDim: const Color(0xFF999191),
              secondary: Color.fromARGB(255, 26, 108, 98),
              secondaryContainer: Color.fromARGB(255, 7, 66, 114),
              tertiary: const Color.fromARGB(255, 0, 0, 0),
              tertiaryContainer: Color.fromARGB(255, 184, 184, 184),
              error: Color.fromARGB(255, 255, 132, 132),
              errorContainer: Color.fromARGB(255, 255, 195, 83),
            ),
            textTheme: TextTheme(
                headlineLarge: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                headlineMedium: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF191D23),
                )),
            useMaterial3: true,
            fontFamily: 'Poppins'),
        initialRoute: "/",
        routes: {
          "/": (context) => LayoutWrapper(child: LoadingPage()),
          "/dashboard": (context) => LayoutWrapper(child: Layout()),
          "/login": (context) => LayoutWrapper(child: AuthPage()),
          "/welcome": (context) => LayoutWrapper(child: WelcomePage()),
          '/verify_email': (context) => LayoutWrapper(child: VerifyEmailPage()),
          "/reset_password_code": (context) =>
              LayoutWrapper(child: ResetPasswordCodePage()),
          "/set_new_password": (context) =>
              LayoutWrapper(child: ResetPassword()),
        },
      ),
    );
  }
}
