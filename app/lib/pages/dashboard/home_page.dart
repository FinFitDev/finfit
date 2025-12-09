import 'dart:math';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/background_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/featured_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/recent_training_section.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/balance_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/transactions_section.dart';
import 'package:excerbuys/containers/dashboard_page/modals/info/offer_info_modal.dart';
import 'package:excerbuys/store/controllers/activity/strava_controller/strava_controller.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard/send_controller/send_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/claims_controller/claims_controller.dart';
import 'package:excerbuys/store/controllers/shop/offers_controller/offers_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller/transactions_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/refresh_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Future<void> Function() fetchData;
  const HomePage({super.key, required this.fetchData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    widget.fetchData();
  }

  Future<void> onRefresh() async {
    if (userController.currentUser == null) {
      return;
    }

    await userController.getCurrentUser(userController.currentUser!.uuid);

    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );

    await Future.delayed(Duration(milliseconds: 300));
    await Future.wait<dynamic>([
      transactionsController.refresh(),
      offersController.refreshFeaturedOffers(),
      sendController.refresh(),
      claimsController.refresh(),
      trainingsController.refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        StreamBuilder<double>(
            stream: dashboardController.scrollDistanceStream,
            builder: (context, snapshot) {
              return Positioned(
                  top: -(max(0.0, snapshot.data ?? 0)) / 4,
                  // we only animate for the newly added points
                  child: BackgroundContainer());
            }),
        NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              // ensure the notification only listens to vertical scroll
              if (scrollNotification.metrics.axis == Axis.vertical) {
                dashboardController
                    .setScrollDistance(scrollNotification.metrics.pixels);
                return true;
              }
              return false;
            },
            child: RefreshWrapper(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        StreamBuilder<double?>(
                            stream: userController.userBalanceStream,
                            builder: (context, balance) {
                              return balance.hasData
                                  ? BalanceContainer(
                                      balance: (balance.data ?? 0).round(),
                                    )
                                  : SizedBox(
                                      height: 420,
                                    );
                            }),
                        Container(
                          padding: EdgeInsets.only(
                              bottom: 80 + layoutController.bottomPadding),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: 500),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  StreamBuilder<bool>(
                                      stream: stravaController.authorizedStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.data == true) {
                                          return SizedBox.shrink();
                                        }
                                        return RippleWrapper(
                                          onPressed: () {
                                            stravaController.authorize();
                                          },
                                          child: Container(
                                            height: 70,
                                            margin: EdgeInsets.only(
                                                left: 16, right: 16, top: 16),
                                            decoration: BoxDecoration(
                                              color: colors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withAlpha(50),
                                                  spreadRadius: -5,
                                                  blurRadius: 8,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 255, 90, 7)
                                                      .withAlpha(20),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              90,
                                                              7))),
                                              child: Row(
                                                spacing: 16,
                                                children: [
                                                  ImageComponent(
                                                    size: 40,
                                                    image:
                                                        "https://images.prismic.io/sacra/9232e343-6544-430f-aacd-ca85f968ca87_strava+logo.png?auto=compress,format",
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    spacing: 2,
                                                    children: [
                                                      Text(
                                                        "Connect with STRAVA",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                255, 90, 7)),
                                                      ),
                                                      Text(
                                                        "Sync your workouts automatically",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    255,
                                                                    90,
                                                                    7)
                                                                .withAlpha(
                                                                    120)),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                  StreamBuilder<
                                          ContentWithLoading<
                                              Map<BigInt, IOfferEntry>>>(
                                      stream:
                                          offersController.featuredOffersStream,
                                      builder: (context, snapshot) {
                                        return FeaturedOffersContainer(
                                          offers: snapshot.data?.content ?? {},
                                          isLoading:
                                              snapshot.data?.isLoading == true,
                                          onPress: (id) {
                                            final offer = snapshot
                                                .data?.content.values
                                                .firstWhere((element) =>
                                                    element.id.toString() ==
                                                    id);
                                            if (offer != null) {
                                              openModal(
                                                  context,
                                                  OfferInfoModal(
                                                    offer: offer,
                                                  ));
                                            }
                                          },
                                        );
                                      }),
                                  StreamBuilder<
                                          ContentWithLoading<
                                              Map<int, ITrainingEntry>>>(
                                      stream:
                                          trainingsController.sortedWorkouts,
                                      builder: (context, snapshot) {
                                        return RecentTrainingSection(
                                            isLoading:
                                                snapshot.data?.isLoading ==
                                                    true,
                                            recentTraining:
                                                snapshot.data == null
                                                    ? {}
                                                    : snapshot.data!.content);
                                      }),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  StreamBuilder<
                                          ContentWithLoading<
                                              Map<String, ITransactionEntry>>>(
                                      stream: transactionsController
                                          .sortedTransactions,
                                      builder: (context, snapshot) {
                                        return TransactionsSection(
                                          recentTransactions:
                                              snapshot.data == null
                                                  ? {}
                                                  : snapshot.data!.content,
                                          isLoading: snapshot.data?.isLoading,
                                        );
                                      })
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
