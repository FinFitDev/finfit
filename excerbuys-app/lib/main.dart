import 'package:excerbuys/layout.dart';
import 'package:excerbuys/pages/auth_page.dart';
import 'package:excerbuys/pages/loading_page.dart';
import 'package:excerbuys/pages/welcome_page.dart';
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
                primaryContainer: Color.fromARGB(255, 244, 244, 244),
                primaryFixedDim: const Color(0xFF999191),
                secondary: Color.fromARGB(255, 108, 180, 238),
                tertiary: const Color.fromARGB(255, 0, 0, 0),
                tertiaryContainer: Color.fromARGB(255, 168, 168, 168),
                error: Color(0xFFFA6161)),
            useMaterial3: true,
            fontFamily: 'Poppins'),
        initialRoute: "/loading",
        routes: {
          "/": (context) => LayoutWrapper(child: Layout()),
          "/login": (context) => LayoutWrapper(child: AuthPage()),
          "/loading": (context) => LayoutWrapper(child: LoadingPage()),
          "/welcome": (context) => LayoutWrapper(child: WelcomePage())
        },
      ),
    );
  }
}
