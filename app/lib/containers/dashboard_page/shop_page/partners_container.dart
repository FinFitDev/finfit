import 'package:excerbuys/components/shared/loaders/universal_loader_box.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class PartnersContainer extends StatefulWidget {
  final bool? isLoading;
  const PartnersContainer({super.key, this.isLoading});

  @override
  State<PartnersContainer> createState() => _PartnersContainerState();
}

class _PartnersContainerState extends State<PartnersContainer> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Partners', style: texts.headlineLarge),
              ],
            ),
          ),
          SizedBox(
            height: 133,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildPartnerItemCard(index, colors, widget.isLoading);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget partnerCard(
    int index, ColorScheme colors, String name, void Function() onPressed) {
  return RippleWrapper(
    onPressed: onPressed,
    child: Container(
      width: 90,
      padding: EdgeInsets.symmetric(vertical: HORIZOTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: LinearGradient(
                        colors: [Colors.blue, Colors.pinkAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
              ),
              Positioned(
                left: 2.5,
                top: 2.5,
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: colors.primaryContainer),
                ),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13),
          )
        ],
      ),
    ),
  );
}

Widget partnerCardWithLoaderWrapper(bool? isLoading, Widget partnerCard) {
  return isLoading == true
      ? Container(
          margin: EdgeInsets.symmetric(vertical: HORIZOTAL_PADDING),
          width: 90,
          child: Column(
            children: [
              UniversalLoaderBox(
                height: 70,
                width: 70,
                borderRadius: 100,
              ),
              SizedBox(
                height: 12,
              ),
              UniversalLoaderBox(
                height: 15,
                width: 65,
              )
            ],
          ),
        )
      : partnerCard;
}

Widget _buildPartnerItemCard(int index, ColorScheme colors, bool? isLoading) {
  switch (index) {
    case 0:
      return Row(
        children: [
          SizedBox(
            width: 6,
          ),
          partnerCardWithLoaderWrapper(
              isLoading, partnerCard(0, colors, 'SFD INC', () {})),
        ],
      );
    case 1:
      return partnerCardWithLoaderWrapper(
          isLoading, partnerCard(1, colors, 'Gymrt', () {}));
    case 2:
      return partnerCardWithLoaderWrapper(
          isLoading, partnerCard(2, colors, 'WheyKingdom', () {}));
    case 3:
      return partnerCardWithLoaderWrapper(
          isLoading, partnerCard(3, colors, 'Beam', () {}));
    case 4:
      return partnerCardWithLoaderWrapper(
          isLoading, partnerCard(4, colors, 'KD sp. z.o.o', () {}));
    case 5:
      return Row(
        children: [
          partnerCardWithLoaderWrapper(
              isLoading, partnerCard(5, colors, 'Blog', () {})),
          SizedBox(
            width: 6,
          )
        ],
      );
    default:
      return const SizedBox.shrink();
  }
}
