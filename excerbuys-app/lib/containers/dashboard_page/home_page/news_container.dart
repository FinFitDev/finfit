import 'package:excerbuys/components/loaders/universal_loader_box.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class NewsContainer extends StatefulWidget {
  final bool? isLoading;
  const NewsContainer({super.key, this.isLoading});

  @override
  State<NewsContainer> createState() => _NewsContainerState();
}

class _NewsContainerState extends State<NewsContainer> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Good day', style: texts.headlineLarge),
              ],
            ),
          ),
          SizedBox(
            height: 133,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildNewsItemCard(index, colors, widget.isLoading);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget newsCard(
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

Widget newsCardWithLoaderWrapper(bool? isLoading, Widget newsCard) {
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
      : newsCard;
}

Widget _buildNewsItemCard(int index, ColorScheme colors, bool? isLoading) {
  switch (index) {
    case 0:
      return Row(
        children: [
          SizedBox(
            width: 6,
          ),
          newsCardWithLoaderWrapper(
              isLoading, newsCard(0, colors, 'Updates', () {})),
        ],
      );
    case 1:
      return newsCardWithLoaderWrapper(
          isLoading, newsCard(1, colors, 'Collabs', () {}));
    case 2:
      return newsCardWithLoaderWrapper(
          isLoading, newsCard(2, colors, 'Arrivals', () {}));
    case 3:
      return newsCardWithLoaderWrapper(
          isLoading, newsCard(3, colors, 'Blog', () {}));
    case 4:
      return newsCardWithLoaderWrapper(
          isLoading, newsCard(4, colors, 'Updates', () {}));
    case 5:
      return Row(
        children: [
          newsCardWithLoaderWrapper(
              isLoading, newsCard(5, colors, 'Blog', () {})),
          SizedBox(
            width: 6,
          )
        ],
      );
    default:
      return const SizedBox.shrink();
  }
}
