import 'dart:ui';

import 'package:excerbuys/components/dashboard_page/shop_page/product_info_modal/product_info_header.dart';
import 'package:excerbuys/components/dashboard_page/shop_page/product_info_modal/product_info_images_list.dart';
import 'package:excerbuys/components/dashboard_page/shop_page/product_info_modal/product_info_variants.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/indicators/labels/empty_data_modal.dart';
import 'package:excerbuys/components/shared/list/list_component.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller/products_controller.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/shop/product/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductInfoModal extends StatefulWidget {
  final String productId;

  const ProductInfoModal({super.key, required this.productId});

  @override
  State<ProductInfoModal> createState() => _ProductInfoModalState();
}

class _ProductInfoModalState extends State<ProductInfoModal> {
  bool _error = false;
  IProductEntry? _product;
  String? _selectedImage;
  Map<String, String> _selectedProductAttributes = {};

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
      if (_product?.images != null && _product!.images!.isNotEmpty) {
        _selectedImage = _product!.images![0];
      }
    });
  }

  double getPrice() {
    IProductVariant? matchingVariant = _product?.variants
        ?.where((v) => v.hasSameAttributes(_selectedProductAttributes))
        .firstOrNull;

    final double? variantPrice = matchingVariant?.price;
    return variantPrice ?? _product?.originalPrice ?? 0;
  }

  double getDiscount() {
    IProductVariant? matchingVariant = _product?.variants
        ?.where((v) => v.hasSameAttributes(_selectedProductAttributes))
        .firstOrNull;

    final double? variantDiscount = matchingVariant?.discount;
    return variantDiscount ?? _product?.discount ?? 0;
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
      child: ModalContentWrapper(
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Stack(
                                  children: [
                                    ImageBox(
                                      image: _selectedImage,
                                      height: 280,
                                      borderRadius: 0,
                                    ),

                                    // Positioned(
                                    //     bottom: 8,
                                    //     left: 0,
                                    //     right: 0,
                                    //     child: Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.center,
                                    //         children: [
                                    //           ClipRRect(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(
                                    //                     8),
                                    //             child: BackdropFilter(
                                    //               filter: ImageFilter.blur(
                                    //                   sigmaX: 30,
                                    //                   sigmaY: 30),
                                    //               child: Container(
                                    //                   padding: EdgeInsets
                                    //                       .symmetric(
                                    //                           horizontal:
                                    //                               10,
                                    //                           vertical: 6),
                                    //                   color: colors.primary
                                    //                       .withAlpha(190),
                                    //                   child:
                                    //                       CarouselCounter(
                                    //                           dataLength: 4,
                                    //                           scrollPercent:
                                    //                               0)),
                                    //             ),
                                    //           ),
                                    //         ]))
                                  ],
                                ),
                                ProductInfoHeader(
                                  product: _product,
                                ),
                                (_product?.images?.length ?? 0) > 1
                                    ? ProductInfoImagesList(
                                        images: _product!.images!,
                                        selectedImage: _selectedImage,
                                        onImageSelected: (image) {
                                          setState(() {
                                            _selectedImage = image;
                                          });
                                        })
                                    : SizedBox.shrink(),
                                _product?.variants != null &&
                                        _product!.variants!.isNotEmpty
                                    ? ProductInfoVariants(
                                        productVariants: _product!.variants!,
                                        onVariantSelected: (variant) {
                                          setState(() {
                                            _selectedProductAttributes =
                                                variant;
                                          });
                                        },
                                      )
                                    : SizedBox.shrink(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: HORIZOTAL_PADDING),
                                  child: ListComponent(
                                    data: {
                                      'Pierwotna cena':
                                          '${padPriceDecimals(getPrice())} PLN',
                                      'Przecena':
                                          "${padPriceDecimals(getDiscount())} %",
                                      'Cena finpoints': _product
                                                  ?.finpointsPrice !=
                                              null
                                          ? '${formatNumber(_product!.finpointsPrice.round())} finpoints'
                                          : 'Unknown',
                                      'Ilość zakupionych':
                                          (_product?.totalTransactions ?? 0)
                                              .toString()
                                    },
                                  ),
                                )
                              ]),
                        ),
                      ),
                      StreamBuilder<double?>(
                          stream: shopController.userBalanceMinusCartCost,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData ||
                                snapshot.data == null ||
                                snapshot.data! >=
                                    (_product?.finpointsPrice ?? 0)) {
                              return SizedBox.shrink();
                            }

                            return Container(
                              padding: EdgeInsets.all(10),
                              margin:
                                  EdgeInsets.only(left: 16, right: 16, top: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: colors.errorContainer.withAlpha(40),
                              ),
                              child: Text(
                                'You are not eligible for a discount on this product yet, but you can still purchase it at the original price. It can be caused by your cart items using up your finpoints balance.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: colors.errorContainer,
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
                            StreamBuilder<double?>(
                                stream: shopController.userBalanceMinusCartCost,
                                builder: (context, snapshot) {
                                  final double userBalance = snapshot.data ?? 0;
                                  return Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        spacing: 4,
                                        children: [
                                          Text(
                                            'Cena',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    colors.tertiaryContainer),
                                          ),
                                          Text(
                                            '${padPriceDecimals(getPrice() * (userBalance < (_product?.finpointsPrice ?? 0) ? 1 : (100 - (getDiscount())) / 100))} PLN',
                                            textAlign: TextAlign.center,
                                            style: texts.headlineMedium,
                                          )
                                        ],
                                      ));
                                }),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                flex: 2,
                                child: StreamBuilder<double?>(
                                    stream:
                                        shopController.userBalanceMinusCartCost,
                                    builder: (context, userBalance) {
                                      return MainButton(
                                          label: 'Dodaj do koszyka',
                                          icon: 'assets/svg/cart.svg',
                                          backgroundColor: colors.secondary,
                                          textColor: colors.primary,
                                          onPressed: () {
                                            if (_product == null) {
                                              return;
                                            }
                                            final variantSet = buildVariantsSet(
                                                _product!.variants ?? []);

                                            shopController.addCartItem(ICartItem(
                                                product: _product!,
                                                quantity: 1,
                                                variant: variantSet.findVariant(
                                                        _selectedProductAttributes) ??
                                                    null,
                                                notEligible:
                                                    (userBalance.data ?? 0) <
                                                        _product!
                                                            .finpointsPrice));
                                          });
                                    })),
                          ],
                        ),
                      )
                    ],
                  ),
                  // to drag the modal down
                  Container(
                    height: 100,
                    color: Colors.transparent,
                  ),
                  Positioned(
                      top: 16,
                      left: 16,
                      child: RippleWrapper(
                        onPressed: () {
                          closeModal(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: colors.primaryContainer),
                          child: Center(
                            child: SvgPicture.asset('assets/svg/arrowBack.svg'),
                          ),
                        ),
                      ))
                ],
              ),
      ),
    );
  }
}
