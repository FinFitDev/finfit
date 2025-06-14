import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeInput extends StatefulWidget {
  final void Function(String) setCode;
  final String? error;
  const PinCodeInput({super.key, required this.setCode, this.error});

  @override
  State<PinCodeInput> createState() => _PinCodeInputState();
}

class _PinCodeInputState extends State<PinCodeInput> {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final inputColor = widget.error != null
        ? colors.error.withAlpha(30)
        : colors.tertiaryContainer.withAlpha(30);

    final borderColor =
        widget.error != null ? colors.error : Colors.transparent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PinCodeTextField(
          controller: _pinController,
          length: 6,
          obscureText: false,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(10),
              fieldHeight: 65,
              fieldWidth: 50,
              activeFillColor: inputColor,
              inactiveFillColor: inputColor,
              selectedFillColor: inputColor,
              activeColor: borderColor,
              inactiveColor: borderColor,
              selectedColor: widget.error != null
                  ? colors.error
                  : colors.tertiaryContainer.withAlpha(50),
              errorBorderColor: colors.error),
          animationDuration: Duration(milliseconds: 100),
          backgroundColor: Colors.transparent,
          cursorColor: Colors.transparent,
          textStyle: TextStyle(
              fontSize: 20,
              color:
                  widget.error != null ? colors.error : colors.primaryFixedDim),
          enableActiveFill: true,
          keyboardType: TextInputType.number,
          onChanged: widget.setCode,
          appContext: context,
        ),
        widget.error != null
            ? Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Text(
                  widget.error!,
                  style: TextStyle(color: colors.error, fontSize: 16),
                ),
              )
            : SizedBox.shrink(),
        // MainButton(
        //     label: 'Paste',
        //     height: 45,
        //     backgroundColor: colors.tertiaryContainer.withAlpha(80),
        //     textColor: colors.primaryFixedDim,
        //     onPressed: () async {
        //       final clipboardData = await Clipboard.getData('text/plain');

        //       if (clipboardData != null &&
        //           clipboardData.text != null &&
        //           parseInt(clipboardData.text!.substring(0, 6)) != null) {
        //         _pinController.text = clipboardData.text!.substring(0, 6);
        //       }
        //     })
      ],
    );
  }
}
