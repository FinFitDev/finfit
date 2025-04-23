import 'package:excerbuys/store/controllers/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DropdownOptionsModal extends StatelessWidget {
  final void Function(String) onSelect;
  const DropdownOptionsModal({required this.onSelect, super.key});

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
          child: Container(
              height: 0.4 * MediaQuery.sizeOf(context).height,
              color: colors.primary,
              width: double.infinity,
              padding: EdgeInsets.only(
                  left: HORIZOTAL_PADDING,
                  right: HORIZOTAL_PADDING,
                  bottom: layoutController.bottomPadding + HORIZOTAL_PADDING,
                  top: HORIZOTAL_PADDING),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    optionCard(colors, 'Option 1', (option) {
                      onSelect(option);
                    }, false),
                    optionCard(colors, 'Option 2', (option) {
                      onSelect(option);
                    }, true),
                    optionCard(colors, 'Option 3', (option) {
                      onSelect(option);
                    }, false)
                  ],
                ),
              ))),
    );
  }

  Widget optionCard(ColorScheme colors, String optionName,
      void Function(String) onSelect, bool? isSelected) {
    return RippleWrapper(
      onPressed: () {
        onSelect(optionName);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colors.primaryContainer,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              optionName,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colors.primaryFixedDim),
            ),
            isSelected == true
                ? SvgPicture.asset(
                    'assets/svg/tick.svg',
                    colorFilter: ColorFilter.mode(
                        colors.primaryFixedDim, BlendMode.srcIn),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
