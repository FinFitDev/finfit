import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/indicators/images_row.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatefulWidget {
  final int points;
  final void Function() onPressed;
  final String date;
  final TRANSACTION_TYPE type;

  // product purchase
  final List<String>? productImages;
  final double? totalProductPrice;

  // second user interaction
  final List<String>? userImages;
  final List<String>? usernames;

  const TransactionCard(
      {super.key,
      required this.points,
      required this.onPressed,
      required this.date,
      required this.type,
      this.productImages,
      this.totalProductPrice,
      this.userImages,
      this.usernames});

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

    final imageCount =
        widget.productImages?.length ?? widget.userImages?.length ?? 0;

    return RippleWrapper(
      onPressed: widget.onPressed,
      child: Container(
          color: Colors.transparent,
          height: 75,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Stack(
                children: [
                  widget.type == TRANSACTION_TYPE.PURCHASE
                      ? ImagesRow(images: widget.productImages!)
                      : ImagesRow(
                          images: widget.userImages!,
                          isProfile: true,
                        ),
                  widget.type != TRANSACTION_TYPE.PURCHASE
                      ? Positioned(
                          right: 0,
                          bottom: 0,
                          child: IconContainer(
                            icon: widget.type == TRANSACTION_TYPE.RECEIVE
                                ? 'assets/svg/receiveArrow.svg'
                                : 'assets/svg/sendArrow.svg',
                            size: 20,
                            ratio: 0.7,
                            backgroundColor: color,
                          ))
                      : SizedBox.shrink()
                ],
              ),
              SizedBox(width: 12),
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
                                    isHidden
                                        ? '***** finpoints'
                                        : '${widget.type == TRANSACTION_TYPE.RECEIVE ? '+' : '-'}${widget.points.abs().toString()} finpoints',
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
                            ? StreamBuilder<bool>(
                                stream: dashboardController.balanceHiddenStream,
                                builder: (context, snapshot) {
                                  final bool isHidden = snapshot.data ?? false;

                                  return Text(
                                    'Zapłacono ${isHidden ? '*****' : widget.totalProductPrice?.toStringAsFixed(2)} PLN',
                                    style: TextStyle(
                                      color: colors.tertiaryContainer,
                                      fontSize: 13,
                                    ),
                                  );
                                })
                            : widget.type == TRANSACTION_TYPE.RECEIVE ||
                                    widget.type == TRANSACTION_TYPE.SEND
                                ? Text(
                                    (widget.usernames != null &&
                                            widget.usernames!.isNotEmpty)
                                        ? widget.usernames!
                                                .sublist(
                                                    0,
                                                    widget.usernames!.length >=
                                                            2
                                                        ? 2
                                                        : widget
                                                            .usernames!.length)
                                                .join(', ') +
                                            (widget.usernames!.length > 2
                                                ? ' + ${(widget.usernames!.length - 2)}'
                                                : '')
                                        : 'Unknown',
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
