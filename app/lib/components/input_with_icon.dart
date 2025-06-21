import 'package:excerbuys/components/shared/activity_icon.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/utils/constants.dart';
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
  final String? outsideLabel;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;

  InputWithIcon({
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
    this.onTap,
    this.outsideLabel,
    this.inputFormatters,
    this.controller,
  });

  @override
  State<InputWithIcon> createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  late TextEditingController _controller;
  String _value = '';
  bool _obscureText = true;
  bool _isFirstRun = false;
  final FocusNode? focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!.text = widget.initialValue ?? '';
    }

    _controller = widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');

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

    focusNode?.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant InputWithIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = widget.initialValue ?? '';
        widget.onChange(_controller.text);
      });
    }
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

    final Color iconsColor =
        _value.isEmpty ? colors.tertiaryContainer : colors.tertiary;

    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: widget.outsideLabel != null ? 26 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  focusNode: focusNode,
                  controller: _controller,
                  keyboardType: widget.inputType,
                  inputFormatters: widget.inputType == TextInputType.number
                      ? <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          ...widget.inputFormatters ?? <TextInputFormatter>[]
                        ]
                      : widget.inputFormatters ?? <TextInputFormatter>[],
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
                  style: texts.headlineMedium
                      ?.copyWith(color: colors.tertiary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText:
                        widget.outsideLabel != null ? null : widget.placeholder,
                    hintStyle: TextStyle(
                        color: colors.tertiaryContainer,
                        fontWeight: FontWeight.w300,
                        fontSize: 14),
                    prefixIcon: widget.leftIcon != null
                        ? GestureDetector(
                            onTap: () {},
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: SvgPicture.asset(
                                  widget.leftIcon!,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                      iconsColor, BlendMode.srcIn),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SvgPicture.asset(
                                _obscureText
                                    ? 'assets/svg/eye.svg'
                                    : 'assets/svg/eye-close.svg',
                                height: 22,
                                colorFilter: ColorFilter.mode(
                                    iconsColor, BlendMode.srcIn),
                              ),
                            ),
                          )
                        : widget.rightIcon != null
                            ? RippleWrapper(
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  widget.onPressRightIcon != null
                                      ? widget.onPressRightIcon!()
                                      : null;
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: HORIZOTAL_PADDING),
                                  child: SvgPicture.asset(
                                    widget.rightIcon!,
                                    height: 22,
                                    colorFilter: ColorFilter.mode(
                                        iconsColor, BlendMode.srcIn),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: widget.verticalPadding ?? 18, horizontal: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(widget.borderRadius ?? 20),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(widget.borderRadius ?? 20),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 1),
                    ),
                    filled: true,
                    fillColor: colors.primaryContainer,
                  ),
                ),
                isError
                    ? Container(
                        margin: EdgeInsets.only(top: 8),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            IconContainer(
                              icon: 'assets/svg/exclamation.svg',
                              size: 16,
                              ratio: 0.7,
                              backgroundColor: colors.error,
                            ),
                            Text(
                              widget.error!,
                              style:
                                  TextStyle(color: colors.error, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
          widget.outsideLabel != null
              ? AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  left: 20,
                  top:
                      focusNode?.hasFocus == true || _controller.text.isNotEmpty
                          ? 0
                          : 0,
                  child: GestureDetector(
                    onTap: () {
                      focusNode?.requestFocus();
                    },
                    child: Text(
                      widget.placeholder,
                      style: TextStyle(
                        color: _controller.text.isNotEmpty
                            ? colors.tertiary
                            : colors.tertiaryContainer,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
