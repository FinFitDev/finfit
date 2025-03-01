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
          child: Stack(
            children: [
              Column(
                children: [
                  // pages
                  Expanded(
                    child: StreamBuilder<RECENT_DATA_CATEGORY>(
                        stream:
                            historyController.activeCategoryRecentDataStream,
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
              // buttons switch between daily data and all historical data
              StreamBuilder<Object>(
                  stream: historyController.activeCategoryRecentDataStream,
                  builder: (context, snapshot) {
                    return StreamBuilder<bool>(
                        stream: historyController.categoryHeaderVisibleStream,
                        builder: (context, visibleSnapshot) {
                          return AnimatedPositioned(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.decelerate,
                            top: visibleSnapshot.data == false ? -60 : 0,
                            height: 56,
                            width: layoutController.relativeContentWidth,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.decelerate,
                              opacity: visibleSnapshot.data == false ? 0 : 1,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colors.primaryContainer,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CategoryButton(
                                        title: 'Daily data',
                                        activeBackgroundColor: colors.primary,
                                        backgroundColor: Colors.transparent,
                                        activeTextColor: colors.secondary,
                                        textColor: colors.tertiaryContainer,
                                        onPressed: () {
                                          historyController.setActiveCategory(
                                              RECENT_DATA_CATEGORY.DAILY);
                                        },
                                        fontSize: 16,
                                        isActive: snapshot.data ==
                                            RECENT_DATA_CATEGORY.DAILY,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: CategoryButton(
                                        title: 'All historical',
                                        activeBackgroundColor: colors.primary,
                                        backgroundColor: Colors.transparent,
                                        activeTextColor: colors.secondary,
                                        textColor: colors.tertiaryContainer,
                                        onPressed: () {
                                          historyController.setActiveCategory(
                                              RECENT_DATA_CATEGORY
                                                  .ALL_HISTORICAL);
                                        },
                                        fontSize: 16,
                                        isActive: snapshot.data ==
                                            RECENT_DATA_CATEGORY.ALL_HISTORICAL,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ],
          ),
        ));
  }
}
