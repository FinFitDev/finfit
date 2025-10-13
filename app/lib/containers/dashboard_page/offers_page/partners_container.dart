import 'package:excerbuys/components/dashboard_page/shop_page/product_owner/partner_card.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class PartnersContainer extends StatefulWidget {
  final bool? isLoading;
  final Map<String, IProductOwnerEntry> owners;
  final void Function(String?) onPressPartner;
  const PartnersContainer(
      {super.key,
      this.isLoading,
      required this.owners,
      required this.onPressPartner});

  @override
  State<PartnersContainer> createState() => _PartnersContainerState();
}

class _PartnersContainerState extends State<PartnersContainer> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Partners', style: texts.headlineLarge),
              ],
            ),
          ),
          SizedBox(
              height: 133,
              child: widget.isLoading == true
                  ? loadingContainer()
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.owners.values.toList().length,
                      itemBuilder: (context, index) {
                        final owner = widget.owners.values.toList()[index];

                        return Padding(
                          padding: EdgeInsets.only(
                              left: index == 0 ? 10 : 0,
                              right: index ==
                                      widget.owners.values.toList().length - 1
                                  ? 10
                                  : 0),
                          child: PartnerCard(
                            onPressed: () {
                              widget.onPressPartner(owner.uuid);
                            },
                            name: owner.name,
                            image: owner.image,
                          ),
                        );
                      })),
        ],
      ),
    );
  }

  Widget loadingContainer() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.only(
                  left: index == 0 ? 10 : 0, right: index == 4 ? 10 : 0),
              child: PartnerCard(
                onPressed: () {},
                name: '',
                isLoading: true,
              ));
        });
  }
}
