import 'package:excerbuys/components/loaders/universal_loader_box.dart';
import 'package:excerbuys/components/shared/indicators/circle_progress/circle_progress_indicator.dart';
import 'package:excerbuys/components/shared/indicators/circle_progress/circle_progress_painter.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoalsContainer extends StatefulWidget {
  final bool? isLoading;
  const GoalsContainer({super.key, this.isLoading});

  @override
  State<GoalsContainer> createState() => _GoalsContainerState();
}

class _GoalsContainerState extends State<GoalsContainer> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: HORIZOTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily goals',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.tertiary),
              ),
              RippleWrapper(
                onPressed: () {},
                child: Text(
                  'See more',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: colors.tertiaryContainer),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          widget.isLoading == true
              ? UniversalLoaderBox(height: 300, width: 100)
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colors.primaryContainer.withAlpha(160)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleProgress(
                            progress: 0.3,
                            size: 120,
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '180 points',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: colors.tertiary,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Container(
                                          width: 80,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 3),
                                          height: 1,
                                          color: colors.tertiaryContainer,
                                        ),
                                        Text(
                                          '260 points',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: colors.tertiaryContainer,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                    // RippleWrapper(
                                    //     child: Container(
                                    //       padding: EdgeInsets.all(10),
                                    //       decoration: BoxDecoration(
                                    //           borderRadius:
                                    //               BorderRadius.circular(10),
                                    //           color: colors.secondary),
                                    //       child: Text(
                                    //         'Edit goals',
                                    //         style: TextStyle(
                                    //             fontSize: 10,
                                    //             color: colors.tertiary,
                                    //             fontWeight: FontWeight.w600),
                                    //       ),
                                    //     ),
                                    //     onPressed: () {})
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  'Keep making progress to complete your goals!',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: colors.tertiaryContainer),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 1,
                        color: colors.tertiaryContainer,
                        margin: EdgeInsets.symmetric(vertical: 30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              CircleProgress(
                                progress: 0.3,
                                size: 40,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Mon',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: colors.tertiaryContainer),
                              )
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              CircleProgress(
                                progress: 1,
                                size: 40,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Tue',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: colors.tertiaryContainer),
                              )
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              CircleProgress(
                                progress: 0.1,
                                size: 40,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Wed',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: colors.tertiaryContainer),
                              )
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              CircleProgress(
                                progress: 0.0,
                                size: 40,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Thu',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: colors.tertiaryContainer),
                              )
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              CircleProgress(
                                progress: 0.8,
                                size: 40,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Fri',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: colors.tertiaryContainer),
                              )
                            ],
                          ))
                        ],
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
