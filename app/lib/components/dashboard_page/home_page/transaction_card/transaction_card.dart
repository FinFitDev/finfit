import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatefulWidget {
  final int points;
  final void Function() onPressed;
  final String date;
  final TRANSACTION_TYPE type;

  // product purchase
  final String? productImage;
  final double? productPrice;

  // second user interaction
  final String? userImage;
  final String? username;

  const TransactionCard(
      {super.key,
      required this.points,
      required this.onPressed,
      required this.date,
      required this.type,
      this.productImage,
      this.productPrice,
      this.userImage,
      this.username});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  String getTransactionTypeText(TRANSACTION_TYPE type) {
    switch (type) {
      case TRANSACTION_TYPE.PURCHASE:
        return 'Used';
      case TRANSACTION_TYPE.SEND:
        return 'Sent';
      case TRANSACTION_TYPE.RECEIVE:
        return 'Received';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    final color = widget.type == TRANSACTION_TYPE.PURCHASE ||
            widget.type == TRANSACTION_TYPE.SEND
        ? colors.error
        : colors.secondary;

    return RippleWrapper(
        child: Container(
            color: Colors.transparent,
            height: 75,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                widget.type == TRANSACTION_TYPE.PURCHASE
                    ? ImageComponent(
                        size: 50,
                        image: widget.productImage,
                      )
                    : IconContainer(
                        icon: widget.type == TRANSACTION_TYPE.RECEIVE
                            ? 'assets/svg/receiveArrow.svg'
                            : 'assets/svg/sendArrow.svg',
                        size: 50,
                        backgroundColor: color,
                      ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 6),
                            child: StreamBuilder<bool>(
                                stream: dashboardController.balanceHiddenStream,
                                builder: (context, snapshot) {
                                  final bool isHidden = snapshot.data ?? false;
                                  return Text(
                                      '${getTransactionTypeText(widget.type)} ${isHidden ? '***** finpoints' : '${widget.points.abs().toString()} finpoints'}',
                                      style: texts.headlineMedium?.copyWith(
                                        color: color,
                                      ));
                                }),
                          ),
                          Text(
                            widget.date
                                .split(' ')[widget.date.split(' ').length - 1],
                            style: TextStyle(
                                color: colors.tertiaryContainer, fontSize: 12),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          widget.type == TRANSACTION_TYPE.PURCHASE
                              ? Text(
                                  'Payed ${widget.productPrice?.toStringAsFixed(2)} PLN',
                                  style: TextStyle(
                                    color: colors.tertiaryContainer,
                                    fontSize: 13,
                                  ),
                                )
                              : widget.type == TRANSACTION_TYPE.RECEIVE ||
                                      widget.type == TRANSACTION_TYPE.SEND
                                  ? Row(
                                      children: [
                                        Text(
                                          widget.type ==
                                                  TRANSACTION_TYPE.RECEIVE
                                              ? 'From:'
                                              : 'To:',
                                          style: TextStyle(
                                            color: colors.tertiaryContainer,
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                              color:
                                                  colors.tertiary.withAlpha(10),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            children: [
                                              ProfileImageGenerator(
                                                size: 13,
                                                seed: widget.userImage,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                widget.username ?? 'Unknown',
                                                style: TextStyle(
                                                  color:
                                                      colors.tertiaryContainer,
                                                  fontSize: 13,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'No additional data',
                                      style: TextStyle(
                                        color: colors.tertiaryContainer,
                                        fontSize: 13,
                                      ),
                                    ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
        onPressed: () {});
  }
}
