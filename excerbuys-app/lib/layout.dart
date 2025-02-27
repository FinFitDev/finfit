import 'package:excerbuys/pages/dashboard_page.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  void initState() {
    print('init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      key: GlobalKey(debugLabel: "dashboard"),
    );
  }
}
