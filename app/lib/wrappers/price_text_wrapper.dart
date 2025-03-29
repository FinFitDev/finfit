import 'package:flutter/material.dart';

class PriceTextWrapper extends StatefulWidget {
  final double price;
  final double fontSize;
  final Color color;
  final String? currencySymbol;

  const PriceTextWrapper(
      {super.key,
      required this.price,
      required this.fontSize,
      required this.color,
      this.currencySymbol});

  @override
  State<PriceTextWrapper> createState() => _PriceTextWrapperState();
}

class _PriceTextWrapperState extends State<PriceTextWrapper> {
  String _mainPart = '0';
  String _decimals = '00';

  void splitPrice(double price) {
    final List<String> parts = price.toString().split('.');
    setState(() {
      _mainPart = parts[0];
      _decimals = parts[1].padRight(2, '0');
    });
  }

  @override
  void didUpdateWidget(covariant PriceTextWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    splitPrice(widget.price);
  }

  @override
  void initState() {
    super.initState();
    splitPrice(widget.price);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _mainPart,
          style: TextStyle(fontSize: widget.fontSize, color: widget.color),
        ),
        SizedBox(
          width: 3 * widget.fontSize / 20,
        ),
        Container(
          margin: EdgeInsets.only(top: 2 * widget.fontSize / 20),
          child: Text(
            _decimals,
            style:
                TextStyle(fontSize: widget.fontSize / 1.5, color: widget.color),
          ),
        ),
        SizedBox(
          width: 5 * widget.fontSize / 20,
        ),
        widget.currencySymbol != null
            ? Text(
                widget.currencySymbol!,
                style:
                    TextStyle(fontSize: widget.fontSize, color: widget.color),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
