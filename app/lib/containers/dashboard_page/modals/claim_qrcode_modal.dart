import 'package:excerbuys/components/shared/buttons/copy_text.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/store/controllers/user_controller/user_controller.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:excerbuys/utils/extensions/context_extensions.dart';

class ClaimQrcodeModal extends StatelessWidget {
  final String code;
  const ClaimQrcodeModal({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return ModalContentWrapper(
      title: l10n.textUseDiscountTitle,
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
                    data: code,
                    decoration: PrettyQrDecoration(
                      // 👇 this controls the QR dots color
                      shape: PrettyQrSmoothSymbol(
                        color: colors.secondary, // ← your custom QR color
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                CopyText(textToCopy: code),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          MainButton(
              label: l10n.actionClose,
              backgroundColor: colors.tertiaryContainer.withAlpha(40),
              textColor: colors.primaryFixedDim,
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
