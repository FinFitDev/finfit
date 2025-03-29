import 'dart:io';

import 'package:excerbuys/components/modal/modal_header.dart';
import 'package:excerbuys/store/controllers/dashboard/send_controller.dart';
import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrscannerModal extends StatefulWidget {
  const QrscannerModal({super.key});

  @override
  State<QrscannerModal> createState() => _QrscannerModalState();
}

class _QrscannerModalState extends State<QrscannerModal> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MODAL_BORDER_RADIUS),
          topRight: Radius.circular(MODAL_BORDER_RADIUS)),
      child: Container(
        color: colors.primary,
        height: MediaQuery.sizeOf(context).height * 0.9,
        width: double.infinity,
        child: Column(
          children: [
            ModalHeader(
              title: 'Send finpoints',
              subtitle: 'Scan QR code',
              goBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: (QRViewController controller) {
                    this.controller = controller;
                    controller.scannedDataStream.listen((scanData) {
                      if (scanData.code != result) {
                        if (scanData.code != null) {
                          sendController.fetchQrCodeUser(scanData.code!);
                        }
                        triggerVibrate(FeedbackType.success);
                        setState(() {
                          result = scanData.code;
                        });

                        if (mounted) {
                          Future.delayed(const Duration(milliseconds: 500),
                              () => Navigator.pop(context));
                        }
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
