import 'package:excerbuys/containers/dashboard_page/modals/dropdown_options_modal.dart';
import 'package:excerbuys/store/controllers/shop/shop_controller/shop_controller.dart';
import 'package:excerbuys/wrappers/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DropdownTrigger<T> extends StatefulWidget {
  final void Function(int) onSelect;
  final List<T> options;
  final int activeOptionIndex;
  final double? height;
  final double? fontSize;
  final Color? color;
  const DropdownTrigger(
      {super.key,
      required this.onSelect,
      required this.options,
      this.height,
      this.fontSize,
      required this.activeOptionIndex,
      this.color});

  @override
  State<DropdownTrigger> createState() => _DropdownTriggerState();
}

class _DropdownTriggerState extends State<DropdownTrigger> {
  bool _isActive = false;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return RippleWrapper(
      onPressed: () async {
        setState(() {
          _isActive = true;
        });
        openModal(
            context,
            StreamBuilder<int>(
                stream: shopController.activeShopCategoryStream,
                builder: (context, snapshot) {
                  return DropdownOptionsModal(
                    onSelect: widget.onSelect,
                    activeOptionIndex: widget.activeOptionIndex,
                    options: widget.options,
                  );
                }), onClose: () {
          // runs after modal is closed
          setState(() {
            _isActive = false;
          });
        }, isFullHeight: false);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: widget.height ?? 45,
        decoration: BoxDecoration(
          color: widget.color ?? colors.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<int>(
                stream: shopController.activeShopCategoryStream,
                builder: (context, snapshot) {
                  return Text(
                    widget.options[snapshot.data ?? 0],
                    style: TextStyle(
                        fontSize: widget.fontSize ?? 14,
                        fontWeight: FontWeight.w500,
                        color: colors.primaryFixedDim),
                  );
                }),
            Transform.rotate(
              angle: (_isActive ? 180 : 0) * 3.14 / 180,
              child: SvgPicture.asset(
                'assets/svg/dropdown_arrow_down.svg',
                colorFilter:
                    ColorFilter.mode(colors.primaryFixedDim, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
