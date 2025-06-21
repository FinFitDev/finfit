import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/components/shared/indicators/sliders/text_overflow_slider.dart';
import 'package:excerbuys/containers/dashboard_page/modals/checkout/delivery/delivery_method_description.dart';
import 'package:excerbuys/types/shop/shop.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class DeliveryGroup extends StatefulWidget {
  final IDeliveryGroup deliveryGroup;
  final void Function(String) onClickDeliveryMethod;
  const DeliveryGroup(
      {super.key,
      required this.deliveryGroup,
      required this.onClickDeliveryMethod});

  @override
  State<DeliveryGroup> createState() => _DeliveryGroupState();
}

class _DeliveryGroupState extends State<DeliveryGroup> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          spacing: 16,
          children: [
            SizedBox(
              height: 50,
              width: (widget.deliveryGroup.images.length - 1) * 20 + 50,
              child: Stack(
                children: widget.deliveryGroup.images
                    .asMap()
                    .entries
                    .map((entry) => Positioned(
                          left: entry.key * 20.0,
                          width: 50,
                          height: 50,
                          child: ImageComponent(
                            size: 50,
                            image: entry.value,
                          ),
                        ))
                    .toList(),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 2,
                children: [
                  Text(
                    widget.deliveryGroup.owner.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${widget.deliveryGroup.totalQuantity} products to deliver',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11, color: colors.tertiaryContainer),
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Column(
              spacing: 4,
              children: (widget.deliveryGroup.deliveryMethods ?? [])
                  .map((method) => Row(
                        children: [
                          Expanded(
                            child: RippleWrapper(
                              onPressed: () {
                                if (method.isAvailable == false) return;
                                widget.onClickDeliveryMethod(method.uuid);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: colors.primaryContainer),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                child: Row(
                                  spacing: 16,
                                  children: [
                                    Opacity(
                                      opacity: method.isAvailable == false
                                          ? 0.2
                                          : 1.0,
                                      child: Row(
                                        spacing: 16,
                                        children: [
                                          ImageComponent(
                                            size: 28,
                                            image: method.image,
                                          ),
                                          Text(method.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                  color:
                                                      colors.primaryFixedDim)),
                                        ],
                                      ),
                                    ),
                                    method.isAvailable == false
                                        ? Expanded(
                                            child: TextOverflowSlider(
                                              text:
                                                  'Unavailable for ${method.unavailableFor!.join(', ')}',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      colors.tertiaryContainer),
                                              pauseDuration:
                                                  Duration(seconds: 2),
                                            ),
                                          )
                                        : method.uuid == SHOP_DELIVERY_DB_UUID
                                            ? Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 4),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color:
                                                              colors.secondary),
                                                      child: Text(
                                                        '0 PLN',
                                                        style: TextStyle(
                                                            color:
                                                                colors.primary,
                                                            fontSize: 11),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          method.description != null
                              ? Container(
                                  margin: EdgeInsets.only(left: 16),
                                  child: RippleWrapper(
                                      child: IconContainer(
                                          backgroundColor:
                                              colors.primaryContainer,
                                          iconColor: colors.tertiaryContainer,
                                          ratio: 0.7,
                                          icon: 'assets/svg/info.svg',
                                          size: 20),
                                      onPressed: () {
                                        openModal(
                                            context,
                                            DeliveryMethodDescription(
                                                title: method.name,
                                                description:
                                                    method.description!));
                                      }),
                                )
                              : SizedBox.shrink(),
                        ],
                      ))
                  .toList()),
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Cena dostawy: ',
                    style:
                        TextStyle(fontSize: 13, color: colors.primaryFixedDim)),
                TextSpan(
                    text: '----',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: colors.tertiary)),
              ]))
            ],
          ),
        ),
        SizedBox(
          height: 32,
        ),
      ],
    );
  }
}
