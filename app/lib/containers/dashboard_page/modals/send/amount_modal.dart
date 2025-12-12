import 'dart:async';
import 'dart:math';

import 'package:excerbuys/components/dashboard_page/send/chosen_recipients_list.dart';
import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/positions/position_with_title.dart';
import 'package:excerbuys/store/controllers/dashboard/send_controller/send_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class AmountModal extends StatefulWidget {
  final void Function() previousPage;

  const AmountModal({super.key, required this.previousPage});

  @override
  State<AmountModal> createState() => _AmountModalState();
}

class _AmountModalState extends State<AmountModal> {
  bool _balanceError = false;
  late StreamSubscription _totalAmountSubscription; // Declare the subscription
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _totalAmountSubscription = sendController.totalAmountStream.listen((data) {
      setState(() {
        _balanceError = (userController.userBalance ?? 0) - data < 0;
      });
    });
  }

  @override
  void dispose() {
    _totalAmountSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return ModalContentWrapper(
      title: l10n.textSendPointsTitle,
      onClickBack: widget.previousPage,
      onClose: () {
        closeModal(context);
      },
      padding: EdgeInsets.only(
          bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                InputWithIcon(
                  placeholder: l10n.textAmountPlaceholder,
                  onChange: (val) {
                    if (val.isEmpty) {
                      sendController.setAmount(null);
                    } else {
                      sendController.setAmount(parseInt(val));
                    }
                  },
                  borderRadius: 10,
                  verticalPadding: 12,
                  inputType: TextInputType.number,
                  error: _balanceError ? l10n.textNotEnoughBalance : null,
                  initialValue: (sendController.amount)?.toString(),
                ),
              ],
            ),
          ),
          StreamBuilder<List<String>>(
              stream: sendController.chosenUsersIdsStream,
              builder: (context, listSnapshot) {
                return StreamBuilder<ContentWithLoading<Map<String, User>>>(
                    stream: sendController.selectedUsersStream,
                    builder: (context, snapshot) {
                      return snapshot.hasData &&
                              snapshot.data!.content.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                ChosenRecipientsList(
                                  selectedUsers: snapshot.data!.content,
                                  disallowChange: true,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            )
                          : SizedBox.shrink();
                    });
              }),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StreamBuilder<int?>(
                    stream: sendController.amountStream,
                    builder: (context, snapshot) {
                      // return ListComponent(
                      //   data: {
                      //     'Amount':
                      //         '${formatNumber(snapshot.data ?? 0)} points',
                      //     'No. of recipients':
                      //         '${sendController.chosenUsersIds.length}',
                      //     'Current balance':
                      //         '${formatNumber((userController.userBalance ?? 0).round())} points',
                      //     'Remaining balance':
                      //         '${formatNumber(max(((userController.userBalance ?? 0) - (snapshot.data ?? 0) * sendController.chosenUsersIds.length), 0).round())} points'
                      //   },
                      //   summary:
                      //       '${(snapshot.data ?? 0) * sendController.chosenUsersIds.length} points',
                      //   summaryColor: colors.secondary,
                      // );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PositionWithTitle(
                              title: l10n.textInputAmountTitle,
                              icon: 'assets/svg/dollar.svg',
                              value:
                                  l10n.textPointsValue(
                                      formatNumber(snapshot.data ?? 0))),
                          PositionWithTitle(
                              title: l10n.textRecipientsCount,
                              icon: 'assets/svg/people.svg',
                              value:
                                  '${sendController.chosenUsersIds.length}'),
                          PositionWithTitle(
                              title: l10n.textCurrentBalance,
                              icon: 'assets/svg/trend_up.svg',
                              value: l10n.textPointsValue(formatNumber(
                                  (userController.userBalance ?? 0).round()))),
                          SizedBox(
                            height: 32,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              Text(
                                l10n.textSummaryLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.tertiaryContainer,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                l10n.textPointsValue(formatNumber(
                                    (snapshot.data ?? 0) *
                                        sendController
                                            .chosenUsersIds.length)),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: colors.secondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                        ],
                      );
                    }),
              ],
            ),
          )),
          SizedBox(
            height: 16,
          ),
          StreamBuilder<int?>(
              stream: sendController.amountStream,
              builder: (context, snapshot) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
                  child: MainButton(
                      holdToConfirm: true,
                      isDisabled: !snapshot.hasData ||
                          snapshot.data == 0 ||
                          _balanceError,
                      label: l10n.actionHoldToConfirm,
                      backgroundColor: colors.secondary,
                      textColor: colors.primary,
                      loading: isLoading,
                      onPressed: () async {
                        if (isLoading) {
                          return;
                        }
                        if (mounted) {
                          setState(() {
                            isLoading = true;
                          });
                        }

                        await sendController.sendPoints();
                        sendController.saveRecentRecipients();
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        }
                      }),
                );
              })
        ],
      ),
    );
  }
}
