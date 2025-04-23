import 'package:excerbuys/containers/dashboard_page/modals/dropdown_options_modal.dart';
import 'package:excerbuys/wrappers/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DropdownTrigger extends StatefulWidget {
  const DropdownTrigger({super.key});

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
        await openModal(context, DropdownOptionsModal(
          onSelect: (option) {
            print(option);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ));
        // runs after modal is closed
        setState(() {
          _isActive = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 45,
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Memberships',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.primaryFixedDim),
            ),
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
