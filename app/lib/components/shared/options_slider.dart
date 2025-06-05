import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class OptionsSlider extends StatelessWidget {
  final List<String> optionsList;
  final String title;
  final String selectedOption;
  final Function(String) onOptionSelected;
  final List<String> unavailableOptions;
  const OptionsSlider(
      {super.key,
      required this.optionsList,
      required this.title,
      required this.selectedOption,
      required this.onOptionSelected,
      required this.unavailableOptions});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: HORIZOTAL_PADDING, right: HORIZOTAL_PADDING, bottom: 8),
          child: Text(
            title,
            style: TextStyle(color: colors.primaryFixedDim),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 16),
          height: 40,
          child: ListView.builder(
            itemBuilder: (_, index) {
              final bool isSelected = selectedOption == optionsList[index];

              return RippleWrapper(
                  onPressed: () {
                    // if (!unavailableOptions.contains(optionsList[index])) {
                    onOptionSelected(
                      optionsList[index],
                    );
                    // }
                  },
                  child: Opacity(
                      opacity:
                          // unavailableOptions.contains(optionsList[index])
                          //     ? 0.2
                          //     :
                          1,
                      child: Container(
                        margin: EdgeInsets.only(
                            right: index == optionsList.length - 1 ? 0 : 12),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.secondary.withAlpha(30)
                              : colors.primaryContainer,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              optionsList[index],
                              style: TextStyle(
                                color: isSelected
                                    ? colors.secondary
                                    : colors.primaryFixedDim,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )));
            },
            itemCount: optionsList.length,
            padding: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
