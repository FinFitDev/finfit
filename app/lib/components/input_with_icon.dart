import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputWithIcon extends StatefulWidget {
  final String? leftIcon;
  final String? rightIcon;
  final void Function()? onPressRightIcon;
  final void Function(String) onChange;
  final void Function()? onTap;
  final String placeholder;
  final String? error;
  final bool? isPassword;
  final bool? disabled;
  final double? verticalPadding;
  final double? borderRadius;
  TextInputType? inputType = TextInputType.text;
  final String? initialValue;
  final FocusNode? focusNode;

  InputWithIcon(
      {super.key,
      this.leftIcon,
      required this.placeholder,
      required this.onChange,
      this.error,
      this.isPassword,
      this.disabled,
      this.rightIcon,
      this.onPressRightIcon,
      this.borderRadius,
      this.verticalPadding,
      this.inputType,
      this.initialValue,
      this.onTap,
      this.focusNode});

  @override
  State<InputWithIcon> createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  late TextEditingController _controller;
  String _value = '';
  bool _obscureText = true;
  bool _isFirstRun = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initialValue ?? '');

    _controller.addListener(() {
      if (!_isFirstRun) {
        setState(() {
          _isFirstRun = true;
        });
        return;
      }
      widget.onChange(_controller.text);
      setState(() {
        _value = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme texts = Theme.of(context).textTheme;

    final bool isError = widget.error != null && widget.error!.isNotEmpty;
    final bool isPassword = widget.isPassword ?? false;

    final Color iconsColor = isError
        ? colors.error
        : _value.isEmpty
            ? colors.tertiaryContainer
            : colors.tertiary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            focusNode: widget.focusNode,
            controller: _controller, // Assign the controller here
            keyboardType: widget.inputType,
            inputFormatters: widget.inputType == TextInputType.number
                ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                : null,
            obscureText: isPassword && _obscureText,
            enableSuggestions: !isPassword,
            onChanged: (String val) {
              widget.onChange(val);
              setState(() {
                _value = val;
              });
            },
            onTap: widget.onTap,

            cursorColor: iconsColor,
            style: texts.headlineMedium?.copyWith(
              color: isError ? colors.error : colors.tertiary,
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                  color: colors.tertiaryContainer, fontWeight: FontWeight.w400),
              prefixIcon: widget.leftIcon != null
                  ? GestureDetector(
                      onTap: () {},
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SvgPicture.asset(
                            widget.leftIcon!,
                            height: 20,
                            colorFilter:
                                ColorFilter.mode(iconsColor, BlendMode.srcIn),
                          )))
                  : null,
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
                  : widget.rightIcon != null
                      ? RippleWrapper(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            widget.onPressRightIcon != null
                                ? widget.onPressRightIcon!()
                                : null;
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SvgPicture.asset(
                              widget.rightIcon!,
                              height: 22,
                              colorFilter:
                                  ColorFilter.mode(iconsColor, BlendMode.srcIn),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
              contentPadding: EdgeInsets.symmetric(
                  vertical: widget.verticalPadding ?? 18, horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
                borderSide: BorderSide(
                    color: isError ? colors.error : Colors.transparent,
                    width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
                borderSide: BorderSide(
                    color: isError ? colors.error : Colors.transparent,
                    width: 1),
              ),
              filled: true,
              fillColor: colors.primaryContainer,
            ),
          ),
          isError
              ? Container(
                  margin: EdgeInsets.only(top: 8, left: 8),
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
