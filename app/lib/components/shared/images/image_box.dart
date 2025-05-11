import 'package:excerbuys/wrappers/image_wrapper.dart';
import 'package:flutter/material.dart';

class ImageBox extends StatefulWidget {
  final String? image;
  final bool? isProgress;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? filterColor;
  final bool? border;

  const ImageBox(
      {super.key,
      required this.image,
      this.isProgress = false,
      this.height,
      this.borderRadius,
      this.width,
      this.filterColor,
      this.border});

  @override
  State<ImageBox> createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  DecorationImage? _decorationImage;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant ImageBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      _isImageLoaded = false;
      _loadImage();
    }
  }

  void _loadImage() async {
    final image = await ImageHelper.getDecorationImage(widget.image);
    if (mounted) {
      setState(() {
        _decorationImage = image;
        _isImageLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
      child: ColorFiltered(
          colorFilter: ColorFilter.mode(
              widget.filterColor ??
                  (widget.isProgress == true
                      ? Colors.grey
                      : Colors.transparent),
              BlendMode.saturation),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: widget.height ?? 140,
                maxWidth: widget.width ?? 2000),
            child: Container(
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
              ),
              child: AnimatedOpacity(
                opacity: _isImageLoaded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 10),
                    border: widget.border == true
                        ? Border.all(width: 1, color: colors.tertiaryContainer)
                        : null,
                    image: _decorationImage,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
