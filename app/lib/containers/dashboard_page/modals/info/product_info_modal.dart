import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/indicators/labels/empty_data_modal.dart';
import 'package:excerbuys/components/shared/list/list_component.dart';
import 'package:excerbuys/components/shared/positions/position_with_background.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/image_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class ProductInfoModal extends StatefulWidget {
  final String productId;

  const ProductInfoModal({super.key, required this.productId});

  @override
  State<ProductInfoModal> createState() => _ProductInfoModalState();
}

class _ProductInfoModalState extends State<ProductInfoModal> {
  bool _error = false;
  IProductEntry? _product;
  ScrollController _scrollController = ScrollController();

  void getProductMetadata() {
    final foundProduct =
        productsController.allProducts.content[widget.productId] ??
            productsController.homeProducts.content[widget.productId];
    if (foundProduct == null) {
      setState(() {
        _error = true;
      });
      return;
    }
    setState(() {
      _product = foundProduct;
    });
  }

  @override
  void initState() {
    super.initState();

    getProductMetadata();
  }

  @override
  void didUpdateWidget(covariant ProductInfoModal oldWidget) {
    if (widget.productId != oldWidget.productId) {
      getProductMetadata();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Adjust with keyboard
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(MODAL_BORDER_RADIUS),
              topRight: Radius.circular(MODAL_BORDER_RADIUS)),
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.9,
            color: colors.primary,
            width: double.infinity,
            padding: EdgeInsets.only(
                bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
            child: _error
                ? EmptyDataModal(
                    message: "Couldn't find product data",
                  )
                : Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ImageBox(
                                      image: _product?.image,
                                      height: 280,
                                      borderRadius: 0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: HORIZOTAL_PADDING,
                                          vertical: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            _product?.name ?? '',
                                            style: texts.headlineLarge,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          RippleWrapper(
                                            onPressed: () {},
                                            child: PositionWithBackground(
                                                name:
                                                    _product?.owner.name ?? '',
                                                image:
                                                    _product?.owner.image ?? '',
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 6, horizontal: 8),
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                )),
                                          ),
                                          _product?.description != null &&
                                                  _product!
                                                      .description.isNotEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 16),
                                                  child: Text(
                                                      _product!.description,
                                                      style: texts.bodyMedium
                                                          ?.copyWith(
                                                              color: colors
                                                                  .primaryFixedDim)),
                                                )
                                              : SizedBox.shrink(),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          StreamBuilder<double?>(
                                              stream: userController
                                                  .userBalanceStream,
                                              builder: (context, snapshot) {
                                                final double userBalance =
                                                    snapshot.data ?? 0;
                                                return ListComponent(
                                                  data: {
                                                    'Original price': _product
                                                                ?.originalPrice !=
                                                            null
                                                        ? '${padPriceDecimals(_product!.originalPrice)} PLN'
                                                        : 'Unknown',
                                                    'Discount': _product
                                                                ?.discount !=
                                                            null
                                                        ? '${padPriceDecimals(_product!.discount)} %'
                                                        : 'Unknown',
                                                    'Finpoints price': _product
                                                                ?.finpointsPrice !=
                                                            null
                                                        ? '${formatNumber(_product!.finpointsPrice.round())} finpoints'
                                                        : 'Unknown',
                                                    'Total purchases': (_product
                                                                ?.totalTransactions ??
                                                            0)
                                                        .toString()
                                                  },
                                                  summary: _product
                                                                  ?.originalPrice !=
                                                              null &&
                                                          _product?.discount !=
                                                              null
                                                      ? '${padPriceDecimals(_product!.originalPrice * (userBalance < (_product?.finpointsPrice ?? 0) ? 1 : (100 - (_product?.discount ?? 0)) / 100))} PLN'
                                                      : 'Unknown',
                                                  summaryColor:
                                                      colors.secondary,
                                                );
                                              })
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          StreamBuilder<double?>(
                              stream: userController.userBalanceStream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data == null ||
                                    snapshot.data! >=
                                        (_product?.finpointsPrice ?? 0)) {
                                  return SizedBox.shrink();
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: HORIZOTAL_PADDING,
                                      right: HORIZOTAL_PADDING,
                                      top: 8),
                                  child: Text(
                                    'You are not eligible for a discount on this product yet, but you can still purchase it at the original price.',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: colors.error,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              }),
                          Container(
                            padding: EdgeInsets.only(
                                top: 16,
                                left: HORIZOTAL_PADDING,
                                right: HORIZOTAL_PADDING),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MainButton(
                                      label: 'Close',
                                      backgroundColor: colors.tertiaryContainer
                                          .withAlpha(80),
                                      textColor: colors.primaryFixedDim,
                                      onPressed: () {
                                        if (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        }
                                      }),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: MainButton(
                                        label: 'Checkout',
                                        backgroundColor: colors.secondary,
                                        textColor: colors.primary,
                                        onPressed: () {
                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                        })),
                              ],
                            ),
                          )
                        ],
                      ),
                      // to drag the modal down
                      Container(
                        height: 200,
                        color: Colors.transparent,
                      )
                    ],
                  ),
          )),
    );
  }
}
