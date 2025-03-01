import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodeModal extends StatelessWidget {
  const QrcodeModal({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      child: Container(
        color: colors.primary,
        width: double.infinity,
        padding: EdgeInsets.only(
            left: 2 * HORIZOTAL_PADDING,
            right: 2 * HORIZOTAL_PADDING,
            bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
        child: Wrap(
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            ModalHeader(
                title: 'Receive finpoints',
                subtitle: 'Scan code with another device'),
            QrImageView(
              data: userController.currentUser!.id,
              version: QrVersions.auto,
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: colors.primaryFixed,
              ),
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: colors.primaryFixed,
              ),
            ),
            Text(
              userController.currentUser!.id,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: colors.primaryFixedDim),
            ),
          ],
        ),
      ),
    );
  }
}
