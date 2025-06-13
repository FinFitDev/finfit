import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:flutter/material.dart';

class DeliveryGroup extends StatefulWidget {
  final IDeliveryGroup deliveryGroup;
  const DeliveryGroup({super.key, required this.deliveryGroup});

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 2,
              children: [
                Text(
                  widget.deliveryGroup.owner.name,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${widget.deliveryGroup.totalQuantity} products to deliver',
                  style:
                      TextStyle(fontSize: 11, color: colors.tertiaryContainer),
                )
              ],
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
                  .map((method) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colors.primaryContainer),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                                    color: colors.primaryFixedDim)),
                          ],
                        ),
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
                    text: '12 PLN',
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
