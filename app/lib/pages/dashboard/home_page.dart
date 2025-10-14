import 'dart:math';
import 'package:excerbuys/containers/dashboard_page/home_page/background_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/featured_offers_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/recent_training_section.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/balance_container.dart';
import 'package:excerbuys/containers/dashboard_page/home_page/transactions_section.dart';
import 'package:excerbuys/containers/dashboard_page/modals/offer_info_modal.dart';
import 'package:excerbuys/store/controllers/activity/activity_controller/activity_controller.dart';
import 'package:excerbuys/store/controllers/activity/steps_controller/steps_controller.dart';
import 'package:excerbuys/store/controllers/activity/trainings_controller/trainings_controller.dart';
import 'package:excerbuys/store/controllers/dashboard/send_controller/send_controller.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/offers_controller/offers_controller.dart';
import 'package:excerbuys/store/controllers/shop/transactions_controller/transactions_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/activity.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/types/transaction.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/refresh_wrapper.dart';
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
    activityController.setTodaysPoints(0);
    await stepsController.fetchsSteps();

    await offersController.refreshFeaturedOffers();
    await sendController.refresh();
  }

  @override
  Widget build(BuildContext context) {
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
                child: Column(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            StreamBuilder<
                                    ContentWithLoading<
                                        Map<BigInt, IOfferEntry>>>(
                                stream: offersController.featuredOffersStream,
                                builder: (context, snapshot) {
                                  return FeaturedOffersContainer(
                                    offers: snapshot.data?.content ?? {},
                                    isLoading: snapshot.data?.isLoading == true,
                                    onPress: (id) {
                                      final offer = snapshot
                                          .data?.content.values
                                          .firstWhere((element) =>
                                              element.id.toString() == id);
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

                            // StreamBuilder<
                            //         ContentWithLoading<List<IProductEntry>>>(
                            //     stream: productsController
                            //         .affordableHomeProductsStream,
                            //     builder: (context, snapshot) {
                            //       if ((snapshot.data == null ||
                            //               snapshot.data!.content.isEmpty) &&
                            //           snapshot.data?.isLoading != true) {
                            //         return SizedBox.shrink();
                            //       }
                            //       return AvailableOffers(
                            //         products: snapshot.data?.content ?? [],
                            //         isLoading: snapshot.data?.isLoading,
                            //       );
                            //     }),
                            // StreamBuilder<
                            //         ContentWithLoading<List<IProductEntry>>>(
                            //     stream: productsController
                            //         .nearlyAffordableHomeProducts,
                            //     builder: (context, snapshot) {
                            //       if ((snapshot.data == null ||
                            //               snapshot.data!.content.isEmpty) &&
                            //           snapshot.data?.isLoading != true) {
                            //         return SizedBox.shrink();
                            //       }
                            //       return ProgressOffersContainer(
                            //         products: snapshot.data?.content ?? [],
                            //         isLoading: snapshot.data?.isLoading,
                            //       );
                            //     }),
                            // StreamBuilder<ContentWithLoading<IStoreStepsData>>(
                            //     stream: stepsController.userStepsStream,
                            //     builder: (context, stepsSnapshot) {
                            //       final IStoreStepsData stepsData =
                            //           stepsSnapshot.hasData
                            //               ? stepsSnapshot.data!.content
                            //               : {};
                            //       return StepsActivityCard(
                            //         isLoading:
                            //             stepsSnapshot.data?.isLoading ?? false,
                            //         stepsData: stepsData,
                            //       );
                            //     }),
                            StreamBuilder<
                                    ContentWithLoading<
                                        Map<String, ITrainingEntry>>>(
                                stream: trainingsController.userTrainingsStream,
                                builder: (context, snapshot) {
                                  final Map<String, ITrainingEntry> trainings =
                                      getTopRecentEntries(
                                          snapshot.data?.content,
                                          (a, b) => b.value.createdAt
                                              .compareTo(a.value.createdAt),
                                          5);

                                  return RecentTrainingSection(
                                      isLoading:
                                          snapshot.data?.isLoading ?? false,
                                      recentTraining: trainings);
                                }),
                            StreamBuilder<
                                    ContentWithLoading<
                                        Map<String, ITransactionEntry>>>(
                                stream: transactionsController
                                    .allTransactionsStream,
                                builder: (context, snapshot) {
                                  final Map<String, ITransactionEntry>
                                      transactions = getTopRecentEntries(
                                          snapshot.data?.content,
                                          (a, b) => b.value.createdAt
                                              .compareTo(a.value.createdAt),
                                          5);
                                  return TransactionsSection(
                                    recentTransactions: transactions,
                                    isLoading: snapshot.data?.isLoading,
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
