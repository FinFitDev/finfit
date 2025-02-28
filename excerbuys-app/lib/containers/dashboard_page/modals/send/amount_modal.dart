import 'dart:async';
import 'dart:math';

import 'package:excerbuys/components/dashboard_page/send/chosen_recipients_list.dart';
import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/list/list_component.dart';
import 'package:excerbuys/store/controllers/app_controller.dart';
import 'package:excerbuys/store/controllers/dashboard/send_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:flutter/material.dart';

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
    super.dispose();
    _totalAmountSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(40), bottom: Radius.circular(20)),
      child: Container(
        color: colors.primary,
        width: double.infinity,
        padding: EdgeInsets.only(
            left: HORIZOTAL_PADDING,
            right: HORIZOTAL_PADDING,
            bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ModalHeader(
              title: 'Send finpoints',
              subtitle: 'Enter amount',
              goBack: widget.previousPage,
            ),
            SizedBox(
              height: 16,
            ),
            InputWithIcon(
              placeholder: 'Amount',
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
              error: _balanceError ? 'Not enough balance' : null,
              initialValue: (sendController.amount)?.toString(),
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
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StreamBuilder<int?>(
                    stream: sendController.amountStream,
                    builder: (context, snapshot) {
                      return ListComponent(
                        data: {
                          'Amount': '${snapshot.data ?? 0} finpoints',
                          'Recipients':
                              '${sendController.chosenUsersIds.length} users',
                          'Current balance':
                              '${(userController.userBalance ?? 0).round().toString()} finpoints',
                          'Remaining balance':
                              '${max(((userController.userBalance ?? 0) - (snapshot.data ?? 0) * sendController.chosenUsersIds.length), 0).round().toString()} finpoints'
                        },
                        summary:
                            '${(snapshot.data ?? 0) * sendController.chosenUsersIds.length} finpoints',
                        summaryColor: colors.secondary,
                      );
                    }),
                // Text(
                //   'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                //   style:
                //       TextStyle(fontSize: 12, color: colors.tertiaryContainer),
                // )
              ],
            )),
            SizedBox(
              height: 16,
            ),
            StreamBuilder<int?>(
                stream: sendController.amountStream,
                builder: (context, snapshot) {
                  return MainButton(
                      holdToConfirm: true,
                      isDisabled: !snapshot.hasData ||
                          snapshot.data == 0 ||
                          _balanceError,
                      label: 'Hold to confirm',
                      backgroundColor: colors.secondary,
                      textColor: colors.primary,
                      loading: isLoading,
                      onPressed: () async {
                        if (isLoading) {
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        await sendController.sendPoints();
                        sendController.saveRecentRecipients();
                        setState(() {
                          isLoading = false;
                        });
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      });
                })
          ],
        ),
      ),
    );
  }
}
