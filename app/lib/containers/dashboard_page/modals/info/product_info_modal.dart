import 'dart:ui';

import 'package:excerbuys/components/dashboard_page/shop_page/product_info_modal/product_info_header.dart';
import 'package:excerbuys/components/dashboard_page/shop_page/product_info_modal/product_info_header_carousel.dart';
import 'package:excerbuys/components/dashboard_page/shop_page/product_info_modal/product_info_images_list.dart';
import 'package:excerbuys/components/dashboard_page/shop_page/product_info_modal/product_info_variants.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/indicators/carousel/carousel_counter.dart';
import 'package:excerbuys/components/shared/indicators/labels/empty_data_modal.dart';
import 'package:excerbuys/components/shared/indicators/warning_box.dart';
import 'package:excerbuys/components/shared/list/list_component.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
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
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class ProductInfoModal extends StatefulWidget {
  final String productId;

  const ProductInfoModal({super.key, required this.productId});

  @override
  State<ProductInfoModal> createState() => _ProductInfoModalState();
}

class _ProductInfoModalState extends State<ProductInfoModal> {
  bool _error = false;
  IProductEntry? _product;
  IProductVariant? _selectedProductVariant;
  IProductVariantsSet? _variantSet;

  bool isAddToCart = false;

  void triggerSuccess() {
    setState(() {
      isAddToCart = true;
    });
    triggerVibrate(FeedbackType.success);
    // Auto-reset after 2 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          isAddToCart = false;
        });
      }
    });
  }

  void getProductMetadata() {
    final foundProduct = null;
    if (foundProduct == null) {
      setState(() {
        _error = true;
      });
      return;
    }
    setState(() {
      _product = foundProduct;
      _variantSet = buildVariantsSet(_product!.variants ?? []);
    });
  }

  double getPrice() {
    final double? variantPrice = _selectedProductVariant?.price;
    return variantPrice ?? _product?.originalPrice ?? 0;
  }

  double getDiscount() {
    final double? variantDiscount = _selectedProductVariant?.discount;
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
    final l10n = context.l10n;

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
                message: l10n.textProductDataError,
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
                                ProductInfoHeaderCarousel(
                                  items: _selectedProductVariant?.images ??
                                      _product?.initialCarouselImages ??
                                      [],
                                ),
                                ProductInfoHeader(
                                  product: _product,
                                ),
                                (_product?.variantsMainImages.length ?? 0) > 1
                                    ? ProductInfoImagesList(
                                        images: _product!.variantsMainImages,
                                        selectedImage:
                                            _selectedProductVariant?.images?[0],
                                        onImageSelected: (image) {
                                          setState(() {
                                            _selectedProductVariant =
                                                _variantSet
                                                    ?.findVariantByImage(image);
                                          });
                                        },
                                      )
                                    : SizedBox.shrink(),
                                _product?.variants != null &&
                                        _product!.variants!.isNotEmpty
                                    ? ProductInfoVariants(
                                        productVariants: _product!.variants!,
                                        selectedVariant:
                                            _selectedProductVariant,
                                        onVariantSelected: (attributes) {
                                          setState(
                                            () {
                                              _selectedProductVariant =
                                                  _variantSet
                                                      ?.findVariant(attributes);
                                            },
                                          );
                                        },
                                      )
                                    : SizedBox.shrink(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: HORIZOTAL_PADDING),
                                  child: ListComponent(
                                    data: {
                                      l10n.textProductOriginalPrice:
                                          '${padPriceDecimals(getPrice())} PLN',
                                      l10n.textDiscountLabel:
                                          '${padPriceDecimals(getDiscount())} %',
                                      l10n.textProductFinpointsPrice:
                                          _product?.finpointsPrice != null
                                              ? '${formatNumber(_product!.finpointsPrice.round())} ${l10n.labelFinpoints}'
                                              : l10n.textUnknown,
                                      l10n.textProductStockLeft:
                                          (_selectedProductVariant?.inStock ??
                                                  _product?.inStock ??
                                                  0)
                                              .toString(),
                                      l10n.textProductPurchasedCount:
                                          (_product?.totalTransactions ?? 0)
                                              .toString()
                                    },
                                  ),
                                )
                              ]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 16,
                            left: HORIZOTAL_PADDING,
                            right: HORIZOTAL_PADDING),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                            ),
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
                      right: 16,
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
                            child: SvgPicture.asset('assets/svg/close.svg'),
                          ),
                        ),
                      ))
                ],
              ),
      ),
    );
  }
}
