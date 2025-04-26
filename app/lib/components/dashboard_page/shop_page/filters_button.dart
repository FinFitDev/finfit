import 'package:excerbuys/containers/dashboard_page/modals/shop_filters_modal.dart';
import 'package:excerbuys/store/controllers/shop_controller.dart';
import 'package:excerbuys/wrappers/modal_wrapper.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FiltersButton extends StatelessWidget {
  const FiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return RippleWrapper(
      onPressed: () {
        openModal(context, ShopFiltersModal());
      },
      child: StreamBuilder<int>(
          stream: shopController.numberOfActiveFiltersStream,
          builder: (context, snapshot) {
            final noOfFilters = (snapshot.data ?? 0);
            return Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/filters.svg',
                  colorFilter: ColorFilter.mode(
                      noOfFilters > 0
                          ? colors.secondary
                          : colors.primaryFixedDim,
                      BlendMode.srcIn),
                ),
                noOfFilters > 0
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '${noOfFilters} filter${noOfFilters > 1 ? 's' : ''} active',
                          style:
                              TextStyle(color: colors.secondary, fontSize: 13),
                        ),
                      )
                    : SizedBox.shrink()
              ],
            );
          }),
    );
  }
}
