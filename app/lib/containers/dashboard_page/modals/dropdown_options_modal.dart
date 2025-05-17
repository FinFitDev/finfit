import 'package:excerbuys/components/shared/positions/position.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class DropdownOptionsModal extends StatelessWidget {
  final void Function(int) onSelect;
  final List<String> options;
  final int activeOptionIndex;
  const DropdownOptionsModal(
      {required this.onSelect,
      super.key,
      required this.options,
      required this.activeOptionIndex});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Adjust with keyboard
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
                    bottom: layoutController.bottomPadding + HORIZOTAL_PADDING,
                    top: HORIZOTAL_PADDING),
                child: SingleChildScrollView(
                  child: Wrap(
                      children: List.generate(options.length, (index) {
                    final el = options[index];
                    return Position(
                        onPress: () {
                          onSelect(index);
                        },
                        optionName: el,
                        isSelected: index == activeOptionIndex);
                  }).toList()),
                )),
          )),
    );
  }
}
