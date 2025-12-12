import 'package:excerbuys/containers/dashboard_page/modals/dropdown_options_modal.dart';
import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/wrappers/modal/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class DropdownTrigger<T> extends StatefulWidget {
  final void Function(int) onSelect;
  final List<T> options;
  final ValueNotifier<int> activeOptionIndex; // 👈 changed type
  final Widget Function(T element, {void Function()? onPressed}) renderChild;
  final Widget Function(T element, void Function()) optionDisplay;

  const DropdownTrigger({
    super.key,
    required this.onSelect,
    required this.options,
    required this.renderChild,
    required this.activeOptionIndex,
    required this.optionDisplay,
  });

  @override
  State<DropdownTrigger<T>> createState() => _DropdownTriggerState<T>();
}

class _DropdownTriggerState<T> extends State<DropdownTrigger<T>> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.activeOptionIndex,
      builder: (context, activeIndex, _) {
        return RippleWrapper(
          onPressed: () async {
            openModal(
              context,
              DropdownOptionsModal<T>(
                onSelect: widget.onSelect,
                activeOptionIndex: widget.activeOptionIndex,
                options: widget.options,
                optionDisplay: widget.optionDisplay,
              ),
              isFullHeight: false,
            );
          },
          child: widget.renderChild(widget.options[activeIndex], onPressed: () {
            openModal(
              context,
              DropdownOptionsModal<T>(
                onSelect: widget.onSelect,
                activeOptionIndex: widget.activeOptionIndex,
                options: widget.options,
                optionDisplay: widget.optionDisplay,
              ),
              isFullHeight: false,
            );
          }),
        );
      },
    );
  }
}
