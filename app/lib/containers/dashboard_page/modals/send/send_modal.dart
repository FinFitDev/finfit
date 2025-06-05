import 'package:excerbuys/containers/dashboard_page/modals/send/amount_modal.dart';
import 'package:excerbuys/containers/dashboard_page/modals/send/choose_recipients_modal.dart';
import 'package:excerbuys/store/controllers/dashboard/send_controller/send_controller.dart';
import 'package:excerbuys/wrappers/modal/modal_switcher_wrapper.dart';
import 'package:flutter/material.dart';

class SendModal extends StatefulWidget {
  const SendModal({super.key});

  @override
  State<SendModal> createState() => _SendModalState();
}

class _SendModalState extends State<SendModal> {
  @override
  void dispose() {
    super.dispose();
    sendController.resetUi();
  }

  @override
  Widget build(BuildContext context) {
    return ModalSwitcherWrapper(
      modals: [
        (next, prev) => ModalStep(
              nextPage: next,
              previousPage: prev,
              child: ChooseRecipientsModal(nextPage: next),
            ),
        (next, prev) => ModalStep(
              nextPage: next,
              previousPage: prev,
              child: AmountModal(previousPage: prev),
            ),
      ],
    );
  }
}
