import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/list/list_component.dart';
import 'package:excerbuys/store/controllers/shop/product_owners_controller/product_owners_controller.dart';
import 'package:excerbuys/store/controllers/shop/products_controller/products_controller.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductOwnerHeaderContainer extends StatelessWidget {
  final String? productOwnerId;
  final void Function() onBackPressed;
  const ProductOwnerHeaderContainer(
      {super.key, this.productOwnerId, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.primary,
      child: StreamBuilder<ContentWithLoading<Map<String, IProductOwnerEntry>>>(
          stream: productOwnersController.allProductOwnersStream,
          builder: (context, snapshot) {
            final owner = snapshot.data?.content[productOwnerId];
            if (owner == null) {
              return Container(
                height: 200,
                color: colors.primary,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      color: colors.primary,
                      child: ImageBox(
                        image: owner.bannerImage ?? owner.image,
                        height: 200,
                        borderRadius: 0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(HORIZOTAL_PADDING, 100,
                          HORIZOTAL_PADDING, HORIZOTAL_PADDING),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Text(
                            owner.description,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: colors.tertiaryContainer),
                          ),
                          ListComponent(data: {
                            'Partner since':
                                parseDate(DateTime.parse(owner.createdAt)),
                            'Total purchases':
                                owner.totalTransactions.toString(),
                            'Total products': owner.totalProducts.toString(),
                          })
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 210,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: HORIZOTAL_PADDING),
                    child: Row(
                      children: [
                        ImageBox(
                          image: owner.image,
                          height: 100,
                          width: 100,
                          borderRadius: 100,
                          border: true,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width - 148,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            spacing: 4,
                            children: [
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                owner.name,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              Text(
                                owner.link ?? '',
                                style: TextStyle(color: colors.secondary),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 52,
                    left: 16,
                    child: Row(
                      children: [
                        RippleWrapper(
                          onPressed: onBackPressed,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: colors.primary,
                                  border: Border.all(
                                      width: 0.5,
                                      color: colors.tertiaryContainer)),
                              child: Row(
                                spacing: 4,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/arrowBack.svg',
                                    colorFilter: ColorFilter.mode(
                                        colors.tertiaryContainer,
                                        BlendMode.srcIn),
                                  ),
                                  Text(
                                    'Go back',
                                    style: TextStyle(
                                        color: colors.tertiaryContainer,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )),
                        )
                      ],
                    ))
              ],
            );
          }),
    );
  }
}
