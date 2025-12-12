import 'package:excerbuys/layout.dart';
import 'package:excerbuys/pages/auth/auth_page.dart';
import 'package:excerbuys/pages/auth/reset_password.dart';
import 'package:excerbuys/pages/auth/reset_password_code.dart';
import 'package:excerbuys/pages/loading_page.dart';
import 'package:excerbuys/pages/auth/verify_email_page.dart';
import 'package:excerbuys/pages/auth/welcome_page.dart';
import 'package:excerbuys/store/controllers/app_controller/app_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/layout_wrapper.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

void main() => runApp(const FinFitApp());

class FinFitApp extends StatefulWidget {
  const FinFitApp({super.key});

  static _FinFitAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_FinFitAppState>();

  @override
  State<FinFitApp> createState() => _FinFitAppState();
}

class _FinFitAppState extends State<FinFitApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<LANGUAGE>(
          stream: appController.appLanguageStream,
          builder: (context, snapshot) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: NAVIGATOR_KEY,
                locale: snapshot.data?.locale,
                onGenerateTitle: (context) => context.l10n.appTitle,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                theme: ThemeData(
                    scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Color.fromARGB(255, 255, 255, 255),
                      primary: Color.fromARGB(255, 255, 255, 255),
                      primaryFixed: Color(0xFF191D23),
                      primaryContainer: Color.fromARGB(255, 250, 250, 250),
                      primaryFixedDim: const Color(0xFF999191),
                      secondary: Color.fromARGB(255, 83, 175, 245),
                      secondaryContainer:
                          const Color.fromARGB(255, 1, 215, 172),
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
                  '/verify_email': (context) =>
                      LayoutWrapper(child: VerifyEmailPage()),
                  "/reset_password_code": (context) =>
                      LayoutWrapper(child: ResetPasswordCodePage()),
                  "/set_new_password": (context) =>
                      LayoutWrapper(child: ResetPassword()),
                },
                builder: (context, child) {
                  Intl.defaultLocale =
                      Localizations.localeOf(context).toLanguageTag();
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    child: child!,
                  );
                });
          }),
    );
  }
}
