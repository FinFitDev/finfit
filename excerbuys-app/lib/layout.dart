import 'package:excerbuys/pages/dashboard_page.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      key: GlobalKey(debugLabel: "dashboard"),
    );
  }
}
