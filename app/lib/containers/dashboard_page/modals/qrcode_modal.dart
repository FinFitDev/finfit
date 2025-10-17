import 'package:excerbuys/components/shared/buttons/copy_text.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

class QrcodeModal extends StatelessWidget {
  const QrcodeModal({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ModalContentWrapper(
      title: 'Receive finpoints',
      onClose: () {
        closeModal(context);
      },
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: colors.secondary.withAlpha(20)),
                  padding: const EdgeInsets.all(70),
                  child: PrettyQrView.data(
                    data: userController.currentUser!.uuid,
                    decoration: PrettyQrDecoration(
                      // 👇 this controls the QR dots color
                      shape: PrettyQrSmoothSymbol(
                        color: colors.secondary, // ← your custom QR color
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Use the scanner option in the send modal on another device to scan this code. You will then need to refresh the app to see the received points.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.primaryFixedDim, fontSize: 13),
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
                    "Share your points with me. This is my ID - ${userController.currentUser?.uuid}");
              })
        ],
      ),
    );
  }
}
