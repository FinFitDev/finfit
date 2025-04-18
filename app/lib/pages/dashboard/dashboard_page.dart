import 'package:excerbuys/components/dashboard_page/bottom_appbar.dart';
import 'package:excerbuys/components/dashboard_page/main_header.dart';
import 'package:excerbuys/pages/dashboard/home_page.dart';
import 'package:excerbuys/pages/dashboard/profile_page.dart';
import 'package:excerbuys/pages/dashboard/recent_page.dart';
import 'package:excerbuys/pages/dashboard/shop_page.dart';
import 'package:excerbuys/store/controllers/activity/activity_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:health/health.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<void> fetchActivity() async {
    Health().configure();
    await activityController.authorize();
    if (Platform.isAndroid) {
      await activityController.checkHealthConnectSdk();
    }
    await activityController.fetchActivity();
    await transactionsController.fetchTransactions();
    await productsController.fetchHomeProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: layoutController.relativeContentHeight,
        color: Theme.of(context).colorScheme.primary,
        child: Stack(
          children: [
            StreamBuilder<int>(
                stream: dashboardController.activePageStream,
                builder: (context, snapshot) {
                  return IndexedStack(
                    index: snapshot.data,
                    children: [
                      HomePage(fetchActivity: fetchActivity),
                      ShopPage(),
                      RecentPage(),
                      ProfilePage()
                    ],
                  );
                }),
            MainHeader(),
            Positioned(
              bottom: 0,
              left: 0,
              width: MediaQuery.sizeOf(context).width,
              child: BottomBar(),
            )
          ],
        ),
      ),
    );
  }
}
