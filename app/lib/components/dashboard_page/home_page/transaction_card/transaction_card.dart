import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatefulWidget {
  final int points;
  final void Function() onPressed;
  final DateTime date;
  final TRANSACTION_TYPE type;

  // product purchase
  final String? offerImage;
  final String? offerName;

  // second user interaction
  final String? userImage;
  final String? username;

  const TransactionCard(
      {super.key,
      required this.points,
      required this.onPressed,
      required this.date,
      required this.type,
      this.offerImage,
      this.offerName,
      this.userImage,
      this.username});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  String getTransactionTypeText(TRANSACTION_TYPE type) {
    switch (type) {
      case TRANSACTION_TYPE.REDEEM:
        return 'Redeemed';
      case TRANSACTION_TYPE.SEND:
        return 'Sent to';
      case TRANSACTION_TYPE.RECEIVE:
        return 'Received from';
      default:
        return '';
    }
  }

  Color getTransactionTypeColor(TRANSACTION_TYPE type, ColorScheme colors) {
    switch (type) {
      case TRANSACTION_TYPE.REDEEM:
        return colors.secondary;
      case TRANSACTION_TYPE.SEND:
        return colors.error;
      case TRANSACTION_TYPE.RECEIVE:
        return colors.secondaryContainer;
      default:
        return colors.tertiaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    final color = getTransactionTypeColor(widget.type, colors);

    return RippleWrapper(
      onPressed: widget.onPressed,
      child: Container(
          color: Colors.transparent,
          height: 75,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              IconContainer(
                icon: widget.type == TRANSACTION_TYPE.REDEEM
                    ? 'assets/svg/gift.svg'
                    : widget.type == TRANSACTION_TYPE.RECEIVE
                        ? 'assets/svg/arrowReceive.svg'
                        : 'assets/svg/arrowSend.svg',
                size: 50,
                backgroundColor: color.withAlpha(20),
                iconColor: color,
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
                        Text(getTransactionTypeText(widget.type),
                            style: texts.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),

                        Text(
                            '${widget.type == TRANSACTION_TYPE.RECEIVE ? '+' : '-'}${widget.points}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: color)),
                        // Container(
                        //   margin: EdgeInsets.only(right: 6),
                        //   child: StreamBuilder<bool>(
                        //       stream: dashboardController.balanceHiddenStream,
                        //       builder: (context, snapshot) {
                        //         final bool isHidden = snapshot.data ?? false;
                        //         return Text(
                        //             isHidden
                        //                 ? '***** finpoints'
                        //                 : '${widget.type == TRANSACTION_TYPE.RECEIVE ? '+' : '-'}${widget.points.abs().toString()} finpoints',
                        //             style: texts.headlineMedium?.copyWith(
                        //               color: color,
                        //             ));
                        //       }),
                        // ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 16,
                      children: [
                        widget.type == TRANSACTION_TYPE.REDEEM
                            ? Expanded(
                                child: Row(
                                  spacing: 4,
                                  children: [
                                    ImageComponent(
                                      size: 14,
                                      image: widget.offerImage,
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.offerName ?? '',
                                        style: TextStyle(
                                            color: colors.tertiaryContainer,
                                            fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : widget.type == TRANSACTION_TYPE.RECEIVE ||
                                    widget.type == TRANSACTION_TYPE.SEND
                                ? Text(
                                    widget.username ?? 'Unknown',
                                    style: TextStyle(
                                      color: colors.tertiaryContainer,
                                      fontSize: 13,
                                    ),
                                  )
                                : Text(
                                    'No additional data',
                                    style: TextStyle(
                                      color: colors.tertiaryContainer,
                                      fontSize: 13,
                                    ),
                                  ),
                        Text(
                          parseDate(widget.date),
                          style: TextStyle(
                              color: colors.tertiaryContainer, fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
