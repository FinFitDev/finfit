import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/components/shared/buttons/copy_text.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

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
            left: HORIZOTAL_PADDING,
            right: HORIZOTAL_PADDING,
            bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
        child: Wrap(
          children: [
            ModalHeader(
                title: 'Receive finpoints',
                subtitle: 'Scan code with another device'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: QrImageView(
                data: userController.currentUser!.id,
                version: QrVersions.auto,
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.circle,
                  color: colors.primaryFixed,
                ),
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: colors.primaryFixed,
                ),
              ),
            ),
            Container(
              height: 32,
            ),
            CopyText(textToCopy: userController.currentUser?.id ?? ''),
            Container(
              height: 8,
            ),
            MainButton(
                label: 'Share',
                backgroundColor: colors.secondary,
                textColor: colors.primary,
                onPressed: () {
                  Share.share(
                      "My FinFit id is ${userController.currentUser?.id}");
                })
          ],
        ),
      ),
    );
  }
}
