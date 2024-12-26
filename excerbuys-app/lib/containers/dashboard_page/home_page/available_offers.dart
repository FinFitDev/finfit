import 'package:excerbuys/components/dashboard_page/home_page/shop_item_card.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class AvailableOffers extends StatefulWidget {
  const AvailableOffers({super.key});

  @override
  State<AvailableOffers> createState() => _AvailableOffersState();
}

class _AvailableOffersState extends State<AvailableOffers> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available now',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.tertiary),
                ),
                RippleWrapper(
                  onPressed: () {},
                  child: Text(
                    'View in shop',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: colors.tertiaryContainer),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ShopItemCard(
                    image:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNZsKSKtF2IU5UnPd2lZrBqHI2_LWgiR7Org&s',
                    points: 250000,
                    originalPrice: 58,
                    name: 'Chocolate protein',
                    seller: 'Producer AC',
                    discount: 12,
                  ),
                  ShopItemCard(
                      image:
                          'https://rmggym.pl/layout/images/kluby/Bydgoszcz01.png',
                      originalPrice: 65,
                      discount: 15,
                      points: 185000,
                      name: 'Gym membership',
                      seller: 'Just Gym'),
                  ShopItemCard(
                    image:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQE4Dxz-qvNcRTxdZWLFGzkoi5VF0hYXihscQ&s',
                    originalPrice: 22,
                    discount: 15,
                    points: 185000,
                    name: 'Gym membership 1 month',
                    seller: 'Platinum',
                    isLast: true,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
