import 'dart:ui';

import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/price_text_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class ShopItemCard extends StatefulWidget {
  final bool? isLast;
  final String image;
  final double originalPrice;
  final int discount;
  final int points;
  final String name;
  final String seller;

  const ShopItemCard(
      {super.key,
      this.isLast,
      required this.image,
      required this.originalPrice,
      required this.discount,
      required this.points,
      required this.name,
      required this.seller});

  @override
  State<ShopItemCard> createState() => _ShopItemCardState();
}

class _ShopItemCardState extends State<ShopItemCard> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
      height: 230,
      child: RippleWrapper(
        onPressed: () {},
        child: Container(
          decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(widget.image),
                          fit: BoxFit.cover)),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.fromLTRB(24, 8, 8, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(widget.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: colors.tertiary,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Quicksand')),
                          Text(widget.seller,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.tertiaryContainer,
                              )),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("List price",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.tertiaryContainer,
                                  )),
                              PriceTextWrapper(
                                price: widget.originalPrice,
                                fontSize: 12,
                                color: colors.tertiary,
                                currencySymbol: '\$',
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Discount",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.tertiaryContainer,
                                  )),
                              Text('${widget.discount} %',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.tertiary,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Cost in points",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.tertiaryContainer,
                                  )),
                              Text(widget.points.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.tertiary,
                                  )),
                            ],
                          ),
                          Container(
                            height: 1,
                            color: colors.tertiaryContainer,
                            margin: EdgeInsets.symmetric(vertical: 16),
                          ),
                          RippleWrapper(
                            onPressed: () {},
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: colors.secondary,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Buy for ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colors.primaryFixedDim,
                                        )),
                                    PriceTextWrapper(
                                      price: widget.originalPrice *
                                          (1 - widget.discount * 0.01),
                                      fontSize: 12,
                                      color: colors.primaryFixedDim,
                                      currencySymbol: '\$',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
