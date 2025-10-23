import 'package:excerbuys/components/dashboard_page/bottom_appbar.dart';
import 'package:excerbuys/components/main_header/main_header.dart';
import 'package:excerbuys/pages/dashboard/home_page.dart';
import 'package:excerbuys/pages/dashboard/profile_page.dart';
import 'package:excerbuys/pages/dashboard/recent_page.dart';
import 'package:excerbuys/pages/dashboard/offers_page.dart';
import 'package:excerbuys/pages/dashboard/track_page.dart';
import 'package:excerbuys/store/controllers/activity/activity_controller/activity_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/claims_controller/claims_controller.dart';
import 'package:excerbuys/store/controllers/shop/offers_controller/offers_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller/transactions_controller.dart';
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
  Future<void> fetchData() async {
    Health().configure();
    transactionsController.fetchTransactions();
    offersController.fetchFeaturedOffers();
    activityController.fetchActivity();
    claimsController.fetchAllClaims();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      HomePage(fetchData: fetchData),
                      TrackPage(),
                      OffersPage(),
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
