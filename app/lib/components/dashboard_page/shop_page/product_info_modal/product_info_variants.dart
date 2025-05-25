import 'package:excerbuys/components/shared/options_slider.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/types/shop.dart';
import 'package:excerbuys/utils/shop/product/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductInfoVariants extends StatefulWidget {
  final List<IProductVariant> productVariants;
  final Function(Map<String, String>) onVariantSelected;

  const ProductInfoVariants(
      {super.key,
      required this.productVariants,
      required this.onVariantSelected});

  @override
  State<ProductInfoVariants> createState() => _ProductInfoVariantsState();
}

class _ProductInfoVariantsState extends State<ProductInfoVariants> {
  Map<String, String> _selectedAttributes = {};
  IProductVariantsSet? _variantSet;
  Map<String, List<String>> _optionsMap = {};
  Map<String, List<String>> _unavailableOptions = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final variantSet = buildVariantsSet(widget.productVariants);

      final formattedOptionsMap = Map.fromEntries(variantSet.options.entries
          .map((el) => MapEntry(capitalizeWord(el.key), el.value)));

      final initialSelectedAttributes = Map.fromEntries(variantSet
          .options.entries
          .map((el) => MapEntry(capitalizeWord(el.key), el.value.first)));

      final unavailable = variantSet.getUnavailableAttributes(
          lowercaseKeys<String>(initialSelectedAttributes));

      setState(() {
        _variantSet = variantSet;
        _optionsMap = formattedOptionsMap;
        _selectedAttributes = initialSelectedAttributes;
        _unavailableOptions = unavailable;
      });

      widget
          .onVariantSelected(lowercaseKeys<String>(initialSelectedAttributes));
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _optionsMap.entries.map((el) {
          final String title = el.key;
          final List<String> options = el.value;
          return OptionsSlider(
              optionsList: options,
              title: title,
              selectedOption: _selectedAttributes[title] ?? '',
              onOptionSelected: (p0) {
                setState(() {
                  _selectedAttributes = {
                    ..._selectedAttributes,
                    title: p0,
                  };

                  if (_variantSet != null) {
                    _unavailableOptions = _variantSet!.getUnavailableAttributes(
                        Map.fromEntries(_selectedAttributes.entries.map(
                            (el) => MapEntry(el.key.toLowerCase(), el.value))));
                  }
                });

                widget.onVariantSelected(
                    lowercaseKeys<String>(_selectedAttributes));
              },
              unavailableOptions:
                  _unavailableOptions[title.toLowerCase()] ?? []);
        }).toList());
  }
}
