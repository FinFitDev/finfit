import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';

class DeliveryMethodDescription extends StatelessWidget {
  final String title;
  final String description;
  const DeliveryMethodDescription(
      {super.key, required this.description, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MODAL_BORDER_RADIUS),
          topRight: Radius.circular(MODAL_BORDER_RADIUS)),
      child: Container(
        padding: EdgeInsets.only(bottom: layoutController.bottomPadding),
        color: colors.primary,
        child: Wrap(
          children: [
            ModalHeader(
              title: title,
              subtitle: 'Opis metody dostawy',
              onClose: () {
                closeModal(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: HORIZOTAL_PADDING, vertical: 16),
              child: Text(
                description,
                style: TextStyle(color: colors.primaryFixedDim, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
