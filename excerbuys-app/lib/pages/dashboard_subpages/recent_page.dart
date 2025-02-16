import 'package:excerbuys/components/shared/buttons/category_button.dart';
import 'package:excerbuys/containers/dashboard_page/history_page/all_historical_container.dart';
import 'package:excerbuys/containers/dashboard_page/history_page/daily_data_container.dart';
import 'package:excerbuys/store/controllers/dashboard/history_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Container(
        padding: EdgeInsets.only(
            top: layoutController.statusBarHeight + MAIN_HEADER_HEIGHT,
            bottom: APPBAR_HEIGHT),
        child: Container(
          padding: EdgeInsets.only(bottom: HORIZOTAL_PADDING),
          child: Column(
            children: [
              // buttons switch between daily data and all historical data
              StreamBuilder<Object>(
                  stream: historyController.activeCategoryRecentDataStream,
                  builder: (context, snapshot) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.secondary,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CategoryButton(
                              title: 'Daily data',
                              activeBackgroundColor: colors.primary,
                              backgroundColor: Colors.transparent,
                              activeTextColor: colors.secondary,
                              textColor: colors.primary,
                              onPressed: () {
                                historyController.setActiveCategory(
                                    RECENT_DATA_CATEGORY.DAILY);
                              },
                              fontSize: 16,
                              isActive:
                                  snapshot.data == RECENT_DATA_CATEGORY.DAILY,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CategoryButton(
                              title: 'All historical',
                              activeBackgroundColor: colors.primary,
                              backgroundColor: Colors.transparent,
                              activeTextColor: colors.secondary,
                              textColor: colors.primary,
                              onPressed: () {
                                historyController.setActiveCategory(
                                    RECENT_DATA_CATEGORY.ALL_HISTORICAL);
                              },
                              fontSize: 16,
                              isActive: snapshot.data ==
                                  RECENT_DATA_CATEGORY.ALL_HISTORICAL,
                            ),
                          )
                        ],
                      ),
                    );
                  }),

              // pages
              Expanded(
                child: StreamBuilder<RECENT_DATA_CATEGORY>(
                    stream: historyController.activeCategoryRecentDataStream,
                    builder: (context, snapshot) {
                      return IndexedStack(
                        index: snapshot.data?.index ?? 0,
                        children: [
                          DailyDataContainer(),
                          AllHistoricalContainer()
                        ],
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
