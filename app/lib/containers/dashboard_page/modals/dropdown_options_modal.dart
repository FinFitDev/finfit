import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class DropdownOptionsModal<T> extends StatefulWidget {
  final void Function(int) onSelect;
  final List<T> options;
  final ValueNotifier<int> activeOptionIndex;
  final Widget Function(T element, void Function() onSelect) optionDisplay;

  const DropdownOptionsModal(
      {required this.onSelect,
      super.key,
      required this.options,
      required this.activeOptionIndex,
      required this.optionDisplay});

  @override
  State<DropdownOptionsModal<T>> createState() =>
      _DropdownOptionsModalState<T>();
}

class _DropdownOptionsModalState<T> extends State<DropdownOptionsModal<T>> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ValueListenableBuilder<int>(
        valueListenable: widget.activeOptionIndex,
        builder: (context, activeIndex, _) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // Adjust with keyboard
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(MODAL_BORDER_RADIUS),
                    topRight: Radius.circular(MODAL_BORDER_RADIUS)),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: Container(
                      color: colors.primary,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: HORIZOTAL_PADDING,
                          right: HORIZOTAL_PADDING,
                          bottom: layoutController.bottomPadding +
                              HORIZOTAL_PADDING,
                          top: HORIZOTAL_PADDING),
                      child: SingleChildScrollView(
                        child: Wrap(
                            children:
                                List.generate(widget.options.length, (index) {
                          final el = widget.options[index];
                          return widget.optionDisplay(
                              el, () => widget.onSelect(index));
                        }).toList()),
                      )),
                )),
          );
        });
  }
}
