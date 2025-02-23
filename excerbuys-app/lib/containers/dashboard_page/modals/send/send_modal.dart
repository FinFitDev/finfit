import 'package:excerbuys/containers/dashboard_page/modals/send/choose_recipients_modal.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class SendModal extends StatefulWidget {
  const SendModal({super.key});

  @override
  State<SendModal> createState() => _SendModalState();
}

class _SendModalState extends State<SendModal> {
  final PageController _pageController = PageController();

  void nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: PageView(
        controller: _pageController,
        children: [
          ChooseRecipientsModal(
            nextPage: nextPage,
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              child: Center(
                  child: RippleWrapper(
                      onPressed: previousPage, child: Text("Page 2")))),
        ],
      ),
    );
  }
}
