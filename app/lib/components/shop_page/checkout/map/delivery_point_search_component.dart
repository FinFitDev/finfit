import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DeliveryPointSearchComponent<T> extends StatefulWidget {
  final void Function()? centerLocation;
  final T points;

  const DeliveryPointSearchComponent(
      {super.key, this.centerLocation, required this.points});

  @override
  State<DeliveryPointSearchComponent> createState() =>
      _DeliveryPointSearchComponentState();
}

class _DeliveryPointSearchComponentState
    extends State<DeliveryPointSearchComponent> {
  bool _isOpen = false;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() {
      _isOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Positioned(
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: _isOpen ? colors.primary : null,
              padding: EdgeInsets.all(HORIZOTAL_PADDING),
              child: Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: InputWithIcon(
                          placeholder: 'Wyszukaj paczkomat',
                          focusNode: _focusNode,
                          onChange: (val) {},
                          rightIcon:
                              _isOpen ? null : 'assets/svg/locate_me.svg',
                          borderRadius: 10,
                          verticalPadding: 12,
                          onTap: _openSearch,
                          onPressRightIcon: widget.centerLocation,
                        ),
                      ),
                      _isOpen
                          ? RippleWrapper(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: Text(
                                    'Anuluj',
                                    style: TextStyle(
                                        color: colors.tertiaryContainer),
                                  )),
                              onPressed: () {
                                setState(() {
                                  _isOpen = false;
                                });
                                FocusScope.of(context).unfocus();
                              })
                          : SizedBox.shrink()
                    ],
                  ),
                  ListView.builder(
                      itemBuilder: (context, index) {
                        final point = widget.points[index];
                        return ListTile(
                          title: Text('${point.name} ${point.description}'),
                          subtitle: Text(
                              '${point.address.street} ${point.address.houseNumber}, ${point.address.postCode} ${point.address.city}'),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _isOpen = false;
                            });
                          },
                        );
                      },
                      itemCount: _isOpen ? 5 : 0,
                      shrinkWrap: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
