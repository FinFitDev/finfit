import 'dart:ui';

import 'package:excerbuys/utils/parsers/parsers.dart';
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
  final GlobalKey _positionedKey = GlobalKey();
  double? _positionedWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox =
          _positionedKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _positionedWidth = renderBox.size.width;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return RippleWrapper(
      onPressed: () {},
      child: IntrinsicWidth(
        child: Container(
          constraints: BoxConstraints(
              minWidth:
                  _positionedWidth != null ? (_positionedWidth! + 10) : 160,
              maxWidth: 250),
          height: 260,
          margin: EdgeInsets.only(right: widget.isLast == true ? 0 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    height: 210,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(widget.image),
                            fit: BoxFit.cover)),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    height: 40,
                    key: _positionedKey,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: colors.primaryContainer.withAlpha(200),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 150,
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${widget.points} points',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: colors.tertiaryContainer),
                                    ),
                                    Text(
                                      '${padPriceDecimals(widget.originalPrice)} \$',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: colors.tertiary,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: colors.tertiary,
                                          decorationThickness: 1),
                                    )
                                  ],
                                ),
                              ),
                              Center(
                                child: Text(
                                  '${padPriceDecimals(widget.originalPrice - 0.01 * widget.discount * widget.originalPrice)} \$',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: colors.secondary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 50,
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            color: colors.tertiary,
                            fontWeight: FontWeight.bold)),
                    Text(widget.seller,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: colors.tertiaryContainer,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
