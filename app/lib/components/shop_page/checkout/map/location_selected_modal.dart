import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/image_component.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/types/delivery.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:flutter/material.dart';

class LocationSelectedModal extends StatefulWidget {
  final IInpostOutOfTheBoxPoint? selectedPoint;
  final void Function() onClickCancel;

  const LocationSelectedModal({
    super.key,
    this.selectedPoint,
    required this.onClickCancel,
  });

  @override
  State<LocationSelectedModal> createState() => _LocationSelectedModalState();
}

class _LocationSelectedModalState extends State<LocationSelectedModal> {
  @override
  Widget build(BuildContext context) {
    final texts = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 250),
      curve: Curves.decelerate,
      left: 16,
      right: 16,
      bottom:
          widget.selectedPoint != null ? layoutController.bottomPadding : -300,
      child: Opacity(
        opacity: widget.selectedPoint != null ? 1 : 0,
        child: Container(
          height: 194,
          padding: EdgeInsets.all(HORIZOTAL_PADDING),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colors.primary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageComponent(
                    size: 80,
                    image: widget.selectedPoint?.image,
                    borderRadius: 10,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.selectedPoint?.name ?? 'Wybierz paczkomat'} ${widget.selectedPoint?.description ?? ''}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: texts.headlineMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${widget.selectedPoint?.address.street ?? ''} ${widget.selectedPoint?.address.houseNumber ?? ''}, ${widget.selectedPoint?.address.postCode ?? ''} ${widget.selectedPoint?.address.city ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: colors.tertiaryContainer,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: MainButton(
                      label: 'Anuluj',
                      backgroundColor: colors.tertiaryContainer.withAlpha(80),
                      textColor: colors.primaryFixedDim,
                      height: 50,
                      onPressed: widget.onClickCancel,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: MainButton(
                      label: 'Wybierz',
                      backgroundColor: colors.secondary,
                      textColor: colors.primary,
                      height: 50,
                      onPressed: () {},
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
