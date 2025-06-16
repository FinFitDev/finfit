import 'package:excerbuys/containers/dashboard_page/modals/checkout/cart_modal.dart';
import 'package:excerbuys/containers/dashboard_page/modals/checkout/delivery/delivery_methods_modal.dart';
import 'package:excerbuys/containers/dashboard_page/modals/checkout/delivery/inpost_outofthebox_select_modal.dart';
import 'package:excerbuys/wrappers/modal/modal_switcher_wrapper.dart';
import 'package:flutter/material.dart';

class CheckoutModalContainer extends StatefulWidget {
  const CheckoutModalContainer({super.key});

  @override
  State<CheckoutModalContainer> createState() => _CheckoutModalContainerState();
}

class _CheckoutModalContainerState extends State<CheckoutModalContainer> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalSwitcherWrapper(
      modals: [
        (next, prev, customPage) => ModalStep(
              nextPage: next,
              previousPage: prev,
              customPage: customPage,
              child: CartModal(nextPage: next),
            ),
        (next, prev, customPage) => ModalStep(
              nextPage: next,
              previousPage: prev,
              customPage: customPage,
              child: DeliveryMethodsModal(
                previousPage: prev,
                customPage: customPage,
              ),
            ),
        (next, prev, customPage) => ModalStep(
              nextPage: next,
              previousPage: prev,
              customPage: customPage,
              child: InpostOutoftheboxSelectModal(
                prevPage: () => customPage(1),
                nextPage: () => customPage(4),
              ),
            ),
      ],
    );
  }
}
