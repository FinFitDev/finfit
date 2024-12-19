import 'package:excerbuys/layout.dart';
import 'package:excerbuys/pages/auth_page.dart';
import 'package:excerbuys/pages/loading_page.dart';
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
        navigatorKey: GeneralConstants.NAVIGATOR_KEY,
        title: GeneralConstants.APP_TITLE,
        theme: ThemeData(
            scaffoldBackgroundColor: Color.fromARGB(0, 0, 0, 0),
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF353535),
                primary: Color(0xFF353535),
                primaryFixed: Color(0xFFBBBBBB),
                primaryContainer: Color.fromARGB(255, 0, 0, 0),
                secondary: Color(0xFF6BBCFF),
                tertiary: Colors.white,
                tertiaryContainer: Color.fromARGB(255, 168, 168, 168),
                error: Color(0xFFFA6161)),
            useMaterial3: true,
            fontFamily: 'Poppins'),
        initialRoute: "/loading",
        routes: {
          "/": (context) => LayoutWrapper(child: Layout()),
          "/login": (context) => LayoutWrapper(child: AuthPage()),
          "/loading": (context) => LayoutWrapper(child: LoadingPage())
        },
      ),
    );
  }
}
