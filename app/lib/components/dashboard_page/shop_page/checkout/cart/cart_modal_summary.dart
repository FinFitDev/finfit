import 'package:excerbuys/components/shared/indicators/warning_box.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:flutter/material.dart';

class CartModalSummary extends StatelessWidget {
  const CartModalSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colors.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Finpoints price',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: colors.tertiaryContainer,
                      fontSize: 12)),
              StreamBuilder<int>(
                  stream: shopController.totalCartFinpointsCostStream,
                  builder: (context, snapshot) {
                    return Text(
                        snapshot.data != null
                            ? ' ${snapshot.data!.toStringAsFixed(0)} finpoints'
                            : ' 0 finpoints',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colors.secondary,
                            fontSize: 12));
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Discounts',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: colors.tertiaryContainer,
                      fontSize: 12)),
              StreamBuilder<double>(
                  stream: shopController.totalCartDiscountValueSaved,
                  builder: (context, snapshot) {
                    return Text('-${padPriceDecimals(snapshot.data ?? 0)} PLN',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colors.secondary,
                            fontSize: 12));
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
