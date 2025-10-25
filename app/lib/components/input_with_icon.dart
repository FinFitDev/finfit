import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputWithIcon extends StatefulWidget {
  final String? leftIcon;
  final String? rightIcon;
  final void Function()? onPressRightIcon;
  final void Function(String) onChange;
  final String placeholder;
  final String? error;
  final bool? isPassword;
  final bool? disabled;
  final double? verticalPadding;
  final double? borderRadius;
  final TextInputType? inputType;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final String? outsideLabel;
  final void Function()? onTap;

  const InputWithIcon({
    super.key,
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
    this.inputFormatters,
    this.outsideLabel,
    this.onTap,
  });

  @override
  State<InputWithIcon> createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  late TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    final bool isError = widget.error != null && widget.error!.isNotEmpty;
    final bool isPassword = widget.isPassword ?? false;

    final String value = _controller.text;
    final Color iconsColor = isError
        ? colors.error
        : value.isEmpty
            ? colors.tertiaryContainer
            : colors.tertiary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            spreadRadius: -5,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.outsideLabel != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 4),
              child: Text(
                widget.outsideLabel!,
                style: texts.bodySmall?.copyWith(
                  color: colors.tertiaryContainer,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          TextField(
            controller: _controller,
            keyboardType: widget.inputType ?? TextInputType.text,
            inputFormatters: widget.inputFormatters ??
                (widget.inputType == TextInputType.number
                    ? <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]
                    : []),
            obscureText: isPassword && _obscureText,
            enableSuggestions: !isPassword,
            enabled: !(widget.disabled ?? false),
            onChanged: widget.onChange,
            onTap: widget.onTap,
            cursorColor: iconsColor,
            style: texts.headlineMedium
                ?.copyWith(color: colors.tertiary, fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.outsideLabel != null ? null : widget.placeholder,
              hintStyle: TextStyle(
                color: colors.tertiaryContainer,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
              prefixIcon: widget.leftIcon != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SvgPicture.asset(
                        widget.leftIcon!,
                        height: 20,
                        colorFilter:
                            ColorFilter.mode(iconsColor, BlendMode.srcIn),
                      ),
                    )
                  : null,
              suffixIcon: isPassword && value.isNotEmpty
                  ? RippleWrapper(
                      onPressed: () {
                        setState(() => _obscureText = !_obscureText);
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
                            widget.onPressRightIcon?.call();
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
                      : null,
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.verticalPadding ?? 18,
                horizontal: 20,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
                borderSide: BorderSide(
                    color: isError
                        ? colors.error
                        : colors.primaryFixedDim.withAlpha(50),
                    width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
                borderSide: BorderSide(
                    color: isError
                        ? colors.error
                        : colors.primaryFixedDim.withAlpha(50),
                    width: 1),
              ),
              filled: true,
              fillColor: colors.primaryContainer,
            ),
          ),
          if (isError)
            Container(
              margin: const EdgeInsets.only(top: 8, left: 8),
              child: Text(
                widget.error!,
                style: TextStyle(color: colors.error, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
