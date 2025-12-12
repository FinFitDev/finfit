import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/profile_image_generator.dart';
import 'package:excerbuys/store/controllers/dashboard_controller/dashboard_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/shop/transaction/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionCard extends StatefulWidget {
  final int points;
  final void Function() onPressed;
  final DateTime date;
  final TRANSACTION_TYPE type;

  // product purchase
  final String? offerImage;
  final String? offerName;

  // second user interaction
  final List<User>? userInfo;

  const TransactionCard({
    super.key,
    required this.points,
    required this.onPressed,
    required this.date,
    required this.type,
    this.offerImage,
    this.offerName,
    this.userInfo,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  String getUsersText(List<User> secondUsers, AppLocalizations l10n) {
    if (secondUsers.isEmpty) {
      return l10n.textUnknown;
    }

    if (secondUsers.length > 2) {
      return l10n.textMultipleUsers;
    }

    String result =
        secondUsers.fold("", (prev, user) => prev + '${user.username} + ');

    if (result.isNotEmpty) {
      result = result.substring(0, result.length - 3);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    final l10n = context.l10n;

    final color = getTransactionTypeColor(widget.type, colors);

    return RippleWrapper(
        onPressed: widget.onPressed,
        child: Container(
          color: Colors.transparent,
          height: 80,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              IconContainer(
                icon: getTransactionTypeIcon(widget.type),
                size: 50,
                backgroundColor: color,
                iconColor: colors.primary,
                borderRadius: 100,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 6,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            getTransactionTypeText(
                                widget.type, l10n),
                            style: texts.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        Text(
                            '${widget.type == TRANSACTION_TYPE.RECEIVE ? '+' : '-'}${widget.points}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: color)),
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
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(10),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: ImageComponent(
                                        size: 14,
                                        image: widget.offerImage,
                                      ),
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
                                ? Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 16,
                                          width:
                                              ((widget.userInfo?.length ?? 1) *
                                                      12.0) +
                                                  12,
                                          child: Stack(
                                            children: (widget.userInfo ?? [])
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              final index = entry.key;
                                              final user = entry.value;
                                              return Positioned(
                                                left: index * 12.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withAlpha(10),
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                        offset: Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ProfileImageGenerator(
                                                    seed: user.image,
                                                    username: user.username,
                                                    size: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            getUsersText(
                                                widget.userInfo!, l10n),
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
                                : Text(
                                    l10n.textNoAdditionalData,
                                    style: TextStyle(
                                      color: colors.tertiaryContainer,
                                      fontSize: 13,
                                    ),
                                  ),
                        Text(
                          parseDate(widget.date, l10n),
                          style: TextStyle(
                              color: colors.tertiaryContainer, fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
