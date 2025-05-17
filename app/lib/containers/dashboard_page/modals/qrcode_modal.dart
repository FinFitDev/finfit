import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/components/shared/buttons/copy_text.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

class QrcodeModal extends StatelessWidget {
  const QrcodeModal({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MODAL_BORDER_RADIUS),
          topRight: Radius.circular(MODAL_BORDER_RADIUS)),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.9,
        color: colors.primary,
        width: double.infinity,
        padding: EdgeInsets.only(
            left: HORIZOTAL_PADDING,
            right: HORIZOTAL_PADDING,
            bottom: layoutController.bottomPadding + HORIZOTAL_PADDING),
        child: Column(
          children: [
            ModalHeader(
                title: 'Receive finpoints',
                subtitle: 'Scan code with another device'),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: PrettyQrView.data(
                        data: userController.currentUser!.uuid,
                        // decoration: const PrettyQrDecoration(
                        //   image: PrettyQrDecorationImage(
                        //     image: AssetImage('assets/images/logo.png'),
                        //   ),
                        // ),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Use the scanner option in the send modal on another device to scan this code. You will then need to refresh the app to see the received points.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: colors.primaryFixedDim, fontSize: 13),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            CopyText(textToCopy: userController.currentUser?.uuid ?? ''),
            SizedBox(
              height: 8,
            ),
            MainButton(
                label: 'Share',
                backgroundColor: colors.secondary,
                textColor: colors.primary,
                onPressed: () {
                  Share.share(
                      "My FinFit id is ${userController.currentUser?.uuid}");
                })
          ],
        ),
      ),
    );
  }
}
