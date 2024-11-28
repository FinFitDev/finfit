import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputWithIcon extends StatefulWidget {
  final String leftIcon;
  final void Function(String) onChange;
  final String placeholder;
  final String? error;
  final bool? isPassword;
  final bool? disabled;

  const InputWithIcon(
      {super.key,
      required this.leftIcon,
      required this.placeholder,
      required this.onChange,
      this.error,
      this.isPassword,
      this.disabled});

  @override
  State<InputWithIcon> createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  String _value = '';
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool isError = widget.error != null && widget.error!.isNotEmpty;
    final bool isPassword = widget.isPassword ?? false;

    final Color iconsColor = isError
        ? colors.error
        : _value.isEmpty
            ? colors.tertiaryContainer
            : colors.tertiary;

    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
              // enabled: !(widget.disabled ?? false),
              obscureText: isPassword && _obscureText,
              enableSuggestions: !isPassword,
              onChanged: (String val) {
                widget.onChange(val);
                setState(() {
                  _value = val;
                });
              },

              // Text styles
              cursorColor: iconsColor,
              style: TextStyle(
                fontSize: 16,
                color: isError ? colors.error : colors.tertiary,
                fontWeight: FontWeight.w400,
              ),

              // decorations
              decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle: TextStyle(
                      color: colors.tertiaryContainer,
                      fontWeight: FontWeight.w400),
                  prefixIcon: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SvgPicture.asset(
                        widget.leftIcon,
                        height: 20,
                        colorFilter:
                            ColorFilter.mode(iconsColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  suffixIcon: isPassword && _value.isNotEmpty
                      ? RippleWrapper(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SvgPicture.asset(
                              _obscureText
                                  ? 'assets/svg/eye.svg'
                                  : 'assets/svg/eye-close.svg',
                              height: 22,
                              colorFilter:
                                  ColorFilter.mode(iconsColor, BlendMode.srcIn),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),

                  // decoration styles
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: isError ? colors.error : Colors.transparent,
                        width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: isError ? colors.error : Colors.transparent,
                        width: 1),
                  ),
                  filled: true,
                  fillColor: colors.primaryContainer)),
          isError
              ? Container(
                  margin: EdgeInsets.only(top: 8, left: 20),
                  child: Text(
                    widget.error!,
                    style: TextStyle(color: colors.error, fontSize: 13),
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
