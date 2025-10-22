import 'package:excerbuys/components/shared/images/image_box.dart';
import 'package:excerbuys/components/shared/list/list_component.dart';
import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/product_owners_controller/product_owners_controller.dart';

import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

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
      padding: EdgeInsets.only(
        top: MAIN_HEADER_HEIGHT - 78 + layoutController.statusBarHeight,
      ),
      child: StreamBuilder<ContentWithLoading<Map<String, IProductOwnerEntry>>>(
          stream: productOwnersController.allProductOwnersStream,
          builder: (context, snapshot) {
            final owner = snapshot.data?.content[productOwnerId];
            if (owner == null) {
              return UniversalLoaderBox(
                height: 200,
              );
            }
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                                parseDateYear(DateTime.parse(owner.createdAt)),
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
                  top: 180,
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
                              RippleWrapper(
                                onPressed: () {
                                  if (owner.link == null ||
                                      owner.link!.isEmpty) {
                                    return;
                                  }
                                  launchURL(owner.link!);
                                },
                                child: Text(
                                  owner.link ?? '',
                                  style: TextStyle(color: colors.secondary),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
